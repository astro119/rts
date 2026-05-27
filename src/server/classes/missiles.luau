local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote_service = require(ReplicatedStorage.shared.services.remote_service)
local msl_data = require(ReplicatedStorage.data.msl_data)

local trail_to_client = remote_service.get("trail_to_client")

local apn = require(ReplicatedStorage.packages.pro_nav.aug_pro_nav)
local welds = require(ReplicatedStorage.packages.welds)
local anchor = require(ReplicatedStorage.packages.anchor)

local missile = {}
missile.__index = missile

function missile.new(missile_model: Model, parent)

    local msl = missile_model:Clone()
    msl.Parent = parent

    local cfg = msl:WaitForChild("cfg")
    local effects = cfg:WaitForChild("effects")

    local root = msl:WaitForChild("root")
    local cog = root:WaitForChild("cog")
    local att0 = root:WaitForChild("att0")

    local ang_vel = Instance.new("AngularVelocity")
    ang_vel.Attachment0 = cog
    ang_vel.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
    ang_vel.MaxTorque = 1000
    ang_vel.Parent = root
    ang_vel.Enabled = false


    -- not sure if ill actually use linear velocity for final movement
    local lin_vel = Instance.new("LinearVelocity")
    lin_vel.Attachment0 = cog
    lin_vel.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
    lin_vel.Parent = root
    lin_vel.Enabled = false
  
    -----------
    local trail_cfg
    local emitter = root:WaitForChild("emitter")
    print()
    print("----------------")
    for _, object in root:GetChildren() do
        print(object.Name)
    end
    print("HELLO################")
    print("EMITTER NAME IS "..emitter.Name)
    print()
    if effects then
        local trail_cfg_temp = effects:WaitForChild("trail_cfg")
        trail_cfg = {
            beam = effects:WaitForChild("beam"),
            emitter = emitter,
            lifetime = trail_cfg_temp:GetAttribute("lifetime"),
            time_to_max_width = trail_cfg_temp:GetAttribute("time_to_max_width"),
            max_trail_width = trail_cfg_temp:GetAttribute("max_trail_width"),
            randomness = trail_cfg_temp:GetAttribute("randomness"),
            resolution = trail_cfg_temp:GetAttribute("resolution")
        }
    end
    -------------


    welds.weld_descendants(root)
    anchor.unanchor_descendants(root)

	return setmetatable({
        model = msl,
        root = root,
        
        att = att0,
        cog = cog,
        ang_vel = ang_vel,
        lin_vel = lin_vel,

        trail_cfg = trail_cfg,

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
    if not self.active then
        self.lin_vel.VectorVelocity = Vector3.new(0, 0, -30)

        if self.trail_cfg then
            print(self.trail_cfg)
            local trail_cfg = self.trail_cfg
            trail_to_client:FireAllClients(trail_cfg)
        end

        self.ang_vel.Enabled = true
        self.lin_vel.Enabled = true
        self.active = true
        print("activating missile")
    end
end

return missile