--[[
  TSB MOD MENU with KEY SYSTEM by SKIBIDIGUYYT 
  Daily Key via Linkvertise + Pastebin
  VIP Key: "VIP-TSB2024"
--]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

--// CONFIG
local key_url = "https://pastebin.com/raw/L1QUZK0g"
local vip_key = "VIP-TSB2024"
local verify_url = "https://link-hub.net/1260685/silly-tsb-scrip"
local save_key_id = "TSBKeySave_"..LocalPlayer.UserId

--// UI - Key Input
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "TSB_KeyUI"

local main = Instance.new("Frame", ScreenGui)
main.Size = UDim2.new(0, 300, 0, 180)
main.Position = UDim2.new(0.5, -150, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Visible = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "TSB Key System"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextScaled = true

local input = Instance.new("TextBox", main)
input.PlaceholderText = "Enter your key here..."
input.Position = UDim2.new(0.1, 0, 0.35, 0)
input.Size = UDim2.new(0.8, 0, 0, 30)
input.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
input.TextColor3 = Color3.fromRGB(255, 255, 255)

local status = Instance.new("TextLabel", main)
status.Position = UDim2.new(0.1, 0, 0.6, 0)
status.Size = UDim2.new(0.8, 0, 0, 20)
status.Text = ""
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.BackgroundTransparency = 1

local getcode = Instance.new("TextButton", main)
getcode.Text = "Receive Code"
getcode.Position = UDim2.new(0.1, 0, 0.75, 0)
getcode.Size = UDim2.new(0.35, 0, 0, 30)
getcode.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
getcode.TextColor3 = Color3.fromRGB(255, 255, 255)
getcode.MouseButton1Click:Connect(function()
	setclipboard(verify_url)
	status.Text = "Link copied! Complete tasks to get code."
end)

local submit = Instance.new("TextButton", main)
submit.Text = "Submit"
submit.Position = UDim2.new(0.55, 0, 0.75, 0)
submit.Size = UDim2.new(0.35, 0, 0, 30)
submit.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
submit.TextColor3 = Color3.fromRGB(255, 255, 255)

--// Validation
local function validateKey(key)
	local stored = getgenv()[save_key_id]
	local now = os.time()

	if key == vip_key then
		return true
	end

	local success, response = pcall(function()
		return game:HttpGet(key_url)
	end)

	if success and response then
		if string.match(response, key) then
			getgenv()[save_key_id] = now
			return true
		end
	end
	return false
end

--// Autoload if valid
if getgenv()[save_key_id] and (os.time() - getgenv()[save_key_id]) < 86400 then
	ScreenGui:Destroy()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBossScript/SillyTSB/main/FullTSBMod.lua"))()
	return
end

--// Submit handler
submit.MouseButton1Click:Connect(function()
	local inputKey = input.Text
	if validateKey(inputKey) then
		status.Text = "Key accepted!"
		wait(1)
		ScreenGui:Destroy()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBossScript/SillyTSB/main/FullTSBMod.lua"))()
	else
		status.Text = "Invalid key. Try again!"
	end
end)
