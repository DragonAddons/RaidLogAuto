 -------------------------------------------------------------------------------
-- RaidLogAuto_Classic
-- Automatically enables combat logging when entering a raid instance
-- and disables it when leaving.
--
-- This version is for: Classic Era
-- Supported features: Raid logging
 -------------------------------------------------------------------------------

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then return end

local ADDON_NAME, _ = ...

RaidLogAutoDB = RaidLogAutoDB or {}

local defaults = {
    enabled = true,
    raidOnly = true,
    printMessages = true,
    combatLogReminderDismissed = false,
}

local GetCVar = GetCVar
local IsInInstance = IsInInstance
local LoggingCombat = LoggingCombat
local print = print
local SetCVar = SetCVar
local StaticPopupDialogs = StaticPopupDialogs
local StaticPopup_Show = StaticPopup_Show

local L = {
    ENABLED = COMBATLOGENABLED or "Combat logging enabled.",
    DISABLED = COMBATLOGDISABLED or "Combat logging disabled.",
    ADDON_LOADED = "RaidLogAuto loaded. Type /rla for options.",
}

local COLOR_YELLOW = "|cffffff00"
local COLOR_GREEN = "|cff00ff00"
local COLOR_RED = "|cffff0000"
local COLOR_WHITE = "|cffffffff"
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

    return instanceType == "raid"
end

local function CheckAdvancedCombatLogging()
    local acl = GetCVar("advancedCombatLogging")
    if acl == nil then return end
    if acl == "0" then
        SetCVar("advancedCombatLogging", "1")
        Print(COLOR_YELLOW .. "Advanced Combat Logging was disabled. "
            .. COLOR_GREEN .. "Automatically enabled it for you.")
    end
end

local function ShowCombatLogReminder()
    if RaidLogAutoDB.combatLogReminderDismissed then return end
    StaticPopup_Show("RAIDLOGAUTO_COMBATLOG_REMINDER")
end

local function UpdateLogging()
    local shouldLog = ShouldEnableLogging()
    local currentlyLogging = LoggingCombat()

    if shouldLog and not currentlyLogging then
        LoggingCombat(true)
        Print(COLOR_GREEN .. L.ENABLED .. COLOR_RESET)
        CheckAdvancedCombatLogging()
    elseif not shouldLog and currentlyLogging then
        LoggingCombat(false)
        Print(COLOR_RED .. L.DISABLED .. COLOR_RESET)
    end
end

 -------------------------------------------------------------------------------
-- Event Handler
 -------------------------------------------------------------------------------

local frame = CreateFrame("Frame")

-------------------------------------------------------------------------------
-- Static Popup: CombatLog.txt Reminder
-------------------------------------------------------------------------------
StaticPopupDialogs["RAIDLOGAUTO_COMBATLOG_REMINDER"] = {
    text = "RaidLogAuto:\n\n"
        .. "1. Make sure Advanced Combat Logging is enabled in "
        .. "System > Network > Advanced Combat Logging. "
        .. "RaidLogAuto will enable it automatically when logging starts, "
        .. "but the setting should stay on.\n\n"
        .. "2. Delete your CombatLog.txt file (in WoW\\Logs\\) before each "
        .. "raid session. Mixing old and new combat logs will cause "
        .. "WarcraftLogs and WoWAnalyzer to reject the upload.\n\n"
        .. "Click OK to dismiss this reminder permanently.",
    button1 = "OK, Got It",
    OnAccept = function()
        RaidLogAutoDB.combatLogReminderDismissed = true
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = false,
    preferredIndex = 3,
}

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

        C_Timer.After(3, ShowCombatLogReminder)

    elseif event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(1, UpdateLogging)

    elseif event == "ZONE_CHANGED_NEW_AREA" then
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
    print("  Print Messages: " .. (RaidLogAutoDB.printMessages and "Yes" or "No"))
    print("  Currently Logging: " .. (LoggingCombat() and COLOR_GREEN .. "Yes" or COLOR_RED .. "No") .. COLOR_RESET)
    local acl = GetCVar("advancedCombatLogging")
    if acl ~= nil then
        Print("Advanced Combat Logging: "
            .. (acl == "1" and (COLOR_GREEN .. "ON") or (COLOR_RED .. "OFF")))
    end
end

local function PrintHelp()
    print(COLOR_YELLOW .. "--- RaidLogAuto Commands ---" .. COLOR_RESET)
    print("  /rla - Show current status")
    print("  /rla on - Enable addon")
    print("  /rla off - Disable addon")
    print("  /rla toggle - Toggle addon on/off")
    print("  /rla silent - Toggle chat messages")
    Print(COLOR_GREEN .. "/rla acl" .. COLOR_WHITE .. " - Check/enable Advanced Combat Logging")
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

    elseif cmd == "acl" then
        local acl = GetCVar("advancedCombatLogging")
        if acl == nil then
            Print(COLOR_RED .. "Advanced Combat Logging CVar not available.")
        elseif acl == "1" then
            Print("Advanced Combat Logging: " .. COLOR_GREEN .. "ON")
        else
            SetCVar("advancedCombatLogging", "1")
            Print("Advanced Combat Logging was " .. COLOR_RED .. "OFF"
                .. COLOR_WHITE .. ". " .. COLOR_GREEN .. "Enabled it for you.")
        end

    elseif cmd == "help" or cmd == "?" then
        PrintHelp()

    else
        print(COLOR_YELLOW .. "[RaidLogAuto]|r Unknown command: " .. cmd)
        PrintHelp()
    end
end
