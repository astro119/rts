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

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local character
local root

-- constants --

-- private functions --

-- public functions --
function module:init() 
    
    
    character = player.Character or player.CharacterAdded:Wait()
    root = character:WaitForChild("HumanoidRootPart")
    characters.hide_char(character)
end

function module:start() 
    
end

-- main --
return module
