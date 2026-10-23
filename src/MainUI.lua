-- Main UI script for Roblox

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create the main screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainUI"
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Parent = screenGui

-- Create the close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 50, 0, 30)
closeButton.Position = UDim2.new(1, -60, 0, 10)
closeButton.Text = "Close"
closeButton.Parent = mainFrame

-- Create the reopen button
local reopenButton = Instance.new("TextButton")
reopenButton.Name = "ReopenButton"
reopenButton.Size = UDim2.new(0, 70, 0, 30)
reopenButton.Position = UDim2.new(0.5, -35, 1, -40)
reopenButton.Text = "Reopen"
reopenButton.Visible = false
reopenButton.Parent = screenGui

-- Function to close the UI
local function closeUI()
    mainFrame.Visible = false
    reopenButton.Visible = true
end

-- Function to reopen the UI
local function reopenUI()
    mainFrame.Visible = true
    reopenButton.Visible = false
end

-- Connect the close button
closeButton.MouseButton1Click:Connect(closeUI)

-- Connect the reopen button
reopenButton.MouseButton1Click:Connect(reopenUI)

-- Create tabs
local tabs = {}
local tabButtons = {}

-- Function to create a new tab
local function createTab(tabName)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "Button"
    tabButton.Size = UDim2.new(0, 100, 0, 30)
    tabButton.Position = UDim2.new(0, #tabs * 100, 0, 0)
    tabButton.Text = tabName
    tabButton.Parent = mainFrame

    local tab = Instance.new("Frame")
    tab.Name = tabName .. "Tab"
    tab.Size = UDim2.new(1, 0, 1, -30)
    tab.Position = UDim2.new(0, 0, 0, 30)
    tab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    tab.Visible = false
    tab.Parent = mainFrame

    table.insert(tabs, tab)
    table.insert(tabButtons, tabButton)

    -- Function to switch tabs
    local function switchTab()
        for _, t in ipairs(tabs) do
            t.Visible = false
        end
        tab.Visible = true
    end

    -- Connect the tab button
    tabButton.MouseButton1Click:Connect(switchTab)

    return tab
end

-- Create some empty tabs
createTab("Tab1")
createTab("Tab2")
createTab("Tab3")

-- Create the remote event logger tab
local remoteEventLoggerTab = createTab("RemoteEvents")

-- Create a scroll frame for the remote event logger
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "RemoteEventLog"
scrollFrame.Size = UDim2.new(1, -20, 1, -20)
scrollFrame.Position = UDim2.new(0, 10, 0, 10)
scrollFrame.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
scrollFrame.ScrollBarThickness = 5
scrollFrame.Parent = remoteEventLoggerTab

-- Create a text label for the log
local logLabel = Instance.new("TextLabel")
logLabel.Name = "LogLabel"
logLabel.Size = UDim2.new(1, -10, 1, -10)
logLabel.Position = UDim2.new(0, 5, 0, 5)
logLabel.Text = "Remote Event Log:\n"
logLabel.TextWrapped = true
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.BackgroundTransparency = 1
logLabel.Parent = scrollFrame

-- Function to log remote events
local function logRemoteEvent(eventName, eventFunction, scriptName)
    logLabel.Text = logLabel.Text .. string.format("Event: %s\nFunction: %s\nScript: %s\n\n", eventName, eventFunction, scriptName)
end

-- Example of how to log a remote event (this would be called when a remote event is triggered)
-- logRemoteEvent("ExampleEvent", "function() print('Event triggered') end", "ExampleScript")

-- Create a remote event to receive log messages from the server
local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "RemoteEventLogger"
remoteEvent.Parent = ReplicatedStorage

-- Connect the remote event to the log function
remoteEvent.OnClientEvent:Connect(function(eventName, eventFunction, scriptName)
    logRemoteEvent(eventName, eventFunction, scriptName)
end)