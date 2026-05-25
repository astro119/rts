local ReplicatedStorage = game:GetService("ReplicatedStorage")

local trails = require(ReplicatedStorage.shared.classes.trails)
local apn = require(ReplicatedStorage.packages.pro_nav.aug_pro_nav)

local missile = {}
missile.__index = missile

function missile.new(missile_model: Model)

    local root = missile_model:WaitForChild("root")
    local emitter = root:WaitForChild("emitter")
    local cog = root:WaitForChild("cog")

    local att0 = root:WaitForChild("att0")
    
    local ang_vel = Instance.new("AngularVelocity")
    ang_vel.Attachment0 = cog
    ang_vel.MaxTorque = 1000
    ang_vel.Parent = root

    -- testing
    ang_vel.AngularVelocity = Vector3.new(0.05, 0.1, 0)


	return setmetatable({
        model = missile_model,
        root = root,
        emitter = emitter,
        trail = nil,

        cog = cog,
        ang_vel = ang_vel,

        mode = nil,
        active = false,
        active_time = 0
    }, missile)
end

function missile:update(dt)
    if self.active then

        -- only just activated the missile
        if self.active_time == 0 then
            -- self.trail = trails.new(self.emitter, 5, 1)
            -- print("activating "..self.model.Name)

        -- missile after activation
        else
            -- local ref4 = workspace:WaitForChild("ref4")
            -- ref4.Position = self.emitter.WorldPosition

            -- self.trail:update(dt)
            -- print("updating "..self.model.Name)
        end
        
        self.active_time += dt
    end
end

function missile:activate()
    self.active = true
end

return missile