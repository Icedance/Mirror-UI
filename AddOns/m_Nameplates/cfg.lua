  local addon, ns = ...
  local cfg = CreateFrame("Frame")

  -----------------------------
  -- MEDIA
  -----------------------------
  local MediaPath = "Interface\\AddOns\\m_Nameplates\\media\\"
  cfg.statusbar = MediaPath.."statusbar"
  cfg.backdrop_edge = MediaPath.."glowTex"
  cfg.font = STANDARD_TEXT_FONT
  cfg.icontex = MediaPath.."iconborder"
  
  -----------------------------
  -- CONFIG
  -----------------------------
  cfg.fontsize = 9					-- Font size for Name and HP text
  cfg.fontflag = "THINOUTLINE"		-- Text outline
  cfg.hpHeight = 6					-- Health bar height
  cfg.hpWidth = 130					-- Health bar width
  cfg.raidIconSize = 14				-- Raid icon size
  cfg.cbIconSize = 16				-- Cast bar icon size
  cfg.cbHeight = 5					-- Cast bar height
  cfg.cbWidth = 100					-- Cast bar width
  cfg.combat_toggle = false 			-- If set to true nameplates will be automatically toggled on when you enter the combat
  
  cfg.TotemIcon = true 				-- Toggle totem icons
  cfg.TotemSize = 16				-- Totem icon size
  
  
  cfg.cast_time = true
  cfg.namecolor = true
  
  -- HANDOVER
  ns.cfg = cfg
