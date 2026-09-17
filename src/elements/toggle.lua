--==================================================
-- n4noware Framework // Toggle Element Module
-- Path: src/elements/toggle.lua
--==================================================

local TweenService = game:GetService("TweenService")
local ToggleModule = {}

function ToggleModule.New(folderAPI, toggleConfig, theme, utilities, elementContainer)
    toggleConfig = toggleConfig or {}
    local toggleText = toggleConfig.Name or "Toggle"
    local default = toggleConfig.Default or false
    local callback = toggleConfig.Callback or function() end
    local value = default
    
    -- Main Container Button
    local ToggleButton = utilities.New("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = theme.Window,
        BorderSizePixel = 0,
        Text = "  " .. toggleText,
        TextColor3 = theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, elementContainer)
    
    utilities.Corner(ToggleButton, 6)
    utilities.Stroke(ToggleButton, 0.3)
    
    -- The tracking switch rail
    local Track = utilities.New("Frame", {
        Size = UDim2.fromOffset(34, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = theme.Border,
        BorderSizePixel = 0,
    }, ToggleButton)
    utilities.Corner(Track, 9)
    
    -- The internal moving slider knob
    local Knob = utilities.New("Frame", {
        Size = UDim2.fromOffset(12, 12),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = theme.Muted,
        BorderSizePixel = 0,
    }, Track)
    utilities.Corner(Knob, 6)
    
    -- Dynamic state rendering engine
    local function Render(instant)
        local targetTrackColor = value and theme.AccentDark or theme.Border
        local targetKnobColor = value and theme.Accent or theme.Muted
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
    
    -- Hover State Implementations
    ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.12), {BackgroundColor3 = theme.SurfaceHover}):Play()
    end)
    
    ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.12), {BackgroundColor3 = theme.Window}):Play()
    end)
    
    -- State Flipping Trigger Execution
    ToggleButton.Activated:Connect(function()
        value = not value
        Render(false)
        task.spawn(callback, value)
    end)
    
    Render(true)
    
    return ToggleButton
end

return ToggleModule
