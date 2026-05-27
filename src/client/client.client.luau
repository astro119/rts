local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.shared.services

for _, service in ipairs(services:GetChildren()) do
	local module = require(service)

	if typeof(module.init) == "function" then
		print("CLIENT initialised "..service.Name)
		module:init()
	end
end

for _, service in ipairs(services:GetChildren()) do
	local module = require(service)

	if typeof(module.start) == "function" then
		print("CLIENT started "..service.Name)
		module:start()
	end
end
