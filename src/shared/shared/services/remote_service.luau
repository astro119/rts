-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- variables --
local remote_service = {}

local events_folder = ReplicatedStorage.remote_events

-- public storage (so other scripts can access them)
remote_service.events = {}

-- public functions --

function remote_service.get(name)

	-- only server is able to create remote events
	if RunService:IsServer() then
		-- create remote event if it doesn't exist
		if not remote_service.events[name] then

			local new_remote_event = Instance.new("RemoteEvent")
			new_remote_event.Name = name
			new_remote_event.Parent = events_folder
			
			remote_service.events[name] = new_remote_event

			print("REMOTE_SERVICE: Generating RemoteEvent \""..name.."\"")
			return new_remote_event
		-- get remote event if it does exist
		else
			-- print("remote event "..name.." already exists")
			return remote_service.events[name]
		end
	-- client will simply have to wait until the remote event is created
	else
		return events_folder:WaitForChild(name)
	end
end

function remote_service:init()
end

function remote_service:start()
end

return remote_service