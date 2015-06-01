-- Author      : Weeperman
-- Create Date : 29/12/2011

Repz = LibStub("AceAddon-3.0"):NewAddon("Repz", "AceTimer-3.0", "AceEvent-3.0", "AceConsole-3.0")
     
local Repz_last_tick = nil
local Repz_last_gain = 0
local Repz_faction = nil
local Repz_factions = nil
                    
function Repz:OnInitialize()
    Repz:UpdateFactions()
end

function Repz:UpdateFactions()
   -- reset
   Repz_factions = {}
   
   -- update
   for factionIndex = 1, GetNumFactions() do
      name, description, standingId, bottomValue, topValue, earnedValue, atWarWith,
        canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(factionIndex)
        
       local faction = {}                
            faction["name"] = name
            faction["index"] = factionIndex
            faction["description"] = description
            
            table.insert(Repz_factions,faction)
    end
end                    
                    
function Repz:OnEnable()
    self.timerCount = 0
    Repz:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE", "CHAT_MSG_COMBAT_FACTION_CHANGE")
    
    local version = tostring(GetAddOnMetadata("Repz","Version"))        
    Repz_last_tick = time()

    RepzPlusOnly = false       
    Repz:Print(string.format("|cffffffffRepz|cffff9900 %s|cffffffff loaded.", version))  
end


function Repz:CHAT_MSG_COMBAT_FACTION_CHANGE(event, ...)

    if (event=="CHAT_MSG_COMBAT_FACTION_CHANGE") then                           
        local message =  tostring(select(1, ...))

        local increased = true;
        local incpattern = string.gsub(string.gsub(FACTION_STANDING_INCREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
        local lstart, lend, lfaction, lamount = strfind(message, incpattern)
        if lstart == nil then
            local decpattern = string.gsub(string.gsub(FACTION_STANDING_DECREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
            lstart, lend, lfaction, lamount = strfind(message, decpattern)
            increased = false;
        end

        local repGain = 0
        if RepzPlusOnly == true then
            if increased == true then
                repGain = tonumber(lamount)
            end
        else
            repGain = tonumber(lamount)
        end
        
        if (Repz_last_gain < repGain) then
            Repz_last_gain = repGain
            if lFaction == GUILD then
                Repz_faction = GetGuildInfo("player")
            else
                Repz_faction = lfaction
            end            
        end

        -- incase new factions have been identified
        if (GetNumFactions() ~= #Repz_factions) then
            Repz:UpdateFactions()    
        end
        
        if repGain > 0 then
            -- wait 2 seconds to play catch up
            self:ScheduleTimer("RepzTimer", 2)
        end
    end
end


function Repz:RepzTimer()
    local watchedfaction, _, _, _, _ = GetWatchedFactionInfo()  
    if watchedfaction ~= Repz_faction then
        for key,faction in pairs(Repz_factions) do                
            if  faction["name"] == Repz_faction then
                SetWatchedFactionIndex(faction["index"])                    
            end        
        end
    end
    
    -- reset the last gain/faction
    Repz_last_gain = 0
    Repz_faction = nil   
    
    self:CancelAllTimers()    
end


