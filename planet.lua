local pos = vec(0, 0, 0)
local vel = vec(0, 0, 0)
models.planet:setParentType("WORLD")
models.planet:setPrimaryRenderType("EMISSIVE_SOLID")
models.planet.root.ring.torus_outline:setSecondaryRenderType("CUTOUT_CULL")
models.planet.root.pyramid_outline:setSecondaryRenderType("CUTOUT_CULL")

function events.tick()
  local targetPos = player:getPos() + vec(0, 2.5, 0)
  local displacement = pos - targetPos
  local springForce = -displacement * 0.2
  local dragForce = -vel
  local totalForce = springForce + dragForce
  vel = vel + totalForce / 5
  pos = pos + vel
  local velLength = vel:length()
  models.planet.root:setRot(models.planet.root:getRot() + vec(0, velLength + 1, velLength))
  models.planet.root.stars:setRot(models.planet.root.stars:getRot() + vec(0, velLength + 1, 0))
  models.planet.root.ring:setRot(models.planet.root.ring:getRot() + vec(velLength + 1, velLength, 0))
  if not renderer:isFirstPerson() and velLength > 0.2 then
    particles["end_rod"]
      :setPos(models.planet.root.pyramid:partToWorldMatrix():apply())
      :setScale(0.3)
      :setLifetime(5)
      :spawn()
  end
end

function events.render()
  local currentPos = models.planet:getPos()
  local targetPos = pos * 16
  models.planet:setPos(math.lerp(currentPos, targetPos, 0.1))
  models.planet.root:setVisible(not renderer:isFirstPerson())
end