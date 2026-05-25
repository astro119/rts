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
local root

local missile_behv

local trail_event

-- constants --

-- private functions --

-- public functions --
function missile_test:init() 

    -- create remote event
    trail_event = Instance.new("RemoteEvent")
    trail_event.Name = "trail_event"
    trail_event.Parent = ReplicatedStorage.RemoteEvents


    msl = cfgs.missile:Clone()
    msl.Parent = workspace
    while not msl.PrimaryPart do
        msl:GetPropertyChangedSignal("PrimaryPart"):Wait()
    end

    root = msl.PrimaryPart

    welds.weld_descendants(root)
    anchor.unanchor_descendants(root)

    missile_behv = missiles.new(msl)
    missile_behv:activate()

end

function missile_test:start()
    RunService.Heartbeat:Connect(function(dt)
        missile_behv:update(dt)
    end)
end

-- main --
return missile_test
