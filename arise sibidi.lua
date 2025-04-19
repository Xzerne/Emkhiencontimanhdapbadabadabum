
getgenv().speed = 140
getgenv().floorToLeave = 26
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "CountdownGui"

local textLabel = Instance.new("TextLabel", screenGui)
textLabel.Size = UDim2.new(0, 150, 0, 30)
textLabel.Position = UDim2.new(0, 10, 0, 10)
textLabel.BackgroundTransparency = 0.3
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextScaled = true
textLabel.Text = "UPDATING..."

function updateCountdown()
 local currentTime = os.date("*t")
 local min = currentTime.min
 local sec = currentTime.sec
 local minutesLeft = 44 - min
 local secondsLeft = 60 - sec
 if minutesLeft < 0 then
  textLabel.Text = "CASTLE SPAWNED!"
 else
  textLabel.Text = minutesLeft .. "m " .. secondsLeft .. "s"
 end
end

local thongbao = loadstring(game:HttpGet('https://raw.githubusercontent.com/Xzerne/Emkhiencontimanhdapbadabadabum/refs/heads/main/Utils/notificationbadabadabum.lua'))()

function checkTime()
 local currentTime = os.date("*t")
 local minute = currentTime.min
 return minute >= 45 and minute <= 59
end

function joinWithStage()
 local args = {
  {
   {
    ["Event"] = "JoinCastle",
    ["Check"] = true
   },
   "\n"
  }
 }
 game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
end

function joinStart()
 local args = {
  {
   {
    ["Event"] = "JoinCastle",
    ["Check"] = false
   },
   "\n"
  }
 }
 game:GetService("ReplicatedStorage").BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
end

function tp(cframe)
 local player = game.Players.LocalPlayer
 local character = player.Character
 if not character then return end

 local hrp = character:FindFirstChild("HumanoidRootPart")
 if not hrp then return end

 local updater = character:FindFirstChild("CharacterScripts") and character.CharacterScripts:FindFirstChild("CharacterUpdater")
 if updater then updater:Destroy() end

 local fixer = character:FindFirstChild("CharacterScripts") and character.CharacterScripts:FindFirstChild("FlyingFixer")
 if fixer then fixer:Destroy() end

 local success = pcall(function()
  hrp.CFrame = cframe
  thongbao("CASTLE SPAWNED!", "Teleporting!", 2)
 end)

 if not success then
  local TweenService = game:GetService("TweenService")
  local distance = (hrp.Position - cframe.Position).Magnitude
  local speed = getgenv().speed
  local time = distance / speed

  local goal = { CFrame = cframe }
  local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
  local tween = TweenService:Create(hrp, tweenInfo, goal)
  tween:Play()
  thongbao("FAILED TO TELEPORT :(", "Trying to tween", 5)
 end
end

function joinCastle()
 if checkTime() then
  tp(CFrame.new(574.596924, 28.4345264, 204.700562, -0.911388338, 2.83596563e-07, -0.411547393, 5.67373149e-07, 1, -5.67372638e-07, 0.411547393, -7.50597735e-07, -0.911388338))
  task.wait(1)
  if getgenv().mode == true then
   thongbao("JOINING CASTLE", "Mode: Join With Stage Saved", 2)
   joinWithStage()
  else
   joinStart()
   thongbao("JOINING CASTLE", "Mode: Join By Starting Over", 2)
  end
 end
end

spawn(function()
 while wait(1) do
  if getgenv().count then
   updateCountdown()
  else
   textLabel.Text = ""
  end
  if getgenv().join and game.PlaceId == 87039211657390 then
   joinCastle()
  end
 end
end)

function getBiggestRoom()
 local world = workspace:FindFirstChild("__Main") and workspace.__Main:FindFirstChild("__World")
 if not world then return nil end

 local biggestNum = -math.huge
 local targetRoom = nil

 for _, v in pairs(world:GetChildren()) do
  if v:IsA("Model") and v.Name:match("^Room_(%d+)$") then
   local num = tonumber(v.Name:match("Room_(%d+)"))
   if num and num > biggestNum then
    biggestNum = num
    targetRoom = v
   end
  end
 end

 return targetRoom
end

function teleportToRoom(room)
 if room then
  tp(room.WorldPivot)
 end
end

local function FindNearestEnemy()
 local character = game.Players.LocalPlayer.Character
 if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

 local hrp = character.HumanoidRootPart
 local closest = nil
 local minDist = math.huge

 for _, v in pairs(workspace.__Main.__Enemies.Client:GetChildren()) do
  local healthText = v:FindFirstChild("HealthBar") and v.HealthBar:FindFirstChild("Main") and v.HealthBar.Main:FindFirstChild("Bar") and v.HealthBar.Main.Bar:FindFirstChild("Amount")
  local root = v:FindFirstChild("HumanoidRootPart")

  if healthText and root and v:IsDescendantOf(workspace) and healthText.ContentText ~= "0 HP" then
   local dist = (hrp.Position - root.Position).Magnitude
   if dist < minDist then
    minDist = dist
    closest = {
     instance = v,
     name = v.Name,
     rootPart = root,
     healthText = healthText
    }
   end
  end
 end

 return closest
end

spawn(function()
 local lastRoom = nil
 while wait() do
  if getgenv().autocastle and game.PlaceId ~= 87039211657390 then
   local room = getBiggestRoom()
   if room and room ~= lastRoom then
    lastRoom = room
    teleportToRoom(room)
   end

   local targetEnemy = FindNearestEnemy()
   if targetEnemy then
    if targetEnemy.instance:IsDescendantOf(workspace) and targetEnemy.healthText.ContentText ~= "0 HP" then
     tp(targetEnemy.rootPart.CFrame * CFrame.new(0, 0, 6))
     local args = {
      { { Event = "PunchAttack", Enemy = targetEnemy.name }, "\4" }
     }
     game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
     task.wait()
    end
   else
    local newRoom = getBiggestRoom()
    if newRoom and newRoom ~= lastRoom then
     lastRoom = newRoom
     teleportToRoom(newRoom)
    end
   end
   task.wait(1)
  end
 end
end)

function TpGameId(Id)
local ts = game:GetService("TeleportService")

ts:Teleport(Id)
end

spawn(function()
    while wait() do
        if getgenv().leaveOnFloor == true then
            pcall(function()
                local currentFloor = getBiggestRoom()
                if currentFloor == "Room_"..tostring(getgenv().floorToLeave) then
                    print(currentFloor)
                    TpGameId(87039211657390)
                end
            end)
        end
    end
end)

spawn(function()
while wait() do
pcall(function()
if game.PlaceId ~= 87039211657390 then
getgenv().join = false
textLabel.Text = "FARMING CASTLE"
end
end)
end
end)


local function Desbruh()
    while getgenv().AutoDestroy do
        task.wait(0.3)

        for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
            if enemy:IsA("Model") then
                local rootPart = enemy:FindFirstChild("HumanoidRootPart")
                local DestroyPrompt = rootPart and rootPart:FindFirstChild("DestroyPrompt")

                if DestroyPrompt then
                    DestroyPrompt:SetAttribute("MaxActivationDistance", 100000)
                    fireproximityprompt(DestroyPrompt)
                end
            end
        end
    end
end

local function AriseVerb()
    while getgenv().AutoArise do
        task.wait(0.3)

        for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
            if enemy:IsA("Model") then
                local rootPart = enemy:FindFirstChild("HumanoidRootPart")
                local arisePrompt = rootPart and rootPart:FindFirstChild("ArisePrompt")

                if arisePrompt then
                    arisePrompt:SetAttribute("MaxActivationDistance", 100000)
                    fireproximityprompt(arisePrompt)
                end
            end
        end
    end
end


if getgenv().AutoArise then
task.spawn(AriseVerb())
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Auto Castle | Arise Crossover",
    SubTitle = "By _toshun",
    TabWidth = 140,
    Size = UDim2.fromOffset(450, 350),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
	Main1 = Window:AddTab({ Title = "Farming", Icon = "" }),
	Main = Window:AddTab({ Title = "Castle", Icon = "" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Tabs.Main:AddToggle("AutoJoinCas", {
    Title = "Auto Join Castle When Spawns",
    Default = false,
    Callback = function(state)
        getgenv().join = state
    end
})

Tabs.Main:AddToggle("ModeSer", {
    Title = "Mode",
    Default = false,
    Description = "True = Start From Checkpoint / False = Start Over",
    Callback = function(state)
        getgenv().mode = state
    end
})


Tabs.Main:AddToggle("Countt", {
    Title = "Count",
    Default = false,
    Description = "Count Minutes Until Castle Spawns ",
    Callback = function(state)
        getgenv().count= state
    end
})
if game.PlaceId ~= 87039211657390 then
Tabs.Main:AddToggle("Castle", {
    Title = "Auto Farm Castle",
    Default = true,
    Callback = function(state)
        getgenv().autocastle= state
    end
})


local floorin = Tabs.Main:AddInput("Forleeee", {
    Title = "Leave On Floor",
    Default = tostring(getgenv().floorToLeave),
    Placeholder = "Floor",
    Numeric = true,
    Finished = true, 
    Callback = function(Value)
        speedValue = tonumber(Value) or 26
    end
})


Tabs.Main:AddToggle("AutOnFloor", {
    Title = "Auto Leave",
    Default = false,
    Callback = function(state)
        getgenv().leaveOnFloor = state
    end
})


end


--Useful Function



local function getNearestSelectedEnemy()
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

    local hrp = character.HumanoidRootPart
    local closest = nil
    local minDist = math.huge

    for _, v in pairs(workspace.__Main.__Enemies:GetChildren()) do
        local healthText = v:FindFirstChild("HealthBar") 
                            and v.HealthBar:FindFirstChild("Main") 
                            and v.HealthBar.Main:FindFirstChild("Bar") 
                            and v.HealthBar.Main.Bar:FindFirstChild("Amount")
        local root = v:FindFirstChild("HumanoidRootPart")

        if healthText and root and v:IsDescendantOf(workspace) and healthText.ContentText == getgenv().MobsSelects and healthText.ContentText ~= "0 HP" then
            local dist = (hrp.Position - root.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = {
                    instance = v,
                    name = v.Name,
                    rootPart = root,
                    healthText = healthText
                }
            end
        end
    end

    return closest
end




local function getNearestSelectedEnemy()
    local character = game.Players.LocalPlayer.Character
    if not character then return nil end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local enemiesFolder = workspace:WaitForChild("__Main"):WaitForChild("__Enemies"):WaitForChild("Client")
    local nearestEnemy = nil
    local shortestDistance = math.huge
    local playerPosition = hrp.Position

    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
            local healthBar = enemy:FindFirstChild("HealthBar")
            if healthBar and healthBar:FindFirstChild("Main") and healthBar.Main:FindFirstChild("Title") then
                local title = healthBar.Main.Title
                if title:IsA("TextLabel") and title.ContentText == getgenv().MobsSelects and not killedNPCs[enemy.Name] then
                    local enemyPosition = enemy.HumanoidRootPart.Position
                    local distance = (playerPosition - enemyPosition).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestEnemy = enemy
                      
                    end
                end
            end
        end
    end
    return nearestEnemy
end






--Main1 Tab

local SoloMobs = { "Soondo", "Gonshee", "Daek", "Longin", "Anders", "Largalan", "Vermillio" }
local NarutoMobs = { "Snake Man", "Blossom", "Black Crow", "Dor" }
local OnePieceMobs = { "Shark Man", "Eminel", "Light Admiral", "Mifalcon" }
local BleachMobs = { "Luryu", "Fyakuya", "Genji", "Murcielago" }
local CloverMobs = { "Sortudo", "Michille", "Wind", "Time King" }
local ChainsawMobs = { "Heaven", "Zere", "Ika" }
local JojoMobs = { "Diablo", "Golyne", "Gosuke", "Gucci" }
local DBMobs = { "Turtle", "Green", "Sky", "Freiza" }

local ZonesTable = {
    "Solo", "Naruto", "One Piece", "Bleach", 
    "Black Clover", "ChainsawMan", "Jojo", "Dragon Ball"
}

local ZoneDrop = Tabs.Main1:AddDropdown("ZoneDropdown", {
    Title = "Select Zone",
    Values = ZonesTable,
    Multi = false,
    Default = "",
})

local SelectMobs = Tabs.Main1:AddDropdown("MobsSelectDropdown", {
    Title = "Select Mobs",
    Values = {},
    Multi = true, -- Cho phép chọn nhiều
    Default = {},
})

local SizeDrop = Tabs.Main1:AddDropdown("SizeDropdown", {
    Title = "Select Size",
    Values = {"Small", "Big"},
    Multi = true, -- Cho phép chọn nhiều
    Default = {},
})

ZoneDrop:OnChanged(function(Value)
    getgenv().ZoneSelect = Value
    local MobsToDisplay = {}

    if Value == "Solo" then
        MobsToDisplay = SoloMobs
    elseif Value == "Naruto" then
        MobsToDisplay = NarutoMobs
    elseif Value == "One Piece" then
        MobsToDisplay = OnePieceMobs
    elseif Value == "Bleach" then
        MobsToDisplay = BleachMobs
    elseif Value == "Black Clover" then
        MobsToDisplay = CloverMobs
    elseif Value == "ChainsawMan" then
        MobsToDisplay = ChainsawMobs
    elseif Value == "Jojo" then
        MobsToDisplay = JojoMobs
    elseif Value == "Dragon Ball" then
        MobsToDisplay = DBMobs
    end

    SelectMobs:SetValues(MobsToDisplay)
end)

SelectMobs:OnChanged(function(Value)
    getgenv().MobsSelects = type(Value) == "table" and Value[1] or Value
    killedNPCs = {}
end)

SizeDrop:OnChanged(function(Value)
    getgenv().SizeSelector = type(Value) == "table" and Value[1] or Value
    killedNPCs = {}
end)




Tabs.Main1:AddToggle("AutoFarm", {
    Title = "Auto Farm Mobs Selected",
    Default = false,
    Callback = function(state)
    getgenv().AutoFarm = state
    end
})


--[[
spawn(function()
    while wait() do
        if getgenv().AutoFarm then
            local mobToFarm = getNearestSelectedEnemy()
            
            if mobToFarm then
                local rootPart = mobToFarm:FindFirstChild("HumanoidRootPart")
                local healthBar = mobToFarm:FindFirstChild("HealthBar")
                local healthText = healthBar and healthBar:FindFirstChild("Main") and healthBar.Main:FindFirstChild("Health")
                local title = healthBar and healthBar:FindFirstChild("Main") and healthBar.Main:FindFirstChild("Title")

                if rootPart and healthText and title and title.ContentText == getgenv().MobsSelects and healthText.ContentText ~= "0 HP" then
                    if getgenv().SizeSelector == 'Small' then
                        rootPart.Size = Vector3.new(2, 2, 1)
                        tp(rootPart.CFrame * CFrame.new(0, 0, 6))
                    elseif getgenv().SizeSelector == 'Big' then
                        rootPart.Size = Vector3.new(4, 4, 2)
                        tp(rootPart.CFrame * CFrame.new(0, 0, 8))
                    end

                    local args = {
                        {
                            { Event = "PunchAttack", Enemy = mobToFarm.Name },
                            "\4"
                        }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                end
            end
            task.wait(0.8)
        end
    end
end)
--]]

     
spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoFarm then
            local mob = getNearestSelectedEnemy()

            if mob and mob.Parent then
                local rootPart = mob:FindFirstChild("HumanoidRootPart")
                local healthBar = mob:FindFirstChild("HealthBar")
                local healthText = healthBar and healthBar:FindFirstChild("Main") and healthBar.Main:FindFirstChild("Health")
                local title = healthBar and healthBar:FindFirstChild("Main") and healthBar.Main:FindFirstChild("Title")

                local sizeFilter = getgenv().SizeSelector
                local expectedSize = (sizeFilter == "Small") and Vector3.new(2, 2, 1) or
                                     (sizeFilter == "Big") and Vector3.new(4, 4, 2)

                if rootPart and healthText and title and healthText.ContentText ~= "0 HP" then
                    if title.ContentText == getgenv().MobsSelects and rootPart.Size == expectedSize then
                        tp(rootPart.CFrame * CFrame.new(0, 0, 6))

                        local args = {
                            {
                                { Event = "PunchAttack", Enemy = mob.Name },
                                "\4"
                            }
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))

                        while mob and mob.Parent and healthText.ContentText ~= "0 HP" and getgenv().AutoFarm do
                            task.wait(0.1)
                        end
                    end
                end
            end
        end
    end
end)



Tabs.Main1:AddToggle("ari", {
    Title = "Auto Arise",
    Default = false,
    Callback = function(state)
    getgenv().AutoArise = state
        
    end
})

spawn(function()
while wait() do
if getgenv().AutoArise then
AriseVerb()
end
end
end)



Tabs.Main1:AddToggle("des", {
    Title = "Auto Destroy",
    Default = false,
    Callback = function(state)
        getgenv().AutoDestroy = state
        
    end
})

spawn(function()
while wait() do
if getgenv().AutoDestroy then
Desbruh()
end
end
end)


local SpeedInput = Tabs.Settings:AddInput("Speedinput", {
    Title = "Tween Speed",
    Default = tostring(getgenv().speed),
    Placeholder = "Tween Speed",
    Numeric = true,
    Finished = true, 
    Callback = function(Value)
        speedValue = tonumber(Value) or 140
    end
})



thongbao("AUTO CASTLE LOADED", "Credit to me!", 5)


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("UnnamedHub")
SaveManager:SetFolder("UnnamedHub/AriseCrossover")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)


SaveManager:LoadAutoloadConfig()

repeat task.wait(0.25) until game:IsLoaded();
getgenv().Image = "rbxassetid://130997882132914";
getgenv().ToggleUI = "LeftControl"

task.spawn(function()
    if not getgenv().LoadedMobileUI == true then getgenv().LoadedMobileUI = true
        local OpenUI = Instance.new("ScreenGui");
        local ImageButton = Instance.new("ImageButton");
        local UICorner = Instance.new("UICorner");
        OpenUI.Name = "OpenUI";
        OpenUI.Parent = game:GetService("CoreGui");
        OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        ImageButton.Parent = OpenUI;
        ImageButton.BackgroundColor3 = Color3.fromRGB(105,105,105);
        ImageButton.BackgroundTransparency = 0.8
        ImageButton.Position = UDim2.new(0.9,0,0.1,0);
        ImageButton.Size = UDim2.new(0,50,0,50);
        ImageButton.Image = getgenv().Image;
        ImageButton.Draggable = true;
        ImageButton.Transparency = 1;
        UICorner.CornerRadius = UDim.new(0,200);
        UICorner.Parent = ImageButton;
        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true,getgenv().ToggleUI,false,game);
        end)
    end
end)