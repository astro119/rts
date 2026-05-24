local general = {}


function general.get_total_mass(rootPart) -- get total mass, including root part
	local totalMass = rootPart:GetMass()
	for _, descendant in ipairs(rootPart:GetDescendants()) do
		if descendant:IsA("BasePart") then
			totalMass = totalMass + descendant:GetMass()
		end
	end
	return totalMass
end

function general.round(num, decimals)
	local mult = 10 ^ decimals
	return math.round(num * mult) / mult
end

function general.round_vector3(vec, decimals)
	decimals = decimals or 2

	local format_str = "%." .. decimals .. "f"

	return string.format(
		"X: " .. format_str .. ", Y: " .. format_str .. ", Z: " .. format_str,
		vec.X, vec.Y, vec.Z
	)
end

function general.find_local_pos(part: BasePart)
	return part.Parent.CFrame:PointToObjectSpace(part.Position)
end


return general