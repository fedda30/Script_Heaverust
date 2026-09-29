local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Создать окно UI
local Window = Library.CreateLib("AdolfClient ^_^ V1.8", "DarkTheme")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WT"
screenGui.Parent = game:GetService("CoreGui")
--Квадрат
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0
frame.AnchorPoint = Vector2.new(1, 0)
frame.Position = UDim2.new(1, -10, 0, 10)
frame.Size = UDim2.new(0, 230, 0, 30) 
--Ушлы
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 0)
corner.Parent = frame
--Текст
local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.Code
label.TextSize = 12
label.TextXAlignment = Enum.TextXAlignment.Center
--Хз
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
RunService.RenderStepped:Connect(function(deltaTime)
    local fps = math.floor(1 / deltaTime)
    label.Text = string.format("AdolfClient^_^|%s|FPS %d", player.Name, fps)
end)

-- Секция
local Tab = Window:NewTab("Aim")
local LAim = false

local UserInputService = game:GetService("UserInputService")
local LAim = false -- Состояние тумблера в меню
local IsRmbPressed = false -- Состояние нажатой кнопки мыши
local Section = Tab:NewSection("Aim")
-- Переключетель
Section:NewToggle("LegitAimbot", "Включить автоматическую наводку на людей", function(state)
    LAim = state
    print("Aimbot status: ", LAim)
end)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        IsRmbPressed = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        IsRmbPressed = false
    end
end)

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local FOV_RADIUS = 150

local function isInsideFOV(targetPosition)
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPosition)
    if onScreen then
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        return mouseDist <= FOV_RADIUS
    end
    return false
end

local function getTarget()
    local closestDist = math.huge
    local target = nil
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = v.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local part = v.Character.HumanoidRootPart
                if isInsideFOV(part.Position) then
                    local dist = (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        target = part
                    end
                end
            end
        end
    end
    return target
end
RunService.RenderStepped:Connect(function()
    if LAim and IsRmbPressed then 
        local target = getTarget()
        if target then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        end
    end
end)
local Section = Tab:NewSection("Hitbox")
Section:NewToggle("HitboxExpander", "Увеличевает хитбокс игрока что делает попадание максимально легким", function(state)
    if state then
        _G.HitboxEnabled = true 
local targetSize = Vector3.new(15,15,15)
local defaultSize = Vector3.new(2, 2, 1) 

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            pcall(function()
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    if _G.HitboxEnabled then
                        hrp.Size = targetSize
                        hrp.Transparency = 0.7
                        hrp.CanCollide = false
                    else
                        hrp.Size = defaultSize
                        hrp.Transparency = 1 
                        hrp.CanCollide = false 
                    end
                end
            end)
        end
    end
end)
    else
        _G.HitboxEnabled = false
local targetSize = Vector3.new(15, 15, 15)
local defaultSize = Vector3.new(2, 2, 1) 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            pcall(function()
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if _G.HitboxEnabled then
                        hrp.Size = targetSize
                        hrp.Transparency = 0.7
                        hrp.CanCollide = false
                    else
                        hrp.Size = defaultSize
                        hrp.Transparency = 1 
                        hrp.CanCollide = false 
                    end
                end
            end)
        end
    end
end)
    end
end) 

-- Секция
local Tab = Window:NewTab("Visuals")

--Подсекция
local Section = Tab:NewSection("FOVChanger")

local targetFOV = 70
local camera = workspace.CurrentCamera

game:GetService("RunService").RenderStepped:Connect(function()
    if camera.FieldOfView ~= targetFOV then
        camera.FieldOfView = targetFOV
    end
end)

--Слайдер
Section:NewSlider("FOVChanger", "Меняет угол обзора вашей камеры по дефолту значение 70", 120, 1, function(s) 
    targetFOV = s
end)

-- Кнопка
Section:NewButton("ResetFOV", "Возвращение ФОВа к исходному значению", function()
    targetFOV = 70
end)

--Подсекция
local Section = Tab:NewSection("FullBright")

local FullBrightEnabled = false

-- Переключатель
Section:NewToggle("FullBright", "????", function(state)
    FullBrightEnabled = state
    if state then
        while FullBrightEnabled do
            game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        task.wait(0.001)
        end
    else
        game.Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end
end)

-- Подсекция
local Section = Tab:NewSection("ESP")

local ESPBoxEnabled = false
local ESPBoxLoop = nil

-- Переключатель
Section:NewToggle("ESPBox", "Делает белые боксы на людей", function(state)
    if state then
        ESPBoxEnabled = true
        ESPBoxLoop = task.spawn(function()
            while wait(0.5) do
                for _, childrik in ipairs(workspace:GetDescendants()) do
                    if childrik:FindFirstChild("Humanoid") and childrik ~= game.Players.LocalPlayer.Character then
                        if not childrik:FindFirstChild("Box") then
                            local esp = Instance.new("BoxHandleAdornment", childrik)
                            esp.Adornee = childrik
                            esp.ZIndex = 0
                            esp.Size = Vector3.new(4, 0.019999999552965164, 0.1)
                            esp.Transparency = 0
                            esp.Color3 = Color3.fromRGB(255, 255, 255)
                            esp.CFrame = CFrame.new(0, 2.6, 0)
                            esp.AlwaysOnTop = true
                            esp.Name = "Box"
                            local esp2 = Instance.new("BoxHandleAdornment", childrik)
                            esp2.Adornee = childrik
                            esp2.ZIndex = 0
                            esp2.Size = Vector3.new(0.019999999552965164, 5.199999809265137, 0.1)
                            esp2.Transparency = 0
                            esp2.Color3 = Color3.fromRGB(255, 255, 255)
                            esp2.CFrame = CFrame.new(-2, 0.009999999776482582, 0)
                            esp2.AlwaysOnTop = true
                            esp2.Name = "Box"
                            local esp3 = Instance.new("BoxHandleAdornment", childrik)
                            esp3.Adornee = childrik
                            esp3.ZIndex = 0
                            esp3.Size = Vector3.new(4, 0.019999999552965164, 0.1)
                            esp3.Transparency = 0
                            esp3.Color3 = Color3.fromRGB(255, 255, 255)
                            esp3.CFrame = CFrame.new(0, -2.6, 0)
                            esp3.AlwaysOnTop = true
                            esp3.Name = "Box"
                            local esp4 = Instance.new("BoxHandleAdornment", childrik)
                            esp4.Adornee = childrik
                            esp4.ZIndex = 0
                            esp4.Size = Vector3.new(0.019999999552965164, 5.199999809265137, 0.1)
                            esp4.Transparency = 0
                            esp4.Color3 = Color3.fromRGB(255, 255, 255)
                            esp4.CFrame = CFrame.new(2, 0.009999999776482582, 0)
                            esp4.AlwaysOnTop = true
                            esp4.Name = "Box"
                        end
                     end
                end
                 task.wait()
            end
        end)
    else
        ESPBoxEnabled = false
        if ESPBoxLoop then
            task.cancel(ESPBoxLoop)
            HESPLoop = nil
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Box" then
                obj:Destroy()
            end
        end
    end
end)

--Подсекция
local Section = Tab:NewSection("Chams")

local ChamsLoop = nil
local ChamsEnabled = false

--Переключатель
Section:NewToggle("Chams", "Если тип за стеной то чамс красный а если нет то зеленый", function(state)
    if state then
        getgenv().ChamsEnabled = true
        task.spawn(function()
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local player = Players.LocalPlayer
            local camera = workspace.CurrentCamera
            local fovDegrees = 120
            local threshold = math.cos(math.rad(fovDegrees / 2))
            while getgenv().ChamsEnabled and task.wait(0.5) do
                for i, childrik in ipairs(workspace:GetDescendants()) do
                    if childrik:FindFirstChild("Humanoid") and childrik ~= player.Character and not childrik:FindFirstChild("ChamsMarker") then
                        local marker = Instance.new("BoolValue", childrik)
                        marker.Name = "ChamsMarker"
                        local esp = Instance.new("BoxHandleAdornment", childrik); esp.Name = "ChamsPart"; esp.Adornee = childrik; esp.AlwaysOnTop = true; esp.ZIndex = 0; esp.Size = Vector3.new(1, 2.3, 1); esp.Transparency = 0.65; esp.Color3 = Color3.fromRGB(255, 48, 48); esp.CFrame = CFrame.new(-1.5, 0, 0.2); esp.Visible = false
                        local esp1 = Instance.new("BoxHandleAdornment", childrik); esp1.Name = "ChamsPart"; esp1.Adornee = childrik; esp1.AlwaysOnTop = true; esp1.ZIndex = 0; esp1.Size = Vector3.new(1, 2.3, 1); esp1.Transparency = 0.65; esp1.Color3 = Color3.fromRGB(255, 48, 48); esp1.CFrame = CFrame.new(1.5, 0, 0.2); esp1.Visible = false
                        local esp2 = Instance.new("BoxHandleAdornment", childrik); esp2.Name = "ChamsPart"; esp2.Adornee = childrik; esp2.AlwaysOnTop = true; esp2.ZIndex = 0; esp2.Size = Vector3.new(1.7, 2, 1); esp2.Transparency = 0.65; esp2.Color3 = Color3.fromRGB(255, 48, 48); esp2.CFrame = CFrame.new(0, 0.2, 0.2); esp2.Visible = false
                        local esp3 = Instance.new("BoxHandleAdornment", childrik); esp3.Name = "ChamsPart"; esp3.Adornee = childrik; esp3.AlwaysOnTop = true; esp3.ZIndex = 0; esp3.Size = Vector3.new(0.8, 2, 1); esp3.Transparency = 0.65; esp3.Color3 = Color3.fromRGB(255, 48, 48); esp3.CFrame = CFrame.new(-0.4, -1.84, 0.2); esp3.Visible = false
                        local esp4 = Instance.new("BoxHandleAdornment", childrik); esp4.Name = "ChamsPart"; esp4.Adornee = childrik; esp4.AlwaysOnTop = true; esp4.ZIndex = 0; esp4.Size = Vector3.new(0.8, 2, 1); esp4.Transparency = 0.65; esp4.Color3 = Color3.fromRGB(255, 48, 48); esp4.CFrame = CFrame.new(0.4, -1.84, 0.2); esp4.Visible = false
                        local esp5 = Instance.new("BoxHandleAdornment", childrik); esp5.Name = "ChamsPart"; esp5.Adornee = childrik; esp5.AlwaysOnTop = true; esp5.ZIndex = 0; esp5.Size = Vector3.new(1.2, 1.2, 1); esp5.Transparency = 0.65; esp5.Color3 = Color3.fromRGB(255, 48, 48); esp5.CFrame = CFrame.new(0.048, 1.8, 0.2); esp5.Visible = false
                        local esp6 = Instance.new("BoxHandleAdornment", childrik); esp6.Name = "ChamsPart"; esp6.Adornee = childrik; esp6.AlwaysOnTop = true; esp6.ZIndex = 0; esp6.Size = Vector3.new(1, 2.3, 1); esp6.Transparency = 0.65; esp6.Color3 = Color3.fromRGB(0, 255, 0); esp6.CFrame = CFrame.new(-1.5, 0, 0.2); esp6.Visible = false
                        local esp7 = Instance.new("BoxHandleAdornment", childrik); esp7.Name = "ChamsPart"; esp7.Adornee = childrik; esp7.AlwaysOnTop = true; esp7.ZIndex = 0; esp7.Size = Vector3.new(1, 2.3, 1); esp7.Transparency = 0.65; esp7.Color3 = Color3.fromRGB(0, 255, 0); esp7.CFrame = CFrame.new(1.5, 0, 0.2); esp7.Visible = false
                        local esp8 = Instance.new("BoxHandleAdornment", childrik); esp8.Name = "ChamsPart"; esp8.Adornee = childrik; esp8.AlwaysOnTop = true; esp8.ZIndex = 0; esp8.Size = Vector3.new(1.7, 2, 1); esp8.Transparency = 0.65; esp8.Color3 = Color3.fromRGB(0, 255, 0); esp8.CFrame = CFrame.new(0, 0.2, 0.2); esp8.Visible = false
                        local esp9 = Instance.new("BoxHandleAdornment", childrik); esp9.Name = "ChamsPart"; esp9.Adornee = childrik; esp9.AlwaysOnTop = true; esp9.ZIndex = 0; esp9.Size = Vector3.new(0.8, 2, 1); esp9.Transparency = 0.65; esp9.Color3 = Color3.fromRGB(0, 255, 0); esp9.CFrame = CFrame.new(-0.4, -1.84, 0.2); esp9.Visible = false
                        local esp10 = Instance.new("BoxHandleAdornment", childrik); esp10.Name = "ChamsPart"; esp10.AlwaysOnTop = true; esp10.ZIndex = 0; esp10.Size = Vector3.new(0.8, 2, 1); esp10.Transparency = 0.65; esp10.Color3 = Color3.fromRGB(0, 255, 0); esp10.CFrame = CFrame.new(0.4, -1.84, 0.2); esp10.Visible = false
                        local esp11 = Instance.new("BoxHandleAdornment", childrik); esp11.Name = "ChamsPart"; esp11.AlwaysOnTop = true; esp11.ZIndex = 0; esp11.Size = Vector3.new(1.2, 1.2, 1); esp11.Transparency = 0.65; esp11.Color3 = Color3.fromRGB(0, 255, 0); esp11.CFrame = CFrame.new(0.048, 1.8, 0.2); esp11.Visible = false
                        RunService.RenderStepped:Connect(function()
                            if getgenv().ChamsEnabled and childrik and childrik.Parent and childrik:FindFirstChild("HumanoidRootPart") then
                                local camPos = camera.CFrame.Position
                                local targetPos = childrik.HumanoidRootPart.Position
                                local direction = targetPos - camPos
                                local inFov = camera.CFrame.LookVector:Dot(direction.Unit) > threshold
                                local rayParams = RaycastParams.new()
                                rayParams.FilterDescendantsInstances = {player.Character, childrik}
                                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                local rayResult = workspace:Raycast(camPos, direction, rayParams)
                                local isBlocked = rayResult ~= nil
                                local showGreen = inFov and not isBlocked
                                local showRed = inFov and isBlocked
                                esp.Visible = showRed; esp1.Visible = showRed; esp2.Visible = showRed; esp3.Visible = showRed; esp4.Visible = showRed; esp5.Visible = showRed
                                esp6.Visible = showGreen; esp7.Visible = showGreen; esp8.Visible = showGreen; esp9.Visible = showGreen; esp10.Visible = showGreen; esp11.Visible = showGreen
                            else
                                esp.Visible = false; esp1.Visible = false; esp2.Visible = false; esp3.Visible = false; esp4.Visible = false; esp5.Visible = false
                                esp6.Visible = false; esp7.Visible = false; esp8.Visible = false; esp9.Visible = false; esp10.Visible = false; esp11.Visible = false
                            end
                        end)
                    end
                end
            end
        end)
    else
        getgenv().ChamsEnabled = false
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "ChamsPart" or obj.Name == "ChamsMarker" then
                obj:Destroy()
            end
        end
    end
end)

--Подсекция
local Section = Tab:NewSection("SkeletonESP")

local SESPLoop = nil
local SESPnabled = false


-- Переключатель
Section:NewToggle("SkeletonESP", "Рисует есп нна ноги руки и тело человека ", function(state)
    if state then
        SESPnabled = true
        SESPLoop = task.spawn(function()
            while SESPnabled do
                for i, childrik in ipairs(workspace:GetDescendants()) do
                    if childrik:FindFirstChild("HumanoidRootPart") and childrik ~= game.Players.LocalPlayer.Character then
                        if not childrik:FindFirstChild("SESP", true) then
                            local ut = childrik:FindFirstChild("UpperTorso")
                            local ll = childrik:FindFirstChild("LeftUpperLeg")
                            local rl = childrik:FindFirstChild("RightUpperLeg")
                            local la = childrik:FindFirstChild("LeftUpperArm")
                            local ra = childrik:FindFirstChild("RightUpperArm")
                            if ut and ll and rl and la and ra then
                                local esp = Instance.new("CylinderHandleAdornment", ut)
                                esp.Adornee = ut
                                esp.ZIndex = 0
                                esp.Radius = 0.05
                                esp.Transparency = 0
                                esp.Height = 2
                                esp.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), 0, 0)
                                esp.Color3 = Color3.fromRGB(255, 255, 255)
                                esp.AlwaysOnTop = true
                                esp.Name = "SESP"
                                local esp2 = Instance.new("CylinderHandleAdornment", ll)
                                esp2.Adornee = ll
                                esp2.ZIndex = 0
                                esp2.Radius = 0.05
                                esp2.Transparency = 0
                                esp2.Height = 2
                                esp2.CFrame = CFrame.new(0, -0.3, 0) * CFrame.Angles(math.rad(80), math.rad(-20), 0)
                                esp2.Color3 = Color3.fromRGB(255, 255, 255)
                                esp2.AlwaysOnTop = true
                                esp2.Name = "SESP"
                                local esp3 = Instance.new("CylinderHandleAdornment", rl)
                                esp3.Adornee = rl
                                esp3.ZIndex = 0
                                esp3.Radius = 0.05
                                esp3.Transparency = 0
                                esp3.Height = 2
                                esp3.CFrame = CFrame.new(0, -0.3, 0) * CFrame.Angles(math.rad(80), math.rad(20), 0)
                                esp3.Color3 = Color3.fromRGB(255, 255, 255)
                                esp3.AlwaysOnTop = true
                                esp3.Name = "SESP"
                                local esp4 = Instance.new("CylinderHandleAdornment", ut)
                                esp4.Adornee = ut
                                esp4.ZIndex = 0
                                esp4.Radius = 0.05
                                esp4.Transparency = 0
                                esp4.Height = 2
                                esp4.CFrame = CFrame.new(0, 0.8, 0) * CFrame.Angles(0, math.rad(90), 0)
                                esp4.Color3 = Color3.fromRGB(255, 255, 255)
                                esp4.AlwaysOnTop = true
                                esp4.Name = "SESP"
                                local esp5 = Instance.new("CylinderHandleAdornment", la)
                                esp5.Adornee = la
                                esp5.ZIndex = 0
                                esp5.Radius = 0.05
                                esp5.Transparency = 0
                                esp5.Height = 2
                                esp5.CFrame = CFrame.new(0, -0.4, 0) * CFrame.Angles(math.rad(90), math.rad(-10), 0)
                                esp5.Color3 = Color3.fromRGB(255, 255, 255)
                                esp5.AlwaysOnTop = true
                                esp5.Name = "SESP"
                                local esp6 = Instance.new("CylinderHandleAdornment", ra)
                                esp6.Adornee = ra
                                esp6.ZIndex = 0
                                esp6.Radius = 0.05
                                esp6.Transparency = 0
                                esp6.Height = 2
                                esp6.CFrame = CFrame.new(0, -0.4, 0) * CFrame.Angles(math.rad(90), math.rad(10), 0)
                                esp6.Color3 = Color3.fromRGB(255, 255, 255)
                                esp6.AlwaysOnTop = true
                                esp6.Name = "SESP"
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)                 
    else
        SESPnabled = false
        if SESPLoop then
            task.cancel(SESPLoop)
            SESPLoop = nil
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "SESP" then
                obj:Destroy()
            end
        end
    end
end)

--Подсекция
local Section = Tab:NewSection("HightLight")

local HESPLoop = nil
local HESPEnabled = false

-- Переключатель
local HESPLoop = nil
local HESPEnabled = false

Section:NewToggle("HightLight", "Подсвечивает именно хитбокс игроков", function(state)
    if state then
        HESPEnabled = true
        HESPLoop = task.spawn(function()
            while HESPEnabled do
                for _, childrik in ipairs(workspace:GetDescendants()) do
                    if childrik:FindFirstChild("Humanoid") and childrik ~= game.Players.LocalPlayer.Character then
                        if not childrik:FindFirstChild("hesp") then
                            local HEsp = Instance.new("Highlight", childrik)
                            HEsp.Name = "hesp"
                            HEsp.Adornee = childrik
                            HEsp.FillColor = Color3.fromRGB(0, 255, 0)
                        end
                    end
                end
                task.wait()
            end
        end)
    else
        HESPEnabled = false
        if HESPLoop then
            task.cancel(HESPLoop)
            HESPLoop = nil
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "hesp" then
                obj:Destroy()
            end
        end
    end
end)

-- Секция
local Tab = Window:NewTab("Anti-Aim")

--Подсекция
local Section = Tab:NewSection("YawPitch")

 Section:NewSlider("YawPitch", "Заставляет смотреть перса в пол или вверх", 180, -180, function(s)
    _G.LeanAngle = math.rad(s)
end)


local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

RunService.Stepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("UpperTorso") then
        local waist = char.UpperTorso:FindFirstChild("Waist")
        if waist and _G.LeanAngle then
            waist.C0 = CFrame.new(0, 0.85, 0) * CFrame.Angles(_G.LeanAngle, 0, 0)
        end
    end
end)

--Подсекция
local Section = Tab:NewSection("Pitch")
local Pitch = false

-- Переключатель
Section:NewToggle("Pitch", "Заставляет ходить вашего перса спиной(Визуал)", function(state)
    Pitch = state
    if state then
        task.spawn(function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        rootPart.Rotation = rootPart.Rotation + Vector3.new(0, 180, 0)
    end)
    else
        print("Toggle Off")
    end
end)

--Подсекция
local Section = Tab:NewSection("SpinBot")
local spinbotEnabled = false

--Переключатель
Section:NewToggle("Spinbot", "Крутит вашего персонажа", function(state)
    spinbotEnabled = state

    if state then
        workspace.Maksimsnys228.Humanoid.AutoRotate = false
        task.spawn(function() 
            local Char = workspace.Maksimsnys228:FindFirstChild("HumanoidRootPart")
            local speed = 0.9
            
            while spinbotEnabled do 
                if Char then
                    Char.CFrame = Char.CFrame * CFrame.Angles(0, speed, 0)
                end
                task.wait(0.1) 
            end
        end)
    else
    workspace.Maksimsnys228.Humanoid.AutoRotate = true
    end
end)

-- Секция
local Tab = Window:NewTab("Movement")
--Подсекция
local Section = Tab:NewSection("BunnyHop")
local BunnyHopEnabled = false
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer
local DashSpeed = 200
UIS.InputBegan:Connect(function(input, processed)
    if processed or not BunnyHopEnabled then return end   
    
    if input.KeyCode == Enum.KeyCode.Space then
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            local Root = Character.HumanoidRootPart
            Root.AssemblyLinearVelocity = Camera.CFrame.LookVector * DashSpeed
        end
    end
end)
Section:NewToggle("BunnyHop", "Рывок при прыжке по направлению камеры", function(state)
    BunnyHopEnabled = state
end)

local Section = Tab:NewSection("Speed")

-- Слайдер
Section:NewSlider("WalkSpeed", "Меняет скорость ходьбы вашего персонажа", 260, 16, function(s) 
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)
local Section = Tab:NewSection("Jump")
-- Слайдер
Section:NewSlider("JumpHeight", "Изменение высоты прыжка", 300, 50, function(s) 
    game.Players.LocalPlayer.Character.Humanoid.JumpPower= s
end)

-- Секция
local Tab = Window:NewTab("Misc")
-- Подсекция
local Section = Tab:NewSection("GUI")
    Section:NewKeybind("Togle on/off UI", "Включает или выключает гуи по вашему бинду", Enum.KeyCode.RightShift, function()
        Library:ToggleUI()
    end)
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local MouseLockEnabled = false

RunService.RenderStepped:Connect(function()
    if MouseLockEnabled then
        player.CameraMode = Enum.CameraMode.Classic 
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local MouseLockEnabled = false
RunService.RenderStepped:Connect(function()
    if MouseLockEnabled then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            local Root = Character.HumanoidRootPart
            local Camera = workspace.CurrentCamera
            local Look = Camera.CFrame.LookVector
            Root.CFrame = CFrame.new(Root.Position, Root.Position + Vector3.new(Look.X, 0, Look.Z))
        end
    end
end)

Section:NewToggle("Thord Person", "3-е лицо", function(state)
    MouseLockEnabled = state
    
    if state then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        LocalPlayer.CameraMaxZoomDistance = 0.5
        LocalPlayer.CameraMinZoomDistance = 0.5
        task.wait(0.1)
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = 400
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
end)
