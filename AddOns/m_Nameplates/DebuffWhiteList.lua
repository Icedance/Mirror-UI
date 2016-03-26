local addon, ns = ...
local DebuffWhiteList = {        --DEBUFF白名单（不在下面列表的全部不显示）

	
		[GetSpellInfo(157736)] = true, ----献祭
		[GetSpellInfo(80240)] = true,----浩劫
		[GetSpellInfo(30108)] = true,----无常
		[GetSpellInfo(980)] = true,----痛楚
		[GetSpellInfo(172)] = true,----腐蚀术
		[GetSpellInfo(27243)] = true,----种子
		[GetSpellInfo(114790)] = true,----灵魂燃烧种子
		[GetSpellInfo(48181)] = true,----放逐
		[GetSpellInfo(5782)] = true,----恐惧
		[GetSpellInfo(47960)] = true,----古手
		[GetSpellInfo(603)] = true,----厄运诅咒
		[GetSpellInfo(124915)] = true,----混乱波




		[GetSpellInfo(589)] = true,----痛
		[GetSpellInfo(15487)] = true,----沉默
		[GetSpellInfo(34914)] = true,----吸血鬼之触
		[GetSpellInfo(158831)] = true,----噬灵瘟疫

		[GetSpellInfo(164812)] = true,----月火
		[GetSpellInfo(164815)] = true,----阳炎

		[GetSpellInfo(112948)] = true,----寒冰炸弹
		[GetSpellInfo(12654)] = true,----点燃


		[GetSpellInfo(8050)] = true,----烈焰震击

		[GetSpellInfo(44457)] = true,----活动炸弹

		[GetSpellInfo(55078)] = true,----血疾病
		[GetSpellInfo(55095)] = true,----冰疾病
		[GetSpellInfo(155159)] = true,----死疽 


		[GetSpellInfo(31803)] = true,----责罚

		[GetSpellInfo(3674)] = true,----黑箭
		[GetSpellInfo(162546)] = true,----寒冰弹
		[GetSpellInfo(118253)] = true,----毒蛇钉刺


		[GetSpellInfo(2818)] = true,----致命毒药
		[GetSpellInfo(122233)] = true,----猩红风暴
		[GetSpellInfo(1943)] = true,----割裂
		[GetSpellInfo(155722)] = true,----斜掠

}
ns.DebuffWhiteList = DebuffWhiteList