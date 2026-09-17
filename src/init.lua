--==================================================
-- n4noware Framework // Central Core Initializer
-- Path: src/init.lua
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- Acquire localized framework dependencies
local Theme = require(script.Parent.theme)
local Utilities = require(script.Parent.utilities)

local library = {}

-- [[ METHOD: CREATE MAIN WINDOW ENGINE ]]
function library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "n4noware UI"
    
    -- Establish standard execution layer container path safely
    local TargetParent = game:GetService("CoreGui"):FindFirstChild("RobloxGui") or Player:WaitForChild("PlayerGui")
    
    -- Evict any running older versions to prevent layout collision conflicts
    if TargetParent:FindFirstChild("N4nowareFramework") then
        TargetParent:FindFirstChild("N4nowareFramework"):Destroy()
    end
    
    -- Master Core GUI Layer
    local Gui = Utilities.New("ScreenGui", {
        Name = "N4nowareFramework",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, TargetParent)
    
    -- Main Canvas Core Window Box 
    local Window = Utilities.New("Frame", {
        Name = "MainWindow",
        Size = UDim2.fromOffset(480, 310),
        Position = UDim2.new(0.5, -240, 0.5, -155),
        BackgroundColor3 = Theme.Window,
        BorderSizePixel = 0,
    }, Gui)
    Utilities.Corner(Window, 10)
    Utilities.Stroke(Window, 0.25)
    
    -- Draggable Window Header Bar
    local Header = Utilities.New("Frame", {
        Name = "HeaderBar",
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
    }, Window)
    Utilities.Corner(Header, 10)
    
    -- Line separator under the header bar
    local HeaderLine = Utilities.New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
    }, Header)
    
    local Title = Utilities.New("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.fromOffset(14, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Header)
    
    -- Sidebar Navigation Hub Frame
    local NavigationHub = Utilities.New("Frame", {
        Name = "NavigationHub",
        Size = UDim2.new(0, 130, 1, -42),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
    }, Window)
    
    local NavLine = Utilities.New("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
    }, NavigationHub)
    
    local NavListLayout = Utilities.New("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, NavigationHub)
    
    Utilities.New("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6)
    }, NavigationHub)
    
    -- Main Elements Canvas Dynamic Section Viewport
    local ContentViewport = Utilities.New("Frame", {
        Name = "ContentViewport",
        Size = UDim2.new(1, -130, 1, -42),
        Position = UDim2.new(0, 130, 0, 42),
        BackgroundTransparency = 1,
    }, Window)
    
    -- ==================================================
    -- IMPLEMENT SEAMLESS INTERACTIVE DRAGGING SYSTEM
    -- ==================================================
    local dragging, dragInput, dragStart, startPos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- ==================================================
    -- CORE API SUB-INSTANCE METHODS EXPOSURE
    -- ==================================================
    local windowAPI = {}
    local totalFolders = 0
    
    function windowAPI:CreateFolder(folderName)
        totalFolders = totalFolders + 1
        local FolderModule = require(script.elements.folder)
        local folderAPI, folderCanvas = FolderModule.New(windowAPI, folderName, Theme, Utilities, ContentViewport, NavigationHub)
        
        -- Automatically render open visual state on the very first section slot
        if totalFolders == 1 then
            folderAPI:Open()
        end
        
        return folderAPI
    end
    
    return windowAPI
end

return library
