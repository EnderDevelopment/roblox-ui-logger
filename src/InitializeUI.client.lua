-- Initialize UI Client Script

local DeveloperUI = require(game:GetService("ReplicatedStorage"):WaitForChild("DeveloperUI"))

-- Initialize the UI when the player joins the game
DeveloperUI:CreateUI()

-- Example of logging a remote event
DeveloperUI:LogRemoteEvent("ExampleEvent", "ExampleFunction", "ExampleScript")