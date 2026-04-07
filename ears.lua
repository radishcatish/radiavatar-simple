local leftEar = models.model.Head.Ears.LeftEar
local rightEar = models.model.Head.Ears.RightEar
local tail = models.model.Body.Tail
local rot = vec(0, 0, 0, 0)
local vel = vec(0, 0, 0, 0)
local oldPlayerRot = vec(0, 0)
local oldHeadRot = vec(0, 0, 0)
local y = 0
local yv = 0

function events.tick()
    local playerRot = player:getRot()
    local playerRotVel = (playerRot - oldPlayerRot) * 1.5
    oldPlayerRot = playerRot
    
    local headRot = vanilla_model.HEAD:getOriginRot()
    local headVel = (headRot - oldHeadRot) * 0.02
    oldHeadRot = headRot
    local playerVel = player:getVelocity() + headVel
    playerVel = vectors.rotateAroundAxis(playerRot.y, playerVel, vec(0, 1, 0))
    playerVel = vectors.rotateAroundAxis(-playerRot.x, playerVel, vec(1, 0, 0))
    playerVel = playerVel * 80 
    vel = vel * 0.6 - rot * 0.2
    rot = rot + vel
    rot.x = rot.x + math.clamp((playerVel.z + playerRotVel.x + headRot.y * 0.5) * 0.6, -27, 27)
    rot.z = rot.z + math.clamp(-playerVel.x + playerRotVel.y, -60, 60) * 0.3
    rot.w = rot.w + math.clamp(playerVel.y * 0.15, -8, 20) -- Combined 0.25 * 0.6
    leftEar:setRot(rot.xyz + rot.__w)
    rightEar:setRot(rot.x_z - rot._yw)
    tail:setRot(rot.w * 3, 0, 0)
    yv = (yv + math.clamp(-playerVel.y * 0.3, -1, 1) - y) * 0.45
    y = y + yv
    local scale = vec(1 - y * 0.1, 1 + y * 0.1, 1 - y * 0.1)
    leftEar:setScale(scale)
    rightEar:setScale(scale)
end