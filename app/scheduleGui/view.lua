local View = {}
View.__index = View

function View.new()
    local self = setmetatable({}, View)

    -- layout constants
    self.PAD      = 40
    self.SPLIT    = 0.50
    self.BTN_W    = 90
    self.BTN_GAP  = 8
    self.LABEL_H  = 22
    self.LINE_GAP = 5

    -- fonts
    self.refFont   = love.graphics.newFont(15)
    self.verseFont = love.graphics.newFont(17)
    self.inputFont = love.graphics.newFont(16)
    self.fbFont    = love.graphics.newFont(15)
    self.numFont   = love.graphics.newFont(18)

    -- display state (populated by loadNextScripture / applyFilter)
    self.ref            = ""
    self.cloakedLines   = {}
    self.uncloakedLines = {}
    self.maxLength      = 0
    self.inputText      = ""
    self.feedback       = nil
    self.peekOn         = false

    return self
end

function View:zoneLayout(W, H)
    local textW   = W - self.PAD * 2
    local splitY  = math.floor(H * self.SPLIT)
    local areaTop = splitY + 12
    local areaH   = H - self.PAD - areaTop
    local areaW   = textW - self.BTN_W - 10
    local btnX    = self.PAD + areaW + 10
    return textW, splitY, areaTop, areaH, areaW, btnX
end

function View:buttonLayout(areaTop, areaH)
    local bh     = math.floor((areaH - self.LABEL_H - self.BTN_GAP * 4) / 4)
    local plusY  = areaTop
    local numY   = plusY  + bh           + self.BTN_GAP
    local minusY = numY   + self.LABEL_H + self.BTN_GAP
    local peekY  = minusY + bh           + self.BTN_GAP
    local okY    = peekY  + bh           + self.BTN_GAP
    return bh, plusY, numY, minusY, peekY, okY
end

function View:feedbackHeight()
    if not self.feedback then return 0 end
    local fbLineH  = self.fbFont:getHeight() + 4
    local numLines = 1 + (self.feedback.correct and 0 or #self.feedback.details)
    return 12 + numLines * fbLineH
end

function View:drawPassageLines(textW, splitY)
    local activeLines = self.peekOn and self.uncloakedLines or self.cloakedLines
    local y = self.PAD
    for _, line in ipairs(activeLines) do
        if y > splitY - 8 then break end

        if line.kind == "gap" then
            y = y + self.verseFont:getHeight() * 0.5
        elseif line.kind == "reference" then
            love.graphics.setFont(self.refFont)
            love.graphics.setColor(0.78, 0.65, 0.32)
            love.graphics.printf(line.text, self.PAD, y, textW, "left")
            local _, wrapped = self.refFont:getWrap(line.text, textW)
            y = y + #wrapped * math.ceil(self.refFont:getHeight() * self.refFont:getLineHeight()) + self.LINE_GAP
        else
            love.graphics.setFont(self.verseFont)
            love.graphics.setColor(0.92, 0.92, 0.92)
            love.graphics.printf(line.text, self.PAD, y, textW, "left")
            local _, wrapped = self.verseFont:getWrap(line.text, textW)
            y = y + #wrapped * math.ceil(self.verseFont:getHeight() * self.verseFont:getLineHeight()) + self.LINE_GAP
        end
    end
end

function View:drawDivider(W, splitY)
    love.graphics.setColor(0.25, 0.25, 0.38)
    love.graphics.line(self.PAD, splitY, W - self.PAD, splitY)
end

-- draws the feedback banner and returns the new areaTop below it
function View:drawFeedback(areaTop, areaW)
    if not self.feedback then return areaTop end

    local fbLineH  = self.fbFont:getHeight() + 4
    local fbH      = self:feedbackHeight()
    local fbY      = areaTop

    if self.feedback.correct then
        love.graphics.setColor(0.07, 0.38, 0.07, 0.92)
    else
        love.graphics.setColor(0.38, 0.07, 0.07, 0.92)
    end
    love.graphics.rectangle("fill", self.PAD, fbY, areaW, fbH, 6, 6)

    love.graphics.setFont(self.fbFont)
    local fy = fbY + 6
    if self.feedback.correct then
        love.graphics.setColor(0.5, 1.0, 0.5)
        love.graphics.printf("CORRECT — press OK for next scripture", self.PAD, fy, areaW, "center")
    else
        love.graphics.setColor(1.0, 0.5, 0.5)
        love.graphics.printf("INCORRECT", self.PAD, fy, areaW, "center")
        fy = fy + fbLineH
        for _, detail in ipairs(self.feedback.details) do
            love.graphics.setColor(1.0, 0.78, 0.78)
            love.graphics.printf(detail, self.PAD + 12, fy, areaW - 12, "left")
            fy = fy + fbLineH
        end
    end

    return fbY + fbH + 8
end

function View:drawTextArea(areaTop, areaH, areaW)
    love.graphics.setColor(0.12, 0.12, 0.18)
    love.graphics.rectangle("fill", self.PAD, areaTop, areaW, areaH, 6, 6)
    love.graphics.setColor(0.4, 0.4, 0.65)
    love.graphics.rectangle("line", self.PAD, areaTop, areaW, areaH, 6, 6)

    local innerX = self.PAD + 12
    local innerY = areaTop + 10
    local innerW = areaW - 24

    love.graphics.setScissor(self.PAD + 2, areaTop + 2, areaW - 4, areaH - 4)
    love.graphics.setFont(self.inputFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.inputText, innerX, innerY, innerW, "left")

    if math.floor(love.timer.getTime() * 2) % 2 == 0 then
        local lineH = math.ceil(self.inputFont:getHeight() * self.inputFont:getLineHeight())
        local _, wrappedLines = self.inputFont:getWrap(self.inputText, innerW)
        if #wrappedLines == 0 then wrappedLines = { "" } end
        local lastLine = wrappedLines[#wrappedLines]
        local cx = innerX + self.inputFont:getWidth(lastLine)
        local cy = innerY + (#wrappedLines - 1) * lineH
        love.graphics.setColor(0.8, 0.8, 1.0)
        love.graphics.line(cx + 1, cy + 2, cx + 1, cy + self.inputFont:getHeight() - 2)
    end
    love.graphics.setScissor()
end

function View:drawRightColumnButtons(btnX, areaTop, areaH)
    local bh, plusY, numY, minusY, peekY, okY = self:buttonLayout(areaTop, areaH)

    -- [ + ]
    love.graphics.setColor(0.18, 0.30, 0.45)
    love.graphics.rectangle("fill", btnX, plusY, self.BTN_W, bh, 6, 6)
    love.graphics.setColor(0.55, 0.80, 1.0)
    love.graphics.setFont(self.refFont)
    love.graphics.printf("+", btnX, plusY + (bh - self.refFont:getHeight()) / 2, self.BTN_W, "center")

    -- filter number label
    love.graphics.setFont(self.numFont)
    love.graphics.setColor(0.70, 0.70, 0.85)
    love.graphics.printf(tostring(self.maxLength), btnX, numY + (self.LABEL_H - self.numFont:getHeight()) / 2, self.BTN_W, "center")

    -- [ − ]
    love.graphics.setColor(0.18, 0.30, 0.45)
    love.graphics.rectangle("fill", btnX, minusY, self.BTN_W, bh, 6, 6)
    love.graphics.setColor(0.55, 0.80, 1.0)
    love.graphics.setFont(self.refFont)
    love.graphics.printf("−", btnX, minusY + (bh - self.refFont:getHeight()) / 2, self.BTN_W, "center")

    -- [ PEEK ]
    if self.peekOn then
        love.graphics.setColor(0.55, 0.42, 0.08)
    else
        love.graphics.setColor(0.20, 0.20, 0.28)
    end
    love.graphics.rectangle("fill", btnX, peekY, self.BTN_W, bh, 6, 6)
    love.graphics.setColor(self.peekOn and 1.0 or 0.55, self.peekOn and 0.82 or 0.55, self.peekOn and 0.25 or 0.65)
    love.graphics.printf("PEEK", btnX, peekY + (bh - self.refFont:getHeight()) / 2, self.BTN_W, "center")

    -- [ OK ] / [ NEXT ]
    if self.feedback and self.feedback.correct then
        love.graphics.setColor(0.10, 0.35, 0.42)
    else
        love.graphics.setColor(0.18, 0.42, 0.18)
    end
    love.graphics.rectangle("fill", btnX, okY, self.BTN_W, bh, 6, 6)
    love.graphics.setColor(0.55, 0.95, 0.55)
    love.graphics.printf(
        (self.feedback and self.feedback.correct) and "NEXT" or "OK",
        btnX, okY + (bh - self.refFont:getHeight()) / 2, self.BTN_W, "center"
    )
end

function View:draw()
    local W, H = love.graphics.getDimensions()
    local textW, splitY, areaTop, areaH, areaW, btnX = self:zoneLayout(W, H)

    love.graphics.clear(0.08, 0.08, 0.13)

    self:drawPassageLines(textW, splitY)
    self:drawDivider(W, splitY)
    areaTop = self:drawFeedback(areaTop, areaW)
    areaH   = H - self.PAD - areaTop
    self:drawTextArea(areaTop, areaH, areaW)
    self:drawRightColumnButtons(btnX, areaTop, areaH)
end

return View
