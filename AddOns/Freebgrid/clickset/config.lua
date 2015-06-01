local ADDON_NAME, ns = "Freebgrid", Freebgrid_NS

local L = ns.Locale

local macroedit = {
	hidden = true,
	path = nil,
	path1 = nil,
}
local defaultvalues = {
	["NONE"] = L.none,
	["target"] = L.target,
	["menu"] = L.menu,
	["follow"] = L.follow,
	["macro"] = L.macro,
}
local default_spells = {
	PRIEST = { 	
			17,			--"真言术:盾",
			139,			--"恢复",
			527,			--"纯净术",
			528,			--"驱散魔法",
			596,			--"治疗祷言",
			1706,			--"漂浮术",
			2096,			--"心灵视界",
			2006,			--"复活术",
			2060,			--"治疗术",
			2061,			--"快速治疗",
			6346,			--"防护恐惧结界",
			21562,			--"真言术:韧",
			32546,			--"联结治疗",	
			33076,			--"愈合祷言",
			33206,			--"痛苦压制",
			34861,			--"治疗之环",
			47540,			--"苦修",
			47788,			--"守护之魂",
			48045,			--"精神灼烧",		
			73325,			--"信仰飞跃",
			88684,			--"圣言术:静",
			108968,			--"虚空转移",
			121135,			--"瀑流",
			126123,			--"忏悔",
			152116,			--"救赎恩惠",
			152118,			--"意志洞悉",
			155245,			--"清晰使命",
	},
	
	DRUID = { 
			774,			--"回春術",
			1126,			--"野性印记",
			2782,			--"净化腐蚀",
			5185,			--"治疗之触",
			8936,			--"癒合",
			18562,			--"迅捷治愈",
			20484,			--"复生",
			33763,			--"生命绽放",
			48438,			--"野性成长",
			50769,			--"起死回生",
			88423,			--"自然之愈",
			102342,			--"铁木树皮"
			102351,			--"塞纳里奥结界"
			102401,			--"野性冲锋"
			145205,			--"野性蘑菇"
	},
	SHAMAN = { 
			546,			--"水上行走",
			974,			--"大地之盾",
			1064,			--"治疗链",
			2008,			--"先祖之魂",
			8004,			--"治疗之涌",
			51886,			--"净化灵魂",
			61295,			--"激流",
			73685,			--"生命释放",
			77130,			--"净化灵魂(恢复)"
			77472,			--"治疗波",
	},

	PALADIN = { 
			633,			--"圣疗术",
			1022,			--"保护之手",
			1038,			--"拯救之手",
			1044,			--"自由之手",
			4987,			--"清洁术",
			6940,  			--"牺牲之手",
			7328,			--"救赎",
			19740,			--"力量祝福",
			19750,			--"圣光闪现",
			20217,			--"王者祝福",
			20473,			--"神圣震击",
			20925,			--"圣洁护盾",
			53563,			--"圣光信标",
			82326,			--"圣光术",
			82327,			--"圣光普照"
			85673,			--"荣耀圣令",
			114039,			--"纯净之手",			
			114157,			--"处决宣判",
			114163,			--"永恒之火",
			114165,			--"神圣棱镜",
			156910,			--"信仰道标",
			157007,			--"洞察道标",
	},

	WARRIOR = { 
			3411,			--"援护",
			114029,			--"捍卫",
			114030,			--"警戒",
	},

	MAGE = { 
			130,			--"缓落",
			475,			--"解除詛咒",
			1459,			--"秘法智力",
			61316,			--"达拉然光辉",
			111264,			--"寒冰结界"
	},

	WARLOCK = { 
			5697,			--"无尽呼吸",
			20707,			--"灵魂石",
			89808,			--"烧灼驱魔(小鬼)",
			109773,			--"黑暗意图",
			115276,			--"烧灼驱魔(邪能小鬼)",
			119898,			--"恶魔掌控(烧灼驱魔)",
			171021,			--"灼烧魔法(地狱火)",
			171023,			--"炽燃魔法(深渊魔)",
	},
	
	MONK = { 	
			115098,			--"真气波",
			115178,			--"轮回转世",
			115450,			--"化瘀术",
			115151,			--"复苏之雾",
			115175,			--"抚慰之雾",
			115921,			--"帝王传承",
			116670,			--"振魂引",
			116781,			--"白虎传承",
			116844,			--"平静之环"
			116849,			--"做茧缚命",
			116694,			--"升腾之雾",
			116841,			--"迅猛如虎",
			124081,			--"禅意珠",
			124682,			--"氤氲之雾",
			157675,			--"真气破",
			147489,			--"移花接木",
	},

	HUNTER = { 
			34477,			--"误导",
			53271,      		--"主人的召唤"
			53480,			--"牺牲咆哮"
	},
	
	ROGUE = { 
			36554,			--"暗影步",
			57934,			--"栽赃嫁祸",
	},
	
	DEATHKNIGHT = {
			47541,			--"凋零缠绕",
			61999,			--"复活盟友",
			108199,			--"血魔之握",
	},
}

local SetClickKeyvalue = function(info,value)
	--local index = string.sub(info,string.find(info,"%d"))
	local index = string.sub(info,-1)
	if index then
		local val = string.gsub(info, "z", "-")
		local name = val
		val = string.gsub(val, "type%d", "", 1)
		if val == "" then val = "Click" end

		if value == "macro" then
			ns.db.ClickCast[index][val]["action"] = "macro"
			macroedit.hidden = false
			macroedit.path = index
			macroedit.path1 = val
		else
			ns.db.ClickCast[index][val]["action"] = value
			macroedit.hidden = true
			macroedit.path =nil
			macroedit.path1 =nil

		end
	end
end		

local GetClickKeyvalue = function(info)
	local index = string.sub(info,-1)
	--local index = string.sub(info,string.find(info,"%d"))
	local value = ""
	if index then
		local val = string.gsub(info, "z", "-")
		val = string.gsub(val, "type%d", "", 1)
		if val == "" then val = "Click" end
		value = ns.db.ClickCast[index][val]["action"]
	end
	return value
end		

local function setDefault(src, dest)
	if type(dest) ~= "table" then dest = {} end
	if type(src) == "table" then
		for k,v in pairs(src) do
			
			if type(v) == "table" then
				v = setDefault(v, dest[k])
			end
			dest[k] = v
		end
	end
	return dest
end

if type(ns.options) ~= "table" then
	ns.options = {
		type = "group", name = ADDON_NAME,
		get = function(info) return ns.db[info[#info]] end,
		set = function(info, value) ns.db[info[#info]] = value end,
		args={}
	}
end
ns.options.args.ClickCast = {
    type = "group",
	name = L.ClickCast, 
	childGroups = "select",
	get = function(info) return GetClickKeyvalue(info[#info]) end,
	set = function(info, value) SetClickKeyvalue(info[#info], value) end,
	args = {
		enable = {
			name = L.enable,
			type = "toggle",
			order = 1,
			width  = "full",
			desc = L.ClickCastdesc,
			get = function(info) return ns.db.ClickCast.enable end,
			set = function(info,val) ns.db.ClickCast.enable = val;end,
			},
		SetDefault = {
			name = L.SetDefault,
			type = "execute",
			func = function() setDefault(ns.defaults.ClickCast, ns.db.ClickCast);ns:ApplyClickSetting(); end,
			order = 2,
			desc = L.SetDefaultdesc,
			},
		apply = {
			name = L.ClickCastapply,
			type = "execute",
			func = function() ns:UpdateClickCastSet(); end,
			order = 3,
			desc = L.ClickCastapplydesc,
			},
		downclick = {
            name = L.downclick,
            type = "toggle",
            order = 4,
			disabled = function() return not ns.db.ClickCast.enable end,
            get = function(info) return ns.db.ClickCast.downclick end,
			set = function(info,val) ns.db.ClickCast.downclick = val; ns:UpdateClickCastSet();end,
        },
		CSGroup1 = {
			order = 5,
			type = "group",
			name = L.type1 ,		
			disabled = function() return not ns.db.ClickCast.enable end,
			args = {
				type1 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype1 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues						
				},
				ctrlztype1 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype1 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype1 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype1 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype1 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup2 = {
			order = 6,
			type = "group",
			name = L.type2 ,			
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type2 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype2 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues				
				},
				ctrlztype2 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype2 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype2 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype2 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype2 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup3 = {
			order = 7,
			type = "group",
			name = L.type3 ,			
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type3 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype3 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues					
				},
				ctrlztype3 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype3 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype3 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype3 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype3 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup4 = {
			order = 8,
			type = "group",
			name = L.type4 ,		
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type4 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype4 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues						
				},
				ctrlztype4 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype4 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype4 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype4 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype4 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		CSGroup5 = {
			order = 9,
			type = "group",
			name = L.type5 ,			
			disabled = function() return not ns.db.ClickCast.enable end,	
			args = {
				type5 = {
					order = 1,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				shiftztype5 = {
					order = 2,
					type = "select",
					name = "" ,
					values = defaultvalues					
				},
				ctrlztype5 = {
					order = 3,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altztype5 = {
					order = 4,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzctrlztype5 = {
					order = 5,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				altzshiftztype5 = {
					order = 6,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
				ctrlzshiftztype5 = {
					order = 7,
					type = "select",
					name = "" ,
					values = defaultvalues
				},
			},
		},
		macro = {
				order = 10,
				type = "input",
				width  = "full",
				multiline  = true,
				name = function(info)
				if macroedit.path then
					return macroedit.path1.."-"..macroedit.path.." "..L.ClickCastmacro
				else
					return ""			
				end	end,
				hidden =  function() return macroedit.hidden end,				
				desc = L.ClickCastmacrodesc,
				get = function(info) 
				if macroedit.path then 
					return ns.db.ClickCast[macroedit.path][macroedit.path1]["macrotext"] 
				else 
					return "" 
				end end,
				set = function(info,val)
					ns.db.ClickCast[macroedit.path][macroedit.path1]["macrotext"] = val
					macroedit.hidden = true
					ns:ApplyClickSetting() 
				end,
		},
    },	
}

local class = select(2, UnitClass("player"))
for _, v in pairs(default_spells[class]) do	--创建职业默认技能表
	local spellname = GetSpellInfo(v)	
	if spellname then
		defaultvalues[tostring(spellname)] = spellname
	end
end

for i = 1, 5 do	--设置下拉菜单
	local path = ns.options.args.ClickCast["args"]["CSGroup"..tostring(i)]["args"]
	for k, _ in ipairs (path) do
		path[k]["values"] = defaultvalues
	end
end

local getclickargsname = function(var)
	local v = string.gsub(var, "z", " + ")
	local ktype = L[string.match(v, "type%d")]		
	local name = string.gsub(v, "type%d", "")..ktype

	return name
end	

for i = 1, 5 do	--设置名称
	local path = ns.options.args.ClickCast["args"]["CSGroup"..tostring(i)]["args"]
	for k, _ in pairs (path) do
		path[k]["name"] = getclickargsname(k)
	end
end
