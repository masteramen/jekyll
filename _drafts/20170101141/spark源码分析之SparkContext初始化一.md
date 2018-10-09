---
layout: post
title:  "spark源码分析之SparkContext初始化一"
title2:  "spark源码分析之SparkContext初始化一"
date:   2017-01-01 23:54:01  +0800
source:  "https://www.jfox.info/spark%e6%ba%90%e7%a0%81%e5%88%86%e6%9e%90%e4%b9%8bsparkcontext%e5%88%9d%e5%a7%8b%e5%8c%96%e4%b8%80.html"
fileName:  "20170101141"
lang:  "zh_CN"
published: true
permalink: "2017/spark%e6%ba%90%e7%a0%81%e5%88%86%e6%9e%90%e4%b9%8bsparkcontext%e5%88%9d%e5%a7%8b%e5%8c%96%e4%b8%80.html"
---
{% raw %}
这里，我们主要关注最主要的2个地方的初始化，首先是TaskScheduler的创建初始化。 

    // Create and start the scheduler
        val (sched, ts) = SparkContext.createTaskScheduler(this, master)
        _schedulerBackend = sched
        _taskScheduler = ts
        _dagScheduler = new DAGScheduler(this)
        _heartbeatReceiver.ask[Boolean](TaskSchedulerIsSet)

这里我们发现还会初始化SchedulerBackend，这里我们继续看createTaskScheduler方法 

    case SPARK_REGEX(sparkUrl) =>
            val scheduler = new TaskSchedulerImpl(sc)
            val masterUrls = sparkUrl.split(",").map("spark://" + _)
            val backend = new SparkDeploySchedulerBackend(scheduler, sc, masterUrls)
            scheduler.initialize(backend)
            (backend, scheduler)

首先创建TaskSchedulerImpl，里面有2个比较重要的变量 

    // Listener object to pass upcalls into
      var dagScheduler: DAGScheduler = null
      var backend: SchedulerBackend = null

然后看创建SparkDeploySchedulerBackend，最主要的方法在下面，因为会之后的程序会调用这个方法 

    override def start() {
        super.start()
        // The endpoint for executors to talk to us
        val driverUrl = rpcEnv.uriOf(SparkEnv.driverActorSystemName,
          RpcAddress(sc.conf.get("spark.driver.host"), sc.conf.get("spark.driver.port").toInt),
          CoarseGrainedSchedulerBackend.ENDPOINT_NAME)
        val args = Seq(
          "--driver-url", driverUrl,
          "--executor-id", "{{EXECUTOR_ID}}",
          "--hostname", "{{HOSTNAME}}",
          "--cores", "{{CORES}}",
          "--app-id", "{{APP_ID}}",
          "--worker-url", "{{WORKER_URL}}")
        val extraJavaOpts = sc.conf.getOption("spark.executor.extraJavaOptions")
          .map(Utils.splitCommandString).getOrElse(Seq.empty)
        val classPathEntries = sc.conf.getOption("spark.executor.extraClassPath")
          .map(_.split(java.io.File.pathSeparator).toSeq).getOrElse(Nil)
        val libraryPathEntries = sc.conf.getOption("spark.executor.extraLibraryPath")
          .map(_.split(java.io.File.pathSeparator).toSeq).getOrElse(Nil)
        // When testing, expose the parent class path to the child. This is processed by
        // compute-classpath.{cmd,sh} and makes all needed jars available to child processes
        // when the assembly is built with the "*-provided" profiles enabled.
        val testingClassPath =
          if (sys.props.contains("spark.testing")) {
            sys.props("java.class.path").split(java.io.File.pathSeparator).toSeq
          } else {
            Nil
          }
        // Start executors with a few necessary configs for registering with the scheduler
        val sparkJavaOpts = Utils.sparkJavaOpts(conf, SparkConf.isExecutorStartupConf)
        val javaOpts = sparkJavaOpts ++ extraJavaOpts
        val command = Command("org.apache.spark.executor.CoarseGrainedExecutorBackend",
          args, sc.executorEnvs, classPathEntries ++ testingClassPath, libraryPathEntries, javaOpts)
        val appUIAddress = sc.ui.map(_.appUIAddress).getOrElse("")
        val coresPerExecutor = conf.getOption("spark.executor.cores").map(_.toInt)
        val appDesc = new ApplicationDescription(sc.appName, maxCores, sc.executorMemory,
          command, appUIAddress, sc.eventLogDir, sc.eventLogCodec, coresPerExecutor)
        client = new AppClient(sc.env.rpcEnv, masters, appDesc, this, conf)
        client.start()
        waitForRegistration()
      }

首先会调用父类的start方法 

      override def start() {
        val properties = new ArrayBuffer[(String, String)]
        for ((key, value) <- scheduler.sc.conf.getAll) {
          if (key.startsWith("spark.")) {
            properties += ((key, value))
          }
        }
        // TODO (prashant) send conf instead of properties
        driverEndpoint = rpcEnv.setupEndpoint(
          CoarseGrainedSchedulerBackend.ENDPOINT_NAME, new DriverEndpoint(rpcEnv, properties))
      }

主要是创建了driver的代理对象，可以给driver发送消息的对象。回到上面的start方法，主要是 

    client = new AppClient(sc.env.rpcEnv, masters, appDesc, this, conf)
    client.start()

直接找到这个start方法 

    def start() {
        // Just launch an rpcEndpoint; it will call back into the listener.
        endpoint = rpcEnv.setupEndpoint("AppClient", new ClientEndpoint(rpcEnv))
      }

就是创建了一个代理对象，看下这个代理对象 

    private class ClientEndpoint(override val rpcEnv: RpcEnv) extends ThreadSafeRpcEndpoint
        with Logging {
        private var master: Option[RpcEndpointRef] = None
        // To avoid calling listener.disconnected() multiple times
        private var alreadyDisconnected = false
        @volatile private var alreadyDead = false // To avoid calling listener.dead() multiple times
        @volatile private var registerMasterFutures: Array[JFuture[_]] = null
        @volatile private var registrationRetryTimer: JScheduledFuture[_] = null
        // A thread pool for registering with masters. Because registering with a master is a blocking
        // action, this thread pool must be able to create "masterRpcAddresses.size" threads at the same
        // time so that we can register with all masters.
        private val registerMasterThreadPool = ThreadUtils.newDaemonCachedThreadPool(
          "appclient-register-master-threadpool",
          masterRpcAddresses.length // Make sure we can register with all masters at the same time
        )
        // A scheduled executor for scheduling the registration actions
        private val registrationRetryThread =
          ThreadUtils.newDaemonSingleThreadScheduledExecutor("appclient-registration-retry-thread")
        override def onStart(): Unit = {
          try {
            registerWithMaster(1)
          } catch {
            case e: Exception =>
              logWarning("Failed to connect to master", e)
              markDisconnected()
              stop()
          }
        }
        /**
         *  Register with all masters asynchronously and returns an array `Future`s for cancellation.
         */
        private def tryRegisterAllMasters(): Array[JFuture[_]] = {
          for (masterAddress <- masterRpcAddresses) yield {
            registerMasterThreadPool.submit(new Runnable {
              override def run(): Unit = try {
                if (registered) {
                  return
                }
                logInfo("Connecting to master " + masterAddress.toSparkURL + "...")
                val masterRef =
                  rpcEnv.setupEndpointRef(Master.SYSTEM_NAME, masterAddress, Master.ENDPOINT_NAME)
                masterRef.send(RegisterApplication(appDescription, self))
              } catch {
                case ie: InterruptedException => // Cancelled
                case NonFatal(e) => logWarning(s"Failed to connect to master $masterAddress", e)
              }
            })
          }
        }
        /**
         * Register with all masters asynchronously. It will call `registerWithMaster` every
         * REGISTRATION_TIMEOUT_SECONDS seconds until exceeding REGISTRATION_RETRIES times.
         * Once we connect to a master successfully, all scheduling work and Futures will be cancelled.
         *
         * nthRetry means this is the nth attempt to register with master.
         */
        private def registerWithMaster(nthRetry: Int) {
          registerMasterFutures = tryRegisterAllMasters()
          registrationRetryTimer = registrationRetryThread.scheduleAtFixedRate(new Runnable {
            override def run(): Unit = {
              Utils.tryOrExit {
                if (registered) {
                  registerMasterFutures.foreach(_.cancel(true))
                  registerMasterThreadPool.shutdownNow()
                } else if (nthRetry >= REGISTRATION_RETRIES) {
                  markDead("All masters are unresponsive! Giving up.")
                } else {
                  registerMasterFutures.foreach(_.cancel(true))
                  registerWithMaster(nthRetry + 1)
                }
              }
            }
          }, REGISTRATION_TIMEOUT_SECONDS, REGISTRATION_TIMEOUT_SECONDS, TimeUnit.SECONDS)
        }
        /**
         * Send a message to the current master. If we have not yet registered successfully with any
         * master, the message will be dropped.
         */
        private def sendToMaster(message: Any): Unit = {
          master match {
            case Some(masterRef) => masterRef.send(message)
            case None => logWarning(s"Drop $message because has not yet connected to master")
          }
        }
        private def isPossibleMaster(remoteAddress: RpcAddress): Boolean = {
          masterRpcAddresses.contains(remoteAddress)
        }
        override def receive: PartialFunction[Any, Unit] = {
          case RegisteredApplication(appId_, masterRef) =>
            // FIXME How to handle the following cases?
            // 1. A master receives multiple registrations and sends back multiple
            // RegisteredApplications due to an unstable network.
            // 2. Receive multiple RegisteredApplication from different masters because the master is
            // changing.
            appId = appId_
            registered = true
            master = Some(masterRef)
            listener.connected(appId)
          case ApplicationRemoved(message) =>
            markDead("Master removed our application: %s".format(message))
            stop()
          case ExecutorAdded(id: Int, workerId: String, hostPort: String, cores: Int, memory: Int) =>
            val fullId = appId + "/" + id
            logInfo("Executor added: %s on %s (%s) with %d cores".format(fullId, workerId, hostPort,
              cores))
            // FIXME if changing master and `ExecutorAdded` happen at the same time (the order is not
            // guaranteed), `ExecutorStateChanged` may be sent to a dead master.
            sendToMaster(ExecutorStateChanged(appId, id, ExecutorState.RUNNING, None, None))
            listener.executorAdded(fullId, workerId, hostPort, cores, memory)
          case ExecutorUpdated(id, state, message, exitStatus) =>
            val fullId = appId + "/" + id
            val messageText = message.map(s => " (" + s + ")").getOrElse("")
            logInfo("Executor updated: %s is now %s%s".format(fullId, state, messageText))
            if (ExecutorState.isFinished(state)) {
              listener.executorRemoved(fullId, message.getOrElse(""), exitStatus)
            }
          case MasterChanged(masterRef, masterWebUiUrl) =>
            logInfo("Master has changed, new master is at " + masterRef.address.toSparkURL)
            master = Some(masterRef)
            alreadyDisconnected = false
            masterRef.send(MasterChangeAcknowledged(appId))
        }
        override def receiveAndReply(context: RpcCallContext): PartialFunction[Any, Unit] = {
          case StopAppClient =>
            markDead("Application has been stopped.")
            sendToMaster(UnregisterApplication(appId))
            context.reply(true)
            stop()
          case r: RequestExecutors =>
            master match {
              case Some(m) => context.reply(m.askWithRetry[Boolean](r))
              case None =>
                logWarning("Attempted to request executors before registering with Master.")
                context.reply(false)
            }
          case k: KillExecutors =>
            master match {
              case Some(m) => context.reply(m.askWithRetry[Boolean](k))
              case None =>
                logWarning("Attempted to kill executors before registering with Master.")
                context.reply(false)
            }
        }
        override def onDisconnected(address: RpcAddress): Unit = {
          if (master.exists(_.address == address)) {
            logWarning(s"Connection to $address failed; waiting for master to reconnect...")
            markDisconnected()
          }
        }
        override def onNetworkError(cause: Throwable, address: RpcAddress): Unit = {
          if (isPossibleMaster(address)) {
            logWarning(s"Could not connect to $address: $cause")
          }
        }
        /**
         * Notify the listener that we disconnected, if we hadn't already done so before.
         */
        def markDisconnected() {
          if (!alreadyDisconnected) {
            listener.disconnected()
            alreadyDisconnected = true
          }
        }
        def markDead(reason: String) {
          if (!alreadyDead) {
            listener.dead(reason)
            alreadyDead = true
          }
        }
        override def onStop(): Unit = {
          if (registrationRetryTimer != null) {
            registrationRetryTimer.cancel(true)
          }
          registrationRetryThread.shutdownNow()
          registerMasterFutures.foreach(_.cancel(true))
          registerMasterThreadPool.shutdownNow()
        }
      }

因为继承了ThreadSafeRpcEndpoint这个类，也就会依次调用onstart， receive等方法，类似与上一遍博客中akka的生命周期 

    private[spark] trait ThreadSafeRpcEndpoint extends RpcEndpoint
    /**
     * An end point for the RPC that defines what functions to trigger given a message.
     *
     * It is guaranteed that `onStart`, `receive` and `onStop` will be called in sequence.
     *
     * The life-cycle of an endpoint is:
     *
     * constructor -> onStart -> receive* -> onStop
     *
     * Note: `receive` can be called concurrently. If you want `receive` to be thread-safe, please use
     * [[ThreadSafeRpcEndpoint]]
     *
     * If any error is thrown from one of [[RpcEndpoint]] methods except `onError`, `onError` will be
     * invoked with the cause. If `onError` throws an error, [[RpcEnv]] will ignore it.

那么会首先调用 

    override def onStart(): Unit = {
          try {
    
            registerWithMaster(1)
          } catch {
            case e: Exception =>
              logWarning("Failed to connect to master", e)
              markDisconnected()
              stop()
          }
        }

直接看registerWithMaster方法，像master注册我们之前封装好的application 

     /**
         *  Register with all masters asynchronously and returns an array `Future`s for cancellation.
         */
        private def tryRegisterAllMasters(): Array[JFuture[_]] = {
          for (masterAddress <- masterRpcAddresses) yield {
            registerMasterThreadPool.submit(new Runnable {
              override def run(): Unit = try {
                if (registered) {
                  return
                }
                logInfo("Connecting to master " + masterAddress.toSparkURL + "...")
                val masterRef =
                  rpcEnv.setupEndpointRef(Master.SYSTEM_NAME, masterAddress, Master.ENDPOINT_NAME)
                masterRef.send(RegisterApplication(appDescription, self))
              } catch {
                case ie: InterruptedException => // Cancelled
                case NonFatal(e) => logWarning(s"Failed to connect to master $masterAddress", e)
              }
            })
          }
        }

会调用master的代理对象，然后调用send方法，send方法实际就是底层调用akka方法，这里我们可以先看下，找到这个AkkaRpcEnv 这个类，看下面的方法，也就是上面调用的setupEndpointRef方法 

    override def setupEndpoint(name: String, endpoint: RpcEndpoint): RpcEndpointRef = {
        @volatile var endpointRef: AkkaRpcEndpointRef = null
        // Use lazy because the Actor needs to use `endpointRef`.
        // So `actorRef` should be created after assigning `endpointRef`.
        lazy val actorRef = actorSystem.actorOf(Props(new Actor with ActorLogReceive with Logging {
          assert(endpointRef != null)
          override def preStart(): Unit = {
            // Listen for remote client network events
            context.system.eventStream.subscribe(self, classOf[AssociationEvent])
            safelyCall(endpoint) {
              endpoint.onStart()
            }
          }
          override def receiveWithLogging: Receive = {
            case AssociatedEvent(_, remoteAddress, _) =>
              safelyCall(endpoint) {
                endpoint.onConnected(akkaAddressToRpcAddress(remoteAddress))
              }
            case DisassociatedEvent(_, remoteAddress, _) =>
              safelyCall(endpoint) {
                endpoint.onDisconnected(akkaAddressToRpcAddress(remoteAddress))
              }
            case AssociationErrorEvent(cause, localAddress, remoteAddress, inbound, _) =>
              safelyCall(endpoint) {
                endpoint.onNetworkError(cause, akkaAddressToRpcAddress(remoteAddress))
              }
            case e: AssociationEvent =>
              // TODO ignore?
            case m: AkkaMessage =>
              logDebug(s"Received RPC message: $m")
              safelyCall(endpoint) {
                processMessage(endpoint, m, sender)
              }
            case AkkaFailure(e) =>
              safelyCall(endpoint) {
                throw e
              }
            case message: Any => {
              logWarning(s"Unknown message: $message")
            }
          }
          override def postStop(): Unit = {
            unregisterEndpoint(endpoint.self)
            safelyCall(endpoint) {
              endpoint.onStop()
            }
          }
          }), name = name)
        endpointRef = new AkkaRpcEndpointRef(defaultAddress, actorRef, conf, initInConstructor = false)
        registerEndpoint(endpoint, endpointRef)
        // Now actorRef can be created safely
        endpointRef.init()
        endp

注意最后会返回AkkaRpcEndpointRef对象，而这个对象重写了send方法 

     override def send(message: Any): Unit = {
        actorRef ! AkkaMessage(message, false)
      }

也就是akka的方法了，很显然。我们回到最初的sparkcontext 

    // Create and start the scheduler
        val (sched, ts) = SparkContext.createTaskScheduler(this, master)
        _schedulerBackend = sched
        _taskScheduler = ts
        _dagScheduler = new DAGScheduler(this)
        _heartbeatReceiver.ask[Boolean](TaskSchedulerIsSet)
        // start TaskScheduler after taskScheduler sets DAGScheduler reference in DAGScheduler's
        // constructor
        _taskScheduler.start()

其实这个start的方法被调用时，backend才会被启动。才会去master注册application 

这里就分析完了，driver向master注册application。下篇博客会继续往后分析注册完后，对资源进行调度，然后分配executor.
{% endraw %}
