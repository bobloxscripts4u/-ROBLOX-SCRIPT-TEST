--// CONFIGURATION
local permanentKey = "VIP-TSB2024"
local pastebinKeyURL = "https://pastebin.com/raw/L1QUZK0g"
local linkvertiseURL = "https://link-hub.net/1260685/silly-tsb-scrip"
local keyCheckInterval = 86400 -- 24 hours in seconds

--// SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

--// SAVE KEY SYSTEM
local function getSavePath()
    return "tsbkey_" .. LocalPlayer.UserId .. ".txt"
end

local function saveKey(key)
    writefile(getSavePath(), HttpService:JSONEncode({key = key, time = os.time()}))
end

local function loadSavedKey()
    if isfile(getSavePath()) then
        local data = HttpService:JSONDecode(readfile(getSavePath()))
        if data and data.key and data.time and os.time() - data.time <= keyCheckInterval then
            return data.key
        end
    end
end

--// UI LIBRARY
local function createKeyUI(onSubmit)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "TSBKeyUI"
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Position = UDim2.new(0.35, 0, 0.35, 0)
    Frame.Size = UDim2.new(0, 350, 0, 200)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Frame)
    Title.Text = "Enter Your Key"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true

    local TextBox = Instance.new("TextBox", Frame)
    TextBox.PlaceholderText = "Paste key here"
    TextBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    TextBox.Size = UDim2.new(0.8, 0, 0, 40)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextScaled = true

    local Submit = Instance.new("TextButton", Frame)
    Submit.Text = "Submit"
    Submit.Position = UDim2.new(0.1, 0, 0.55, 0)
    Submit.Size = UDim2.new(0.35, 0, 0, 35)
    Submit.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    Submit.TextScaled = true

    local LinkBtn = Instance.new("TextButton", Frame)
    LinkBtn.Text = "Receive Code"
    LinkBtn.Position = UDim2.new(0.55, 0, 0.55, 0)
    LinkBtn.Size = UDim2.new(0.35, 0, 0, 35)
    LinkBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
    LinkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    LinkBtn.TextScaled = true

    Submit.MouseButton1Click:Connect(function()
        onSubmit(TextBox.Text)
        ScreenGui:Destroy()
    end)

    LinkBtn.MouseButton1Click:Connect(function()
        setclipboard(linkvertiseURL)
        LinkBtn.Text = "Link Copied!"
    end)
end

--// KEY VALIDATION + LOAD MAIN MOD
local function validateAndLoad(key)
    if key == permanentKey then
        saveKey(key)
        loadMod()
        return
    end

    local success, pasteKey = pcall(function()
        return game:HttpGet(pastebinKeyURL)
    end)

    if success and key == pasteKey then
        saveKey(key)
        loadMod()
    else
        createKeyUI(validateAndLoad)
    end
end

--// MOD MENU FUNCTIONALITY
function loadMod()
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")

    -- UI
    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "TSBModMenu"

    local mainBtn = Instance.new("ImageButton", gui)
    mainBtn.Size = UDim2.new(0, 60, 0, 60)
    mainBtn.Position = UDim2.new(0, 20, 0.5, -30)
    mainBtn.Image = "rbxassetid://7072718365" -- "S" icon
    mainBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainBtn.BorderSizePixel = 0

    local frame = Instance.new("Frame", gui)
    frame.Position = UDim2.new(0, 90, 0.5, -100)
    frame.Size = UDim2.new(0, 200, 0, 250)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Visible = false
    frame.BorderSizePixel = 0

    local function addButton(text, callback)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, #frame:GetChildren() * 35)
        btn.Text = text
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BorderSizePixel = 0
        btn.MouseButton1Click:Connect(callback)
    end

    mainBtn.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)

    --// TSB ACTIONS
    local function getEnemy()
        local closest, dist = nil, math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local d = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    closest, dist = v, d
                end
            end
        end
        return closest
    end

    local autofarm = false
    addButton("Toggle AutoFarm", function()
        autofarm = not autofarm
    end)

    local autoskill = false
    addButton("Toggle AutoSkill", function()
        autoskill = not autoskill
    end)

    local autoblock = false
    addButton("Toggle AutoBlock", function()
        autoblock = not autoblock
    end)

    local autocounter = false
    addButton("Toggle AutoCounter", function()
        autocounter = not autocounter
    end)

    addButton("Speed Boost", function()
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end)

    RunService.RenderStepped:Connect(function()
        if autofarm then
            local enemy = getEnemy()
            if enemy and enemy.Character then
                local pos = enemy.Character.HumanoidRootPart.Position
                LocalPlayer.Character:MoveTo(pos + Vector3.new(2, 0, 0))
            end
        end

        if autoskill then
            local enemy = getEnemy()
            if enemy and enemy.Character and enemy.Character:FindFirstChild("Humanoid") then
                local hum = enemy.Character.Humanoid
                if hum.Health > 0 and not hum:GetState().Name:lower():find("knock") then
                    keypress(Enum.KeyCode.E) wait(0.1) keyrelease(Enum.KeyCode.E)
                end
            end
        end

        if autoblock then
            keypress(Enum.KeyCode.F)
            wait(0.05)
            keyrelease(Enum.KeyCode.F)
        end

        if autocounter then
            keypress(Enum.KeyCode.G)
            wait(0.05)
            keyrelease(Enum.KeyCode.G)
        end
    end)
end

--// START
local saved = loadSavedKey()
if saved then
    validateAndLoad(saved)
else
    createKeyUI(validateAndLoad)
end
