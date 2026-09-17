--==================================================
-- n4noware Framework // Button Element Module
-- Path: src/elements/button.lua
--==================================================

local TweenService = game:GetService("TweenService")
local ButtonModule = {}

function ButtonModule.New(folderAPI, buttonConfig, theme, utilities, elementContainer)
    buttonConfig = buttonConfig or {}
    local buttonText = buttonConfig.Name or "Button"
    local callback = buttonConfig.Callback or function() end
    
    -- Instantiate Interactive TextButton
    local Button = utilities.New("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = theme.Window,
        BorderSizePixel = 0,
        Text = "  " .. buttonText,
        TextColor3 = theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, elementContainer)
    
    utilities.Corner(Button, 6)
    utilities.Stroke(Button, 0.3)
    
    -- Visual Hover State Animations
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.12), {BackgroundColor3 = theme.SurfaceHover}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.12), {BackgroundColor3 = theme.Window}):Play()
    end)
    
    -- Activation Event Handling
    Button.Activated:Connect(function()
        task.spawn(callback)
        
        -- Click Feedback Flash Implementation
        Button.BackgroundColor3 = theme.AccentDark
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = theme.Window}):Play()
    end)
    
    return Button
end

return ButtonModule
