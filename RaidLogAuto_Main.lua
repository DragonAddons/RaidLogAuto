 -------------------------------------------------------------------------------
-- RaidLogAuto_Main
-- Automatically enables combat logging when entering a raid instance
-- and disables it when leaving.
--
-- This version is for:
-- - World of Warcraft Retail (LoggingCombat API, Mythic+ support)
-- - Mists of Pandaria Classic (LoggingCombat API)
--
-- Note: This addon does NOT work on Classic Era (no LoggingCombat API)
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...

RaidLogAutoDB = RaidLogAutoDB or {}

local defaults = {
    enabled = true,
    raidOnly = true,
    mythicPlus = false,
    printMessages = true,
}

local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local GetInstanceInfo = GetInstanceInfo
local LoggingCombat = LoggingCombat
local print = print

local L = {
    ENABLED = COMBATLOGENABLED or "Combat logging enabled.",
    DISABLED = COMBATLOGDISABLED or "Combat logging disabled.",
    ADDON_LOADED = "RaidLogAuto loaded. Type /rla for options.",
}

local COLOR_YELLOW = "|cffffff00"
local COLOR_GREEN = "|cff00ff00"
local COLOR_RED = "|cffff0000"
local COLOR_RESET = "|r"

 -------------------------------------------------------------------------------
-- Helper Functions
 -------------------------------------------------------------------------------

local function Print(msg)
    if RaidLogAutoDB.printMessages then
        print(COLOR_YELLOW .. "[RaidLogAuto]|r " .. msg)
    end
end

local function ShouldEnableLogging()
    if not RaidLogAutoDB.enabled then
        return false
    end

    local inInstance, instanceType = IsInInstance()

    if not inInstance then
        return false
    end

    if instanceType == "raid" then
        return true
    end

    if RaidLogAutoDB.mythicPlus and instanceType == "party" then
        if C_ChallengeMode and C_ChallengeMode.GetActiveChallengeMapID then
            local mapID = C_ChallengeMode.GetActiveChallengeMapID()
            if mapID then
                return true
            end
        end
    end

    return false
end

local function UpdateLogging()
    local shouldLog = ShouldEnableLogging()
    local currentlyLogging = LoggingCombat()

    if shouldLog and not currentlyLogging then
        LoggingCombat(true)
        Print(COLOR_GREEN .. L.ENABLED .. COLOR_RESET)
    elseif not shouldLog and currentlyLogging then
        LoggingCombat(false)
        Print(COLOR_RED .. L.DISABLED .. COLOR_RESET)
    end
end

 -------------------------------------------------------------------------------
-- Event Handler
 -------------------------------------------------------------------------------

local frame = CreateFrame("Frame")

local function OnEvent(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        for key, value in pairs(defaults) do
            if RaidLogAutoDB[key] == nil then
                RaidLogAutoDB[key] = value
            end
        end
        Print(L.ADDON_LOADED)

        self:UnregisterEvent("ADDON_LOADED")
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

        if C_ChallengeMode then
            self:RegisterEvent("CHALLENGE_MODE_START")
            self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(1, UpdateLogging)

    elseif event == "ZONE_CHANGED_NEW_AREA" then
        UpdateLogging()

    elseif event == "CHALLENGE_MODE_START" then
        if RaidLogAutoDB.mythicPlus then
            UpdateLogging()
        end

    elseif event == "CHALLENGE_MODE_COMPLETED" then
        UpdateLogging()
    end
end

frame:SetScript("OnEvent", OnEvent)
frame:RegisterEvent("ADDON_LOADED")

 -------------------------------------------------------------------------------
-- Slash Commands
 -------------------------------------------------------------------------------

SLASH_RAIDLOGAUTO1 = "/raidlogauto"
SLASH_RAIDLOGAUTO2 = "/rla"

local function PrintStatus()
    print(COLOR_YELLOW .. "--- RaidLogAuto Status ---" .. COLOR_RESET)
    print("  Enabled: " .. (RaidLogAutoDB.enabled and COLOR_GREEN .. "Yes" or COLOR_RED .. "No") .. COLOR_RESET)
    print("  Raid Only: " .. (RaidLogAutoDB.raidOnly and "Yes" or "No"))
    if C_ChallengeMode then
        print("  Mythic+: " .. (RaidLogAutoDB.mythicPlus and "Yes" or "No"))
    end
    print("  Print Messages: " .. (RaidLogAutoDB.printMessages and "Yes" or "No"))
    print("  Currently Logging: " .. (LoggingCombat() and COLOR_GREEN .. "Yes" or COLOR_RED .. "No") .. COLOR_RESET)
end

local function PrintHelp()
    print(COLOR_YELLOW .. "--- RaidLogAuto Commands ---" .. COLOR_RESET)
    print("  /rla - Show current status")
    print("  /rla on - Enable addon")
    print("  /rla off - Disable addon")
    print("  /rla toggle - Toggle addon on/off")
    print("  /rla mythic - Toggle Mythic+ logging (Retail only)")
    print("  /rla silent - Toggle chat messages")
    print("  /rla help - Show this help")
end

SlashCmdList["RAIDLOGAUTO"] = function(msg)
    local cmd = msg:lower():trim()

    if cmd == "" or cmd == "status" then
        PrintStatus()

    elseif cmd == "on" or cmd == "enable" then
        RaidLogAutoDB.enabled = true
        Print("Addon " .. COLOR_GREEN .. "enabled" .. COLOR_RESET)
        UpdateLogging()

    elseif cmd == "off" or cmd == "disable" then
        RaidLogAutoDB.enabled = false
        Print("Addon " .. COLOR_RED .. "disabled" .. COLOR_RESET)
        UpdateLogging()

    elseif cmd == "toggle" then
        RaidLogAutoDB.enabled = not RaidLogAutoDB.enabled
        Print("Addon " .. (RaidLogAutoDB.enabled and COLOR_GREEN .. "enabled" or COLOR_RED .. "disabled") .. COLOR_RESET)
        UpdateLogging()

    elseif cmd == "mythic" or cmd == "m+" then
        if C_ChallengeMode then
            RaidLogAutoDB.mythicPlus = not RaidLogAutoDB.mythicPlus
            Print("Mythic+ logging " .. (RaidLogAutoDB.mythicPlus and COLOR_GREEN .. "enabled" or COLOR_RED .. "disabled") .. COLOR_RESET)
            UpdateLogging()
        else
            Print("Mythic+ is only available in Retail WoW.")
        end

    elseif cmd == "silent" or cmd == "quiet" then
        RaidLogAutoDB.printMessages = not RaidLogAutoDB.printMessages
        print(COLOR_YELLOW .. "[RaidLogAuto]|r Messages " .. (RaidLogAutoDB.printMessages and "enabled" or "disabled"))

    elseif cmd == "help" or cmd == "?" then
        PrintHelp()

    else
        print(COLOR_YELLOW .. "[RaidLogAuto]|r Unknown command: " .. cmd)
        PrintHelp()
    end
end
