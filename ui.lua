--==================================================
-- n4noware Framework API Library // STEP 1: BASE ENGINE
--==================================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Visual Configuration Matrix
local Theme = {
	Background = Color3.fromRGB(5, 8, 6),
	Window = Color3.fromRGB(9, 13, 10),
	Surface = Color3.fromRGB(13, 18, 15),
	SurfaceHover = Color3.fromRGB(20, 28, 22),
	Border = Color3.fromRGB(42, 58, 46),
	Text = Color3.fromRGB(235, 242, 237),
	Muted = Color3.fromRGB(132, 146, 137),
	Accent = Color3.fromRGB(66, 225, 120),
}

-- Engine Utilities
local function New(className, properties, parent)
	local object = Instance.new(className)
	for property, value in pairs(properties or {}) do 
		object[property] = value 
	end
	object.Parent = parent
	return object
end

local function Corner(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = object
end

local function Stroke(object, transparency, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Border
	stroke.Transparency = transparency or 0
	stroke.Thickness = thickness or 1
	stroke.Parent = object
end

-- This is the core library object developers interact with first
local library = {}

-- [[ METHOD: CREATE MAIN WINDOW ]]
function library:CreateWindow(config)
	config = config or {}
	local windowName = config.Name or "n4noware UI"

	-- Establish standard execution layer parent
	local TargetParent = game:GetService("CoreGui"):FindFirstChild("RobloxGui") or Player:WaitForChild("PlayerGui")
	
	-- Evict older versions to prevent UI collision errors
	if TargetParent:FindFirstChild("N4nowareFramework") then
		TargetParent:FindFirstChild("N4nowareFramework"):Destroy()
	end

	-- Master Layer Container
	local Gui = New("ScreenGui", {
		Name = "N4nowareFramework",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, TargetParent)

	-- Physical Window Frame
	local Window = New("Frame", {
		Name = "MainWindow",
		Size = UDim2.fromOffset(370, 255),
		Position = UDim2.new(0.5, -185, 0.5, -127),
		BackgroundColor3 = Theme.Window,
		BorderSizePixel = 0,
	}, Gui)

	Corner(Window, 15)
	Stroke(Window, 0.08)

	-- Structural Window Header
	local Header = New("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 54),
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
	}, Window)
	Corner(Header, 15) -- Matches top edges cleanly

	local Title = New("TextLabel", {
		Size = UDim2.new(1, -30, 1, 0),
		Position = UDim2.fromOffset(15, 0),
		BackgroundTransparency = 1,
		Text = windowName,
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, Header)

	-- The target frame where elements, groups, or folders will physically render
	local Container = New("ScrollingFrame", {
		Name = "Container",
		Size = UDim2.new(1, -28, 1, -68),
		Position = UDim2.fromOffset(14, 60),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Accent,
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	}, Window)

	local Layout = New("UIListLayout", {
		Padding = UDim.new(0, 7),
		SortOrder = Enum.SortOrder.LayoutOrder
	}, Container)

	-- Prepare the sub-API object for this specific window instance
	local windowAPI = {}
	
	-- Pass utility accessors internally so next components can access them
	windowAPI.Container = Container
	windowAPI.Theme = Theme
	windowAPI.New = New
	windowAPI.Corner = Corner
	windowAPI.Stroke = Stroke

	return windowAPI
end

-- Return the library object to the developer's loadstring call
return library
