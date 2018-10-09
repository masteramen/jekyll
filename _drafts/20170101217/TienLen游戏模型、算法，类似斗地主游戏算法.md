---
layout: post
title:  "TienLen游戏模型、算法，类似斗地主游戏算法"
title2:  "TienLen游戏模型、算法，类似斗地主游戏算法"
date:   2017-01-01 23:55:17  +0800
source:  "https://www.jfox.info/tienlen%e6%b8%b8%e6%88%8f%e6%a8%a1%e5%9e%8b%e7%ae%97%e6%b3%95%e7%b1%bb%e4%bc%bc%e6%96%97%e5%9c%b0%e4%b8%bb%e6%b8%b8%e6%88%8f%e7%ae%97%e6%b3%95.html"
fileName:  "20170101217"
lang:  "zh_CN"
published: true
permalink: "2017/tienlen%e6%b8%b8%e6%88%8f%e6%a8%a1%e5%9e%8b%e7%ae%97%e6%b3%95%e7%b1%bb%e4%bc%bc%e6%96%97%e5%9c%b0%e4%b8%bb%e6%b8%b8%e6%88%8f%e7%ae%97%e6%b3%95.html"
---
{% raw %}
最近需要做一个类似于斗地主的游戏——柬埔寨TienLen游戏，规则方面和斗地主相差不大，算法方面，也是大同小异，所以趁着这个机会，将这部分算法进行整理，文章中包含了牌模型的构建、初始化牌、洗牌、发牌、牌类型判断、出牌校验、提示等算法，AI算法暂时没有整理：

### 1.定义牌对象

首先需要对牌对象进行定义，正常斗地主玩法下，一张牌只有一个属性，就是数字大小，而不管花色，而在我们的游戏中，同样数字的牌，不同花色之间还可以比较，因此，我们的牌一共有两个基本属性，分别为花色和大小。

#### 1.1 规则

对于花色，规则定义如下：黑桃>梅花>方片>红桃

对于数字，规则定义如下：2最大，3最小

#### 1.2 建模

我们将牌的牌面实际数字使用数字进行标记，使用数字3到15表示真实牌的3到2，其中11表示J，12表示Q，13表示K，14表示A，15表示2，其余数字分别代表真实牌面数字。

将牌的牌面花色同样使用数字进行标记：根据从大到小，分别标记为：4——黑桃，3——梅花，2——方片，1——红桃。

这样，对于一张牌的数字模型，使用以下公式进行标记：

牌数字模型大小 = 牌面数字模型大小 * 10 + 牌面花色模型大小

    // 牌号点数：如3~J~A~2,使用3~15数字
    private int cardNumber;
    
    // 牌色：如4红桃, 3方片, 2梅花, 1黑桃
    private int cardColor;
    
    // 牌全称：例34是红桃3,152是梅花2,113是方片J
    private String cardName;
    
    // 牌描述：例红桃3,梅花2
    private String cardDesc;
    

#### 1.3 总结

经过上边的标记，我们很容易将一张牌的模型进行数字化，例如：

154——黑桃2

151——红桃2

83——梅花8

这样154>151，同样黑桃2大于红桃2

151>83，同样红桃2大于梅花8

### 2. 构建一副牌

构建一副牌可以从花色、牌面大小、牌的名称、牌的描述四个方面进行构建，其中花色（4——黑桃，3——梅花，2——方片，1——红桃），大小为：使用数字3到15表示真实牌的3到2，牌名称即牌大小和花色组成的数字大小，描述是通用的牌的叫法，比如：154——黑桃2 牌名称为154 描述为 黑桃2

这里需要主要的是：**斗地主中存在王，大小王，共54张牌，而在我们的TienLen游戏中不存在大小王，只有52张牌**

     /**
     * 初始化牌
     * @return
     */
    public List<CardInfo> initCard() {
        List<CardInfo> cardList = new ArrayList<CardInfo>();
        for (int i = 1; i < 5; i++) {
            for (int j = 3; j < 16; j++) {
                CardInfo cardInfo = new CardInfo();
                cardInfo.setCardNumber(j);
                cardInfo.setCardColor(i);
                cardInfo.setCardName(j * 10 + i + "");
                switch (i) {
                    case 1:
                        cardInfo.setCardDesc("红桃" + j);
                        break;
                    case 2:
                        cardInfo.setCardDesc("方片" + j);
                        break;
                    case 3:
                        cardInfo.setCardDesc("梅花" + j);
                        break;
                    case 4:
                        cardInfo.setCardDesc("黑桃" + j);
                        break;
                }
                cardList.add(cardInfo);
            }
        }
        return cardList;
    }
    

### 3. 洗牌

洗牌只需要将牌进行打乱即可，这里考虑使用随机数进行交换，模拟洗牌，但是这样的算法存在缺陷，即有可能洗完以后，牌仍然保持原样

    /**
     * 洗牌
     *
     * @param cardList 初始化号的牌
     * @return
     */
    public List<CardInfo> washCard(List<CardInfo> cardList) {
        List<CardInfo> randomCardList = cardList;
        for (int i = 0; i < 100; i++) {
            Random random = new Random();
            // 找出52以内的随机数，然后交换位置
            int a = random.nextInt(52);
            int b = random.nextInt(52);
            CardInfo cardInfoTemp = randomCardList.get(a);
            randomCardList.set(a, randomCardList.get(b));
            randomCardList.set(b, cardInfoTemp);
        }
    
        return randomCardList;
    }
    

### 4. 发牌

发牌算法很简单，将已经洗好的52张牌，顺序发给各个玩家。这里我们与斗地主区别在于，我们这里一共有四个玩家，因此需要将牌分为4份：

    /**
     * 发牌
     *
     * @param cardList 洗好的牌
     * @return
     */
    public List<CardInfo>[] handCard(List<CardInfo> cardList) {
        List<CardInfo> playerCardList[] = new Vector[4];
        for (int i = 0; i < 4; i++) {
            playerCardList[i] = new Vector<CardInfo>();
        }
        for (int j = 0; j < 52; j++) {
            switch (j % 4) {
                case 0:
                    playerCardList[0].add(cardList.get(j));
                    break;
                case 1:
                    playerCardList[1].add(cardList.get(j));
                    break;
                case 2:
                    playerCardList[2].add(cardList.get(j));
                    break;
                case 3:
                    playerCardList[3].add(cardList.get(j));
                    break;
                default:
                    break;
            }
        }
        return playerCardList;
    }
    

### 5. 捋牌

也就是对牌进行排序，从大到小进行排序，这样出来的牌，便于往后进行分类等运算。

    /**
     * 排序，按照从大到小的顺序进行排
     *
     * @param cardList
     * @return
     */
    public List<CardInfo> sortCard(List<CardInfo> cardList) {
        Collections.sort(cardList, new Comparator<CardInfo>() {
            @Override
            public int compare(CardInfo cardInfo1, CardInfo cardInfo2) {
                int cardNum1 = Integer.valueOf(cardInfo1.getCardName());
                int cardNum2 = Integer.valueOf(cardInfo2.getCardName());
    
                if (cardNum1 > cardNum2) {
                    return -1;
                } else if (cardNum1 == cardNum2) {
                    return 0;
                } else {
                    return 1;
                }
            }
        });
        return cardList;
    }
    

### 6. 出牌

出牌时，应该根据规则进行出牌，首先、判断用户所选择的牌是否符合规则，即是否是单牌、对子、三张、链子、炸弹等

#### 6.1 单张牌

获取单张牌的算法很简单，任意一张牌，都可以作为单张牌使用，因此只需要将所有的牌都添加到单张牌的列表中即可。

     /***
     * 获取单张牌
     *
     * @param mCardList
     * @return
     */
    public List<List<CardInfo>> get1(List<CardInfo> mCardList) {
        List<List<CardInfo>> all1List = new ArrayList<>();
        List<CardInfo> cardList;
        sortCardAsc(mCardList);
        for (int i = 0, length = mCardList.size(); i < length; i++) {
            cardList = new ArrayList<>();
            cardList.add(mCardList.get(i));
            all1List.add(cardList);
        }
    
        return all1List;
    }
    

#### 6.2 对子

获取对子时，需要注意，因为我们TienLen游戏的规则中，不仅需要比较牌面点数大小，还需要比较花色大小，所以，同样4个2，可能组合成多种对子，且大小不一样，比如黑桃2和梅花2，比如红桃2和方片2

     /**
     * 获取对子
     * 这里对i+1 i+2 i+3分别和第i张牌进行对比，
     * 举例：比如四个2，可以黑桃2和方片2一对，也可以是梅花2和红桃2一对
     *
     * @param mCardList
     * @return
     */
    public List<List<CardInfo>> get11(List<CardInfo> mCardList) {
        // 先对牌进行排序
        sortCardAsc(mCardList);
        List<List<CardInfo>> all11CardList = new ArrayList<>();
        List<CardInfo> cardList;
        for (int i = 0, length = mCardList.size(); i < length; i++) {
            if (i + 1 < length
                    && mCardList.get(i).getCardNumber() == mCardList.get(i + 1).getCardNumber()) {
                cardList = new ArrayList<>();
                cardList.add(mCardList.get(i));
                cardList.add(mCardList.get(i + 1));
                all11CardList.add(cardList);
            }
            if (i + 2 < length
                    && mCardList.get(i).getCardNumber() == mCardList.get(i + 2).getCardNumber()) {
                cardList = new ArrayList<>();
                cardList.add(mCardList.get(i));
                cardList.add(mCardList.get(i + 2));
                all11CardList.add(cardList);
            }
            if (i + 3 < length
                    && mCardList.get(i).getCardNumber() == mCardList.get(i + 3).getCardNumber()) {
                cardList = new ArrayList<>();
                cardList.add(mCardList.get(i));
                cardList.add(mCardList.get(i + 3));
                all11CardList.add(cardList);
            }
        }
        return all11CardList;
    }
    

### 6.3 三个

在斗地主的规则中，好像也是三个也可以一起出，但是需要带一个或者一对，我们TienLen游戏中不需要带，也不能带，可以直接出，比如三个三，三个四，这样的牌，获取的算法和上边对子的获取算法一致

     /***
     * 获取三个
     * 算法个获取对子的算法类似
     *
     * @param mCardList
     * @return
     */
    public List<List<CardInfo>> get111(List<CardInfo> mCardList) {
        List<List<CardInfo>> all111List = new ArrayList<>();
        List<CardInfo> cardList;
        // 先对牌进行排序
        sortCardAsc(mCardList);
    
        for (int i = 0, length = mCardList.size(); i < length; i++) {
            if (i + 2 < length
                    && mCardList.get(i).getCardNumber() == mCardList.get(i + 2).getCardNumber()) {
                cardList = new ArrayList<>();
                cardList.add(mCardList.get(i));
                cardList.add(mCardList.get(i + 1));
                cardList.add(mCardList.get(i + 2));
                all111List.add(cardList);
            }
        }
        return all111List;
    }
    

### 6.4 炸弹

炸弹，不论在斗地主中还是我们现在做的TienLen中，都是一样的作用，一样的获取方法，和获取对子，三个的方法一致，这里直接上代码：

    /***
     * 获取炸弹
     *
     * @param mCardList
     * @return
     */
    public List<List<CardInfo>> get1111(List<CardInfo> mCardList) {
        List<List<CardInfo>> all1111List = new ArrayList<>();
        List<CardInfo> cardList;
    
        for (int i = 0, length = mCardList.size(); i < length; i++) {
            if (i + 3 < length
                    && mCardList.get(i).getCardNumber() == mCardList.get(i + 3).getCardNumber()) {
                cardList = new ArrayList<>();
                cardList.add(mCardList.get(i));
                cardList.add(mCardList.get(i + 1));
                cardList.add(mCardList.get(i + 2));
                cardList.add(mCardList.get(i + 3));
                all1111List.add(cardList);
            }
        }
        return all1111List;
    }
    

### 6.5 链子

终于说到了这个牌型——链子，链子在不同的玩法中，可以出不同的长度，在我们的TienLen中最少是三联，这里获取时，先对手牌进行排序，排好序后，进行遍历，找到能和当前牌连接起来的，且牌长度大于3的，均属于链子：

    /**
     * 获取链子
     *
     * @param mCardList
     * @return
     */
    public List<List<CardInfo>> get123(List<CardInfo> mCardList) {
        // 链子长度必须大于3,即最少出3连
        if (mCardList.size() < 3) {
            return null;
        }
        // 构建返回数据
        List<CardInfo> tempCardList = new ArrayList<>();
        List<List<CardInfo>> all123List = new ArrayList<>();
    
        // 先去掉2
        for (int i = 0; i < mCardList.size(); i++) {
            if (mCardList.get(i).getCardNumber() != 15) {
                tempCardList.add(mCardList.get(i));
            }
        }
        // 重新进行排序
        sortCardAsc(tempCardList);
    
        for (int i = 0; i < tempCardList.size(); i++) {
            CardInfo tempCardInfo = tempCardList.get(i);
            List<CardInfo> cardList = new ArrayList<>();
            cardList.add(tempCardInfo);
            List<CardInfo> cardListTempAfter = new ArrayList<>();
            for (int j = i + 1; j < tempCardList.size(); j++) {
                // 判断当前牌是否个下一个牌能连起来（当前牌是5，当下一个是5+1=6时，即连起来了，当连起来大于3个牌时，即可以认为是一连）
                if ((tempCardInfo.getCardNumber() + 1) == tempCardList.get(j).getCardNumber()) {
                    cardListTempAfter.clear();
                    cardListTempAfter.addAll(cardList);
                    cardList.add(tempCardList.get(j));
                    tempCardInfo = tempCardList.get(j);
                    if (cardList.size() >= 3) {
                        List<CardInfo> cardListTemp = new ArrayList<>();
                        cardListTemp.addAll(cardList);
                        all123List.add(cardList);
    
                        cardList = new ArrayList<>();
                        cardList.addAll(cardListTemp);
                    }
                } else if (tempCardInfo.getCardNumber() == tempCardList.get(j).getCardNumber()
                        && tempCardInfo.getCardNumber() != tempCardList.get(i).getCardNumber()) {
                    List<CardInfo> cardListTemp = new ArrayList<>();
                    cardListTemp.addAll(cardListTempAfter);
                    if (cardListTemp.size() > 0
                            && cardListTemp.get(cardListTemp.size() - 1).getCardNumber() != tempCardList
                            .get(j).getCardNumber()) {
                        cardListTempAfter.add(tempCardList.get(j));
                        if (cardListTempAfter.size() >= 3) {
                            all123List.add(cardListTempAfter);
                            cardListTempAfter = new ArrayList<>();
                            cardListTempAfter.addAll(cardListTemp);
                        }
                    }
                }
            }
        }
        return all123List;
    }
    

### 6.6 双链

双链，也就是经常说的飞机带翅膀，双链的前提是对子，只有存在对子的情况下，才能找出来双链，所以，其算法也是一样，先找到所有的对子，然后去掉2，进行排序，再按照找链子的方法进行找，这样返回的就是双链。

     /***
     * 获取飞机
     *
     * @param mCardInfoList
     * @return
     */
    public List<List<CardInfo>> get112233(List<CardInfo> mCardInfoList) {
        int length = mCardInfoList.size();
        // 双链最少为3连，所以最少六张牌
        if (length < 6) {
            return null;
        }
        // 保存所有的对子
        List<CardInfo> tempList = new ArrayList<>();
        // 保存所有不包含2的对子
        List<CardInfo> apairTempList = new ArrayList<>();
        // 防止重复添加
        List<Integer> integerList = new Vector<>();
    
        // 返回结果
        List<List<CardInfo>> all112233List = new ArrayList<>();
    
        // 存储单个双对链子
        List<CardInfo> cardList;
    
        // 先获取所有的对子
        for (int i = 0; i < length; i++) {
            if (i + 1 < length
                    && mCardInfoList.get(i).getCardNumber() == mCardInfoList.get(i + 1)
                    .getCardNumber()) {
                tempList.add(mCardInfoList.get(i));
                tempList.add(mCardInfoList.get(i + 1));
                i = i + 1;
            }
        }
        // 排序
        sortCardAsc(tempList);
    
        // 去除对2和相同的
        for (int i = 0, tempLength = tempList.size(); i < tempLength; i++) {
            if (!integerList.contains(Integer.valueOf(tempList.get(i).getCardNumber()))) {
                apairTempList.add(tempList.get(i));
                integerList.add(Integer.valueOf(tempList.get(i).getCardNumber()));
            }
        }
    
        // 双对的链子最少三联
        if (apairTempList.size() < 3) {
            return null;
        }
    
        // 对之前拿到的对子List进行排序，正序
        sortCardAsc(tempList);
    
        // 到这里已经拿到了所有对子中的某一个单牌，只需拿出所有的链子
        List<List<CardInfo>> get123TempList = get123(apairTempList);
    
        for (int j = 0; j < get123TempList.size(); j++) {
            List<CardInfo> list123 = get123TempList.get(j);
            sortCardAsc(list123);
            for (int k = 0; k < tempList.size(); k++) {
                if (tempList.get(k).getCardName().equals(list123.get(0).getCardName())) {
                    cardList = new ArrayList<>();
                    for (int l = k; l < list123.size() * 2 + k; l++) {
                        cardList.add(tempList.get(l));
                    }
                    all112233List.add(cardList);
                }
            }
        }
        return all112233List;
    }
    

### 7 出牌

出牌有两种情况，一种是手动选择的，一种是通过提示，自动出牌的。对于手动选择的，需要根据自己当前是否有首先出牌权，进行校验，

1. 如果当前是自己的局，也就是说，上轮出牌的过程中，自己最大，这局自己首先出，所以只需要校验自己手动选择的牌是否符合规则。
2. 如果当前是别人的局，也就是说，自己当前跟着别人的局出牌，只能和别人的类型一致，且大于对方，所以需要校验选择的牌类型是否和别人的一致，再校验是否比别人的大，才能出

对于通过提示出牌的，只适合第二种情况，也就是说，别人出牌，然后自己管，系统会进行提示

#### 7.1 判断所选择的牌，是否符合已经定义的出牌类型，对应上边所述的第一种情况，只要符合规则均可以出

     /**
     * 获取出牌类型
     * 
     * @param outCard
     * @return
     */
    public OutCardType getOutCardType(List<CardInfo> outCard) {
        if (outCard != null) {
            int cardLength = outCard.size();
    
            if (outCard.get(0).getCardNumber() == outCard.get(cardLength - 1).getCardNumber()) {
                switch (cardLength) {
                    case 1:
                        // 单牌
                        return OutCardType.type1;
                    case 2:
                        // 对子
                        return OutCardType.type11;
                    case 3:
                        // 三个
                        return OutCardType.type111;
                    case 4:
                        // 炸弹
                        return OutCardType.type1111;
                }
            }
    
            // 判断链子，最少三张
            if (outCard.size() >= 3) {
                List<CardInfo> tempCardList = new ArrayList<>();
    
                // 先去掉2
                for (int i = 0; i < outCard.size(); i++) {
                    if (outCard.get(i).getCardNumber() != 15) {
                        tempCardList.add(outCard.get(i));
                    }
                }
                // 重新进行排序
                sortCardAsc(tempCardList);
    
                // 判断是否为链子
                List<List<CardInfo>> get123 = get123(outCard);
                if (get123 != null && get123.size() > 0) {
                    for (List<CardInfo> list : get123) {
                        if (list.size() == outCard.size()) {
                            return OutCardType.type123;
                        }
                    }
    
                }
    
                // 双对至少6张
                if (outCard.size() >= 6) {
                    int length = outCard.size();
                    // 保存所有的对子
                    List<CardInfo> tempList = new ArrayList<>();
                    // 保存所有不包含2的对子
                    List<CardInfo> apairTempList = new ArrayList<>();
                    // 防止重复添加
                    List<Integer> integerList = new Vector<>();
    
                    // 先获取所有的对子
                    for (int i = 0; i < length; i++) {
                        if (i + 1 < length
                                && outCard.get(i).getCardNumber() == outCard.get(i + 1)
                                .getCardNumber()) {
                            tempList.add(outCard.get(i));
                            tempList.add(outCard.get(i + 1));
                            i = i + 1;
                        }
                    }
    
                    // 所有的牌均为对子
                    if (tempList.size() == outCard.size()) {
                        // 去除对2
                        for (int i = 0, tempLength = tempList.size(); i < tempLength; i++) {
                            if (integerList.indexOf(outCard.get(i).getCardNumber()) < 0
                                    && tempList.get(i).getCardNumber() != 15) {
                                apairTempList.add(tempList.get(i));
                                integerList.add(tempList.get(i).getCardNumber());
                            }
                            i = i + 1;
                        }
    
                        // 到这里已经拿到了所有对子中的某一个单牌，只需拿出所有的链子
                        List<List<CardInfo>> get123TempList = get123(apairTempList);
                        for (int i = 0; i < get123TempList.size(); i++) {
                            if (get123TempList.get(i).size() == length / 2) {
                                return OutCardType.type112233;
                            }
                        }
                    }
                }
            }
        }
        return OutCardType.type0;
    }
    

只有当选中牌的类型是已知类型，才能第一步判断出是否可以出牌，下一步则需要根据当前是不是自己轮，判断需要不需要压对方的牌

#### 7.2 判断当前所选择的牌，是否符合规则，而且，是否比上一家出的牌大

    /**
     * 当上家出牌后，判断自己是否可以出牌
     *
     * @param outCard
     * @param mAllCard
     * @param mSelectCard
     * @return
     */
    public boolean whetherCanPlay(List<CardInfo> outCard, List<CardInfo> mAllCard,
                                  List<CardInfo> mSelectCard) {
        boolean isCardCanPlay = false;
    
        // 获取对手牌型
        OutCardType outCardType = getOutCardType(outCard);
        OutCardType outCardTypeMy = getOutCardType(mSelectCard);
        sortCard(outCard);
        // 先对牌进行排序
        sortCard(mSelectCard);
    
        // 首先判断牌的张数是否一样
        if (outCard.size() == mSelectCard.size() && outCardType == outCardTypeMy) {
            int outCardName = Integer.valueOf(outCard.get(0).getCardName());
            int mSelectCardName = Integer.valueOf(mSelectCard.get(0).getCardName());
    
            // 相同，属于同一级牌之间压
            switch (outCardType) {
                case type1:
                    if (mSelectCardName > outCardName) {
                        isCardCanPlay = true;
                    }
                    break;
                case type11:
                    if (mSelectCardName > outCardName) {
                        isCardCanPlay = true;
                    }
                    break;
                case type111:
                    if (mSelectCardName > outCardName) {
                        isCardCanPlay = true;
                    }
                    break;
                case type1111:
                    if (mSelectCardName > outCardName) {
                        isCardCanPlay = true;
                    }
                    break;
                case type123:
                    if (mSelectCardName > outCardName) {
                        isCardCanPlay = true;
                    }
                    break;
                case type112233:
                    if (mSelectCardName > outCardName) {
                        isCardCanPlay = true;
                    }
                    break;
                default:
                    isCardCanPlay = false;
                    break;
            }
        } else {
            // 当张数不一致时，有两种情况，即炸弹压2和连着的双对压对2
            if (outCard.size() == 1 && mSelectCard.size() == 4) {
                // 当别人为单个2且自己的Type为炸弹时
                if (outCard.get(0).getCardNumber() == 15
                        && getOutCardType(mSelectCard) == OutCardType.type1111) {
                    isCardCanPlay = true;
                }
            } else {
                // 别人出牌为一对2，自己应该用33-44-55-66或者55-66-77-88压
                if (outCard.size() == 2 && mSelectCard.size() >= 8) {
                    if (outCard.get(0).getCardNumber() == 15
                            && getOutCardType(mSelectCard) == OutCardType.type112233) {
                        isCardCanPlay = true;
                    }
                } else {
                    isCardCanPlay = false;
                }
            }
        }
        return isCardCanPlay;
    }
    

这里边包含了部分规则，比如同样的牌类型，比较大小，同时33445566可以压对二这样的规则

### 8. 提示

提示算法比较简单，先获取上家出牌的类型，再获取自己手牌中对应类型的列表，逐个进行比较，直到找到合适的

### 9. AI

这里除了上述洗牌、发牌、出牌等算法之外，还有单机模式的AI算法，回头有空了整理下，我再发上来吧。

### 10. 总结

在这片文章中，只是写了一个针对斗地主类类游戏的牌的算法，包含了牌模型构建、洗牌、发牌、出牌等算法的实现，虽然游戏规则不同，但是思路大同小异，希望有需要的同学可以参考下。
{% endraw %}
