-- ==============================================================================
-- [Gestio UI - Blox Strike Ultimate Mobile Engine | Version 4.1.6 Clean Engine]
-- Target Game: Blox Strike (Roblox)
-- ==============================================================================

pcall(function()
    if getgenv and getgenv().GestioRunning then
        getgenv().GestioRunning()
    end
end)

-- ==========================================
-- SYSTEM SERVICES IMPORT
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = nil
pcall(function()
    VirtualInputManager = game:GetService("VirtualInputManager")
end)

-- ==========================================
-- CLIENT ENVIRONMENT VALIDATION
-- ==========================================
local player = Players.LocalPlayer
if not player then
    local startWait = tick()
    while not player and (tick() - startWait) < 5 do
        player = Players.LocalPlayer
        task.wait(0.1)
    end
    if not player then
        player = Players:GetPlayers()[1]
    end
end

local camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")

function getSafeGui()
    local success, result = pcall(function()
        if gethui then
            return gethui()
        end
    end)
    if success and result then return result end
    
    success, result = pcall(function()
        return CoreGui
    end)
    if success and result then return result end
    
    if player then
        return player:WaitForChild("PlayerGui", 5) or player:FindFirstChildOfClass("PlayerGui")
    end
    return nil
end

local targetGui = getSafeGui()
if not targetGui and player then
    pcall(function() targetGui = player:WaitForChild("PlayerGui", 5) end)
end
if not targetGui then
    warn("[Gestio] GUI initialization failed: no valid GUI parent")
    return
end

local connections = {}
local activeEspHolders = {}
local screenEspCache = {}
local activeTracersCache = {}
local activeHeadDotsCache = {}
local mobileSlideInputActive = false
local mobileSlideInput = nil
local mobileJumpHookedButton = nil
local mobileJumpConnections = {}
local skinScanAccumulator = 0
local savedAutoRotate = nil
local hitmarkerSerial = 0
local antiAfkEnabled = true
local antiAfkConnection = nil

local genv = (type(getgenv) == "function") and getgenv() or nil
if genv and not genv.GestioSavedPos then
    genv.GestioSavedPos = {
        OpenBtn = UDim2.new(0.5, -45, 0, 15),
        MainFrame = UDim2.new(0.5, 0, 0.5, 0)
    }
end
local savedPos = (genv and genv.GestioSavedPos) or {
    OpenBtn = UDim2.new(0.5, -45, 0, 15),
    MainFrame = UDim2.new(0.5, 0, 0.5, 0)
}

-- ==========================================
-- EXTENDED THEME & PALETTE SYSTEM
-- ==========================================
local themeLibrary = {
    ["Charcoal Crimson"] = {
        Name = "Charcoal Crimson",
        Background = Color3.fromRGB(24, 25, 28),
        Sidebar = Color3.fromRGB(30, 32, 36),
        CardBg = Color3.fromRGB(35, 38, 43),
        Accent = Color3.fromRGB(210, 45, 55),
        AccentHover = Color3.fromRGB(230, 60, 70),
        TextPrimary = Color3.fromRGB(235, 238, 242),
        TextSecondary = Color3.fromRGB(140, 145, 155),
        Border = Color3.fromRGB(45, 48, 55),
        GridSquare = Color3.fromRGB(30, 32, 36),
        Enemy_Accent = Color3.fromRGB(235, 75, 75),
        Enemy_Fill = Color3.fromRGB(220, 50, 50),
        Enemy_Hidden = Color3.fromRGB(120, 125, 135),
        NametagTextColor = Color3.fromRGB(255, 255, 255),
        HealthHigh = Color3.fromRGB(46, 204, 113),
        HealthMid = Color3.fromRGB(241, 196, 15),
        HealthLow = Color3.fromRGB(231, 76, 60),
        MolotovColor = Color3.fromRGB(255, 95, 35),
        SmokeColor = Color3.fromRGB(180, 185, 195),
        HEColor = Color3.fromRGB(255, 45, 55)
    },
    ["Cyberpunk Neon"] = {
        Name = "Cyberpunk Neon",
        Background = Color3.fromRGB(15, 15, 22),
        Sidebar = Color3.fromRGB(20, 20, 32),
        CardBg = Color3.fromRGB(28, 28, 45),
        Accent = Color3.fromRGB(0, 230, 255),
        AccentHover = Color3.fromRGB(40, 240, 255),
        TextPrimary = Color3.fromRGB(240, 245, 255),
        TextSecondary = Color3.fromRGB(130, 140, 175),
        Border = Color3.fromRGB(45, 50, 75),
        GridSquare = Color3.fromRGB(22, 22, 36),
        Enemy_Accent = Color3.fromRGB(255, 0, 128),
        Enemy_Fill = Color3.fromRGB(200, 0, 100),
        Enemy_Hidden = Color3.fromRGB(120, 125, 135),
        NametagTextColor = Color3.fromRGB(255, 255, 255),
        HealthHigh = Color3.fromRGB(0, 255, 200),
        HealthMid = Color3.fromRGB(255, 220, 0),
        HealthLow = Color3.fromRGB(255, 0, 90),
        MolotovColor = Color3.fromRGB(255, 120, 0),
        SmokeColor = Color3.fromRGB(140, 160, 210),
        HEColor = Color3.fromRGB(255, 0, 90)
    },
    ["Emerald Shadow"] = {
        Name = "Emerald Shadow",
        Background = Color3.fromRGB(18, 24, 20),
        Sidebar = Color3.fromRGB(22, 32, 26),
        CardBg = Color3.fromRGB(28, 42, 34),
        Accent = Color3.fromRGB(46, 204, 113),
        AccentHover = Color3.fromRGB(60, 220, 130),
        TextPrimary = Color3.fromRGB(235, 245, 240),
        TextSecondary = Color3.fromRGB(135, 160, 145),
        Border = Color3.fromRGB(40, 60, 48),
        GridSquare = Color3.fromRGB(24, 34, 28),
        Enemy_Accent = Color3.fromRGB(235, 75, 75),
        Enemy_Fill = Color3.fromRGB(220, 50, 50),
        Enemy_Hidden = Color3.fromRGB(120, 125, 135),
        NametagTextColor = Color3.fromRGB(255, 255, 255),
        HealthHigh = Color3.fromRGB(46, 204, 113),
        HealthMid = Color3.fromRGB(241, 196, 15),
        HealthLow = Color3.fromRGB(231, 76, 60),
        MolotovColor = Color3.fromRGB(255, 100, 40),
        SmokeColor = Color3.fromRGB(170, 190, 180),
        HEColor = Color3.fromRGB(255, 50, 60)
    }
}

local currentTheme = themeLibrary["Charcoal Crimson"]

-- ==========================================
-- COMBAT ENGINE STATE VARIABLES
-- ==========================================
local aimbotEnabled = false
local aimbotSpeed = 35.0
local aimbotSmoothness = 0.15
local aimFov = 160
local showFovCircle = true
local snapAimMode = false
local isAiming = false
local lockedTarget = nil
local aimboneIndex = 1
local targetSwitchDelay = 0.05
local shotDelay = 0.0
local hitChance = 85
local minDamage = 15
local bodyAimOnly = false
local autoWallCheck = false
local predictionEnabled = true
local predictionFactor = 0.135
local visibleCheck = false
local aimSensitivity = 1.0
local lockOnJump = true

-- ==========================================
-- STABLE NON-CONFLICTING NO RECOIL / RCS
-- ==========================================
local noRecoil = {
    enabled = false,
    strength = 0.85,
    isShooting = false
}

local rcsEnabled = false
local rcsStrength = 60
local rcsPitchFactor = 1.0
local rcsYawFactor = 1.0

-- Track firing state safely across Touch and Mouse without touching game inventory
local fireStartConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        noRecoil.isShooting = true
    end
end)
table.insert(connections, fireStartConn)

local fireEndConn = UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        noRecoil.isShooting = false
    end
end)
table.insert(connections, fireEndConn)

-- ==========================================
-- CRIMSON NEON HITMARKER & THIRD PERSON
-- ==========================================
local hitmarkerEnabled = false
local hitmarkerDuration = 0.28
local hitmarkerSize = 13
local hitmarkerThickness = 2
local hitmarkerGlow = true
local hitmarkerLastHealth = {}
local hitmarkerBusy = false
local thirdPersonEnabled = false
local thirdPersonDistance = 12
local thirdPersonHeight = 1.5
local thirdPersonPreviousOffset = nil

-- ==========================================
-- SKINS & WEAPON MODS ENGINE
-- ==========================================
local butterflyKnifeEnabled = false
local butterflySkin = "Fade"

function hookBloxStrikeModules()
    pcall(function()
        if getgc then
            for _, v in ipairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "EquippedMelee") ~= nil then
                    v.EquippedMelee = "Butterfly Knife"
                elseif type(v) == "table" and rawget(v, "MeleeSkin") ~= nil then
                    v.MeleeSkin = butterflySkin
                elseif type(v) == "table" and rawget(v, "Knife") ~= nil and type(v.Knife) == "table" then
                    v.Knife.Name = "Butterfly Knife"
                    v.Knife.Skin = butterflySkin
                end
            end
        end
    end)
end

function scanAndMorphKnives(root)
    if not butterflyKnifeEnabled or not root then return end
    pcall(function()
        for _, obj in ipairs(root:GetDescendants()) do
            local oName = obj.Name:lower()
            if oName:find("knife") or oName:find("melee") or oName:find("blade") or oName:find("karambit") or oName:find("bayonet") or oName:find("arms") or oName:find("viewmodel") then
                for _, child in ipairs(obj:GetDescendants()) do
                    local textureId
                    if butterflySkin == "Fade" then
                        textureId = "rbxassetid://4991206411"
                    elseif butterflySkin == "Doppler" then
                        textureId = "rbxassetid://4991206517"
                    elseif butterflySkin == "Lore" then
                        textureId = "rbxassetid://4991206622"
                    else
                        textureId = "rbxassetid://4991206306"
                    end

                    if child:IsA("MeshPart") then
                        pcall(function() child.TextureID = textureId end)
                    elseif child:IsA("SpecialMesh") then
                        pcall(function() child.TextureId = textureId end)
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- TRIGGERBOT ASSISTANT VARIABLES
-- ==========================================
local triggerbotEnabled = false
local triggerbotDelay = 0.02
local triggerbotHeadOnly = false
local triggerbotMobileAutoFire = true
local lastTriggerTick = 0

-- ==========================================
-- RAGE & ANTI-AIM (SPINBOT) VARIABLES
-- ==========================================
local antiAimEnabled = false
local spinSpeed = 50
local currentSpinAngle = 0
local antiAimYawMode = "Spin"

-- ==========================================
-- MOVEMENT, BHOP & SLIDE VARIABLES
-- ==========================================
local bunnyHopEnabled = false
local bhopAutoJump = false
local bhopAirStrafe = true
local bhopSpeedBoost = 1.35
local bhopJumpPower = 52
local isMobileJumpHeld = false
local lastMoveDirection = Vector3.zero

local slideEnabled = false
local isSliding = false
local slideSpeedBoost = 1.8
local slideFriction = 0.94
local slideMinSpeed = 16
local currentSlideVel = Vector3.zero
local defaultHipHeight = 2.0
local defaultHipHeightCaptured = false

local speedEnabled = false
local walkMultiplier = 2.0

local flightEnabled = false
local flightSpeed = 50

-- ==========================================
-- VISUALS & ESP CONFIGURATION VARIABLES
-- ==========================================
local nametagsEnabled = false
local espMaxDist = 3000
local espShowDistance = true
local espShowHealth = true
local espTextSize = 8.5
local tagTransparency = 0.25
local tagBgColor = Color3.fromRGB(16, 17, 20)
local tagOffsetY = 2.6
local tagShowWeapon = true

local boxEspEnabled = false
local cornerBoxEnabled = false
local boxThickness = 1.0
local healthBarEnabled = true

local highlightEnabled = false
local headDotEnabled = false
local tracersEnabled = false

local grenadeEspEnabled = false
local showGrenadePath = true
local showMolotovRadius = true
local showSmokeRadius = true
local grenadeMaxDist = 1500

-- ==========================================
-- JUMP CIRCLE CONFIGURATION VARIABLES
-- ==========================================
local jumpCircleEnabled = false
local jumpCircleStyle = "GradientWave"
local jumpCircleSegmentCount = 32
local jumpCircleRadius = 3.5
local jumpCircleHeightOffset = -2.8
local activeJumpCircleData = nil

-- ==========================================
-- ENVIRONMENT & LIGHTING VARIABLES
-- ==========================================
local antiFlashEnabled = true
local fullBrightEnabled = false
local removeFogEnabled = true

local nightModeEnabled = false
local nightPreset = "Midnight"
local nightClockTime = 0.0
local nightBrightness = 0.2
local nightOutdoorAmbient = Color3.fromRGB(25, 25, 40)

local nightPresets = {
    ["Midnight"] = {
        ClockTime = 0.0,
        Brightness = 0.2,
        OutdoorAmbient = Color3.fromRGB(25, 25, 40),
        Ambient = Color3.fromRGB(15, 15, 25),
        FogColor = Color3.fromRGB(10, 10, 20)
    },
    ["Nebula"] = {
        ClockTime = 23.8,
        Brightness = 0.3,
        OutdoorAmbient = Color3.fromRGB(70, 25, 85),
        Ambient = Color3.fromRGB(45, 15, 60),
        FogColor = Color3.fromRGB(90, 30, 110)
    },
    ["DeepBlood"] = {
        ClockTime = 0.0,
        Brightness = 0.35,
        OutdoorAmbient = Color3.fromRGB(75, 10, 15),
        Ambient = Color3.fromRGB(45, 5, 10),
        FogColor = Color3.fromRGB(35, 5, 8)
    },
    ["CyberPurple"] = {
        ClockTime = 23.5,
        Brightness = 0.3,
        OutdoorAmbient = Color3.fromRGB(65, 15, 95),
        Ambient = Color3.fromRGB(40, 10, 60),
        FogColor = Color3.fromRGB(30, 8, 45)
    },
    ["EmeraldNight"] = {
        ClockTime = 1.0,
        Brightness = 0.25,
        OutdoorAmbient = Color3.fromRGB(10, 55, 30),
        Ambient = Color3.fromRGB(5, 35, 20),
        FogColor = Color3.fromRGB(5, 25, 15)
    },
    ["PitchBlack"] = {
        ClockTime = 0.0,
        Brightness = 0.0,
        OutdoorAmbient = Color3.fromRGB(0, 0, 0),
        Ambient = Color3.fromRGB(0, 0, 0),
        FogColor = Color3.fromRGB(0, 0, 0)
    }
}

local defaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor
}

-- ==========================================
-- DISPLAY CONTAINERS SETUP
-- ==========================================
mainContainer = Instance.new("ScreenGui")
mainContainer.Name = "GestioMainContainer"
mainContainer.ResetOnSpawn = false
mainContainer.DisplayOrder = 10
mainContainer.IgnoreGuiInset = true
mainContainer.Parent = targetGui

overlayContainer = Instance.new("Folder", mainContainer)
overlayContainer.Name = "Gestio_2DOverlay"

grenadeContainer = Instance.new("Folder", mainContainer)
grenadeContainer.Name = "Gestio_GrenadeOverlay"

jumpCircleFolder = Instance.new("Folder", Workspace)
jumpCircleFolder.Name = "Gestio_JumpCircleWorld"

grenadePool = {}
mobileSlideBtn = nil

-- ==========================================
-- CRIMSON NEON HITMARKER UI
-- ==========================================
local hitmarkerGui = Instance.new("ScreenGui")
hitmarkerGui.Name = "GestioHitmarkerGui"
hitmarkerGui.ResetOnSpawn = false
hitmarkerGui.IgnoreGuiInset = true
hitmarkerGui.DisplayOrder = 60
hitmarkerGui.Parent = mainContainer

local hitmarkerCenter = Instance.new("Frame")
hitmarkerCenter.Name = "Center"
hitmarkerCenter.AnchorPoint = Vector2.new(0.5, 0.5)
hitmarkerCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
hitmarkerCenter.Size = UDim2.new(0, 0, 0, 0)
hitmarkerCenter.BackgroundTransparency = 1
hitmarkerCenter.Visible = false
hitmarkerCenter.Parent = hitmarkerGui

local hitmarkerLines = {}
for i, rotation in ipairs({45, -45, 135, -135}) do
    local line = Instance.new("Frame")
    line.Name = "Line" .. i
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Size = UDim2.new(0, hitmarkerThickness, 0, hitmarkerSize)
    line.BackgroundColor3 = currentTheme.Accent
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 1
    line.Rotation = rotation
    line.Parent = hitmarkerCenter

    local glow = Instance.new("UIStroke")
    glow.Name = "NeonGlow"
    glow.Color = currentTheme.Accent
    glow.Thickness = hitmarkerGlow and 2.5 or 0
    glow.Transparency = 1
    glow.Parent = line

    hitmarkerLines[i] = line
end

function refreshHitmarkerTheme()
    for _, line in ipairs(hitmarkerLines) do
        line.BackgroundColor3 = currentTheme.Accent
        local glow = line:FindFirstChild("NeonGlow")
        if glow then
            glow.Color = currentTheme.Accent
            glow.Thickness = hitmarkerGlow and 2.5 or 0
        end
    end
end

function showHitmarker()
    if not hitmarkerEnabled then return end

    hitmarkerSerial += 1
    local serial = hitmarkerSerial
    hitmarkerCenter.Visible = true

    for _, line in ipairs(hitmarkerLines) do
        line.BackgroundTransparency = 0
        local glow = line:FindFirstChild("NeonGlow")
        if glow then glow.Transparency = 0.05 end
    end

    local fadeInfo = TweenInfo.new(
        math.max(0.05, hitmarkerDuration),
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    for _, line in ipairs(hitmarkerLines) do
        TweenService:Create(line, fadeInfo, {
            BackgroundTransparency = 1
        }):Play()

        local glow = line:FindFirstChild("NeonGlow")
        if glow then
            TweenService:Create(glow, fadeInfo, {Transparency = 1}):Play()
        end
    end

    task.delay(math.max(0.05, hitmarkerDuration), function()
        if serial == hitmarkerSerial then
            hitmarkerCenter.Visible = false
        end
    end)
end

if genv then
    genv.GestioShowHitmarker = showHitmarker
end

-- ==========================================
-- THIRD PERSON CAMERA CONTROLLER
-- ==========================================
function applyThirdPerson()
    local cam = Workspace.CurrentCamera
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not cam or not hum then return end

    if thirdPersonEnabled then
        if thirdPersonPreviousOffset == nil then
            thirdPersonPreviousOffset = hum.CameraOffset
        end
        cam.CameraSubject = hum
        cam.CameraType = Enum.CameraType.Custom
        hum.CameraOffset = Vector3.new(0, thirdPersonHeight, -thirdPersonDistance)
    else
        if thirdPersonPreviousOffset ~= nil then
            hum.CameraOffset = thirdPersonPreviousOffset
            thirdPersonPreviousOffset = nil
        else
            hum.CameraOffset = Vector3.zero
        end
    end
end

function setThirdPersonEnabled(enabled)
    thirdPersonEnabled = enabled
    applyThirdPerson()
end

function refreshThirdPerson()
    if thirdPersonEnabled then
        applyThirdPerson()
    end
end

-- ==========================================
-- LIGHTING & ATMOSPHERE FUNCTIONS
-- ==========================================
function applyNightPreset(presetName)
    local cfg = nightPresets[presetName]
    if not cfg then return end
    nightPreset = presetName
    nightClockTime = cfg.ClockTime
    nightBrightness = cfg.Brightness
    nightOutdoorAmbient = cfg.OutdoorAmbient
    
    if nightModeEnabled then
        Lighting.ClockTime = cfg.ClockTime
        Lighting.Brightness = cfg.Brightness
        Lighting.OutdoorAmbient = cfg.OutdoorAmbient
        Lighting.Ambient = cfg.Ambient
        Lighting.GlobalShadows = true
        if not removeFogEnabled then
            Lighting.FogColor = cfg.FogColor
        end
    end
end

function restoreLightingState()
    pcall(function()
        Lighting.Brightness = defaultLighting.Brightness
        Lighting.ClockTime = defaultLighting.ClockTime
        Lighting.GlobalShadows = defaultLighting.GlobalShadows
        Lighting.Ambient = defaultLighting.Ambient
        Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
        Lighting.FogEnd = defaultLighting.FogEnd
        Lighting.FogColor = defaultLighting.FogColor
    end)
end

-- ==========================================
-- CLEANUP ROUTINES
-- ==========================================
function clearActiveJumpCircle()
    if not activeJumpCircleData then return end
    if activeJumpCircleData.Connections then
        for _, conn in ipairs(activeJumpCircleData.Connections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    if activeJumpCircleData.Container then
        pcall(function() activeJumpCircleData.Container:Destroy() end)
    end
    activeJumpCircleData = nil
end

function cleanup()
    pcall(function() setThirdPersonEnabled(false) end)
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum and savedAutoRotate ~= nil then
            hum.AutoRotate = savedAutoRotate
        end
    end
    savedAutoRotate = nil
    hitmarkerSerial += 1
    hitmarkerLastHealth = {}

    for _, c in pairs(connections) do 
        pcall(function() c:Disconnect() end) 
    end
    if antiAfkConnection then
        pcall(function() antiAfkConnection:Disconnect() end)
        antiAfkConnection = nil
    end
    for _, holder in pairs(activeEspHolders) do
        pcall(function() holder.Holder:Destroy() end)
    end
    for _, esp in pairs(screenEspCache) do
        pcall(function()
            esp.Box:Destroy()
            esp.TagCard:Destroy()
            esp.HealthBarBg:Destroy()
            for _, corner in pairs(esp.Corners) do
                corner.H:Destroy()
                corner.V:Destroy()
            end
        end)
    end
    for _, gUi in pairs(grenadePool) do
        pcall(function()
            gUi.Tag:Destroy()
            gUi.RadiusCircle:Destroy()
            for _, l in ipairs(gUi.Lines) do l:Destroy() end
        end)
    end
    clearActiveJumpCircle()
    pcall(function() jumpCircleFolder:Destroy() end)
    pcall(function() hitmarkerGui:Destroy() end)
    if genv then genv.GestioShowHitmarker = nil end
    if mobileSlideBtn then
        pcall(function() mobileSlideBtn:Destroy() end)
        mobileSlideBtn = nil
    end
    mobileSlideInputActive = false
    mobileSlideInput = nil
    isSliding = false
    currentSlideVel = Vector3.zero
    for _, conn in ipairs(mobileJumpConnections) do
        pcall(function() conn:Disconnect() end)
    end
    mobileJumpConnections = {}
    mobileJumpHookedButton = nil
    activeEspHolders = {}
    screenEspCache = {}
    grenadePool = {}
    
    restoreLightingState()

    pcall(function() if targetGui:FindFirstChild("GestioScreenGui") then targetGui.GestioScreenGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioToggleGui") then targetGui.GestioToggleGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioFovGui") then targetGui.GestioFovGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioWatermarkGui") then targetGui.GestioWatermarkGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioMainContainer") then targetGui.GestioMainContainer:Destroy() end end)
end

if genv then genv.GestioRunning = cleanup end

function bindTouch(btn, callback)
    btn.Activated:Connect(callback)
end

-- ==========================================
-- HUD OVERLAYS (FOV & WATERMARK)
-- ==========================================
fovGui = Instance.new("ScreenGui")
fovGui.Name = "GestioFovGui"
fovGui.ResetOnSpawn = false
fovGui.DisplayOrder = 9
fovGui.IgnoreGuiInset = true
fovGui.Parent = targetGui

fovFrame = Instance.new("Frame", fovGui)
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovFrame.BackgroundTransparency = 1
fovFrame.BorderSizePixel = 0
fovFrame.Visible = false
fovStroke = Instance.new("UIStroke", fovFrame)
fovStroke.Color = currentTheme.Accent
fovStroke.Thickness = 0.8
fovCorner = Instance.new("UICorner", fovFrame)
fovCorner.CornerRadius = UDim.new(1, 0)

watermarkGui = Instance.new("ScreenGui")
watermarkGui.Name = "GestioWatermarkGui"
watermarkGui.ResetOnSpawn = false
watermarkGui.DisplayOrder = 20
watermarkGui.IgnoreGuiInset = true
watermarkGui.Parent = targetGui

wmCard = Instance.new("Frame", watermarkGui)
wmCard.Position = UDim2.new(0, 14, 0, 14)
wmCard.Size = UDim2.new(0, 0, 0, 22)
wmCard.AutomaticSize = Enum.AutomaticSize.X
wmCard.BackgroundColor3 = currentTheme.Background
wmCard.BorderSizePixel = 0
Instance.new("UICorner", wmCard).CornerRadius = UDim.new(0, 5)

wmStroke = Instance.new("UIStroke", wmCard)
wmStroke.Color = currentTheme.Border
wmStroke.Thickness = 1.0

wmPad = Instance.new("UIPadding", wmCard)
wmPad.PaddingLeft = UDim.new(0, 8)
wmPad.PaddingRight = UDim.new(0, 8)

wmLayout = Instance.new("UIListLayout", wmCard)
wmLayout.FillDirection = Enum.FillDirection.Horizontal
wmLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wmLayout.Padding = UDim.new(0, 5)

wmDot = Instance.new("Frame", wmCard)
wmDot.Size = UDim2.new(0, 5, 0, 5)
wmDot.BackgroundColor3 = currentTheme.Accent
wmDot.BorderSizePixel = 0
Instance.new("UICorner", wmDot).CornerRadius = UDim.new(1, 0)

wmTitle = Instance.new("TextLabel", wmCard)
wmTitle.AutomaticSize = Enum.AutomaticSize.X
wmTitle.Size = UDim2.new(0, 0, 1, 0)
wmTitle.BackgroundTransparency = 1
wmTitle.Text = "GESTIO"
wmTitle.TextColor3 = currentTheme.Accent
wmTitle.TextSize = 9
wmTitle.Font = Enum.Font.GothamBold

wmDivider = Instance.new("Frame", wmCard)
wmDivider.Size = UDim2.new(0, 1, 0, 10)
wmDivider.BackgroundColor3 = currentTheme.Border
wmDivider.BorderSizePixel = 0

wmMetrics = Instance.new("TextLabel", wmCard)
wmMetrics.AutomaticSize = Enum.AutomaticSize.X
wmMetrics.Size = UDim2.new(0, 0, 1, 0)
wmMetrics.BackgroundTransparency = 1
wmMetrics.Text = "FPS: 60 | PING: 0ms"
wmMetrics.TextColor3 = currentTheme.TextSecondary
wmMetrics.TextSize = 8.5
wmMetrics.Font = Enum.Font.GothamBold

fpsCounter = 0
lastFpsUpdate = tick()

-- ==========================================
-- FACTION CHECK & HEALTH CHECK LOGIC
-- ==========================================
function isAlly(plr)
    if not plr or plr == player then return false end
    if plr.Team and player.Team then
        return plr.Team == player.Team
    end
    if plr:GetAttribute("Team") and player:GetAttribute("Team") then
        return plr:GetAttribute("Team") == player:GetAttribute("Team")
    end
    if plr.TeamColor and player.TeamColor and plr.TeamColor ~= BrickColor.new("White") then
        return plr.TeamColor == player.TeamColor
    end
    return false
end

function isTargetEnemy(plr, char)
    if not plr or plr == player then return false end
    if char and char == player.Character then return false end
    return not isAlly(plr)
end

function getTargetHitbox(char)
    if not char then return nil end
    if bodyAimOnly then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    end
    if aimboneIndex == 1 then
        return char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso")
    elseif aimboneIndex == 2 then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
    else
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
    end
end

function isEntityAlive(char, hum)
    if not char or not char.Parent or not char:IsDescendantOf(Workspace) then 
        return false 
    end
    
    if hum and hum.Parent then
        local health = 100
        pcall(function() health = hum.Health end)
        if health <= 0 then 
            return false 
        end
        
        local state = nil
        pcall(function() state = hum:GetState() end)
        if state == Enum.HumanoidStateType.Dead then 
            return false 
        end
    end

    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    local head = char:FindFirstChild("Head")
    if not root and not head then
        return false
    end

    return true
end

-- ==========================================
-- VISIBILITY CHECK SYSTEM
-- ==========================================
wallRayParams = RaycastParams.new()
wallRayParams.FilterType = Enum.RaycastFilterType.Exclude
wallRayParams.IgnoreWater = true

function isVisibleThroughWalls(targetPart, targetChar)
    if not camera or not targetPart or not targetChar then return false end
    local myChar = player.Character
    wallRayParams.FilterDescendantsInstances = {myChar, camera}
    local origin = camera.CFrame.Position
    local dir = targetPart.Position - origin
    local hit = Workspace:Raycast(origin, dir, wallRayParams)
    if hit then
        if hit.Instance:IsDescendantOf(targetChar) or hit.Instance == targetPart then
            return true
        end
    end
    return false
end

-- ==========================================
-- JUMP CIRCLE RENDER ENGINE
-- ==========================================
function buildJumpRing(segmentCount, radius, thickness)
    local container = Instance.new("Folder")
    container.Name = "JumpCircleContainer"

    local segments = {}
    local angleStep = (math.pi * 2) / segmentCount
    local chordLength = 2 * radius * math.sin(angleStep / 2) + 0.15

    for i = 1, segmentCount do
        local angle = (i - 1) * angleStep
        local part = Instance.new("Part")
        part.Name = "Seg_" .. i
        part.Size = Vector3.new(thickness or 0.25, thickness or 0.25, chordLength)
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.CastShadow = false
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromRGB(255, 255, 255)
        part.Transparency = 0
        part.Parent = container

        segments[i] = {
            Part = part,
            Angle = angle
        }
    end

    return container, segments
end

function updateJumpRingLayout(segments, centerPosition, radius)
    local n = #segments
    for i, seg in ipairs(segments) do
        local angle = seg.Angle
        local nextAngle = angle + (math.pi * 2 / n)
        local p1 = centerPosition + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        local p2 = centerPosition + Vector3.new(math.cos(nextAngle) * radius, 0, math.sin(nextAngle) * radius)
        local mid = (p1 + p2) * 0.5

        if seg.Part and seg.Part.Parent then
            seg.Part.CFrame = CFrame.lookAt(mid, p2)
        end
    end
end

function spawnJumpRipple(position)
    if not jumpCircleEnabled then return end
    task.spawn(function()
        local rippleFolder, segments = buildJumpRing(jumpCircleSegmentCount, jumpCircleRadius, 0.3)
        rippleFolder.Parent = jumpCircleFolder

        local startT = os.clock()
        local duration = 0.5
        local maxR = jumpCircleRadius * 2.5
        local col1 = Color3.fromRGB(0, 240, 255)
        local col2 = Color3.fromRGB(255, 0, 128)

        local rippleConn
        rippleConn = RunService.RenderStepped:Connect(function()
            local elapsed = os.clock() - startT
            local alpha = elapsed / duration
            if alpha >= 1 or not jumpCircleEnabled then
                if rippleConn then rippleConn:Disconnect() end
                if rippleFolder then rippleFolder:Destroy() end
                return
            end

            local eased = 1 - (1 - alpha) * (1 - alpha)
            local curR = jumpCircleRadius + (maxR - jumpCircleRadius) * eased
            updateJumpRingLayout(segments, position, curR)

            for i, seg in ipairs(segments) do
                if seg.Part and seg.Part.Parent then
                    seg.Part.Transparency = alpha
                    seg.Part.Color = col1:Lerp(col2, alpha)
                end
            end
        end)
    end)
end

function initJumpCircleForCharacter(char)
    clearActiveJumpCircle()
    if not jumpCircleEnabled or not char then return end

    local hrp = char:WaitForChild("HumanoidRootPart", 4)
    local hum = char:WaitForChild("Humanoid", 4)
    if not hrp or not hum then return end

    local container, segments = buildJumpRing(jumpCircleSegmentCount, jumpCircleRadius, 0.25)
    container.Parent = jumpCircleFolder

    local circleData = {
        Container = container,
        Segments = segments,
        HRP = hrp,
        Humanoid = hum,
        Connections = {}
    }
    activeJumpCircleData = circleData

    local startClock = os.clock()

    local loopConn = RunService.RenderStepped:Connect(function(dt)
        if not jumpCircleEnabled or not hrp or not hrp.Parent or not hum or not hum.Parent or hum.Health <= 0 then
            clearActiveJumpCircle()
            return
        end

        local elapsed = os.clock() - startClock
        local footPos = hrp.Position + Vector3.new(0, jumpCircleHeightOffset, 0)
        updateJumpRingLayout(segments, footPos, jumpCircleRadius)

        if jumpCircleStyle == "GradientWave" then
            local n = #segments
            local spin = (elapsed * 3) % (math.pi * 2)
            local c1 = Color3.fromRGB(210, 45, 55)
            local c2 = Color3.fromRGB(0, 200, 255)
            for i, seg in ipairs(segments) do
                local ratio = ((i / n) + spin) % 1
                local wave = (math.sin(ratio * math.pi * 2) + 1) * 0.5
                if seg.Part and seg.Part.Parent then
                    seg.Part.Color = c1:Lerp(c2, wave)
                    seg.Part.Transparency = 0.1 + (wave * 0.2)
                end
            end
        elseif jumpCircleStyle == "ChromaPulse" then
            local hue = (elapsed * 0.4) % 1
            local col = Color3.fromHSV(hue, 0.9, 1)
            for _, seg in ipairs(segments) do
                if seg.Part and seg.Part.Parent then
                    seg.Part.Color = col
                    seg.Part.Transparency = 0.15
                end
            end
        elseif jumpCircleStyle == "StaticNeon" then
            for _, seg in ipairs(segments) do
                if seg.Part and seg.Part.Parent then
                    seg.Part.Color = currentTheme.Accent
                    seg.Part.Transparency = 0.1
                end
            end
        end
    end)
    table.insert(circleData.Connections, loopConn)

    local stateConn = hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Jumping then
            local footPos = hrp.Position + Vector3.new(0, jumpCircleHeightOffset, 0)
            spawnJumpRipple(footPos)
        end
    end)
    table.insert(circleData.Connections, stateConn)
end

table.insert(connections, player.CharacterAdded:Connect(initJumpCircleForCharacter))
table.insert(connections, player.CharacterRemoving:Connect(clearActiveJumpCircle))

if player.Character then
    task.spawn(function()
        initJumpCircleForCharacter(player.Character)
    end)
end

-- ==========================================
-- GRENADE TRAJECTORY CALCULATION ENGINE
-- ==========================================
grenadeRayParams = RaycastParams.new()
grenadeRayParams.FilterType = Enum.RaycastFilterType.Exclude
grenadeRayParams.IgnoreWater = true

function isEntityCharacter(inst)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and inst:IsDescendantOf(p.Character) then
            return true
        end
    end
    return false
end

function getOrCreateGrenadeUI(nadeInstance)
    if grenadePool[nadeInstance] then return grenadePool[nadeInstance] end

    local tag = Instance.new("Frame", grenadeContainer)
    tag.Size = UDim2.new(0, 0, 0, 14)
    tag.AutomaticSize = Enum.AutomaticSize.X
    tag.AnchorPoint = Vector2.new(0.5, 1)
    tag.BackgroundColor3 = Color3.fromRGB(18, 19, 22)
    tag.BackgroundTransparency = 0.35
    tag.BorderSizePixel = 0
    tag.Visible = false
    Instance.new("UICorner", tag).CornerRadius = UDim.new(0, 3)

    local pad = Instance.new("UIPadding", tag)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)

    local lbl = Instance.new("TextLabel", tag)
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextSize = 7.5
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)

    local radiusCircle = Instance.new("Frame", grenadeContainer)
    radiusCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    radiusCircle.BackgroundTransparency = 1
    radiusCircle.BorderSizePixel = 0
    radiusCircle.Visible = false
    Instance.new("UICorner", radiusCircle).CornerRadius = UDim.new(1, 0)
    local radStroke = Instance.new("UIStroke", radiusCircle)
    radStroke.Thickness = 1.5

    local data = {
        Tag = tag,
        Label = lbl,
        RadiusCircle = radiusCircle,
        RadiusStroke = radStroke,
        Lines = {}
    }

    for j = 1, 8 do
        local seg = Instance.new("Frame", grenadeContainer)
        seg.BorderSizePixel = 0
        seg.AnchorPoint = Vector2.new(0.5, 0.5)
        seg.Visible = false
        table.insert(data.Lines, seg)
    end

    grenadePool[nadeInstance] = data
    return data
end

function renderGrenadeOverlays()
    if not grenadeEspEnabled then
        for _, v in pairs(grenadePool) do
            v.Tag.Visible = false
            v.RadiusCircle.Visible = false
            for _, l in ipairs(v.Lines) do l.Visible = false end
        end
        return
    end

    local camPos = camera.CFrame.Position
    local activeGrenades = {}

    for _, item in ipairs(Workspace:GetChildren()) do
        if not isEntityCharacter(item) then
            local nName = item.Name:lower()
            local isNade = false
            local nadeType = "NADE"
            local nadeColor = currentTheme.HEColor
            local effectRadiusStuds = 14

            if nName:find("molotov") or nName:find("incendiary") or nName:find("fire") then
                isNade = true
                nadeType = "MOLOTOV"
                nadeColor = currentTheme.MolotovColor
                effectRadiusStuds = 17
            elseif nName:find("smoke") then
                isNade = true
                nadeType = "SMOKE"
                nadeColor = currentTheme.SmokeColor
                effectRadiusStuds = 20
            elseif nName:find("grenade") or nName:find("hegrenade") or nName:find("frag") then
                isNade = true
                nadeType = "HE"
                nadeColor = currentTheme.HEColor
                effectRadiusStuds = 15
            elseif nName:find("flash") then
                isNade = true
                nadeType = "FLASH"
                nadeColor = Color3.fromRGB(245, 235, 120)
                effectRadiusStuds = 10
            end

            if isNade then
                local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                if part and part.Parent and part:IsDescendantOf(Workspace) then
                    local dist = (part.Position - camPos).Magnitude
                    if dist <= grenadeMaxDist then
                        activeGrenades[item] = true
                        local ui = getOrCreateGrenadeUI(item)
                        local scrPos, onScreen = camera:WorldToViewportPoint(part.Position)

                        if onScreen and scrPos.Z > 0 then
                            ui.Tag.Position = UDim2.new(0, scrPos.X, 0, scrPos.Y - 6)
                            ui.Label.Text = string.format("%s [%dm]", nadeType, math.floor(dist))
                            ui.Label.TextColor3 = nadeColor
                            ui.Tag.Visible = true

                            if showGrenadePath and part.AssemblyLinearVelocity and part.AssemblyLinearVelocity.Magnitude > 2 then
                                local vel = part.AssemblyLinearVelocity
                                local simPos = part.Position
                                local stepTime = 0.08
                                local grav = Vector3.new(0, -Workspace.Gravity, 0)
                                
                                grenadeRayParams.FilterDescendantsInstances = {player.Character, item, camera}

                                for step = 1, #ui.Lines do
                                    local nextPos = simPos + (vel * stepTime) + (0.5 * grav * stepTime * stepTime)
                                    vel = vel + (grav * stepTime)

                                    local castHit = Workspace:Raycast(simPos, nextPos - simPos, grenadeRayParams)
                                    if castHit then nextPos = castHit.Position end

                                    local p1, v1 = camera:WorldToViewportPoint(simPos)
                                    local p2, v2 = camera:WorldToViewportPoint(nextPos)

                                    if v1 and v2 and p1.Z > 0 and p2.Z > 0 then
                                        local lFrame = ui.Lines[step]
                                        local startV2 = Vector2.new(p1.X, p1.Y)
                                        local endV2 = Vector2.new(p2.X, p2.Y)
                                        local lDist = (endV2 - startV2).Magnitude
                                        local center = (startV2 + endV2) * 0.5
                                        local angle = math.deg(math.atan2(endV2.Y - startV2.Y, endV2.X - startV2.X))

                                        lFrame.Size = UDim2.new(0, lDist, 0, 1.2)
                                        lFrame.Position = UDim2.new(0, center.X, 0, center.Y)
                                        lFrame.Rotation = angle
                                        lFrame.BackgroundColor3 = nadeColor
                                        lFrame.Visible = true
                                    else
                                        ui.Lines[step].Visible = false
                                    end

                                    if castHit then
                                        for rem = step + 1, #ui.Lines do ui.Lines[rem].Visible = false end
                                        break
                                    end
                                    simPos = nextPos
                                end
                            else
                                for _, l in ipairs(ui.Lines) do l.Visible = false end
                            end

                            local shouldShowRadius = (nadeType == "MOLOTOV" and showMolotovRadius) or (nadeType == "SMOKE" and showSmokeRadius)
                            if shouldShowRadius then
                                grenadeRayParams.FilterDescendantsInstances = {player.Character, item, camera}
                                local groundCast = Workspace:Raycast(part.Position, Vector3.new(0, -60, 0), grenadeRayParams)
                                local groundPos = groundCast and groundCast.Position or part.Position
                                
                                local cCenter, cVisible = camera:WorldToViewportPoint(groundPos)
                                local cEdge, _ = camera:WorldToViewportPoint(groundPos + (camera.CFrame.RightVector * effectRadiusStuds))

                                if cVisible and cCenter.Z > 0 then
                                    local rPix = (Vector2.new(cEdge.X, cEdge.Y) - Vector2.new(cCenter.X, cCenter.Y)).Magnitude
                                    ui.RadiusCircle.Size = UDim2.new(0, rPix * 2, 0, rPix * 2)
                                    ui.RadiusCircle.Position = UDim2.new(0, cCenter.X, 0, cCenter.Y)
                                    ui.RadiusCircle.BackgroundTransparency = 1
                                    ui.RadiusStroke.Color = nadeColor
                                    ui.RadiusCircle.Visible = true
                                else
                                    ui.RadiusCircle.Visible = false
                                end
                            else
                                ui.RadiusCircle.Visible = false
                            end
                        else
                            ui.Tag.Visible = false
                            ui.RadiusCircle.Visible = false
                            for _, l in ipairs(ui.Lines) do l.Visible = false end
                        end
                    end
                end
            end
        end
    end

    for inst, data in pairs(grenadePool) do
        if not activeGrenades[inst] or not inst.Parent then
            data.Tag:Destroy()
            data.RadiusCircle:Destroy()
            for _, l in ipairs(data.Lines) do l:Destroy() end
            grenadePool[inst] = nil
        end
    end
end

-- ==========================================
-- TARGET SELECTION & AIMBOT MATHEMATICS
-- ==========================================
visRayParams = RaycastParams.new()
visRayParams.FilterType = Enum.RaycastFilterType.Exclude
visRayParams.IgnoreWater = true

function isTargetVisible(originPos, targetPart, targetChar)
    if not visibleCheck then return true end
    local myChar = player.Character
    visRayParams.FilterDescendantsInstances = {myChar, camera}
    local dir = targetPart.Position - originPos
    local hit = Workspace:Raycast(originPos, dir, visRayParams)
    if hit and (hit.Instance:IsDescendantOf(targetChar) or hit.Instance == targetPart) then
        return true
    end
    return false
end

function getClosestTarget()
    if not camera then 
        camera = Workspace.CurrentCamera 
        if not camera then return nil end
    end

    local closestTarget = nil
    local closestDist = aimFov
    local vp = camera.ViewportSize
    local screenCenter = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    local camPos = camera.CFrame.Position
    local allPlayers = Players:GetPlayers()

    for i = 1, #allPlayers do
        local plr = allPlayers[i]
        local char = plr.Character
        if char and plr ~= player and isTargetEnemy(plr, char) then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if isEntityAlive(char, hum) then
                local targetPart = getTargetHitbox(char)
                if targetPart then
                    local calcPos = targetPart.Position
                    local screenCalcPos = calcPos
                    if predictionEnabled and targetPart.AssemblyLinearVelocity then
                        screenCalcPos = calcPos + (targetPart.AssemblyLinearVelocity * predictionFactor)
                    end
                    local screenPos, onScreen = camera:WorldToViewportPoint(screenCalcPos)
                    if onScreen and screenPos.Z > 0 then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if screenDist <= closestDist then
                            if isTargetVisible(camPos, targetPart, char) then
                                closestDist = screenDist
                                closestTarget = {
                                    Player = plr,
                                    Char = char,
                                    Part = targetPart,
                                    Hum = hum,
                                    Position = calcPos,
                                    AimPosition = screenCalcPos,
                                    ScreenPosition = Vector2.new(screenPos.X, screenPos.Y),
                                    Distance = screenDist
                                }
                            end
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

-- ==========================================
-- TRIGGERBOT PROCESSING LOGIC
-- ==========================================
triggerRayParams = RaycastParams.new()
triggerRayParams.FilterType = Enum.RaycastFilterType.Exclude
triggerRayParams.IgnoreWater = true

function runMobileTriggerbot()
    if not triggerbotEnabled then return end
    local now = tick()
    if (now - lastTriggerTick) < triggerbotDelay then return end

    local vp = camera.ViewportSize
    local ray = camera:ViewportPointToRay(vp.X * 0.5, vp.Y * 0.5)
    triggerRayParams.FilterDescendantsInstances = {player.Character, camera}
    
    local res = Workspace:Raycast(ray.Origin, ray.Direction * 1000, triggerRayParams)
    if res and res.Instance then
        local hitChar = res.Instance.Parent
        local hitPlr = Players:GetPlayerFromCharacter(hitChar)
        if not hitPlr and hitChar and hitChar.Parent then
            hitPlr = Players:GetPlayerFromCharacter(hitChar.Parent)
            hitChar = hitChar.Parent
        end

        if hitPlr and isTargetEnemy(hitPlr, hitChar) then
            local hum = hitChar:FindFirstChildOfClass("Humanoid")
            if isEntityAlive(hitChar, hum) then
                if triggerbotHeadOnly and res.Instance.Name ~= "Head" then return end
                lastTriggerTick = now
                if triggerbotMobileAutoFire then
                    pcall(function()
                        local myChar = player.Character
                        local equippedTool = myChar and myChar:FindFirstChildOfClass("Tool")
                        if equippedTool then
                            equippedTool:Activate()
                        elseif VirtualInputManager then
                            pcall(function() VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, true, game, 0) end)
                            task.wait(0.01)
                            pcall(function() VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, false, game, 0) end)
                        end
                    end)
                end
            end
        end
    end
end

-- ==========================================
-- 2D ESP COMPONENT CACHE FACTORY
-- ==========================================
function getOrCreateScreenEsp(plr)
    if screenEspCache[plr] then return screenEspCache[plr] end

    local box = Instance.new("Frame", overlayContainer)
    box.Name = "Box_" .. plr.Name
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false

    local stroke = Instance.new("UIStroke", box)
    stroke.Color = currentTheme.Enemy_Accent
    stroke.Thickness = boxThickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local healthBarBg = Instance.new("Frame", overlayContainer)
    healthBarBg.Name = "HealthBg_" .. plr.Name
    healthBarBg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Visible = false
    Instance.new("UICorner", healthBarBg).CornerRadius = UDim.new(0, 2)
    local hbStroke = Instance.new("UIStroke", healthBarBg)
    hbStroke.Color = Color3.fromRGB(35, 38, 45)
    hbStroke.Thickness = 0.8

    local healthBarFill = Instance.new("Frame", healthBarBg)
    healthBarFill.Name = "Fill"
    healthBarFill.AnchorPoint = Vector2.new(0, 1)
    healthBarFill.Position = UDim2.new(0, 0, 1, 0)
    healthBarFill.Size = UDim2.new(1, 0, 1, 0)
    healthBarFill.BackgroundColor3 = currentTheme.HealthHigh
    healthBarFill.BorderSizePixel = 0
    Instance.new("UICorner", healthBarFill).CornerRadius = UDim.new(0, 2)

    local healthGradient = Instance.new("UIGradient", healthBarFill)
    healthGradient.Rotation = 90
    healthGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
    })

    local corners = {}
    for i = 1, 4 do
        local hLine = Instance.new("Frame", overlayContainer)
        hLine.Name = "CornerH_" .. plr.Name .. "_" .. i
        hLine.BackgroundColor3 = currentTheme.Enemy_Accent
        hLine.BorderSizePixel = 0
        hLine.Visible = false

        local vLine = Instance.new("Frame", overlayContainer)
        vLine.Name = "CornerV_" .. plr.Name .. "_" .. i
        vLine.BackgroundColor3 = currentTheme.Enemy_Accent
        vLine.BorderSizePixel = 0
        vLine.Visible = false

        table.insert(corners, {H = hLine, V = vLine})
    end

    local tagCard = Instance.new("Frame", overlayContainer)
    tagCard.Name = "TagCard_" .. plr.Name
    tagCard.AnchorPoint = Vector2.new(0.5, 1)
    tagCard.Size = UDim2.new(0, 0, 0, 16)
    tagCard.AutomaticSize = Enum.AutomaticSize.X
    tagCard.BackgroundColor3 = tagBgColor
    tagCard.BackgroundTransparency = tagTransparency
    tagCard.BorderSizePixel = 0
    tagCard.Visible = false

    Instance.new("UICorner", tagCard).CornerRadius = UDim.new(0, 4)
    local cardStroke = Instance.new("UIStroke", tagCard)
    cardStroke.Color = currentTheme.Border
    cardStroke.Thickness = 0.8

    local pad = Instance.new("UIPadding", tagCard)
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 6)

    local tagLabel = Instance.new("TextLabel", tagCard)
    tagLabel.AutomaticSize = Enum.AutomaticSize.X
    tagLabel.Size = UDim2.new(0, 0, 1, 0)
    tagLabel.BackgroundTransparency = 1
    tagLabel.TextColor3 = currentTheme.NametagTextColor
    tagLabel.TextSize = espTextSize
    tagLabel.Font = Enum.Font.GothamBold

    local data = {
        Box = box,
        BoxStroke = stroke,
        HealthBarBg = healthBarBg,
        HealthBarFill = healthBarFill,
        Corners = corners,
        TagCard = tagCard,
        TagCardStroke = cardStroke,
        TagLabel = tagLabel,
        LastText = ""
    }
    screenEspCache[plr] = data
    return data
end

table.insert(connections, Players.PlayerRemoving:Connect(function(plr)
    local oldChar = plr.Character
    local oldHum = oldChar and oldChar:FindFirstChildOfClass("Humanoid")
    if oldHum then
        hitmarkerLastHealth[oldHum] = nil
    end

    local cache = screenEspCache[plr]
    if cache then
        pcall(function()
            cache.Box:Destroy()
            cache.HealthBarBg:Destroy()
            cache.TagCard:Destroy()
            for _, corner in pairs(cache.Corners) do
                corner.H:Destroy()
                corner.V:Destroy()
            end
        end)
        screenEspCache[plr] = nil
    end
end))

-- ==========================================
-- TACTICAL ESP SCREEN RENDER LOOP
-- ==========================================
function renderTacticalOverlay()
    local camPos = camera.CFrame.Position
    local allPlayers = Players:GetPlayers()

    for i = 1, #allPlayers do
        local plr = allPlayers[i]
        local esp = getOrCreateScreenEsp(plr)
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local rootPart = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        local head = char and char:FindFirstChild("Head")

        local isEnemy = isTargetEnemy(plr, char)
        local isAlive = isEntityAlive(char, hum)

        if isEnemy and isAlive and rootPart and (nametagsEnabled or boxEspEnabled or cornerBoxEnabled) then
            local dist = (rootPart.Position - camPos).Magnitude

            if dist <= espMaxDist then
                local isVisible = isVisibleThroughWalls(head or rootPart, char)
                local sideColor = isVisible and currentTheme.Enemy_Accent or currentTheme.Enemy_Hidden

                local headOffset = head and Vector3.new(0, 0.6, 0) or Vector3.new(0, 2.0, 0)
                local topWorld = (head and head.Position or rootPart.Position) + headOffset
                local bottomWorld = rootPart.Position - Vector3.new(0, 3.0, 0)

                local topScreen, topVisible = camera:WorldToViewportPoint(topWorld)
                local bottomScreen, _ = camera:WorldToViewportPoint(bottomWorld)

                if topVisible and topScreen.Z > 0 then
                    local boxHeight = math.abs(bottomScreen.Y - topScreen.Y)
                    local boxWidth = boxHeight * 0.65
                    local boxPosX = topScreen.X - (boxWidth * 0.5)
                    local boxPosY = topScreen.Y

                    if boxEspEnabled and not cornerBoxEnabled then
                        esp.BoxStroke.Color = sideColor
                        esp.BoxStroke.Thickness = boxThickness
                        esp.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                        esp.Box.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                        esp.Box.Visible = true
                        for _, corner in ipairs(esp.Corners) do
                            corner.H.Visible = false
                            corner.V.Visible = false
                        end
                    elseif cornerBoxEnabled then
                        esp.Box.Visible = false
                        local lengthX = math.max(boxWidth * 0.25, 4)
                        local lengthY = math.max(boxHeight * 0.25, 4)
                        local thick = boxThickness + 0.5

                        for _, corner in ipairs(esp.Corners) do
                            corner.H.BackgroundColor3 = sideColor
                            corner.V.BackgroundColor3 = sideColor
                        end

                        esp.Corners[1].H.Size = UDim2.new(0, lengthX, 0, thick)
                        esp.Corners[1].H.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                        esp.Corners[1].H.Visible = true

                        esp.Corners[1].V.Size = UDim2.new(0, thick, 0, lengthY)
                        esp.Corners[1].V.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                        esp.Corners[1].V.Visible = true

                        esp.Corners[2].H.Size = UDim2.new(0, lengthX, 0, thick)
                        esp.Corners[2].H.Position = UDim2.new(0, boxPosX + boxWidth - lengthX, 0, boxPosY)
                        esp.Corners[2].H.Visible = true

                        esp.Corners[2].V.Size = UDim2.new(0, thick, 0, lengthY)
                        esp.Corners[2].V.Position = UDim2.new(0, boxPosX + boxWidth - thick, 0, boxPosY)
                        esp.Corners[2].V.Visible = true

                        esp.Corners[3].H.Size = UDim2.new(0, lengthX, 0, thick)
                        esp.Corners[3].H.Position = UDim2.new(0, boxPosX, 0, boxPosY + boxHeight - thick)
                        esp.Corners[3].H.Visible = true

                        esp.Corners[3].V.Size = UDim2.new(0, thick, 0, lengthY)
                        esp.Corners[3].V.Position = UDim2.new(0, boxPosX, 0, boxPosY + boxHeight - lengthY)
                        esp.Corners[3].V.Visible = true

                        esp.Corners[4].H.Size = UDim2.new(0, lengthX, 0, thick)
                        esp.Corners[4].H.Position = UDim2.new(0, boxPosX + boxWidth - lengthX, 0, boxPosY + boxHeight - thick)
                        esp.Corners[4].H.Visible = true

                        esp.Corners[4].V.Size = UDim2.new(0, thick, 0, lengthY)
                        esp.Corners[4].V.Position = UDim2.new(0, boxPosX + boxWidth - thick, 0, boxPosY + boxHeight - lengthY)
                        esp.Corners[4].V.Visible = true
                    else
                        esp.Box.Visible = false
                        for _, corner in ipairs(esp.Corners) do
                            corner.H.Visible = false
                            corner.V.Visible = false
                        end
                    end

                    if (boxEspEnabled or cornerBoxEnabled) and healthBarEnabled and hum then
                        local maxHp = hum.MaxHealth > 0 and hum.MaxHealth or 100
                        local curHp = math.clamp(hum.Health, 0, maxHp)
                        local hpPercent = math.clamp(curHp / maxHp, 0, 1)

                        local barWidth = 3
                        local barGap = 4
                        local barX = boxPosX - barWidth - barGap
                        local barY = boxPosY

                        esp.HealthBarBg.Size = UDim2.new(0, barWidth, 0, boxHeight)
                        esp.HealthBarBg.Position = UDim2.new(0, barX, 0, barY)
                        esp.HealthBarBg.Visible = true

                        esp.HealthBarFill.Size = UDim2.new(1, 0, hpPercent, 0)
                        
                        if hpPercent > 0.5 then
                            local t = (hpPercent - 0.5) * 2
                            esp.HealthBarFill.BackgroundColor3 = currentTheme.HealthMid:Lerp(currentTheme.HealthHigh, t)
                        else
                            local t = hpPercent * 2
                            esp.HealthBarFill.BackgroundColor3 = currentTheme.HealthLow:Lerp(currentTheme.HealthMid, t)
                        end
                    else
                        esp.HealthBarBg.Visible = false
                    end

                    if nametagsEnabled then
                        esp.TagCard.BackgroundTransparency = tagTransparency
                        esp.TagCardStroke.Color = currentTheme.Border
                        esp.TagLabel.TextSize = espTextSize

                        local baseName = plr.DisplayName or plr.Name
                        local infoText = baseName
                        
                        if espShowDistance then
                            infoText = string.format("%s [%dm]", infoText, math.floor(dist))
                        end
                        if espShowHealth and hum then
                            local curHealth = math.floor(hum.Health)
                            infoText = string.format("%s [%dHP]", infoText, curHealth > 0 and curHealth or 100)
                        end
                        if tagShowWeapon then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then
                                infoText = string.format("%s {%s}", infoText, tool.Name)
                            end
                        end

                        if esp.LastText ~= infoText then
                            esp.TagLabel.Text = infoText
                            esp.LastText = infoText
                        end

                        esp.TagCard.Position = UDim2.new(0, topScreen.X, 0, topScreen.Y - 4)
                        esp.TagCard.Visible = true
                    else
                        esp.TagCard.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.HealthBarBg.Visible = false
                    for _, corner in ipairs(esp.Corners) do
                        corner.H.Visible = false
                        corner.V.Visible = false
                    end
                    esp.TagCard.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.HealthBarBg.Visible = false
                for _, corner in ipairs(esp.Corners) do
                    corner.H.Visible = false
                    corner.V.Visible = false
                end
                esp.TagCard.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.HealthBarBg.Visible = false
            for _, corner in ipairs(esp.Corners) do
                corner.H.Visible = false
                corner.V.Visible = false
            end
            esp.TagCard.Visible = false
        end
    end
end

-- ==========================================
-- 3D ESP ATTACHMENT PIPELINE
-- ==========================================
function attachEspToPlayer(plr)
    if plr == player then return end

    local holder = Instance.new("Folder")
    holder.Name = "GestioESP_" .. plr.Name
    holder.Parent = mainContainer

    local dotBillboard = Instance.new("BillboardGui", holder)
    dotBillboard.Size = UDim2.new(0, 6, 0, 6)
    dotBillboard.StudsOffset = Vector3.new(0, 0.5, 0)
    dotBillboard.AlwaysOnTop = true
    dotBillboard.Enabled = false

    local dotFrame = Instance.new("Frame", dotBillboard)
    dotFrame.Size = UDim2.new(1, 0, 1, 0)
    dotFrame.BackgroundColor3 = currentTheme.Enemy_Accent
    dotFrame.BorderSizePixel = 0
    Instance.new("UICorner", dotFrame).CornerRadius = UDim.new(1, 0)

    local tracerLine = Instance.new("Frame", mainContainer)
    tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
    tracerLine.BorderSizePixel = 0
    tracerLine.BackgroundColor3 = currentTheme.Enemy_Accent
    tracerLine.Visible = false

    local hl = Instance.new("Highlight")
    hl.Name = "GestioHighlight_" .. plr.Name
    hl.FillTransparency = 0.45
    hl.OutlineTransparency = 0.0
    hl.Enabled = false
    hl.FillColor = currentTheme.Enemy_Fill
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = holder

    local espData = {
        Holder = holder,
        HeadDot = dotBillboard,
        DotFrame = dotFrame,
        Tracer = tracerLine,
        Highlight = hl
    }
    activeEspHolders[plr] = espData

    local function setupCharacter(char)
        if not char then return end
        task.spawn(function()
            local head = char:WaitForChild("Head", 3)
            if head and dotBillboard then
                dotBillboard.Adornee = head
            end
            if hl then
                hl.Adornee = char
            end
        end)
    end

    if plr.Character then setupCharacter(plr.Character) end
    local charConn = plr.CharacterAdded:Connect(setupCharacter)
    table.insert(connections, charConn)
end

for _, v in pairs(Players:GetPlayers()) do attachEspToPlayer(v) end
table.insert(connections, Players.PlayerAdded:Connect(attachEspToPlayer))

-- ==========================================
-- MAIN ENGINE RENDER LOOP
-- ==========================================
table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    camera = Workspace.CurrentCamera or camera
    if not camera then return end
    local localPos = camera.CFrame.Position

    fpsCounter = fpsCounter + 1
    local nowTick = tick()
    if nowTick - lastFpsUpdate >= 0.5 then
        local currentFps = math.floor(fpsCounter / (nowTick - lastFpsUpdate))
        local pingVal = 0
        pcall(function()
            local serverStats = Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem")
            if serverStats and serverStats:FindFirstChild("Data Ping") then
                pingVal = math.floor(serverStats["Data Ping"]:GetValue())
            end
        end)
        wmMetrics.Text = string.format("FPS: %d | PING: %dms", currentFps, pingVal)
        fpsCounter = 0
        lastFpsUpdate = nowTick
    end

    if fovFrame then
        local isFovVisible = aimbotEnabled and showFovCircle
        fovFrame.Visible = isFovVisible
        if isFovVisible then
            local diameter = aimFov * 2
            fovFrame.Size = UDim2.new(0, diameter, 0, diameter)
        end
    end

    -- Smooth Non-Intrusive RCS / No Recoil Drag while shooting
    if (rcsEnabled or noRecoil.enabled) and noRecoil.isShooting then
        local comp = (noRecoil.enabled and (noRecoil.strength * 0.0035) or 0) + (rcsEnabled and ((rcsStrength / 100) * 0.004 * rcsPitchFactor) or 0)
        camera.CFrame = camera.CFrame * CFrame.Angles(-comp, 0, 0)
    end

    isAiming = aimbotEnabled

    if aimbotEnabled and isAiming then
        if not lockedTarget or not isEntityAlive(lockedTarget.Char, lockedTarget.Hum) then
            lockedTarget = getClosestTarget()
        else
            local checkPos = lockedTarget.Position
            if predictionEnabled and lockedTarget.Part and lockedTarget.Part.Parent then
                checkPos = lockedTarget.Part.Position
                local velocity = lockedTarget.Part.AssemblyLinearVelocity
                if velocity then
                    checkPos += velocity * predictionFactor
                end
            end
            local scrPos, onScreen = camera:WorldToViewportPoint(checkPos)
            local vp = camera.ViewportSize
            local screenDist = (Vector2.new(scrPos.X, scrPos.Y) - Vector2.new(vp.X * 0.5, vp.Y * 0.5)).Magnitude
            if not onScreen or scrPos.Z <= 0 or screenDist > aimFov then
                lockedTarget = getClosestTarget()
            end
        end

        if lockedTarget and lockedTarget.Position then
            local aimPos = lockedTarget.AimPosition or lockedTarget.Position
            if predictionEnabled and lockedTarget.Part and lockedTarget.Part.Parent then
                aimPos = lockedTarget.Part.Position
                if lockedTarget.Part.AssemblyLinearVelocity then
                    aimPos += lockedTarget.Part.AssemblyLinearVelocity * predictionFactor
                end
            end

            local desired = CFrame.lookAt(camera.CFrame.Position, aimPos)
            if snapAimMode then
                camera.CFrame = desired
            else
                local smooth = math.clamp(aimbotSmoothness, 0, 0.98)
                local speedAlpha = 1 - math.exp(-math.max(1, aimbotSpeed) * dt)
                local alpha = math.clamp(speedAlpha * (1 - smooth), 0.01, 1)
                camera.CFrame = camera.CFrame:Lerp(desired, alpha)
            end
        end
    else
        lockedTarget = nil
    end

    if butterflyKnifeEnabled then
        skinScanAccumulator += dt
        if skinScanAccumulator >= 0.50 then
            skinScanAccumulator = 0
            scanAndMorphKnives(Workspace)
            scanAndMorphKnives(camera)
            hookBloxStrikeModules()
        end
    else
        skinScanAccumulator = 0
    end

    runMobileTriggerbot()
    renderTacticalOverlay()
    renderGrenadeOverlays()

    for plr, data in pairs(activeEspHolders) do
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local rootPart = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        local head = char and char:FindFirstChild("Head")
        
        local isEnemy = isTargetEnemy(plr, char)
        local isAlive = isEntityAlive(char, hum)
        local dist = rootPart and (rootPart.Position - localPos).Magnitude or 9999

        if char and isEnemy and isAlive and (dist <= espMaxDist) then
            local isVisible = isVisibleThroughWalls(head or rootPart, char)
            local activeAccent = isVisible and currentTheme.Enemy_Accent or currentTheme.Enemy_Hidden
            local activeHighlight = isVisible and currentTheme.Enemy_Fill or currentTheme.Enemy_Hidden

            if data.Highlight.Adornee ~= char then
                data.Highlight.Adornee = char
            end
            if head and data.HeadDot.Adornee ~= head then
                data.HeadDot.Adornee = head
            end

            data.Highlight.FillColor = activeHighlight
            data.Highlight.Enabled = highlightEnabled

            data.DotFrame.BackgroundColor3 = activeAccent
            data.HeadDot.Enabled = headDotEnabled

            if tracersEnabled and rootPart then
                local scrPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                if onScreen and scrPos.Z > 0 then
                    local origin = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y)
                    local dest = Vector2.new(scrPos.X, scrPos.Y)
                    local lineDist = (dest - origin).Magnitude
                    local center = (origin + dest) * 0.5
                    local angle = math.deg(math.atan2(dest.Y - origin.Y, dest.X - origin.X))

                    data.Tracer.BackgroundColor3 = activeAccent
                    data.Tracer.Size = UDim2.new(0, lineDist, 0, 1.5)
                    data.Tracer.Position = UDim2.new(0, center.X, 0, center.Y)
                    data.Tracer.Rotation = angle
                    data.Tracer.Visible = true
                else
                    data.Tracer.Visible = false
                end
            else
                data.Tracer.Visible = false
            end
        else
            data.HeadDot.Enabled = false
            data.Highlight.Enabled = false
            data.Tracer.Visible = false
            if data.Highlight.Adornee then
                data.Highlight.Adornee = nil
            end
            if data.HeadDot.Adornee then
                data.HeadDot.Adornee = nil
            end
        end
    end

    if fullBrightEnabled then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    elseif nightModeEnabled then
        local cfg = nightPresets[nightPreset] or nightPresets["Midnight"]
        Lighting.Brightness = nightBrightness or cfg.Brightness
        Lighting.ClockTime = nightClockTime or cfg.ClockTime
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = nightOutdoorAmbient or cfg.OutdoorAmbient
        Lighting.Ambient = cfg.Ambient
    end

    if removeFogEnabled then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = defaultLighting.FogEnd
    end
    if antiFlashEnabled then
        pcall(function()
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("ColorCorrectionEffect") and v.Saturation < -0.5 then v.Enabled = false end
            end
        end)
    end
end))

-- ==========================================
-- ANTI-AIM ROTATION LOOP
-- ==========================================
table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not antiAimEnabled then
        if hum and savedAutoRotate ~= nil then
            hum.AutoRotate = savedAutoRotate
            savedAutoRotate = nil
        end
        return
    end

    if not hrp or not hum or hum.Health <= 0 then return end

    if savedAutoRotate == nil then
        savedAutoRotate = hum.AutoRotate
        hum.AutoRotate = false
    end

    currentSpinAngle = (currentSpinAngle + (spinSpeed * dt * 60)) % 360
    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(currentSpinAngle), 0)
end))

-- ==========================================
-- RAYCAST GROUND CHECK
-- ==========================================
groundRayParams = RaycastParams.new()
groundRayParams.FilterType = Enum.RaycastFilterType.Exclude
groundRayParams.IgnoreWater = true

function isPlayerGrounded(char, hrp)
    groundRayParams.FilterDescendantsInstances = {char, camera}
    local origin = hrp.Position
    local direction = Vector3.new(0, -3.2, 0)
    local hit = Workspace:Raycast(origin, direction, groundRayParams)
    return hit ~= nil
end

-- ==========================================
-- MOBILE INPUT TOUCH HOOK & SLIDE BUTTON
-- ==========================================
function captureDefaultHipHeight(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Parent then
        defaultHipHeight = hum.HipHeight
        defaultHipHeightCaptured = true
    end
end

function restoreDefaultHipHeight()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.HipHeight = defaultHipHeightCaptured and defaultHipHeight or hum.HipHeight
    end
end

local mobileSlideDragging = false
local mobileSlideToggleActive = false

function positionMobileSlideButton(jumpBtn)
    if not mobileSlideBtn or not jumpBtn then return end
    mobileSlideBtn.Position = UDim2.new(
        jumpBtn.Position.X.Scale,
        jumpBtn.Position.X.Offset - 60,
        jumpBtn.Position.Y.Scale,
        jumpBtn.Position.Y.Offset
    )
end

function updateMobileSlideIndicator()
    if not mobileSlideBtn then return end

    local stroke = mobileSlideBtn:FindFirstChild("GestioSlideStroke")
    if mobileSlideToggleActive then
        mobileSlideBtn.BackgroundColor3 = currentTheme.Accent
        mobileSlideBtn.BackgroundTransparency = 0.08
        mobileSlideBtn.TextColor3 = currentTheme.TextPrimary
        if stroke then
            stroke.Color = currentTheme.Accent
            stroke.Thickness = 2
        end
    else
        mobileSlideBtn.BackgroundColor3 = currentTheme.CardBg
        mobileSlideBtn.BackgroundTransparency = 0.3
        mobileSlideBtn.TextColor3 = currentTheme.Accent
        if stroke then
            stroke.Color = currentTheme.Border
            stroke.Thickness = 1.2
        end
    end
end

function updateMobileSlideVisibility()
    if mobileSlideBtn then
        mobileSlideBtn.Visible = slideEnabled and UserInputService.TouchEnabled

        if not slideEnabled then
            mobileSlideToggleActive = false
            isSliding = false
            currentSlideVel = Vector3.zero
            updateMobileSlideIndicator()
        end
    end
end

function triggerMobileSlideStart()
    if not slideEnabled then return false end

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not (hrp and hum and isEntityAlive(char, hum) and isPlayerGrounded(char, hrp)) then
        return false
    end

    local moveDir = hum.MoveDirection
    if moveDir.Magnitude <= 0.1 then
        moveDir = hrp.CFrame.LookVector
    end

    currentSlideVel = moveDir * (16 * slideSpeedBoost)
    isSliding = true
    hum.HipHeight = defaultHipHeight * 0.4
    return true
end

function triggerMobileSlideEnd()
    isSliding = false
    currentSlideVel = Vector3.zero

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.HipHeight = defaultHipHeightCaptured and defaultHipHeight or hum.HipHeight
    end
end

function toggleMobileSlide()
    if not slideEnabled then return end

    if mobileSlideToggleActive then
        mobileSlideToggleActive = false
        triggerMobileSlideEnd()
    else
        if triggerMobileSlideStart() then
            mobileSlideToggleActive = true
        end
    end

    updateMobileSlideIndicator()
end

function createMobileSlideButton()
    if mobileSlideBtn then
        updateMobileSlideVisibility()
        return
    end

    mobileSlideBtn = Instance.new("TextButton")
    mobileSlideBtn.Name = "GestioMobileSlideBtn"
    mobileSlideBtn.Size = UDim2.new(0, 50, 0, 50)
    mobileSlideBtn.Position = UDim2.new(1, -145, 1, -115)
    mobileSlideBtn.BackgroundColor3 = currentTheme.CardBg
    mobileSlideBtn.BackgroundTransparency = 0.3
    mobileSlideBtn.Text = "SLIDE"
    mobileSlideBtn.TextColor3 = currentTheme.Accent
    mobileSlideBtn.TextSize = 9.5
    mobileSlideBtn.Font = Enum.Font.GothamBold
    mobileSlideBtn.Visible = slideEnabled and UserInputService.TouchEnabled
    mobileSlideBtn.ZIndex = 80
    mobileSlideBtn.Active = true
    mobileSlideBtn.AutoButtonColor = false
    mobileSlideBtn.Parent = mainContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = mobileSlideBtn

    local stroke = Instance.new("UIStroke")
    stroke.Name = "GestioSlideStroke"
    stroke.Color = currentTheme.Border
    stroke.Thickness = 1.2
    stroke.Parent = mobileSlideBtn

    local tapConn = mobileSlideBtn.Activated:Connect(function()
        if mobileSlideDragging then
            mobileSlideDragging = false
            return
        end
        toggleMobileSlide()
    end)
    table.insert(connections, tapConn)

    local dragStart = nil
    local buttonStart = nil
    local dragConn = mobileSlideBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            buttonStart = mobileSlideBtn.Position
            mobileSlideDragging = false
        end
    end)
    table.insert(connections, dragConn)

    local changedConn = mobileSlideBtn.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not dragStart or not buttonStart then return end

        local delta = input.Position - dragStart
        if math.abs(delta.X) > 10 or math.abs(delta.Y) > 10 then
            mobileSlideDragging = true
            mobileSlideBtn.Position = UDim2.new(
                buttonStart.X.Scale,
                buttonStart.X.Offset + delta.X,
                buttonStart.Y.Scale,
                buttonStart.Y.Offset + delta.Y
            )
        end
    end)
    table.insert(connections, changedConn)

    updateMobileSlideIndicator()
end

function hookMobileJumpButton()
    task.spawn(function()
        local pGui = player:WaitForChild("PlayerGui", 5)
        if not pGui then return end
        local touchGui = pGui:WaitForChild("TouchGui", 5)
        if not touchGui then return end
        local controlFrame = touchGui:WaitForChild("TouchControlFrame", 5)
        if not controlFrame then return end
        local jumpBtn = controlFrame:WaitForChild("JumpButton", 5)
        if not jumpBtn then return end

        if mobileJumpHookedButton == jumpBtn then
            positionMobileSlideButton(jumpBtn)
            return
        end

        for _, conn in ipairs(mobileJumpConnections) do
            pcall(function() conn:Disconnect() end)
        end
        mobileJumpConnections = {}
        mobileJumpHookedButton = jumpBtn

        local jConn1 = jumpBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                isMobileJumpHeld = true
            end
        end)
        table.insert(mobileJumpConnections, jConn1)
        table.insert(connections, jConn1)

        local jConn2 = jumpBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                isMobileJumpHeld = false
            end
        end)
        table.insert(mobileJumpConnections, jConn2)
        table.insert(connections, jConn2)

        positionMobileSlideButton(jumpBtn)
    end)
end

createMobileSlideButton()
hookMobileJumpButton()

function hookCharacterWeapons(char)
    if not char then return end
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            scanAndMorphKnives(child)
        end
    end)
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            scanAndMorphKnives(tool)
        end
    end
end

table.insert(connections, player.CharacterAdded:Connect(function(char)
    thirdPersonPreviousOffset = nil
    task.defer(function()
        if thirdPersonEnabled then
            applyThirdPerson()
        end
    end)
    mobileSlideToggleActive = false
    mobileSlideDragging = false
    isSliding = false
    currentSlideVel = Vector3.zero
    mobileSlideInputActive = false
    mobileSlideInput = nil
    defaultHipHeightCaptured = false
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        defaultHipHeight = hum.HipHeight
        defaultHipHeightCaptured = true
        hum.HipHeight = defaultHipHeight
    end
    hookMobileJumpButton()
    hookCharacterWeapons(char)
end))

if player.Character then
    captureDefaultHipHeight(player.Character)
    hookCharacterWeapons(player.Character)
end

local jumpReqConn = UserInputService.JumpRequest:Connect(function()
    isMobileJumpHeld = true
end)
table.insert(connections, jumpReqConn)

local inBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.Space then
        isMobileJumpHeld = true
    end

    if slideEnabled and (input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.LeftControl) then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and isEntityAlive(char, hum) and isPlayerGrounded(char, hrp) then
            if not defaultHipHeightCaptured then captureDefaultHipHeight(char) end
            local moveDir = hum.MoveDirection.Magnitude > 0.1 and hum.MoveDirection or hrp.CFrame.LookVector
            currentSlideVel = moveDir * (16 * slideSpeedBoost)
            isSliding = true
            hum.HipHeight = defaultHipHeight * 0.4
        end
    end
end)
table.insert(connections, inBeganConn)

local inEndedConn = UserInputService.InputEnded:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.Space then
        isMobileJumpHeld = false
    end
    if input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.LeftControl then
        isSliding = false
        currentSlideVel = Vector3.zero
        restoreDefaultHipHeight()
    end
end)
table.insert(connections, inEndedConn)

-- ==========================================
-- HITMARKER TARGET HEALTH MONITOR (ALL ENEMIES)
-- ==========================================
table.insert(connections, RunService.Heartbeat:Connect(function()
    if not hitmarkerEnabled then
        hitmarkerLastHealth = {}
        return
    end

    for _, targetPlr in ipairs(Players:GetPlayers()) do
        if targetPlr ~= player then
            local char = targetPlr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if char and hum and isTargetEnemy(targetPlr, char) and isEntityAlive(char, hum) then
                local currentHealth = hum.Health
                local previousHealth = hitmarkerLastHealth[hum]

                if previousHealth and currentHealth < previousHealth and (previousHealth - currentHealth) > 0.01 then
                    showHitmarker()
                end

                hitmarkerLastHealth[hum] = currentHealth
            end
        end
    end
end))

-- ==========================================
-- UNIFIED PHYSICS & KINEMATICS HEARTBEAT
-- ==========================================
table.insert(connections, RunService.Heartbeat:Connect(function(dt)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or not isEntityAlive(char, hum) then return end

    local currentMove = hum.MoveDirection
    if currentMove.Magnitude > 0.05 then
        lastMoveDirection = currentMove
    end

    local currentVel = hrp.AssemblyLinearVelocity
    local finalVelocity = nil
    local activeMode = "Normal"

    -- 1. FLIGHT
    if flightEnabled then
        activeMode = "Flight"
        local camLook = camera.CFrame.LookVector
        finalVelocity = camLook * flightSpeed

    -- 2. SLIDE
    elseif slideEnabled and isSliding then
        local grounded = isPlayerGrounded(char, hrp)
        if grounded and currentSlideVel.Magnitude > slideMinSpeed then
            activeMode = "Slide"
            local frictionFactor = math.pow(
                math.clamp(slideFriction, 0, 1),
                math.max(dt, 0) * 60
            )
            currentSlideVel = currentSlideVel * frictionFactor
            finalVelocity = Vector3.new(
                currentSlideVel.X,
                currentVel.Y,
                currentSlideVel.Z
            )
        else
            isSliding = false
            currentSlideVel = Vector3.zero
            restoreDefaultHipHeight()
        end
    end

    -- 3. BHOP + AUTO STRAFE
    if activeMode == "Normal" and bunnyHopEnabled then
        local grounded = isPlayerGrounded(char, hrp) or hum.FloorMaterial ~= Enum.Material.Air
        local shouldJump = bhopAutoJump or isMobileJumpHeld or hum.Jump

        if grounded and shouldJump then
            activeMode = "Bhop"
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            finalVelocity = Vector3.new(
                currentVel.X,
                bhopJumpPower,
                currentVel.Z
            )
        elseif not grounded and bhopAirStrafe and currentMove.Magnitude > 0.05 then
            activeMode = "AutoStrafe"
            local targetSpeed = 16 * bhopSpeedBoost
            local targetVel = currentMove * targetSpeed
            finalVelocity = Vector3.new(
                targetVel.X,
                currentVel.Y,
                targetVel.Z
            )
        end
    end

    -- 4. SPEED
    if activeMode == "Normal" and speedEnabled and hum.MoveDirection.Magnitude > 0 then
        activeMode = "Speed"
        local targetVel = hum.MoveDirection * (16 * walkMultiplier)
        finalVelocity = Vector3.new(
            targetVel.X,
            currentVel.Y,
            targetVel.Z
        )
    end

    if finalVelocity then
        hrp.AssemblyLinearVelocity = finalVelocity
    end
end))

-- ==========================================
-- UI SCOPE FIX & DYNAMIC LAYOUT CALCULATION
-- ==========================================
function setAntiAfkEnabled(enabled)
    antiAfkEnabled = enabled
    if antiAfkConnection then
        pcall(function() antiAfkConnection:Disconnect() end)
        antiAfkConnection = nil
    end
    if not antiAfkEnabled then return end

    antiAfkConnection = player.Idled:Connect(function()
        pcall(function()
            if VirtualInputManager then
                VirtualInputManager:SendMouseButtonEvent(1, 1, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(1, 1, 0, false, game, 0)
            end
        end)
    end)
end

function buildGestioUI()
setAntiAfkEnabled(antiAfkEnabled)

-- ==========================================
-- FLOATING UI LAUNCHER
-- ==========================================
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "GestioToggleGui"
toggleGui.ResetOnSpawn = false
toggleGui.DisplayOrder = 100
toggleGui.IgnoreGuiInset = true
toggleGui.Parent = targetGui

local openBtn = Instance.new("TextButton", toggleGui)
openBtn.Size = UDim2.new(0, 85, 0, 30)
openBtn.Position = savedPos.OpenBtn
openBtn.BackgroundColor3 = currentTheme.Background
openBtn.Text = "Gestio"
openBtn.TextColor3 = currentTheme.Accent
openBtn.TextSize = 11
openBtn.Font = Enum.Font.GothamBold
openBtn.Active = true
openBtn.AutoButtonColor = false
openBtn.ZIndex = 100
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)
local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = currentTheme.Border

-- ==========================================
-- MASTER VIEWPORT WINDOW
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GestioScreenGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 50
screenGui.IgnoreGuiInset = true
screenGui.Parent = targetGui

local masterFrame = Instance.new("Frame", screenGui)
masterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
masterFrame.Size = UDim2.new(0.90, 0, 0.82, 0)
masterFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
masterFrame.BackgroundTransparency = 1
masterFrame.Visible = true

local sizeConstraint = Instance.new("UISizeConstraint", masterFrame)
sizeConstraint.MaxSize = Vector2.new(740, 320)
sizeConstraint.MinSize = Vector2.new(300, 200)

local masterLayout = Instance.new("UIListLayout", masterFrame)
masterLayout.FillDirection = Enum.FillDirection.Horizontal
masterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
masterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
masterLayout.Padding = UDim.new(0, 6)

function toggleMenu() 
    masterFrame.Visible = not masterFrame.Visible 
end

local btnDrag, btnStartPos, btnInputStart = false, nil, nil
local bInBegan = openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDrag = true
        btnStartPos = openBtn.Position
        btnInputStart = input.Position
    end
end)
table.insert(connections, bInBegan)

local bInChanged = UserInputService.InputChanged:Connect(function(input)
    if btnDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnInputStart
        local newPos = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
        openBtn.Position = newPos
        savedPos.OpenBtn = newPos
        if genv then genv.GestioSavedPos.OpenBtn = newPos end
    end
end)
table.insert(connections, bInChanged)

local bInEnded = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if btnDrag then
            btnDrag = false
            if (input.Position - btnInputStart).Magnitude < 15 then 
                toggleMenu() 
            end
        end
    end
end)
table.insert(connections, bInEnded)

local mainFrame = Instance.new("Frame", masterFrame)
mainFrame.Size = UDim2.new(0.58, 0, 1, 0)
mainFrame.BackgroundColor3 = currentTheme.Background
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 5
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = currentTheme.Border

local bgGridFolder = Instance.new("Folder", mainFrame)
bgGridFolder.Name = "GestioBackgroundGrid"

local gridRows = 12
local gridCols = 22
for r = 0, gridRows - 1 do
    for c = 0, gridCols - 1 do
        local square = Instance.new("Frame", bgGridFolder)
        square.Size = UDim2.new(0, 20, 0, 20)
        square.Position = UDim2.new(c / gridCols, 0, r / gridRows, 0)
        square.BackgroundColor3 = currentTheme.Sidebar
        square.BackgroundTransparency = 0.82
        square.BorderSizePixel = 0
        square.ZIndex = 5
        Instance.new("UICorner", square).CornerRadius = UDim.new(0, 3)
    end
end

local sidebar = Instance.new("ScrollingFrame", mainFrame)
sidebar.Size = UDim2.new(0, 75, 1, -8)
sidebar.Position = UDim2.new(0, 4, 0, 4)
sidebar.BackgroundColor3 = currentTheme.Sidebar
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 6
sidebar.ScrollBarThickness = 0
sidebar.CanvasSize = UDim2.new(0, 0, 0, 250)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local sbLayout = Instance.new("UIListLayout", sidebar)
sbLayout.FillDirection = Enum.FillDirection.Vertical
sbLayout.SortOrder = Enum.SortOrder.LayoutOrder
sbLayout.Padding = UDim.new(0, 3)
sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local sbPad = Instance.new("UIPadding", sidebar)
sbPad.PaddingTop = UDim.new(0, 4)
sbPad.PaddingBottom = UDim.new(0, 4)

local logoBtn = Instance.new("TextButton", sidebar)
logoBtn.Size = UDim2.new(0.9, 0, 0, 24)
logoBtn.BackgroundTransparency = 1
logoBtn.Text = "Gestio"
logoBtn.TextColor3 = currentTheme.Accent
logoBtn.TextSize = 11
logoBtn.Font = Enum.Font.GothamBold
logoBtn.ZIndex = 7
logoBtn.LayoutOrder = 1
bindTouch(logoBtn, toggleMenu)

function createNavBtn(order, txt)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(0.88, 0, 0, 19)
    b.BackgroundColor3 = currentTheme.Sidebar
    b.TextColor3 = currentTheme.TextSecondary
    b.Text = txt
    b.TextSize = 7.5
    b.Font = Enum.Font.GothamBold
    b.ZIndex = 7
    b.LayoutOrder = order
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local cBtn = createNavBtn(2, "COMBAT")
local mBtn = createNavBtn(3, "MOVEMENT")
local eBtn = createNavBtn(4, "ESP")
local sBtn = createNavBtn(5, "SKINS")
local envBtn = createNavBtn(6, "ENV")
local micsBtn = createNavBtn(7, "MICS")
local setsBtn = createNavBtn(8, "SETTINGS")
cBtn.BackgroundColor3 = currentTheme.CardBg
cBtn.TextColor3 = currentTheme.Accent

function makePageContainer()
    local c = Instance.new("ScrollingFrame", mainFrame)
    c.Size = UDim2.new(1, -84, 1, -12)
    c.Position = UDim2.new(0, 80, 0, 6)
    c.BackgroundTransparency = 1
    c.ScrollBarThickness = 2
    c.CanvasSize = UDim2.new(0, 0, 0, 900)
    c.Visible = false
    c.ZIndex = 6

    local list = Instance.new("UIListLayout", c)
    list.FillDirection = Enum.FillDirection.Vertical
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 10)

    local pad = Instance.new("UIPadding", c)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 10)

    return c
end

function makeCategorySection(page, title, layoutOrder, cardCount)
    local count = cardCount or 4
    local rows = math.ceil(count / 4)
    local gridHeight = rows * 64
    local totalHeight = 22 + gridHeight

    local sectionContainer = Instance.new("Frame", page)
    sectionContainer.Size = UDim2.new(1, 0, 0, totalHeight)
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.LayoutOrder = layoutOrder or 1
    sectionContainer.ZIndex = 6

    local headerLabel = Instance.new("TextLabel", sectionContainer)
    headerLabel.Size = UDim2.new(1, 0, 0, 18)
    headerLabel.BackgroundTransparency = 1
    headerLabel.Text = title:upper()
    headerLabel.TextColor3 = currentTheme.Accent
    headerLabel.TextSize = 8.5
    headerLabel.Font = Enum.Font.GothamBold
    headerLabel.TextXAlignment = Enum.TextXAlignment.Left
    headerLabel.ZIndex = 7

    local gridFrame = Instance.new("Frame", sectionContainer)
    gridFrame.Size = UDim2.new(1, 0, 0, gridHeight)
    gridFrame.Position = UDim2.new(0, 0, 0, 20)
    gridFrame.BackgroundTransparency = 1
    gridFrame.ZIndex = 6

    local grid = Instance.new("UIGridLayout", gridFrame)
    grid.CellSize = UDim2.new(0, 58, 0, 58)
    grid.CellPadding = UDim2.new(0, 6, 0, 6)

    return gridFrame
end

local cPage = makePageContainer()
local mPage = makePageContainer()
local ePage = makePageContainer()
local sPage = makePageContainer()
local envPage = makePageContainer()
local micsPage = makePageContainer()
local setsPage = makePageContainer()
cPage.Visible = true

function switch(tab)
    cPage.Visible = (tab == "C")
    mPage.Visible = (tab == "M")
    ePage.Visible = (tab == "E")
    sPage.Visible = (tab == "SKINS")
    envPage.Visible = (tab == "ENV")
    micsPage.Visible = (tab == "MICS")
    setsPage.Visible = (tab == "SETS")

    local btns = {{cBtn, "C"}, {mBtn, "M"}, {eBtn, "E"}, {sBtn, "SKINS"}, {envBtn, "ENV"}, {micsBtn, "MICS"}, {setsBtn, "SETS"}}
    for _, item in ipairs(btns) do
        local on = (item[2] == tab)
        item[1].BackgroundColor3 = on and currentTheme.CardBg or currentTheme.Sidebar
        item[1].TextColor3 = on and currentTheme.Accent or currentTheme.TextSecondary
    end
end

bindTouch(cBtn, function() switch("C") end)
bindTouch(mBtn, function() switch("M") end)
bindTouch(eBtn, function() switch("E") end)
bindTouch(sBtn, function() switch("SKINS") end)
bindTouch(envBtn, function() switch("ENV") end)
bindTouch(micsBtn, function() switch("MICS") end)
bindTouch(setsBtn, function() switch("SETS") end)

-- ==========================================
-- RIGHT INSPECTOR FRAMEWORK
-- ==========================================
local inspectorPanel = Instance.new("Frame", masterFrame)
inspectorPanel.Size = UDim2.new(0.40, 0, 1, 0)
inspectorPanel.BackgroundColor3 = currentTheme.Background
inspectorPanel.BorderSizePixel = 0
inspectorPanel.ZIndex = 5
Instance.new("UICorner", inspectorPanel).CornerRadius = UDim.new(0, 8)
local insStroke = Instance.new("UIStroke", inspectorPanel)
insStroke.Color = currentTheme.Border

local insGridFolder = Instance.new("Folder", inspectorPanel)
insGridFolder.Name = "GestioInspectorGrid"
for r = 0, gridRows - 1 do
    for c = 0, 12 do
        local square = Instance.new("Frame", insGridFolder)
        square.Size = UDim2.new(0, 20, 0, 20)
        square.Position = UDim2.new(c / 12, 0, r / gridRows, 0)
        square.BackgroundColor3 = currentTheme.Sidebar
        square.BackgroundTransparency = 0.82
        square.BorderSizePixel = 0
        square.ZIndex = 5
        Instance.new("UICorner", square).CornerRadius = UDim.new(0, 3)
    end
end

local insHeader = Instance.new("TextLabel", inspectorPanel)
insHeader.Size = UDim2.new(1, -38, 0, 26)
insHeader.Position = UDim2.new(0, 10, 0, 4)
insHeader.BackgroundTransparency = 1
insHeader.Text = "Settings"
insHeader.TextColor3 = currentTheme.TextPrimary
insHeader.TextSize = 10
insHeader.Font = Enum.Font.GothamBold
insHeader.TextXAlignment = Enum.TextXAlignment.Left
insHeader.ZIndex = 6

local closeBtn = Instance.new("TextButton", inspectorPanel)
closeBtn.Size = UDim2.new(0, 18, 0, 18)
closeBtn.Position = UDim2.new(1, -22, 0, 6)
closeBtn.BackgroundColor3 = currentTheme.CardBg
closeBtn.Text = "X"
closeBtn.TextColor3 = currentTheme.TextSecondary
closeBtn.TextSize = 9
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 7
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
bindTouch(closeBtn, toggleMenu)

local insContent = Instance.new("ScrollingFrame", inspectorPanel)
insContent.Size = UDim2.new(1, 0, 1, -32)
insContent.Position = UDim2.new(0, 0, 0, 30)
insContent.BackgroundTransparency = 1
insContent.ScrollBarThickness = 2
insContent.CanvasSize = UDim2.new(0, 0, 0, 650)
insContent.ZIndex = 6

function addInspectorSlider(y, txt, min, max, cur, isFloat, onChange)
    local lbl = Instance.new("TextLabel", insContent)
    lbl.Size = UDim2.new(0.86, 0, 0, 12)
    lbl.Position = UDim2.new(0.07, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = currentTheme.TextSecondary
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextSize = 8.5
    lbl.Font = Enum.Font.GothamBold
    lbl.ZIndex = 7
    lbl.Text = isFloat and string.format("%s: %.2fx", txt, cur) or string.format("%s: %d", txt, cur)

    local track = Instance.new("TextButton", insContent)
    track.Size = UDim2.new(0.86, 0, 0, 6)
    track.Position = UDim2.new(0.07, 0, 0, y + 14)
    track.BackgroundColor3 = currentTheme.Border
    track.Text = ""
    track.AutoButtonColor = false
    track.ZIndex = 7
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(math.clamp((cur - min) / (max - min), 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = currentTheme.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 8
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local drag = false
    local function update(input)
        local pos = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
        local pct = pos / track.AbsoluteSize.X
        local rawVal = min + (max - min) * pct
        local val = isFloat and (math.floor(rawVal * 100) / 100) or math.floor(rawVal)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        lbl.Text = isFloat and string.format("%s: %.2fx", txt, val) or string.format("%s: %d", txt, val)
        onChange(val)
    end

    local trInBegan = track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true 
            update(input)
        end
    end)
    table.insert(connections, trInBegan)

    local trInEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    table.insert(connections, trInEnded)

    local trInChanged = UserInputService.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    table.insert(connections, trInChanged)
end

function addInspectorToggle(y, txt, default, onToggle)
    local f = Instance.new("Frame", insContent)
    f.Size = UDim2.new(0.86, 0, 0, 20)
    f.Position = UDim2.new(0.07, 0, 0, y)
    f.BackgroundTransparency = 1
    f.ZIndex = 7

    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(0.7, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = txt
    t.TextColor3 = currentTheme.TextSecondary
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextSize = 8.5
    t.Font = Enum.Font.GothamBold
    t.ZIndex = 7

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 26, 0, 14)
    btn.Position = UDim2.new(1, -26, 0.5, -7)
    btn.BackgroundColor3 = default and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
    btn.Text = ""
    btn.ZIndex = 8
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 10, 0, 10)
    circle.Position = default and UDim2.new(1, -11, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.ZIndex = 9
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = default
    local function executeToggle()
        state = not state
        btn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
        circle.Position = state and UDim2.new(1, -11, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
        onToggle(state)
    end

    bindTouch(btn, executeToggle)
end

function addInspectorChoice(y, txt, choices, currentChoice, onSelect)
    local row = Instance.new("Frame", insContent)
    row.Size = UDim2.new(0.86, 0, 0, 28)
    row.Position = UDim2.new(0.07, 0, 0, y)
    row.BackgroundTransparency = 1
    row.ZIndex = 20

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.34, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = txt
    lbl.TextColor3 = currentTheme.TextSecondary
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextSize = 8.5
    lbl.Font = Enum.Font.GothamBold
    lbl.ZIndex = 20

    local dropdown = Instance.new("TextButton", row)
    dropdown.Size = UDim2.new(0.66, 0, 0, 26)
    dropdown.Position = UDim2.new(0.34, 0, 0.5, -13)
    dropdown.BackgroundColor3 = currentTheme.CardBg
    dropdown.BorderSizePixel = 0
    dropdown.Text = ""
    dropdown.AutoButtonColor = false
    dropdown.ZIndex = 21
    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 5)

    local stroke = Instance.new("UIStroke", dropdown)
    stroke.Color = currentTheme.Border
    stroke.Thickness = 1

    local selectedLabel = Instance.new("TextLabel", dropdown)
    selectedLabel.Size = UDim2.new(1, -30, 1, 0)
    selectedLabel.Position = UDim2.new(0, 10, 0, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = currentChoice
    selectedLabel.TextColor3 = currentTheme.TextPrimary
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.TextSize = 8
    selectedLabel.Font = Enum.Font.GothamBold
    selectedLabel.ZIndex = 22

    local arrow = Instance.new("TextLabel", dropdown)
    arrow.Size = UDim2.new(0, 22, 1, 0)
    arrow.Position = UDim2.new(1, -24, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = currentTheme.TextSecondary
    arrow.TextSize = 8
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = 22

    local list = Instance.new("Frame", insContent)
    list.Name = "PresetDropdown"
    list.Size = UDim2.new(0.5676, 0, 0, 0)
    list.Position = UDim2.new(0.3624, 0, 0, y + 31)
    list.BackgroundColor3 = currentTheme.CardBg
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 100
    list.ClipsDescendants = true
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 5)
    local listStroke = Instance.new("UIStroke", list)
    listStroke.Color = currentTheme.Border

    local layout = Instance.new("UIListLayout", list)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local open = false
    local h = 25

    local function close()
        open = false
        list.Visible = false
        list.Size = UDim2.new(0.5676, 0, 0, 0)
        arrow.Text = "▼"
    end
    local function toggle()
        open = not open
        list.Visible = open
        list.Size = open and UDim2.new(0.5676, 0, 0, #choices*h+2) or UDim2.new(0.5676, 0, 0, 0)
        arrow.Text = open and "▲" or "▼"
    end

    for i, choiceName in ipairs(choices) do
        local option = Instance.new("TextButton", list)
        option.LayoutOrder = i
        option.Size = UDim2.new(1, -2, 0, h)
        option.BackgroundColor3 = choiceName == currentChoice and currentTheme.Accent or currentTheme.CardBg
        option.Text = choiceName
        option.TextColor3 = choiceName == currentChoice and Color3.fromRGB(255,255,255) or currentTheme.TextSecondary
        option.TextSize = 8
        option.Font = Enum.Font.GothamBold
        option.AutoButtonColor = false
        option.ZIndex = 101
        Instance.new("UICorner", option).CornerRadius = UDim.new(0,4)
        bindTouch(option, function()
            currentChoice = choiceName
            selectedLabel.Text = choiceName
            for _, child in ipairs(list:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = currentTheme.CardBg
                    child.TextColor3 = currentTheme.TextSecondary
                end
            end
            option.BackgroundColor3 = currentTheme.Accent
            option.TextColor3 = Color3.fromRGB(255,255,255)
            close()
            onSelect(choiceName)
        end)
    end
    bindTouch(dropdown, toggle)
end

-- ==========================================
-- DETAILED INSPECTOR ROUTING
-- ==========================================
function openInspectorFor(moduleName)
    insHeader.Text = moduleName
    for _, child in pairs(insContent:GetChildren()) do child:Destroy() end

    if moduleName == "Tracking" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 580)
        addInspectorSlider(6, "FOV Radius", 50, 400, aimFov, false, function(v) aimFov = v end)
        addInspectorSlider(38, "Speed", 1.0, 50.0, aimbotSpeed, true, function(v) aimbotSpeed = v end)
        addInspectorSlider(70, "Smoothness", 0.0, 0.95, aimbotSmoothness, true, function(v) aimbotSmoothness = v end)
        addInspectorSlider(102, "Prediction Factor", 0.05, 0.3, predictionFactor, true, function(v) predictionFactor = v end)
        addInspectorToggle(140, "Body Priority", bodyAimOnly, function(v) bodyAimOnly = v end)
        addInspectorToggle(166, "Snap Lock Mode", snapAimMode, function(v) snapAimMode = v end)
        addInspectorToggle(192, "Prediction", predictionEnabled, function(v) predictionEnabled = v end)
        addInspectorToggle(218, "Show FOV Circle", showFovCircle, function(v) showFovCircle = v end)
        addInspectorToggle(244, "Visibility Check", visibleCheck, function(v) visibleCheck = v end)
    elseif moduleName == "No Recoil" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 110)
        addInspectorSlider(6, "Recoil Dampener", 0.1, 1.0, noRecoil.strength, true, function(v)
            noRecoil.strength = v
        end)
    elseif moduleName == "Butterfly Knife" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 160)
        addInspectorChoice(6, "Skin Finish", {"Vanilla", "Fade", "Doppler", "Lore"}, butterflySkin, function(selected)
            butterflySkin = selected
            hookBloxStrikeModules()
            scanAndMorphKnives(Workspace)
            scanAndMorphKnives(camera)
        end)
        addInspectorToggle(48, "Auto Re-apply", true, function(v) end)
    elseif moduleName == "Third Person" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 115)
        addInspectorSlider(6, "Distance", 5, 25, thirdPersonDistance, false, function(v)
            thirdPersonDistance = v
            refreshThirdPerson()
        end)
        addInspectorSlider(38, "Height", -1, 5, thirdPersonHeight, false, function(v)
            thirdPersonHeight = v
            refreshThirdPerson()
        end)
    elseif moduleName == "Hitmarker" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 170)
        addInspectorSlider(6, "Duration", 0.10, 0.60, hitmarkerDuration, true, function(v)
            hitmarkerDuration = v
        end)
        addInspectorSlider(38, "Size", 8, 24, hitmarkerSize, false, function(v)
            hitmarkerSize = v
            for _, line in ipairs(hitmarkerLines) do
                line.Size = UDim2.new(0, hitmarkerThickness, 0, hitmarkerSize)
            end
        end)
        addInspectorSlider(70, "Thickness", 1, 4, hitmarkerThickness, false, function(v)
            hitmarkerThickness = v
            for _, line in ipairs(hitmarkerLines) do
                line.Size = UDim2.new(0, hitmarkerThickness, 0, hitmarkerSize)
            end
        end)
        addInspectorToggle(108, "Neon Glow", hitmarkerGlow, function(v)
            hitmarkerGlow = v
            for _, line in ipairs(hitmarkerLines) do
                local glow = line:FindFirstChild("NeonGlow")
                if glow then glow.Thickness = hitmarkerGlow and 2.5 or 0 end
            end
        end)
    elseif moduleName == "Anti-Aim" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorSlider(6, "Spin Speed", 10, 150, spinSpeed, false, function(v) 
            spinSpeed = v 
        end)
    elseif moduleName == "Slide" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 180)
        addInspectorSlider(6, "Speed Boost", 1.2, 3.0, slideSpeedBoost, true, function(v) slideSpeedBoost = v end)
        addInspectorSlider(38, "Friction", 0.85, 0.99, slideFriction, true, function(v) slideFriction = v end)
        addInspectorSlider(70, "Min Speed Threshold", 8, 24, slideMinSpeed, false, function(v) slideMinSpeed = v end)
    elseif moduleName == "Jump Circle" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 240)
        addInspectorSlider(6, "Radius", 1.5, 8.0, jumpCircleRadius, true, function(v)
            jumpCircleRadius = v
            if player.Character then initJumpCircleForCharacter(player.Character) end
        end)
        addInspectorSlider(38, "Segments", 12, 48, jumpCircleSegmentCount, false, function(v)
            jumpCircleSegmentCount = v
            if player.Character then initJumpCircleForCharacter(player.Character) end
        end)
        addInspectorChoice(80, "Style", {"GradientWave", "ChromaPulse", "StaticNeon"}, jumpCircleStyle, function(v)
            jumpCircleStyle = v
            if player.Character then initJumpCircleForCharacter(player.Character) end
        end)
    elseif moduleName == "Grenade ESP" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 220)
        addInspectorSlider(6, "Max Distance", 200, 3000, grenadeMaxDist, false, function(v) grenadeMaxDist = v end)
        addInspectorToggle(42, "Trajectory Path", showGrenadePath, function(v) showGrenadePath = v end)
        addInspectorToggle(70, "Molotov Radius", showMolotovRadius, function(v) showMolotovRadius = v end)
        addInspectorToggle(98, "Smoke Radius", showSmokeRadius, function(v) showSmokeRadius = v end)
    elseif moduleName == "Bhop Engine" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 200)
        addInspectorSlider(6, "Jump Power", 30, 100, bhopJumpPower, false, function(v) bhopJumpPower = v end)
        addInspectorSlider(38, "Speed Boost", 1.0, 3.0, bhopSpeedBoost, true, function(v) bhopSpeedBoost = v end)
        addInspectorToggle(76, "Auto Jump (Always)", bhopAutoJump, function(v) bhopAutoJump = v end)
        addInspectorToggle(102, "Air Strafe", bhopAirStrafe, function(v) bhopAirStrafe = v end)
    elseif moduleName == "Nametags" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 340)
        addInspectorSlider(6, "Max Distance", 100, 5000, espMaxDist, false, function(v) espMaxDist = v end)
        addInspectorSlider(38, "Text Size", 8, 20, espTextSize, false, function(v) espTextSize = v end)
        addInspectorSlider(70, "Transparency", 0.0, 0.9, tagTransparency, true, function(v) tagTransparency = v end)
        addInspectorToggle(108, "Show Distance", espShowDistance, function(v) espShowDistance = v end)
        addInspectorToggle(134, "Show Health", espShowHealth, function(v) espShowHealth = v end)
        addInspectorToggle(160, "Show Weapon", tagShowWeapon, function(v) tagShowWeapon = v end)
    elseif moduleName == "Box Overlay" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 200)
        addInspectorSlider(6, "Max Distance", 100, 5000, espMaxDist, false, function(v) espMaxDist = v end)
        addInspectorSlider(38, "Thickness", 1.0, 3.0, boxThickness, true, function(v) boxThickness = v end)
        addInspectorToggle(76, "Corner Box", cornerBoxEnabled, function(v) cornerBoxEnabled = v end)
        addInspectorToggle(108, "Health Bar", healthBarEnabled, function(v) healthBarEnabled = v end)
    elseif moduleName == "World Changer" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 330)
        addInspectorChoice(6, "World Preset", {"Midnight", "Nebula", "DeepBlood", "CyberPurple", "EmeraldNight", "PitchBlack"}, nightPreset, function(selected)
            applyNightPreset(selected)
        end)
        addInspectorSlider(48, "Brightness", 0.0, 2.0, nightBrightness, true, function(v) 
            nightBrightness = v 
            if nightModeEnabled then Lighting.Brightness = v end
        end)
        addInspectorSlider(80, "Clock Time", 0.0, 24.0, nightClockTime, true, function(v) 
            nightClockTime = v 
            if nightModeEnabled then Lighting.ClockTime = v end
        end)
    elseif moduleName == "RCS" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 240)
        addInspectorSlider(6, "RCS Strength", 10, 100, rcsStrength, false, function(v) rcsStrength = v end)
        addInspectorSlider(38, "Pitch Factor", 0.1, 2.0, rcsPitchFactor, true, function(v) rcsPitchFactor = v end)
        addInspectorSlider(70, "Yaw Factor", 0.1, 2.0, rcsYawFactor, true, function(v) rcsYawFactor = v end)
        addInspectorToggle(108, "Horizontal Comp", rcsHorizontalComp, function(v) rcsHorizontalComp = v end)
    elseif moduleName == "Trigger Assistant" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 150)
        addInspectorSlider(6, "Trigger Delay", 0.0, 0.2, triggerbotDelay, true, function(v) triggerbotDelay = v end)
        addInspectorToggle(44, "Head Only", triggerbotHeadOnly, function(v) triggerbotHeadOnly = v end)
        addInspectorToggle(70, "Auto Trigger", triggerbotMobileAutoFire, function(v) triggerbotMobileAutoFire = v end)
    else
        insContent.CanvasSize = UDim2.new(0, 0, 0, 50)
        local lbl = Instance.new("TextLabel", insContent)
        lbl.Size = UDim2.new(0.86, 0, 0, 30)
        lbl.Position = UDim2.new(0.07, 0, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Module active and synchronized."
        lbl.TextColor3 = currentTheme.TextSecondary
        lbl.TextSize = 8.5
        lbl.TextWrapped = true
        lbl.Font = Enum.Font.Gotham
    end
end

-- ==========================================
-- CARD GENERATOR COMPONENT
-- ==========================================
function addCard(parent, name, defaultState, onToggle)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(0, 58, 0, 58)
    card.BackgroundColor3 = currentTheme.CardBg
    card.BorderSizePixel = 0
    card.ZIndex = 7
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = currentTheme.Border

    local textBtn = Instance.new("TextButton", card)
    textBtn.Size = UDim2.new(1, -4, 0, 24)
    textBtn.Position = UDim2.new(0, 2, 0, 2)
    textBtn.BackgroundTransparency = 1
    textBtn.Text = name
    textBtn.TextColor3 = currentTheme.TextPrimary
    textBtn.TextSize = 7.5
    textBtn.Font = Enum.Font.GothamBold
    textBtn.TextWrapped = true
    textBtn.ZIndex = 8
    bindTouch(textBtn, function() openInspectorFor(name) end)

    local toggleBtn = Instance.new("TextButton", card)
    toggleBtn.Size = UDim2.new(0, 24, 0, 13)
    toggleBtn.Position = UDim2.new(0.5, -12, 1, -16)
    toggleBtn.BackgroundColor3 = defaultState and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
    toggleBtn.Text = ""
    toggleBtn.ZIndex = 8
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", toggleBtn)
    circle.Size = UDim2.new(0, 9, 0, 9)
    circle.Position = defaultState and UDim2.new(1, -10, 0.5, -4.5) or UDim2.new(0, 2, 0.5, -4.5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.ZIndex = 9
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = defaultState
    local function executeToggle()
        state = not state
        toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
        circle.Position = state and UDim2.new(1, -10, 0.5, -4.5) or UDim2.new(0, 2, 0.5, -4.5)
        onToggle(state)
        
        if name == "World Changer" then
            if state then
                applyNightPreset(nightPreset)
            else
                restoreLightingState()
            end
        elseif name == "FullBright" and not state and not nightModeEnabled then
            restoreLightingState()
        end
    end

    bindTouch(toggleBtn, executeToggle)
end

-- ==========================================
-- TAB SECTIONS & MODULE POPULATION
-- ==========================================

-- COMBAT TAB
local cAimSection = makeCategorySection(cPage, "Aim & Ballistics", 1, 3)
local cRageSection = makeCategorySection(cPage, "HVH & Anti-Aim", 2, 1)

addCard(cAimSection, "Tracking", aimbotEnabled, function(v)
    aimbotEnabled = v
    isAiming = v
    if not v then
        lockedTarget = nil
    end
end)
addCard(cAimSection, "RCS", rcsEnabled, function(v) rcsEnabled = v end)
addCard(cAimSection, "No Recoil", noRecoil.enabled, function(v)
    noRecoil.enabled = v
end)
addCard(cAimSection, "Trigger Assistant", triggerbotEnabled, function(v) triggerbotEnabled = v end)
addCard(cRageSection, "Anti-Aim", antiAimEnabled, function(v) antiAimEnabled = v end)

-- MOVEMENT TAB
local mHopSection = makeCategorySection(mPage, "Bhop Mechanics", 1, 1)
local mBoostSection = makeCategorySection(mPage, "Physics Modifications", 2, 3)

addCard(mHopSection, "Bhop Engine", bunnyHopEnabled, function(v) bunnyHopEnabled = v end)
addCard(mBoostSection, "Slide", slideEnabled, function(v) 
    slideEnabled = v 
    updateMobileSlideVisibility()
end)
addCard(mBoostSection, "Speed Boost", speedEnabled, function(v) speedEnabled = v end)
addCard(mBoostSection, "Flight", flightEnabled, function(v) flightEnabled = v end)

-- ESP TAB
local ePlayerSection = makeCategorySection(ePage, "Player Visuals", 1, 6)
local eWorldSection = makeCategorySection(ePage, "World & Projectiles", 2, 2)

addCard(ePlayerSection, "Nametags", nametagsEnabled, function(v) nametagsEnabled = v end)
addCard(ePlayerSection, "Highlight", highlightEnabled, function(v) highlightEnabled = v end)
addCard(ePlayerSection, "Box Overlay", boxEspEnabled, function(v) boxEspEnabled = v end)
addCard(ePlayerSection, "Head Dot", headDotEnabled, function(v) headDotEnabled = v end)
addCard(ePlayerSection, "Snaplines", tracersEnabled, function(v) tracersEnabled = v end)
addCard(ePlayerSection, "Hitmarker", hitmarkerEnabled, function(v)
    hitmarkerEnabled = v
    if not v then
        hitmarkerCenter.Visible = false
        hitmarkerBusy = false
    end
end)

addCard(eWorldSection, "Grenade ESP", grenadeEspEnabled, function(v) grenadeEspEnabled = v end)
addCard(eWorldSection, "Jump Circle", jumpCircleEnabled, function(v) 
    jumpCircleEnabled = v 
    if v and player.Character then
        initJumpCircleForCharacter(player.Character)
    else
        clearActiveJumpCircle()
    end
end)

-- SKINS TAB (Skinchanger)
local sKnifeSection = makeCategorySection(sPage, "Melee Weapons", 1, 1)
addCard(sKnifeSection, "Butterfly Knife", butterflyKnifeEnabled, function(v)
    butterflyKnifeEnabled = v
    if v then
        hookBloxStrikeModules()
        scanAndMorphKnives(Workspace)
        scanAndMorphKnives(camera)
    end
end)

-- WORLD CHANGER / ENVIRONMENT TAB
local envLightSection = makeCategorySection(envPage, "Atmosphere & World", 1, 4)
addCard(envLightSection, "World Changer", nightModeEnabled, function(v)
    nightModeEnabled = v
    if v then
        applyNightPreset(nightPreset)
    elseif not fullBrightEnabled then
        restoreLightingState()
    end
end)
addCard(envLightSection, "FullBright", fullBrightEnabled, function(v)
    fullBrightEnabled = v
    if not v and not nightModeEnabled then
        restoreLightingState()
    end
end)
addCard(envLightSection, "Anti-Flash", antiFlashEnabled, function(v) antiFlashEnabled = v end)
addCard(envLightSection, "No Fog", removeFogEnabled, function(v)
    removeFogEnabled = v
    if not v then
        Lighting.FogEnd = defaultLighting.FogEnd
    end
end)

-- MISC TAB
local miscGeneralSection = makeCategorySection(micsPage, "Utilities", 1, 2)
addCard(miscGeneralSection, "Third Person", thirdPersonEnabled, function(v)
    setThirdPersonEnabled(v)
end)
addCard(miscGeneralSection, "Anti-AFK", antiAfkEnabled, function(v)
    setAntiAfkEnabled(v)
end)

-- SETTINGS TAB
local setsGeneralSection = makeCategorySection(setsPage, "Configuration", 1, 1)
addCard(setsGeneralSection, "Theme", true, function(v) end)

openInspectorFor("Tracking")

end

buildGestioUI()
