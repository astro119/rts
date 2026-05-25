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

local root
local emitter

local trail

-- constants --

-- private functions --

-- public functions --
function missile:init() 
    

    msl = workspace:WaitForChild("missile")
    cfg = msl:WaitForChild("cfg")

    root = msl:WaitForChild("root")
    emitter = root:WaitForChild("emitter")

    local effects = cfg:WaitForChild("effects")
    local beam = effects:WaitForChild("beam")
    local trail_cfg = effects:WaitForChild("trail_cfg")
    local lifetime = trail_cfg:GetAttribute("lifetime")
    local time_to_max_width = trail_cfg:GetAttribute("time_to_max_width")
    local max_trail_width = trail_cfg:GetAttribute("max_trail_width")
    local randomness = trail_cfg:GetAttribute("randomness")
    local resolution = trail_cfg:GetAttribute("resolution")
    
    

    trail = trails.new(beam, emitter, lifetime, time_to_max_width, max_trail_width, randomness, resolution)


    cfg:Destroy()
end

-- local axes2_root = workspace:WaitForChild("Axes2"):WaitForChild("root")
function missile:start()
    RunService.RenderStepped:Connect(function(dt)
        -- axes2_root.CFrame = emitter.WorldCFrame
        trail:update(dt)
    end)
end

-- main --
return missile
