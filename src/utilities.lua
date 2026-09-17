local Theme = loadstring(game:HttpGet("https://githubusercontent.com"))()
local Utilities = {}

function Utilities.New(className, properties, parent)
	local object = Instance.new(className)
	for property, value in pairs(properties or {}) do 
		object[property] = value 
	end
	object.Parent = parent
	return object
end

function Utilities.Corner(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = object
end

function Utilities.Stroke(object, transparency, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Border
	stroke.Transparency = transparency or 0
	stroke.Thickness = thickness or 1
	stroke.Parent = object
end

return Utilities
