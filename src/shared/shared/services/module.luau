-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- dependencies --

-- types --

-- variables --
local module = {}

local cam

-- constants --

-- private functions --

-- public functions --
function module:init() 
    cam = workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Custom
    cam.CameraSubject = workspace:WaitForChild("missile"):WaitForChild("root")
    cam.CameraSubject = workspace:WaitForChild("plane"):WaitForChild("root")
end

function module:start() 
end

-- main --
return module
