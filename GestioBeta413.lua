-- ==============================================================================
-- [Gestio UI - Blox Strike Ultimate Mobile Engine | Version 4.2.0 Extended]
-- Architecture: Uncompressed Full Pipeline
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
local Debris = game:GetService("Debris")

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

local function getSafeGui()
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
local hitmarkerLastHealth = {}

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
local aimbotSmoothness = 0.0
local aimFov = 160
local showFovCircle = true
local snapAimMode = true
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
-- VISUALS & ENHANCED CHAMS / SOUL / HIT HUD
-- ==========================================
local hitmarkerEnabled = false
local hitmarkerDuration = 0.28
local hitmarkerSize = 13
local hitmarkerThickness = 2
local hitmarkerGlow = true
local thirdPersonEnabled = false
local thirdPersonDistance = 12
local thirdPersonHeight = 1.5
local thirdPersonPreviousOffset = nil

local hitLogsEnabled = false
local hitDamageEnabled = false
local targetHudEnabled = false
local soulAnimationEnabled = false
local fadeChamsEnabled = false
local bulletTracersGlow = true
local hitboxGradientEnabled = true
local animationDirection = "Right" -- "Right" or "Left"

-- ==========================================
-- SKINS & WEAPON MODS ENGINE
-- ==========================================
local butterflyKnifeEnabled = false
local butterflySkin = "Fade"

local function hookBloxStrikeModules()
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

local function scanAndMorphKnives(root)
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
-- RECOIL CONTROL & TRIGGERBOT
-- ==========================================
local rcsEnabled = false
local rcsStrength = 75
local rcsPitchFactor = 1.0
local rcsYawFactor = 1.0
local rcsSmoothness = 0.2
local rcsHorizontalComp = true

local triggerbotEnabled = false
local triggerbotDelay = 0.02
local triggerbotHeadOnly = false
local triggerbotMobileAutoFire = true
local lastTriggerTick = 0

local antiAimEnabled = false
local spinSpeed = 50
local currentSpinAngle = 0

-- ==========================================
-- MOVEMENT & BHOP ENGINE
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
-- ESP SYSTEM CONFIGURATION
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
-- JUMP CIRCLE ENGINE
-- ==========================================
local jumpCircleEnabled = false
local jumpCircleStyle = "GradientWave"
local jumpCircleSegmentCount = 32
local jumpCircleRadius = 3.5
local jumpCircleHeightOffset = -2.8
local activeJumpCircleData = nil

-- ==========================================
-- ENVIRONMENT LIGHTING
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
    ["Midnight"] = { ClockTime = 0.0, Brightness = 0.2, OutdoorAmbient = Color3.fromRGB(25, 25, 40), Ambient = Color3.fromRGB(15, 15, 25), FogColor = Color3.fromRGB(10, 10, 20) },
    ["Nebula"] = { ClockTime = 23.8, Brightness = 0.3, OutdoorAmbient = Color3.fromRGB(70, 25, 85), Ambient = Color3.fromRGB(45, 15, 60), FogColor = Color3.fromRGB(90, 30, 110) },
    ["DeepBlood"] = { ClockTime = 0.0, Brightness = 0.35, OutdoorAmbient = Color3.fromRGB(75, 10, 15), Ambient = Color3.fromRGB(45, 5, 10), FogColor = Color3.fromRGB(35, 5, 8) },
    ["CyberPurple"] = { ClockTime = 23.5, Brightness = 0.3, OutdoorAmbient = Color3.fromRGB(65, 15, 95), Ambient = Color3.fromRGB(40, 10, 60), FogColor = Color3.fromRGB(30, 8, 45) },
    ["EmeraldNight"] = { ClockTime = 1.0, Brightness = 0.25, OutdoorAmbient = Color3.fromRGB(10, 55, 30), Ambient = Color3.fromRGB(5, 35, 20), FogColor = Color3.fromRGB(5, 25, 15) },
    ["PitchBlack"] = { ClockTime = 0.0, Brightness = 0.0, OutdoorAmbient = Color3.fromRGB(0, 0, 0), Ambient = Color3.fromRGB(0, 0, 0), FogColor = Color3.fromRGB(0, 0, 0) }
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
local mainContainer = Instance.new("ScreenGui")
mainContainer.Name = "GestioMainContainer"
mainContainer.ResetOnSpawn = false
mainContainer.DisplayOrder = 10
mainContainer.IgnoreGuiInset = true
mainContainer.Parent = targetGui

local overlayContainer = Instance.new("Folder", mainContainer)
overlayContainer.Name = "Gestio_2DOverlay"

local grenadeContainer = Instance.new("Folder", mainContainer)
grenadeContainer.Name = "Gestio_GrenadeOverlay"

local jumpCircleFolder = Instance.new("Folder", Workspace)
jumpCircleFolder.Name = "Gestio_JumpCircleWorld"

local soulFolder = Instance.new("Folder", Workspace)
soulFolder.Name = "Gestio_SoulWorld"

local grenadePool = {}
local mobileSlideBtn = nil

-- ==========================================
-- TARGET HUD & HIT LOGS UI
-- ==========================================
local hudContainer = Instance.new("ScreenGui")
hudContainer.Name = "GestioHudContainer"
hudContainer.ResetOnSpawn = false
hudContainer.DisplayOrder = 55
hudContainer.IgnoreGuiInset = true
hudContainer.Parent = targetGui

local hitLogList = Instance.new("Frame", hudContainer)
hitLogList.Position = UDim2.new(0, 20, 0.35, 0)
hitLogList.Size = UDim2.new(0, 260, 0, 200)
hitLogList.BackgroundTransparency = 1

local hitLogLayout = Instance.new("UIListLayout", hitLogList)
hitLogLayout.SortOrder = Enum.SortOrder.LayoutOrder
hitLogLayout.Padding = UDim.new(0, 4)

local function pushHitLog(targetName, damage, hitbox)
    if not hitLogsEnabled then return end
    local row = Instance.new("Frame", hitLogList)
    row.Size = UDim2.new(1, 0, 0, 20)
    row.BackgroundColor3 = currentTheme.Background
    row.BackgroundTransparency = 0.2
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = currentTheme.Border
    stroke.Thickness = 1

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 5, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 8.5
    lbl.TextColor3 = currentTheme.TextPrimary
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = string.format("[HIT] Hit %s in %s for %d DMG", tostring(targetName), tostring(hitbox or "Body"), math.floor(damage))

    task.delay(3.5, function()
        pcall(function()
            TweenService:Create(row, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(lbl, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            task.wait(0.5)
            row:Destroy()
        end)
    end)
end

local targetHudFrame = Instance.new("Frame", hudContainer)
targetHudFrame.Size = UDim2.new(0, 200, 0, 50)
targetHudFrame.Position = UDim2.new(0.5, -100, 0.72, 0)
targetHudFrame.BackgroundColor3 = currentTheme.Background
targetHudFrame.BorderSizePixel = 0
targetHudFrame.Visible = false
Instance.new("UICorner", targetHudFrame).CornerRadius = UDim.new(0, 6)
local thStroke = Instance.new("UIStroke", targetHudFrame)
thStroke.Color = currentTheme.Border
thStroke.Thickness = 1

local thAvatar = Instance.new("ImageLabel", targetHudFrame)
thAvatar.Size = UDim2.new(0, 36, 0, 36)
thAvatar.Position = UDim2.new(0, 7, 0, 7)
thAvatar.BackgroundColor3 = currentTheme.Sidebar
Instance.new("UICorner", thAvatar).CornerRadius = UDim.new(0, 4)

local thName = Instance.new("TextLabel", targetHudFrame)
thName.Size = UDim2.new(0, 140, 0, 14)
thName.Position = UDim2.new(0, 50, 0, 8)
thName.BackgroundTransparency = 1
thName.Font = Enum.Font.GothamBold
thName.TextSize = 9
thName.TextColor3 = currentTheme.TextPrimary
thName.TextXAlignment = Enum.TextXAlignment.Left

local thBarBg = Instance.new("Frame", targetHudFrame)
thBarBg.Size = UDim2.new(0, 140, 0, 8)
thBarBg.Position = UDim2.new(0, 50, 0, 28)
thBarBg.BackgroundColor3 = currentTheme.CardBg
Instance.new("UICorner", thBarBg).CornerRadius = UDim.new(1, 0)

local thBarFill = Instance.new("Frame", thBarBg)
thBarFill.Size = UDim2.new(1, 0, 1, 0)
thBarFill.BackgroundColor3 = currentTheme.Accent
Instance.new("UICorner", thBarFill).CornerRadius = UDim.new(1, 0)

local function spawnHitDamageIndicator(pos, dmg)
    if not hitDamageEnabled then return end
    task.spawn(function()
        local bb = Instance.new("BillboardGui", mainContainer)
        bb.Size = UDim2.new(0, 50, 0, 25)
        bb.AlwaysOnTop = true
        bb.StudsOffset = Vector3.new(0, 1.5, 0)
        
        local p = Instance.new("Part", Workspace)
        p.Position = pos
        p.Transparency = 1
        p.Anchored = true
        p.CanCollide = false
        bb.Adornee = p

        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "-" .. tostring(math.floor(dmg))
        lbl.TextColor3 = currentTheme.Enemy_Accent
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 12
        local stroke = Instance.new("UIStroke", lbl)
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(0,0,0)

        local t = 0.6
        local dir = (animationDirection == "Left") and -1.5 or 1.5
        local targetPos = pos + Vector3.new(dir, 2, 0)
        TweenService:Create(p, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        TweenService:Create(lbl, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
        task.wait(t)
        bb:Destroy()
        p:Destroy()
    end)
end

local function spawnSoulAnimation(origin)
    if not soulAnimationEnabled then return end
    task.spawn(function()
        local soul = Instance.new("Part")
        soul.Shape = Enum.PartType.Ball
        soul.Size = Vector3.new(1.2, 1.2, 1.2)
        soul.Position = origin
        soul.Anchored = true
        soul.CanCollide = false
        soul.Material = Enum.Material.Neon
        soul.Color = currentTheme.Accent
        soul.Transparency = 0.2
        soul.Parent = soulFolder

        local att = Instance.new("Attachment", soul)
        local pe = Instance.new("ParticleEmitter", att)
        pe.Rate = 35
        pe.Lifetime = NumberRange.new(0.3, 0.5)
        pe.Speed = NumberRange.new(2, 4)
        pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0)})
        pe.Color = ColorSequence.new(currentTheme.Accent, Color3.fromRGB(255, 255, 255))

        local dir = (animationDirection == "Left") and -3 or 3
        local dest = origin + Vector3.new(dir, 6, (math.random() - 0.5) * 2)

        local tw = TweenService:Create(soul, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Position = dest,
            Transparency = 1,
            Size = Vector3.new(0.1, 0.1, 0.1)
        })
        tw:Play()
        task.wait(0.8)
        pe.Enabled = false
        task.wait(0.4)
        soul:Destroy()
    end)
end

-- ==========================================
-- HITMARKER SYSTEM
-- ==========================================
local hitmarkerGui = Instance.new("ScreenGui")
hitmarkerGui.Name = "GestioHitmarkerGui"
hitmarkerGui.ResetOnSpawn = false
hitmarkerGui.IgnoreGuiInset = true
hitmarkerGui.DisplayOrder = 60
hitmarkerGui.Parent = mainContainer

local hitmarkerCenter = Instance.new("Frame")
hitmarkerCenter.AnchorPoint = Vector2.new(0.5, 0.5)
hitmarkerCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
hitmarkerCenter.BackgroundTransparency = 1
hitmarkerCenter.Visible = false
hitmarkerCenter.Parent = hitmarkerGui

local hitmarkerLines = {}
for i, rotation in ipairs({45, -45, 135, -135}) do
    local line = Instance.new("Frame", hitmarkerCenter)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Size = UDim2.new(0, hitmarkerThickness, 0, hitmarkerSize)
    line.BackgroundColor3 = currentTheme.Accent
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 1
    line.Rotation = rotation

    local glow = Instance.new("UIStroke", line)
    glow.Name = "NeonGlow"
    glow.Color = currentTheme.Accent
    glow.Thickness = hitmarkerGlow and 2.5 or 0
    glow.Transparency = 1

    hitmarkerLines[i] = line
end

local function showHitmarker()
    if not hitmarkerEnabled then return end
    hitmarkerSerial = hitmarkerSerial + 1
    local serial = hitmarkerSerial
    hitmarkerCenter.Visible = true

    for _, line in ipairs(hitmarkerLines) do
        line.BackgroundTransparency = 0
        local glow = line:FindFirstChild("NeonGlow")
        if glow then glow.Transparency = 0.05 end
    end

    local fadeInfo = TweenInfo.new(math.max(0.05, hitmarkerDuration), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _, line in ipairs(hitmarkerLines) do
        TweenService:Create(line, fadeInfo, {BackgroundTransparency = 1}):Play()
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

-- ==========================================
-- THIRD PERSON & LIGHTING LOGIC
-- ==========================================
local function applyThirdPerson()
    local cam = Workspace.CurrentCamera
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not cam or not hum then return end

    if thirdPersonEnabled then
        if thirdPersonPreviousOffset == nil then
            thirdPersonPreviousOffset = hum.CameraOffset
        end
        cam.CameraSubject = hum
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

local function applyNightPreset(presetName)
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

local function restoreLightingState()
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

local function cleanup()
    pcall(function() thirdPersonEnabled = false; applyThirdPerson() end)
    for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
    if antiAfkConnection then pcall(function() antiAfkConnection:Disconnect() end) end
    for _, holder in pairs(activeEspHolders) do pcall(function() holder.Holder:Destroy() end) end
    for _, esp in pairs(screenEspCache) do
        pcall(function()
            esp.Box:Destroy()
            esp.TagCard:Destroy()
            esp.HealthBarBg:Destroy()
            for _, corner in pairs(esp.Corners) do corner.H:Destroy(); corner.V:Destroy() end
        end)
    end
    pcall(function() jumpCircleFolder:Destroy() end)
    pcall(function() soulFolder:Destroy() end)
    pcall(function() hitmarkerGui:Destroy() end)
    pcall(function() hudContainer:Destroy() end)
    restoreLightingState()
    pcall(function() if targetGui:FindFirstChild("GestioScreenGui") then targetGui.GestioScreenGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioToggleGui") then targetGui.GestioToggleGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioMainContainer") then targetGui.GestioMainContainer:Destroy() end end)
end

if genv then genv.GestioRunning = cleanup end

local function bindTouch(btn, callback)
    btn.Activated:Connect(callback)
end

-- ==========================================
-- HUD OVERLAYS (FOV & WATERMARK)
-- ==========================================
local fovGui = Instance.new("ScreenGui", targetGui)
fovGui.Name = "GestioFovGui"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true

local fovFrame = Instance.new("Frame", fovGui)
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovFrame.BackgroundTransparency = 1
fovFrame.Visible = false
local fovStroke = Instance.new("UIStroke", fovFrame)
fovStroke.Color = currentTheme.Accent
fovStroke.Thickness = 0.8
Instance.new("UICorner", fovFrame).CornerRadius = UDim.new(1, 0)

local watermarkGui = Instance.new("ScreenGui", targetGui)
watermarkGui.Name = "GestioWatermarkGui"
watermarkGui.ResetOnSpawn = false
watermarkGui.IgnoreGuiInset = true

local wmCard = Instance.new("Frame", watermarkGui)
wmCard.Position = UDim2.new(0, 14, 0, 14)
wmCard.Size = UDim2.new(0, 0, 0, 22)
wmCard.AutomaticSize = Enum.AutomaticSize.X
wmCard.BackgroundColor3 = currentTheme.Background
Instance.new("UICorner", wmCard).CornerRadius = UDim.new(0, 5)

local wmStroke = Instance.new("UIStroke", wmCard)
wmStroke.Color = currentTheme.Border
wmStroke.Thickness = 1.0

local wmLayout = Instance.new("UIListLayout", wmCard)
wmLayout.FillDirection = Enum.FillDirection.Horizontal
wmLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wmLayout.Padding = UDim.new(0, 5)

local wmPad = Instance.new("UIPadding", wmCard)
wmPad.PaddingLeft = UDim.new(0, 8)
wmPad.PaddingRight = UDim.new(0, 8)

local wmTitle = Instance.new("TextLabel", wmCard)
wmTitle.AutomaticSize = Enum.AutomaticSize.X
wmTitle.Size = UDim2.new(0, 0, 1, 0)
wmTitle.BackgroundTransparency = 1
wmTitle.Text = "GESTIO"
wmTitle.TextColor3 = currentTheme.Accent
wmTitle.TextSize = 9
wmTitle.Font = Enum.Font.GothamBold

local wmMetrics = Instance.new("TextLabel", wmCard)
wmMetrics.AutomaticSize = Enum.AutomaticSize.X
wmMetrics.Size = UDim2.new(0, 0, 1, 0)
wmMetrics.BackgroundTransparency = 1
wmMetrics.Text = "FPS: 60 | PING: 0ms"
wmMetrics.TextColor3 = currentTheme.TextSecondary
wmMetrics.TextSize = 8.5
wmMetrics.Font = Enum.Font.GothamBold

local fpsCounter = 0
local lastFpsUpdate = tick()

-- ==========================================
-- COMBAT & FACTION UTILITIES
-- ==========================================
local function isAlly(plr)
    if not plr or plr == player then return false end
    if plr.Team and player.Team then return plr.Team == player.Team end
    if plr:GetAttribute("Team") and player:GetAttribute("Team") then return plr:GetAttribute("Team") == player:GetAttribute("Team") end
    if plr.TeamColor and player.TeamColor and plr.TeamColor ~= BrickColor.new("White") then return plr.TeamColor == player.TeamColor end
    return false
end

local function isTargetEnemy(plr, char)
    if not plr or plr == player then return false end
    if char and char == player.Character then return false end
    return not isAlly(plr)
end

local function isEntityAlive(char, hum)
    if not char or not char.Parent or not char:IsDescendantOf(Workspace) then return false end
    if hum and hum.Parent and hum.Health <= 0 then return false end
    return (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")) ~= nil
end

local function getTargetHitbox(char)
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

local visRayParams = RaycastParams.new()
visRayParams.FilterType = Enum.RaycastFilterType.Exclude
visRayParams.IgnoreWater = true

local function isTargetVisible(originPos, targetPart, targetChar)
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

local function getClosestTarget()
    if not camera then camera = Workspace.CurrentCamera if not camera then return nil end end
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
-- 2D ESP BUILDER
-- ==========================================
local function getOrCreateScreenEsp(plr)
    if screenEspCache[plr] then return screenEspCache[plr] end

    local box = Instance.new("Frame", overlayContainer)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false

    local stroke = Instance.new("UIStroke", box)
    stroke.Color = currentTheme.Enemy_Accent
    stroke.Thickness = boxThickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local boxGrad = Instance.new("UIGradient", box)
    boxGrad.Rotation = 90
    boxGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, currentTheme.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })

    local healthBarBg = Instance.new("Frame", overlayContainer)
    healthBarBg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Visible = false
    Instance.new("UICorner", healthBarBg).CornerRadius = UDim.new(0, 2)

    local healthBarFill = Instance.new("Frame", healthBarBg)
    healthBarFill.AnchorPoint = Vector2.new(0, 1)
    healthBarFill.Position = UDim2.new(0, 0, 1, 0)
    healthBarFill.Size = UDim2.new(1, 0, 1, 0)
    healthBarFill.BackgroundColor3 = currentTheme.HealthHigh
    healthBarFill.BorderSizePixel = 0
    Instance.new("UICorner", healthBarFill).CornerRadius = UDim.new(0, 2)

    local corners = {}
    for i = 1, 4 do
        local hLine = Instance.new("Frame", overlayContainer)
        hLine.BackgroundColor3 = currentTheme.Enemy_Accent
        hLine.BorderSizePixel = 0
        hLine.Visible = false

        local vLine = Instance.new("Frame", overlayContainer)
        vLine.BackgroundColor3 = currentTheme.Enemy_Accent
        vLine.BorderSizePixel = 0
        vLine.Visible = false

        table.insert(corners, {H = hLine, V = vLine})
    end

    local tagCard = Instance.new("Frame", overlayContainer)
    tagCard.AnchorPoint = Vector2.new(0.5, 1)
    tagCard.Size = UDim2.new(0, 0, 0, 16)
    tagCard.AutomaticSize = Enum.AutomaticSize.X
    tagCard.BackgroundColor3 = tagBgColor
    tagCard.BackgroundTransparency = tagTransparency
    tagCard.Visible = false
    Instance.new("UICorner", tagCard).CornerRadius = UDim.new(0, 4)

    local tagStroke = Instance.new("UIStroke", tagCard)
    tagStroke.Color = currentTheme.Border
    tagStroke.Thickness = 0.8

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
        BoxGradient = boxGrad,
        HealthBarBg = healthBarBg,
        HealthBarFill = healthBarFill,
        Corners = corners,
        TagCard = tagCard,
        TagLabel = tagLabel,
        LastText = ""
    }
    screenEspCache[plr] = data
    return data
end

-- ==========================================
-- 3D CHAMS & HIGHLIGHT ATTACHMENT
-- ==========================================
local function attachEspToPlayer(plr)
    if plr == player then return end

    local holder = Instance.new("Folder", mainContainer)
    holder.Name = "GestioESP_" .. plr.Name

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

    local tracerGlow = Instance.new("UIStroke", tracerLine)
    tracerGlow.Color = currentTheme.Enemy_Accent
    tracerGlow.Thickness = bulletTracersGlow and 2 or 0
    tracerGlow.Transparency = 0.3

    local hl = Instance.new("Highlight", holder)
    hl.FillTransparency = 0.45
    hl.OutlineTransparency = 0.0
    hl.Enabled = false
    hl.FillColor = currentTheme.Enemy_Fill
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local espData = {
        Holder = holder,
        HeadDot = dotBillboard,
        DotFrame = dotFrame,
        Tracer = tracerLine,
        TracerGlow = tracerGlow,
        Highlight = hl
    }
    activeEspHolders[plr] = espData

    local function setupCharacter(char)
        if not char then return end
        task.spawn(function()
            local head = char:WaitForChild("Head", 3)
            if head and dotBillboard then dotBillboard.Adornee = head end
            if hl then hl.Adornee = char end
        end)
    end

    if plr.Character then setupCharacter(plr.Character) end
    table.insert(connections, plr.CharacterAdded:Connect(setupCharacter))
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

    if rcsEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local rcsComp = (rcsStrength / 100) * 0.005
        camera.CFrame = camera.CFrame * CFrame.Angles(rcsComp * rcsPitchFactor, 0, 0)
    end

    if aimbotEnabled and isAiming then
        if not lockedTarget or not isEntityAlive(lockedTarget.Char, lockedTarget.Hum) then
            lockedTarget = getClosestTarget()
        else
            local scrPos, onScreen = camera:WorldToViewportPoint(lockedTarget.Position)
            local vp = camera.ViewportSize
            local screenDist = (Vector2.new(scrPos.X, scrPos.Y) - Vector2.new(vp.X * 0.5, vp.Y * 0.5)).Magnitude
            if not onScreen or screenDist > aimFov then
                lockedTarget = getClosestTarget()
            end
        end

        if lockedTarget and lockedTarget.Position then
            local aimPos = lockedTarget.AimPosition or lockedTarget.Position
            if predictionEnabled and lockedTarget.Part and lockedTarget.Part.Parent then
                aimPos = lockedTarget.Part.Position
                if lockedTarget.Part.AssemblyLinearVelocity then
                    aimPos = aimPos + (lockedTarget.Part.AssemblyLinearVelocity * predictionFactor)
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

    if targetHudEnabled and lockedTarget and lockedTarget.Hum and lockedTarget.Player then
        targetHudFrame.Visible = true
        thName.Text = lockedTarget.Player.DisplayName
        local maxH = lockedTarget.Hum.MaxHealth > 0 and lockedTarget.Hum.MaxHealth or 100
        local pct = math.clamp(lockedTarget.Hum.Health / maxH, 0, 1)
        thBarFill.Size = UDim2.new(pct, 0, 1, 0)
        pcall(function()
            thAvatar.Image = Players:GetUserThumbnailAsync(lockedTarget.Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
    else
        targetHudFrame.Visible = false
    end

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

            if fadeChamsEnabled then
                local distAlpha = math.clamp(dist / espMaxDist, 0, 1)
                data.Highlight.FillTransparency = 0.2 + (distAlpha * 0.75)
                data.Highlight.OutlineTransparency = 0.1 + (distAlpha * 0.85)
            else
                local pulse = (math.sin(tick() * 4) + 1) * 0.5
                data.Highlight.FillTransparency = 0.35 + (pulse * 0.2)
                data.Highlight.OutlineTransparency = 0.0
            end

            data.Highlight.FillColor = activeHighlight
            data.Highlight.OutlineColor = isVisible and currentTheme.Accent or Color3.fromRGB(255,255,255)
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
                    if data.TracerGlow then
                        data.TracerGlow.Thickness = bulletTracersGlow and 2.5 or 0
                        data.TracerGlow.Color = activeAccent
                    end
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
        end
    end
end))

-- Health tracking for damage and soul animation
table.insert(connections, RunService.Heartbeat:Connect(function()
    for _, targetPlr in ipairs(Players:GetPlayers()) do
        if targetPlr ~= player then
            local char = targetPlr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and isTargetEnemy(targetPlr, char) and isEntityAlive(char, hum) then
                local currentHealth = hum.Health
                local prevHealth = hitmarkerLastHealth[hum]
                if prevHealth and currentHealth < prevHealth and (prevHealth - currentHealth) > 0.01 then
                    local dmg = prevHealth - currentHealth
                    if hitmarkerEnabled then showHitmarker() end
                    if hitDamageEnabled and char:FindFirstChild("Head") then spawnHitDamageIndicator(char.Head.Position, dmg) end
                    if hitLogsEnabled then pushHitLog(targetPlr.DisplayName, dmg, "Torso") end
                    if currentHealth <= 0 and soulAnimationEnabled and char:FindFirstChild("HumanoidRootPart") then
                        spawnSoulAnimation(char.HumanoidRootPart.Position)
                    end
                end
                hitmarkerLastHealth[hum] = currentHealth
            end
        end
    end
end))

-- ==========================================
-- UI VIEWPORT SETUP
-- ==========================================
local toggleGui = Instance.new("ScreenGui", targetGui)
toggleGui.Name = "GestioToggleGui"
toggleGui.ResetOnSpawn = false
toggleGui.IgnoreGuiInset = true

local openBtn = Instance.new("TextButton", toggleGui)
openBtn.Size = UDim2.new(0, 85, 0, 30)
openBtn.Position = savedPos.OpenBtn
openBtn.BackgroundColor3 = currentTheme.Background
openBtn.Text = "Gestio"
openBtn.TextColor3 = currentTheme.Accent
openBtn.TextSize = 11
openBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)
local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = currentTheme.Border

local screenGui = Instance.new("ScreenGui", targetGui)
screenGui.Name = "GestioScreenGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local masterFrame = Instance.new("Frame", screenGui)
masterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
masterFrame.Size = UDim2.new(0.90, 0, 0.82, 0)
masterFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
masterFrame.BackgroundTransparency = 1

local sizeConstraint = Instance.new("UISizeConstraint", masterFrame)
sizeConstraint.MaxSize = Vector2.new(740, 320)
sizeConstraint.MinSize = Vector2.new(300, 200)

local masterLayout = Instance.new("UIListLayout", masterFrame)
masterLayout.FillDirection = Enum.FillDirection.Horizontal
masterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
masterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
masterLayout.Padding = UDim.new(0, 6)

local function toggleMenu() masterFrame.Visible = not masterFrame.Visible end
bindTouch(openBtn, toggleMenu)

local mainFrame = Instance.new("Frame", masterFrame)
mainFrame.Size = UDim2.new(0.58, 0, 1, 0)
mainFrame.BackgroundColor3 = currentTheme.Background
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = currentTheme.Border

local sidebar = Instance.new("ScrollingFrame", mainFrame)
sidebar.Size = UDim2.new(0, 75, 1, -8)
sidebar.Position = UDim2.new(0, 4, 0, 4)
sidebar.BackgroundColor3 = currentTheme.Sidebar
sidebar.ScrollBarThickness = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local sbLayout = Instance.new("UIListLayout", sidebar)
sbLayout.FillDirection = Enum.FillDirection.Vertical
sbLayout.Padding = UDim.new(0, 3)
sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createNavBtn(txt)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(0.88, 0, 0, 19)
    b.BackgroundColor3 = currentTheme.Sidebar
    b.TextColor3 = currentTheme.TextSecondary
    b.Text = txt
    b.TextSize = 7.5
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local cBtn = createNavBtn("COMBAT")
local mBtn = createNavBtn("MOVEMENT")
local eBtn = createNavBtn("ESP")
local sBtn = createNavBtn("SKINS")
local envBtn = createNavBtn("ENV")
local micsBtn = createNavBtn("MICS")
local setsBtn = createNavBtn("SETTINGS")
cBtn.BackgroundColor3 = currentTheme.CardBg
cBtn.TextColor3 = currentTheme.Accent

local function makePageContainer()
    local c = Instance.new("ScrollingFrame", mainFrame)
    c.Size = UDim2.new(1, -84, 1, -12)
    c.Position = UDim2.new(0, 80, 0, 6)
    c.BackgroundTransparency = 1
    c.ScrollBarThickness = 2
    c.CanvasSize = UDim2.new(0, 0, 0, 900)
    c.Visible = false
    local list = Instance.new("UIListLayout", c)
    list.Padding = UDim.new(0, 10)
    return c
end

local cPage = makePageContainer()
local mPage = makePageContainer()
local ePage = makePageContainer()
local sPage = makePageContainer()
local envPage = makePageContainer()
local micsPage = makePageContainer()
local setsPage = makePageContainer()
cPage.Visible = true

local function switch(tab)
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
-- INSPECTOR SYSTEM
-- ==========================================
local inspectorPanel = Instance.new("Frame", masterFrame)
inspectorPanel.Size = UDim2.new(0.40, 0, 1, 0)
inspectorPanel.BackgroundColor3 = currentTheme.Background
Instance.new("UICorner", inspectorPanel).CornerRadius = UDim.new(0, 8)
local insStroke = Instance.new("UIStroke", inspectorPanel)
insStroke.Color = currentTheme.Border

local insHeader = Instance.new("TextLabel", inspectorPanel)
insHeader.Size = UDim2.new(1, -38, 0, 26)
insHeader.Position = UDim2.new(0, 10, 0, 4)
insHeader.BackgroundTransparency = 1
insHeader.Text = "Settings"
insHeader.TextColor3 = currentTheme.TextPrimary
insHeader.TextSize = 10
insHeader.Font = Enum.Font.GothamBold
insHeader.TextXAlignment = Enum.TextXAlignment.Left

local insContent = Instance.new("ScrollingFrame", inspectorPanel)
insContent.Size = UDim2.new(1, 0, 1, -32)
insContent.Position = UDim2.new(0, 0, 0, 30)
insContent.BackgroundTransparency = 1
insContent.ScrollBarThickness = 2
insContent.CanvasSize = UDim2.new(0, 0, 0, 650)

local function addInspectorSlider(y, txt, min, max, cur, isFloat, onChange)
    local lbl = Instance.new("TextLabel", insContent)
    lbl.Size = UDim2.new(0.86, 0, 0, 12)
    lbl.Position = UDim2.new(0.07, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = currentTheme.TextSecondary
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextSize = 8.5
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = isFloat and string.format("%s: %.2fx", txt, cur) or string.format("%s: %d", txt, cur)

    local track = Instance.new("TextButton", insContent)
    track.Size = UDim2.new(0.86, 0, 0, 6)
    track.Position = UDim2.new(0.07, 0, 0, y + 14)
    track.BackgroundColor3 = currentTheme.Border
    track.Text = ""
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(math.clamp((cur - min) / (max - min), 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = currentTheme.Accent
    fill.BorderSizePixel = 0
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

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true; update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

local function addInspectorToggle(y, txt, default, onToggle)
    local f = Instance.new("Frame", insContent)
    f.Size = UDim2.new(0.86, 0, 0, 20)
    f.Position = UDim2.new(0.07, 0, 0, y)
    f.BackgroundTransparency = 1

    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(0.7, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = txt
    t.TextColor3 = currentTheme.TextSecondary
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextSize = 8.5
    t.Font = Enum.Font.GothamBold

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 26, 0, 14)
    btn.Position = UDim2.new(1, -26, 0.5, -7)
    btn.BackgroundColor3 = default and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 10, 0, 10)
    circle.Position = default and UDim2.new(1, -11, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = default
    bindTouch(btn, function()
        state = not state
        btn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
        circle.Position = state and UDim2.new(1, -11, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
        onToggle(state)
    end)
end

local function addInspectorChoice(y, txt, choices, currentChoice, onSelect)
    local row = Instance.new("Frame", insContent)
    row.Size = UDim2.new(0.86, 0, 0, 28)
    row.Position = UDim2.new(0.07, 0, 0, y)
    row.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.34, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = txt
    lbl.TextColor3 = currentTheme.TextSecondary
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextSize = 8.5
    lbl.Font = Enum.Font.GothamBold

    local dropdown = Instance.new("TextButton", row)
    dropdown.Size = UDim2.new(0.66, 0, 0, 26)
    dropdown.Position = UDim2.new(0.34, 0, 0.5, -13)
    dropdown.BackgroundColor3 = currentTheme.CardBg
    dropdown.Text = ""
    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 5)

    local selectedLabel = Instance.new("TextLabel", dropdown)
    selectedLabel.Size = UDim2.new(1, -30, 1, 0)
    selectedLabel.Position = UDim2.new(0, 10, 0, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = currentChoice
    selectedLabel.TextColor3 = currentTheme.TextPrimary
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.TextSize = 8
    selectedLabel.Font = Enum.Font.GothamBold

    local list = Instance.new("Frame", insContent)
    list.Size = UDim2.new(0.5676, 0, 0, 0)
    list.Position = UDim2.new(0.3624, 0, 0, y + 31)
    list.BackgroundColor3 = currentTheme.CardBg
    list.Visible = false
    list.ZIndex = 100
    list.ClipsDescendants = true
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 5)
    local layout = Instance.new("UIListLayout", list)

    local open = false
    local function toggle()
        open = not open
        list.Visible = open
        list.Size = open and UDim2.new(0.5676, 0, 0, #choices * 25 + 2) or UDim2.new(0.5676, 0, 0, 0)
    end

    for i, choiceName in ipairs(choices) do
        local option = Instance.new("TextButton", list)
        option.Size = UDim2.new(1, -2, 0, 25)
        option.BackgroundColor3 = (choiceName == currentChoice) and currentTheme.Accent or currentTheme.CardBg
        option.Text = choiceName
        option.TextColor3 = Color3.fromRGB(255, 255, 255)
        option.TextSize = 8
        option.Font = Enum.Font.GothamBold
        option.ZIndex = 101
        bindTouch(option, function()
            selectedLabel.Text = choiceName
            toggle()
            onSelect(choiceName)
        end)
    end
    bindTouch(dropdown, toggle)
end

local function openInspectorFor(moduleName)
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
    elseif moduleName == "Box Overlay" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 240)
        addInspectorSlider(6, "Max Distance", 100, 5000, espMaxDist, false, function(v) espMaxDist = v end)
        addInspectorSlider(38, "Thickness", 1.0, 3.0, boxThickness, true, function(v) boxThickness = v end)
        addInspectorToggle(76, "Corner Box", cornerBoxEnabled, function(v) cornerBoxEnabled = v end)
        addInspectorToggle(108, "Health Bar", healthBarEnabled, function(v) healthBarEnabled = v end)
        addInspectorToggle(136, "Gradient Hitbox", hitboxGradientEnabled, function(v) hitboxGradientEnabled = v end)
    elseif moduleName == "Highlight" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 120)
        addInspectorToggle(6, "Fade Chams", fadeChamsEnabled, function(v) fadeChamsEnabled = v end)
    elseif moduleName == "Snaplines" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 120)
        addInspectorToggle(6, "Tracer Glow", bulletTracersGlow, function(v) bulletTracersGlow = v end)
    elseif moduleName == "Soul Animation" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 120)
        addInspectorChoice(6, "Direction", {"Right", "Left"}, animationDirection, function(v) animationDirection = v end)
    else
        local lbl = Instance.new("TextLabel", insContent)
        lbl.Size = UDim2.new(0.86, 0, 0, 30)
        lbl.Position = UDim2.new(0.07, 0, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Module active and synchronized."
        lbl.TextColor3 = currentTheme.TextSecondary
        lbl.TextSize = 8.5
        lbl.Font = Enum.Font.Gotham
    end
end

-- ==========================================
-- CATEGORY & CARD BUILDERS
-- ==========================================
local function makeCategorySection(page, title, count)
    local gridHeight = math.ceil((count or 4) / 4) * 64
    local container = Instance.new("Frame", page)
    container.Size = UDim2.new(1, 0, 0, 22 + gridHeight)
    container.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", container)
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text = title:upper()
    lbl.TextColor3 = currentTheme.Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 8.5
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local grid = Instance.new("Frame", container)
    grid.Position = UDim2.new(0, 0, 0, 20)
    grid.Size = UDim2.new(1, 0, 0, gridHeight)
    grid.BackgroundTransparency = 1
    local gl = Instance.new("UIGridLayout", grid)
    gl.CellSize = UDim2.new(0, 58, 0, 58)
    gl.CellPadding = UDim2.new(0, 6, 0, 6)
    return grid
end

local function addCard(parent, name, defaultState, onToggle)
    local card = Instance.new("Frame", parent)
    card.BackgroundColor3 = currentTheme.CardBg
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", card)
    s.Color = currentTheme.Border

    local txt = Instance.new("TextButton", card)
    txt.Size = UDim2.new(1, -4, 0, 24)
    txt.Position = UDim2.new(0, 2, 0, 2)
    txt.BackgroundTransparency = 1
    txt.Text = name
    txt.TextColor3 = currentTheme.TextPrimary
    txt.TextSize = 7.5
    txt.Font = Enum.Font.GothamBold
    txt.TextWrapped = true
    bindTouch(txt, function() openInspectorFor(name) end)

    local toggle = Instance.new("TextButton", card)
    toggle.Size = UDim2.new(0, 24, 0, 13)
    toggle.Position = UDim2.new(0.5, -12, 1, -16)
    toggle.BackgroundColor3 = defaultState and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
    toggle.Text = ""
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local circ = Instance.new("Frame", toggle)
    circ.Size = UDim2.new(0, 9, 0, 9)
    circ.Position = defaultState and UDim2.new(1, -10, 0.5, -4.5) or UDim2.new(0, 2, 0.5, -4.5)
    circ.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circ).CornerRadius = UDim.new(1, 0)

    local state = defaultState
    bindTouch(toggle, function()
        state = not state
        toggle.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
        circ.Position = state and UDim2.new(1, -10, 0.5, -4.5) or UDim2.new(0, 2, 0.5, -4.5)
        onToggle(state)
    end)
end

-- MODULE POPULATION
local cSec = makeCategorySection(cPage, "Aim & Ballistics", 4)
addCard(cSec, "Tracking", aimbotEnabled, function(v) aimbotEnabled = v end)
addCard(cSec, "RCS", rcsEnabled, function(v) rcsEnabled = v end)
addCard(cSec, "Trigger Assistant", triggerbotEnabled, function(v) triggerbotEnabled = v end)
addCard(cSec, "Target HUD", targetHudEnabled, function(v) targetHudEnabled = v end)

local eSec = makeCategorySection(ePage, "Visual Engine", 9)
addCard(eSec, "Nametags", nametagsEnabled, function(v) nametagsEnabled = v end)
addCard(eSec, "Highlight", highlightEnabled, function(v) highlightEnabled = v end)
addCard(eSec, "Box Overlay", boxEspEnabled, function(v) boxEspEnabled = v end)
addCard(eSec, "Hitmarker", hitmarkerEnabled, function(v) hitmarkerEnabled = v end)
addCard(eSec, "Soul Animation", soulAnimationEnabled, function(v) soulAnimationEnabled = v end)
addCard(eSec, "Hit Logs", hitLogsEnabled, function(v) hitLogsEnabled = v end)
addCard(eSec, "Hit Damage", hitDamageEnabled, function(v) hitDamageEnabled = v end)
addCard(eSec, "Fade Chams", fadeChamsEnabled, function(v) fadeChamsEnabled = v end)
addCard(eSec, "Snaplines", tracersEnabled, function(v) tracersEnabled = v end)

openInspectorFor("Tracking")
