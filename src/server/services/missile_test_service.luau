-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local packages = ReplicatedStorage.packages
local classes = script.Parent.Parent.classes
local cfgs = ReplicatedStorage.cfgs

-- dependencies --
local missiles = require(classes.missiles)
local anchor = require(packages.anchor)

-- types --

-- variables --
local missile_test = {}

local msl

-- constants --

-- private functions --

-- public functions --
function missile_test:init() 
end

function missile_test:start()
    msl = missiles.new(cfgs.missile:Clone(), workspace)
    anchor.anchor_descendants(msl.root)
    task.wait(2)
    
    -- msl:activate()
    anchor.unanchor_descendants(msl.root)
    msl.ang_vel.AngularVelocity = Vector3.new(0.05, 0.1, 0)
    -- RunService.Heartbeat:Connect(function(dt)
    --     msl:update(dt)
    -- end)
end

-- main --
return missile_test
