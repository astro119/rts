-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- dependencies --
local trails = require(ReplicatedStorage.shared.classes.trails)

-- types --

-- variables --
local trails_client = {}

local remote_events = ReplicatedStorage.remote_events
local trail_event = remote_events.trail

local trails_table = {}

-- constants --

-- private functions --

-- public functions --
function trails_client:init()     
end

-- local axes2_root = workspace:WaitForChild("Axes2"):WaitForChild("root")
function trails_client:start()
    RunService.RenderStepped:Connect(function(dt)
        for _, trail in ipairs(trails_table) do
            trail:update(dt)
        end
    end)

    trail_event.OnClientEvent:Connect(function()
        table.insert(trails_table, new_trail)
    end)
end

-- main --
return trails_client
