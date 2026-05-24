-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- dependencies --
local general = require(ReplicatedStorage.packages.general)
local kinematics = require(ReplicatedStorage.packages.kinematics)

-- types --

-- variables --
local kinematics_test = {}

local root

-- constants --

-- private functions --

-- public functions --
function kinematics_test:init() 
    root = workspace:WaitForChild("kinematics_testing"):WaitForChild("Axes"):WaitForChild("root")
end

function kinematics_test:start() 

    local root_kinematics = kinematics.new(root)

    RunService.Heartbeat:Connect(function(dt)
        root_kinematics:update(dt)
        print(general.round(root_kinematics.rot_rate.pitch, 2),
                general.round(root_kinematics.rot_rate.yaw, 2),
                general.round(root_kinematics.rot_rate.roll, 2))
        -- local ang_vel = root.AssemblyAngularVelocity
        -- ang_vel 
    end)
end

-- main --
return kinematics_test
