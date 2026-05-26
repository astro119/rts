-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local classes = script.Parent.Parent.classes
local cfgs = ReplicatedStorage.cfgs

-- dependencies --
local msl_data = require(ReplicatedStorage.data.msl_data)
local missiles = require(classes.missiles)
local welds = require(ReplicatedStorage.packages.welds)
local anchor = require(ReplicatedStorage.packages.anchor)

-- types --

-- variables --
local missile_test = {}

local msl

local trail_event

-- constants --

-- private functions --

-- public functions --
function missile_test:init() 

    -- create remote event
    -- trail_event = Instance.new("RemoteEvent")
    -- trail_event.Name = "trail_event"
    -- trail_event.Parent = ReplicatedStorage.RemoteEvents


    msl = missiles.new(cfgs.missile:Clone(), workspace)
    msl:activate()

    -- testing
    msl.lin_vel.VectorVelocity = Vector3.new(0, 0, -40)
    msl.ang_vel.AngularVelocity = Vector3.new(0.05, 0.1, 0)
end

function missile_test:start()
    RunService.Heartbeat:Connect(function(dt)
        msl:update(dt)
    end)
end

-- main --
return missile_test
