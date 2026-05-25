-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local classes = script.Parent.Parent.classes

-- dependencies --
local missiles = require(classes.missiles)
local welds = require(ReplicatedStorage.packages.welds)
local anchor = require(ReplicatedStorage.packages.anchor)

-- types --

-- variables --
local missile_test = {}

local missile
local root

local missile_behv

-- constants --

-- private functions --

-- public functions --
function missile_test:init() 

    missile = workspace:WaitForChild("missile")
    while not missile.PrimaryPart do
        missile:GetPropertyChangedSignal("PrimaryPart"):Wait()
    end

    root = missile.PrimaryPart

    welds.weld_descendants(root)
    anchor.unanchor_descendants(root)

    missile_behv = missiles.new(missile)
    missile_behv:activate()
end

function missile_test:start()
    RunService.Heartbeat:Connect(function(dt)
        missile_behv:update(dt)
    end)
end

-- main --
return missile_test
