--[[
@author 图图
设计目标：
    1. 正确&漂亮的显示经验/声望（显示样式参考mirror的saft）
    2. 不满级时，文字提示为经验相关
    3. 满级时，文字提示为声望相关，经验不显示，没追踪则不显示~
    4. 鼠标移上去时，提示内容为：阵营：%FACTION%  \n  %RANK%  \n  value/Max
    5. 鼠标点击时，弹出菜单：发送经验/声望->小队、工会、团队、目标
]]
-----------------------------------常/变 量------------------------------------
local addon, addonData = ...
local anchors={
    {"TOPLEFT", ActionButton1, "BOTTOMLEFT", -2, -49 }, --左上角锚点
    {"TOPRIGHT", MultiBarBottomRightButton12, "BOTTOMRIGHT", 0, -49 } --右上角锚点
}
TuBarCfg = {}
local cfg = TuBarCfg
local barHeight = 5
barHeight = floor(barHeight/2)*2+1 --将barHeight限定为不比原来小的奇数（顶边，中间，底边各有一个像素的变框）
if barHeight < 5 then barHeight = 5 end --最小5px
local texPath="Interface\\Buttons\\WHITE8x8"
local sparkPath="Interface\\CastingBar\\UI-CastingBar-Spark"
local backdrop={bgFile = texPath, edgeFile = texPath, edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1}}
-----------------------------------公共函数------------------------------------
--获取实际的声望数据（归一化保镖数据）--Author:图图
--@return name, rank, min, max, value, color
function GetRealFactionInfo()
    local facRanks={"仇恨","敌对","冷淡","中立","友善","尊敬","崇敬","崇拜"}
    local name, rank, min, max, value, facID = GetWatchedFactionInfo()
    name = (facID==1168 and "公会" or name)
    local color = FACTION_BAR_COLORS[rank]
    rank = facRanks[rank]
    --判断是否保镖~friendshipID==nil则是一般声望，否则是保镖
    local friendshipID = GetFriendshipReputation(facID);
    if friendshipID then
        local _, curRep, _, fName, desc, _, rankText, fMin, fMax = GetFriendshipReputation(facID);
        if (fMax) then
            min, max, value = fMin, fMax, curRep;
        else--如果朋友关系达到最大，则取不到值，颜色取00ffff（与系统一致）
            min, max, value = 0, 1, 1;
        end
        rank = rankText; -- 保镖声望等级重定向
        color = FACTION_BAR_COLORS[5] --人物类的声望颜色固定绿色（与系统一致）
    end
    return name, rank, min, max, value, color
end
--获取经验值
function GetXP()
    local XP, maxXP = UnitXP("player"), UnitXPMax("player")
    local restXP = GetXPExhaustion()
    local perXP = floor(XP/maxXP*100)
    local perRest
    if restXP then
        perRest = floor(restXP/maxXP*100)
    end
    return XP,maxXP,restXP,perXP,perRest
end
--创建经验条
local function CreateBar(name, layer, w, h)
    local bar = TuXP_Box:CreateTexture(name, layer or "OVERLAY")
    bar:SetTexture(texPath)
    bar:SetSize(w, h)
    local spark = TuXP_Box:CreateTexture(nil, "OVERLAY")
    spark:SetTexture(sparkPath)
    spark:SetBlendMode("ADD")
    spark:SetAlpha(.8)
    spark:SetPoint("TOPLEFT", bar, "TOPRIGHT", -5, 7)
    spark:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 5, -7)
    return bar
end
--设置是否显示
local function SetVisible(bar, visible)
    if bar == Tu_Rep then
        bar:SetPoint("BOTTOMLEFT", visible and TuXP_Box or UIParent, 1, visible and 1 or -100)
    else
        bar:SetPoint("TOPLEFT", visible and TuXP_Box or UIParent, 1, visible and -1 or 100)
    end
end
--设置数据
local function SetValue(bar, v, max)
    local totalWidth = TuXP_Box:GetWidth() - 2;
    local barWidth = totalWidth * v / max;
    bar:SetWidth(barWidth)
end
function formatColor(color)
    return (string.format("%02x%02x%02x", color.r*255, color.g*255, color.b*255))
end
-----------------------------------事 件  响 应------------------------------------
function onEvent(self, evt, addonName)
    if evt == "ADDON_LOADED" and string.upper(addonName) == string.upper(addon) then
        cfg = TuBarCfg
        if cfg.showText ==nil then cfg.showText=false end --默认不显示
    end
    local isMaxLevel = (UnitLevel("player") == MAX_PLAYER_LEVEL)
    --print("---onEvent---")
    if GetWatchedFactionInfo() then--追踪了声望
        SetVisible(Tu_Rep, true)
        TuXP_Box.repText:Show()
        local name, rank, min, max, value, color = GetRealFactionInfo()
        --print("v/min/max = "..value.."/"..min.."/"..max)
        SetValue(Tu_Rep, value-min, max-min)
        Tu_Rep:SetVertexColor(color.r, color.g, color.b)
        TuXP_Box.repText:SetText(cfg.showText and string.format('%s: %s/%s (%d%%)', name, value-min, max-min, (value-min)/(max-min)*100) or "")
        --Tu_Rep:SetPoint("BOTTOMLEFT", TuXP_Box, 1,1)    --显示声望条
        if isMaxLevel then
            TuXP_Box:Show()
            SetVisible(Tu_XP, false)  --隐藏经验
            TuXP_Box.expText:SetText("")
            SetVisible(Tu_RestXP, false)
            Tu_Rep:SetHeight(barHeight-2)
            TuXP_Box.repText:SetPoint("CENTER", 0, 0)
        else
            local XP,maxXP,restXP,perXP,perRest = GetXP()
            SetVisible(Tu_XP, true)
            SetVisible(Tu_RestXP, true)
            SetValue(Tu_XP, XP, maxXP)
            SetValue(Tu_RestXP, perRest and (perRest>100 and maxXP or restXP) or XP, maxXP)
            TuXP_Box.expText:SetText(cfg.showText and string.format('%s/%s (%d%%)', XP, maxXP, perRest or 0) or "")
            TuXP_Box.expText:SetPoint("CENTER",TuXP_Box,"LEFT",TuXP_Box:GetWidth()/3,0)
            TuXP_Box.repText:SetPoint("CENTER",TuXP_Box,"RIGHT",-TuXP_Box:GetWidth()/3,0)
            Tu_XP:SetHeight((barHeight-3)/2)
            Tu_RestXP:SetHeight((barHeight-3)/2)
            Tu_Rep:SetHeight((barHeight-3)/2)
        end
    else    
        SetVisible(Tu_Rep, false)
        TuXP_Box.repText:SetText("")
        --Tu_Rep:SetPoint("BOTTOMLEFT", TuXP_Box, 1,1)    --显示声望条
        if isMaxLevel then
            TuXP_Box:Hide()
            TuXP_Box.expText:SetText("")
            SetVisible(Tu_XP, false)
            SetVisible(Tu_RestXP, false)
            Tu_Rep:SetHeight(barHeight-2)
        else
            local XP,maxXP,restXP,perXP,perRest = GetXP()
            SetVisible(Tu_XP, true)
            SetVisible(Tu_RestXP, true)
            SetValue(Tu_XP, XP, maxXP)
            SetValue(Tu_RestXP, perRest and (perRest>100 and maxXP or restXP) or XP, maxXP)
            TuXP_Box.expText:SetText(cfg.showText and string.format('%s/%s (%d%%)', XP, maxXP, perRest or 0) or "")
            TuXP_Box.expText:SetPoint("CENTER",0,0)
            Tu_XP:SetHeight(barHeight-2)
            Tu_RestXP:SetHeight(barHeight-2)
        end
    end
end
-----------------------------------基本资源创建------------------------------------
CreateFrame("Frame", "TuXP_Box", UIParent)
TuXP_Box:SetHeight(barHeight)
for i=1,#anchors do
    TuXP_Box:SetPoint(unpack(anchors[i]))
end
--设置容器背景、颜色、边框
TuXP_Box:SetBackdrop(backdrop)
TuXP_Box:SetBackdropColor(0, 0, 0, 0.5)
TuXP_Box:SetBackdropBorderColor(0,0,0)
TuXP_Box:SetFrameLevel(1)
--创建经验条
TuXP_Box.rest=CreateBar("Tu_RestXP", "OVERLAY", 510,3)
TuXP_Box.rest:SetPoint("TOPLEFT", 1,-1)
TuXP_Box.rest:SetVertexColor(0, .4, .8)
TuXP_Box.xp=CreateBar("Tu_XP", "OVERLAY", 360,3)
TuXP_Box.xp:SetPoint("TOPLEFT", 1,-1)
TuXP_Box.xp:SetVertexColor(0.5, 0, .75)
TuXP_Box.rep=CreateBar("Tu_Rep", "OVERLAY", 480,3)
TuXP_Box.rep:SetPoint("BOTTOMLEFT", 1,1)
TuXP_Box.rep:SetVertexColor(.3, 1, .3)
--文字提示
TuXP_Box.expText=TuXP_Box:CreateFontString("TuXP_expText", "OVERLAY")
TuXP_Box.expText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
TuXP_Box.repText=TuXP_Box:CreateFontString("TuXP_repText", "OVERLAY")
TuXP_Box.repText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
--事件注册
TuXP_Box:RegisterEvent("PLAYER_LEVEL_UP")--升级
TuXP_Box:RegisterEvent("PLAYER_XP_UPDATE")--得到经验
TuXP_Box:RegisterEvent("UPDATE_EXHAUSTION")--双倍变化
TuXP_Box:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")--声望
TuXP_Box:RegisterEvent("UPDATE_FACTION")--声望
TuXP_Box:RegisterEvent("ADDON_LOADED")
TuXP_Box:SetScript("OnEvent", onEvent)
TuXP_Box:SetScript("OnEnter", function()
    GameTooltip:SetOwner(TuXP_Box, "ANCHOR_TOP", -3, barHeight) --经验条鼠标提示位置
    GameTooltip:ClearLines()
    if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
        local XP,maxXP,restXP,perXP,perRest = GetXP()
        --GameTooltip:AddLine("")
        GameTooltip:AddLine(string.format("当前经验：%s/%s (%d%%)", XP, maxXP, perXP))
        GameTooltip:AddLine(string.format("双倍经验：%s%%", restXP or 0))
        GameTooltip:AddLine(string.format("剩余经验：%s%%", 100-perXP))
        if restXP then
            GameTooltip:AddLine(string.format('|cffb3e1ff双倍经验: %s (%d%%)', restXP, perRest))
        end
    end
    if GetRealFactionInfo() then
        local name, rank, min, max, value,color = GetRealFactionInfo()
        --GameTooltip:AddLine(" ")
        GameTooltip:AddLine(string.format('当前声望: %s', name))
        GameTooltip:AddLine(string.format('声望等级: |cff%s%s|r',formatColor(color), rank))
        GameTooltip:AddLine(string.format('声望: %s/%s (%d%%)', value-min, max-min, (value-min)/(max-min)*100))
        GameTooltip:AddLine(string.format('剩余: %s', max-value))
    end
    GameTooltip:Show()
end)
TuXP_Box:SetScript("OnLeave", function() GameTooltip:Hide() end)
--弹出菜单：发送经验/声望
function sendReport(isExp, target)
    if isExp then 
        local XP,maxXP,restXP,perXP,perRest = GetXP()
        SendChatMessage("当前等级："..UnitLevel("player").."，当前经验值: "..XP.."/"..maxXP.." ("..perXP.."%)"..(restXP and (", 双倍经验"..perRest.."%.") or ", 无双倍经验."), target, nil, target == "whisper" and UnitName("target") or nil)
    else
        local name, rank, min, max, value = GetRealFactionInfo()
        SendChatMessage(name.." 声望: "..rank..", "..(value-min).."/"..(max-min).." ("..floor((value-min)/(max-min)*100).."%).", target, nil, target == "whisper" and UnitName("target") or nil)
    end
end
local reportFrame = CreateFrame("Frame", "TuXP_ReportMenu", UIParent)
TuXP_Box:SetScript("OnMouseUp", function(self, btn)
    local index = 2
    local menu = {{ text = "发送", isTitle = true,notCheckable = true}}
    local inParty = (GetNumSubgroupMembers() > 0)
    local inGuild = IsInGuild()
    local inRaid = (GetNumGroupMembers()>0)
    local hasTarget = (UnitIsPlayer("target") and not UnitIsEnemy("player", "target"))
    if (UnitLevel("player") ~= MAX_PLAYER_LEVEL) then
        menu[index]={ text = "经验到", hasArrow = true, notCheckable = true,
            menuList = {
                { text = "队伍", notCheckable = true, func = function()sendReport(true, "PARTY")end ,disabled = not inParty},
                { text = "公会", notCheckable = true, func = function()sendReport(true, "guild")end ,disabled = not inGuild},
                { text = "团队", notCheckable = true, func = function()sendReport(true, "raid")end ,disabled = not inRaid},
                { text = "目标", notCheckable = true, func = function()sendReport(true, "whisper")end ,disabled = not hasTarget}
            } 
        }
        index = index + 1
    end
    if GetWatchedFactionInfo() then
        menu[index]={ text = "声望到", hasArrow = true, notCheckable = true,
            menuList = {
                { text = "队伍", notCheckable = true, func = function()sendReport(false, "party")end ,disabled = not inParty},
                { text = "公会", notCheckable = true, func = function()sendReport(false, "guild")end ,disabled = not inGuild},
                { text = "团队", notCheckable = true, func = function()sendReport(false, "raid")end ,disabled = not inRaid},
                { text = "目标", notCheckable = true, func = function()sendReport(false, "whisper")end ,disabled = not hasTarget}
            } 
        }
        index = index + 1
    end
    menu[index]={text="提示文字", checked = cfg.showText, func=function() cfg.showText = not cfg.showText;onEvent() end}
    if btn == "RightButton" then
        EasyMenu(menu, reportFrame, "cursor", 0, 0, "menu", 2)
    end
end)
--print("-----------|cffff3333Tutu的经验条加载结束|r-----------")