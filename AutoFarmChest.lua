-- [Notify Bada Badabum]
local thongbao = loadstring(game:HttpGet('https://raw.githubusercontent.com/Xzerne/Emkhiencontimanhdapbadabadabum/refs/heads/main/Utils/notificationbadabadabum.lua'))()
local ServerHopAPI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Xzerne/Emkhiencontimanhdapbadabadabum/refs/heads/main/Modules/HopServer.lua'))()

if not game:IsLoaded() then
	thongbao('Bada Badabum', 'Loading Please Wait...', 2)
end;


function topos(Pos)
    if not Pos or not Pos.Position then
        warn("Invalid Position object!")
        return
    end

    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        warn("Player or HumanoidRootPart not found!")
        return
    end

    local humanoidRootPart = player.Character.HumanoidRootPart
    local distance = (Pos.Position - humanoidRootPart.Position).Magnitude


    local speedConfig = {
        {limit = 25, speed = 5000},
        {limit = 50, speed = 2000},
        {limit = 150, speed = 800},
        {limit = 250, speed = 600},
        {limit = 500, speed = 300},
        {limit = 750, speed = 250},
        {limit = math.huge, speed = getgenv().TweenSpeed or 250},
    }

    local speed = nil
    for _, config in ipairs(speedConfig) do
        if distance < config.limit then
            speed = config.speed
            break
        end
    end

    if not speed then
        warn("Speed configuration failed")
        return
    end

    
    local tweenTime = distance / speed

    
    local tween = game:GetService("TweenService"):Create(
        humanoidRootPart,
        TweenInfo.new(tweenTime, Enum.EasingStyle.Linear),
        {CFrame = Pos}
    )
    tween:Play()
end

spawn(function()
    while task.wait() do
        if getgenv().AutoFarmChest and getgenv().Tween then
            pcall(function()
                if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("God's Chalice") or not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Fist of Darkness") then
                    local foundChest = false
                    pcall(function()
                        for i, v in pairs(game:GetService("Workspace").ChestModels:GetChildren()) do
                            if v.Name == "SilverChest" or v.Name == "GoldChest" or v.Name == "DiamondChest" or v.Name == "FragmentChest" or v.Name == "MirageChest" then
                                foundChest = true
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.PushBox.CFrame
                                wait(0.15)
                            end
                        end

                        if not foundChest then
                            if getgenv().Hop then
                                thongbao("Bada Badabum", 'No Chests Found.Hopping Please Wait...')
                                ServerHopAPI:Teleport(game.PlaceId, Singapore)
                            else
                                thongbao(
    "Bada Badabum",
    "Wanna Hop Server?",
    10,
    "OK Bro",
    "No Shit",
    function()
        ServerHopAPI:Teleport(game.PlaceId, Singapore)
    end,
    function()
        warn('ok')
    end
)
                            end
                        end

                        for i, v in pairs(game.Workspace.ChestModels:GetDescendants()) do
                            if v:IsA("TouchTransmitter") then
                                wait(0.15)
                                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                                wait(0.15)
                                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                            end
                        end
                    end)
                end
            end)
        end
        ::continue::
    end
end)




spawn(function()
    while task.wait() do
        if getgenv().AutoFarmChest and not getgenv().Tween then
            pcall(function()
                if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("God's Chalice") or not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Fist of Darkness") then
                    local foundChest = false
                    pcall(function()
                        for i, v in pairs(game:GetService("Workspace").ChestModels:GetChildren()) do
                            if v.Name == "SilverChest" or v.Name == "GoldChest" or v.Name == "DiamondChest" or v.Name == "FragmentChest" or v.Name == "MirageChest" then
                                foundChest = true
                                topos(v.PushBox.CFrame)
                                wait(0.15)
                            end
                        end

                        if not foundChest then
                            if getgenv().Hop then
                                thongbao("Bada Badabum", 'No Chests Found.Hopping Please Wait...')
                                ServerHopAPI:Teleport(game.PlaceId, Singapore)
                            else
                                thongbao(
    "Bada Badabum",
    "Wanna Hop Server?",
    10,
    "OK Bro",
    "No Shit",
    function()
        ServerHopAPI:Teleport(game.PlaceId, Singapore)
    end,
    function()
        warn('ok')
    end
)
                            end
                        end

                        for i, v in pairs(game.Workspace.ChestModels:GetDescendants()) do
                            if v:IsA("TouchTransmitter") then
                                wait(0.15)
                                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                                wait(0.15)
                                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                            end
                        end
                    end)
                end
            end)
        end
        ::continue::
    end
end)


--[[
getgenv().TweenSpeed = 350
getgenv().Tween = false
getgenv().Hop = true
getgenv().FarmChest = true
--]]