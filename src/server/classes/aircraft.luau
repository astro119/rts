local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
    ang_vel.MaxTorque = 1000
    ang_vel.Parent = root

    -- testing
    ang_vel.AngularVelocity = Vector3.new(0.05, -0.1, 0)

    welds.weld_descendants(root)
    -- anchor.unanchor_descendants(root)

	return setmetatable({
        model = model,
        root = root,

        hardpoints = hardpoints,
        weapons = {},

        cog = cog,
        ang_vel = ang_vel,

        mode = nil,
    }, aircraft)
end

function aircraft:update(dt)
    
end

function aircraft:weapon_station_init(station: number, weapon: Model)

end

return aircraft