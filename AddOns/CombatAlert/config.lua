local _, ns = ...
--如需要显示中文，请注意文件编码格式UTF-8
ns.setting = {
	EnableExecute = true,	--开启斩杀提示
	OnlyShowBoss = false,	--仅显示Boss的斩杀提示
	AutoThreshold = true,	--根据职业自动判断斩杀阶段
	ExecuteThreshold = 0.2, --斩杀阶段血量
}

ns.texts = {
	EnterCombat = {
--		"擦，进战斗了！",
		"进入战斗！",
--		"开始战斗了哦，亲",
--		"有刺客！",
		},
	LeaveCombat = {
--		"终于逃掉了",
		"脱离战斗！",
--		"搞定！",
		},
	ExecutePhase = {
		"斩杀！",
--		"搞死你丫的！",
--		"给我去死吧！",
		},
    Hplow = {
        "低血量",
        },   
    Mplow = {
        "法力值过低",
        },      
}

ns.class = {
   ["WARRIOR"] = { 0.2, 0.2, 0}, --每个职业每个天赋的斩杀阶段血量，统计可能不准确，0即为不显示，3个数字依次是3系天赋
   ["DRUID"] = { 0, 0.25, 0.25},
   ["PALADIN"] = { 0, 0, 0.2},
   ["PRIEST"] = { 0, 0, 0.25},
   ["DEATHKNIGHT"] = { 0, 0.45, 0.45},
   ["WARLOCK"] = { 0.2, 0.25, 0.2},
   ["ROGUE"] = { 0.35, 0, 0},
   ["HUNTER"] = { 0.2, 0.2, 0.2},
   ["MAGE"] = { 0.2, 0.35, 0.2},
   ["SHAMAN"] = { 0, 0, 0},   
}