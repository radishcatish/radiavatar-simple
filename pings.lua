
local function meow()
    animations.model.communicate:restart()
    for i=1,5 do sounds:stopSound("meow" .. i) end
    sounds["meow" .. tostring(math.random(1, 5))]
        :setPitch(math.random(75, 125) / 100)
        :setPos(models.model.Head:partToWorldMatrix():apply())
        :setSubtitle("Radi meows")
        :play()
end
function pings.meowmsg()
    animations.model.message:restart()
    for i=1,5 do sounds:stopSound("meow" .. i) end
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



printTable(textures:getTextures())
models.model.Head:setSecondaryTexture("CUSTOM", textures["star"])

local wobbleLib = require("wobwob").new()
wobbleLib:add("squish", {initial = 0, target = 0, multiplier = .6})
wobbleLib:add("bodybounce", {initial = 0, target = 0, multiplier = .6})
wobbleLib:add("earsback", {initial = 0, target = 0, multiplier = .6})
wobbleLib:add("earsside", {initial = 0, target = 0, multiplier = .6})
wobbleLib:add("bodyside", {initial = 0, target = 0, multiplier = .6})
local headRotOld = vec(0,0)
local model = models.model
function events.tick()

    local playerVel = player:getVelocity()
    local playerRot = player:getRot()
    local headRot = player:getRot() 
    local headVel = headRot - headRotOld
    headRotOld = headRot

    local forwardVel = playerVel:dot(player:getLookDir().x_z:normalize()) + 0.0000000001
    local sidewaysVel = (playerVel * matrices.rotation3(0, playerRot.y, 0)).x

    wobbleLib:setTarget("squish", player:getVelocity().y * -1)
    wobbleLib:setTarget("bodybounce", (player:getVelocity().y * -1 * .6))
    wobbleLib:setTarget("earsback", (headVel.x * -1 / 90) + forwardVel)
    wobbleLib:setTarget("earsside", (headVel.y * -1 / 145) + sidewaysVel)
    wobbleLib:setTarget("bodyside", sidewaysVel)
    wobbleLib:update()


    model.Head.Ears.LeftEar:setScale(vec(
      math.clamp(1 - wobbleLib:get("squish") /4, 0.2, 2), 
      math.clamp(1 + wobbleLib:get("squish") /4, 0.2, 2), 
      math.clamp(1 - wobbleLib:get("squish") /4, 0.2, 2)
    ) )
    model.Head.Ears.RightEar:setScale(model.Head.Ears.LeftEar:getScale())

    model.Head.Ears.LeftEar:setRot(vec(
      wobbleLib:get("earsback") * 90, 
      0, 
      wobbleLib:get("earsside") * -90
    ))
    model.Head.Ears.RightEar:setRot(model.Head.Ears.LeftEar:getRot() * vec(1, 1, 1))

    model.Body.Tail:setRot(vec( wobbleLib:get("bodybounce") * -45, 0, wobbleLib:get("bodyside") * -90 ))
    model.Body.Bandana.ends:setRot(vec( wobbleLib:get("bodybounce") * -45, 0, wobbleLib:get("bodyside") * -90 ))

end
