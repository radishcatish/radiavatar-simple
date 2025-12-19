local Vec = vec

local state = {
  pos = Vec(0, 0, 0),
  vel = Vec(0, 0, 0),
  velLength = 0.0,
  element = nil,
  elementOffset = Vec(0, 2.5, 0) * 16,
  offset = Vec(0, 0, 0),
}

local CONST = {
  SPRING_STRENGTH = 0.2,
  MASS = 5,
  RESISTANCE = 1,
  VISIBLE_VEL_THRESHOLD = 0.25,
  GLIDE_PARTICLE_THRESHOLD = 0.3,
}

local renderContext = nil

local function partile()
  particles["end_rod"]
    :setPos(models.planet.root.pyramid:partToWorldMatrix():apply())
    :setScale(0.3)
    :setLifetime(5)
    :setPhysics(false)
    :spawn()
end

function events.entity_init()


  state.velLength = 0.0
  state.pos = Vec(0, 0, 0)
  state.vel = Vec(0, 0, 0)
  state.element = models.planet
  state.element:setParentType("WORLD")

  models.planet:setPrimaryRenderType("EMISSIVE_SOLID")
  models.planet.root.ring.torus_outline:setSecondaryRenderType("CUTOUT_CULL")
  models.planet.root.pyramid_outline:setSecondaryRenderType("CUTOUT_CULL")
  
  models.planet.root:setLight(15)

  state.offset = Vec(
    state.elementOffset.x - state.elementOffset.z,
    state.elementOffset.y,
    state.elementOffset.x + state.elementOffset.z
  )

  state.pos = player:getPos() + state.offset / 16
  state.element:setPos(state.pos * 16)
  state.element:setOffsetRot(0, -player:getBodyYaw() + 180, 0)
end

function events.tick()
  local target = player:getPos() + state.offset / 16
  local diff = state.pos - target
  local force = Vec(0, 0, 0)
  force = force - diff * CONST.SPRING_STRENGTH
  force = force - state.vel * CONST.RESISTANCE
  state.vel = state.vel + force / CONST.MASS

  state.pos = state.pos + state.vel
  if not (host:isHost() and renderer:isFirstPerson()) and state.velLength > CONST.GLIDE_PARTICLE_THRESHOLD then
    partile()
  end
  state.velLength = math.lerp(state.velLength, state.vel:length(), .5) * 1.7
  models.planet.root:setRot(models.planet.root:getRot() + (Vec(0, state.velLength, state.velLength) + Vec(0, 1, 0)))
  models.planet.root.stars:setRot(models.planet.root.stars:getRot() + (Vec(0, state.velLength, 0) + Vec(0, 1, 0)))
  models.planet.root.ring:setRot(models.planet.root.ring:getRot() + (Vec(state.velLength, state.velLength, 0) + Vec(1, 0, 0)))
end

function events.render(_, ctx)
  state.element:setPos(math.lerp(state.element:getPos(), state.pos * 16, .1))


  if not renderer:isFirstPerson() then
    models.planet.root:setVisible(true)

  else
    models.planet.root:setVisible(false)
  end
end

