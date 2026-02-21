-------------------------------------------------------------------------------
-- RaidLogAuto_Classic
-- Automatically enables combat logging when entering a raid instance
-- and disables it when leaving.
--
-- THIS VERSION IS FOR CLASSIC ERA AND WRATH CLASSIC
-- Note: LoggingCombat() API does not exist in Classic/Wrath
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...

RaidLogAutoDB = RaidLogAutoDB or {}

local defaults = {
    enabled = true,
    raidOnly = true,
    printMessages = true,
}

local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local GetInstanceInfo = GetInstanceInfo
local print = print

local L = {
    ADDON_LOADED = "RaidLogAuto loaded. Type /rla for options.",
    NOT_AVAILABLE = "Combat logging is not available in Classic/Wrath.",
    UNSUPPORTED = "LoggingCombat API not supported in Classic.",
}

local COLOR_YELLOW = "|cffffff00"
local COLOR_GREEN = "|cff00ff00"
local COLOR_RED = "|cffff0000"
local COLOR_RESET = "|r"

local function LoggingCombatWrapper(...)
    return false
end

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

    return false
end

local function UpdateLogging()
    local shouldLog = ShouldEnableLogging()
    local currentlyLogging = LoggingCombatWrapper()

    if shouldLog and not currentlyLogging then
        LoggingCombatWrapper(true)
        Print(COLOR_GREEN .. L.NOT_AVAILABLE .. COLOR_RESET)
    elseif not shouldLog and currentlyLogging then
        LoggingCombatWrapper(false)
    end
end

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

    elseif event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(1, UpdateLogging)

    elseif event == "ZONE_CHANGED_NEW_AREA" then
        UpdateLogging()
    end
end

frame:SetScript("OnEvent", OnEvent)
frame:RegisterEvent("ADDON_LOADED")

SLASH_RAIDLOGAUTO1 = "/raidlogauto"
SLASH_RAIDLOGAUTO2 = "/rla"

local function PrintStatus()
    print(COLOR_YELLOW .. "--- RaidLogAuto Status ---" .. COLOR_RESET)
    print("  Enabled: " .. (RaidLogAutoDB.enabled and COLOR_GREEN .. "Yes" or COLOR_RED .. "No") .. COLOR_RESET)
    print("  Raid Only: " .. (RaidLogAutoDB.raidOnly and "Yes" or "No"))
    print("  Print Messages: " .. (RaidLogAutoDB.printMessages and "Yes" or "No"))
    print("  Auto Logging: " .. COLOR_RED .. "N/A (Classic)" .. COLOR_RESET)
    print("  " .. COLOR_YELLOW .. L.UNSUPPORTED .. COLOR_RESET)
end

local function PrintHelp()
    print(COLOR_YELLOW .. "--- RaidLogAuto Commands ---" .. COLOR_RESET)
    print("  /rla - Show current status")
    print("  /rla on - Enable addon")
    print("  /rla off - Disable addon")
    print("  /rla toggle - Toggle addon on/off")
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
