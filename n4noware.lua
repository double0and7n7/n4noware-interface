
--===================================================================
-- n4noware Framework // Unified Production Bundle
-- Single-Line Loadstring Compatible
--===================================================================

-- [1. THEME MATRIX CONFIGURATION]
local Theme = {
    Window = Color3.fromRGB(20, 20, 20),
    Background = Color3.fromRGB(15, 15, 15),
    Surface = Color3.fromRGB(25, 25, 25),
    SurfaceHover = Color3.fromRGB(30, 30, 30),
    Border = Color3.fromRGB(35, 35, 35),
    Text = Color3.fromRGB(240, 240, 240),
    Muted = Color3.fromRGB(140, 140, 140),
    Accent = Color3.fromRGB(46, 204, 113),       -- Vibrant Green
    AccentDark = Color3.fromRGB(39, 174, 96)
}

-- [2. CORE FRAMEWORK UTILITIES]
local Utilities = {}
function Utilities.New(className, properties, parent)
    local obj = Instance.new(className)
    for prop, val in pairs(properties) do
        obj[prop] = val
    end
    if parent then obj.Parent = parent end
    return obj
end

function Utilities.Corner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

function Utilities.Stroke(instance, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = Theme.Border
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

-- [3. ELEMENT MODULE: BUTTON]
local ButtonModule = {}
function ButtonModule.New(buttonConfig, elementContainer)
    buttonConfig = buttonConfig or {}
    local buttonText = buttonConfig.Name or "Button"
    local callback = buttonConfig.Callback or function() end
    
    local Button = Utilities.New("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Window,
        BorderSizePixel = 0,
        Text = "  " .. buttonText,
        TextColor3 = Theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, elementContainer)
    
    Utilities.Corner(Button, 6)
    Utilities.Stroke(Button, 0.3)
    
    Button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(Button, TweenInfo.new(0.12), {BackgroundColor3 = Theme.SurfaceHover}):Play()
    end)
    Button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(Button, TweenInfo.new(0.12), {BackgroundColor3 = Theme.Window}):Play()
    end)
    Button.Activated:Connect(function()
        task.spawn(callback)
        Button.BackgroundColor3 = Theme.AccentDark
        game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Window}):Play()
    end)
    return Button
end

-- [4. ELEMENT MODULE: TOGGLE]
local ToggleModule = {}
function ToggleModule.New(toggleConfig, elementContainer)
    toggleConfig = toggleConfig or {}
    local toggleText = toggleConfig.Name or "Toggle"
    local default = toggleConfig.Default or false
    local callback = toggleConfig.Callback or function() end
    local value = default
    
    local ToggleButton = Utilities.New("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Window,
        Text = "  " .. toggleText,
        TextColor3 = Theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, elementContainer)
    Utilities.Corner(ToggleButton, 6)
    Utilities.Stroke(ToggleButton, 0.3)
    
    local Track = Utilities.New("Frame", {
        Size = UDim2.fromOffset(34, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = Theme.Border,
    }, ToggleButton)
    Utilities.Corner(Track, 9)
    
    local Knob = Utilities.New("Frame", {
        Size = UDim2.fromOffset(12, 12),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Theme.Muted,
    }, Track)
    Utilities.Corner(Knob, 6)
    
    local function Render(instant)
        local targetTrack = value and Theme.AccentDark or Theme.Border
        local targetKnob = value and Theme.Accent or Theme.Muted
        local targetPos = value and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
        if instant then
            Track.BackgroundColor3 = targetTrack
            Knob.BackgroundColor3 = targetKnob
            Knob.Position = targetPos
        else
            game:GetService("TweenService"):Create(Track, TweenInfo.new(0.18), {BackgroundColor3 = targetTrack}):Play()
            game:GetService("TweenService"):Create(Knob, TweenInfo.new(0.18), {BackgroundColor3 = targetKnob, Position = targetPos}):Play()
        end
    end
    
    ToggleButton.Activated:Connect(function()
        value = not value
        Render(false)
        task.spawn(callback, value)
    end)
    Render(true)
    return ToggleButton
end

-- [5. ELEMENT MODULE: DROPDOWN]
local DropdownModule = {}
function DropdownModule.New(folderAPI, dropdownConfig, elementContainer)
    dropdownConfig = dropdownConfig or {}
    local dropdownText = dropdownConfig.Name or "Dropdown"
    local listOptions = dropdownConfig.Options or {}
    local callback = dropdownConfig.Callback or function() end
    local open = false
    local selected = listOptions[1] or "None"
    
    local DropdownFrame = Utilities.New("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.Window,
        ClipsDescendants = true
    }, elementContainer)
    Utilities.Corner(DropdownFrame, 6)
    Utilities.Stroke(DropdownFrame, 0.3)
    
    local DropdownHeader = Utilities.New("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Text = "  " .. dropdownText,
        TextColor3 = Theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, DropdownFrame)
    
    local SelectedLabel = Utilities.New("TextLabel", {
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(1, -155, 0, 0),
        BackgroundTransparency = 1,
        Text = selected,
        TextColor3 = Theme.Accent,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Right
    }, DropdownHeader)
    
    local ListHolder = Utilities.New("Frame", {
        Size = UDim2.new(1, -16, 1, -42),
        Position = UDim2.fromOffset(8, 38),
        BackgroundTransparency = 1
    }, DropdownFrame)
    
    local ListLayout = Utilities.New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, ListHolder)
    
    local function ToggleDropdown()
        open = not open
        local targetHeight = open and (36 + ListLayout.AbsoluteContentSize.Y + 10) or 36
        local tween = game:GetService("TweenService"):Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)})
        tween:Play()
        if folderAPI and folderAPI.ResizeFolder then
            tween.Completed:Connect(function() folderAPI:ResizeFolder() end)
            folderAPI:ResizeFolder()
        end
    end
    
    DropdownHeader.Activated:Connect(ToggleDropdown)
    
    for index, optionName in ipairs(listOptions) do
        local OptionButton = Utilities.New("TextButton", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = Theme.Window,
            Text = "  " .. tostring(optionName),
            TextColor3 = Theme.Muted,
            TextSize = 10,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = index,
            AutoButtonColor = false
        }, ListHolder)
        Utilities.Corner(OptionButton, 4)
        
        OptionButton.Activated:Connect(function()
            SelectedLabel.Text = tostring(optionName)
            ToggleDropdown()
            task.spawn(callback, optionName)
        end)
    end
    return DropdownFrame
end

-- [6. ELEMENT MODULE: FOLDER NAVIGATION]
local FolderModule = {}
function FolderModule.New(folderName, contentContainer, navigationContainer)
    local folderAPI = {}
    
    local NavButton = Utilities.New("TextButton", {
        Size = UDim2.new(1, -12, 0, 32),
        BackgroundColor3 = Theme.Window,
        Text = "   " .. folderName,
        TextColor3 = Theme.Muted,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, navigationContainer)
    Utilities.Corner(NavButton, 6)
    Utilities.Stroke(NavButton, 0.3)
    
    local ElementCanvas = Utilities.New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        Visible = false,
    }, contentContainer)
    
    local Layout = Utilities.New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, ElementCanvas)
    Utilities.New("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, ElementCanvas)
    
    function folderAPI:ResizeFolder()
        ElementCanvas.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 12)
    end
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() folderAPI:ResizeFolder() end)
    
    function folderAPI:Open()
        for _, canvas in ipairs(contentContainer:GetChildren()) do
            if canvas:IsA("ScrollingFrame") then canvas.Visible = false end
        end
        for _, btn in ipairs(navigationContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                game:GetService("TweenService"):Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Window, TextColor3 = Theme.Muted}):Play()
            end
        end
ElementCanvas.Visible = true
game:GetService("TweenService"):Create(NavButton, TweenInfo.new(0.15), {BackgroundColor3 = Theme.SurfaceHover, TextColor3 = Theme.Text}):Play()
end
NavButton.Activated:Connect(function() folderAPI:Open() end)
function folderAPI:CreateButton(config) return ButtonModule.New(config, ElementCanvas) end
function folderAPI:CreateToggle(config) return ToggleModule.New(config, ElementCanvas) end
function folderAPI:CreateDropdown(config) return DropdownModule.New(folderAPI, config, ElementCanvas) end
return folderAPI, ElementCanvas
end
-- [7. MASTER CORE LIBRARY ENGINE]
local library = {}
function library:CreateWindow(config)
config = config or {}
local windowName = config.Name or "n4noware UI"
local TargetParent = game:GetService("CoreGui"):FindFirstChild("RobloxGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
if TargetParent:FindFirstChild("N4nowareFramework") then TargetParent:FindFirstChild("N4nowareFramework"):Destroy() end
local Gui = Utilities.New("ScreenGui", {Name = "N4nowareFramework", ResetOnSpawn = false, IgnoreGuiInset = true}, TargetParent)
local Window = Utilities.New("Frame", {
Size = UDim2.fromOffset(480, 310),
Position = UDim2.new(0.5, -240, 0.5, -155),
BackgroundColor3 = Theme.Window,
}, Gui)
Utilities.Corner(Window, 10)
Utilities.Stroke(Window, 0.25)
local Header = Utilities.New("Frame", {Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Theme.Surface}, Window)
Utilities.Corner(Header, 10)
local Title = Utilities.New("TextLabel", {
Size = UDim2.new(1, -30, 1, 0), Position = UDim2.fromOffset(14, 0), BackgroundTransparency = 1,
Text = windowName, TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left
}, Header)
local NavigationHub = Utilities.New("Frame", {
Size = UDim2.new(0, 130, 1, -42), Position = UDim2.new(0, 0, 0, 42), BackgroundColor3 = Theme.Background,
}, Window)
Utilities.New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, NavigationHub)
Utilities.New("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, NavigationHub)
local ContentViewport = Utilities.New("Frame", {Size = UDim2.new(1, -130, 1, -42), Position = UDim2.new(0, 130, 0, 42), BackgroundTransparency = 1}, Window)
-- Dragging System Mechanics
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true dragStart = input.Position startPos = Window.Position
input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement) then
local delta = input.Position - dragStart
Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)
local windowAPI = {}
local totalFolders = 0
function windowAPI:CreateFolder(folderName)
totalFolders = totalFolders + 1
local folderAPI, folderCanvas = FolderModule.New(folderName, ContentViewport, NavigationHub)
if totalFolders == 1 then folderAPI:Open() end
return folderAPI
end
return windowAPI
end
-- Crucial execution line: allows the loadstring pipeline to pass the library reference back out
return library
