--==================================================
-- n4noware Framework API Library // STEP 2: FOLDER ENGINE
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
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

-- Core Library Object
local library = {}

-- [[ METHOD: CREATE MAIN WINDOW ]]
function library:CreateWindow(config)
	config = config or {}
	local windowName = config.Name or "n4noware UI"

	local TargetParent = game:GetService("CoreGui"):FindFirstChild("RobloxGui") or Player:WaitForChild("PlayerGui")
	
	if TargetParent:FindFirstChild("N4nowareFramework") then
		TargetParent:FindFirstChild("N4nowareFramework"):Destroy()
	end

	local Gui = New("ScreenGui", {
		Name = "N4nowareFramework",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, TargetParent)

	local Window = New("Frame", {
		Name = "MainWindow",
		Size = UDim2.fromOffset(370, 280),
		Position = UDim2.new(0.5, -185, 0.5, -140),
		BackgroundColor3 = Theme.Window,
		BorderSizePixel = 0,
	}, Gui)

	Corner(Window, 15)
	Stroke(Window, 0.08)

	local Header = New("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 54),
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
	}, Window)
	Corner(Header, 15)

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

	-- Window Instance API
	local windowAPI = {}

	-- [[ METHOD: CREATE FOLDER ]]
	function windowAPI:CreateFolder(folderName)
		folderName = folderName or "Folder"

		-- The physical frame containing the folder layout
		local FolderFrame = New("Frame", {
			Name = folderName .. "Folder",
			Size = UDim2.new(1, 0, 0, 35), -- Shorter default size, dynamically grows
			BackgroundColor3 = Theme.Surface,
			BorderSizePixel = 0,
			ClipsDescendants = true
		}, Container)

		Corner(FolderFrame, 8)
		Stroke(FolderFrame, 0.4)

		-- Folder Header Button (Clickable to minimize/expand later)
		local FolderHeader = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 35),
			BackgroundTransparency = 1,
			Text = "  ▼  " .. string.upper(folderName),
			TextColor3 = Theme.Accent,
			TextSize = 10,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, FolderFrame)

		-- Nested container inside the folder where specific toggles/buttons will sit
		local ElementContainer = New("Frame", {
			Name = "Elements",
			Size = UDim2.new(1, -20, 1, -40),
			Position = UDim2.fromOffset(10, 40),
			BackgroundTransparency = 1,
		}, FolderFrame)

		local ElementLayout = New("UIListLayout", {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder
		}, ElementContainer)

		-- Automatically resize the physical folder frame based on how many items are inside it
		ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			FolderFrame.Size = UDim2.new(1, 0, 0, ElementLayout.AbsoluteContentSize.Y + 45)
		end)

		-- Return a unique Folder API object so components target this folder specifically
		local folderAPI = {}
		folderAPI.ElementContainer = ElementContainer
		
		return folderAPI
	end

	return windowAPI
end

return library
