-- Textbox.lua

-- for receiving input from keyboard

Textbox = class(Button)

function Textbox:init(x,y,w)
    Button.init(self,x,y,w,0) -- we don't know the height yet
    
    self.text = ""

    -- in font properties you can set fill,font,fontSize
    self.fontProperties = {font="Futura-CondensedExtraBold",fill=color(255,255,255)} 
    self:setFontSize(30)
    self.cursorColor = color(206,206,206,255)
    self.cursorWidth = 2
    self.cursorMarginY = 4
    self.align = "CENTER" -- can also be "LEFT"
    self.protected = false -- for passwords
    
    -- internal state
    self.selected = false
    self.cursorPos = 0  -- 0 means before the first letter, 1 after the first, so on
end

function Textbox:setFontSize(x)
    self.fontProperties.fontSize = x
    -- calculate the height based on font properties
    pushStyle()
    self:applyTextProperties()
    local w,h = textSize("dummy")
    popStyle()
    self.h = h
end

-- call back for when a key is pressed
function Textbox:keyboard(key)
    
    -- if not active, ignore
    if not self.selected then return nil end
    
    if key == BACKSPACE then
        --print(self.cursorPos)
        -- note if we're already at the start, nothing to do
        if self.cursorPos > 0 then
            local prefix = self.text:sub(1,self.cursorPos-1)
            local posfix = self.text:sub(self.cursorPos+1,self.text:len())
            self.text = prefix..posfix
            self.cursorPos = self.cursorPos - 1
        end
    else
        local prefix = self.text:sub(1,self.cursorPos)
        local posfix = self.text:sub(self.cursorPos+1,self.text:len())
        local proposedText = prefix..key..posfix
        pushStyle()
        self:applyTextProperties()
        local proposedW = textSize(proposedText)
        popStyle()
        if proposedW <= self:maxX() then
            -- we can add the new char
            self.text = proposedText
            self.cursorPos = self.cursorPos + 1
        end
    end
    
    if self.keycallback then self.keycallback(self.text) end
end

function Textbox:displayText()
    local displayText = self.text
    if self.protected then
        displayText = ""
        for i = 1,self.text:len() do displayText = displayText.."*" end
    end
    return displayText
end

function Textbox:applyTextProperties()
    textMode(CORNER)
    font(self.fontProperties.font)
    fontSize(self.fontProperties.fontSize)
    fill(self.fontProperties.fill)
end

function Textbox:maxX()
    return self.w - 10
end

function Textbox:draw()
    pushStyle()
    noSmooth()
    
    -- draw the bounding box
    rectMode(CORNER)
    strokeWidth(2)
    stroke(255, 255, 255, 255)
    noFill()
    rect(self.x,self.y,self.w,self.h)
    
    -- draw the text
    self:applyTextProperties()
    local displayText = self:displayText()
    local textW = textSize(displayText)
    local textX = self.x + (self.w - textW)/2
    if self.align == "LEFT" then textX = self.x end
    local textY = self.y
    if self.protected then textY = textY - self.h*.2 end
    text(displayText,textX,textY)

    if not self.selected then
        popStyle()
        return nil
    end

    -- draw the cursor
    if math.floor(ElapsedTime*4)%2 == 0 then
        stroke(self.cursorColor)
        strokeWidth(self.cursorWidth)
        local prefix = displayText:sub(1,self.cursorPos)
        local len = textSize(prefix)
        line(textX+len,self.y+self.cursorMarginY,textX+len,self.y+self.h-2*self.cursorMarginY)
    end

     popStyle()
end

function Textbox:touched(t)
    local didTouch = Button.touched(self,t)
    if not didTouch then self:unselect() end
    return didTouch
end

-- when the text box is active, the keyboard shows up (and coursor and other elements too)
function Textbox:select()
    self.selected = true
    -- move the cursor to the end
    self.cursorPos = self:displayText():len()
    GLOBAL_SHOWKEYBOARD = true
end

function Textbox:unselect()
    self.selected = false
    hideKeyboard()
end

function Textbox:onEnded(touch)
    if not self.selected then self:select() end
end

-- moves the cursor to the x coordinate of the touch
function Textbox:onTouched(touch)
    if not self.selected then return nil end
    
    self.cursorPos = 0

    pushStyle()
    self:applyTextProperties()
    local displayText = self:displayText()
    local textW = textSize(displayText)
    local textX = self.x + (self.w - textW)/2
    local touchX = touch.x - textX
    
    for idx = 1,self.text:len() do
        local len = textSize(displayText:sub(1,idx))
        if len > touchX then break end
        self.cursorPos = self.cursorPos + 1
    end
    popStyle()
end
