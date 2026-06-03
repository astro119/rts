local c = {}

function c.set_visual_hidden(char: Model, hidden: boolean)
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.Transparency = hidden and 1 or 0
			obj.CastShadow = not hidden
		elseif obj:IsA("Decal") then
			obj.Transparency = hidden and 1 or 0
		end
	end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.DisplayDistanceType = hidden
			and Enum.HumanoidDisplayDistanceType.None
			or Enum.HumanoidDisplayDistanceType.Viewer
	end
end

function c.set_collision(char: Model, can_collide: boolean)
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.CanCollide = can_collide
		end
	end
end

function c.hide_char(char: Model)
	c.set_visual_hidden(char, true)
	c.set_collision(char, false)
end

function c.show_char(char: Model)
	c.set_visual_hidden(char, false)
	c.set_collision(char, true)
end

return c