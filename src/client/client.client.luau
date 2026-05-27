local services = game:GetService("ReplicatedStorage").shared.services

local load_exceptions = {
	module = true, -- add names here
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
			print("CLIENT: Initialising \""..service.Name.."\"...")
			module:init()
			print("CLIENT: Initialised \""..service.Name.."\"")
		end
	end
end

-- START PHASE
for _, entry in ipairs(loaded_services_list) do
	local module = entry.module
	local name = entry.name

	if typeof(module.start) == "function" then
		print("CLIENT: Starting \""..name.."\"...")
		module:start()
		print("CLIENT: Started \""..name.."\"")
	end
end

print("---------------------------------")
print("CLIENT INITIALISATION RESULT")
for _, service in ipairs(loaded_services_list) do
	print("\""..service.name.."\" 								")
end
print("---------------------------------")