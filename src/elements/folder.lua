--==================================================
-- n4noware Framework // Folder Element Module
-- Path: src/elements/folder.lua
--==================================================

local TweenService = game:GetService("TweenService")
local FolderModule = {}

function FolderModule.New(windowAPI, folderName, theme, utilities, contentContainer, navigationContainer)
    folderName = folderName or "Folder"
    
    local folderAPI = {}
    local open = false
    
    -- 1. Navigation Button (Sidebar tab)
    local NavButton = utilities.New("TextButton", {
        Size = UDim2.new(1, -12, 0, 32),
        BackgroundColor3 = theme.Window,
        BorderSizePixel = 0,
        Text = "   " .. folderName,
        TextColor3 = theme.Muted,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, navigationContainer)
    
    utilities.Corner(NavButton, 6)
    utilities.Stroke(NavButton, 0.3)
    
    -- 2. Scrolling Content Canvas for elements
    local ElementCanvas = utilities.New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Accent,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, contentContainer)
    
    local Layout = utilities.New("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, ElementCanvas)
    
    utilities.New("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6)
    }, ElementCanvas)
    
    -- Automatically recalibrates the scrollable window boundaries
    function folderAPI:ResizeFolder()
        ElementCanvas.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 12)
    end
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        folderAPI:ResizeFolder()
    end)
    
    -- Handles selection transitions and visual swapping
    function folderAPI:Open()
        for _, otherCanvas in ipairs(contentContainer:GetChildren()) do
            if otherCanvas:IsA("ScrollingFrame") then
                otherCanvas.Visible = false
            end
        end
        for _, otherButton in ipairs(navigationContainer:GetChildren()) do
            if otherButton:IsA("TextButton") then
                TweenService:Create(otherButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = theme.Window,
                    TextColor3 = theme.Muted
                }):Play()
            end
        end
        
        ElementCanvas.Visible = true
        TweenService:Create(NavButton, TweenInfo.new(0.15), {
            BackgroundColor3 = theme.SurfaceHover,
            TextColor3 = theme.Text
        }):Play()
    end
    
    -- Interactive event attachments
    NavButton.MouseEnter:Connect(function()
        if not ElementCanvas.Visible then
            TweenService:Create(NavButton, TweenInfo.new(0.12), {TextColor3 = theme.Text}):Play()
        end
    end)
    
    NavButton.MouseLeave:Connect(function()
        if not ElementCanvas.Visible then
            TweenService:Create(NavButton, TweenInfo.new(0.12), {TextColor3 = theme.Muted}):Play()
        end
    end)
    
    NavButton.Activated:Connect(function()
        folderAPI:Open()
    end)
    
    -- Sub-element pipeline binding wrappers
    function folderAPI:CreateButton(config)
        local ButtonModule = require(script.Parent.button)
        return ButtonModule.New(folderAPI, config, theme, utilities, ElementCanvas)
    end
    
    function folderAPI:CreateToggle(config)
        local ToggleModule = require(script.Parent.toggle)
        return ToggleModule.New(folderAPI, config, theme, utilities, ElementCanvas)
    end
    
    function folderAPI:CreateDropdown(config)
        local DropdownModule = require(script.Parent.dropdown)
        return DropdownModule.New(folderAPI, config, theme, utilities, ElementCanvas)
    end
    
    return folderAPI, ElementCanvas
end

return FolderModule
