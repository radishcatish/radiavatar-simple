
vanilla_model.HAT:setVisible(false)
vanilla_model.HEAD:setVisible(false)
vanilla_model.JACKET:setVisible(false)
vanilla_model.CAPE:setVisible(false)
nameplate.ENTITY:setText('[{"text":"radi","color":"#ffeeb8"}]')
nameplate.CHAT:setText('[{"text":"radi","color":"#c2edff"}]')
nameplate.LIST:setText('[{"color":"#c2edff","text":"${name}"}]')
local vistimer = 0
function events.tick()
vistimer = math.max(vistimer - 1, 0)
models.model.Head.mouth:setVisible(vistimer > 0)
end

function events.render(_, ctx)

 
     models.model.Head:setVisible(not (ctx == "OTHER" and renderer:isFirstPerson())) 
 
end

local function meow()
    vistimer = 7
    for i=1,5 do sounds:stopSound("meow" .. i) end
    sounds["meow" .. tostring(math.random(1, 5))]
        :setPitch(math.random(75, 125) / 100)
        :setPos(player:getPos() + vec(0, 1.5, 0))
        :setSubtitle("Radi meows")
        :play()
end

function pings.meowmsg()
    vistimer = 5
    for i=1,5 do sounds:stopSound("meow" .. i) end
    sounds["text"]
        :setPitch(math.random(75, 125) / 100)
        :setPos(player:getPos() + vec(0, 1.5, 0))
        :setSubtitle("Radi meows")
        :play()
end


function pings.communicate()
    if player:isLoaded() then meow() end
end

keybinds:newKeybind("peak communication", "key.keyboard.r", false).press = function()
    pings.communicate()
end

function events.chat_send_message(msg)
    if msg:sub(1, 1) == "/" then
        return msg
    end
    pings.meowmsg()
    return msg
end
