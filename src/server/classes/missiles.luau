local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

local packages = ReplicatedStorage.packages

local remote_service = require(ReplicatedStorage.shared.services.remote_service)

local msl_data = require(ServerScriptService.data.msl_data)

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

    -- effects
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

    -- guidance
    local guidance_cfg = cfg:WaitForChild("guidance")
    local guidance
    if guidance_cfg:GetAttribute("type") == "apn" then
        local N = guidance_cfg:GetAttribute("constant")
        guidance = apn.new(nil, nil, nil, N)
    end


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
  



    welds.weld_descendants(root)
    anchor.unanchor_descendants(root)

	local msl_self = setmetatable({
        id = id,

        model = model,
        root = root,
        
        att = att0,
        cog = cog,
        ang_vel = ang_vel,
        lin_vel = lin_vel,

        guidance = guidance,
        trail_cfg = trail_cfg,

        prev_target = nil,
        target = nil,

        mode = nil,
        active = false,
        active_time = 0
    }, missile)

    msl_self:append_to_data(msl_data)

    return msl_self
end

function missile:append_to_data(table)
    table[self.id] = self
end

function missile:remove_from_data(table)
    table[self.id] = nil
end

function missile:update(dt)
    if self.active then
        -- only just activated the missile
        if self.active_time == 0 then

        -- missile after activation
        else
            -- if new target has been selected, update guidance data
            -- this is done just in case some erratic movement happens at the start
            -- when changing targets
            if self.prev_target ~= self.target then
                self.guidance:set_new(self.target.Position, 
                                        self.target.AssemblyLinearVelocity,
                                        self.root.Position,
                                        self.guidance.N)
            end

            -- if a target exists
            if self.target then
                local a_cmd = self.guidance:update(self.target.Position,
                                                    self.target.AssemblyLinearVelocity,
                                                    self.root.Position,
                                                    self.root.AssemblyLinearVelocity,
                                                    dt)
                local v_s = self.root.AssemblyLinearVelocity
                local des_v = (v_s + a_cmd).Unit
                local des_v_local = self.root.CFrame:VectorToObjectSpace(des_v)

                
                local yaw_error = math.atan2(des_v_local.X, -des_v_local.Z)
                local pitch_error = math.atan2(des_v_local.Y, -des_v_local.Z)

                local pitch_ang_v = math.sign(pitch_error) * math.rad(50)
                local yaw_ang_v = -math.sign(yaw_error) * math.rad(50)

                self.ang_vel.AngularVelocity = Vector3.new(pitch_ang_v, yaw_ang_v, 0)

                -- checking whether it impact, if the missile is going fast enough, a simple
                -- proximity check won't work since the missile will be travelling so far every frame
                -- MIGHT CHANGE later in favour of also detecting when the missile will impact terrain
                -- and not just a specified target 
                
            end

            self.prev_target = self.target
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