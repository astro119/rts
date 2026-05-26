-- services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- variables --
local remote_events = {}

local events_folder = ReplicatedStorage:WaitForChild("remote_events")

local events = {
	"trail",
	"test",
	"hello"
}

-- public storage (so other scripts can access them)
remote_events.events = {}

-- public functions --
function remote_events:init()

	for _, event_name in ipairs(events) do

		local event = events_folder:FindFirstChild(event_name)

		if not event then
			event = Instance.new("RemoteEvent")
			event.Name = event_name
			event.Parent = events_folder
		end

		remote_events.events[event_name] = event
	end
end

function remote_events:start()
	-- example connections (optional)
	-- remote_events.events.trail.OnServerEvent:Connect(function(...)
	-- end)
end

return remote_events