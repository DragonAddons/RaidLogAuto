std = "lua51"
max_line_length = false
codes = true

exclude_files = {
    "RaidLogAuto.lua", -- Deprecated, no longer loaded
}

ignore = {
    "212/self", -- Unused argument 'self' (common in WoW event handlers)
}

-- Globals the addon writes to
globals = {
    "RaidLogAutoDB",
    "SLASH_RAIDLOGAUTO1",
    "SLASH_RAIDLOGAUTO2",
    "SlashCmdList",
    "StaticPopupDialogs",
}

-- WoW API globals (read-only)
read_globals = {
    "C_ChallengeMode",
    "C_Timer",
    "COMBATLOGDISABLED",
    "COMBATLOGENABLED",
    "CreateFrame",
    "GetCVar",
    "GetInstanceInfo",
    "IsInInstance",
    "IsInRaid",
    "LoggingCombat",
    "print",
    "SetCVar",
    "StaticPopup_Show",
}
