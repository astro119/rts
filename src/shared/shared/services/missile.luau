-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- dependencies --
local trails = require(ReplicatedStorage.shared.classes.trails)

-- types --

-- variables --
local missile = {}

local msl
local cfg
local beam
local root

local missile_behv

local trail

-- constants --

-- private functions --

-- public functions --
function missile:init() 
    

    msl = workspace:WaitForChild("missile")
    cfg = msl:WaitForChild("cfg")

    beam = cfg:WaitForChild("trail"):WaitForChild("beam")
    root = msl:WaitForChild("root")

    trail = trails.new(beam, root:WaitForChild("emitter"), 5, 10, 0.6)


    cfg:Destroy()
end

function missile:start()
    RunService.RenderStepped:Connect(function(dt)
        trail:update(dt)
    end)
end

-- main --
return missile
