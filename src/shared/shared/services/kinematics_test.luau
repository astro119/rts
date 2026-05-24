-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- dependencies --
local kinematics = require(ReplicatedStorage.packages.kinematics)

-- types --

-- variables --
local kinematics_test = {}

local root
local previous_root

-- constants --

-- private functions --

-- public functions --
function kinematics_test:init() 
    root = workspace:WaitForChild("kinematics_testing"):WaitForChild("Axes"):WaitForChild("root")
    previous_root = workspace:WaitForChild("kinematics_testing"):WaitForChild("Axes2"):WaitForChild("root")
end

function kinematics_test:start() 

    local root_kinematics = kinematics.new(root)

    RunService.Heartbeat:Connect(function(dt)
        root_kinematics:update()
        print(root_kinematics.rotation)
    end)
end

-- main --
return kinematics_test
