local STRING_UTIL     = require("app/lib/util/stringUtil")
local TRACKING_DATA   = require("app/lib/scheduling/trackingData")
local FREQUENCY       = require("app/lib/scheduling/frequency")
local SESSION         = require("app/lib/scheduling/session")
local GET_PASSAGE     = require("app/lib/bible/getPassage")
local PASSAGE_CLOAKER = require("app/lib/cloak/passageCloaker")
local WORD_CLOAKER    = require("app/lib/cloak/wordCloaker")

-- ── schedule data ─────────────────────────────────────────────────────────────

local scheduleList = require("data/scheduling/scheduleList")

-- SRS logic state — reassigned by loadNextScripture / applyFilter
local trackData, selected, passageArgs, passageResult, cloaked, expectedWords
local originalFilter, resultRecorded

-- forward declaration so applyFilter / loadNextScripture can set view fields
local view

-- ── build display lines ───────────────────────────────────────────────────────

local function buildLines(passage)
    local lines = {}
    local r = passage.book .. " " .. passage.passage .. " (" .. passage.version .. ")"
    table.insert(lines, { text = r,  kind = "reference" })
    table.insert(lines, { text = "", kind = "gap" })
    for _, ch in ipairs(passage.result) do
        if ch.warning then
            table.insert(lines, { text = "WARNING: " .. ch.warning, kind = "warning" })
        else
            for _, v in ipairs(ch) do
                if v.warning then
                    table.insert(lines, { text = "WARNING: " .. v.warning, kind = "warning" })
                else
                    for n, fragment in ipairs(v) do
                        if n == 1 then
                            table.insert(lines, { text = v.verse .. "  " .. fragment, kind = "verse" })
                        else
                            table.insert(lines, { text = "    " .. fragment, kind = "continuation" })
                        end
                    end
                end
            end
        end
    end
    table.insert(lines, { text = "", kind = "gap" })
    table.insert(lines, { text = r,  kind = "reference" })
    return lines
end

-- ── filter application ────────────────────────────────────────────────────────

local function applyFilter(newFilter)
    view.maxLength  = math.max(0, newFilter)
    selected.filter = view.maxLength
    TRACKING_DATA.save(trackData)
    cloaked            = PASSAGE_CLOAKER:execute { result = passageResult, maxLength = view.maxLength }
    view.cloakedLines  = buildLines(cloaked)
    SESSION.save(SESSION.collectFromPassage(passageResult, view.maxLength))
    expectedWords      = SESSION.load()
end

-- ── load / refresh ────────────────────────────────────────────────────────────

local function loadNextScripture()
    trackData = TRACKING_DATA.load()
    if not trackData then
        trackData = TRACKING_DATA.generate(scheduleList)
    else
        trackData = TRACKING_DATA.sync(trackData, scheduleList)
    end

    selected            = TRACKING_DATA.select(trackData)
    passageArgs         = STRING_UTIL:split(selected.reference, " ")
    passageResult       = GET_PASSAGE(passageArgs)
    view.uncloakedLines = buildLines(passageResult)
    view.ref            = passageResult.book .. " " .. passageResult.passage .. " (" .. passageResult.version .. ")"

    applyFilter(selected.filter)

    originalFilter  = view.maxLength
    resultRecorded  = false
    view.inputText  = ""
    view.feedback   = nil
    view.peekOn     = false

    if love.window then love.window.setTitle(view.ref) end
end

-- ── recording helpers ─────────────────────────────────────────────────────────

local function recordSuccess()
    if view.maxLength ~= originalFilter then
        -- filter was already adjusted and saved by applyFilter; skip level bump
    else
        selected.level    = math.min(selected.level + 1, 24)
        selected.nextDate = os.time() + FREQUENCY[selected.level]
        TRACKING_DATA.save(trackData)
    end
end

local function recordFailure()
    if selected.nextDate == 0 then
        applyFilter(view.maxLength - 1)
    else
        selected.level    = 1
        selected.nextDate = 0
        TRACKING_DATA.save(trackData)
    end
end

-- ── evaluation ────────────────────────────────────────────────────────────────

local function evaluate()
    local given = WORD_CLOAKER.collectCloakedWords(view.inputText, view.maxLength)

    if #given ~= #expectedWords then
        view.feedback = {
            correct = false,
            details = { string.format("Expected %d cloaked word(s), got %d.", #expectedWords, #given) },
        }
        if not resultRecorded then
            resultRecorded = true
            recordFailure()
        end
        return
    end

    local allCorrect = true
    local details    = {}
    for i, exp in ipairs(expectedWords) do
        if exp:lower() ~= (given[i] or ""):lower() then
            allCorrect = false
            table.insert(details, string.format("[%d] expected \"%s\", got \"%s\"", i, exp, given[i] or ""))
        end
    end

    view.feedback = { correct = allCorrect, details = details }

    if not resultRecorded then
        resultRecorded = true
        if allCorrect then recordSuccess() else recordFailure() end
    end
end

local function okPressed()
    if view.feedback and view.feedback.correct then
        loadNextScripture()
    else
        evaluate()
    end
end

-- ── View class ────────────────────────────────────────────────────────────────

local View = require("app/scheduleGui/view")

-- ── initialise ────────────────────────────────────────────────────────────────

view = View.new()
loadNextScripture()

love.window.setTitle(view.ref)
love.window.setMode(900, 650, { resizable = true, minwidth = 600, minheight = 450 })

-- ── love callbacks ────────────────────────────────────────────────────────────

function love.draw()
    view:draw()
end

function love.textinput(t)
    if view.feedback and view.feedback.correct then return end
    view.inputText = view.inputText .. t
    view.feedback  = nil
end

function love.keypressed(key)
    if key == "backspace" then
        if view.feedback and view.feedback.correct then return end
        view.inputText = view.inputText:sub(1, -2)
        view.feedback  = nil
    elseif key == "return" or key == "kpenter" then
        if view.feedback and view.feedback.correct then
            loadNextScripture()
        else
            view.inputText = view.inputText .. "\n"
            view.feedback  = nil
        end
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button ~= 1 then return end
    local W, H = love.graphics.getDimensions()
    local _, _, areaTop, areaH, areaW, btnX = view:zoneLayout(W, H)

    local fbH = view:feedbackHeight()
    if fbH > 0 then
        areaTop = areaTop + fbH + 8
        areaH   = H - view.PAD - areaTop
    end

    if x < btnX or x > btnX + view.BTN_W then return end

    local bh, plusY, _, minusY, peekY, okY = view:buttonLayout(areaTop, areaH)

    if     y >= plusY  and y <= plusY  + bh then applyFilter(view.maxLength + 1)
    elseif y >= minusY and y <= minusY + bh then applyFilter(view.maxLength - 1)
    elseif y >= peekY  and y <= peekY  + bh then view.peekOn = not view.peekOn
    elseif y >= okY    and y <= okY    + bh then okPressed()
    end
end
