--==================================================
-- n4noware Framework // Dropdown Element Module
-- Path: src/elements/dropdown.lua
--==================================================

local TweenService = game:GetService("TweenService")
local DropdownModule = {}

function DropdownModule.New(folderAPI, dropdownConfig, theme, utilities, elementContainer)
    dropdownConfig = dropdownConfig or {}
    local dropdownText = dropdownConfig.Name or "Dropdown"
    local listOptions = dropdownConfig.Options or {}
    local callback = dropdownConfig.Callback or function() end
    
    local open = false
    local selected = listOptions[1] or "None"
    
    -- Main external container box
    local DropdownFrame = utilities.New("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = theme.Window,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, elementContainer)
    
    utilities.Corner(DropdownFrame, 6)
    utilities.Stroke(DropdownFrame, 0.3)
    
    -- Clickable Top Header button
    local DropdownHeader = utilities.New("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Text = "  " .. dropdownText,
        TextColor3 = theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, DropdownFrame)
    
    -- Shows current active option choice
    local SelectedLabel = utilities.New("TextLabel", {
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(1, -155, 0, 0),
        BackgroundTransparency = 1,
        Text = selected,
        TextColor3 = theme.Accent,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Right
    }, DropdownHeader)
    
    -- Visual indicator arrow
    local Indicator = utilities.New("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = theme.Muted,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Center
    }, DropdownHeader)
    
    -- Internal list layout holder for items
    local ListHolder = utilities.New("Frame", {
        Size = UDim2.new(1, -16, 1, -42),
        Position = UDim2.fromOffset(8, 38),
        BackgroundTransparency = 1
    }, DropdownFrame)
    
    local ListLayout = utilities.New("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, ListHolder)
    
    -- Smooth expanding height animation
    local function ToggleDropdown()
        open = not open
        Indicator.Text = open and "▲" or "▼"
        
        local targetHeight = open and (36 + ListLayout.AbsoluteContentSize.Y + 10) or 36
        local tween = TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, targetHeight)
        })
        
        tween:Play()
        
        -- If folder resizing is handled globally by your layout system
        if folderAPI and folderAPI.ResizeFolder then
            tween.Completed:Connect(function()
                folderAPI:ResizeFolder()
            end)
            folderAPI:ResizeFolder()
        end
    end
    
    DropdownHeader.Activated:Connect(ToggleDropdown)
    
    -- Dynamically build option rows
    for index, optionName in ipairs(listOptions) do
        local OptionButton = utilities.New("TextButton", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = theme.Window, -- clean base row color
            BorderSizePixel = 0,
            Text = "  " .. tostring(optionName),
            TextColor3 = theme.Muted,
            TextSize = 10,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = index,
            AutoButtonColor = false
        }, ListHolder)
        
        utilities.Corner(OptionButton, 4)
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.1), {
                BackgroundColor3 = theme.SurfaceHover, 
                TextColor3 = theme.Text
            }):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.1), {
                BackgroundColor3 = theme.Window, 
                TextColor3 = theme.Muted
            }):Play()
        end)
        
        OptionButton.Activated:Connect(function()
            selected = optionName
            SelectedLabel.Text = selected
            ToggleDropdown()
            task.spawn(callback, selected)
        end)
    end
    
    return DropdownFrame
end

return DropdownModule
