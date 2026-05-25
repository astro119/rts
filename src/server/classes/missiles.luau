local trails = require(script.Parent.trails)

local missile = {}
missile.__index = missile

function missile.new(missile_model: Model)

    local root = missile_model:WaitForChild("root")
    local emitter = root:WaitForChild("emitter")
    local trail = trails.new(emitter, 5, 1)

	return setmetatable({
        model = missile_model,
        root = root,
        emitter = emitter,
        trail = nil,

        active = false,
        active_time = 0
    }, missile)
end

function missile:update(dt)
    if self.active then

        -- only just activated the missile
        if self.active_time == 0 then
            self.trail = trails.new(self.emitter, 5, 1)
            -- print("activating "..self.model.Name)

        -- missile after activation
        else
            -- local ref4 = workspace:WaitForChild("ref4")
            -- ref4.Position = self.emitter.WorldPosition

            self.trail:update(dt)
            -- print("updating "..self.model.Name)
        end
        
        self.active_time += dt
    end
end

function missile:activate()
    self.active = true
end

return missile