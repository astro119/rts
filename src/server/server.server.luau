local services = script.Parent.services

for _, service in ipairs(services:GetChildren()) do
	local module = require(service)

	if typeof(module.init) == "function" then
		module:init()
		print("SERVER initialised "..service.Name)
	end
end

for _, service in ipairs(services:GetChildren()) do
	local module = require(service)

	if typeof(module.start) == "function" then
		module:start()
		print("SERVER started "..service.Name)
	end
end
