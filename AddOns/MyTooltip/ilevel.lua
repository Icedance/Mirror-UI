-- credits to Ray @ ngacn.cc
local gtt = GameTooltip
local ILEVEL

if GetLocale() == "zhCN" then
	ILEVEL = "装备等级："
elseif GetLocale() == "zhTW" then
	ILEVEL = "裝備等級: "
else
	ILEVEL = "iLevel: "
end

-- 物品等级
local Quality = {
	[500] = {
		["Red"] = { ["A"] = 0.94, ["B"] = 400, ["C"] = 0.0006, ["D"] = 1 },
		["Green"] = { ["A"] = 0.47, ["B"] = 400, ["C"] = 0.0047, ["D"] = -1 },
		["Blue"] = { ["A"] = 0, ["B"] = 0, ["C"] = 0, ["D"] = 0 },
	},
	[400] = {
		["Red"] = { ["A"] = 0.94, ["B"] = 300, ["C"] = 0.0006, ["D"] = 1 },
		["Green"] = { ["A"] = 0.47, ["B"] = 300, ["C"] = 0.0047, ["D"] = -1 },
		["Blue"] = { ["A"] = 0, ["B"] = 0, ["C"] = 0, ["D"] = 0 },
	},
	[300] = {
		["Red"] = { ["A"] = 0.69, ["B"] = 200, ["C"] = 0.0025, ["D"] = 1 },
		["Green"] = { ["A"] = 0.28, ["B"] = 200, ["C"] = 0.0019, ["D"] = 1 },
		["Blue"] = { ["A"] = 0.97, ["B"] = 200, ["C"] = 0.0096, ["D"] = -1 },
	},
	[200] = {
		["Red"] = { ["A"] = 0.0, ["B"] = 100, ["C"] = 0.0069, ["D"] = 1 },
		["Green"] = { ["A"] = 0.5, ["B"] = 100, ["C"] = 0.0022, ["D"] = -1 },
		["Blue"] = { ["A"] = 1, ["B"] = 100, ["C"] = 0.0003, ["D"] = -1 },
	},
	[100] = {
		["Red"] = { ["A"] = 0.12, ["B"] = 0, ["C"] = 0.0012, ["D"] = -1 },
		["Green"] = { ["A"] = 1, ["B"] = 0, ["C"] = 0.0050, ["D"] = -1 },
		["Blue"] = { ["A"] = 0, ["B"] = 0, ["C"] = 0.01, ["D"] = 1 },
	},
}

local function GetItemScore(iLink)
   local _, _, itemRarity, itemLevel, _, _, _, _, itemEquip = GetItemInfo(iLink);
   itemLevel = itemLevel or 0
   if (IsEquippableItem(iLink)) then
      if not (itemLevel > 1) and (itemRarity > 1) then
      return 0;
      end
   end
   return itemLevel;
end

local function GetPlayerScore(unit)
   local ilvl, ilvlAdd, equipped = 0, 0, 0;
   if (UnitIsPlayer(unit)) then
      --local _, targetClass = UnitClass(unit);
      for i = 1, 17 do
         if (i ~= 4) then
            local iLink = GetInventoryItemLink(unit, i);
            if (iLink) then
               ilvlAdd = GetItemScore(iLink);
               ilvl = ilvl + ilvlAdd;
               equipped = equipped + 1;
            end
         end
      end
   end
   ClearInspectPlayer();
   return floor(ilvl / equipped);
end

local function GetQuality(ItemScore)
	if ( ItemScore > 499 ) then ItemScore = 499; end
	local Red = 0.1; local Blue = 0.1; local Green = 0.1
   	if not ( ItemScore ) then return 0, 0, 0 end
	for i = 0,5 do
		if ( ItemScore > i * 100 ) and ( ItemScore <= ( ( i + 1 ) * 100 ) ) then
		    local Red = Quality[( i + 1 ) * 100].Red["A"] + (((ItemScore - Quality[( i + 1 ) * 100].Red["B"])*Quality[( i + 1 ) * 100].Red["C"])*Quality[( i + 1 ) * 100].Red["D"])
            local Blue = Quality[( i + 1 ) * 100].Green["A"] + (((ItemScore - Quality[( i + 1 ) * 100].Green["B"])*Quality[( i + 1 ) * 100].Green["C"])*Quality[( i + 1 ) * 100].Green["D"])
            local Green = Quality[( i + 1 ) * 100].Blue["A"] + (((ItemScore - Quality[( i + 1 ) * 100].Blue["B"])*Quality[( i + 1 ) * 100].Blue["C"])*Quality[( i + 1 ) * 100].Blue["D"])
			--if not ( Red ) or not ( Blue ) or not ( Green ) then return 0.1, 0.1, 0.1, nil; end
			return Red, Green, Blue
		end
	end
	return 0.1, 0.1, 0.1
end

local _, unit

local function UpdateScore()
	local unitilvl = GetPlayerScore(unit);
		--print(unitilvl)
	if (unitilvl > 1) then
		local Red, Blue, Green = GetQuality(unitilvl)
		gtt:AddLine(ILEVEL..unitilvl, Red, Green, Blue)
		gtt:Show()
	end
end

local eventframe = CreateFrame'Frame'

eventframe:SetScript("OnEvent", function(self)
   self:UnregisterEvent"INSPECT_READY"
   UpdateScore()
end)

local function SetUnit()
	_, unit = gtt:GetUnit();
  eventframe:RegisterEvent"INSPECT_READY"
	if not (unit) or not (UnitIsPlayer(unit)) or not (CanInspect(unit)) then
	  return;
	elseif (UnitIsUnit(unit,"player")) then
		unit = "player"
		UpdateScore()
	elseif not (InspectFrame and InspectFrame:IsShown()) then
		--print("Start Inspetct", unit)
	    NotifyInspect(unit)
	end
end
gtt:HookScript("OnTooltipSetUnit",SetUnit)