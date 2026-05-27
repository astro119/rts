local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local packages = ReplicatedStorage.packages

local remote_service = require(ReplicatedStorage.shared.services.remote_service)
local msl_data = require(ReplicatedStorage.data.msl_data)

local trail_to_client = remote_service.get("trail_to_client")

local pid = require(packages.pid)
local apn = require(packages.pro_nav.aug_pro_nav)
local welds = require(packages.welds)
local anchor = require(packages.anchor)

local missile = {}
missile.__index = missile

function missile.new(missile_model: Model, parent)

    local model = missile_model:Clone()
    model.Parent = parent
    local root = model:WaitForChild("root")

    local id = HttpService:GenerateGUID(false)
    model:SetAttribute("id", id)
    
    local cfg = model:WaitForChild("cfg")
    local effects = cfg:WaitForChild("effects")
    local trail_cfg
    if effects then
        local trail_cfg_temp = effects:WaitForChild("trail_cfg")
        trail_cfg = {
            beam = effects:WaitForChild("beam"),
            emitter = root:WaitForChild("emitter"),
            lifetime = trail_cfg_temp:GetAttribute("lifetime"),
            time_to_max_width = trail_cfg_temp:GetAttribute("time_to_max_width"),
            max_trail_width = trail_cfg_temp:GetAttribute("max_trail_width"),
            randomness = trail_cfg_temp:GetAttribute("randomness"),
            resolution = trail_cfg_temp:GetAttribute("resolution")
        }
    end
    local guidance = cfg:WaitForChild("guidance")
    if guidance:GetAttribute("type") == "apn" then
        -- apn.new()
    end


    local cog = root:WaitForChild("cog")
    local att0 = root:WaitForChild("att0")

    local ang_vel = Instance.new("AngularVelocity")
    ang_vel.Attachment0 = cog
    ang_vel.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
    ang_vel.MaxTorque = 1000
    ang_vel.Parent = root
    ang_vel.Enabled = false

    local guidance

    -- not sure if ill actually use linear velocity for final movement
    local lin_vel = Instance.new("LinearVelocity")
    lin_vel.Attachment0 = cog
    lin_vel.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
    lin_vel.Parent = root
    lin_vel.Enabled = false
  



    welds.weld_descendants(root)
    anchor.unanchor_descendants(root)

	return setmetatable({
        id = id,

        model = model,
        root = root,
        
        att = att0,
        cog = cog,
        ang_vel = ang_vel,
        lin_vel = lin_vel,

        guidance = guidance,
        trail_cfg = trail_cfg,

        target = nil,
        mode = nil,
        active = false,
        active_time = 0
    }, missile)
end

function missile:update(dt)
    if self.active then

        -- only just activated the missile
        if self.active_time == 0 then

        -- missile after activation
        else
            
        end
        
        self.active_time += dt
    end
end

function missile:activate()
    if not self.active then
        -- print("activating missile")
        self.lin_vel.VectorVelocity = Vector3.new(0, 0, -30)

        if self.trail_cfg then
            trail_to_client:FireAllClients(self.trail_cfg)
        end

        self.ang_vel.Enabled = true
        self.lin_vel.Enabled = true
        self.active = true
    end
end

return missile