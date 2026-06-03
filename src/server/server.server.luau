local services = script.Parent.services

local load_exceptions = {
	module = true, -- add names here
	player_service = true
}

local loaded_services_list = {}

-- INIT PHASE
for _, service in ipairs(services:GetChildren()) do
	if not load_exceptions[service.Name] then
		local module = require(service)

		table.insert(loaded_services_list, {
			name = service.Name,
			module = module
		})

		if typeof(module.init) == "function" then
			print("SERVER: Initialising \""..service.Name.."\"...")
			module:init()
			print("SERVER: Initialised \""..service.Name.."\"")
		end
	end
end

-- START PHASE
for _, service in ipairs(loaded_services_list) do
	local module = service.module
	local name = service.name

	if typeof(module.start) == "function" then
		print("SERVER: Starting \""..name.."\"...")
		module:start()
		print("SERVER: Started \""..name.."\"")
	end
end

print("---------------------------------")
print("SERVER INITIALISATION RESULT")
for _, service in ipairs(loaded_services_list) do
	print("\""..service.name.."\" 								")
end
print("---------------------------------")