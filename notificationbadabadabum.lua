local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NotificationUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "NotificationFrame"
frame.Parent = screenGui
frame.Size = UDim2.new(0.3, 0, 0.2, 0)
frame.Position = UDim2.new(0.35, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = frame
titleLabel.Size = UDim2.new(1, -10, 0.3, -10)
titleLabel.Position = UDim2.new(0, 5, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = ""
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

local contentLabel = Instance.new("TextLabel")
contentLabel.Name = "ContentLabel"
contentLabel.Parent = frame
contentLabel.Size = UDim2.new(1, -10, 0.4, -10)
contentLabel.Position = UDim2.new(0, 5, 0.3, 0)
contentLabel.BackgroundTransparency = 1
contentLabel.Text = ""
contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
contentLabel.TextScaled = true
contentLabel.Font = Enum.Font.Gotham

local button1 = Instance.new("TextButton")
button1.Name = "Button1"
button1.Parent = frame
button1.Size = UDim2.new(0.45, -5, 0.2, -5)
button1.Position = UDim2.new(0.05, 0, 0.75, 0)
button1.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
button1.TextColor3 = Color3.fromRGB(255, 255, 255)
button1.TextScaled = true
button1.Font = Enum.Font.GothamBold
button1.Visible = false

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(0.1, 0)
corner1.Parent = button1


local button2 = Instance.new("TextButton")
button2.Name = "Button2"
button2.Parent = frame
button2.Size = UDim2.new(0.45, -5, 0.2, -5)
button2.Position = UDim2.new(0.5, 5, 0.75, 0)
button2.BackgroundColor3 = Color3.fromRGB(250, 100, 100)
button2.TextColor3 = Color3.fromRGB(255, 255, 255)
button2.TextScaled = true
button2.Font = Enum.Font.GothamBold
button2.Visible = false

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0.1, 0)
corner2.Parent = button2

frame.Visible = false

local button1Connection
local button2Connection

local function thongbao(title, content, duration, button1Text, button2Text, button1Func, button2Func)
    titleLabel.Text = title
    contentLabel.Text = content

   
    if button1Connection then
        button1Connection:Disconnect()
    end
    if button2Connection then
        button2Connection:Disconnect()
    end

    
    if button1Text and button1Func then
        button1.Text = button1Text
        button1.Visible = true
        button1Connection = button1.MouseButton1Click:Connect(function()
            button1Func()
            frame.Visible = false
        end)
    else
        button1.Visible = false
    end

    
    if button2Text and button2Func then
        button2.Text = button2Text
        button2.Visible = true
        button2Connection = button2.MouseButton1Click:Connect(function()
            button2Func()
            frame.Visible = false
        end)
    else
        button2.Visible = false
    end

    frame.Visible = true
    frame:TweenSize(UDim2.new(0.3, 0, 0.2, 0), "Out", "Sine", 0.5, true)

    
    task.delay(duration, function()
        if frame.Visible then
            frame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Sine", 0.5, true, function()
                frame.Visible = false
            end)
        end
    end)
end

--[[
thongbao(
    "Bada Badabum",
    "Hello",
    5,
    "Yes",
    "No",
    function()
        print("Yes button clicked")
    end,
    function()
        print("No button clicked")
    end
)

--]]
