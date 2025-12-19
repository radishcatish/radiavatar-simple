
local leftEar = models.model.root.Head.Ears.LeftEar
local rightEar = models.model.root.Head.Ears.RightEar
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



    leftEar:setRot(rot.xyz + rot.__w)
    rightEar:setRot(rot.x_z - rot._yw )
end