-- Azeroth After Dark: the latest WoW: Forever news, in game.
-- Core: saved settings, the story list, the login popup, slash commands.
-- The stories themselves ship in News.lua (written by the After Dark newsroom, refreshed with every addon update).
local ADDON, ns = ...

ns.MEDIA = "Interface\\AddOns\\" .. ADDON .. "\\Media\\"
ns.POPUP_MODES = { "new", "always", "off" }
ns.POPUP_LABELS = { new = "New stories", always = "Every login", off = "Never" }

local DEFAULTS = {
    popup = "new",        -- new: pop up when there's a story you haven't seen; always; off
    lastSeen = 0,         -- publish time of the newest story when you last opened the window
    read = {},            -- [storyId] = true once you've opened the article
    minimap = { angle = 215, hide = false },
    point = nil,          -- saved window position
}

local function copyDefaults(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dst[k]) ~= "table" then dst[k] = {} end
            copyDefaults(dst[k], v)
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
end

-- ------------------------------------------------------------------------------------------------ stories

function ns.News()
    local n = AzerothAfterDarkNews
    if type(n) ~= "table" or type(n.stories) ~= "table" then return { stories = {}, generated = 0 } end
    return n
end

local sorted
--- Stories, newest first (each validated once: a story with no headline is dropped).
function ns.Stories()
    if sorted then return sorted end
    sorted = {}
    for _, s in ipairs(ns.News().stories) do
        if type(s) == "table" and type(s.headline) == "string" and s.headline ~= "" then
            s.id = s.id or s.headline
            s.time = tonumber(s.time) or 0
            s.body = type(s.body) == "table" and s.body or {}
            s.bullets = type(s.bullets) == "table" and s.bullets or {}
            s.images = type(s.images) == "table" and s.images or {}
            s.sources = type(s.sources) == "table" and s.sources or {}
            sorted[#sorted + 1] = s
        end
    end
    table.sort(sorted, function(a, b)
        if (a.top and 1 or 0) ~= (b.top and 1 or 0) then return a.top and true or false end
        if a.time ~= b.time then return a.time > b.time end
        return tostring(a.id) < tostring(b.id)
    end)
    return sorted
end

function ns.Find(id)
    for i, s in ipairs(ns.Stories()) do
        if s.id == id then return s, i end
    end
end

function ns.Now() return time() end

--- "just now", "25m ago", "3h ago", "Yesterday", "4d ago", "Nov 2"
function ns.Ago(t, now)
    now = now or ns.Now()
    t = tonumber(t) or 0
    if t <= 0 then return "" end
    local d = now - t
    if d < 90 then return "just now" end
    if d < 3600 then return math.floor(d / 60) .. "m ago" end
    if d < 86400 then return math.floor(d / 3600) .. "h ago" end
    if d < 2 * 86400 then return "Yesterday" end
    if d < 7 * 86400 then return math.floor(d / 86400) .. "d ago" end
    return date("%b ", t) .. tonumber(date("%d", t))
end

--- "Wowhead", "Wowhead + Icy Veins"
function ns.SourceNames(s)
    local names, seen = {}, {}
    for _, src in ipairs(s.sources or {}) do
        local n = type(src) == "table" and src.name
        if n and not seen[n] then seen[n] = true; names[#names + 1] = n end
    end
    return table.concat(names, " + ")
end

function ns.Meta(s, now)
    local parts = {}
    local ago = ns.Ago(s.time, now)
    if ago ~= "" then parts[#parts + 1] = ago end
    local src = ns.SourceNames(s)
    if src ~= "" then parts[#parts + 1] = src end
    return table.concat(parts, "  ·  ")
end

function ns.IsUnread(s) return ns.db and not ns.db.read[s.id] end

function ns.MarkRead(s)
    if ns.db and s then ns.db.read[s.id] = true end
    if ns.OnReadChanged then ns.OnReadChanged() end
end

function ns.UnreadCount()
    local n = 0
    for _, s in ipairs(ns.Stories()) do if ns.IsUnread(s) then n = n + 1 end end
    return n
end

function ns.Newest()
    local t = 0
    for _, s in ipairs(ns.Stories()) do if s.time > t then t = s.time end end
    return t
end

--- Is there a story you haven't seen in the window yet?
function ns.HasNew()
    return ns.db ~= nil and ns.Newest() > (ns.db.lastSeen or 0)
end

function ns.MarkSeen()
    if ns.db then ns.db.lastSeen = math.max(ns.db.lastSeen or 0, ns.Newest()) end
end

--- Days since this edition was written (nil when News.lua has no date).
function ns.EditionAge(now)
    local g = tonumber(ns.News().generated) or 0
    if g <= 0 then return nil end
    return ((now or ns.Now()) - g) / 86400
end

-- ------------------------------------------------------------------------------------------------ popup

function ns.ShouldPopup()
    if not ns.db or #ns.Stories() == 0 then return false end
    if ns.db.popup == "always" then return true end
    if ns.db.popup == "new" then return ns.HasNew() end
    return false
end

local pendingCombat = false
function ns.TryPopup()
    if not ns.ShouldPopup() then return end
    if InCombatLockdown and InCombatLockdown() then pendingCombat = true; return end
    if ns.Show then ns.Show() end
end

function ns.CyclePopup()
    local cur = ns.db.popup
    for i, m in ipairs(ns.POPUP_MODES) do
        if m == cur then
            ns.db.popup = ns.POPUP_MODES[i % #ns.POPUP_MODES + 1]
            return ns.db.popup
        end
    end
    ns.db.popup = "new"
    return "new"
end

-- ------------------------------------------------------------------------------------------------ events

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event, a1, a2)
    if event == "ADDON_LOADED" and a1 == ADDON then
        AzerothAfterDarkDB = type(AzerothAfterDarkDB) == "table" and AzerothAfterDarkDB or {}
        copyDefaults(AzerothAfterDarkDB, DEFAULTS)
        ns.db = AzerothAfterDarkDB
        -- forget read marks for stories that left the edition
        local keep = {}
        for _, s in ipairs(ns.Stories()) do keep[s.id] = true end
        for id in pairs(ns.db.read) do if not keep[id] then ns.db.read[id] = nil end end
        if ns.CreateMinimapButton then ns.CreateMinimapButton() end
    elseif event == "PLAYER_ENTERING_WORLD" then
        local isInitialLogin = a1
        if isInitialLogin then
            -- give the login screen fade and other addons' greetings a moment
            C_Timer.After(4, ns.TryPopup)
        end
    elseif event == "PLAYER_REGEN_ENABLED" and pendingCombat then
        pendingCombat = false
        C_Timer.After(1, ns.TryPopup)
    end
end)

-- ------------------------------------------------------------------------------------------------ slash

local function say(msg) print("|cfff2c46bAzeroth After Dark|r: " .. msg) end
ns.Say = say

SLASH_AZEROTHAFTERDARK1 = "/aad"
SLASH_AZEROTHAFTERDARK2 = "/afterdark"
SLASH_AZEROTHAFTERDARK3 = "/wownews"
SlashCmdList.AZEROTHAFTERDARK = function(msg)
    msg = strtrim and strtrim(msg or ""):lower() or (msg or ""):lower()
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    if cmd == "" then
        if ns.Toggle then ns.Toggle() end
    elseif cmd == "popup" then
        if ns.POPUP_LABELS[arg] then ns.db.popup = arg else ns.CyclePopup() end
        say("show on login: " .. ns.POPUP_LABELS[ns.db.popup])
        if ns.Refresh then ns.Refresh() end
    elseif cmd == "minimap" then
        ns.db.minimap.hide = not ns.db.minimap.hide
        if ns.UpdateMinimapButton then ns.UpdateMinimapButton() end
        say("minimap button " .. (ns.db.minimap.hide and "hidden" or "shown"))
    elseif cmd == "reset" then
        ns.db.point = nil
        if ns.ResetPosition then ns.ResetPosition() end
        say("window position reset")
    elseif cmd == "unread" then
        wipe(ns.db.read)
        ns.db.lastSeen = 0
        if ns.Refresh then ns.Refresh() end
        say("every story marked unread")
    else
        say("/aad - open the news")
        say("/aad popup [new|always|off] - when the news opens by itself on login")
        say("/aad minimap - show or hide the minimap button")
        say("/aad reset - put the window back in the middle")
    end
end
