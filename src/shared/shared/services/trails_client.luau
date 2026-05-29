-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local classes = ReplicatedStorage.shared.classes
local services = ReplicatedStorage.shared.services

-- dependencies --
local remote_service = require(services.remote_service)
local trails = require(classes.trails)

-- types --

-- variables --
local trails_client = {}

local trail_event = remote_service.get("trail_to_client")

local trails_table = {}

-- constants --

-- private functions --

-- public functions --
function trails_client:init()    
    RunService.RenderStepped:Connect(function(dt)
        for _, trail in ipairs(trails_table) do
            trail:update(dt)
        end
    end)

    -- trail_event.OnClientEvent:Connect(function(id, new_trail_data)
    --     local new_trail = trails.new(new_trail_data)
    --     trails_table[id] = trails.new(new_trail_data)
    -- end) 
    trail_event.OnClientEvent:Connect(function(new_trail_data)
        local new_trail = trails.new(new_trail_data)
        table.insert(trails_table, new_trail)
    end) 
end

function trails_client:start()
end

-- main --
return trails_client