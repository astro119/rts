local anchor = {}

function anchor.anchor_descendants(root)
	root.Anchored = true
	for _, object in ipairs(root:GetDescendants()) do
		if object:IsA("BasePart") then
			object.Anchored = true
		end
	end
end

function anchor.unanchor_descendants(root)
	root.Anchored = false
	for _, object in ipairs(root:GetDescendants()) do
		if object:IsA("BasePart") then
			object.Anchored = false
		end
	end
end

return anchor
