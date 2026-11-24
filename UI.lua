-- Azeroth After Dark: the news window (front page + article view) and the minimap button.
-- Built from plain frames and colour textures only (no Blizzard templates), so it doesn't depend on
-- Forever's Camelot FrameXML.
local ADDON, ns = ...

local W, H = 880, 600
local PAD = 14
local HEADER_H = 50
local FOOTER_H = 34
local CW = W - PAD * 2                          -- content width
local CH = H - HEADER_H - FOOTER_H - PAD        -- content height
local TABS_H = 28                               -- the front page's tab bar
local BODY_Y = TABS_H + 10                      -- front page content starts below it
local HERO_W = 500
local HERO_IMG_H = 250
local LIST_X = HERO_W + 18
local LIST_W = CW - LIST_X
local ROW_H = 70
local COL_W = 640                               -- article reading column

local GOLD  = { 0.95, 0.77, 0.42 }
local INK   = { 0.94, 0.93, 0.98 }
local SOFT  = { 0.80, 0.78, 0.88 }
local MUTED = { 0.58, 0.56, 0.68 }
local HEAD_FONT = "Fonts\\FRIZQT__.TTF"
local BODY_FONT = "Fonts\\ARIALN.TTF"

local CATEGORY_COLORS = {
    ["Hotfixes"]    = { 1.00, 0.56, 0.22 },
    ["Patch Notes"] = { 0.38, 0.66, 1.00 },
    ["Maintenance"] = { 0.95, 0.38, 0.38 },
    ["Events"]      = { 0.42, 0.86, 0.48 },
    ["Community"]   = { 0.76, 0.52, 1.00 },
    ["Guides"]      = { 0.32, 0.85, 0.80 },
    ["Breaking"]    = { 1.00, 0.28, 0.28 },
}
local function catColor(c) return CATEGORY_COLORS[c or ""] or GOLD end

-- ------------------------------------------------------------------------------------------------ helpers

local function rect(parent, layer, r, g, b, a)
    local t = parent:CreateTexture(nil, layer or "BACKGROUND")
    t:SetColorTexture(r, g, b, a or 1)
    return t
end

local function border(frame, r, g, b, a)
    local function line() return rect(frame, "BORDER", r, g, b, a) end
    local t = line(); t:SetPoint("TOPLEFT"); t:SetPoint("TOPRIGHT"); t:SetHeight(1)
    local bo = line(); bo:SetPoint("BOTTOMLEFT"); bo:SetPoint("BOTTOMRIGHT"); bo:SetHeight(1)
    local l = line(); l:SetPoint("TOPLEFT"); l:SetPoint("BOTTOMLEFT"); l:SetWidth(1)
    local rr = line(); rr:SetPoint("TOPRIGHT"); rr:SetPoint("BOTTOMRIGHT"); rr:SetWidth(1)
end

local function text(parent, font, size, color, layer)
    local fs = parent:CreateFontString(nil, layer or "OVERLAY")
    fs:SetFont(font, size, "")
    fs:SetTextColor(color[1], color[2], color[3])
    fs:SetJustifyH("LEFT")
    fs:SetJustifyV("TOP")
    fs:SetWordWrap(true)
    return fs
end

-- WoW reads "|" as an escape; stories never carry one, but be safe.
local function safe(s) return (tostring(s or ""):gsub("|", "||")) end

local function imagePath(img)
    if type(img) == "table" and type(img.file) == "string" and img.file ~= "" then
        return ns.MEDIA .. img.file
    end
end
local PLACEHOLDER = function() return ns.MEDIA .. "placeholder" end

local function setImage(tex, img)
    tex:SetTexture(imagePath(img) or PLACEHOLDER())
    tex:SetTexCoord(0, 1, 0, 1)
end

-- A text button: label + hover tint.
local function textButton(parent, label, w, h)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(w, h)
    b.bg = rect(b, "BACKGROUND", 1, 1, 1, 0.06)
    b.bg:SetAllPoints()
    b.label = text(b, HEAD_FONT, 11, SOFT)
    b.label:SetPoint("CENTER")
    b.label:SetJustifyH("CENTER")
    b.label:SetText(label)
    b:SetScript("OnEnter", function(self) self.bg:SetColorTexture(GOLD[1], GOLD[2], GOLD[3], 0.22); self.label:SetTextColor(1, 1, 1) end)
    b:SetScript("OnLeave", function(self) self.bg:SetColorTexture(1, 1, 1, 0.06); self.label:SetTextColor(SOFT[1], SOFT[2], SOFT[3]) end)
    return b
end

-- Category chip: a coloured pill sized to its text.
local function chip(parent)
    local c = CreateFrame("Frame", nil, parent)
    c:SetHeight(18)
    c.bg = rect(c, "ARTWORK", 1, 1, 1, 1)
    c.bg:SetAllPoints()
    c.label = text(c, HEAD_FONT, 10, { 0.06, 0.05, 0.10 })
    c.label:SetPoint("LEFT", 7, 0)
    c.label:SetJustifyV("MIDDLE")
    function c:Set(category)
        local col = catColor(category)
        self.bg:SetColorTexture(col[1], col[2], col[3], 1)
        self.label:SetText(safe(category or "News"):upper())
        self:SetWidth(math.max(40, (self.label:GetStringWidth() or 40) + 14))
    end
    return c
end

-- Scroll area with a thin custom scrollbar and mouse-wheel scrolling.
local function scrollArea(parent, w, h)
    local sf = CreateFrame("ScrollFrame", nil, parent)
    sf:SetSize(w - 10, h)
    local child = CreateFrame("Frame", nil, sf)
    child:SetSize(w - 10, 1)
    sf:SetScrollChild(child)
    local track = rect(parent, "ARTWORK", 1, 1, 1, 0.05)
    track:SetPoint("TOPLEFT", sf, "TOPRIGHT", 4, 0)
    track:SetSize(4, h)
    local thumb = rect(parent, "OVERLAY", GOLD[1], GOLD[2], GOLD[3], 0.55)
    thumb:SetWidth(4)

    local function maxScroll() return math.max(0, (child:GetHeight() or 0) - h) end
    function sf:UpdateThumb()
        local m = maxScroll()
        if m <= 0 then thumb:Hide(); track:Hide(); return end
        thumb:Show(); track:Show()
        local th = math.max(24, h * h / (h + m))
        thumb:SetHeight(th)
        thumb:ClearAllPoints()
        thumb:SetPoint("TOPLEFT", track, "TOPLEFT", 0, -((h - th) * (self:GetVerticalScroll() / m)))
    end
    function sf:ScrollTo(v)
        self:SetVerticalScroll(math.max(0, math.min(maxScroll(), v)))
        self:UpdateThumb()
    end
    sf:EnableMouseWheel(true)
    sf:SetScript("OnMouseWheel", function(self, delta) self:ScrollTo(self:GetVerticalScroll() - delta * 60) end)
    return sf, child
end

-- ------------------------------------------------------------------------------------------------ window

local f, home, article, footer
local view = "home"
local current                -- story shown in the article view
local imageIndex = 1

local function savePosition()
    local point, _, rel, x, y = f:GetPoint()
    ns.db.point = { point, rel, x, y }
end

function ns.ResetPosition()
    if not f then return end
    f:ClearAllPoints()
    local p = ns.db and ns.db.point
    if p then f:SetPoint(p[1], UIParent, p[2], p[3], p[4]) else f:SetPoint("CENTER", UIParent, "CENTER", 0, 30) end
end

local function buildHeader()
    local h = CreateFrame("Frame", nil, f)
    h:SetPoint("TOPLEFT"); h:SetPoint("TOPRIGHT"); h:SetHeight(HEADER_H)
    local bg = rect(h, "BACKGROUND", 0.10, 0.08, 0.19, 1); bg:SetAllPoints()
    local line = rect(h, "BORDER", GOLD[1], GOLD[2], GOLD[3], 0.45)
    line:SetPoint("BOTTOMLEFT"); line:SetPoint("BOTTOMRIGHT"); line:SetHeight(1)
    h:EnableMouse(true)
    h:RegisterForDrag("LeftButton")
    h:SetScript("OnDragStart", function() f:StartMoving() end)
    h:SetScript("OnDragStop", function() f:StopMovingOrSizing(); savePosition() end)

    local logo = h:CreateTexture(nil, "ARTWORK")
    logo:SetTexture(ns.MEDIA .. "logo")
    logo:SetSize(38, 38)
    logo:SetPoint("LEFT", 10, 0)

    local title = text(h, HEAD_FONT, 17, GOLD)
    title:SetPoint("TOPLEFT", logo, "TOPRIGHT", 10, -3)
    title:SetText("AZEROTH AFTER DARK")
    f.subtitle = text(h, HEAD_FONT, 10, MUTED)
    f.subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)

    local close = textButton(h, "X", 30, 26)
    close:SetPoint("RIGHT", -10, 0)
    close:SetScript("OnClick", function() f:Hide() end)
    f.close = close
end

local function buildFooter()
    footer = CreateFrame("Frame", nil, f)
    footer:SetPoint("BOTTOMLEFT"); footer:SetPoint("BOTTOMRIGHT"); footer:SetHeight(FOOTER_H)
    local bg = rect(footer, "BACKGROUND", 0.07, 0.06, 0.13, 1); bg:SetAllPoints()
    local line = rect(footer, "BORDER", 1, 1, 1, 0.08)
    line:SetPoint("TOPLEFT"); line:SetPoint("TOPRIGHT"); line:SetHeight(1)

    local popup = textButton(footer, "", 210, 22)
    popup:SetPoint("LEFT", 10, 0)
    popup:SetScript("OnClick", function() ns.CyclePopup(); ns.Refresh() end)
    popup:HookScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine("Open the news on login")
        GameTooltip:AddLine("New stories: only when there's a story you haven't seen.", 1, 1, 1, true)
        GameTooltip:AddLine("Click to change.", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    popup:HookScript("OnLeave", function() GameTooltip:Hide() end)
    footer.popup = popup

    footer.status = text(footer, HEAD_FONT, 10, MUTED)
    footer.status:SetPoint("RIGHT", -12, 0)
    footer.status:SetJustifyH("RIGHT")
    footer.status:SetJustifyV("MIDDLE")
end

-- ------------------------------------------------------------------------------------------------ front page

local rows = {}
local tabButtons = {}
local tab = "all"            -- the front page's tab: "all", "new" or a category
local list = {}              -- the stories the front page shows (and Prev/Next walks)

-- Category tabs, in this order when the edition has stories in them.
local TAB_ORDER = { "Breaking", "Hotfixes", "Patch Notes", "Maintenance", "Events", "News", "Guides", "Community" }

--- The tabs for this edition: { key, label, count }.
function ns.Tabs()
    local stories = ns.Stories()
    local counts, unread = {}, 0
    for _, s in ipairs(stories) do
        local c = s.category or "News"
        counts[c] = (counts[c] or 0) + 1
        if ns.IsUnread(s) then unread = unread + 1 end
    end
    local out = { { key = "all", label = "ALL", count = #stories }, { key = "new", label = "NEW", count = unread } }
    local listed = {}
    for _, c in ipairs(TAB_ORDER) do
        if counts[c] then out[#out + 1] = { key = c, label = c:upper(), count = counts[c] }; listed[c] = true end
    end
    for c, n in pairs(counts) do      -- a category the addon doesn't know yet still gets a tab
        if not listed[c] then out[#out + 1] = { key = c, label = c:upper(), count = n } end
    end
    return out
end

--- Stories on a tab, newest first.
function ns.Filter(key)
    local out = {}
    for _, s in ipairs(ns.Stories()) do
        if key == "all" or (key == "new" and ns.IsUnread(s)) or (s.category or "News") == key then out[#out + 1] = s end
    end
    return out
end

function ns.Tab() return tab, list end

local function getTabButton(i)
    if tabButtons[i] then return tabButtons[i] end
    local b = CreateFrame("Button", nil, home.tabs)
    b:SetHeight(TABS_H)
    b.hl = rect(b, "BACKGROUND", 1, 1, 1, 0.06)
    b.hl:SetAllPoints()
    b.hl:Hide()
    b.label = text(b, HEAD_FONT, 11, MUTED)
    b.label:SetPoint("LEFT", 10, 0)
    b.label:SetJustifyV("MIDDLE")
    b.line = rect(b, "ARTWORK", GOLD[1], GOLD[2], GOLD[3], 1)
    b.line:SetPoint("BOTTOMLEFT"); b.line:SetPoint("BOTTOMRIGHT"); b.line:SetHeight(2)
    b:SetScript("OnEnter", function(self) self.hl:Show() end)
    b:SetScript("OnLeave", function(self) self.hl:Hide() end)
    b:SetScript("OnClick", function(self) ns.SetTab(self.key) end)
    tabButtons[i] = b
    return b
end

local function refreshTabs()
    local tabs = ns.Tabs()
    local known = false
    for _, t in ipairs(tabs) do if t.key == tab then known = true end end
    if not known then tab = "all" end      -- that category left the edition
    for _, b in ipairs(tabButtons) do b:Hide() end
    local x, pad = 0, 20
    -- squeeze the padding if the edition has many categories
    local total = 0
    for _, t in ipairs(tabs) do total = total + #t.label * 7 + 30 end
    if total > CW then pad = 10 end
    for i, t in ipairs(tabs) do
        local b = getTabButton(i)
        b.key = t.key
        local active = t.key == tab
        local col = (t.key == "all" or t.key == "new") and GOLD or catColor(t.key)
        local num = t.count > 0 and ("  |cff8f8aa6" .. t.count .. "|r") or ""
        if t.key == "new" and t.count > 0 then num = "  |cfff2c46b" .. t.count .. "|r" end
        b.label:SetText(t.label .. num)
        if active then b.label:SetTextColor(1, 1, 1) else b.label:SetTextColor(MUTED[1], MUTED[2], MUTED[3]) end
        b.line:SetColorTexture(col[1], col[2], col[3], 1)
        b.line:SetShown(active)
        b:SetWidth((b.label:GetStringWidth() or 40) + pad)
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", home.tabs, "TOPLEFT", x, 0)
        b:Show()
        x = x + b:GetWidth() + 2
    end
end

local function buildHome()
    home = CreateFrame("Frame", nil, f)
    home:SetPoint("TOPLEFT", PAD, -(HEADER_H + PAD))
    home:SetSize(CW, CH - PAD)

    -- the top story
    local hero = CreateFrame("Button", nil, home)
    hero:SetPoint("TOPLEFT", 0, -BODY_Y)
    hero:SetSize(HERO_W, CH - PAD - BODY_Y)
    hero.img = hero:CreateTexture(nil, "ARTWORK")
    hero.img:SetPoint("TOPLEFT")
    hero.img:SetSize(HERO_W, HERO_IMG_H)
    local frame = CreateFrame("Frame", nil, hero)
    frame:SetAllPoints(hero.img)
    border(frame, GOLD[1], GOLD[2], GOLD[3], 0.35)
    hero.shine = rect(hero, "OVERLAY", 1, 1, 1, 0.07)
    hero.shine:SetAllPoints(hero.img)
    hero.shine:Hide()
    hero.kicker = text(hero, HEAD_FONT, 10, GOLD)
    hero.kicker:SetPoint("TOPLEFT", hero.img, "BOTTOMLEFT", 0, -12)
    hero.kicker:SetText("TOP STORY")
    hero.chip = chip(hero)
    hero.chip:SetPoint("LEFT", hero.kicker, "RIGHT", 10, 0)
    hero.meta = text(hero, HEAD_FONT, 10, MUTED)
    hero.meta:SetPoint("LEFT", hero.chip, "RIGHT", 10, 0)
    hero.headline = text(hero, HEAD_FONT, 19, INK)
    hero.headline:SetPoint("TOPLEFT", hero.img, "BOTTOMLEFT", 0, -38)
    hero.headline:SetWidth(HERO_W)
    hero.headline:SetMaxLines(3)
    hero.headline:SetSpacing(2)
    hero.dek = text(hero, BODY_FONT, 14, SOFT)
    hero.dek:SetPoint("TOPLEFT", hero.headline, "BOTTOMLEFT", 0, -8)
    hero.dek:SetWidth(HERO_W)
    hero.dek:SetMaxLines(4)
    hero.dek:SetSpacing(2)
    hero.more = text(hero, HEAD_FONT, 10, GOLD)
    hero.more:SetPoint("TOPLEFT", hero.dek, "BOTTOMLEFT", 0, -10)
    hero.more:SetText("READ THE STORY  >")
    hero:SetScript("OnEnter", function(self) self.shine:Show(); self.headline:SetTextColor(GOLD[1], GOLD[2], GOLD[3]) end)
    hero:SetScript("OnLeave", function(self) self.shine:Hide(); self.headline:SetTextColor(INK[1], INK[2], INK[3]) end)
    hero:SetScript("OnClick", function(self) if self.story then ns.OpenStory(self.story.id) end end)
    home.hero = hero

    -- the rest
    local label = text(home, HEAD_FONT, 10, GOLD)
    label:SetPoint("TOPLEFT", LIST_X, -BODY_Y)
    label:SetText("MORE HEADLINES")
    home.listLabel = label
    local sf, child = scrollArea(home, LIST_W, CH - PAD - BODY_Y - 22)
    sf:SetPoint("TOPLEFT", LIST_X, -(BODY_Y + 20))
    home.list, home.listChild = sf, child

    home.empty = text(home, BODY_FONT, 15, SOFT)
    home.empty:SetPoint("CENTER")
    home.empty:SetJustifyH("CENTER")
    home.empty:SetWidth(460)
    home.empty:SetText("No stories in this edition yet.\nUpdate the addon to get the latest WoW: Forever news.")

    -- tab bar: All, New (unread), then one tab per category in this edition
    home.tabs = CreateFrame("Frame", nil, home)
    home.tabs:SetPoint("TOPLEFT")
    home.tabs:SetSize(CW, TABS_H)
    local base = rect(home.tabs, "BACKGROUND", 1, 1, 1, 0.08)
    base:SetPoint("BOTTOMLEFT"); base:SetPoint("BOTTOMRIGHT"); base:SetHeight(1)
end

local function getRow(i)
    if rows[i] then return rows[i] end
    local child = home.listChild
    local r = CreateFrame("Button", nil, child)
    r:SetSize(LIST_W - 14, ROW_H - 6)
    r:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_H)
    r.hl = rect(r, "BACKGROUND", 1, 1, 1, 0.07)
    r.hl:SetAllPoints()
    r.hl:Hide()
    r.thumb = r:CreateTexture(nil, "ARTWORK")
    r.thumb:SetSize(104, 52)
    r.thumb:SetPoint("TOPLEFT", 4, -6)
    r.dot = r:CreateTexture(nil, "OVERLAY")
    r.dot:SetTexture(ns.MEDIA .. "dot")
    r.dot:SetVertexColor(GOLD[1], GOLD[2], GOLD[3])
    r.dot:SetSize(10, 10)
    r.dot:SetPoint("TOPLEFT", r.thumb, "TOPLEFT", -4, 4)
    r.cat = text(r, HEAD_FONT, 9, GOLD)
    r.cat:SetPoint("TOPLEFT", r.thumb, "TOPRIGHT", 10, 1)
    r.headline = text(r, HEAD_FONT, 12, INK)
    r.headline:SetPoint("TOPLEFT", r.cat, "BOTTOMLEFT", 0, -3)
    r.headline:SetWidth(LIST_W - 14 - 122)
    r.headline:SetMaxLines(2)
    r.meta = text(r, HEAD_FONT, 9, MUTED)
    r.meta:SetPoint("BOTTOMLEFT", r.thumb, "BOTTOMRIGHT", 10, -6)
    r:SetScript("OnEnter", function(self) self.hl:Show(); self.headline:SetTextColor(GOLD[1], GOLD[2], GOLD[3]) end)
    r:SetScript("OnLeave", function(self) self.hl:Hide(); self.headline:SetTextColor(INK[1], INK[2], INK[3]) end)
    r:SetScript("OnClick", function(self) if self.story then ns.OpenStory(self.story.id) end end)
    rows[i] = r
    return r
end

local function refreshHome()
    refreshTabs()
    list = ns.Filter(tab)
    local stories = list
    local now = ns.Now()
    local top = stories[1]
    if top == nil then
        if #ns.Stories() == 0 then
            home.empty:SetText("No stories in this edition yet.\nUpdate the addon to get the latest WoW: Forever news.")
        elseif tab == "new" then
            home.empty:SetText("You're all caught up.\nEvery story in this edition has been read.")
        else
            home.empty:SetText("Nothing here in this edition.")
        end
    end
    home.empty:SetShown(top == nil)
    home.hero:SetShown(top ~= nil)
    home.list:SetShown(top ~= nil)
    home.listLabel:SetShown(#stories > 1)
    for _, r in ipairs(rows) do r:Hide(); r.story = nil end
    if not top then return end

    local hero = home.hero
    hero.story = top
    setImage(hero.img, top.images[1])
    hero.chip:Set(top.category)
    hero.meta:SetText(safe(ns.Meta(top, now)))
    hero.headline:SetText(safe(top.headline))
    hero.dek:SetText(safe(top.dek or top.body[1] or ""))
    local kick = tab == "all" and "TOP STORY" or tab == "new" and "NEWEST" or "LATEST"
    hero.kicker:SetText(ns.IsUnread(top) and (kick .. "  |cfff2c46b•|r") or kick)

    for i = 2, #stories do
        local s = stories[i]
        local r = getRow(i - 1)
        r.story = s
        setImage(r.thumb, s.images[1])
        r.cat:SetText(safe(s.category or "News"):upper())
        local col = catColor(s.category)
        r.cat:SetTextColor(col[1], col[2], col[3])
        r.headline:SetText(safe(s.headline))
        r.meta:SetText(safe(ns.Meta(s, now)))
        r.dot:SetShown(ns.IsUnread(s))
        r:Show()
    end
    home.listChild:SetHeight(math.max(1, (#stories - 1) * ROW_H))
    home.list:UpdateThumb()
end

-- ------------------------------------------------------------------------------------------------ article

-- Reusable widgets for the article body (recycled every time a story opens).
local pools = {}
local function acquire(kind, make)
    local p = pools[kind]
    if not p then p = { used = 0 }; pools[kind] = p end
    p.used = p.used + 1
    local w = p[p.used]
    if not w then w = make(); p[p.used] = w end
    w:ClearAllPoints()
    w:Show()
    return w
end
local function releaseAll()
    for _, p in pairs(pools) do
        for i = 1, #p do p[i]:Hide() end
        p.used = 0
    end
end

local function buildArticle()
    article = CreateFrame("Frame", nil, f)
    article:SetPoint("TOPLEFT", PAD, -(HEADER_H + 10))
    article:SetSize(CW, CH - 6)
    article:Hide()

    local back = textButton(article, "<  ALL NEWS", 110, 24)
    back:SetPoint("TOPLEFT")
    back:SetScript("OnClick", function() ns.ShowHome() end)
    local nextB = textButton(article, "NEXT  >", 80, 24)
    nextB:SetPoint("TOPRIGHT", -10, 0)
    nextB:SetScript("OnClick", function() ns.Step(1) end)
    local prevB = textButton(article, "<  PREV", 80, 24)
    prevB:SetPoint("RIGHT", nextB, "LEFT", -6, 0)
    prevB:SetScript("OnClick", function() ns.Step(-1) end)
    article.count = text(article, HEAD_FONT, 10, MUTED)
    article.count:SetPoint("RIGHT", prevB, "LEFT", -10, 0)
    article.count:SetJustifyH("RIGHT")
    article.prev, article.next = prevB, nextB

    local sf, child = scrollArea(article, CW, CH - 6 - 32)
    sf:SetPoint("TOPLEFT", 0, -32)
    article.scroll, article.child = sf, child
    local colX = math.floor((CW - 10 - COL_W) / 2)
    article.colX = colX

    -- gallery (fixed, at the top of the scroll child)
    local imgH = COL_W / 2
    local img = child:CreateTexture(nil, "ARTWORK")
    img:SetSize(COL_W, imgH)
    img:SetPoint("TOPLEFT", colX, 0)
    article.img = img
    local imgFrame = CreateFrame("Frame", nil, child)
    imgFrame:SetAllPoints(img)
    border(imgFrame, GOLD[1], GOLD[2], GOLD[3], 0.35)
    local function arrow(label, dir)
        local b = textButton(imgFrame, label, 34, 54)
        b.bg:SetColorTexture(0, 0, 0, 0.55)
        b:SetScript("OnLeave", function(self) self.bg:SetColorTexture(0, 0, 0, 0.55); self.label:SetTextColor(SOFT[1], SOFT[2], SOFT[3]) end)
        b:SetScript("OnClick", function() ns.ShowImage(imageIndex + dir) end)
        return b
    end
    article.imgPrev = arrow("<", -1); article.imgPrev:SetPoint("LEFT", 6, 0)
    article.imgNext = arrow(">", 1); article.imgNext:SetPoint("RIGHT", -6, 0)
    article.caption = text(child, HEAD_FONT, 9, MUTED)
    article.caption:SetPoint("TOPLEFT", img, "BOTTOMLEFT", 0, -5)
    article.caption:SetWidth(COL_W)
    article.caption:SetJustifyH("RIGHT")
    article.imgH = imgH
end

function ns.ShowImage(i)
    local imgs = current and current.images or {}
    local n = #imgs
    if n == 0 then
        setImage(article.img, nil)
        article.caption:SetText("")
        article.imgPrev:Hide(); article.imgNext:Hide()
        return
    end
    if i < 1 then i = n elseif i > n then i = 1 end
    imageIndex = i
    local img = imgs[i]
    setImage(article.img, img)
    local cap = {}
    if n > 1 then cap[#cap + 1] = i .. " / " .. n end
    if img.caption and img.caption ~= "" then cap[#cap + 1] = safe(img.caption) end
    if img.credit and img.credit ~= "" then cap[#cap + 1] = "Image: " .. safe(img.credit) end
    article.caption:SetText(table.concat(cap, "   ·   "))
    article.imgPrev:SetShown(n > 1)
    article.imgNext:SetShown(n > 1)
end

local function copyBox(parent)
    local e = CreateFrame("EditBox", nil, parent)
    e:SetSize(COL_W - 120, 22)
    e:SetAutoFocus(false)
    e:SetFont(BODY_FONT, 13, "")
    e:SetTextColor(0.55, 0.78, 1)
    e:SetTextInsets(6, 6, 0, 0)
    local bg = rect(e, "BACKGROUND", 0, 0, 0, 0.45); bg:SetAllPoints()
    border(e, 1, 1, 1, 0.12)
    e:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
    e:SetScript("OnEditFocusLost", function(self) self:HighlightText(0, 0) end)
    e:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    e:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    -- read-only: typing puts the link back
    e:SetScript("OnTextChanged", function(self, user) if user and self.url then self:SetText(self.url); self:HighlightText() end end)
    e:SetScript("OnMouseUp", function(self) self:SetFocus(); self:HighlightText() end)
    return e
end

local function layoutArticle(s)
    releaseAll()
    local child, x = article.child, article.colX
    local y = article.imgH + 22          -- below the gallery + caption

    local function place(widget, dx, gap)
        widget:SetPoint("TOPLEFT", child, "TOPLEFT", x + (dx or 0), -y)
        return widget
    end
    local function fs(kind, font, size, color, width)
        local w = acquire(kind, function() return text(child, font, size, color) end)
        w:SetWidth(width or COL_W)
        return w
    end
    local function heightOf(w) return math.ceil(w:GetStringHeight() or 14) end

    -- chip + meta
    local c = acquire("chip", function() return chip(child) end)
    c:Set(s.category)
    place(c)
    local meta = fs("meta", HEAD_FONT, 10, MUTED, COL_W - 120)
    meta:SetPoint("LEFT", c, "RIGHT", 10, 0)
    meta:SetText(safe(ns.Meta(s)))
    y = y + 18 + 12

    local hl = fs("headline", HEAD_FONT, 22, INK)
    hl:SetSpacing(3)
    hl:SetText(safe(s.headline))
    place(hl)
    y = y + heightOf(hl) + 10

    if s.dek and s.dek ~= "" then
        local dek = fs("dek", BODY_FONT, 16, GOLD)
        dek:SetSpacing(2)
        dek:SetText(safe(s.dek))
        place(dek)
        y = y + heightOf(dek) + 14
    end

    local rule = acquire("rule", function() return rect(child, "ARTWORK", GOLD[1], GOLD[2], GOLD[3], 0.3) end)
    rule:SetSize(COL_W, 1)
    place(rule)
    y = y + 16

    for _, p in ipairs(s.body) do
        local para = fs("para", BODY_FONT, 15, INK)
        para:SetSpacing(3)
        para:SetText(safe(p))
        place(para)
        y = y + heightOf(para) + 12
    end

    if #s.bullets > 0 then
        y = y + 6
        local head = fs("section", HEAD_FONT, 11, GOLD)
        head:SetText(s.category == "Hotfixes" and "WHAT CHANGED" or "KEY POINTS")
        place(head)
        y = y + 22
        for _, b in ipairs(s.bullets) do
            local dot = fs("bulletdot", BODY_FONT, 15, GOLD, 14)
            dot:SetText("•")
            place(dot, 2)
            local line = fs("bullet", BODY_FONT, 15, INK, COL_W - 20)
            line:SetSpacing(2)
            line:SetText(safe(b))
            place(line, 18)
            y = y + heightOf(line) + 8
        end
    end

    if #s.sources > 0 then
        y = y + 14
        local head = fs("section", HEAD_FONT, 11, GOLD)
        head:SetText("READ THE FULL STORY")
        place(head)
        y = y + 22
        for _, src in ipairs(s.sources) do
            if type(src) == "table" and src.url then
                local name = fs("srcname", HEAD_FONT, 11, SOFT, 110)
                name:SetText(safe(src.name or "Source"))
                place(name, 0)
                local box = acquire("copybox", function() return copyBox(child) end)
                box.url = src.url
                box:SetText(src.url)
                box:SetCursorPosition(0)
                box:SetPoint("TOPLEFT", child, "TOPLEFT", x + 115, -(y - 5))
                y = y + 28
            end
        end
        local hint = fs("hint", HEAD_FONT, 9, MUTED)
        hint:SetText("Click a link, then Ctrl+C to copy it into your browser.")
        place(hint)
        y = y + 18
    end

    y = y + 10
    local credit = fs("credit", HEAD_FONT, 9, MUTED)
    credit:SetText("Written for Azeroth After Dark from the reporting above  ·  wow.afterdark.fm")
    place(credit)
    y = y + 30

    child:SetHeight(y)
    article.scroll:ScrollTo(0)
end

local function indexIn(t, id)
    for i, s in ipairs(t) do if s.id == id then return i end end
end

function ns.OpenStory(id)
    local s = ns.Find(id)
    if not s then return end
    if not f then ns.Build() end
    -- Prev/Next walk the tab the story was opened from; a story that isn't on it (opened from elsewhere) walks All
    local index = indexIn(list, id)
    if not index then list = ns.Stories(); index = indexIn(list, id) end
    current = s
    view = "article"
    home:Hide()
    article:Show()
    imageIndex = 1
    ns.ShowImage(1)
    layoutArticle(s)
    local n = #list
    article.count:SetText(index .. " of " .. n .. (tab ~= "all" and ("  ·  " .. (tab == "new" and "NEW" or tab:upper())) or ""))
    article.prev:SetShown(index > 1)
    article.next:SetShown(index < n)
    ns.MarkRead(s)
    if not f:IsShown() then f:Show() end
end

function ns.Step(dir)
    if not current then return end
    local i = indexIn(list, current.id)
    local s = list[(i or 1) + dir]
    if s then ns.OpenStory(s.id) end
end

function ns.SetTab(key)
    tab = key or "all"
    if home then
        home.list:ScrollTo(0)
        ns.ShowHome()
    end
end

function ns.ShowHome()
    view = "home"
    current = nil
    if article then article:Hide() end
    if home then home:Show(); refreshHome() end
end

-- ------------------------------------------------------------------------------------------------ public

function ns.Build()
    if f then return f end
    f = CreateFrame("Frame", "AzerothAfterDarkFrame", UIParent)
    f:SetSize(W, H)
    f:SetFrameStrata("HIGH")
    f:SetToplevel(true)
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    local bg = rect(f, "BACKGROUND", 0.045, 0.04, 0.085, 0.97); bg:SetAllPoints()
    border(f, GOLD[1], GOLD[2], GOLD[3], 0.5)
    f:Hide()
    ns.ResetPosition()
    tinsert(UISpecialFrames, "AzerothAfterDarkFrame")   -- Escape closes it

    buildHeader()
    buildFooter()
    buildHome()
    buildArticle()

    f:SetScript("OnShow", function() ns.Refresh() end)
    f:SetScript("OnHide", function() ns.MarkSeen(); ns.UpdateMinimapButton() end)
    return f
end

function ns.Refresh()
    if not f then return end
    local news = ns.News()
    local edition = tonumber(news.generated) or 0
    local stories = ns.Stories()
    local sub = "WoW: FOREVER NEWS"
    if edition > 0 then sub = sub .. "   ·   EDITION " .. date("%b ", edition):upper() .. tonumber(date("%d", edition)) end
    f.subtitle:SetText(sub)
    footer.popup.label:SetText("Show on login:  |cfff2c46b" .. ns.POPUP_LABELS[ns.db.popup] .. "|r")

    local age = ns.EditionAge()
    local unread = ns.UnreadCount()
    if age and age > 4 then
        footer.status:SetText("|cffff9933This edition is " .. math.floor(age) .. " days old. Update the addon for the latest news.|r")
    else
        footer.status:SetText(#stories .. " stories" .. (unread > 0 and ("  ·  |cfff2c46b" .. unread .. " unread|r") or "") .. "   ·   /aad")
    end
    if view == "article" and current then
        -- keep the article and the list Prev/Next walks (on New, the story just read has left the tab)
        local keep = list
        refreshHome()
        list = keep
        home:Hide()
    else
        ns.ShowHome()
    end
end

function ns.OnReadChanged()
    if f and f:IsShown() then
        if view == "home" then refreshHome() end
        local unread = ns.UnreadCount()
        local stories = ns.Stories()
        local age = ns.EditionAge()
        if not (age and age > 4) then
            footer.status:SetText(#stories .. " stories" .. (unread > 0 and ("  ·  |cfff2c46b" .. unread .. " unread|r") or "") .. "   ·   /aad")
        end
    end
    ns.UpdateMinimapButton()
end

function ns.Show(id)
    ns.Build()
    if id then ns.OpenStory(id) return end
    view = "home"
    f:Show()
    ns.Refresh()
end

function ns.Hide() if f then f:Hide() end end

function ns.Toggle()
    if f and f:IsShown() then f:Hide() else ns.Show() end
end

function ns.IsShown() return f ~= nil and f:IsShown() end
function ns.View() return view, current end

-- ------------------------------------------------------------------------------------------------ minimap

local mm
local atan2 = math.atan2 or function(y, x) return math.atan(y, x) end

local function placeMinimap()
    local a = math.rad(ns.db.minimap.angle or 215)
    local r = (Minimap:GetWidth() or 140) / 2 + 8
    mm:ClearAllPoints()
    mm:SetPoint("CENTER", Minimap, "CENTER", math.cos(a) * r, math.sin(a) * r)
end

function ns.CreateMinimapButton()
    if mm or not Minimap then return end
    mm = CreateFrame("Button", "AzerothAfterDarkMinimapButton", Minimap)
    mm:SetSize(32, 32)
    mm:SetFrameStrata("MEDIUM")
    mm:SetFrameLevel(8)
    mm.icon = mm:CreateTexture(nil, "ARTWORK")
    mm.icon:SetTexture(ns.MEDIA .. "logo")
    mm.icon:SetAllPoints()
    mm.hl = mm:CreateTexture(nil, "HIGHLIGHT")
    mm.hl:SetTexture(ns.MEDIA .. "logo")
    mm.hl:SetAllPoints()
    mm.hl:SetBlendMode("ADD")
    mm.hl:SetAlpha(0.35)
    mm.badge = mm:CreateTexture(nil, "OVERLAY")
    mm.badge:SetTexture(ns.MEDIA .. "dot")
    mm.badge:SetVertexColor(0.9, 0.2, 0.2)
    mm.badge:SetSize(15, 15)
    mm.badge:SetPoint("TOPRIGHT", 3, 3)
    mm.count = mm:CreateFontString(nil, "OVERLAY")
    mm.count:SetFont(HEAD_FONT, 9, "OUTLINE")
    mm.count:SetPoint("CENTER", mm.badge, "CENTER", 0, 0)
    mm:RegisterForClicks("AnyUp")
    mm:RegisterForDrag("LeftButton")
    mm:SetScript("OnClick", function() ns.Toggle() end)
    mm:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local sc = Minimap:GetEffectiveScale()
            ns.db.minimap.angle = math.deg(atan2(py / sc - my, px / sc - mx))
            placeMinimap()
        end)
    end)
    mm:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
    mm:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Azeroth After Dark", GOLD[1], GOLD[2], GOLD[3])
        local top = ns.Stories()[1]
        if top then GameTooltip:AddLine(top.headline, 1, 1, 1, true) end
        local n = ns.UnreadCount()
        GameTooltip:AddLine(n > 0 and (n .. " unread " .. (n == 1 and "story" or "stories")) or "You're all caught up", 0.7, 0.7, 0.8)
        GameTooltip:AddLine("Click: open the news   Drag: move", 0.5, 0.5, 0.6)
        GameTooltip:Show()
    end)
    mm:SetScript("OnLeave", function() GameTooltip:Hide() end)
    placeMinimap()
    ns.UpdateMinimapButton()
end

function ns.UpdateMinimapButton()
    if not mm then return end
    mm:SetShown(not ns.db.minimap.hide)
    local n = ns.UnreadCount()
    mm.badge:SetShown(n > 0)
    mm.count:SetShown(n > 0)
    mm.count:SetText(n > 9 and "9+" or tostring(n))
end
