-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local data = ReplicatedStorage.data
local classes = ReplicatedStorage.shared.classes
local services = ReplicatedStorage.shared.services

-- dependencies --
local trail_data = require(data.trail_data)
local remote_service = require(services.remote_service)
local trails = require(classes.trails)

-- types --

-- variables --
local trails_client = {}

local trail_event = remote_service.get("trail_to_client")
local trail_stop = remote_service.get("trail_stop")


-- constants --

-- private functions --

-- public functions --
function trails_client:init()    
    RunService.RenderStepped:Connect(function(dt)
        for _, trail in pairs(trail_data) do
            trail:update(dt)
        end
    end)

    -- trail_event.OnClientEvent:Connect(function(id, new_trail_data)
    --     local new_trail = trails.new(new_trail_data)
        -- table.insert(trails_table, new_trail)
    -- end) 
    trail_event.OnClientEvent:Connect(function(id, new_trail_data)
        local new_trail = trails.new(id, new_trail_data)
        trail_data[id] = new_trail
    end) 

    trail_stop.OnClientEvent:Connect(function(id)
        trail_data[id]:deactivate()
    end) 
end

function trails_client:start()
end

-- main --
return trails_client