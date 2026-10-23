-- Developer UI Module

local DeveloperUI = {}

-- Constants
local SCREEN_GUI_NAME = "DeveloperUIScreenGui"
local FRAME_NAME = "DeveloperUIFrame"
local TITLE_BAR_NAME = "TitleBar"
local CLOSE_BUTTON_NAME = "CloseButton"
local REOPEN_BUTTON_NAME = "ReopenButton"
local TABS_FRAME_NAME = "TabsFrame"
local TAB_BUTTON_PREFIX = "TabButton"
local CONTENT_FRAME_NAME = "ContentFrame"
local REMOTE_EVENT_LOGGER_NAME = "RemoteEventLogger"

-- Variables
local screenGui
local frame
local titleBar
local closeButton
local reopenButton
local tabsFrame
local contentFrame
local remoteEventLogger
local currentTab

-- Function to create the UI
function DeveloperUI:CreateUI()
    -- Create ScreenGui
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = SCREEN_GUI_NAME
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Create Frame
    frame = Instance.new("Frame")
    frame.Name = FRAME_NAME
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Create Title Bar
    titleBar = Instance.new("Frame")
    titleBar.Name = TITLE_BAR_NAME
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame

    -- Create Close Button
    closeButton = Instance.new("TextButton")
    closeButton.Name = CLOSE_BUTTON_NAME
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar

    -- Create Reopen Button
    reopenButton = Instance.new("TextButton")
    reopenButton.Name = REOPEN_BUTTON_NAME
    reopenButton.Size = UDim2.new(0, 100, 0, 30)
    reopenButton.Position = UDim2.new(0.5, -50, 0.5, -15)
    reopenButton.AnchorPoint = Vector2.new(0.5, 0.5)
    reopenButton.Text = "Reopen UI"
    reopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    reopenButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    reopenButton.BorderSizePixel = 0
    reopenButton.Visible = false
    reopenButton.Parent = screenGui

    -- Create Tabs Frame
    tabsFrame = Instance.new("Frame")
    tabsFrame.Name = TABS_FRAME_NAME
    tabsFrame.Size = UDim2.new(0, 100, 1, -30)
    tabsFrame.Position = UDim2.new(0, 0, 0, 30)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabsFrame.BorderSizePixel = 0
    tabsFrame.Parent = frame

    -- Create Content Frame
    contentFrame = Instance.new("Frame")
    contentFrame.Name = CONTENT_FRAME_NAME
    contentFrame.Size = UDim2.new(1, -100, 1, -30)
    contentFrame.Position = UDim2.new(0, 100, 0, 30)
    contentFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = frame

    -- Create Remote Event Logger
    remoteEventLogger = Instance.new("ScrollingFrame")
    remoteEventLogger.Name = REMOTE_EVENT_LOGGER_NAME
    remoteEventLogger.Size = UDim2.new(1, 0, 1, 0)
    remoteEventLogger.Position = UDim2.new(0, 0, 0, 0)
    remoteEventLogger.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    remoteEventLogger.BorderSizePixel = 0
    remoteEventLogger.Visible = false
    remoteEventLogger.Parent = contentFrame

    -- Create UI List Layout for Tabs
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = tabsFrame

    -- Create Tab Buttons
    local tabNames = {"Tab 1", "Tab 2", "Tab 3", "Remote Events"}
    for i, tabName in ipairs(tabNames) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = TAB_BUTTON_PREFIX .. i
        tabButton.Size = UDim2.new(1, 0, 0, 30)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabsFrame

        tabButton.MouseButton1Click:Connect(function()
            DeveloperUI:SwitchTab(tabName)
        end)
    end

    -- Make the UI draggable
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Connect Close Button
    closeButton.MouseButton1Click:Connect(function()
        frame.Visible = false
        reopenButton.Visible = true
    end)

    -- Connect Reopen Button
    reopenButton.MouseButton1Click:Connect(function()
        frame.Visible = true
        reopenButton.Visible = false
    end)

    -- Initialize the first tab
    DeveloperUI:SwitchTab("Tab 1")
end

-- Function to switch tabs
function DeveloperUI:SwitchTab(tabName)
    if currentTab then
        currentTab.Visible = false
    end

    if tabName == "Remote Events" then
        remoteEventLogger.Visible = true
        currentTab = remoteEventLogger
    else
        -- Handle other tabs if needed
    end
end

-- Function to log remote events
function DeveloperUI:LogRemoteEvent(eventName, eventFunction, scriptName)
    local logEntry = Instance.new("TextLabel")
    logEntry.Size = UDim2.new(1, 0, 0, 30)
    logEntry.Text = string.format("Event: %s\nFunction: %s\nScript: %s", eventName, eventFunction, scriptName)
    logEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
    logEntry.BackgroundTransparency = 1
    logEntry.TextWrapped = true
    logEntry.Parent = remoteEventLogger

    -- Adjust the canvas size to fit all log entries
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = remoteEventLogger
    remoteEventLogger.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end

return DeveloperUI