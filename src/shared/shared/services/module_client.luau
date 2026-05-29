-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- dependencies --

-- types --

-- variables --
local module = {}

local cam = workspace:WaitForChild("Camera")

-- constants --

-- private functions --

-- public functions --
function module:init() 
    cam.CameraType = Enum.CameraType.Custom
    -- cam.CameraSubject = workspace:WaitForChild("missile"):WaitForChild("root")
    cam.CameraSubject = workspace:WaitForChild("plane"):WaitForChild("root")--:WaitForChild("weapons"):WaitForChild("missile"):WaitForChild("root")
end

function module:start() 
end

-- main --
return module
