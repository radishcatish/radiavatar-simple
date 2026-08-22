
local function meow()
    animations.model.communicate:restart()
    for i=1,2 do sounds:stopSound("meow" .. i) end
    sounds["meow" .. tostring(math.random(1, 2))]
        :setPitch(math.random(75, 125) / 100)
        :setPos(models.model.Head:partToWorldMatrix():apply())
        :setSubtitle("Radi meows")
        :play()
end
function pings.meowmsg()
    animations.model.message:restart()
    for i=1,2 do sounds:stopSound("meow" .. i) end
    sounds["text"]
        :setPitch(math.random(75, 125) / 100)
        :setPos(models.model.Head:partToWorldMatrix():apply())
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
    pings.meowmsg()
    return msg
end



vanilla_model.HAT:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.JACKET:setVisible(false)
models.model.Head:setSecondaryTexture("CUSTOM", textures["star"])
animations.model.tail:play()

local survivalplate =
    models:newText("health"):setScale(.25):setPos(0, 42, 0):alignment("center"):background(true)
function events.tick()
      survivalplate:setVisible(host:isHost() and not renderer:isFirstPerson())

    local hp = math.floor(player:getHealth())
    local absorption = player:getAbsorptionAmount()
    local food = player:getFood()
    local sat = math.floor(player:getSaturation())
    local armor = player:getArmor()

    survivalplate:setText(toJson({
        { text = "❤ ", color = "#447FFF" },
        { text = hp .. " ", color = "white" },
        { text = absorption > 0 and ("+" .. absorption .. " ") or "", color = "#ffaa00" },
        { text = "🍖 ", color = "#c8a96e" },
        { text = food .. " ", color = "white" },
        { text = sat > 0 and ("(+" .. sat .. ") ") or "", color = "#44ff88" },
        { text = "🛡 ", color = "#aaaaaa" },
        { text = armor .. "", color = "white" },

    }))

end

local tailx, taily, tailz = 0, 0, 0
function events.render(delta)
    local r = client.getCameraRot()
    survivalplate:setRot(r.x, r.y * -1 - (player:getBodyYaw(delta) - 180 )* -1, 0)
    local nonIdle = (1 + player:getVelocity().xz:length() * 20)
    local idleRot = (math.sin(world.getTime(delta) / 10) * 20) / nonIdle
 

    tailx, taily, tailz =
    math.lerp(tailx, 30 / nonIdle, delta), 
    math.lerp(taily, vanilla_model.LEFT_LEG:getOriginRot().x / 10 + idleRot, delta), 
    0

    models.model.Body.Tail:setRot(tailx, taily, tailz)
end