
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
nameplate.ENTITY:setPivot(0, 2.5, 0)

function pings.communicate()
    if not player:isLoaded() then
        return
    end
    sounds:stopSound("meow1")
    sounds:stopSound("meow2")
    sounds:stopSound("meow3")
    sounds:playSound("meow" .. tostring(math.random(1, 3)), player:getPos() + vec(0, 1.5, 0), 1, math.random(75, 125) / 100)
    animations.model.communicate:restart()
end

keybinds:newKeybind("peak communication", "key.keyboard.r", false).press = function()
    pings.communicate()
end




local head = models.model.root.Head
local velocityStrength = 2
local rot = vec(0, 0, 0, 0)
local vel = vec(0, 0, 0, 0)
local oldPlayerRot = vec(0,0)
local oldHeadRot = vec(0,0,0)

function events.tick()
    local playerRot = player:getRot()
    local playerRotVel = (playerRot - oldPlayerRot) * 0.75 * velocityStrength
    oldPlayerRot = playerRot
    local headRot = vec(head:getTrueRot().y, head:getTrueRot().x, head:getTrueRot().z)
    local headVel = (headRot - oldHeadRot) * 0.01 * velocityStrength
    oldHeadRot = headRot
    local playerVel = player:getVelocity() + headVel
    playerVel = vectors.rotateAroundAxis(playerRot.y, playerVel, vec(0, 1, 0))
    playerVel = vectors.rotateAroundAxis(-playerRot.x, playerVel, vec(1, 0, 0))
    playerVel = playerVel * velocityStrength * 40
    vel = vel * 0.6 - rot * 0.2
    rot = rot + vel
    rot.x = rot.x + math.clamp((playerVel.z + playerRotVel.x) * .6, -27, 27)
    rot.z = rot.z + math.clamp(-playerVel.x + playerRotVel.y, -60, 60) * .3
    rot.w = rot.w + math.clamp((playerVel.y * 0.25 ) * .6, -8, 20)
    models.model.root.Head.Ears.LeftEar:setRot(rot.xyz + rot.__w)
    models.model.root.Head.Ears.RightEar:setRot(rot.x_z - rot._yw )
 
    models.model.root.Body.Bandana:setVisible(player:getItem(5).id == "minecraft:elytra" or player:getItem(5).id == "minecraft:air")
    models.model.root.Body.Tail:setVisible(player:getItem(5).id == "minecraft:elytra" or player:getItem(5).id == "minecraft:air")
end