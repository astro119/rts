local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local classes = ServerScriptService.classes

local missiles = require(classes.missiles)

local trails = require(ReplicatedStorage.shared.classes.trails)

local apn = require(ReplicatedStorage.packages.pro_nav.aug_pro_nav)
local welds = require(ReplicatedStorage.packages.welds)
local anchor = require(ReplicatedStorage.packages.anchor)

local aircraft = {}
aircraft.__index = aircraft

function aircraft.new(model: Model)

    local root = model:WaitForChild("root")
    local cog = root:WaitForChild("cog")

    local hardpoints = {}
    local hardpoints_folder = root:WaitForChild("hardpoints")
    for _, hardpoint in ipairs(hardpoints_folder:GetChildren()) do
        local index = tonumber(hardpoint.Name)
        if index then
            hardpoints[index] = hardpoint
        end
    end

    -- print(hardpoints)
    -- for _, hardpoint in ipairs(hardpoints) do
    --     print(hardpoint.Position)
    -- end
    
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
    lin_vel.MaxForce = 100000
    lin_vel.Parent = root
    lin_vel.Enabled = false


    -- testing
    ang_vel.Enabled = true
    ang_vel.AngularVelocity = Vector3.new(0, 0.2, 0)
    lin_vel.Enabled = true
    lin_vel.VectorVelocity = Vector3.new(0, 0, -20)

    welds.weld_descendants(root)
    -- anchor.unanchor_descendants(root)

	return setmetatable({
        model = model,
        root = root,

        hardpoints = hardpoints,
        weapons = {},

        cog = cog,
        ang_vel = ang_vel,
        lin_vel = lin_vel,

        mode = nil,
    }, aircraft)
end

function aircraft:update(dt)
    
end

function aircraft:attach_to_hardpoint(station: number, weapon_model: Model)
    local hardpoint = self.hardpoints[station]
    local weapons = self.root:WaitForChild("weapons")
    local weapon = missiles.new(weapon_model, weapons)

    -- attach weapon, with correct offset
    weapon.root.CFrame = hardpoint.WorldCFrame * weapon.att.CFrame:Inverse()
    welds.weld(weapon.root, self.root)
    table.insert(self.weapons, station, weapon)
    -- weapon.lin_vel.VectorVelocity = Vector3.new(0,0,-0.5)
end

function aircraft:deploy_weapon(station: number)
    local weapon = self.weapons[station]
    if weapon then
        weapon:activate()

        -- temporary maybe??
        local weld_attach = weapon.root:WaitForChild("WeldConstraint")
        weld_attach:Destroy()
        table.remove(self.weapons, station)
    end
end

return aircraft