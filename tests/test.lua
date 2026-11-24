-- Headless tests for Azeroth After Dark.   node tests/run.js tests/test.lua   (from the addon folder)
unpack = table.unpack
tinsert = table.insert
date, time = os.date, os.time
wipe = function(t) for k in pairs(t) do t[k] = nil end return t end
strtrim = function(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
local realPrint = print
local pass, fail = 0, 0
local function ok(c, name) if c then pass = pass + 1 else fail = fail + 1; realPrint("FAIL: " .. name) end end

-- ------------------------------------------------------------ frame stubs
local Frame = {}
Frame.__index = function(t, k)
    local v = rawget(Frame, k)
    if v ~= nil then return v end
    if type(k) == "string" and k:match("^%u") then return function() end end
    return nil
end
local frames = {}
local function newObj(kind, parent)
    local o = setmetatable({ kind = kind, parent = parent, shown = true, scripts = {}, events = {},
                             w = 0, h = 0, scroll = 0, points = {}, size = 12 }, Frame)
    frames[#frames + 1] = o
    return o
end
function Frame:Show() local was = self.shown; self.shown = true; if not was and self.scripts.OnShow then self.scripts.OnShow(self) end end
function Frame:Hide() local was = self.shown; self.shown = false; if was and self.scripts.OnHide then self.scripts.OnHide(self) end end
function Frame:SetShown(v) if v then self:Show() else self:Hide() end end
function Frame:IsShown() return self.shown end
function Frame:IsVisible()
    local o = self
    while o do if not o.shown then return false end o = o.parent end
    return true
end
function Frame:SetSize(w, h) self.w, self.h = w, h end
function Frame:SetWidth(w) self.w = w end
function Frame:SetHeight(h) self.h = h end
function Frame:GetWidth() return self.w end
function Frame:GetHeight() return self.h end
function Frame:GetCenter() return 100, 100 end
function Frame:SetScript(n, f) self.scripts[n] = f end
function Frame:GetScript(n) return self.scripts[n] end
function Frame:HookScript(n, f)
    local old = self.scripts[n]
    self.scripts[n] = function(...) if old then old(...) end f(...) end
end
function Frame:RegisterEvent(e) self.events[e] = true end
function Frame:UnregisterEvent(e) self.events[e] = nil end
function Frame:SetText(t) self.text = t end
function Frame:GetText() return self.text end
function Frame:SetFont(_, size) self.size = size; return true end
function Frame:GetStringWidth() return #(tostring(self.text or "")) * self.size * 0.5 end
function Frame:GetStringHeight()
    local chars = #(tostring(self.text or ""))
    local perLine = math.max(1, math.floor((self.w > 0 and self.w or 300) / (self.size * 0.5)))
    return math.ceil(math.max(1, chars) / perLine) * (self.size + 3)
end
function Frame:SetTextColor(r, g, b) self.color = { r, g, b } end
function Frame:SetTexture(t) self.texture = t end
function Frame:SetColorTexture(r, g, b, a) self.color = { r, g, b, a } end
function Frame:SetPoint(...) self.points[#self.points + 1] = { ... } end
function Frame:ClearAllPoints() self.points = {} end
function Frame:GetPoint() return "CENTER", nil, "CENTER", 10, 20 end
function Frame:CreateFontString() return newObj("FontString", self) end
function Frame:CreateTexture() return newObj("Texture", self) end
function Frame:GetVerticalScroll() return self.scroll end
function Frame:SetVerticalScroll(v) self.scroll = v end
function Frame:GetEffectiveScale() return 1 end
function Frame:Click(b) if self.scripts.OnClick then self.scripts.OnClick(self, b or "LeftButton") end end

function CreateFrame(kind, name, parent)
    local f = newObj(kind, parent)
    if name then _G[name] = f end
    return f
end
UIParent = newObj("Frame")
Minimap = newObj("Frame"); Minimap.w = 140
GameTooltip = newObj("GameTooltip")
local tipLines = {}
function GameTooltip:SetOwner() tipLines = {} end
function GameTooltip:AddLine(t) tipLines[#tipLines + 1] = t end
UISpecialFrames, SlashCmdList = {}, {}
local printed = {}
print = function(...) printed[#printed + 1] = table.concat({ ... }, " ") end
local timers = {}
C_Timer = { After = function(_, fn) timers[#timers + 1] = fn end }
local function flush() local t = timers; timers = {}; for _, fn in ipairs(t) do fn() end end
GetCursorPosition = function() return 0, 0 end
local combat = false
InCombatLockdown = function() return combat end

local function fire(event, ...)
    for _, f in ipairs(frames) do
        if f.events[event] and f.scripts.OnEvent then f.scripts.OnEvent(f, event, ...) end
    end
end

-- ------------------------------------------------------------ load the real edition
local ns = {}
for _, file in ipairs({ "News.lua", "Core.lua", "UI.lua" }) do assert(loadfile(file))("AzerothAfterDark", ns) end
fire("ADDON_LOADED", "AzerothAfterDark")

local stories = ns.Stories()
ok(#stories >= 2, "edition has stories (" .. #stories .. ")")
local sortedOk = true
for i = 2, #stories do if stories[i].time > stories[i - 1].time then sortedOk = false end end
ok(sortedOk, "stories newest first")
ok(ns.db and ns.db.popup == "new", "defaults applied")
ok(ns.UnreadCount() == #stories, "everything unread on first install")
ok(AzerothAfterDarkMinimapButton ~= nil, "minimap button made")
ok(AzerothAfterDarkMinimapButton.count.text == (#stories > 9 and "9+" or tostring(#stories)), "minimap badge shows unread count")

-- login popup
fire("PLAYER_ENTERING_WORLD", false, true)   -- a /reload: no popup
flush()
ok(not ns.IsShown(), "no popup on reload")
fire("PLAYER_ENTERING_WORLD", true, false)
flush()
ok(ns.IsShown(), "popup on first login with new stories")
local f = AzerothAfterDarkFrame
ok(UISpecialFrames[1] == "AzerothAfterDarkFrame", "escape closes the window")

-- front page
local hero = nil
for _, o in ipairs(frames) do if o.kind == "Button" and o.story == stories[1] then hero = o end end
ok(hero ~= nil, "hero holds the top story")
ok(hero.headline.text == stories[1].headline, "hero headline")
ok(hero.img.texture and hero.img.texture:find("^Interface\\AddOns\\AzerothAfterDark\\Media\\"), "hero picture path")
local rowCount = 0
for _, o in ipairs(frames) do if o.kind == "Button" and o.story and o ~= hero and o.shown and o.thumb then rowCount = rowCount + 1 end end
ok(rowCount == #stories - 1, "one row per other story (" .. rowCount .. ")")

-- open every story: layout must not error and must show the body
for i, s in ipairs(stories) do
    local good, err = pcall(ns.OpenStory, s.id)
    ok(good, "open story " .. i .. (err and (": " .. tostring(err)) or ""))
end
ok(ns.UnreadCount() == 0, "opening marks read")
ok(not AzerothAfterDarkMinimapButton.badge.shown, "badge hidden when all read")

-- article navigation
ns.OpenStory(stories[1].id)
local v, cur = ns.View()
ok(v == "article" and cur == stories[1], "article view")
ns.Step(1)
v, cur = ns.View()
ok(cur == stories[2], "next story")
ns.Step(-1)
v, cur = ns.View()
ok(cur == stories[1], "previous story")
ns.Step(-1)
v, cur = ns.View()
ok(cur == stories[1], "no story before the first")

-- the body text actually got laid out
local foundBody = false
local s1 = stories[1]
for _, o in ipairs(frames) do
    if o.kind == "FontString" and o.shown and o.text == s1.body[1] then foundBody = true end
end
ok(foundBody, "article body shown")
local foundUrl = false
for _, o in ipairs(frames) do
    if o.kind == "EditBox" and o.shown and o.url == (s1.sources[1] or {}).url then foundUrl = true end
end
ok(foundUrl or #s1.sources == 0, "source link box")

-- gallery
local withPics
for _, s in ipairs(stories) do if #s.images > 1 then withPics = s; break end end
if withPics then
    ns.OpenStory(withPics.id)
    ns.ShowImage(2)
    local img
    for _, o in ipairs(frames) do if o.kind == "Texture" and o.w == 640 and o.h == 320 then img = o end end
    ok(img and img.texture == ns.MEDIA .. withPics.images[2].file, "gallery shows picture 2")
    ns.ShowImage(#withPics.images + 1)
    ok(img.texture == ns.MEDIA .. withPics.images[1].file, "gallery wraps around")
end

ns.ShowHome()
ok(ns.View() == "home", "back to all news")

-- ------------------------------------------------------------ tabs
SlashCmdList.AZEROTHAFTERDARK("unread")
ns.SetTab("all")
local tabs = ns.Tabs()
ok(tabs[1].key == "all" and tabs[1].count == #stories, "first tab is All with every story")
ok(tabs[2].key == "new" and tabs[2].count == #stories, "second tab is New with the unread count")
local cats, catTotal = {}, 0
for i = 3, #tabs do cats[tabs[i].key] = tabs[i].count; catTotal = catTotal + tabs[i].count end
ok(catTotal == #stories, "category tabs cover every story once")
for _, s in ipairs(stories) do
    if not cats[s.category or "News"] then ok(false, "no tab for category " .. tostring(s.category)) end
end
local tabBtns = 0
for _, o in ipairs(frames) do if o.kind == "Button" and o.key and o.shown then tabBtns = tabBtns + 1 end end
ok(tabBtns == #tabs, "one tab button per tab (" .. tabBtns .. ")")

-- pick the busiest category and filter to it
local busy, busyN = nil, 0
for i = 3, #tabs do if tabs[i].count > busyN then busy, busyN = tabs[i].key, tabs[i].count end end
for _, o in ipairs(frames) do if o.kind == "Button" and o.key == busy and o.shown then o:Click() end end
local t, shownList = ns.Tab()
ok(t == busy and #shownList == busyN, "clicking a tab filters to " .. tostring(busy))
local onlyBusy = true
for _, s in ipairs(shownList) do if (s.category or "News") ~= busy then onlyBusy = false end end
ok(onlyBusy, "filtered list holds only that category")
local heroNow
for _, o in ipairs(frames) do if o.kind == "Button" and o.story == shownList[1] and o.img then heroNow = o end end
ok(heroNow ~= nil, "the tab's newest story is the big one")
local rowsShown = 0
for _, o in ipairs(frames) do if o.kind == "Button" and o.story and o.shown and o.thumb then rowsShown = rowsShown + 1 end end
ok(rowsShown == busyN - 1, "rows only for the tab's other stories (" .. rowsShown .. ")")

-- Prev/Next stay inside the tab
ns.OpenStory(shownList[1].id)
if busyN > 1 then
    ns.Step(1)
    local _, c = ns.View()
    ok(c == shownList[2], "Next walks the tab, not All")
end
ns.Step(-1)
local _, c0 = ns.View()
ok(c0 == shownList[1], "Prev walks back inside the tab")

-- New: reading stories takes them off the tab, but Next keeps walking the list you opened
ns.ShowHome()
ns.SetTab("new")
local _, newList = ns.Tab()
ok(#newList == ns.UnreadCount() and #newList >= 2, "New lists every unread story")
ns.OpenStory(newList[1].id)
ns.Refresh()                                 -- e.g. the footer's popup button while reading
ns.Step(1)
local _, c1 = ns.View()
ok(c1 == newList[2], "Next from New still finds the next story after a refresh")
for _, s in ipairs(stories) do ns.MarkRead(s) end
ns.ShowHome()
local _, emptyNew = ns.Tab()
ok(#emptyNew == 0, "New is empty once everything is read")
local caughtUp = false
for _, o in ipairs(frames) do if o.kind == "FontString" and o.shown and o.text and o.text:find("all caught up") then caughtUp = true end end
ok(caughtUp, "New shows 'all caught up'")

-- a story opened from outside the tab walks All
ns.SetTab(busy)
local outsider
for _, s in ipairs(stories) do if (s.category or "News") ~= busy then outsider = s; break end end
if outsider then
    ns.OpenStory(outsider.id)
    local _, l = ns.Tab()
    ok(#l == #stories, "a story from outside the tab walks All")
end
ns.SetTab("Nonsense")
ns.ShowHome()
ok(ns.Tab() == "all", "an unknown tab falls back to All")
ns.SetTab("all")

-- closing marks the edition seen; next login doesn't pop up
f:Hide()
ok(ns.db.lastSeen == ns.Newest(), "closing marks seen")
fire("PLAYER_ENTERING_WORLD", true, false); flush()
ok(not ns.IsShown(), "no popup when nothing new")
SlashCmdList.AZEROTHAFTERDARK("popup always")
ok(ns.db.popup == "always", "/aad popup always")
fire("PLAYER_ENTERING_WORLD", true, false); flush()
ok(ns.IsShown(), "always mode pops up")
f:Hide()
SlashCmdList.AZEROTHAFTERDARK("popup off")
fire("PLAYER_ENTERING_WORLD", true, false); flush()
ok(not ns.IsShown(), "off mode never pops up")

-- a new story arrives (the next edition) while in combat at login
SlashCmdList.AZEROTHAFTERDARK("popup new")
ns.db.lastSeen = 0
combat = true
fire("PLAYER_ENTERING_WORLD", true, false); flush()
ok(not ns.IsShown(), "waits out combat")
combat = false
fire("PLAYER_REGEN_ENABLED"); flush()
ok(ns.IsShown(), "pops up after combat")

-- toggle + footer cycle
ns.Toggle()
ok(not ns.IsShown(), "toggle closes")
SlashCmdList.AZEROTHAFTERDARK("")
ok(ns.IsShown(), "/aad opens")
ok(ns.CyclePopup() == "always" and ns.CyclePopup() == "off" and ns.CyclePopup() == "new", "popup modes cycle")
SlashCmdList.AZEROTHAFTERDARK("minimap")
ok(not AzerothAfterDarkMinimapButton.shown, "/aad minimap hides the button")
SlashCmdList.AZEROTHAFTERDARK("minimap")
ok(AzerothAfterDarkMinimapButton.shown, "/aad minimap shows it again")
SlashCmdList.AZEROTHAFTERDARK("unread")
ok(ns.UnreadCount() == #stories, "/aad unread")

-- time labels
local now = 1000000000
ok(ns.Ago(now - 30, now) == "just now", "ago: just now")
ok(ns.Ago(now - 25 * 60, now) == "25m ago", "ago: minutes")
ok(ns.Ago(now - 3 * 3600, now) == "3h ago", "ago: hours")
ok(ns.Ago(now - 30 * 3600, now) == "Yesterday", "ago: yesterday")
ok(ns.Ago(now - 4 * 86400, now) == "4d ago", "ago: days")
ok(ns.Ago(0, now) == "", "ago: no time")
ok(ns.SourceNames({ sources = { { name = "Wowhead" }, { name = "Icy Veins" }, { name = "Wowhead" } } }) == "Wowhead + Icy Veins", "source names merged")

-- ------------------------------------------------------------ an empty / missing edition
frames = {}
AzerothAfterDarkNews = nil
AzerothAfterDarkDB = nil
local ns2 = {}
for _, file in ipairs({ "Core.lua", "UI.lua" }) do assert(loadfile(file))("AzerothAfterDark", ns2) end
fire("ADDON_LOADED", "AzerothAfterDark")
ok(#ns2.Stories() == 0, "missing edition = no stories")
fire("PLAYER_ENTERING_WORLD", true, false); flush()
ok(not ns2.IsShown(), "no popup with no stories")
local good = pcall(ns2.Show)
ok(good and ns2.IsShown(), "empty window opens")

-- a stale edition warns in the footer
frames = {}
AzerothAfterDarkNews = { generated = os.time() - 6 * 86400, stories = { { id = "a", time = os.time() - 6 * 86400, headline = "Old", body = { "x" } } } }
AzerothAfterDarkDB = nil
local ns3 = {}
for _, file in ipairs({ "Core.lua", "UI.lua" }) do assert(loadfile(file))("AzerothAfterDark", ns3) end
fire("ADDON_LOADED", "AzerothAfterDark")
ns3.Show()
local warned = false
for _, o in ipairs(frames) do if o.kind == "FontString" and o.text and o.text:find("days old") then warned = true end end
ok(warned, "stale edition warning")
ok(math.floor(ns3.EditionAge() + 0.5) == 6, "edition age")

realPrint(string.format("%d passed, %d failed", pass, fail))
if fail > 0 then os.exit(1) end
