-- ==========================================
-- ЧАСТЬ 1: СИСТЕМА СОХРАНЕНИЯ И КАРКАС GUI
-- ==========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local uiToggleBind = Enum.KeyCode.Insert 

-- Настройки по умолчанию
_G.MacroEnabled = false
_G.MacroBind = Enum.KeyCode.E
_G.IsBinding = false
_G.UseHoldMode = true
_G.MacroDelay = 0.01 
_G.TargetAngleDegrees = 60
_G.IsHolding = false

local comEnabled = false
local character
local root
local axisModel

-- ФУНКЦИИ АВТОСОХРАНЕНИЯ
local fileName = "MacroSettings_v9.json"

local function saveSettings()
    pcall(function()
        if writefile then
            local data = {
                Bind = _G.MacroBind.Name,
                UseHoldMode = _G.UseHoldMode,
                MacroDelay = _G.MacroDelay,
                TargetAngleDegrees = _G.TargetAngleDegrees
            }
            writefile(fileName, HttpService:JSONEncode(data))
        end
    end)
end

local function loadSettings()
    pcall(function()
        if readfile and isfile and isfile(fileName) then
            local data = HttpService:JSONDecode(readfile(fileName))
            if data then
                if data.Bind then _G.MacroBind = Enum.KeyCode[data.Bind] end
                if data.UseHoldMode ~= nil then _G.UseHoldMode = data.UseHoldMode end
                if data.MacroDelay then _G.MacroDelay = data.MacroDelay end
                if data.TargetAngleDegrees then _G.TargetAngleDegrees = data.TargetAngleDegrees end
            end
        end
    end)
end

loadSettings()

-- Автоопределение сенсы
local currentSensitivity = 1.0
pcall(function()
    currentSensitivity = UserSettings():GetService("UserGameSettings").MouseSensitivity
end)

-- Создание ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MacroTool_V9_LeftRight"
ScreenGui.ResetOnSpawn = false 

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui") end

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 290)
Frame.Position = UDim2.new(0, 50, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Macro v9 (Sense: " .. string.format("%.2f", currentSensitivity) .. ")"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == uiToggleBind then
        Frame.Visible = not Frame.Visible
    end
end)
-- ==========================================
-- ЧАСТЬ 2: КНОПКИ, ПОЛЯ ВВОДА И ТРИГГЕРЫ СОХРАНЕНИЯ
-- ==========================================

-- Вспомогательная функция для быстрого создания кнопок интерфейса
local function createMenuButton(text, posIndex, bgColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 28)
    btn.Position = UDim2.new(0, 20, 0, 45 + (posIndex - 1) * 33)
    btn.BackgroundColor3 = bgColor
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = Frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

-- Вспомогательная функция для быстрого создания полей ввода текста (TextBox)
local function createMenuTextBox(text, posIndex, bgColor)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 180, 0, 28)
    box.Position = UDim2.new(0, 20, 0, 45 + (posIndex - 1) * 33)
    box.BackgroundColor3 = bgColor
    box.Text = text
    box.TextColor3 = Color3.fromRGB(220, 220, 220)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 13
    box.ClearTextOnFocus = true
    box.Parent = Frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box
    
    return box
end

-- Создаем элементы с учетом загруженных настроек
local ToggleButton = createMenuButton("Macro: OFF", 1, Color3.fromRGB(180, 50, 50))

local currentModeText = _G.UseHoldMode and "Mode: HOLD" or "Mode: CLICK"
local currentModeColor = _G.UseHoldMode and Color3.fromRGB(50, 100, 150) or Color3.fromRGB(120, 50, 150)
local ModeButton = createMenuButton(currentModeText, 2, currentModeColor)

local BindButton = createMenuButton("Bind: " .. _G.MacroBind.Name, 3, Color3.fromRGB(55, 55, 55))

local AngleInput = createMenuTextBox("Degrees: " .. _G.TargetAngleDegrees .. "°", 4, Color3.fromRGB(35, 45, 35))

local currentDelayMs = math.floor(_G.MacroDelay * 1000)
local DelayInput = createMenuTextBox("Delay (ms): " .. currentDelayMs, 5, Color3.fromRGB(35, 35, 35))

local ComButton = createMenuButton("COM: OFF", 7, Color3.fromRGB(70, 70, 70))

-- === ОБРАБОТКА ВЗАИМОДЕЙСТВИЯ И СОХРАНЕНИЯ ===

ToggleButton.MouseButton1Click:Connect(function()
    _G.MacroEnabled = not _G.MacroEnabled
    if _G.MacroEnabled then
        ToggleButton.Text = "Macro: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        ToggleButton.Text = "Macro: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        _G.IsHolding = false
    end
end)

ModeButton.MouseButton1Click:Connect(function()
    _G.UseHoldMode = not _G.UseHoldMode
    if _G.UseHoldMode then
        ModeButton.Text = "Mode: HOLD"
        ModeButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
    else
        ModeButton.Text = "Mode: CLICK"
        ModeButton.BackgroundColor3 = Color3.fromRGB(120, 50, 150)
    end
    saveSettings()
end)

BindButton.MouseButton1Click:Connect(function()
    if _G.IsBinding then return end
    _G.IsBinding = true
    BindButton.Text = "Press any key..."
    BindButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end)

AngleInput.FocusLost:Connect(function(enterPressed)
    local text = AngleInput.Text:gsub("[^%d%-]", "")
    local deg = tonumber(text) or 60
    if deg == 0 then deg = 60 end
    _G.TargetAngleDegrees = deg
    AngleInput.Text = "Degrees: " .. deg .. "°"
    saveSettings()
end)

DelayInput.FocusLost:Connect(function(enterPressed)
    local text = DelayInput.Text:gsub("%D", "")
    local ms = tonumber(text) or 10
    _G.MacroDelay = ms / 1000
    DelayInput.Text = "Delay (ms): " .. ms
    saveSettings()
end)
-- ==========================================
-- ЧАСТЬ 3: ИЗМЕНЕННОЕ НАПРАВЛЕНИЕ ЦИКЛА И COM
-- ==========================================

-- Функция полной очистки осей COM
local function destroyAxis()
    if axisModel then
        axisModel:Destroy()
        axisModel = nil
    end
end

-- Функция создания неоновых осей координат на Центре Масс (COM)
local function createAxis()
    destroyAxis()
    
    axisModel = Instance.new("Model")
    axisModel.Name = "COMAxis_Vector_V9"
    axisModel.Parent = workspace
    
    local function makePart(size, color)
        local p = Instance.new("Part")
        p.Size = size
        p.Color = color
        p.Material = Enum.Material.Neon
        p.Anchored = true
        p.CanCollide = false
        p.Parent = axisModel
        return p
    end
    
    local x = makePart(Vector3.new(3, 0.3, 0.3), Color3.fromRGB(255, 0, 0))   -- Красная X
    local y = makePart(Vector3.new(0.3, 3, 0.3), Color3.fromRGB(0, 255, 0))   -- Зеленая Y
    local z = makePart(Vector3.new(0.3, 0.3, 3), Color3.fromRGB(0, 0, 255))   -- Синяя Z
    
    RunService.RenderStepped:Connect(function()
        if comEnabled and root and axisModel and x.Parent and y.Parent and z.Parent then
            local pos = root.AssemblyCenterOfMass
            local rot = root.CFrame - root.Position
            local cf = CFrame.new(pos) * rot
            x.CFrame = cf
            y.CFrame = cf
            z.CFrame = cf
        end
    end)
end

-- Логика кнопки COM
ComButton.MouseButton1Click:Connect(function()
    comEnabled = not comEnabled
    if comEnabled then
        ComButton.Text = "COM: ON"
        ComButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        createAxis()
    else
        ComButton.Text = "COM: OFF"
        ComButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        destroyAxis()
    end
end)

-- Отслеживание персонажа при ресетах
local function updateCharacter(char)
    character = char
    root = char:WaitForChild("HumanoidRootPart", 5)
    local humanoid = char:WaitForChild("Humanoid", 5)
    
    if humanoid then
        humanoid.Died:Connect(function()
            destroyAxis()
            if comEnabled then
                task.spawn(function()
                    local newChar = localPlayer.CharacterAdded:Wait()
                    if comEnabled then createAxis() end
                end)
            end
        end)
    end
end

localPlayer.CharacterAdded:Connect(updateCharacter)
if localPlayer.Character then
    updateCharacter(localPlayer.Character)
end

-- === ВЕКТОРНЫЙ ОБХОД КАМЕРЫ ===
local function vectorRotateCamera(targetDegrees)
    local rad = math.rad(targetDegrees)
    
    local camCF = camera.CFrame
    local camPos = camCF.Position
    local lookVec = camCF.LookVector
    
    local currentYaw = math.atan2(-lookVec.X, -lookVec.Z)
    local newYaw = currentYaw + rad
    local pitch = math.asin(lookVec.Y)
    
    local newLookVector = Vector3.new(
        -math.sin(newYaw) * math.cos(pitch),
        math.sin(pitch),
        -math.cos(newYaw) * math.cos(pitch)
    )
    
    camera.CFrame = CFrame.lookAt(camPos, camPos + newLookVector)
end

-- ИСПРАВЛЕННЫЙ ЦИКЛ: теперь сначала идет ВЛЕВО, потом ВПРАВО
local function startMacroLoop()
    local turnLeft = true -- Флаг инвертирован для старта влево
    while _G.IsHolding and _G.MacroEnabled do
        task.wait(_G.MacroDelay)
        if not _G.IsHolding or not _G.MacroEnabled then break end
        
        -- Если turnLeft истина, поворачиваем влево (знак минус), иначе вправо (знак плюс)
        local angle = turnLeft and -_G.TargetAngleDegrees or _G.TargetAngleDegrees
        vectorRotateCamera(angle)
        
        turnLeft = not turnLeft
    end
end

local staticTurnLeft = true

-- Слушатель ввода клавиатуры
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if _G.IsBinding and input.UserInputType == Enum.UserInputType.Keyboard then
        _G.MacroBind = input.KeyCode
        BindButton.Text = "Bind: " .. _G.MacroBind.Name
        BindButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        _G.IsBinding = false
        saveSettings()
        return
    end

    if gameProcessed or not _G.MacroEnabled then return end

    if input.KeyCode == _G.MacroBind then
        if _G.UseHoldMode then
            if not _G.IsHolding then
                _G.IsHolding = true
                task.spawn(startMacroLoop)
            end
        else
            -- Для режима CLICK порядок также изменен на влево -> вправо
            task.spawn(function()
                staticTurnLeft = not staticTurnLeft
                task.wait(_G.MacroDelay)
                local angle = staticTurnLeft and -_G.TargetAngleDegrees or _G.TargetAngleDegrees
                vectorRotateCamera(angle)
            end)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == _G.MacroBind then
        _G.IsHolding = false
    end
end)
