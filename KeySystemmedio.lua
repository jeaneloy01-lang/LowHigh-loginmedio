-- [[ SISTEMA DE PROTEÇÃO LOWHIGH STORE - MÉDIO ]] --
local KeyAuthApp = loadstring(game:HttpGet("https://raw.githubusercontent.com/KeyAuth/roblox-lua-example/main/KeyAuth.lua"))()

KeyAuthApp:init({
    name = "Jeaneloy01's Application",
    ownerid = "bg8cRvXsrd",
    secret = "803735a5e270d0b55245276f24f541361b0065532fb94760c86688ac90ddb9dd", -- <--- COLOQUE SUA SECRET AQUI!
    version = "1.0"
})

KeyAuthApp:login()

-- BLOQUEIO EXCLUSIVO: Só passa se a Key for Level 2
if KeyAuthApp.user_data.subscriptions[1].level ~= "2" then
    game.Players.LocalPlayer:Kick("❌ LowHigh Store: Esta key é do Plano Simples. Compre o MÉDIO!")
end

print("Acesso LowHigh MÉDIO Liberado! Carregando Silent Aim...")

-- [[ SCRIPT MÉDIO - SILENT AIM & ESP ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-up-library/master/gui%20v2"))()
local Window = Library:CreateWindow("LowHigh Store - MÉDIO")

local Main = Window:Folder("Combate")

-- Configurações do Silent Aim
_G.SilentAimEnabled = false
_G.TeamCheck = true

Main:Toggle("Ativar Silent Aim", function(state)
    _G.SilentAimEnabled = state
end)

-- Lógica do Silent Aim (Redirecionamento de Tiro)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function GetClosestPlayer()
    local target = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if _G.TeamCheck and v.Team == LocalPlayer.Team then continue end
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if magnitude < dist then
                    target = v
                    dist = magnitude
                end
            end
        end
    end
    return target
end

-- Hook para fazer a bala ir no alvo
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, index)
    if self == Mouse and index == "Hit" and _G.SilentAimEnabled then
        local target = GetClosestPlayer()
        if target and target.Character:FindFirstChild("Head") then
            return target.Character.Head.CFrame
        end
    end
    return oldIndex(self, index)
end)

local Visuals = Window:Folder("Visual")
Visuals:Button("Ativar ESP Boxes", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/p00p-shid/ESP/main/ESP.lua"))()
end)

Main:Label("Plano Médio Ativo", Color3.fromRGB(255, 255, 0))
