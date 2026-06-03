-- services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local packages = ReplicatedStorage.packages

-- dependencies --
local characters = require(packages.character)

-- types --

-- variables --
local module = {}

local player = Players.LocalPlayer

local character
local root

local cam = workspace.CurrentCamera

-- constants --

-- private functions --

-- public functions --
function module:init() 
    cam.CameraType = Enum.CameraType.Custom
    -- cam.CameraSubject = workspace:WaitForChild("missile"):WaitForChild("root")
    cam.CameraSubject = workspace:WaitForChild("plane"):WaitForChild("root"):WaitForChild("weapons"):WaitForChild("missile"):WaitForChild("root")

    local cam = workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Custom
    
    character = player.Character or player.CharacterAdded:Wait()
    root = character:WaitForChild("HumanoidRootPart")
    -- characters.hide_char(character)
end

function module:start() 
    local timer = 0
    RunService.RenderStepped:Connect(function(dt)
        if timer > 0.5 then
            print(timer)
            -- root.CFrame = cam.CFrame
            timer = 0
        end
        timer += dt
    end)
end

-- main --
return module
