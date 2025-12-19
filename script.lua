
vanilla_model.PLAYER:setVisible(false)
nameplate.ENTITY:setText('[{"text":"radi","color":"#ffeeb8"}]')
nameplate.ENTITY:setPivot(0, 2.5, 0)
nameplate.CHAT:setText('[{"text":"radi","color":"#c2edff"}]')
nameplate.LIST:setText('[{"color":"#c2edff","text":"${name}"}]')

function pings.communicate()
    if not player:isLoaded() then
        return
    end

    sounds:stopSound("meow1")
    sounds:stopSound("meow2")
    sounds:stopSound("meow3")
    sounds:playSound(
        "meow" .. tostring(math.random(1, 3)),
        player:getPos() + vec(0, 1.5, 0),
        1,
        math.random(75, 125) / 100
    )
    animations.model.communicate:restart()
end

keybinds:newKeybind("peak communication", "key.keyboard.r", false).press = function()
    pings.communicate()
end


