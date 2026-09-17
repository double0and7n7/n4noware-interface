--==================================================
-- n4noware Framework API Library // STEP 4: TOGGLE ENGINE
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
	AccentDark = Color3.fromRGB(24, 67, 39),
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
		Size = UDim2.fromOffset(370, 320),
		Position = UDim2.new(0.5, -185, 0.5, -160),
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

		local FolderFrame = New("Frame", {
			Name = folderName .. "Folder",
			Size = UDim2.fromOffset(1, 35),
			BackgroundColor3 = Theme.Surface,
			BorderSizePixel = 0,
			ClipsDescendants = true
		}, Container)

		Corner(FolderFrame, 8)
		Stroke(FolderFrame, 0.4)

		local FolderHeader = New("TextButton", {
			Size = UDim2.new(1, 0, 0, 35),
			BackgroundTransparency = 1,
			Text = "  ▼  " .. string.upper(folderName),
			TextColor3 = Theme.Accent,
			TextSize = 10,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, FolderFrame)

		local ElementContainer = New("Frame", {
			Name = "Elements",
			Size = UDim2.new(1, -20, 1, -45),
			Position = UDim2.fromOffset(10, 40),
			BackgroundTransparency = 1,
		}, FolderFrame)

		local ElementLayout = New("UIListLayout", {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder
		}, ElementContainer)

		ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			FolderFrame.Size = UDim2.new(1, 0, 0, ElementLayout.AbsoluteContentSize.Y + 50)
		end)

		-- Folder Instance API
		local folderAPI = {}

		-- [[ METHOD: CREATE BUTTON ]]
		function folderAPI:CreateButton(buttonConfig)
			buttonConfig = buttonConfig or {}
			local buttonText = buttonConfig.Name or "Button"
			local callback = buttonConfig.Callback or function() end

			local Button = New("TextButton", {
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = Theme.Window,
				BorderSizePixel = 0,
				Text = "   " .. buttonText,
				TextColor3 = Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamMedium,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutoButtonColor = false
			}, ElementContainer)

			Corner(Button, 6)
			Stroke(Button, 0.3)

			local Arrow = New("TextLabel", {
				Size = UDim2.new(0, 20, 1, 0),
				Position = UDim2.new(1, -25, 0, 0),
				BackgroundTransparency = 1,
				Text = "→",
				TextColor3 = Theme.Muted,
				TextSize = 12,
				Font = Enum.Font.GothamMedium,
				TextXAlignment = Enum.TextXAlignment.Right
			}, Button)

			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.12), {BackgroundColor3 = Theme.SurfaceHover}):Play()
			end)

			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.12), {BackgroundColor3 = Theme.Window}):Play()
			end)

			Button.Activated:Connect(function()
				task.spawn(callback)
				Button.BackgroundColor3 = Theme.AccentDark
				TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Window}):Play()
			end)

			return Button
		end

		-- [[ METHOD: CREATE TOGGLE ]]
		function folderAPI:CreateToggle(toggleConfig)
			toggleConfig = toggleConfig or {}
			local toggleText = toggleConfig.Name or "Toggle"
			local default = toggleConfig.Default or false
			local callback = toggleConfig.Callback or function() end
			local value = default

			-- Base row selection panel
			local ToggleButton = New("TextButton", {
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundColor3 = Theme.Window,
				BorderSizePixel = 0,
				Text = "   " .. toggleText,
				TextColor3 = Theme.Text,
				TextSize = 11,
				Font = Enum.Font.GothamMedium,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutoButtonColor = false
			}, ElementContainer)

			Corner(ToggleButton, 6)
			Stroke(ToggleButton, 0.3)

			-- The tracking rail
			local Track = New("Frame", {
				Size = UDim2.fromOffset(34, 18),
				Position = UDim2.new(1, -44, 0.5, -9),
				BackgroundColor3 = Theme.Border,
				BorderSizePixel = 0,
			}, ToggleButton)
			Corner(Track, 9)

			-- The internal moving block
			local Knob = New("Frame", {
				Size = UDim2.fromOffset(12, 12),
				Position = UDim2.fromOffset(3, 3),
				BackgroundColor3 = Theme.Muted,
				BorderSizePixel = 0,
			}, Track)
			Corner(Knob, 6)

			local function Render(instant)
				local targetTrackColor = value and Theme.AccentDark or Theme.Border
				local targetKnobColor = value and Theme.Accent or Theme.Muted
				local targetKnobPos = value and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)

				if instant then
					Track.BackgroundColor3 = targetTrackColor
					Knob.BackgroundColor3 = targetKnobColor
					Knob.Position = targetKnobPos
				else
					TweenService:Create(Track, TweenInfo.new(0.18), {BackgroundColor3 = targetTrackColor}):Play()
					TweenService:Create(Knob, TweenInfo.new(0.18), {BackgroundColor3 = targetKnobColor, Position = targetKnobPos}):Play()
				end
			end

			ToggleButton.MouseEnter:Connect(function()
				TweenService:Create(ToggleButton, TweenInfo.new(0.12), {BackgroundColor3 = Theme.SurfaceHover}):Play()
			end)

			ToggleButton.MouseLeave:Connect(function()
				TweenService:Create(ToggleButton, TweenInfo.new(0.12), {BackgroundColor3 = Theme.Window}):Play()
			end)

			ToggleButton.Activated:Connect(function()
				value = not value
				Render(false)
				task.spawn(callback, value)
			end)

			Render(true)

			-- Return external hooks to control states on demand
			local toggleAPI = {}
			function toggleAPI:Set(newValue)
				value = not not newValue
				Render(false)
				task.spawn(callback, value)
			end
			
			return toggleAPI
		end

		return folderAPI
	end

	return windowAPI
end

return library
