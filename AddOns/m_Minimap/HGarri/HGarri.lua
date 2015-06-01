----------------------------------------------------------------------------------------
--	Clear and Hide The GarryPMB -- Hover Over Time!
----------------------------------------------------------------------------------------
GarrisonLandingPageMinimapButton.ClearAllPoints = dummy
GarrisonLandingPageMinimapButton.SetPoint = dummy
GarrisonLandingPageMinimapButton:SetAlpha(0)
GarrisonLandingPageMinimapButton:SetScript("OnEnter", function()
	GarrisonLandingPageMinimapButton:FadeIn()
end)
GarrisonLandingPageMinimapButton:SetScript("OnLeave", function()
	GarrisonLandingPageMinimapButton:FadeOut()
end)