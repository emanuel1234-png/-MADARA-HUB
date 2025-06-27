local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPEnabled = false
local TextLabels = {}
local Lines = {}

-- Cria texto sobre a cabeça
local function createESPText(player)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "MadaraESP"
    billboardGui.Adornee = player.Character and player.Character:FindFirstChild("Head")
    billboardGui.Size = UDim2.new(0, 100, 0, 30)
    billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    billboardGui.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel", billboardGui)
    textLabel.Text = "MADARA MODS"
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 0, 0) -- vermelho
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Size = UDim2.new(1, 0, 1, 0)

    return billboardGui
end

-- Cria linha da base da tela até o jogador
local function createLine()
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.new(1, 0, 0)
    line.Thickness = 2
    return line
end

-- Ativa ESP
local function enableESP()
    if ESPEnabled then return end
    ESPEnabled = true

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local espText = createESPText(player)
            espText.Parent = player.Character.Head
            TextLabels[player] = espText

            local line = createLine()
            Lines[player] = line
        end
    end
end

-- Desativa ESP
local function disableESP()
    if not ESPEnabled then return end
    ESPEnabled = false

    for _, espText in pairs(TextLabels) do
        if espText then espText:Destroy() end
    end
    TextLabels = {}

    for _, line in pairs(Lines) do
        if line then
            line.Visible = false
            line:Remove()
        end
    end
    Lines = {}
end

-- Atualiza linhas a cada frame
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end

    for player, line in pairs(Lines) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPos, onScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
            local screenPos = Vector2.new(rootPos.X, rootPos.Y)
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

            if onScreen then
                line.From = screenCenter
                line.To = screenPos
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end)

-- Exemplo de uso: botão simples no chat para ligar/desligar ESP
Players.LocalPlayer.Chatted:Connect(function(msg)
    if msg == "!esp on" then
        enableESP()
        print("ESP ativado!")
    elseif msg == "!esp off" then
        disableESP()
        print("ESP desativado!")
    end
end)
