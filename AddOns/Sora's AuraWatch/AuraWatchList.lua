--[[


一些说明：

   Sora's AuraWatch对于Buff列表的管理是分组进行的,每一组Buff公用同一个定位点,同样的大小,同样的样式
   
   在组属性中
   {
		Name = 分组的名称
		Direction = 提示的增长方向 ("RIGHT"/"LEFT"/"UP"/"DOWN")
		Interval = 相邻提示的间距
		Mode = 提示模式(图标ICON 或者 计时条BAR)
		IconSize = 图标大小
		BarWidth = 计时条宽度(BAR模式下必须有这个属性)
		Pos = 首图标的定位点
		List = 要监视的Buff/Debuff/CD列表	
   }
   
   其中List =
   {
		AuraID/ItemID/AuraID = 三选一,分别对应监视 Buff/Debuff,物品CD,技能CD 三种情况
		UnitID = 要监视的目标,常用的有 玩家"player"/目标"target" (如果要监视Buff/Debuff的话必须有)
		Caster = 过滤Buff/Debuff的释放者 (可选,如果不需要按照施法者过滤请不要写这一项 ！！！注意,C为大写！！！ )
		Stack = 过滤Buff/Debuff的层数(可选,当Buff/Debuff层数大于等于Stack的值的时候才显示 ！！！注意,S为大写！！！)
	}

	eg. 这是一个示例
	{
		Name = "Dot",
		Direction = "UP",
		Interval = 4,
		Mode = "BAR",
		IconSize = 16,
		BarWidth = 175,
		Pos = { "LEFT", UIParent, "CENTER", 160, -50 },
		List = {
			-- 血之疫病
			{AuraID = 55078, UnitID = "target", Stack = 1},
			-- 冰霜疫病
			{AuraID = 55095, UnitID = "target", Caster = "player"},
			-- 不灭药水
			{ItemID = 40093},
		},
	},

]]

local _, SR = ...
local cfg = SR.AuraWatchConfig

SRAuraList = {
   -- 全职业
   ["ALL"] = {
      {
         Name = "Buff",
         Direction = "UP", Interval = 2,
         Mode = "ICON", IconSize = 30, 
         Pos = {"LEFT", UIParent, "CENTER", -340, 68},
         List = {
         -->PLAYER
			    	--坚毅
			    	{AuraID = 158300, UnitID = "player"},
			    	--醉拳
			    	{AuraID = 124275, UnitID = "player"},
				    {AuraID = 124274, UnitID = "player"},
				    {AuraID = 124273, UnitID = "player"},
			    	--金钟罩
			    	{AuraID = 115295, UnitID = "player"},
			    	--玄牛雕像
			    	{AuraID = 115315, UnitID = "player"},
			    	--盾牌屏障
			    	{AuraID = 112048, UnitID = "player"},
			    	--圣洁护盾
			    	{AuraID = 20925, UnitID = "player"},
			    	--鲜血护盾
			    	{AuraID = 77535, UnitID = "player"},
			    	-- 潜行(DZ)
            {AuraID = 1784, UnitID = "player"},
            --潜行(XD)
				    {AuraID =   5215, UnitID = "player"},
			    	 -- 咒术护盾(FS)
            {AuraID = 1463, UnitID = "player"},
             -- 咒术洪流(FS)
            {AuraID = 116267, UnitID = "player"},
            -- 寒冰护体(FS)
            {AuraID = 11426, UnitID = "player"},
            -- 圣洁护盾(QS)
            {AuraID = 65148, UnitID = "player"},
            {AuraID = 20925, UnitID = "player"},
            -- 光辉治疗(QS)
            {AuraID = 86273, UnitID = "player"},
            --圣盾术(QS)
				    {AuraID =    642, UnitID = "player"},
				    --石壁图腾(SM)
				    {AuraID = 114893, UnitID = "player"},
				    --牺牲(SS)
				    {AuraID = 7812, UnitID = "player"},
				     -- 暮光结界(SS)
            {AuraID = 6229, UnitID = "player"},
            -- 愤怒结界(SS)
            {AuraID = 119839, UnitID = "player"},
            -- 牺牲契约(SS)
            {AuraID = 108416, UnitID = "player"},
            --黑暗交易(SS)
				    {AuraID = 110913, UnitID = "player"},
				    -- 灵魂榨取(SS)
            {AuraID =108366, UnitID = "player"},
            -- 野魔花(XD)
            {AuraID =28527, UnitID = "player"},
            -- 神圣庇护(MS)
            {AuraID = 47753, UnitID = "player"},
            --灵魂护壳(MS)
			    	{AuraID = 114908, UnitID = "target", Caster = "player"},
			    	-- 天使壁垒(MS)
            {AuraID = 114214, UnitID = "player"},
            --独来独往
						{AuraID = 164273, UnitID = "player"},
            -- 远古王者庇护
            {AuraID = 64413, UnitID = "player"},
            -- 蛋壳
            {AuraID = 91308, UnitID = "player"},
            {AuraID = 91296, UnitID = "player"},
            -- 尼约德的保护符文
            {AuraID = 59616, UnitID = "player"},
            {AuraID = 42740, UnitID = "player"},
            -- 灵魂之盾
            {AuraID = 126920, UnitID = "player"},
            -- 巨神像
            {AuraID = 116631, UnitID = "player"},
            -- 反魔法护罩
            {AuraID = 48707, UnitID = "player"},
            -- 死亡壁垒
            {AuraID =115635, UnitID = "player"},
            -- 作茧缚命
            {AuraID =116849, UnitID = "player"},
            -- 金钟罩
            {AuraID =123402, UnitID = "player"},
            -- 寒霜壁垒
            {AuraID =138668, UnitID = "player"},
            -- 晶化甲壳
            {AuraID =137633, UnitID = "player"},
            -- 寒霜壁垒
            {AuraID =138979, UnitID = "player"},
            -- 灵魂壁障
            {AuraID =138925, UnitID = "player"},
            -- 蛇沫之盾
            {AuraID =140380, UnitID = "player"},
            -- 上古毒瘴
            {AuraID =142861, UnitID = "player"},
            -- 自然之障
            {AuraID =145379, UnitID = "player"},
            
				--痛苦压制
				{AuraID =  33206, UnitID = "player"},
				--盾墙
				{AuraID =    871, UnitID = "player"},
				--冰封之韧
				{AuraID =  48792, UnitID = "player"},
				--保护之手
				{AuraID =   1022, UnitID = "player"},
				--生存本能
				{AuraID =  61336, UnitID = "player"},
				--威慑
				{AuraID = 148467, UnitID = "player"},
				{AuraID =  19263, UnitID = "player"},
				--寒冰屏障
				{AuraID =  45438, UnitID = "player"},
				--强化隐形术
				{AuraID = 113862, UnitID = "player"},
				--剑在人在
				{AuraID = 118038, UnitID = "player"},
				--法术反射
				{AuraID =  23920, UnitID = "player"},
				--升腾
				{AuraID = 114050, UnitID = "player"},	--元素
				{AuraID = 114051, UnitID = "player"},	--增强
				{AuraID = 114052, UnitID = "player"},	--恢复
				--圣佑术
				{AuraID =    498, UnitID = "player"},
				--自由之手
				{AuraID =   1044, UnitID = "player"},
				--复仇之怒
				{AuraID =  31842, UnitID = "player"},	--神圣
				{AuraID =  31884, UnitID = "player"},	--惩戒
				--狂野怒火
				{AuraID =  19574, UnitID = "pet"},
				--急速射击
				{AuraID =   3045, UnitID = "player"},
				--不灭决心
				{AuraID = 104773, UnitID = "player"},
				--闪避
				{AuraID =   5277, UnitID = "player"},
				--壮胆酒
				{AuraID = 120954, UnitID = "player"},
				--躯不坏
				{AuraID = 122278, UnitID = "player"},
				--散魔功
				{AuraID = 122783, UnitID = "player"},
         ---->坦克
			    	--暴击20s
			    	{AuraID = 162917, UnitID = "player"},
			    	--暴击10s
			    	{AuraID = 176982, UnitID = "player"},
			    	--急速10s
			    	{AuraID = 176937, UnitID = "player"},
			    	--使用，生命上限20s
			    	{AuraID = 176460, UnitID = "player"},
			    	--使用，精通20s
			    	{AuraID = 176876, UnitID = "player"},
			    	--精通10s
			    	{AuraID = 165824, UnitID = "player"},
			    	--护甲10s
			    	{AuraID = 177053, UnitID = "player"},
		    		--精通10s
				    {AuraID = 177056, UnitID = "player"},
			    	--递增急速10s
			    	{AuraID = 177102, UnitID = "player"},
		    	---->力量dps
			    	--全能10s
			    	{AuraID = 176974, UnitID = "player"},
			    	--使用，全能15s
			    	{AuraID = 170397, UnitID = "player"},
			    	--精通10s
			    	{AuraID = 176935, UnitID = "player"},
			    	--使用，力量10s
			    	{AuraID = 177189, UnitID = "player"},
			    	--暴击10s
			    	{AuraID = 177040, UnitID = "player"},
			    	--使用，溅射15s
			    	{AuraID = 176874, UnitID = "player"},
			    	--精通10s
			    	{AuraID = 177042, UnitID = "player"},
			    	--递增暴击10s
			    	{AuraID = 177096, UnitID = "player"},
			    ---->敏捷dps
				--暴击20s
				{AuraID = 162915, UnitID = "player"},
			    	--溅射10s
				    {AuraID = 176984, UnitID = "player"},
			    	--精通10s
				    {AuraID = 176939, UnitID = "player"},
				    --使用，敏捷20s
				    {AuraID = 177597, UnitID = "player"},
				    --溅射10s
				    {AuraID = 177038, UnitID = "player"},
				    --急速10s
				    {AuraID = 177035, UnitID = "player"},
				    --使用，溅射20s
				    {AuraID = 176878, UnitID = "player"},
				    --递增暴击10s
				{AuraID = 177067, UnitID = "player", Value = true},
				--PVP饰品
				{AuraID = 126707, UnitID = "player"},
				--使用，精通
				{AuraID = 165485, UnitID = "player"},
			    ---->法系dps
				    --暴击20s
				    {AuraID = 162919, UnitID = "player"},
				    --急速10s
				    {AuraID = 176980, UnitID = "player"},
				    --使用，急速20s
				    {AuraID = 176875, UnitID = "player"},
				    --精通10s
				    {AuraID = 176941, UnitID = "player"},
				    --使用，法强20s
				    {AuraID = 177594, UnitID = "player"},
				    --暴击10s
				    {AuraID = 177046, UnitID = "player"},
				    --急速10s
				    {AuraID = 177051, UnitID = "player"},
				    --递增暴击10s
				    {AuraID = 177081, UnitID = "player"},
			    ---->治疗
				    --精神10s
				    {AuraID = 162913, UnitID = "player"},
				    --精通10s
				    {AuraID = 176943, UnitID = "player"},
				    --使用，法力值20s
				    {AuraID = 177592, UnitID = "player"},
				    --暴击10s
				    {AuraID = 176978, UnitID = "player"},
				    --使用，急速20s
				    {AuraID = 176879, UnitID = "player"},
				    --溅射10s
				    {AuraID = 177063, UnitID = "player"},
				    --精神10s
				    {AuraID = 177060, UnitID = "player"},
				    --递增急速10s
				    {AuraID = 177086, UnitID = "player"},
		------>6.2饰品
			---->敏捷
				--触发敏捷
				{AuraID = 183926, UnitID = "player"},
				--储能爆炸
				{AuraID = 184293, UnitID = "player"},
			---->力量
				--触发力量
				{AuraID = 183941, UnitID = "player"},
				--阿克狂暴战
				{AuraID = 185230, UnitID = "player"},
				--阿克惩戒骑
				{AuraID = 185102, UnitID = "player"},
			---->法系
				--阿克暗牧
				{AuraID = 184915, UnitID = "player"},
				--阿克毁灭
				{AuraID = 185229, UnitID = "player"},
				--触发智力
				{AuraID = 183924, UnitID = "player"},
				--AOE饰品
				{AuraID = 184073, UnitID = "player"},
			---->治疗
				--阿克奶骑
				{AuraID = 185100, UnitID = "player"},
				--阿克戒律牧
				{AuraID = 184912, UnitID = "player"},
				--使用加爆击
				{AuraID = 183929, UnitID = "player"},
				--吸血效果
				{AuraID = 184671, UnitID = "player"},
			---->坦克
				--触发精通
				{AuraID = 183931, UnitID = "player"},
				--触发耐力
				{AuraID = 184770, UnitID = "player"},
 
         -- 职业
            -- 潜伏帷幕
            {AuraID =115834, UnitID = "player"},
            -- 护甲
            {AuraID =138852, UnitID = "player"},
            -- 寒冰结界
            {AuraID =111264, UnitID = "player"},
            -- 平心之环
            {AuraID =116844, UnitID = "player"},
            -- 神圣之火
            {AuraID =114163, UnitID = "player"},
            -- 氤氲之雾
            {AuraID =132120, UnitID = "player"},
            -- 邪恶狂热
            {AuraID = 49016, UnitID = "player"},
            -- 警戒
            {AuraID =114030, UnitID = "player"},
            -- 英勇
            {AuraID = 32182, UnitID = "player"},
            -- 嗜血
            {AuraID = 2825, UnitID = "player"},
            -- 时间扭曲
            {AuraID = 80353, UnitID = "player"},
            -- 远古狂乱
            {AuraID = 90355, UnitID = "player"},
            -- 守护之魂
            {AuraID = 47788, UnitID = "player"},
            -- 愈合祷言
            {AuraID = 41635, UnitID = "player"},
            -- 牺牲之手
            {AuraID = 6940, UnitID = "player"},
            -- 自由之手
            {AuraID = 1044, UnitID = "player"},
            -- 保护之手
            {AuraID = 1022, UnitID = "player"},
            -- 拯救之手
            {AuraID = 1038, UnitID = "player"},
            -- 永恒之火
            {AuraID = 156322, UnitID = "player"},
            -- 反魔法领域
            {AuraID = 50461, UnitID = "player"},
            -- 反魔法领域
            {AuraID = 51052, UnitID = "player"},
            -- 反魔法领域
            {AuraID = 145629, UnitID = "player"},
            -- 颅骨战旗
            {AuraID =114206, UnitID = "player"},
            -- 法力之潮
            {AuraID = 16191, UnitID = "player"},
            -- 治疗之潮
            {AuraID = 108280, UnitID = "player"},
            -- 虔诚光环
            {AuraID = 31821, UnitID = "player"},
            -- 金钟罩
            {AuraID =136707, UnitID = "player"},
            -- 嫁祸诀窍
            {AuraID = 57933, UnitID = "player"},
            -- 风暴之鞭图腾
            {AuraID =120676, UnitID = "player"},
            -- 激活
            {AuraID = 29166, UnitID = "player"},
            -- 宁静
            {AuraID = 740, UnitID = "player"},
            -- 天堂之羽
            {AuraID =121557, UnitID = "player"},
            -- 真言术:壁垒
            {AuraID = 62618, UnitID = "player"},
            -- 身心合一
            {AuraID = 65081, UnitID = "player"},
            -- 集结呐喊
            {AuraID = 97463, UnitID = "player"},
            -- 缓落术
            {AuraID = 130, UnitID = "player"},
            -- 牺牲咆哮
            {AuraID = 53480, UnitID = "player"},
            -- 群体反射
            {AuraID =114028, UnitID = "player"},
            -- 振奮咆哮
            {AuraID =97462, UnitID = "player"},
            -- 振奮咆哮
            {AuraID =97463, UnitID = "player"},
            -- 援护
            {AuraID = 3411, UnitID = "player"},
            -- 大地之盾
            {AuraID = 974, UnitID = "player"},
            -- 圣光道标
            {AuraID = 53563, UnitID = "player"},
            -- 治疗之泉图腾
            {AuraID =119523, UnitID = "player"},
            -- 灵魂链接图腾
            {AuraID = 98007, UnitID = "player"},
            -- 灵魂链接图腾
            {AuraID = 98008, UnitID = "player"},
            -- 血魔之握
            {AuraID = 108199, UnitID = "player"},
            -- 战栗图腾
            {AuraID = 8143, UnitID = "player"},
            -- 风行图腾
            {AuraID = 108273, UnitID = "player"},
            -- 无尽呼吸
            {AuraID = 5697, UnitID = "player"},
            {AuraID =104202, UnitID = "player"},
            -- 狂奔怒吼
            {AuraID = 77761, UnitID = "player"},
            {AuraID = 77764, UnitID = "player"},
            {AuraID = 106898, UnitID = "player"},
            -- 捍卫
            {AuraID =114029, UnitID = "player"},
            {AuraID = 46947, UnitID = "player"},
            -- 治疗宠物
            {AuraID = 136, UnitID = "pet"},
            -- 急奔
            {AuraID = 61684, UnitID = "pet"},
            -- 控制亡灵
            {AuraID =111673, UnitID = "pet"},
            -- 蜷缩
            {AuraID = 91838, UnitID = "pet"},
            -- 腐臭壁垒
            {AuraID = 91837, UnitID = "pet"},
            -- 黑暗突变
            {AuraID = 63560, UnitID = "pet"},
            -- 追杀
            {AuraID = 30151, UnitID = "pet"},
            -- 生命通道
            {AuraID =104220, UnitID = "pet"},
            -- 愤怒风暴
            {AuraID =115831, UnitID = "pet"},
            -- 暗影壁垒
            {AuraID = 17767, UnitID = "pet"},
            -- 次级隐形术
            {AuraID = 7870, UnitID = "pet"},
            -- 奴役恶魔
            {AuraID = 1098, UnitID = "pet"},
         -- 战场
            -- 狂暴
            {AuraID = 23505, UnitID = "player"},
            {AuraID = 24378, UnitID = "player"},
            -- 巨魔天赋：狂暴
            {AuraID = 26297, UnitID = "player"},
            --血性狂怒（兽人种族天赋）
				    {AuraID =  20572, UnitID = "player"},
				    {AuraID =  33697, UnitID = "player"},
            -- 加速
            {AuraID = 23451, UnitID = "player"},
            {AuraID = 23978, UnitID = "player"},
            -- 恢复
            {AuraID = 23493, UnitID = "player"},
            {AuraID = 24379, UnitID = "player"},
         -- MOP日常
            -- 速度之王
            {AuraID =127376, UnitID = "player"},
            -- 清醒
            {AuraID =129050, UnitID = "player"},
            -- 信息素追踪
            {AuraID =124519, UnitID = "player"},
            -- 利刃翻滚
            {AuraID =124532, UnitID = "player"},
            -- 战歌
            {AuraID =123223, UnitID = "player"},
            -- 古代熊猫人的祝福
            {AuraID =135094, UnitID = "player"},
            -- 起死回生(增益)
            {AuraID =123155, UnitID = "player"},
            -- 起死回生(冷却)
            {AuraID =127704, UnitID = "player"},
            -- 时间扭曲
            {AuraID =121546, UnitID = "player"},
            -- 豹之凶猛
            {AuraID =136775, UnitID = "player"},
            -- 豹之迅捷
            {AuraID =136777, UnitID = "player"},
            -- 豹之追踪
            {AuraID =136778, UnitID = "player"},
         -- 工程学
            -- 神经元弹簧
            {AuraID = 96228, UnitID = "player"},
            {AuraID = 96229, UnitID = "player"},
            {AuraID = 96230, UnitID = "player"},
            -- 地精滑翔器
            {AuraID =126389, UnitID = "player"},
            -- 滑水推进器
            {AuraID =131459, UnitID = "player"},
            -- 氮气推进器
            {AuraID = 54861, UnitID = "player"},
            -- 接地离子护盾
            {AuraID = 82627, UnitID = "player"},
            -- 相位指
            {AuraID =108788, UnitID = "player"},
            -- 隐形场
            {AuraID = 82820, UnitID = "player"},
            -- 装甲护网
            {AuraID = 82387, UnitID = "player"},
            -- 灵活偏转碟
            {AuraID = 82176, UnitID = "player"},
            -- 超级加速器
            {AuraID = 54758, UnitID = "player"},
            -- 降落伞
            {AuraID = 55001, UnitID = "player"},
         -- 物品
            -- 强度激增
            {AuraID =138702, UnitID = "player"},
            -- 狂怒之羽
            {AuraID =138759, UnitID = "player"},
            -- 力量
            {AuraID =138760, UnitID = "player"},
            -- 赞达拉之火
            {AuraID =138958, UnitID = "player"},
            -- 赞达拉战神
            {AuraID =138960, UnitID = "player"},
            -- 钢铁之舞
            {AuraID =120032, UnitID = "player"},
            -- 血腥舞钢
            {AuraID =142530, UnitID = "player"},
            -- 敏锐
            {AuraID =126657, UnitID = "player"},
            -- 风暴之盾
            {AuraID =116631, UnitID = "player"},
            -- 咖啡提神
            {AuraID =125282, UnitID = "player"},
            -- 提速
            {AuraID =126599, UnitID = "player"},
            -- 次级隐形术
            {AuraID = 3680, UnitID = "player"},
            -- 胜利召唤
            {AuraID =126679, UnitID = "player"},
            -- 胜利之涌
            {AuraID =126700, UnitID = "player"},
            -- 魔古之力药水
            {AuraID =105706, UnitID = "player"},
            -- 狂暴护符
            {AuraID =138870, UnitID = "player"},
            -- 凤歌
            {AuraID =104510, UnitID = "player"},
            {AuraID =104509, UnitID = "player"},
            {AuraID =104423, UnitID = "player"},
            -- 玉魂
            {AuraID = 104993, UnitID = "player"},
            --兔妖之啮
				    {AuraID = 105697, UnitID = "player"},
				    --青龙药水
				    {AuraID = 105702, UnitID = "player"},
				    --群山药水
				    {AuraID = 105698, UnitID = "player"},
            -- 无情打击
            {AuraID = 126649, UnitID = "player"},
            -- 天神祝福
            {AuraID =128984, UnitID = "player"},
            {AuraID =128985, UnitID = "player"},
            {AuraID =128986, UnitID = "player"},
            -- 亮纹
            {AuraID = 125487, UnitID = "player"},
            -- 敏捷
            {AuraID =126554, UnitID = "player"},
            -- 多思之息
            {AuraID =138898, UnitID = "player"},
            --影踪躲闪饰品
			    	{AuraID = 138728, UnitID = "player"},
				    --影踪敏捷饰品
				    {AuraID = 138699, UnitID = "player"},
				    --影踪力量饰品
				    {AuraID = 138702, UnitID = "player"},
				    --影踪智力饰品
				    {AuraID = 138703, UnitID = "player"}, 
         -- 副本
            -- 黑暗祝福
            {AuraID = 69391, UnitID = "player"},
            -- 天在蒸汽
            {AuraID = 69871, UnitID = "player"},
            -- 原始营养
            {AuraID =140741, UnitID = "player"},
            -- 灵巧之翼
            {AuraID =134339, UnitID = "player"},
            -- 飞行
            {AuraID =133755, UnitID = "player"},
            --赞达拉之韧（提高生命上限）
			 	    {AuraID = 126697, UnitID = "player"},
						--嗜血者的精致小瓶（躲闪加精通）
						{AuraID = 138864, UnitID = "player"},
						--梦魇残片（命中加躲闪）
						{AuraID = 126646, UnitID = "player"},
						--龙血之瓶(攻击加躲闪)
						{AuraID = 126533, UnitID = "player"},
						--灵魂屏障（伤害吸收）
						{AuraID = 138979, UnitID = "player"},
						--邪恶魂能
						{AuraID = 138938, UnitID = "player"},
						--杀戮护符
						{AuraID = 138895, UnitID = "player"},
						--重生符文
						{AuraID = 139117, UnitID = "player"},	--暴击
						{AuraID = 139120, UnitID = "player"},	--精通
						{AuraID = 139121, UnitID = "player"},	--急速
						--雷纳塔基的灵魂符咒
						{AuraID = 138756, UnitID = "player"},
						--季鹍的传说之羽
						{AuraID = 138759, UnitID = "player"},
						--赞达拉之火
						{AuraID = 138958, UnitID = "player"},
						--普利莫修斯的狂怒护符
						{AuraID = 138870, UnitID = "player"},
						--双后的凝视
						{AuraID = 139170, UnitID = "player"},
						--黑雾漩涡
						{AuraID = 126657, UnitID = "player"},
						--张叶的辉煌精华
						{AuraID = 139133, UnitID = "player"},
						--九头蛇之息
						{AuraID = 138898, UnitID = "player"},
						--乌苏雷的最终抉择
						{AuraID = 138786, UnitID = "player"},
						--雷神的精准之视
						{AuraID = 138963, UnitID = "player"},
						--老陈的壮胆酒（使用加精通）
						{AuraID = 126597, UnitID = "player"},
						--郝利东的垂死之息
						{AuraID = 138856, UnitID = "player"},
						--赤精之祈
						{AuraID = 146323, UnitID = "player"},
						--赤精之魂（治疗披风）
						{AuraID = 146200, UnitID = "player"},
						--玉珑之噬
						{AuraID = 146218, UnitID = "player"},
						--雪怒之律
						{AuraID = 146312, UnitID = "player"},
						--雪怒之捷
						{AuraID = 146296, UnitID = "player"},
						--砮皂之毅
						{AuraID = 146344, UnitID = "player"},
						--伊墨苏斯的净化之缚，智力
						{AuraID = 146046, UnitID = "player"},
						--傲慢之棱光囚笼，治疗
						{AuraID = 146314, UnitID = "player"},
						--纳兹戈林的抛光勋章，治疗
						{AuraID = 148908, UnitID = "player"},
						--狂妄之诅咒，坦克
						{AuraID = 146395, UnitID = "player"},
						--卡德里斯的剧毒图腾，智力
						{AuraID = 148906, UnitID = "player"},
						--亚煞极的黑暗之血，智力
						{AuraID = 146184, UnitID = "player"},
						--索克的酸蚀之牙，治疗
						{AuraID = 148911, UnitID = "player"},
						--鲁克的不幸护符，坦克
						{AuraID = 146343, UnitID = "player"},
						--暴怒之印，敏捷
						{AuraID = 148896, UnitID = "player"},
						--斯基尔的沁血护符，力量
						{AuraID = 146285, UnitID = "player"},
						--融火之核，力量
						{AuraID = 148899, UnitID = "player"},
						--滴答作响的黑色雷管，敏捷
						{AuraID = 146310, UnitID = "player"},
						--间歇性变异平衡器，治疗
						{AuraID = 146317, UnitID = "player"},
						--索克的尾巴尖，力量
						{AuraID = 146250, UnitID = "player"},
						--哈洛姆的护符，敏捷
						{AuraID = 148903, UnitID = "player"},
						--迦拉卡斯的邪恶之眼，力量
						{AuraID = 146245, UnitID = "player"},
						--狂怒水晶，智力
						{AuraID = 148897, UnitID = "player"},
						--既定之天命，敏捷
						{AuraID = 146308, UnitID = "player"},
         -- 影之哀伤
            -- 灵魂碎片
            {AuraID = 71905, UnitID = "player"},
            -- 森罗万象
            {AuraID = 73422, UnitID = "player"},
      ------>新版本附魔
				--血环之印
				{AuraID = 173322, UnitID = "player"},
				--雷神之印
				{AuraID = 159234, UnitID = "player"},
				--战歌之印
				{AuraID = 159675, UnitID = "player"},
				--霜狼之印
				{AuraID = 159676, UnitID = "player"},
				--影月之印
				{AuraID = 159678, UnitID = "player"},
				--黑石之印
				{AuraID = 159679, UnitID = "player"},
				--瞄准镜
				{AuraID = 156055, UnitID = "player"},--溅射
				{AuraID = 156061, UnitID = "player"},--爆击
				{AuraID = 173287, UnitID = "player"},--精通
				--橙戒
				{AuraID = 177161, UnitID = "player"},--敏捷690
				{AuraID = 177172, UnitID = "player"},--敏捷710
				{AuraID = 177159, UnitID = "player"},--智力690
				{AuraID = 177176, UnitID = "player"},--智力710
				{AuraID = 177160, UnitID = "player"},--力量690
				{AuraID = 177175, UnitID = "player"},--力量710
        ------>新版本药水以及饰品
				    --德拉诺敏捷
				    {AuraID = 156423, UnitID = "player"},
				    --德拉诺智力
				    {AuraID = 156426, UnitID = "player"},
				    --德拉诺力量
				    {AuraID = 156428, UnitID = "player"},
				    --德拉诺护甲
				    {AuraID = 156430, UnitID = "player"},
				    
				    --变羊
				    {AuraID =    118, UnitID = "player"},
				    --制裁之锤
				    {AuraID =    853, UnitID = "player"},
				    --肾击
				    {AuraID =    408, UnitID = "player"},
				    --撕扯
				    {AuraID =  47481, UnitID = "player"},
				    --割碎
				    {AuraID =  22570, UnitID = "player"},
			    	--虚空鳐：虚空之风
			    	{AuraID = 160452, UnitID = "player"},
			    	--鼓
			    	{AuraID = 146555, UnitID = "player"},
				    --豹群
				    {AuraID =  13159, UnitID = "player"},
				    --灵狐守护
				    {AuraID = 172106, UnitID = "player"},
			    	--神圣赞美诗
			    	{AuraID =  64843, UnitID = "player"},
			    	--神聖禮頌
			    	{AuraID =  64844, UnitID = "player"},
				    --反魔法领域
			    	{AuraID = 145629, UnitID = "player"},
			    	--烟雾弹
				    {AuraID =  88611, UnitID = "player"},
			    	--魔法增效
				    {AuraID = 159916, UnitID = "player"},
				    --五气归元
				    {AuraID = 115310, UnitID = "player"},
			    	--蟠龙之息
				    {AuraID = 157535, UnitID = "player"},
			    	--纯净之手
			    	{AuraID = 114039, UnitID = "player"},
			    	--铁木树皮
			    	{AuraID = 102342, UnitID = "player"},
			    	--信阳道标
			    	{AuraID = 156910, UnitID = "player"},
			    	--风行图腾
				    {AuraID = 114896, UnitID = "player"},
				 -- 德拉诺-坦克
            -- 骑士徽章
            {AuraID = 162917, UnitID = "player"},
            -- 岩心雕像
            {AuraID = 176982, UnitID = "player"},
            -- 齐步的愚忠
            {AuraID = 176460, UnitID = "player"},
            --普尔的盲目之眼
				    {AuraID =  176876, UnitID = "player"},
				    -- 石化食肉孢子
				    {AuraID =  165824, UnitID = "player"},
            -- 不眠奥术精魄
            {AuraID = 177053, UnitID = "player"},
            -- 无懈合击石板
            {AuraID = 176873, UnitID = "player"},
            -- 爆裂熔炉之门
            {AuraID = 177056, UnitID = "player"},
            -- 总击护符
            {AuraID = 177102, UnitID = "player"},
      -- 德拉诺-力量
            -- 战争之颅
            {AuraID = 162915, UnitID = "player"},
            -- 活体之山微利
            {AuraID = 176974, UnitID = "player"},
            -- 奇亚诺思的剑鞘
            {AuraID = 177189, UnitID = "player"},
            --泰克图斯的脉动之心
				    {AuraID =  177040, UnitID = "player"},
				    -- 抽搐暗影之瓶
				    {AuraID =  176874, UnitID = "player"},
            -- 尖啸之魂号角
            {AuraID = 177042, UnitID = "player"},
            -- 熔炉主管的徽记
            {AuraID = 177096, UnitID = "player"},
       -- 德拉诺-敏捷
            -- 黑心执行者勋章
            {AuraID = 176984, UnitID = "player"},
            -- 双面幸运金币
            {AuraID = 177597, UnitID = "player"},
            -- 毁灭的鳞
            {AuraID = 177038, UnitID = "player"},
            --多肉龙脊奖章
				    {AuraID =  177035, UnitID = "player"},
				    -- 跃动的山脉之心
				    {AuraID =  176878, UnitID = "player"},
            -- 蜂鸣黑铁触发器
            {AuraID = 177067, UnitID = "player"},
       -- 德拉诺-法系
            -- 睡魔之袋
            {AuraID = 162919, UnitID = "player"},
            -- 狂怒之心护符
            {AuraID = 176980, UnitID = "player"},
            -- 虚无碎片
            {AuraID = 176875, UnitID = "player"},
            --库普兰的清新
				    {AuraID =  177594, UnitID = "player"},
				    -- 蜥蜴人灵魂容器
				    {AuraID =  177046, UnitID = "player"},
            -- 达玛克的无常护符
            {AuraID = 177051, UnitID = "player"},    
            -- 黑铁微型坩埚
            {AuraID = 177081, UnitID = "player"}, 
       -- 德拉诺-治疗
            -- 羽翼沙袋
            {AuraID = 162913, UnitID = "player"},
            -- 咏然蜡烛
            {AuraID = 177592, UnitID = "player"},
            -- 完美的活性蘑菇
            {AuraID = 176978, UnitID = "player"},
            --腐蚀治疗徽章
				    {AuraID =  176879, UnitID = "player"},
				    -- 元素师的屏蔽护符
				    {AuraID =  177063, UnitID = "player"},
            -- 铁刺狗玩具
            {AuraID = 177060, UnitID = "player"},    
            -- 自动修复灭菌器
            {AuraID = 177086, UnitID = "player"},

         },
      },
      {
			Name = "Debuff",
			Direction = "UP", Interval = 1,
			Mode = "ICON", IconSize = 46,
			Pos = {"RIGHT", UIParent, "CENTER", 200, -95},
			List = {		
				------>6.0团队BOSS
				--卡加斯·刃拳：迸裂创伤
				{AuraID = 159178, UnitID = "player"},
				--刺穿
				{AuraID = 159113, UnitID = "player"},
				--老虎盯人
				{AuraID = 162497, UnitID = "player"},
				--屠夫：捶肉槌
				{AuraID = 156151, UnitID = "player"},
				--龟裂创伤
				{AuraID = 156152, UnitID = "player"},
				--深渊行者布兰肯斯波：溃烂
				{AuraID = 163241, UnitID = "player"},
				--烧苔藓
				{AuraID = 165223, UnitID = "player"},
				--寄生孢子
				{AuraID = 163242, UnitID = "player"},
				--泰克图斯：石化
				{AuraID = 162892, UnitID = "player"},
				--双子小怪，奥能动荡
				{AuraID = 166200, UnitID = "player"},
				--独眼魔双子：弱化防御
				{AuraID = 159709, UnitID = "player"},
				--致衰咆哮
				{AuraID = 158026, UnitID = "player"},
				--奥术之伤
				{AuraID = 167200, UnitID = "player"},
				--扭曲奥能
				{AuraID = 163297, UnitID = "player"},
				--M5奥能动荡，分散
				{AuraID = 163372, UnitID = "player"},
				--克拉戈：废灵璧垒
				{AuraID = 163134, UnitID = "player", Value = true},
				--魔能散射邪能
				{AuraID = 172895, UnitID = "player"},
				--元首马尔高克：混沌标记（换坦）
				{AuraID = 158605, UnitID = "player"},	--P1
				{AuraID = 164176, UnitID = "player"},	--P2
				{AuraID = 164178, UnitID = "player"},	--P3
				{AuraID = 164191, UnitID = "player"},	--P4
				--拘禁
				{AuraID = 158619, UnitID = "player"},
				--烙印
				{AuraID = 156225, UnitID = "player"},	--P1
				{AuraID = 164004, UnitID = "player"},	--P2
				{AuraID = 164005, UnitID = "player"},	--P3
				{AuraID = 164006, UnitID = "player"},	--P4
				--锁定
				{AuraID = 157763, UnitID = "player"},
				--减速
				{AuraID = 157801, UnitID = "player"},
				--毁灭共鸣
				{AuraID = 159200, UnitID = "player"},
				--毁灭共鸣（晕）
				{AuraID = 174106, UnitID = "player"},
				-->黑石铸造厂
			--格鲁尔
				--石化
				{AuraID = 155330, UnitID = "player"},
				{AuraID = 155506, UnitID = "player"},
				--炼狱切割
				{AuraID = 155080, UnitID = "player"},
				--M火耀石
				{AuraID = 165298, UnitID = "player"},
			--奥尔高格
				--酸液洪流，ST
				{AuraID = 156297, UnitID = "player"},
				--酸液巨口，MT
				{AuraID = 173471, UnitID = "player"},
				--翻滚之怒
				{AuraID = 155900, UnitID = "player"},
			--爆裂熔炉
				--高热，T
				{AuraID = 155242, UnitID = "player"},
				--熔化
				{AuraID = 155225, UnitID = "player"},
				--锁定
				{AuraID = 155196, UnitID = "player"},
				--不稳定的火焰
				{AuraID = 176121, UnitID = "player"},
				--炸弹
				{AuraID = 178279, UnitID = "player"},
				{AuraID = 155192, UnitID = "player"},
			--汉斯加尔与弗兰佐克 
				--折脊碎椎
				{AuraID = 157139, UnitID = "player"},
				--干扰怒吼
				{AuraID = 160838, UnitID = "player"},
				{AuraID = 160845, UnitID = "player"},
				{AuraID = 160847, UnitID = "player"},
				{AuraID = 160848, UnitID = "player"},
				--灼热燃烧
				{AuraID = 155818, UnitID = "player"},
			--缚火者卡格拉兹
				--锁定
				{AuraID = 154952, UnitID = "player"},
				--焦灼吐息，T
				{AuraID = 155074, UnitID = "player"},
				--升腾烈焰，T
				{AuraID = 163284, UnitID = "player"},
				--火焰链接
				{AuraID = 155049, UnitID = "player"},
				--熔岩激流
				{AuraID = 154932, UnitID = "player"},
				--炽热光辉
				{AuraID = 155277, UnitID = "player"},
			--克罗莫格
				--扭曲护甲，T
				{AuraID = 156766, UnitID = "player"},
				--纠缠之地符文
				{AuraID = 157059, UnitID = "player"},
				--破碎大地符文
				{AuraID = 161923, UnitID = "player"},
				{AuraID = 161839, UnitID = "player"},
			--兽王达玛克
				--狂乱撕扯，T
				{AuraID = 155061, UnitID = "player"},
				{AuraID = 162283, UnitID = "player"},
				--炽燃利齿，T
				{AuraID = 155030, UnitID = "player"},
				--碾碎护甲，T
				{AuraID = 155236, UnitID = "player"},
				--爆燃
				{AuraID = 154981, UnitID = "player"},
				--高热弹片
				{AuraID = 155499, UnitID = "player"},
				--M地动山摇
				{AuraID = 162276, UnitID = "player"},
				{AuraID = 155826, UnitID = "player"},
			--主管索戈尔
				--点燃，T
				{AuraID = 155921, UnitID = "player"},
				--定时炸弹
				{AuraID = 159481, UnitID = "player"},
				--实验型脉冲手雷
				{AuraID = 165195, UnitID = "player"},
				--M燃烧
				{AuraID = 164380, UnitID = "player"},
				--M热能冲击
				{AuraID = 164280, UnitID = "player"},
			--女武神
				--急速射击
				{AuraID = 156631, UnitID = "player"},
				--穿透射击
				{AuraID = 164271, UnitID = "player"},
				--震颤暗影
				{AuraID = 156214, UnitID = "player"},
				--鲜血仪式
				{AuraID = 159724, UnitID = "player"},
				--锁定
				{AuraID = 158702, UnitID = "player"},
				--致命投掷
				{AuraID = 158692, UnitID = "player"},
				--暗影猎杀
				{AuraID = 158315, UnitID = "player"},
			--黑手
				--坦克盯人
				{AuraID = 156653, UnitID = "player"},
				--死亡标记
				{AuraID = 156096, UnitID = "player"},
				--穿刺
				{AuraID = 156743, UnitID = "player"},
				{AuraID = 175020, UnitID = "player"},
				--断骨
				{AuraID = 157354, UnitID = "player"},
				--熔渣冲击
				{AuraID = 156047, UnitID = "player"},
				{AuraID = 157018, UnitID = "player"},
				{AuraID = 157322, UnitID = "player"},
				--巨力粉碎猛击
				{AuraID = 158054, UnitID = "player"},
				--熔火熔渣
				{AuraID = 156401, UnitID = "player"},
				--投掷熔渣炸弹
				{AuraID = 159179, UnitID = "player"},
				--投掷熔渣炸弹，T
				{AuraID = 157000, UnitID = "player"},
				
		--地狱火堡垒
			--奇袭地狱火
				--啸风战斧
				{AuraID = 184379, UnitID = "player"},
				--钻孔
				{AuraID = 180022, UnitID = "player"},
				--灼烧
				{AuraID = 185157, UnitID = "player"},
			--钢铁掠夺者
				--炮击
				{AuraID = 182280, UnitID = "player"},
				--染料污渍
				{AuraID = 182003, UnitID = "player"},
				--献祭
				{AuraID = 182074, UnitID = "player"},
			--考莫克
				--攫取之手
				{AuraID = 181345, UnitID = "player"},
				--邪能之触
				{AuraID = 181321, UnitID = "player"},
				--爆裂冲击
				{AuraID = 181306, UnitID = "player"},
			--地狱火高阶议会
				--堕落狂怒
				{AuraID = 184360, UnitID = "player"},
				--酸性创伤
				{AuraID = 184847, UnitID = "player"},
				--血液沸腾M
				{AuraID = 184355, UnitID = "player"},
				--死灵印记
				{AuraID = 184449, UnitID = "player"},
				{AuraID = 184450, UnitID = "player"},
				{AuraID = 184676, UnitID = "player"},
				{AuraID = 185065, UnitID = "player"},
				{AuraID = 185066, UnitID = "player"},
			--基尔罗格
				--恶魔腐化
				{AuraID = 182159, UnitID = "player"},
				{AuraID = 184396, UnitID = "player"},
				--不朽决心
				{AuraID = 180718, UnitID = "player"},
				--撕碎护甲
				{AuraID = 180200, UnitID = "player"},
			--血魔
				--消化
				{AuraID = 181295, UnitID = "player"},
				--嗜命
				{AuraID = 180148, UnitID = "player"},
				--毁灭之触
				{AuraID = 179977, UnitID = "player"},
			--暗影领主伊斯卡
				--幻影之伤
				{AuraID = 182325, UnitID = "player"},
				--幻影腐蚀
				{AuraID = 181824, UnitID = "player"},
				--邪能炸弹
				{AuraID = 181753, UnitID = "player"},
				--邪能飞轮
				{AuraID = 182178, UnitID = "player"},
			--永恒者索奎萨尔
				--粉碎防御
				{AuraID = 182038, UnitID = "player"},
				--易爆的邪能宝珠
				{AuraID = 189627, UnitID = "player"},
				--邪能牢笼
				{AuraID = 180415, UnitID = "player"},
				--堕落者之赐
				{AuraID = 184124, UnitID = "player"},
				--魅影重重
				{AuraID = 182769, UnitID = "player"},
				--暗言术：恶
				{AuraID = 184239, UnitID = "player"},
				--恶毒鬼魅
				{AuraID = 182900, UnitID = "player"},
				--永世饥渴
				{AuraID = 188666, UnitID = "player"},
			--女暴君维哈里
				--凋零契印
				{AuraID = 180000, UnitID = "player"},
				--腐蚀序列
				{AuraID = 180526, UnitID = "player"},
			--恶魔领主扎昆
				--魂不附体
				{AuraID = 179407, UnitID = "player"},
				--玷污
				{AuraID = 189032, UnitID = "player"},
				{AuraID = 189031, UnitID = "player"},
				{AuraID = 189030, UnitID = "player"},
				--毁灭之种
				{AuraID = 181515, UnitID = "player"},
			--祖霍拉克
				--邪蚀
				{AuraID = 186134, UnitID = "player"},
				--灵媒
				{AuraID = 186135, UnitID = "player"},
				--邪影屠戮
				{AuraID = 185656, UnitID = "player"},
				--魔能喷涌
				{AuraID = 186407, UnitID = "player"},
				--灵能涌动
				{AuraID = 186333, UnitID = "player"},
			--玛诺洛斯
				--末日印记
				{AuraID = 181099, UnitID = "player"},
				--末日之刺
				{AuraID = 189717, UnitID = "player"},
				--强化暗影之力
				{AuraID = 182088, UnitID = "player"},
			--阿克蒙德
				--暗影爆破
				{AuraID = 183864, UnitID = "player"},
				--锁定
				{AuraID = 182879, UnitID = "player"},
				--束缚折磨
				{AuraID = 184964, UnitID = "player"},					    
			},
	  	},
   {
			Name = "Warning",
			Direction = "DOWN", Interval = 1,
			Mode = "ICON", IconSize = 55,
			Pos = {"CENTER", UIParent, "TOP", 0, -180},
			List = {		
				-->悬槌堡
				--M1老虎易伤
				{AuraID = 163130, UnitID = "target"},
				--M1BOSS易伤
				{AuraID = 159029, UnitID = "target"},
				--克拉戈废灵璧垒
				{AuraID = 156803, UnitID = "target", Value = true},
			-->黑石铸造厂
				--1震地暴怒
				{AuraID = 155539, UnitID = "target"},
				--2黑石弹幕
				{AuraID = 156834, UnitID = "target"},
				--2如饥似渴
				{AuraID = 155819, UnitID = "target"},
				--3减伤护盾
				{AuraID = 155176, UnitID = "target"},
				--3护盾消失
				{AuraID = 158345, UnitID = "target"},
				--3大地反馈护盾
				{AuraID = 155173, UnitID = "target"},
				--5过热
				{AuraID = 154950, UnitID = "target"},
				--5烈焰之怒
				{AuraID = 163273, UnitID = "target"},
				--6雷霆轰击
				{AuraID = 157054, UnitID = "target"},
				--6狂暴
				{AuraID = 156861, UnitID = "target"},
				--7野蛮怒吼
				{AuraID = 155208, UnitID = "target"},
				--7防御
				{AuraID = 160382, UnitID = "target"},
				--M7势不可挡
				{AuraID = 155321, UnitID = "target"},
				--8呵斥
				{AuraID = 156281, UnitID = "target"},
				--9钢铁意志
				{AuraID = 159336, UnitID = "target"},
				--9利刃沖刺
				{AuraID = 155794, UnitID = "target"},
				--9土之壁垒
				{AuraID = 158708, UnitID = "target"},
				--坦克过载
				{AuraID = 159199, UnitID = "target"},
				--坦克易伤
				{AuraID = 157322, UnitID = "target"},
				--坦克黑铁铠甲
				{AuraID = 156667, UnitID = "target"},
			-->地狱火堡垒
				--血魔，灵魂盛宴
				{AuraID = 181973, UnitID = "target"},
				--永恒者索奎萨尔，邪能壁垒
				{AuraID = 184053, UnitID = "target"},
				--永恒者索奎萨尔，染血追踪者
				{AuraID = 188767, UnitID = "target"},
				--女暴君维哈里，统御者壁垒
				{AuraID = 180040, UnitID = "target"},
				--祖霍拉克，混乱压制
				{AuraID = 187204, UnitID = "target"},
			-->PLAYER
				--痛苦压制
				{AuraID =  33206, UnitID = "target"},
				--盾墙
				{AuraID =    871, UnitID = "target"},
				--冰封之韧
				{AuraID =  48792, UnitID = "target"},
				--反魔法护罩
				{AuraID =  48707, UnitID = "target"},
				--保护之手
				{AuraID =   1022, UnitID = "target"},
				--生存本能
				{AuraID =  61336, UnitID = "target"},
				--威慑
				{AuraID = 148467, UnitID = "target"},
				{AuraID =  19263, UnitID = "target"},
				--寒冰屏障
				{AuraID =  45438, UnitID = "target"},
				--强化隐形术
				{AuraID = 113862, UnitID = "target"},
				--剑在人在
				{AuraID = 118038, UnitID = "target"},
				--法术反射
				{AuraID =  23920, UnitID = "target"},
				--升腾
				{AuraID = 114050, UnitID = "target"},	--元素
				{AuraID = 114051, UnitID = "target"},	--增强
				{AuraID = 114052, UnitID = "target"},	--恢复
				--圣佑术
				{AuraID =    498, UnitID = "target"},
				--圣盾术
				{AuraID =    642, UnitID = "target"},
				--自由之手
				{AuraID =   1044, UnitID = "target"},
				--复仇之怒
				{AuraID =  31842, UnitID = "target"},	--神圣
				{AuraID =  31884, UnitID = "target"},	--惩戒
				--狂野怒火
				{AuraID =  19574, UnitID = "target"},
				--急速射击
				{AuraID =   3045, UnitID = "target"},
				--不灭决心
				{AuraID = 104773, UnitID = "target"},
				--黑暗交易
				{AuraID = 110913, UnitID = "target"},
				--闪避
				{AuraID =   5277, UnitID = "target"},
				--壮胆酒
				{AuraID = 120954, UnitID = "target"},
				--躯不坏
				{AuraID = 122278, UnitID = "target"},
				--散魔功
				{AuraID = 122783, UnitID = "target"},
			},
		},
   },
   -- 死亡骑士
   ["DEATHKNIGHT"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval = 3,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -560, -27},
         List = {
            -- 新技能*
            {AuraID = 171049, UnitID = "player"},
            -- 新技能*(暗影注入)
            {AuraID = 91342, UnitID = "player"},
            -- 黑暗模拟
            {AuraID = 77616, UnitID = "player"},
            -- 亡者大军
            {AuraID = 42650, UnitID = "player"},
            -- 符能转化
            {AuraID =119975, UnitID = "player"},
            -- 亵渎之地
            {AuraID =115018, UnitID = "player"},
            -- 冷酷严冬
            {AuraID =108200, UnitID = "player"},
            -- 灵魂收割
            {AuraID =114868, UnitID = "player"},
            -- 炼狱
            {AuraID =116888, UnitID = "player"},
            -- 不洁之力
            {AuraID = 53365, UnitID = "player"},
            -- 灰烬冰川
            {AuraID = 53386, UnitID = "player"},
            -- 血之气息
            {AuraID = 50421, UnitID = "player"},
            -- 鲜血护盾
            {AuraID = 77535, UnitID = "player"},
            -- 符文刃舞
            {AuraID = 81256, UnitID = "player"},
            -- 赤色天灾
            {AuraID = 81141, UnitID = "player"},
            -- 死亡脚步
            {AuraID = 96268, UnitID = "player"},
            -- 邪恶虫群
            {AuraID =115989, UnitID = "player"},
            -- 符文腐蚀
            {AuraID = 51460, UnitID = "player"},
            -- 白骨之盾
            {AuraID = 49222, UnitID = "player"},
            -- 巫妖之躯
            {AuraID = 49039, UnitID = "player"},
            -- 末日突降
            {AuraID = 81340, UnitID = "player"},
            -- 杀戮机器
            {AuraID = 51124, UnitID = "player"},
            -- 冰冻之雾
            {AuraID = 59052, UnitID = "player"},
            -- 冰霜之柱
            {AuraID = 51271, UnitID = "player"},
            -- 鲜血充能
            {AuraID =114851, UnitID = "player"},
            -- 黑暗援助
            {AuraID =101568, UnitID = "player"},
            -- 吸血鬼之血
            {AuraID = 55233, UnitID = "player"},
            -- 大墓地的意志
            {AuraID = 81162, UnitID = "player"},
            --冰霜之路
				    {AuraID =   3714, UnitID = "player"},
				    --死亡之影
				    {AuraID = 164047, UnitID = "player", Value = true},
				    --蜷缩
				    {AuraID =  91838, UnitID = "pet"},
				    
         -- 套装效果
            -- 残酷之握
            {AuraID =131547, UnitID = "player"},
            -- 符文归还
            {AuraID = 61258, UnitID = "player"},
            -- DPS 2T16
            {AuraID = 144901, UnitID = "player"},
            -- T 2T16
            {AuraID = 144948, UnitID = "player"},
         },
      },   
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 450, 85},
         List = {
            -- 蹒跚冲锋
            {AuraID = 91807, UnitID = "target", Caster = "pet"},
            -- 蛮兽打击
            {AuraID = 91797, UnitID = "target", Caster = "pet"},
            -- 撕扯
            {AuraID = 91800, UnitID = "target", Caster = "pet"},
            -- 冷酷严冬(减速)
            {AuraID =115000, UnitID = "target", Caster = "player"},
            -- 冷酷严冬(昏迷)
            {AuraID =115001, UnitID = "target", Caster = "player"},
            -- 灵魂收割(鲜血)
            {AuraID =114866, UnitID = "target", Caster = "player"},
            -- 灵魂收割(邪恶)
            {AuraID =130736, UnitID = "target", Caster = "player"},
            -- 灵魂收割(冰霜)
            {AuraID =130735, UnitID = "target", Caster = "player"},
            -- 血之疫病
            {AuraID = 55078, UnitID = "target", Caster = "player"},
            -- 冰霜疫病
            {AuraID = 55095, UnitID = "target", Caster = "player"},
            --血红热疫
				    {AuraID = 81130, UnitID = "target", Caster = "player"},
            -- 冻疮
            {AuraID = 50435, UnitID = "target", Caster = "player"},
            -- 窒息
            {AuraID =108194, UnitID = "target", Caster = "player"},
            -- 绞袭
            {AuraID = 47476, UnitID = "target", Caster = "player"},
            -- 寒冰锁链(定身)
            {AuraID = 96294, UnitID = "target", Caster = "player"},
            -- 寒冰锁链(减速)
            {AuraID = 45524, UnitID = "target", Caster = "player"},
            -- 黑暗模拟
            {AuraID = 77606, UnitID = "target", Caster = "player"},
            -- 死疽打击
            {AuraID = 73975, UnitID = "target", Caster = "player"},
         },
      },   
   },
   -- 战士
   ["WARRIOR"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval =2,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -500, -27},
         List = {
            -- 激怒
            {AuraID = 12880, UnitID = "player"},
            -- 粗暴打断
            {AuraID = 86663, UnitID = "player"},
            -- 狂暴之怒
            {AuraID = 18499, UnitID = "player"},
            -- 浴血奋战
            {AuraID = 12292, UnitID = "player"},
            -- 致命平静
            {AuraID = 85730, UnitID = "player"},
            -- 鲁莽
            {AuraID = 1719, UnitID = "player"},
            -- 横扫攻击
            {AuraID = 12328, UnitID = "player"},
            -- 血之气息
            {AuraID = 60503, UnitID = "player"},
            -- 天神下凡
            {AuraID =107574, UnitID = "player"},
            -- 断筋雕文
            {AuraID =115945, UnitID = "player"},
            -- 狂怒回复
            {AuraID = 55694, UnitID = "player"},
            -- 剑刃风暴
            {AuraID = 46924, UnitID = "player"},
            -- 盾牌格挡
            {AuraID =132404, UnitID = "player"},
            -- 剑盾猛攻
            {AuraID = 50227, UnitID = "player"},
            -- 破釜沉舟
            {AuraID = 12975, UnitID = "player"},
            -- 最后通牒
            {AuraID =122510, UnitID = "player"},
            -- 胜利
            {AuraID = 32216, UnitID = "player"},
            -- 激怒
            {AuraID = 12880, UnitID = "player"},
            -- 复苏之风
            {AuraID =125667, UnitID = "player"},
            {AuraID = 29842, UnitID = "player"},
            -- 血脉喷张
            {AuraID = 46916, UnitID = "player"},
            -- 乱舞
            {AuraID = 12968, UnitID = "player"},
            -- 绞肉机
            {AuraID = 85739, UnitID = "player"},
            -- 怒击
            {AuraID =131116, UnitID = "player"},
            -- 怒风斩
            {AuraID =115317, UnitID = "player"},
            -- 致死打击
            {AuraID = 12294, UnitID = "player"},
            -- 坚守阵地
            {AuraID = 84619, UnitID = "player"},
            -- 挫志怒吼
            {AuraID =125565, UnitID = "player"},
            -- 猝死
            {AuraID = 52437, UnitID = "player"},
            {AuraID =139958, UnitID = "player"},
            --破坏者
				    {AuraID = 152277, UnitID = "player"},
						--挑战战旗
				    {AuraID = 114192, UnitID = "player"},
				    --英勇飞跃雕文
				    {AuraID = 133278, UnitID = "player"},
				    --盾牌冲锋
				    {AuraID = 169667, UnitID = "player"},
         },
      },   
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 430, 85},
         List = {
            -- 破甲攻击
            {AuraID =113746, UnitID = "target"},
            -- 缴械
            {AuraID = 676, UnitID = "target"},
            -- 冲锋击昏
            {AuraID = 7922, UnitID = "target", Caster = "player"},
            -- 巨人打击
            {AuraID = 167105, UnitID = "target", Caster = "player"},
            -- 重伤
            {AuraID =115767, UnitID = "target", Caster = "player"},
            -- 断筋
            {AuraID = 1715, UnitID = "target", Caster = "player"},
            -- 撕裂
            {AuraID = 772, UnitID = "target", Caster = "player"},
            -- 迟滞
            {AuraID =129923, UnitID = "target", Caster = "player"},
            -- 刺耳怒吼
            {AuraID = 12323, UnitID = "target", Caster = "player"},
            -- 浴血奋战
            {AuraID =113344, UnitID = "target", Caster = "player"},
            -- 错愕怒吼
            {AuraID =107566, UnitID = "target", Caster = "player"},
            -- 震荡波
            {AuraID =132168, UnitID = "target", Caster = "player"},
            -- 破胆怒吼
            {AuraID = 20511, UnitID = "target", Caster = "player"},
            -- 挫志怒吼
            {AuraID = 1160, UnitID = "target", Caster = "player"},
            -- 禁令沉默
            {AuraID = 18498, UnitID = "target", Caster = "player"},
            -- 碎裂投掷
            {AuraID = 64382, UnitID = "target", Caster = "player"},
            -- 风暴之锤
            {AuraID =132169, UnitID = "target", Caster = "player"},
            -- 搓志战旗
            {AuraID =114205, UnitID = "target", Caster = "player"},
            -- 挑战战旗
            {AuraID =114198, UnitID = "target", Caster = "player"},
            -- 战神
            {AuraID =105771, UnitID = "target", Caster = "player"},
            {AuraID =137637, UnitID = "target", Caster = "player"},
         },
      },   
   },
   -- 术士
   ["WARLOCK"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval = 3,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -560, -27},
         List = {
            -- 灰烬转换
            {AuraID =114635, UnitID = "player"},
            -- 浩劫
            {AuraID = 80240, UnitID = "player"},
            -- 黑暗灵魂:易爆
            {AuraID =113858, UnitID = "player"},
            -- 黑暗灵魂:学识
            {AuraID =113861, UnitID = "player"},
            -- 黑暗灵魂:哀难
            {AuraID =113860, UnitID = "player"},
            -- 硫磺烈火
            {AuraID =108683, UnitID = "player"},
            -- 火焰之雨
            {AuraID =104232, UnitID = "player"},
            -- 魔典:恶魔牺牲
            {AuraID =108503, UnitID = "player"},
            -- 灼疗主人
            {AuraID =119899, UnitID = "player"},
            -- 黑暗再生
            {AuraID =108359, UnitID = "player"},
            -- 生命通道
            {AuraID = 755, UnitID = "player"},
            -- 爆燃
            {AuraID =117828, UnitID = "player"},
            -- 爆燃冲刺
            {AuraID =111400, UnitID = "player"},
            -- 鲜血恐惧
            {AuraID =111397, UnitID = "player"},
            -- 反冲
            {AuraID = 34936, UnitID = "player"},
            -- 治疗石
            {AuraID = 6262, UnitID = "player"},
            -- 恶魔传送门
            {AuraID =113901, UnitID = "player"},
            -- 地狱烈焰
            {AuraID = 1949, UnitID = "player"},
            -- 熔火之心
            {AuraID =122355, UnitID = "player"},
            --基尔加丹的狡诈
				    {AuraID = 137587, UnitID = "player"},
				    --玛诺洛斯的狂怒
				    {AuraID = 108508, UnitID = "player"},
				    --恶魔协同
				    {AuraID = 171982, UnitID = "player"},
				    --恶魔之箭
				    {AuraID = 157695, UnitID = "player"},
            -- 献祭光环
            {AuraID =104025, UnitID = "player"},
            -- 灵魂交换
            {AuraID = 86211, UnitID = "player"},
            -- 灵魂燃烧
            {AuraID = 74434, UnitID = "player"},
            -- 暗夜冥想
            {AuraID = 17941, UnitID = "player"},
            -- 灵魂燃烧:恶魔法阵
            {AuraID = 79438, UnitID = "player"},
            -- 恶魔重生
            {AuraID = 88448, UnitID = "player"},
            -- 恶魔重生
            {AuraID = 108559, UnitID = "player"},
            -- 术士T16 - 炽燃之怒
            {AuraID = 145085, UnitID = "player"},
            -- 术士T16 - 毁灭浩劫
            {AuraID = 145075, UnitID = "player"},
            -- 术士T16 - 灰烬精通
            {AuraID = 145164, UnitID = "player"},
         },
      },   
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 430, 85},
         List = {
            -- 元素诅咒
            {AuraID = 1490, UnitID = "target"},
            {AuraID =116202, UnitID = "target"},
            {AuraID =104225, UnitID = "target"},
            -- 虚弱诅咒
            {AuraID =109466, UnitID = "target"},
            {AuraID =116198, UnitID = "target"},
            {AuraID =109468, UnitID = "target"},
            -- 疲劳诅咒
            {AuraID = 18233, UnitID = "target"},
            {AuraID =104223, UnitID = "target"},
            -- 放逐
            {AuraID = 710, UnitID = "target"},
            -- 缴械
            {AuraID =118093, UnitID = "target", Caster = "pet"},
            -- 法力封锁
            {AuraID = 24259, UnitID = "target", Caster = "pet"},
            -- 受难
            {AuraID = 17735, UnitID = "target", Caster = "pet"},
            -- 诱惑
            {AuraID = 6358, UnitID = "target", Caster = "pet"},
            -- 迷魅
            {AuraID =115268, UnitID = "target", Caster = "pet"},
            -- 地狱火觉醒
            {AuraID = 22703, UnitID = "target", Caster = "pet"},
            -- 巨斧投掷
            {AuraID = 89766, UnitID = "target", Caster = "pet"},
            -- 献祭
            {AuraID = 348, UnitID = "target", Caster = "player"},
            {AuraID = 157736, UnitID = "target", Caster = "player"},
            -- 混乱之箭
            {AuraID =116858, UnitID = "target", Caster = "player"},
            -- 燃烧
            {AuraID = 17962, UnitID = "target", Caster = "player"},
            -- 暗影之怒
            {AuraID = 30283, UnitID = "target", Caster = "player"},
            -- 恐惧
            {AuraID =118699, UnitID = "target", Caster = "player"},
            -- 恐惧嚎叫
            {AuraID = 5484, UnitID = "target", Caster = "player"},
            -- 浩劫
            {AuraID = 80240, UnitID = "target", Caster = "player"},
            -- 奥术洪流
            {AuraID = 28730, UnitID = "target", Caster = "player"},
            -- 死亡缠绕
            {AuraID = 6789, UnitID = "target", Caster = "player"},
            -- 鲜血恐惧
            {AuraID =137143, UnitID = "target", Caster = "player"},
            -- 阿克蒙德的复仇
            {AuraID =108505, UnitID = "target", Caster = "player"},
            -- 暗影烈焰
            {AuraID = 47960, UnitID = "target", Caster = "player"},
            -- 腐蚀术
            {AuraID = 146739, UnitID = "target", Caster = "player"},
            -- 末日降临
            {AuraID = 603, UnitID = "target", Caster = "player"},
            -- 混乱波浪
            {AuraID =124915, UnitID = "target", Caster = "player"},
            -- 挑衅
            {AuraID = 97827, UnitID = "target", Caster = "player"},
            -- 催眠术
            {AuraID =104045, UnitID = "target", Caster = "player"},
            -- 吸取灵魂
            {AuraID = 1120, UnitID = "target", Caster = "player"},
            -- 痛楚
            {AuraID = 980, UnitID = "target", Caster = "player"},
            -- 鬼影缠身
            {AuraID = 48181, UnitID = "target", Caster = "player"},
            -- 梦魇
            {AuraID = 60947, UnitID = "target", Caster = "player"},
            -- 痛苦无常
            {AuraID = 30108, UnitID = "target", Caster = "player"},
            -- 灾难之握
            {AuraID =103103, UnitID = "target", Caster = "player"},
            -- 生命收割
            {AuraID =108371, UnitID = "target", Caster = "player"},
            {AuraID =115707, UnitID = "target", Caster = "player"},
            -- 腐蚀之种
            {AuraID = 27243, UnitID = "target", Caster = "player"},
            {AuraID =114790, UnitID = "target", Caster = "player"},
            -- 吸取生命
            {AuraID = 689, UnitID = "target", Caster = "player"},
            {AuraID = 89420, UnitID = "target", Caster = "player"},
         },
      },
   },
   -- 德鲁伊
   ["DRUID"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval = 3,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -500, -27},
         List = {
				    -- 节能施法
            {AuraID = 16870, UnitID = "player"},
            -- 节能施法
            {AuraID = 48438, UnitID = "player"},
            -- 野性成长
            {AuraID = 8936, UnitID = "player"},
            -- 愈合
            {AuraID = 135700, UnitID = "player"},
            -- 自然之赐
            {AuraID = 16886, UnitID = "player"},
            -- 日蚀
            {AuraID = 48517, UnitID = "player"},
            -- 月蚀
            {AuraID = 48518, UnitID = "player"},
            -- 猛虎之怒
            {AuraID = 5217, UnitID = "player"},
            -- 狂暴(猫&熊)
            {AuraID = 50334, UnitID = "player"},
            -- 野蛮咆哮(猫)
            {AuraID = 127538, UnitID = "player"},
            -- 粉碎
            {AuraID = 80951, UnitID = "player"},
            -- 月光淋漓
            {AuraID = 81192, UnitID = "player"},
            -- 坠星
            {AuraID = 93400, UnitID = "player"},
            -- 狂暴
            {AuraID = 93622, UnitID = "player"},
            -- 急奔
            {AuraID = 1850, UnitID = "player"},
            -- 狂暴
            {AuraID = 106951, UnitID = "player"},
            --野性位移
				    {AuraID = 137452, UnitID = "player"},
				    --野性冲锋：泳速
				    {AuraID = 102416, UnitID = "player"},
				    --塞纳里奥结界
				    {AuraID = 102351, UnitID = "player"},
            -- 化身：丛林之王
            {AuraID = 102543, UnitID = "player"},
            -- 自然之握
            {AuraID = 16689, UnitID = "player"},
            -- 乌索克之力
            {AuraID = 106922, UnitID = "player"},
            -- 树皮术
            {AuraID = 22812, UnitID = "player"},
            -- 野蛮咆哮
            {AuraID = 52610, UnitID = "player"},
            -- 日光增效
            {AuraID = 164545, UnitID = "player"},
            -- 月光增效
            {AuraID = 164547, UnitID = "player"},
            -- 野蛮防御
            {AuraID = 132402, UnitID = "player"},
            -- 回春术
            {AuraID = 155777, UnitID = "player"},
            -- 萌芽(奶)
            {AuraID = 774, UnitID = "player"},
            --野性之心
				    {AuraID = 108291, UnitID = "player"},
				    {AuraID = 108292, UnitID = "player"},
				    {AuraID = 108293, UnitID = "player"},
				    {AuraID = 108294, UnitID = "player"},
				    --掠食者的迅捷(猫)
				    {AuraID =  69369, UnitID = "player"},
				    --尖牙与利爪(熊)
				    {AuraID = 135286, UnitID = "player"},
				    --自然的守护
				    {AuraID = 124974, UnitID = "player"},
				    --化身
				    {AuraID = 102560, UnitID = "player"},
				    {AuraID = 117679, UnitID = "player"},
				    {AuraID = 102558, UnitID = "player"},
				    --星辰坠落(鸟)
				    {AuraID =  48505, UnitID = "player"},
				    --超凡之盟(鸟)
			    	{AuraID = 112071, UnitID = "player"},
				    --月之巅(鸟)
			    	{AuraID = 171743, UnitID = "player"},
				    --日之巅(鸟)
			    	{AuraID = 171744, UnitID = "player"},
				    --强化枭兽(鸟)
				    {AuraID = 157228, UnitID = "player"},
			    	--野蛮咆哮(猫)
				    {AuraID = 174544, UnitID = "player"},
			    	--血腥爪击(猫)
			    	{AuraID = 145152, UnitID = "player"},
				    --鬃毛倒竖(熊)
			    	{AuraID = 155835, UnitID = "player"},
			    	--粉碎(熊)
			    	{AuraID = 158792, UnitID = "player"},
			    	--相生(奶)
			    	{AuraID = 100977, UnitID = "player"},
				    --丛林之魂(奶)
				    {AuraID = 114108, UnitID = "player"},
			    	--洞察秋毫(奶)
			    	{AuraID = 155631, UnitID = "player"},
			    	--洞察秋毫(奶)
			    	{AuraID = 155577, UnitID = "player"},
			    	-- 生命绽放
            {AuraID = 33763, UnitID = "player"},
            -- 强化生命绽放
            {AuraID = 157312, UnitID = "player"},
				    --刚毅（T披风）
			    	{AuraID = 138242, UnitID = "player"},
         },
      },
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 430, 85},
         List = {   
         		--野性冲锋：晕眩
				    {AuraID =  50259, UnitID = "target", Caster = "player"},
				    --野性冲锋：定身
				    {AuraID =  45334, UnitID = "target", Caster = "player"},
				    --台风：晕眩
				    {AuraID =  61391, UnitID = "target", Caster = "player"},
				    --群体缠绕
				    {AuraID = 102359, UnitID = "target", Caster = "player"},
				    --割碎(猫)
				    {AuraID =  22570, UnitID = "target", Caster = "player"},
				    --星辰耀斑(鸟)
				    {AuraID = 152221, UnitID = "target", Caster = "player"},
				    --日光术(鸟)
				    {AuraID =  81261, UnitID = "target", Caster = "player"},
				    --铁木树皮(奶)
				    {AuraID = 102342, UnitID = "target", Caster = "player"},
				    --源生(奶)
				    {AuraID = 162359, UnitID = "target", Caster = "player"},
				    --萌芽(奶)
            {AuraID = 48438, UnitID = "target", Caster = "player"},
				    --野性成长
            {AuraID = 8936, UnitID = "target", Caster = "player"},
				    --愈合
				    {AuraID = 155777, UnitID = "target", Caster = "player"},
            -- 挫志咆哮(熊)
            {AuraID = 99, UnitID = "target", Caster = "player"},
            -- 回春术
            {AuraID = 774, UnitID = "target", Caster = "player"},
            -- 蛮力猛击
            {AuraID = 5211, UnitID = "target", Caster = "player"},
            -- 绞缠根须
            {AuraID = 339, UnitID = "target", Caster = "player"},
            -- 割裂(猫)
            {AuraID = 1079, UnitID = "target", Caster = "player"},
            -- 精灵虫群
            {AuraID = 102355, UnitID = "target", Caster = "player"},
            -- 斜掠(猫)
            {AuraID = 1822, UnitID = "target", Caster = "player"},
            -- 破甲
            {AuraID = 113746, UnitID = "target", Caster = "player"},
            -- 虫群
            {AuraID = 5570, UnitID = "target", Caster = "player"},
            -- 月火术
            {AuraID = 164812, UnitID = "target", Caster = "player"},
            -- 割伤(熊)
            {AuraID = 33745, UnitID = "target", Caster = "player"},
            -- 尖牙与利齿(熊)
            {AuraID = 135601, UnitID = "target", Caster = "player"},
            -- 虚弱打击
            {AuraID = 115798, UnitID = "target", Caster = "player"},
            -- 痛击
            {AuraID = 106830, UnitID = "target", Caster = "player"},
            {AuraID = 77758, UnitID = "target", Caster = "player"},
            -- 感染伤口
            {AuraID = 58180, UnitID = "target", Caster = "player"},
            -- 生命绽放
            {AuraID = 33763, UnitID = "target", Caster = "player"},
            -- 强化生命绽放
            {AuraID = 157312, UnitID = "player", Caster = "player"},
            -- 裂伤(猫)
            {AuraID = 33876, UnitID = "target", Caster = "player"},
            -- 野蛮咆哮(猫)
            {AuraID = 52610, UnitID = "target", Caster = "player"},
            -- 斜掠
            {AuraID = 155722, UnitID = "target", Caster = "player"},
            -- 阳炎术
            {AuraID = 164815, UnitID = "target", Caster = "player"},
         },
      },
   },
   -- 猎人
   ["HUNTER"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval = 3,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -560, -27},
         List = {
            --狂轰滥炸
						{AuraID =  82921, UnitID = "player"},
						--陷阱发射器
						--{AuraID =  77769, UnitID = "player"},
						--生存专家
						{AuraID = 164857, UnitID = "player"},
            -- 野兽之心
            {AuraID = 34471, UnitID = "player"},
            -- 误导
            {AuraID = 34477, UnitID = "player"},
            {AuraID = 35079, UnitID = "player"},
            -- 强化稳固射击
            {AuraID = 53220, UnitID = "player"},
            -- 眼镜蛇打击
            {AuraID = 53257, UnitID = "player"},
            -- 野性呼唤
            {AuraID = 53434, UnitID = "player"},
            -- 荷枪实弹
            {AuraID = 56453, UnitID = "player"},
            --狩猎刺激
				    {AuraID =  34720, UnitID = "player"},
				    --稳固集中
				    {AuraID = 177668, UnitID = "player"},
				    --狙击训练
				    {AuraID = 168811, UnitID = "player"},
            -- 攻击弱点
            {AuraID = 70728, UnitID = "player"},
            -- 准备,端枪,瞄准... ...
            {AuraID = 82925, UnitID = "player"},
            -- 开火!
            {AuraID = 82926, UnitID = "player"},
            -- 灵魂治愈
            {AuraID = 90361, UnitID = "player"},
            -- 上!
            {AuraID = 89388, UnitID = "player"},
            -- 集中火力
            {AuraID = 82692, UnitID = "player"},
            -- 假死
            {AuraID = 5384, UnitID = "player"},
            -- 血性大发
            {AuraID = 94007, UnitID = "player"},
            -- X光瞄准
            {AuraID = 95712, UnitID = "player"},
            -- 伪装
            {AuraID = 51755, UnitID = "player"},
            -- 狂乱
            {AuraID = 19615, UnitID = "player"},
            -- 迅疾如风
            {AuraID =118922, UnitID = "player"},
            -- 主人的召唤
            {AuraID = 54216, UnitID = "player"},
            -- 爆裂领主的毁灭瞄准镜
            {AuraID = 109085, UnitID = "player"},
         },
      },
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 430, 85},
         List = {
            -- 猎人印记
            {AuraID = 1130 ,UnitID = "target", Caster = "player"},
            -- 毒蛇钉刺
            {AuraID =118253 ,UnitID = "target", Caster = "player"},
				    --爆炸射击
				    {AuraID =  53301, UnitID = "target", Caster = "player"},
				    --扰乱射击
				    {AuraID =  20736, UnitID = "target", Caster = "player"},
				    --险境求生
				    {AuraID = 136634, UnitID = "target", Caster = "player"},
				    --夺命黑鸦
				    {AuraID = 131894, UnitID = "target", Caster = "player"},
            -- 驱散射击
            {AuraID = 19503 ,UnitID = "target", Caster = "player"},
            -- 穿刺射击
            {AuraID = 63468 ,UnitID = "target", Caster = "player"},
            -- 震荡射击
            {AuraID = 5116 ,UnitID = "target", Caster = "player"},
            -- 黑箭
            {AuraID = 3674 ,UnitID = "target", Caster = "player"},
            -- 蜘蛛毒刺
            {AuraID = 82654 ,UnitID = "target", Caster = "player"},
            --爆炸陷阱
			    	{AuraID =  13812, UnitID = "target", Caster = "player"},
			    	--冰霜陷阱：诱捕
			    	{AuraID = 135373, UnitID = "target", Caster = "player"},
				    --束缚射击
				    {AuraID = 117526, UnitID = "target"},
         },
      },
   },
   -- 法师
   ["MAGE"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval = 3,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -560, -27},
         List = {
            -- 奥术强化
            {AuraID = 12042, UnitID = "player"},
            -- 唤醒
            {AuraID = 12051, UnitID = "player"},
            -- 奥术冲击
            {AuraID = 36032, UnitID = "player"},
            -- 寒冰指
            {AuraID = 44544, UnitID = "player"},
            -- 法术连击
            {AuraID = 48108, UnitID = "player"},
            -- 冰冷智慧
            {AuraID = 57761, UnitID = "player"},
            -- 冲击(等级1)
            {AuraID = 64343, UnitID = "player"},
            -- 奥术飞弹!
            {AuraID = 79683, UnitID = "player"},
            -- 灸灼
            {AuraID = 87023, UnitID = "player"},
            -- 冰冷血脉
            {AuraID = 12472, UnitID = "player"},
            -- 气定神闲
            {AuraID = 12043, UnitID = "player"},
            -- 隐形术
            {AuraID = 32612, UnitID = "player"},
            -- 祈愿者之能
            {AuraID = 116257, UnitID = "player"},
            --强化隐形术
				    {AuraID = 110960, UnitID = "player"},
				    --隐没
				    {AuraID = 157913, UnitID = "player"},
				    --炽热疾速
				    {AuraID = 108843, UnitID = "player"},
				    --能量符文
				    {AuraID = 116014, UnitID = "player"},
				    --操控时间
				    {AuraID = 110909, UnitID = "player"},
				    --热力迸发(火)
				    {AuraID =  48107, UnitID = "player"},
				    --浮冰
				    {AuraID = 108839, UnitID = "player"},
         },
      },
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 430, 85},
         List = {      
            -- 点燃
            {AuraID = 12654 ,UnitID = "target", Caster = "player"},
            --燃烧(火)
				    {AuraID =  83853, UnitID = "target", Caster = "player"},
            -- 临界炽焰
            {AuraID = 22959 ,UnitID = "target", Caster = "player"},
            -- 减速
            {AuraID = 31589 ,UnitID = "target", Caster = "player"},
            -- 活动炸弹
            {AuraID = 44457 ,UnitID = "target", Caster = "player"},
            -- 反制
            {AuraID = 55021 ,UnitID = "target", Caster = "player"},
            -- 冰霜新星
            {AuraID = 122 ,UnitID = "target", Caster = "player"},
            -- 冰锥术
            {AuraID = 120 ,UnitID = "target", Caster = "player"},
            -- 寒冰箭
            {AuraID = 116 ,UnitID = "target", Caster = "player"},
            -- 霜火之箭
            {AuraID = 44614 ,UnitID = "target", Caster = "player"},
            -- 虚空风暴
            {AuraID = 114923 ,UnitID = "target", Caster = "player"},
            -- 烈焰风暴
            {AuraID = 2120 ,UnitID = "target", Caster = "player"},
            -- 深度冻结
            {AuraID = 44572 ,UnitID = "target", Caster = "player"},
            -- 冰冻术
            {AuraID = 33395 ,UnitID = "target", Caster = "pet"},
            --炎爆术(火)
				    {AuraID =  11366, UnitID = "target", Caster = "player"},
				    --龙息术(火)
				    {AuraID =  31661, UnitID = "target", Caster = "player"},
				    --冰霜之环
				    {AuraID =  82691, UnitID = "target", Caster = "player"},
				    --寒冰炸弹
			    	{AuraID = 112948, UnitID = "target", Caster = "player"},
			    	--冰霜之颌
				    {AuraID = 102051, UnitID = "target", Caster = "player"},
         },
      },
   },
   -- 萨满
   ["SHAMAN"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval = 3,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -560, -27},
         List = {
            -- 萨满之怒
            {AuraID = 30823, UnitID = "player"},
            -- 潮汐奔涌
            {AuraID = 53390, UnitID = "player"},
           -- 元素回响
            {AuraID = 159105, UnitID = "player"},
           -- XXXX
            {AuraID = 73920, UnitID = "player"},
            -- 漩涡武器5层
            {AuraID = 53817, UnitID = "player", Stack = 5},
            -- 灵魂行者的恩赐
            {AuraID = 79206, UnitID = "player"},
            {AuraID = 159652, UnitID = "player"},	--神盾雕文
            --熔岩奔腾
				    {AuraID =  77762, UnitID = "player"},
				    --闪电护盾
				    {AuraID =    324, UnitID = "player"},
				    --能量增效
				    {AuraID = 118350, UnitID = "player"},
				    --幽魂步
				    {AuraID =  58875, UnitID = "player"},
				    --风之释放
				    {AuraID =  73681, UnitID = "player"},
				    --强化闪电链
				    {AuraID = 157766, UnitID = "player"},
				    --强化释放
			    	{AuraID = 162557, UnitID = "player"},
			  		--怒火释放
			  		{AuraID = 118470, UnitID = "player"},	--元素
			  		{AuraID = 118472, UnitID = "player"},	--增强
				  	--元素回响
				  	{AuraID = 159101, UnitID = "player"},
			  		--元素冲击
				  	{AuraID = 118522, UnitID = "player"},	--爆击
			  		{AuraID = 173183, UnitID = "player"},	--急速
			  		{AuraID = 173184, UnitID = "player"},	--精通
			  		{AuraID = 173185, UnitID = "player"},	--溅射
			  		{AuraID = 173186, UnitID = "player"},	--敏捷
				  	--星界转移
			  		{AuraID = 108271, UnitID = "player"},
		  			--自然守护者
		  			{AuraID =  30884, UnitID = "player"},
			  		--先祖迅捷
			  		{AuraID =  16188, UnitID = "player"},
			  		--先祖指引
			  		{AuraID = 108281, UnitID = "player"},
			  		--元素掌握
			  		{AuraID =  16166, UnitID = "player"},
			  		--生命释放
			  		{AuraID =  73685, UnitID = "player"},
			  		--火焰释放
			  		{AuraID = 165462, UnitID = "player"},	--元素
			  		{AuraID =  73683, UnitID = "player"},	--增强
			  		--元素融合
			  		{AuraID = 157174, UnitID = "player"},
         },
      },
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 430, 85},
         List = {
            -- 大地震击
            {AuraID = 8042, UnitID = "target", Caster = "player"},
            -- 烈焰震击
            {AuraID = 8050, UnitID = "target", Caster = "player"},
            -- 冰霜震击
            {AuraID = 8056, UnitID = "target", Caster = "player"},
            -- 风暴打击
            {AuraID = 17364, UnitID = "target", Caster = "player"},
            -- 激流
            {AuraID = 61295, UnitID = "target", Caster = "player"},
            -- 大地之盾
            {AuraID = 974, UnitID = "target", Caster = "player"},
            -- 灼热烈焰
            {AuraID = 77661, UnitID = "target", Caster = "player"},
            --冰霜之力
				    {AuraID =  63685, UnitID = "target", Caster = "player"},
				    --束缚元素
				    {AuraID =  76780, UnitID = "target", Caster = "player"},
			    	--妖术
				    {AuraID =  51514, UnitID = "target", Caster = "player"},
				    --陷地图腾
				    {AuraID =  64695, UnitID = "target", Caster = "player"},
				    --电能图腾
				    {AuraID = 118905, UnitID = "target", Caster = "player"},
				    --元素释放(2T16)
				    {AuraID = 144999, UnitID = "target", Caster = "player"},
         },
      },
   },
   -- 圣骑士
   ["PALADIN"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval = 3,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -500, -27},
         List = {
            -- 圣疗术
            {AuraID = 633, UnitID = "player"},
            -- 炙热防御者
            {AuraID = 31850, UnitID = "player"},
            -- 纯洁审判(等级3)
            {AuraID = 53657, UnitID = "player"},
            -- 圣光灌注(等级2)
            {AuraID = 54149, UnitID = "player"},
            -- 神圣恳求
            {AuraID = 54428, UnitID = "player"},
            -- 战争艺术
            {AuraID = 59578, UnitID = "player"},
            -- 异端裁决
            {AuraID = 84963, UnitID = "player"},
            -- 大十字军 (复仇盾)
            {AuraID = 85043, UnitID = "player"},
            -- 神圣使命 (盾击必暴)
            {AuraID = 85433, UnitID = "player"},
            -- 狂热
            {AuraID = 85696, UnitID = "player"},
            -- 荣耀堡垒
            {AuraID = 114637, UnitID = "player"},
            -- 远古列王守卫
            {AuraID = 86659, UnitID = "player"},
            -- 破晓
            {AuraID = 88819, UnitID = "player"},
            -- 正义盾击
            {AuraID = 132403, UnitID = "player"},
            -- 神圣意志
            {AuraID = 90174, UnitID = "player"},
            --自律
				    {AuraID =  25771, UnitID = "player"},
				    --强化神圣震击
				    {AuraID = 160002, UnitID = "player"},
				    --圣洁护盾
				    {AuraID = 148039, UnitID = "player"}, 
				    --大十字军
				    {AuraID =  85416, UnitID = "player"},
				    --神圣十字军
				    {AuraID = 144595, UnitID = "player"},
				    --强化圣印
				    {AuraID = 156990, UnitID = "player"},	--真理
				    {AuraID = 156989, UnitID = "player"},	--正义
				    {AuraID = 156987, UnitID = "player"},	--公正
				    {AuraID = 156988, UnitID = "player"},	--洞察
				    --圣光之速
				    {AuraID =  85499, UnitID = "player"},
				    --无私治愈
				    {AuraID = 114250, UnitID = "player"},
				    --神圣复仇者
				    {AuraID = 105809, UnitID = "player"},
				    --炽天使
				    {AuraID = 152262, UnitID = "player"},
				    --最终审判
				    {AuraID = 157048, UnitID = "player"},
         },
      },
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 430, 85},
         List = {
            -- 制裁之锤
            {AuraID = 853, UnitID = "target", Caster = "player"},
            -- 奉献
            {AuraID = 81298, UnitID = "target", Caster = "player"},
            -- 复仇之盾
            {AuraID = 31935, UnitID = "target", Caster = "player"},
            -- 神圣愤怒
            {AuraID = 2812, UnitID = "target", Caster = "player"},
            -- 超度邪恶
            {AuraID = 10326, UnitID = "target", Caster = "player"},
            -- 忏悔
            {AuraID = 20066, UnitID = "target", Caster = "player"},
				    --制裁之拳
				    {AuraID = 105593, UnitID = "target", Caster = "player"},
				    --圣光救赎
				    {AuraID = 157047, UnitID = "target", Caster = "player"},
				    --洞察道标
				    {AuraID = 157007, UnitID = "target", Caster = "player"},
         },
      },
   },
   -- 牧师
   ["PRIEST"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval = 3,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -500, -27},
         List = {
            -- 消散
            {AuraID = 47585, UnitID = "player"},
            -- 争分夺秒
            {AuraID = 59888, UnitID = "player"},
            -- 妙手回春
            {AuraID = 63735, UnitID = "player"},
            -- 心灵融化
            {AuraID = 73510, UnitID = "player"},
            -- 暗影宝珠
            {AuraID = 77487, UnitID = "player"},
            -- 心灵视界
            {AuraID = 2096, UnitID = "player"},
            -- 脉轮:佑
            {AuraID = 81206, UnitID = "player"},
            -- 脉轮:静
            {AuraID = 81208, UnitID = "player"},
            -- 脉轮:罚
            {AuraID = 81209, UnitID = "player"},
            -- 真言术:障
            {AuraID = 81782, UnitID = "player"},
            -- 恢复
            {AuraID = 139, UnitID = "player"},
            -- 吸血鬼的拥抱
            {AuraID = 15286, UnitID = "player"},
            -- 渐隐术
            {AuraID = 586, UnitID = "player"},
            -- 黑暗福音
            {AuraID = 87118, UnitID = "player"},
            -- 天使长
            {AuraID = 87152, UnitID = "player"},
            -- 黑暗天使长
            {AuraID = 87153, UnitID = "player"},
            -- 福音传播
            {AuraID = 81661, UnitID = "player"},
            -- 圣光涌动(等级1)
            {AuraID = 88688, UnitID = "player"},
            -- 强效暗影
            {AuraID = 95799, UnitID = "player"},
            -- 防护恐惧结界
            {AuraID = 6346, UnitID = "player"},
            -- 心灵尖刺雕文
            {AuraID = 81292, UnitID = "player"},
            -- 精神鞭笞雕文
            {AuraID = 120587, UnitID = "player"},
            --圣光涌动
				    {AuraID = 114255, UnitID = "player"},
				    --神圣洞察
				    {AuraID = 124430, UnitID = "player"},	--暗影
				    {AuraID = 123266, UnitID = "player"},	--戒律
				    {AuraID = 123267, UnitID = "player"},	--神圣
				    --愈合之语
				    {AuraID = 155362, UnitID = "player"},
            -- 真言术:盾(MS)
            {AuraID = 17, UnitID = "player"},
				--天使壁垒
				{AuraID = 114212, UnitID = "player"},
				--幽灵伪装潜行
				{AuraID = 119032, UnitID = "player"},
				--幻影
				{AuraID = 114239, UnitID = "player"},
				--争分夺秒
				{AuraID =  59889, UnitID = "player"},
				--命运多舛
				{AuraID = 123254, UnitID = "player"},
				--灵魂护壳
				{AuraID = 109964, UnitID = "player"},
				--能量灌注
				{AuraID =  10060, UnitID = "player"},
				--愈合之语
				{AuraID = 155363, UnitID = "player"},
				--救赎恩惠
				{AuraID = 155274, UnitID = "player"},
				--天使长
				{AuraID =  81700, UnitID = "player"},
				--宽仁之心，4T16
				{AuraID = 145336, UnitID = "player"},
				--虔诚信仰，2T16
				{AuraID = 145327, UnitID = "player"},
         },
      },
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 430, 85},
         List = {
            -- 暗言术:痛
            {AuraID = 589, UnitID = "target", Caster = "player"},
            -- 噬灵疫病
            {AuraID = 158831, UnitID = "target", Caster = "player"},
            -- 虚弱灵魂
            {AuraID = 6788, UnitID = "target", Caster = "player"},
            -- 精神鞭笞
            {AuraID = 15407, UnitID = "target", Caster = "player"},
            -- 真言术：盾
            {AuraID = 17, UnitID = "target", Caster = "player"},
            -- 沉默
            {AuraID = 15487, UnitID = "target", Caster = "player"},
            -- 防护恐惧结界
            {AuraID = 6346, UnitID = "target", Caster = "player"},
            -- 神圣之火
            {AuraID = 14914, UnitID = "target", Caster = "player"},
            -- 愈合祷言
            {AuraID = 41635, UnitID = "target", Caster = "player"},
            -- 心灵尖啸
            {AuraID = 8122, UnitID = "target", Caster = "player"},
            -- 恢复
            {AuraID = 139, UnitID = "target", Caster = "player"},
            -- 心灵惊骇
            {AuraID = 64044, UnitID = "target", Caster = "player"},
            -- 吸血鬼之触
            {AuraID = 34914, UnitID = "target", Caster = "player"},
            --虚空熵能
				    {AuraID = 155361, UnitID = "target", Caster = "player"},
				    --圣言术：静
				    {AuraID =  88684, UnitID = "target", Caster = "player"},
				    --真言术：慰
				    {AuraID = 129250, UnitID = "target", Caster = "player"},
				    --虚空触须
				    {AuraID = 114404, UnitID = "target", Caster = "player"},
				    --统御意志
				    {AuraID = 	 605, UnitID = "target", Caster = "player"}, 
			    	--意志洞悉
			    	{AuraID = 152118, UnitID = "target", Caster = "player"},
         },
      },
   },
   -- 盗贼
   ["ROGUE"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval = 3,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -500, -27},
         List = {
            --佯攻
            {AuraID = 1966, UnitID = "player"},
            --切割
            {AuraID = 5171, UnitID = "player"},
            --嫁祸诀窍
            {AuraID = 57934, UnitID = "player"},
            --灭绝
            {AuraID = 58427, UnitID = "player"},
            --嫁祸诀窍
            {AuraID = 59628, UnitID = "player"},
            --致命冲动
            {AuraID = 84590, UnitID = "player"},
            --恢复
            {AuraID = 73651, UnitID = "player"},
            --恢复
            {AuraID = 115189, UnitID = "player"},
            --剑刃乱舞
            {AuraID = 13877, UnitID = "player"},
            --冲动
            {AuraID = 13750, UnitID = "player"},
            --疾跑
            {AuraID = 2983, UnitID = "player"},
            --毒化
            {AuraID = 32645, UnitID = "player"},
            --备战就绪
            {AuraID = 74001, UnitID = "player"},
            --暗影斗篷
            {AuraID = 31224, UnitID = "player"},
            --暗影之舞
            {AuraID = 51713, UnitID = "player"},
            --暗影之刃
            {AuraID = 121471, UnitID = "player"},
            --强化宿敌
				    {AuraID = 158108, UnitID = "player"},
            --征服召唤
            {AuraID =102441, UnitID = "player"},
            --破甲
            {AuraID =113746, UnitID = "player"},
            --消失
            {AuraID =11327, UnitID = "player"},
            --杀戮盛宴
            {AuraID =51690, UnitID = "player"},
            --速度爆发
            {AuraID =137573, UnitID = "player"},
            --红灯
            {AuraID = 84745, UnitID = "player"},
            --黄灯
            {AuraID = 84746, UnitID = "player"},
            --绿灯
            {AuraID = 84747, UnitID = "player"},
            --敏锐大师
				    {AuraID =  31665, UnitID = "player"},
            --毒刃：减速
				    {AuraID = 115196, UnitID = "player"},
				    --潜伏帷幕
				    {AuraID = 114018, UnitID = "player"},
				    --盲点
				    {AuraID = 121153, UnitID = "player"},
         },
      },
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 430, 85},
         List = {            
            -- 偷袭
            {AuraID = 1833, UnitID = "target", Caster = "player"},
            -- 肾击
            {AuraID = 408, UnitID = "target", Caster = "player"},
            -- 致盲
            {AuraID = 2094, UnitID = "target", Caster = "player"},
            -- 闷棍
            {AuraID = 6770, UnitID = "target", Caster = "player"},
            -- 割裂
            {AuraID = 1943, UnitID = "target", Caster = "player"},
            -- 锁喉
            {AuraID = 703, UnitID = "target", Caster = "player"},
            -- 凿击
            {AuraID = 1776, UnitID = "target", Caster = "player"},
            -- 破甲
            {AuraID = 8647, UnitID = "target", Caster = "player"},
            -- 拆卸
            {AuraID =51722, UnitID = "target", Caster = "player"},
            --出血
				    {AuraID =  16511, UnitID = "target", Caster = "player"},
				    --死亡标记
				    {AuraID = 137619, UnitID = "target", Caster = "player"},
				    --暗影反射
				    {AuraID = 156745, UnitID = "target", Caster = "player"},
            -- 致命药膏
            {AuraID = 2818, UnitID = "target", Caster = "player"},
            -- 麻痹药膏
            {AuraID = 5760, UnitID = "target", Caster = "player"},
            -- 减速药膏
            {AuraID = 3409, UnitID = "target", Caster = "player"},
            -- 致伤药膏
            {AuraID =13218, UnitID = "target", Caster = "player"},
            -- 要害打击 
            {AuraID =84617, UnitID = "target", Caster = "player"},
            -- 锁喉沉默
            {AuraID = 1330, UnitID = "target", Caster = "player"},
            -- 出血流血伤害
            {AuraID =89775, UnitID = "target", Caster = "player"},
            -- 打劫
            {AuraID =51693, UnitID = "target", Caster = "player"},
            -- 麻醉，无法使用复仇
            {AuraID = 84958, UnitID = "target"},
            -- 洞悉弱点
            {AuraID = 91021, UnitID = "target"},
            -- 头晕
            {AuraID = 79124, UnitID = "target"},
            -- 裁缝网
            {AuraID = 75148, UnitID = "target"},
            -- 裁缝网
            {AuraID = 55536, UnitID = "target"},         
         },
      },      
   },
   -- 武僧
   ["MONK"] = {
      {
         Name = "Spell",
         Direction = "UP", Interval = 3,
         Mode = "BAR", IconSize = 21, BarWidth = 150,
         Pos = {"LEFT", UIParent, "CENTER", -500, -27},
         List = {            
            -- 猛虎之力
            {AuraID = 125359, UnitID = "player"},
            -- 强力金钟罩
            {AuraID = 118636, UnitID = "player"},
            -- 飘渺酒
            {AuraID = 128939, UnitID = "player"},
            -- 酒醒入定
            {AuraID = 115307, UnitID = "player"},
            -- 飘渺酒
            {AuraID = 115308, UnitID = "player"},
            -- 豪能酒
            {AuraID = 115288, UnitID = "player"},
            -- 虎眼酒
            {AuraID = 116740, UnitID = "player"},
            -- 慈悲庇护
            {AuraID = 115213, UnitID = "player"},
            -- 业报之触
            {AuraID = 125174, UnitID = "player"},
            -- 青龙之忱
            {AuraID = 127722, UnitID = "player"},
            -- 禅意珠
            {AuraID = 124081, UnitID = "player"},
            -- 活力之雾
            {AuraID = 118674, UnitID = "player"},
            -- 复苏之雾
            {AuraID = 119611 ,UnitID = "player"},
            -- 和平环
            {AuraID = 116844, UnitID = "player"},
            -- 虎眼酒
            {AuraID = 116740, UnitID = "player"},
            -- 真气突
            {AuraID = 121828, UnitID = "player"},
            -- 禅意飞行
            {AuraID = 125883, UnitID = "player"},
            --翻滚动能
			    	{AuraID = 119085, UnitID = "player"},
			    	--虎眼酒
			    	{AuraID = 125195, UnitID = "player"},
			    	--金创药
			    	--{AuraID = 134563, UnitID = "player"},
				    --力贯千钧
			    	--{AuraID = 129914, UnitID = "player"},
			    	--魂体双分
			    	{AuraID = 101643, UnitID = "player"},
				    --法力茶(奶)
				    {AuraID = 115867, UnitID = "player"},
				    --雷光聚神茶(奶)
				    {AuraID = 116680, UnitID = "player"},
				    --猛虎之力
				    {AuraID = 120273, UnitID = "player"},
				    --迅如猛虎
				    {AuraID = 116841, UnitID = "player"},   
				    --屏气凝神
				    {AuraID = 152173, UnitID = "player"},
				    --青龙之息(奶)
				    {AuraID = 157627, UnitID = "player"},
         },
      },
      {
         Name = "Dot",
         Direction = "UP", Interval = 3,
         Mode = "BAR2", IconSize = 21, BarWidth = 150,
         Pos = {"RIGHT", UIParent, "CENTER", 430, 85},
         List = {
            -- 逍遥酒
            {AuraID = 137562, UnitID = "player"},
            --旭日东升踢
            {AuraID = 130320 ,UnitID = "target", Caster = "player"},
            --嚎镇八方
		        {AuraID = 116189, UnitID = "target", Caster = "player"},
            --分筋错骨
            {AuraID = 115078 ,UnitID = "target", Caster = "player"},
            --切喉手
            {AuraID = 116709 ,UnitID = "target", Caster = "player"},
            --扫堂腿
            {AuraID = 119381 ,UnitID = "target", Caster = "player"},
            --业报之触
            {AuraID = 122470 ,UnitID = "target", Caster = "player"},
            --金刚震（定身）
				    {AuraID = 116706, UnitID = "target", Caster = "player"},
				    --迷醉酒雾
				    {AuraID = 116330, UnitID = "target", Caster = "player"},
				    --醉酿投
				    {AuraID = 121253, UnitID = "target", Caster = "player"},
				    --火焰之熄
				    {AuraID = 123725, UnitID = "target", Caster = "player"},
				    --风火雷电
				    {AuraID = 138130, UnitID = "target", Caster = "player"},
            -- 裁缝网
            {AuraID = 75148, UnitID = "target"},
            -- 裁缝网
            {AuraID = 55536, UnitID = "target"},
            -- 金刚震
            {AuraID = 116095, UnitID = "target"},
            -- 和平环
            {AuraID = 116844, UnitID = "target", Caster = "player"},
         },
      },
   },
} 