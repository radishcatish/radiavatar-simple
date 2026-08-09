-- HEY!!! what are you DOING here go look at the main script you . Inexperienced Coder
-- local wobbleLib = require("wobwob").new()
local WobbleLib = {}
WobbleLib.__index = WobbleLib

-- create a new wobbly value (you don't use this one)
function WobbleLib.createWobble(config)
    config = config or {}
    return {
        value = config.initial or 0,
        velocity = 0,
        target = config.target or 0,
        multiplier = config.multiplier or 0.5
    }
end

-- add a wobbly value (you use this one)
function WobbleLib:add(name, config)
    self.wobbles[name] = WobbleLib.createWobble(config)
    return self.wobbles[name]
end

-- update a wobbly value's target value 
function WobbleLib:setTarget(name, target)
    if self.wobbles[name] then
        self.wobbles[name].target = target
    end
end

-- get current wobbly value's... value
function WobbleLib:get(name)
    if self.wobbles[name] then
        return self.wobbles[name].value
    end
    return 0
end

-- set a wobbly value's velocity
function WobbleLib:setVel(name, velocity)
    if self.wobbles[name] then
        self.wobbles[name].velocity = velocity
    end
end

-- add to a wobbly value's velocity
function WobbleLib:addVel(name, velocity)
    if self.wobbles[name] then
        self.wobbles[name].velocity = self.wobbles[name].velocity + velocity
    end
end

-- set velocity for multiple wobbly values
function WobbleLib:setVelBulk(names, velocity)
    for _, name in ipairs(names) do
        if self.wobbles[name] then
            self.wobbles[name].velocity = velocity
        end
    end
end

-- add velocity to multiple wobbly values
function WobbleLib:addVelBulk(names, velocity)
    for _, name in ipairs(names) do
        if self.wobbles[name] then
            self.wobbles[name].velocity = self.wobbles[name].velocity + velocity
        end
    end
end

-- update all wobbly values for optimization purposes. (do this in tick once)
function WobbleLib:update()
    for name, wobble in pairs(self.wobbles) do
        wobble.velocity = (wobble.velocity + wobble.value- wobble.value + (wobble.target - wobble.value)) * wobble.multiplier
        wobble.value = wobble.value + wobble.velocity
    end
end

-- create a new instance (also do this once)
function WobbleLib.new()
    local self = setmetatable({}, WobbleLib)
    self.wobbles = {}
    return self
end

return WobbleLib