-- Main.lua

function setup()
    local schema = {
        title = "Bluetooth",
        backButton = {
            text = "General", 
            callback = function() print("Pressed back") end
        },
        elems = {
            {type="block",elems = {
                {type="SimpleArrow", text = "About", callback = function() print("HI") end },
                {type="SimpleArrow", text = "Software Update",rightText="Nice one!"},
                {type="SimpleArrow", text = "Usage", rightText = "Two"},
            }},
            {type="blank",amount=30},
            {type="MultiTextInput", lines = 5},
            {type="blank",amount=30},
            {type="text",text="Now Discovereable"},
            {type="blank",amount=5},
            {type="block",elems = {
                {type="TextInput", label = "username",shadowText="he-man"},
                {type="TextInput", label = "nickname"},
                {type="SimpleArrow", text = "Sounds",tag="temp"},
            }},
            {type="blank",amount=30},
            {type="block",elems = {
                {type="SimpleArrow", text = "Sounds"},
                {type="SimpleArrow", text = "Sounds"},
                {type="SimpleArrow", text = "Sounds"},
                {type="SimpleArrow", text = "Sounds"},
                {type="SimpleArrow", text = "Sounds"},
                {type="SimpleArrow", text = "Sounds"},
                {type="SimpleArrow", text = "Sounds"},
                {type="SimpleArrow", text = "Sounds"},
                {type="SimpleArrow", text = "Sounds"},
                {type="SimpleArrow", text = "Sounds"},
            }},
        }
    }
    
    p = AppleScreen(schema)
    p.taggedElems.temp:showHourGlass(true)
    --p.taggedElems.temp:setColors(color(255,0,0),color(255,0,0))
end


function draw()
    background(0)
    smooth()
    p:draw()
end

function touched(t)
    p:touched(t)
    if GLOBAL_SHOWKEYBOARD then
        GLOBAL_SHOWKEYBOARD = nil
        showKeyboard()
    end
end

function keyboard(key)
    --print("keyboard!")
    p:keyboard(key)
end
