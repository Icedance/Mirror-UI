function SetUnitAura_handler(self, unitId, auraIndex, filter)
    _, _, _, _, _, _, _, unitCaster, _ = UnitAura(unitId, auraIndex, filter)
    if unitCaster then
        GameTooltip:AddLine(UnitName(unitCaster), 0.2, 0.8, 0.2)
        GameTooltip:Show()
    end
end

function SetUnitDebuff_handler(self, unitId, auraIndex, filter)
    _, _, _, _, _, _, _, unitCaster, _ = UnitDebuff(unitId, auraIndex, filter)
    if unitCaster then
        GameTooltip:AddLine(UnitName(unitCaster), 0.2, 0.8, 0.2)
        GameTooltip:Show()
    end
end

function SetUnitBuff_handler(self, unitId, auraIndex, filter)
    _, _, _, _, _, _, _, unitCaster, _ = UnitBuff(unitId, auraIndex, filter)
    if unitCaster then
        GameTooltip:AddLine(UnitName(unitCaster), 0.2, 0.8, 0.2)
        GameTooltip:Show()
    end
end

hooksecurefunc(GameTooltip, "SetUnitAura", SetUnitAura_handler)
hooksecurefunc(GameTooltip, "SetUnitBuff", SetUnitBuff_handler)
hooksecurefunc(GameTooltip, "SetUnitDebuff", SetUnitDebuff_handler)
