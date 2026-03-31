local STRING_UTIL     = require("app/lib/util/stringUtil")
local TRACKING_DATA   = require("app/lib/scheduling/trackingData")
local FREQUENCY       = require("app/lib/scheduling/frequency")
local SESSION         = require("app/lib/scheduling/session")
local GET_PASSAGE     = require("app/lib/bible/getPassage")
local PASSAGE_CLOAKER = require("app/lib/cloak/passageCloaker")
local WORD_CLOAKER    = require("app/lib/cloak/wordCloaker")

-- ── schedule data (reloaded each session) ────────────────────────────────────

local scheduleList = require("data/scheduling/scheduleList")

-- mutable passage state — reassigned by loadNextScripture
local trackData, selected, passageArgs, maxLength
local passageResult, cloaked, cloakedLines, uncloakedLines, expectedWords, ref

-- mutable interaction state — reset by loadNextScripture
local inputText, feedback, peekOn, originalFilter, resultRecorded

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
    maxLength       = math.max(0, newFilter)
    selected.filter = maxLength
    TRACKING_DATA.save(trackData)
    cloaked         = PASSAGE_CLOAKER:execute { result = passageResult, maxLength = maxLength }
    cloakedLines    = buildLines(cloaked)
    SESSION.save(SESSION.collectFromPassage(passageResult, maxLength))
    expectedWords   = SESSION.load()
end

-- ── load / refresh ────────────────────────────────────────────────────────────

local function loadNextScripture()
    trackData = TRACKING_DATA.load()
    if not trackData then
        trackData = TRACKING_DATA.generate(scheduleList)
    else
        trackData = TRACKING_DATA.sync(trackData, scheduleList)
    end

    selected      = TRACKING_DATA.select(trackData)
    passageArgs   = STRING_UTIL:split(selected.reference, " ")
    passageResult = GET_PASSAGE(passageArgs)
    uncloakedLines = buildLines(passageResult)
    ref = passageResult.book .. " " .. passageResult.passage .. " (" .. passageResult.version .. ")"

    applyFilter(selected.filter)

    originalFilter = maxLength
    resultRecorded = false
    inputText      = ""
    feedback       = nil
    peekOn         = false

    if love.window then
        love.window.setTitle(ref)
    end
end

-- initial load
loadNextScripture()

-- ── layout constants ──────────────────────────────────────────────────────────

local PAD      = 40
local SPLIT    = 0.50
local BTN_W    = 90
local BTN_GAP  = 8
local LABEL_H  = 22
local LINE_GAP = 5

-- ── fonts ─────────────────────────────────────────────────────────────────────

local refFont   = love.graphics.newFont(15)
local verseFont = love.graphics.newFont(17)
local inputFont = love.graphics.newFont(16)
local fbFont    = love.graphics.newFont(15)
local numFont   = love.graphics.newFont(18)

love.window.setTitle(ref)
love.window.setMode(900, 650, { resizable = true, minwidth = 600, minheight = 450 })

-- ── recording helpers ─────────────────────────────────────────────────────────

local function recordSuccess()
    if maxLength ~= originalFilter then
        -- filter was already adjusted and saved by applyFilter; skip level bump
    else
        selected.level    = math.min(selected.level + 1, 24)
        selected.nextDate = os.time() + FREQUENCY[selected.level]
        TRACKING_DATA.save(trackData)
    end
end

local function recordFailure()
    if selected.nextDate == 0 then
        applyFilter(maxLength - 1)
    else
        selected.level    = 1
        selected.nextDate = 0
        TRACKING_DATA.save(trackData)
    end
end

-- ── evaluation ────────────────────────────────────────────────────────────────

local function evaluate()
    local given = WORD_CLOAKER.collectCloakedWords(inputText, maxLength)

    if #given ~= #expectedWords then
        feedback = {
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

    feedback = { correct = allCorrect, details = details }

    if not resultRecorded then
        resultRecorded = true
        if allCorrect then
            recordSuccess()
        else
            recordFailure()
        end
    end
end

local function okPressed()
    if feedback and feedback.correct then
        loadNextScripture()
    else
        evaluate()
    end
end

-- ── layout helpers ────────────────────────────────────────────────────────────

local function zoneLayout(W, H)
    local textW   = W - PAD * 2
    local splitY  = math.floor(H * SPLIT)
    local areaTop = splitY + 12
    local areaH   = H - PAD - areaTop
    local areaW   = textW - BTN_W - 10
    local btnX    = PAD + areaW + 10
    return textW, splitY, areaTop, areaH, areaW, btnX
end

local function buttonLayout(areaTop, areaH)
    local bh     = math.floor((areaH - LABEL_H - BTN_GAP * 4) / 4)
    local plusY  = areaTop
    local numY   = plusY  + bh      + BTN_GAP
    local minusY = numY   + LABEL_H + BTN_GAP
    local peekY  = minusY + bh      + BTN_GAP
    local okY    = peekY  + bh      + BTN_GAP
    return bh, plusY, numY, minusY, peekY, okY
end

-- ── love callbacks ────────────────────────────────────────────────────────────

function love.draw()
    local W, H = love.graphics.getDimensions()
    local textW, splitY, areaTop, areaH, areaW, btnX = zoneLayout(W, H)

    love.graphics.clear(0.08, 0.08, 0.13)

    -- passage lines
    local activeLines = peekOn and uncloakedLines or cloakedLines
    local y = PAD
    for _, line in ipairs(activeLines) do
        if y > splitY - 8 then break end

        if line.kind == "gap" then
            y = y + verseFont:getHeight() * 0.5
        elseif line.kind == "reference" then
            love.graphics.setFont(refFont)
            love.graphics.setColor(0.78, 0.65, 0.32)
            love.graphics.printf(line.text, PAD, y, textW, "left")
            local _, wrapped = refFont:getWrap(line.text, textW)
            y = y + #wrapped * math.ceil(refFont:getHeight() * refFont:getLineHeight()) + LINE_GAP
        else
            love.graphics.setFont(verseFont)
            love.graphics.setColor(0.92, 0.92, 0.92)
            love.graphics.printf(line.text, PAD, y, textW, "left")
            local _, wrapped = verseFont:getWrap(line.text, textW)
            y = y + #wrapped * math.ceil(verseFont:getHeight() * verseFont:getLineHeight()) + LINE_GAP
        end
    end

    -- divider
    love.graphics.setColor(0.25, 0.25, 0.38)
    love.graphics.line(PAD, splitY, W - PAD, splitY)

    -- feedback banner
    if feedback then
        local fbLineH  = fbFont:getHeight() + 4
        local numLines = 1 + (feedback.correct and 0 or #feedback.details)
        local fbH      = 12 + numLines * fbLineH
        local fbY      = areaTop

        if feedback.correct then
            love.graphics.setColor(0.07, 0.38, 0.07, 0.92)
        else
            love.graphics.setColor(0.38, 0.07, 0.07, 0.92)
        end
        love.graphics.rectangle("fill", PAD, fbY, areaW, fbH, 6, 6)

        love.graphics.setFont(fbFont)
        local fy = fbY + 6
        if feedback.correct then
            love.graphics.setColor(0.5, 1.0, 0.5)
            love.graphics.printf("CORRECT — press OK for next scripture", PAD, fy, areaW, "center")
        else
            love.graphics.setColor(1.0, 0.5, 0.5)
            love.graphics.printf("INCORRECT", PAD, fy, areaW, "center")
            fy = fy + fbLineH
            for _, detail in ipairs(feedback.details) do
                love.graphics.setColor(1.0, 0.78, 0.78)
                love.graphics.printf(detail, PAD + 12, fy, areaW - 12, "left")
                fy = fy + fbLineH
            end
        end

        areaTop = fbY + fbH + 8
        areaH   = H - PAD - areaTop
    end

    -- text area
    love.graphics.setColor(0.12, 0.12, 0.18)
    love.graphics.rectangle("fill", PAD, areaTop, areaW, areaH, 6, 6)
    love.graphics.setColor(0.4, 0.4, 0.65)
    love.graphics.rectangle("line", PAD, areaTop, areaW, areaH, 6, 6)

    local innerX = PAD + 12
    local innerY = areaTop + 10
    local innerW = areaW - 24

    love.graphics.setScissor(PAD + 2, areaTop + 2, areaW - 4, areaH - 4)
    love.graphics.setFont(inputFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(inputText, innerX, innerY, innerW, "left")

    if math.floor(love.timer.getTime() * 2) % 2 == 0 then
        local lineH = math.ceil(inputFont:getHeight() * inputFont:getLineHeight())
        local _, wrappedLines = inputFont:getWrap(inputText, innerW)
        if #wrappedLines == 0 then wrappedLines = { "" } end
        local lastLine = wrappedLines[#wrappedLines]
        local cx = innerX + inputFont:getWidth(lastLine)
        local cy = innerY + (#wrappedLines - 1) * lineH
        love.graphics.setColor(0.8, 0.8, 1.0)
        love.graphics.line(cx + 1, cy + 2, cx + 1, cy + inputFont:getHeight() - 2)
    end
    love.graphics.setScissor()

    -- right column buttons
    local bh, plusY, numY, minusY, peekY, okY = buttonLayout(areaTop, areaH)

    -- [ + ]
    love.graphics.setColor(0.18, 0.30, 0.45)
    love.graphics.rectangle("fill", btnX, plusY, BTN_W, bh, 6, 6)
    love.graphics.setColor(0.55, 0.80, 1.0)
    love.graphics.setFont(refFont)
    love.graphics.printf("+", btnX, plusY + (bh - refFont:getHeight()) / 2, BTN_W, "center")

    -- filter number label
    love.graphics.setFont(numFont)
    love.graphics.setColor(0.70, 0.70, 0.85)
    love.graphics.printf(tostring(maxLength), btnX, numY + (LABEL_H - numFont:getHeight()) / 2, BTN_W, "center")

    -- [ − ]
    love.graphics.setColor(0.18, 0.30, 0.45)
    love.graphics.rectangle("fill", btnX, minusY, BTN_W, bh, 6, 6)
    love.graphics.setColor(0.55, 0.80, 1.0)
    love.graphics.setFont(refFont)
    love.graphics.printf("−", btnX, minusY + (bh - refFont:getHeight()) / 2, BTN_W, "center")

    -- [ PEEK ]
    if peekOn then
        love.graphics.setColor(0.55, 0.42, 0.08)
    else
        love.graphics.setColor(0.20, 0.20, 0.28)
    end
    love.graphics.rectangle("fill", btnX, peekY, BTN_W, bh, 6, 6)
    love.graphics.setColor(peekOn and 1.0 or 0.55, peekOn and 0.82 or 0.55, peekOn and 0.25 or 0.65)
    love.graphics.printf("PEEK", btnX, peekY + (bh - refFont:getHeight()) / 2, BTN_W, "center")

    -- [ OK ] — label changes when correct
    if feedback and feedback.correct then
        love.graphics.setColor(0.10, 0.35, 0.42)
    else
        love.graphics.setColor(0.18, 0.42, 0.18)
    end
    love.graphics.rectangle("fill", btnX, okY, BTN_W, bh, 6, 6)
    love.graphics.setColor(0.55, 0.95, 0.55)
    love.graphics.printf(
        (feedback and feedback.correct) and "NEXT" or "OK",
        btnX, okY + (bh - refFont:getHeight()) / 2, BTN_W, "center"
    )
end

function love.textinput(t)
    if feedback and feedback.correct then return end
    inputText = inputText .. t
    feedback  = nil
end

function love.keypressed(key)
    if key == "backspace" then
        if feedback and feedback.correct then return end
        inputText = inputText:sub(1, -2)
        feedback  = nil
    elseif key == "return" or key == "kpenter" then
        if feedback and feedback.correct then
            loadNextScripture()
        else
            inputText = inputText .. "\n"
            feedback  = nil
        end
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button ~= 1 then return end
    local W, H = love.graphics.getDimensions()
    local _, _, areaTop, areaH, areaW, btnX = zoneLayout(W, H)

    if feedback then
        local fbLineH  = fbFont:getHeight() + 4
        local numLines = 1 + (feedback.correct and 0 or #feedback.details)
        local fbH      = 12 + numLines * fbLineH
        areaTop = areaTop + fbH + 8
        areaH   = H - PAD - areaTop
    end

    if x < btnX or x > btnX + BTN_W then return end

    local bh, plusY, numY, minusY, peekY, okY = buttonLayout(areaTop, areaH)

    if     y >= plusY  and y <= plusY  + bh then applyFilter(maxLength + 1)
    elseif y >= minusY and y <= minusY + bh then applyFilter(maxLength - 1)
    elseif y >= peekY  and y <= peekY  + bh then peekOn = not peekOn
    elseif y >= okY    and y <= okY    + bh then okPressed()
    end
end
