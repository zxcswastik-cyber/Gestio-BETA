-- XC cleaned UI build
-- Unified XC lime/dark interface
pcall(function()
    if type(getgenv) == "function" then
        local env = getgenv()
        if env and type(env.XCRunning) == "function" then
            env.XCRunning()
        end
    end
end)

-- ==========================================
-- XC UI layer
-- ==========================================
local XCIcons = {
    Combat = "⌁",
    Visuals = "◉",
    Players = "♙",
    World = "◈",
    Movement = "↯",
    Misc = "⚙",
    Config = "▣",
    Scripts = "⌘",
    Search = "⌕",
    Settings = "⚙",
    Info = "ⓘ",
}

local function XCIcon(parent, glyph, size, color)
    local label = Instance.new("TextLabel")
    label.Name = "XCIcon"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, size or 18, 0, size or 18)
    label.Text = glyph or "•"
    label.Font = Enum.Font.GothamBold
    label.TextSize = math.max(12, math.floor((size or 18) * 0.78))
    label.TextColor3 = color or Color3.fromRGB(152, 204, 0)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

-- ==========================================
-- CENTRAL CONFIGURATION SYSTEM
-- ==========================================
local HttpService = game:GetService("HttpService")

local XCConfig = {
    -- Toggles
    antiAfkEnabled = false,
    noFallDamageEnabled = false,
    spectatorListEnabled = false,
    spectatorCounterEnabled = true,
    spectatorHideEmpty = false,
    spectatorNameMode = "Display name",
    animationsEnabled = false,
    animationLoop = true,
    animationSpeed = 1.0,
    animationId = "73593666217037",
    customHandsEnabled = false,
    customHandsX = 0,
    customHandsY = 0,
    customHandsZ = 0,
    customHandsPitch = 0,
    customHandsYaw = 0,
    customHandsRoll = 0,
    uiScale = 1.0,
    watermarkEnabled = true,
    watermarkShowFPS = true,
    watermarkShowPing = true,
    watermarkShowName = false,
    watermarkText = "XC",
    aimbotEnabled = false,
    predictionEnabled = true,
    silentAimEnabled = false,
    rcsEnabled = false,
    chamsEnabled = false,
    hitmarkerEnabled = false,
    thirdPersonEnabled = false,
    skinChangerEnabled = false,
    triggerbotEnabled = false,
    antiAimEnabled = false,
    bunnyHopEnabled = false,
    slideEnabled = false,
    speedEnabled = false,
    flightEnabled = false,
    nametagsEnabled = false,
    boxEspEnabled = false,
    cornerBoxEnabled = false,
    healthBarEnabled = true,
    headDotEnabled = false,
    tracersEnabled = false,
    grenadeEspEnabled = false,
    jumpCircleEnabled = false,
    antiFlashEnabled = false,
    fullBrightEnabled = false,
    removeFogEnabled = true,
    nightModeEnabled = false,
    rageBotEnabled = false,
    rageAutoFire = true,
    bulletTrailEnabled = true,
    bulletFlashEnabled = true,
    weaponChamsEnabled = false,
    customScopeEnabled = false,
    scopeRemoveOriginal = false,
    scopeCrosshairEnabled = true,
    scopeDynamicGap = false,
    scopeCrosshairStyle = "Cross",
    scopeCrosshairLeft = true,
    scopeCrosshairRight = true,
    scopeCrosshairTop = true,
    scopeCrosshairBottom = true,
    scopeCrosshairDot = true,
    scopeCrosshairOpacity = 0,
    scopeCrosshairOutline = false,
    scopeCrosshairOutlineThickness = 1,
    scopeCrosshairOutlineR = 0,
    scopeCrosshairOutlineG = 0,
    scopeCrosshairOutlineB = 0,
    worldSkyboxEnabled = false,
    worldPostFXEnabled = false,
    weatherEnabled = false,
    weatherMode = "Rain",
    weatherIntensity = 45,
    weatherWind = 8,
    freecamEnabled = false,
    freecamSpeed = 55,
    freecamSensitivity = 0.18,
    freecamKey = "F4",
    freelookEnabled = false,
    freelookSensitivity = 0.16,
    freelookKey = "LeftAlt",
    streamerModeEnabled = false,
    streamerKey = "F8",
    settingsShowNotifications = true,
    settingsCompactMode = false,
    menuKey = "RightShift",

    -- Sliders & Values
    rageFov = 360,
    rageTargetMode = "Distance",
    priorityPlayerName = "None",
    aimFov = 160,
    triggerbotFov = 160,
    aimbotSpeed = 35.0,
    aimbotSmoothness = 0.15,
    predictionFactor = 0.165,
    bodyAimOnly = false,
    snapAimMode = false,
    showFovCircle = true,
    visibleCheck = false,
    
    silentAimFov = 150,
    silentAimHitChance = 100,
    silentAimTeamCheck = true,
    silentAimVisibleCheck = false,
    silentAimAimHead = true,
    pSilentEnabled = false,
    wallbangEnabled = false,
    showSilentFovCircle = true,

    chamsFillTransparency = 0.45,
    chamsOutlineTransparency = 0.10,
    chamsTeamCheck = true,
    chamsShowTeammates = false,
    chamsOcclusion = true,

    recoilStrength = 0.85,
    noRecoilEnabled = false,
    noSpreadEnabled = false,
    fireRateEnabled = false,
    fireRate = 0.01,
    rcsStrength = 60,
    rcsPitchFactor = 1.0,
    rcsYawFactor = 1.0,

    thirdPersonDistance = 12,
    thirdPersonHeight = 1.5,
    thirdPersonOffset = 2.5,

    hitmarkerDuration = 0.28,
    hitmarkerSize = 13,
    hitmarkerThickness = 2,
    hitmarkerGlow = true,

    spinSpeed = 50,
    bhopJumpPower = 52,
    bhopSpeedBoost = 1.35,
    bhopAutoJump = false,
    bhopAirStrafe = true,
    walkMultiplier = 2.0,
    flightSpeed = 50,

    slideSpeedBoost = 1.8,
    slideFriction = 0.94,
    slideMinSpeed = 16,

    jumpCircleRadius = 3.5,
    jumpCircleSegmentCount = 48,
    jumpCircleStyle = "GradientWave",

    grenadeMaxDist = 1500,
    showGrenadePath = true,
    showMolotovRadius = true,
    showSmokeRadius = true,

    espMaxDist = 3000,
    espTextSize = 8.5,
    tagTransparency = 0.25,
    espShowDistance = true,
    espShowHealth = true,
    tagShowWeapon = true,
    boxThickness = 1.0,

    nightPreset = "Midnight",
    nightBrightness = 0.2,
    nightClockTime = 0.0,
    worldSkyboxPreset = "Night",
    worldFogStart = 0,
    worldFogEnd = 100000,
    worldExposure = 0,
    worldSaturation = 0,
    worldContrast = 0,
    worldColorR = 255,
    worldColorG = 255,
    worldColorB = 255,
    bulletTracerStyle = "Block",
    bulletTracerDuration = 0.65,
    bulletTracerWidth = 0.08,
    bulletTracerRainbow = false,
    bulletImpactEnabled = false,
    bulletImpactSize = 0.35,
    cubeCheckerEnabled = false,
    cubeCheckerRainbow = false,
    cubeCheckerSize = 1.5,
    cubeCheckerDistance = 20,
    cubeCheckerLineThickness = 0.04,
    cubeCheckerTransparency = 0.2,
    bulletTracerColorR = 255,
    bulletTracerColorG = 25,
    bulletTracerColorB = 35,
    weaponChamsMode = "Crystal",
    weaponChamsTransparency = 0.22,
    weaponChamsReflectance = 0.75,
    weaponChamsColorR = 210,
    weaponChamsColorG = 45,
    weaponChamsColorB = 55,
    scopeFovEnabled = false,
    scopeFov = 70,
    customFovEnabled = false,
    customFov = 90,
    scopeCrosshairLength = 85,
    scopeCrosshairThickness = 2,
    scopeCrosshairGap = 8,
    scopeCrosshairColorR = 255,
    scopeCrosshairColorG = 255,
    scopeCrosshairColorB = 255,
    selectedKnifeType = "Butterfly Knife",
    selectedSkin = "Fade",
    gloveChangerEnabled = false,
    selectedGloveModel = "Sports Gloves",
    selectedGloveSkin = "Default",
    weaponSkinSelections = {}
}

-- Immutable startup snapshot used by Settings > Config Manager > RESET.
local function deepCopyConfigValue(v)
    if type(v) ~= "table" then return v end
    local out = {}
    for k,val in pairs(v) do out[k] = deepCopyConfigValue(val) end
    return out
end
local XCConfigDefaults = deepCopyConfigValue(XCConfig)

-- Reuse one configuration table between reinjections. Persistent hooks from a
-- previous run then continue to read the values controlled by the new menu.
local sharedXCEnv = (type(getgenv) == "function") and getgenv() or nil
if sharedXCEnv then
    if type(sharedXCEnv.XCSharedConfig) == "table" then
        local existing = sharedXCEnv.XCSharedConfig
        for key, value in pairs(XCConfig) do
            if existing[key] == nil then existing[key] = deepCopyConfigValue(value) end
        end
        XCConfig = existing
    else
        sharedXCEnv.XCSharedConfig = XCConfig
    end
end

-- A reinjection must start from safe toggle defaults. Numeric/user settings
-- remain shared, but an old session cannot silently reactivate expensive
-- scanners or render modules before the user opens the new menu.
for key, defaultValue in pairs(XCConfigDefaults) do
    if type(defaultValue) == "boolean" then XCConfig[key] = defaultValue end
end

local UI_Bind_Registry = {}
-- Expensive executor scans are opt-in for the current session. Persisted
-- config values never trigger getgc work merely by injecting the script.
local lazyFeatureRequests = {
    fireRate = false,
    recoilSpread = false,
    silentFallback = false,
}

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
-- CLIENT ENVIRONMENT VALIDATION XC
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
    warn("[XC] GUI initialization failed: no valid GUI parent")
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
local antiAfkConnection = nil
local activeJumpCircleData = nil

local genv = (type(getgenv) == "function") and getgenv() or nil
local xcSessionToken = {}
if genv then genv.XCSessionToken = xcSessionToken end
local function xcSessionActive()
    return not genv or genv.XCSessionToken == xcSessionToken
end
if genv and not genv.XCSavedPos then
    genv.XCSavedPos = {
        OpenBtn = UDim2.new(0.5, -45, 0, 15),
        MainFrame = UDim2.new(0.5, 0, 0.5, 0)
    }
end
local savedPos = (genv and genv.XCSavedPos) or {
    OpenBtn = UDim2.new(0.5, -45, 0, 15),
    MainFrame = UDim2.new(0.5, 0, 0.5, 0)
}

-- ==========================================
-- EXTENDED THEME & PALETTE SYSTEM
-- ==========================================
local themeLibrary = {
    ["XC Lime"] = {
        Name = "XC Lime",
        Background = Color3.fromRGB(18, 18, 22),
        Sidebar = Color3.fromRGB(22, 22, 27),
        CardBg = Color3.fromRGB(28, 28, 34),
        Accent = Color3.fromRGB(152, 204, 0),
        AccentHover = Color3.fromRGB(180, 225, 25),
        TextPrimary = Color3.fromRGB(240, 240, 245),
        TextSecondary = Color3.fromRGB(150, 150, 160),
        Border = Color3.fromRGB(45, 45, 55),
        GridSquare = Color3.fromRGB(25, 25, 30),
        Enemy_Accent = Color3.fromRGB(235, 75, 75),
        Enemy_Fill = Color3.fromRGB(220, 50, 50),
        Enemy_Hidden = Color3.fromRGB(120, 125, 135),
        NametagTextColor = Color3.fromRGB(255,255,255),
        HealthHigh = Color3.fromRGB(70,200,110),
        HealthMid = Color3.fromRGB(230,190,40),
        HealthLow = Color3.fromRGB(230,70,70),
        MolotovColor = Color3.fromRGB(255,95,35),
        SmokeColor = Color3.fromRGB(180,185,195),
        HEColor = Color3.fromRGB(255,45,55)
    }
}

local currentTheme = themeLibrary["XC Lime"]

-- ==========================================
-- XC NOTIFICATION CENTER
-- ==========================================
local XCNotificationGui = nil
local XCNotificationHolder = nil
local XCNotificationSerial = 0

local function ensureXCNotifications()
    if XCNotificationGui and XCNotificationGui.Parent and XCNotificationHolder and XCNotificationHolder.Parent then
        return true
    end

    pcall(function()
        local old = targetGui:FindFirstChild("XCNotificationsGui")
        if old then old:Destroy() end
    end)

    XCNotificationGui = Instance.new("ScreenGui")
    XCNotificationGui.Name = "XCNotificationsGui"
    XCNotificationGui.ResetOnSpawn = false
    XCNotificationGui.IgnoreGuiInset = true
    XCNotificationGui.DisplayOrder = 250
    XCNotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    XCNotificationGui.Parent = targetGui

    XCNotificationHolder = Instance.new("Frame")
    XCNotificationHolder.Name = "NotificationHolder"
    XCNotificationHolder.AnchorPoint = Vector2.new(1, 1)
    XCNotificationHolder.Position = UDim2.new(1, -18, 1, -18)
    XCNotificationHolder.Size = UDim2.new(0, 300, 1, -36)
    XCNotificationHolder.BackgroundTransparency = 1
    XCNotificationHolder.Parent = XCNotificationGui

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 8)
    layout.Parent = XCNotificationHolder

    return true
end

function XCNotify(title, message, kind, duration)
    if XCConfig.settingsShowNotifications == false then return end
    if not ensureXCNotifications() then return end

    XCNotificationSerial = XCNotificationSerial + 1
    local serial = XCNotificationSerial
    title = tostring(title or "XC")
    message = tostring(message or "")
    duration = tonumber(duration) or 2.5

    local accent = currentTheme.Accent
    if kind == "success" then
        accent = Color3.fromRGB(75, 190, 105)
    elseif kind == "warning" then
        accent = Color3.fromRGB(225, 165, 55)
    elseif kind == "error" then
        accent = Color3.fromRGB(225, 65, 70)
    end

    local card = Instance.new("Frame")
    card.Name = "Toast_" .. serial
    card.Size = UDim2.new(1, 0, 0, 64)
    card.BackgroundColor3 = currentTheme.Background
    card.BackgroundTransparency = 0.04
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.LayoutOrder = serial
    card.Parent = XCNotificationHolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = currentTheme.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.05
    stroke.Parent = card

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, -14)
    accentBar.Position = UDim2.new(0, 7, 0, 7)
    accentBar.BackgroundColor3 = accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0, 17, 0, 10)
    icon.BackgroundColor3 = currentTheme.Sidebar
    icon.BackgroundTransparency = 0.1
    icon.Text = kind == "error" and "!" or kind == "warning" and "!" or "✓"
    icon.TextColor3 = accent
    icon.TextSize = 14
    icon.Font = Enum.Font.GothamBold
    icon.Parent = card
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -62, 0, 19)
    titleLabel.Position = UDim2.new(0, 53, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = currentTheme.TextPrimary
    titleLabel.TextSize = 9
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = card

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -62, 0, 25)
    msgLabel.Position = UDim2.new(0, 53, 0, 27)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = currentTheme.TextSecondary
    msgLabel.TextSize = 8
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextWrapped = true
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextYAlignment = Enum.TextYAlignment.Top
    msgLabel.Parent = card

    local progress = Instance.new("Frame")
    progress.Size = UDim2.new(1, -14, 0, 2)
    progress.Position = UDim2.new(0, 7, 1, -5)
    progress.BackgroundColor3 = currentTheme.Sidebar
    progress.BorderSizePixel = 0
    progress.Parent = card

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = accent
    fill.BorderSizePixel = 0
    fill.Parent = progress

    card.Position = UDim2.new(1, 24, 0, 0)
    card.BackgroundTransparency = 1
    titleLabel.TextTransparency = 1
    msgLabel.TextTransparency = 1
    icon.TextTransparency = 1
    accentBar.BackgroundTransparency = 1

    TweenService:Create(card, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.04
    }):Play()
    TweenService:Create(titleLabel, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    TweenService:Create(msgLabel, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    TweenService:Create(icon, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    TweenService:Create(accentBar, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    TweenService:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

    task.delay(duration, function()
        if not card or not card.Parent then return end
        local out = TweenService:Create(card, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 24, 0, 0), BackgroundTransparency = 1
        })
        out:Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.18), {TextTransparency = 1}):Play()
        TweenService:Create(msgLabel, TweenInfo.new(0.18), {TextTransparency = 1}):Play()
        TweenService:Create(icon, TweenInfo.new(0.18), {TextTransparency = 1}):Play()
        TweenService:Create(accentBar, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
        out.Completed:Wait()
        if card then card:Destroy() end
    end)
end

-- ==========================================
-- COMBAT ENGINE STATE VARIABLES
-- ==========================================
local isAiming = false
local currentAimTarget = nil
local lastTargetSwitchTick = 0
local TARGET_HYSTERESIS_TIME = 0.12
local aimboneIndex = 1

local function rgb(r,g,b)
    return Color3.fromRGB(
        math.clamp(math.floor(tonumber(r) or 255), 0, 255),
        math.clamp(math.floor(tonumber(g) or 255), 0, 255),
        math.clamp(math.floor(tonumber(b) or 255), 0, 255)
    )
end

local silentAimResolved = nil
-- Forward declarations: the shoot hook is defined before the Silent Aim helpers.
local getSilentAimTarget
local silentAimCamPosAim
local silentAimHooked = false
local silentAimCamHooked = false
local bloxStrikeShootHooked = false

local function setupBloxStrikeShootHook()
    if bloxStrikeShootHooked then return end
    
    pcall(function()
        local visualInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                local char = player.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                
                if (XCConfig.bulletTrailEnabled or XCConfig.bulletFlashEnabled) and tool then
                    local cam = Workspace.CurrentCamera or camera
                    if not cam then return end
                    
                    local origin = cam.CFrame.Position
                    local muzzle = tool:FindFirstChild("Muzzle") or tool:FindFirstChild("Handle")
                    if muzzle and muzzle:IsA("BasePart") then
                        origin = muzzle.Position
                    end

                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    rayParams.FilterDescendantsInstances = {player.Character, camera}
                    rayParams.IgnoreWater = true
                    
                    local hit = Workspace:Raycast(origin, cam.CFrame.LookVector * 500, rayParams)
                    local bulletEnd = hit and hit.Position or (origin + cam.CFrame.LookVector * 500)
                    local dist = (origin - bulletEnd).Magnitude

                    if XCConfig.bulletTrailEnabled then
                        local trail = Instance.new("Part")
                        trail.Anchored = true
                        trail.CanCollide = false
                        trail.CanTouch = false
                        trail.CanQuery = false
                        trail.CastShadow = false
                        trail.Material = (XCConfig.bulletTracerStyle == "Cylinder") and Enum.Material.Neon or Enum.Material.Neon
                        trail.Color = XCConfig.bulletTracerRainbow and Color3.fromHSV((os.clock()*0.35)%1,0.9,1) or rgb(XCConfig.bulletTracerColorR,XCConfig.bulletTracerColorG,XCConfig.bulletTracerColorB)
                        local width = math.clamp(tonumber(XCConfig.bulletTracerWidth) or 0.08, 0.02, 0.5)
                        if XCConfig.bulletTracerStyle == "Cylinder" then
                            trail.Shape = Enum.PartType.Cylinder
                            trail.Size = Vector3.new(dist, width, width)
                            trail.CFrame = CFrame.lookAt(origin, bulletEnd) * CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-dist/2,0,0)
                        else
                            trail.Size = Vector3.new(width, width, dist)
                            trail.CFrame = CFrame.lookAt(origin, bulletEnd) * CFrame.new(0, 0, -dist / 2)
                        end
                        trail.Parent = Workspace
                        local duration = math.clamp(tonumber(XCConfig.bulletTracerDuration) or 0.65, 0.05, 10)
                        TweenService:Create(trail, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1}):Play()
                        task.delay(duration + 0.05, function() pcall(function() trail:Destroy() end) end)
                    end

                    if XCConfig.bulletImpactEnabled then
                        local impact = Instance.new("Part")
                        impact.Anchored = true; impact.CanCollide = false; impact.CanTouch = false; impact.CanQuery = false; impact.CastShadow = false
                        impact.Shape = Enum.PartType.Ball
                        impact.Material = Enum.Material.Neon
                        impact.Color = XCConfig.bulletTracerRainbow and Color3.fromHSV((os.clock()*0.35)%1,0.9,1) or rgb(XCConfig.bulletTracerColorR,XCConfig.bulletTracerColorG,XCConfig.bulletTracerColorB)
                        local sz = math.clamp(tonumber(XCConfig.bulletImpactSize) or 0.35, 0.05, 2)
                        impact.Size = Vector3.new(sz,sz,sz)
                        impact.CFrame = CFrame.new(bulletEnd)
                        impact.Parent = Workspace
                        TweenService:Create(impact, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=Vector3.zero, Transparency=1}):Play()
                        task.delay(0.4, function() pcall(function() impact:Destroy() end) end)
                    end

                    if XCConfig.bulletFlashEnabled then
                        local flash = Instance.new("Part")
                        flash.Anchored = true; flash.CanCollide = false; flash.CanTouch = false; flash.CanQuery = false; flash.CastShadow = false
                        flash.Material = Enum.Material.Neon
                        flash.Color = rgb(255,80,80)
                        flash.Shape = Enum.PartType.Ball
                        flash.Size = Vector3.new(0.6,0.6,0.6)
                        flash.CFrame = CFrame.new(origin)
                        flash.Parent = Workspace
                        TweenService:Create(flash, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=Vector3.zero, Transparency=1}):Play()
                        task.delay(0.15, function() pcall(function() flash:Destroy() end) end)
                    end
                end
            end
        end)
        table.insert(connections, visualInputConnection)
    end)

    pcall(function()
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        local moduleScript = controllers and controllers:FindFirstChild("InventoryController")
        if not moduleScript then return end

        local inventoryController = require(moduleScript)
        if type(inventoryController) ~= "table" then return end
        if type(inventoryController.ShootWeapon) ~= "function" then return end
        if rawget(inventoryController, "__XCShootHooked") then
            bloxStrikeShootHooked = true
            return
        end

        local originalShootWeapon = inventoryController.ShootWeapon
        inventoryController.ShootWeapon = function(self, data, ...)
            if XCConfig.silentAimEnabled
                and type(data) == "table"
                and type(data.Bullets) == "table" then

                -- Resolve the target at the actual weapon call instead of relying only
                -- on the RenderStepped snapshot. This removes frame-rate dependent
                -- target staleness for automatic weapons and multi-pellet shots.
                local shotTarget = getSilentAimTarget and getSilentAimTarget() or nil
                local shotAllowed = true

                -- Hit chance is evaluated once per actual ShootWeapon invocation.
                -- A single invocation may contain multiple pellets; they share the
                -- same decision so one shot is not partially modified.
                if XCConfig.silentAimHitChance < 100 then
                    shotAllowed = math.random(1, 100) <= math.clamp(XCConfig.silentAimHitChance, 0, 100)
                end

                if shotTarget and shotAllowed then
                    local camPos, aimPos = silentAimCamPosAim(shotTarget)
                    if camPos and aimPos then
                        for _, bullet in pairs(data.Bullets) do
                            if type(bullet) == "table" then
                                local origin = bullet.Origin
                                    or bullet.StartingPoint
                                    or bullet.Position
                                    or camPos

                                if typeof(origin) == "CFrame" then
                                    origin = origin.Position
                                end

                                if typeof(origin) == "Vector3" then
                                    local delta = aimPos - origin
                                    if delta.Magnitude > 0.001 then
                                        -- Keep XC's direction rewrite.
                                        bullet.Direction = delta.Unit
                                    end

                                    -- XC-style authoritative hit payload rewrite.
                                    if type(bullet.Hits) == "table" then
                                        for _, hitData in pairs(bullet.Hits) do
                                            if type(hitData) == "table" then
                                                hitData.Instance = shotTarget
                                                hitData.Position = shotTarget.Position
                                            end
                                        end
                                    end

                                    if XCConfig.wallbangEnabled then
                                        bullet.Penetration = 9999
                                        bullet.Wallbang = true
                                        bullet.IgnoreEnvironment = true
                                    end
                                end
                            end
                        end
                    end
                end
            end

            return originalShootWeapon(self, data, ...)
        end

        rawset(inventoryController, "__XCShootHooked", true)
        bloxStrikeShootHooked = true
    end)
end

-- ==========================================
-- STABLE RCS & RECOIL
-- ==========================================
local noRecoil = {
    isShooting = false
}

local fireStartConn = UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        noRecoil.isShooting = true
    end
end)
table.insert(connections, fireStartConn)

local fireEndConn = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        noRecoil.isShooting = false
    end
end)
table.insert(connections, fireEndConn)

-- ==========================================
-- FACTION CHECK & HEALTH CHECK LOGIC -+WORK
-- ==========================================
function isAlly(plr)
    if not plr or plr == player then return true end
    if not XCConfig.chamsTeamCheck then return false end
    
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
    if XCConfig.bodyAimOnly then
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
-- VISIBILITY CHECK SYSTEM WORK
-- ==========================================
local wallRayParams = RaycastParams.new()
wallRayParams.FilterType = Enum.RaycastFilterType.Exclude
wallRayParams.IgnoreWater = true

function isVisibleThroughWalls(targetPart, targetChar)
    if XCConfig.wallbangEnabled then return true end
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
-- ZERO-LAG SILENT AIM -+WORK
-- ==========================================
getSilentAimTarget = function()
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end
    local camPos = cam.CFrame.Position
    local camLook = cam.CFrame.LookVector
    local maxAngle = math.rad(XCConfig.silentAimFov)
    local best, bestAngle = nil, maxAngle
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == player then continue end
        if XCConfig.silentAimTeamCheck and isAlly(plr) then continue end
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not isEntityAlive(char, hum) then continue end
        local part = char:FindFirstChild(XCConfig.silentAimAimHead and "Head" or "HumanoidRootPart")
            or char:FindFirstChild("Torso")
        if not part or not part:IsA("BasePart") then continue end
        if XCConfig.silentAimVisibleCheck and not isVisibleThroughWalls(part, char) then
            continue
        end
        local predictedPos = getKinematicAimPosition(part)
        local dir = (predictedPos - camPos).Unit
        local angle = math.acos(math.clamp(camLook:Dot(dir), -1, 1))
        if angle < bestAngle then
            bestAngle = angle
            best = part
        end
    end
    return best
end

silentAimCamPosAim = function(targetPart)
    targetPart = targetPart or silentAimResolved
    if not (XCConfig.silentAimEnabled and targetPart) then return nil end
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end
    local camPos = cam.CFrame.Position
    local aimPos = getKinematicAimPosition(targetPart)

    -- getKinematicAimPosition() is the single source of prediction.
    -- Do not apply a second lateral lead here.
    return camPos, aimPos
end

local function setupSilentAimHooks()
    if silentAimHooked and silentAimCamHooked then return end

    if not silentAimHooked and hookmetamethod then
        pcall(function()
            local mouse = player:GetMouse()
            local oldIndex
            oldIndex = hookmetamethod(mouse, "__index", function(self, key)
                if XCConfig.silentAimEnabled and silentAimResolved and (key == "Hit" or key == "UnitRay") then
                    local camPos, aimPos = silentAimCamPosAim()
                    if camPos then
                        if key == "Hit" then
                            return CFrame.new(camPos, aimPos)
                        else
                            return Ray.new(camPos, (aimPos - camPos).Unit)
                        end
                    end
                end
                return oldIndex(self, key)
            end)
        end)
        silentAimHooked = true
    end

    if not silentAimCamHooked and hookmetamethod and getnamecallmethod then
        pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args = {...}

                if XCConfig.silentAimEnabled and silentAimResolved and noRecoil.isShooting
                    and self == camera
                    and (method == "ViewportPointToRay" or method == "ScreenPointToRay") then
                    local camPos, aimPos = silentAimCamPosAim()
                    if camPos then
                        return Ray.new(camPos, (aimPos - camPos).Unit)
                    end
                end

                if XCConfig.pSilentEnabled and silentAimResolved and self == Workspace then
                    local camPos, aimPos = silentAimCamPosAim()
                    if aimPos then
                        if method == "Raycast" then
                            local origin = args[1]
                            local originalDirection = args[2]
                            if typeof(origin) == "Vector3" and typeof(originalDirection) == "Vector3" then
                                local magnitude = originalDirection.Magnitude
                                local delta = aimPos - origin
                                if magnitude > 0 and delta.Magnitude > 0.001 then
                                    args[2] = delta.Unit * magnitude
                                    if XCConfig.wallbangEnabled then
                                        local wbParams = RaycastParams.new()
                                        wbParams.FilterType = Enum.RaycastFilterType.Include
                                        local charList = {}
                                        for _, plr in ipairs(Players:GetPlayers()) do
                                            if plr.Character then
                                                table.insert(charList, plr.Character)
                                            end
                                        end
                                        wbParams.FilterDescendantsInstances = charList
                                        wbParams.IgnoreWater = true
                                        args[3] = wbParams
                                    end
                                    return oldNamecall(self, unpack(args))
                                end
                            end
                        elseif method == "FindPartOnRay"
                            or method == "FindPartOnRayWithIgnoreList"
                            or method == "FindPartOnRayWithWhitelist" then
                            local oldRay = args[1]
                            if typeof(oldRay) == "Ray" then
                                local delta = aimPos - oldRay.Origin
                                if delta.Magnitude > 0.001 then
                                    args[1] = Ray.new(oldRay.Origin, delta.Unit * oldRay.Direction.Magnitude)
                                    return oldNamecall(self, unpack(args))
                                end
                            end
                        end
                    end
                end

                return oldNamecall(self, ...)
            end)
        end)
        silentAimCamHooked = true
    end
end

-- ==========================================
-- CHAMS COLORS NO WORK & HITMARKER VARS NO WORK
-- ==========================================
local chamsColorVisible = Color3.fromRGB(255, 45, 85)
local chamsColorHidden = Color3.fromRGB(110, 115, 125)
local chamsColorAlly = Color3.fromRGB(0, 230, 255)
local chamsOutlineColor = Color3.fromRGB(240, 240, 245)

local hitmarkerLastHealth = {}

-- ==========================================
-- XC SKINCHANGER
-- ==========================================
local skinData = {
    SkinsRoot = nil,
    SkinSelections = {},
    GloveSelections = {},
    GloveFolders = {},
    Ready = false
}

local function refreshXCSkinData()
    if skinData.Ready and skinData.SkinsRoot and skinData.SkinsRoot.Parent then return end

    local assets = ReplicatedStorage:FindFirstChild("Assets")
    skinData.SkinsRoot = assets and assets:FindFirstChild("Skins")
    if not skinData.SkinsRoot then return end

    skinData.SkinSelections = {}
    skinData.GloveSelections = {}
    skinData.GloveFolders = {}

    for _, weaponFolder in ipairs(skinData.SkinsRoot:GetChildren()) do
        local skins = {}
        for _, skin in ipairs(weaponFolder:GetChildren()) do
            skins[#skins + 1] = skin.Name
        end
        table.sort(skins)
        skinData.SkinSelections[weaponFolder.Name] = skins

        if weaponFolder.Name:match("Glove") or weaponFolder.Name:match("Gloves") or weaponFolder.Name == "Hand Wraps" then
            skinData.GloveFolders[#skinData.GloveFolders + 1] = weaponFolder
            local gloveSkins = {"Default"}
            for _, skin in ipairs(weaponFolder:GetChildren()) do
                gloveSkins[#gloveSkins + 1] = skin.Name
            end
            skinData.GloveSelections[weaponFolder.Name] = gloveSkins
        end
    end

    for weaponName, skins in pairs(skinData.SkinSelections) do
        if XCConfig.weaponSkinSelections[weaponName] == nil then
            XCConfig.weaponSkinSelections[weaponName] = skins[1] or "Default"
        end
    end

    skinData.Ready = true
end

refreshXCSkinData()

local function isBaseKnife(name)
    return name == "CT Knife" or name == "T Knife" or name == "Knife"
end

local function getCurrentWeaponModel()
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end
    for _, child in ipairs(cam:GetChildren()) do
        if child:IsA("Model") and child.Name ~= "Viewmodel" and not child.Name:lower():find("light") then
            return child
        end
    end
    return nil
end

local function applySurfaceAppearanceSkin(model, weaponName, skinName)
    if not model or not skinData.SkinsRoot then return end
    if not weaponName or not skinName or skinName == "Default" then return end

    local weaponFolder = skinData.SkinsRoot:FindFirstChild(weaponName)
    local skinFolder = weaponFolder and weaponFolder:FindFirstChild(skinName)
    local cameraFolder = skinFolder and skinFolder:FindFirstChild("Camera")
    local factoryNew = cameraFolder and cameraFolder:FindFirstChild("Factory New")
    if not factoryNew then return end

    for _, appearance in ipairs(factoryNew:GetChildren()) do
        if appearance:IsA("SurfaceAppearance") then
            local targetPart = model:FindFirstChild(appearance.Name, true)
            if targetPart and targetPart:IsA("BasePart") then
                for _, old in ipairs(targetPart:GetChildren()) do
                    if old:IsA("SurfaceAppearance") then old:Destroy() end
                end
                appearance:Clone().Parent = targetPart
            end
        end
    end
end

local lastBloxModuleScan = 0
local function hookBloxStrikeModules(forceScan)
    local now = os.clock()
    if not forceScan and lastBloxModuleScan > 0 and (now - lastBloxModuleScan) < 5 then return end
    lastBloxModuleScan = now
    refreshXCSkinData()
    pcall(function()
        if type(getgc) ~= "function" then return end
        for _, obj in ipairs(getgc(true)) do
            if type(obj) == "table" then
                if rawget(obj, "EquippedMelee") ~= nil and XCConfig.skinChangerEnabled then
                    obj.EquippedMelee = XCConfig.selectedKnifeType
                end
                if rawget(obj, "MeleeSkin") ~= nil and XCConfig.skinChangerEnabled then
                    obj.MeleeSkin = XCConfig.selectedSkin
                end
                if rawget(obj, "Knife") ~= nil and type(obj.Knife) == "table" and XCConfig.skinChangerEnabled then
                    obj.Knife.Name = XCConfig.selectedKnifeType
                    obj.Knife.Skin = XCConfig.selectedSkin
                end
            end
        end
    end)
end

local function scanAndMorphKnives(root)
    if not XCConfig.skinChangerEnabled or not root then return end
    refreshXCSkinData()
    if not skinData.SkinsRoot then return end

    local weaponModel = getCurrentWeaponModel()
    if weaponModel then
        local selectedWeapon = weaponModel.Name
        if isBaseKnife(selectedWeapon) then
            selectedWeapon = XCConfig.selectedKnifeType
        end
        local selectedSkin = XCConfig.weaponSkinSelections[selectedWeapon]
            or (selectedWeapon == XCConfig.selectedKnifeType and XCConfig.selectedSkin)
            or "Default"
        applySurfaceAppearanceSkin(weaponModel, selectedWeapon, selectedSkin)
    end
end

local function applyXCGloves()
    if not XCConfig.gloveChangerEnabled then return end
    refreshXCSkinData()
    if not skinData.SkinsRoot then return end

    local cam = Workspace.CurrentCamera or camera
    if not cam then return end
    local arms
    for _, child in ipairs(cam:GetChildren()) do
        if child:IsA("Model") and (child.Name:match("Arms") or child:FindFirstChild("Right Arm")) then
            arms = child
            break
        end
    end
    if not arms then return end

    local leftArm = arms:FindFirstChild("Left Arm")
    local rightArm = arms:FindFirstChild("Right Arm")
    local leftGlove = leftArm and leftArm:FindFirstChild("Glove")
    local rightGlove = rightArm and rightArm:FindFirstChild("Glove")
    if not leftGlove or not rightGlove then return end

    local gloveFolder = skinData.SkinsRoot:FindFirstChild(XCConfig.selectedGloveModel)
    local skinFolder = gloveFolder and gloveFolder:FindFirstChild(XCConfig.selectedGloveSkin)
    local cameraFolder = skinFolder and skinFolder:FindFirstChild("Camera")
    local factoryNew = cameraFolder and cameraFolder:FindFirstChild("Factory New")
    if not factoryNew then return end

    for _, glove in ipairs({leftGlove, rightGlove}) do
        for _, old in ipairs(glove:GetChildren()) do
            if old:IsA("SurfaceAppearance") then old:Destroy() end
        end
        for _, appearance in ipairs(factoryNew:GetChildren()) do
            if appearance:IsA("SurfaceAppearance") then
                appearance:Clone().Parent = glove
            end
        end
    end
end

-- Compatibility with the existing XC render scanner.
task.spawn(function()
    while xcSessionActive() do
        task.wait(1)
        pcall(function()
            if XCConfig.skinChangerEnabled then
                scanAndMorphKnives(camera)
            end
            if XCConfig.gloveChangerEnabled then
                applyXCGloves()
            end
        end)
    end
end)

-- ==========================================
-- EXTRA XC MODULES
-- Skin/knife/gloves are already handled above.
-- These modules are intentionally self-contained so they do not
-- interfere with the existing aim/ESP/render engines.
-- ==========================================

local noFallLastCharacter = nil
local animationTrack = nil
local animationObject = nil
local spectatorGui = nil
local spectatorFrame = nil
local spectatorListLabel = nil
local spectatorCounterLabel = nil
local handsLastModel = nil
local handsLastPivot = nil

local function setNoFallDamage(enabled)
    if not enabled then return end
    local char = player and player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end)
end

local function stopXCAnimation()
    if animationTrack then
        pcall(function() animationTrack:Stop(0.12) end)
        animationTrack = nil
    end
    if animationObject then
        pcall(function() animationObject:Destroy() end)
        animationObject = nil
    end
end

local function playXCAnimation()
    stopXCAnimation()
    if not XCConfig.animationsEnabled then return end
    local char = player and player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
    local id = tostring(XCConfig.animationId or ""):match("%d+")
    if not id then return end
    animationObject = Instance.new("Animation")
    animationObject.Name = "XCAnimation"
    animationObject.AnimationId = "rbxassetid://" .. id
    local ok, track = pcall(function() return animator:LoadAnimation(animationObject) end)
    if not ok or not track then
        stopXCAnimation()
        return
    end
    animationTrack = track
    animationTrack.Priority = Enum.AnimationPriority.Action
    animationTrack.Looped = XCConfig.animationLoop
    animationTrack:Play(0.15, 1, math.clamp(XCConfig.animationSpeed, 0.1, 3))
end

local function getSpectatorNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr:GetAttribute("IsSpectating") == true then
            names[#names + 1] = plr
        end
    end
    table.sort(names, function(a,b) return a.Name:lower() < b.Name:lower() end)
    return names
end

local function buildSpectatorGui()
    if spectatorGui and spectatorGui.Parent then return end
    spectatorGui = Instance.new("ScreenGui")
    spectatorGui.Name = "XCSpectatorGui"
    spectatorGui.ResetOnSpawn = false
    spectatorGui.IgnoreGuiInset = true
    spectatorGui.DisplayOrder = 21
    spectatorGui.Parent = targetGui

    spectatorFrame = Instance.new("Frame", spectatorGui)
    spectatorFrame.Size = UDim2.new(0, 210, 0, 120)
    spectatorFrame.Position = UDim2.new(1, -224, 0, 92)
    spectatorFrame.BackgroundColor3 = currentTheme.Background
    spectatorFrame.BorderSizePixel = 0
    spectatorFrame.Visible = false
    Instance.new("UICorner", spectatorFrame).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", spectatorFrame)
    stroke.Color = currentTheme.Border
    stroke.Thickness = 1

    local title = Instance.new("TextLabel", spectatorFrame)
    title.Size = UDim2.new(1, -12, 0, 22)
    title.Position = UDim2.new(0, 6, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = "SPECTATORS"
    title.TextColor3 = currentTheme.Accent
    title.TextSize = 9
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left

    spectatorCounterLabel = Instance.new("TextLabel", spectatorFrame)
    spectatorCounterLabel.Size = UDim2.new(1, -12, 0, 18)
    spectatorCounterLabel.Position = UDim2.new(0, 6, 0, 24)
    spectatorCounterLabel.BackgroundTransparency = 1
    spectatorCounterLabel.TextColor3 = currentTheme.TextSecondary
    spectatorCounterLabel.TextSize = 8
    spectatorCounterLabel.Font = Enum.Font.GothamBold
    spectatorCounterLabel.TextXAlignment = Enum.TextXAlignment.Left

    spectatorListLabel = Instance.new("TextLabel", spectatorFrame)
    spectatorListLabel.Size = UDim2.new(1, -12, 1, -48)
    spectatorListLabel.Position = UDim2.new(0, 6, 0, 44)
    spectatorListLabel.BackgroundTransparency = 1
    spectatorListLabel.TextColor3 = currentTheme.TextPrimary
    spectatorListLabel.TextSize = 8
    spectatorListLabel.Font = Enum.Font.Gotham
    spectatorListLabel.TextWrapped = true
    spectatorListLabel.TextXAlignment = Enum.TextXAlignment.Left
    spectatorListLabel.TextYAlignment = Enum.TextYAlignment.Top
end

local function updateSpectatorGui()
    buildSpectatorGui()
    local names = getSpectatorNames()
    local watching = player and player:GetAttribute("Spectators")
    if type(watching) ~= "number" then watching = nil end
    spectatorFrame.Visible = XCConfig.spectatorListEnabled and not (XCConfig.spectatorHideEmpty and #names == 0 and not watching)
    spectatorCounterLabel.Visible = XCConfig.spectatorCounterEnabled
    spectatorCounterLabel.Text = "Watching you: " .. (watching and tostring(math.floor(watching)) or "?")
    local lines = {}
    for _, plr in ipairs(names) do
        if XCConfig.spectatorNameMode == "Username" then
            lines[#lines+1] = plr.Name
        elseif XCConfig.spectatorNameMode == "Both" and plr.DisplayName ~= plr.Name then
            lines[#lines+1] = plr.DisplayName .. "  @" .. plr.Name
        else
            lines[#lines+1] = plr.DisplayName
        end
    end
    spectatorListLabel.Text = #lines > 0 and table.concat(lines, "\n") or "No active spectators"
    spectatorFrame.Size = UDim2.new(0, 210, 0, math.max(88, 64 + math.min(#lines, 8) * 14))
end

local function applyXCHandsOffset()
    if not XCConfig.customHandsEnabled then
        handsLastModel = nil
        handsLastPivot = nil
        return
    end
    local cam = Workspace.CurrentCamera or camera
    if not cam then return end
    local model = getCurrentWeaponModel()
    if not model or not model:IsA("Model") then return end
    if handsLastModel ~= model then
        handsLastModel = model
        handsLastPivot = model:GetPivot()
    end
    local original = model:GetPivot()
    local offset = CFrame.new(XCConfig.customHandsX, XCConfig.customHandsY, XCConfig.customHandsZ)
        * CFrame.Angles(math.rad(XCConfig.customHandsPitch), math.rad(XCConfig.customHandsYaw), math.rad(XCConfig.customHandsRoll))
    pcall(function()
        model:PivotTo(cam.CFrame * offset * cam.CFrame:ToObjectSpace(original))
    end)
end

-- Lightweight background update for the extra modules.
local spectatorUpdateAccumulator = 0
local animationUpdateAccumulator = 0
table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    if not XCConfig.noFallDamageEnabled
        and not XCConfig.spectatorListEnabled
        and not XCConfig.customHandsEnabled
        and not animationTrack then
        if spectatorFrame then spectatorFrame.Visible = false end
        return
    end
    if XCConfig.noFallDamageEnabled then
        local char = player and player.Character
        if char ~= noFallLastCharacter then
            noFallLastCharacter = char
            setNoFallDamage(true)
        end
    end
    if XCConfig.spectatorListEnabled then
        spectatorUpdateAccumulator += dt
        if spectatorUpdateAccumulator >= 0.5 then
            spectatorUpdateAccumulator = 0
            updateSpectatorGui()
        end
    elseif spectatorFrame then
        spectatorFrame.Visible = false
    end
    if XCConfig.customHandsEnabled then
        applyXCHandsOffset()
    end
    if animationTrack and animationTrack.IsPlaying then
        animationUpdateAccumulator += dt
        if animationUpdateAccumulator >= 0.25 then
            animationUpdateAccumulator = 0
            animationTrack.Looped = XCConfig.animationLoop
            pcall(function() animationTrack:AdjustSpeed(math.clamp(XCConfig.animationSpeed, 0.1, 3)) end)
        end
    end
end))

-- ==========================================
-- TRIGGERBOT NO WORK & MOVEMENT STATE NO WORK
-- ==========================================
local triggerbotDelay = 0.02
local triggerbotHeadOnly = false
local triggerbotMobileAutoFire = true
local lastTriggerTick = 0

local currentSpinAngle = 0
local isMobileJumpHeld = false
local lastMoveDirection = Vector3.zero

local isSliding = false
local currentSlideVel = Vector3.zero
local defaultHipHeight = 2.0
local defaultHipHeightCaptured = false

-- ==========================================
-- ENVIRONMENT PRESETS & FOG LIBRARY FULL WORK
-- ==========================================
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

local fogLibrary = {
    ["Nebula"] = Color3.fromRGB(90, 30, 110),
    ["nebula"] = Color3.fromRGB(90, 30, 110),
    ["Midnight"] = Color3.fromRGB(10, 10, 20),
    ["DeepBlood"] = Color3.fromRGB(35, 5, 8),
    ["CyberPurple"] = Color3.fromRGB(30, 8, 45),
    ["EmeraldNight"] = Color3.fromRGB(5, 25, 15),
    ["PitchBlack"] = Color3.fromRGB(0, 0, 0)
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
mainContainer.Name = "XCMainContainer"
mainContainer.ResetOnSpawn = false
mainContainer.DisplayOrder = 10
mainContainer.IgnoreGuiInset = true
mainContainer.Parent = targetGui

local overlayContainer = Instance.new("Folder", mainContainer)
overlayContainer.Name = "XC_2DOverlay"

local grenadeContainer = Instance.new("Folder", mainContainer)
grenadeContainer.Name = "XC_GrenadeOverlay"

local jumpCircleFolder = Instance.new("Folder", Workspace)
jumpCircleFolder.Name = "XC_JumpCircleWorld"

local grenadePool = {}
local mobileSlideBtn = nil

-- ==========================================
-- HITMARKER NO WORK
-- ==========================================
local hitmarkerGui = Instance.new("ScreenGui")
hitmarkerGui.Name = "XCHitmarkerGui"
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
    line.Size = UDim2.new(0, XCConfig.hitmarkerThickness, 0, XCConfig.hitmarkerSize)
    line.BackgroundColor3 = currentTheme.Accent
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 1
    line.Rotation = rotation
    line.Parent = hitmarkerCenter

    local glow = Instance.new("UIStroke")
    glow.Name = "NeonGlow"
    glow.Color = currentTheme.Accent
    glow.Thickness = XCConfig.hitmarkerGlow and 2.5 or 0
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
            glow.Thickness = XCConfig.hitmarkerGlow and 2.5 or 0
        end
    end
end

function showHitmarker()
    if not XCConfig.hitmarkerEnabled then return end

    hitmarkerSerial += 1
    local serial = hitmarkerSerial
    hitmarkerCenter.Visible = true

    for _, line in ipairs(hitmarkerLines) do
        line.BackgroundTransparency = 0
        local glow = line:FindFirstChild("NeonGlow")
        if glow then glow.Transparency = 0.05 end
    end

    local fadeInfo = TweenInfo.new(
        math.max(0.05, XCConfig.hitmarkerDuration),
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

    task.delay(math.max(0.05, XCConfig.hitmarkerDuration), function()
        if serial == hitmarkerSerial then
            hitmarkerCenter.Visible = false
        end
    end)
end

if genv then
    genv.XCShowHitmarker = showHitmarker
end

-- ==========================================
-- THIRD PERSON WORK
-- ==========================================
local isThirdPersonActive = false
local thirdPersonSaved = nil

local function getThirdPersonTarget()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum or hum.Health <= 0 then return nil, nil end
    return char, hum
end

local function restoreThirdPerson()
    isThirdPersonActive = false

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if camera and thirdPersonSaved then
        camera.CameraMinZoomDistance = thirdPersonSaved.minZoom
        camera.CameraMaxZoomDistance = thirdPersonSaved.maxZoom
    end

    if player and thirdPersonSaved then
        pcall(function()
            player.CameraMode = thirdPersonSaved.cameraMode
        end)
    end

    if camera then
        camera.CameraType = Enum.CameraType.Custom
        if hum then
            camera.CameraSubject = hum
        end
    end

    thirdPersonSaved = nil
end

function applyThirdPerson()
    if not XCConfig.thirdPersonEnabled then
        if isThirdPersonActive then
            restoreThirdPerson()
        end
        return
    end

    camera = Workspace.CurrentCamera or camera
    if not camera then return end

    local char, hum = getThirdPersonTarget()
    if not char then
        if isThirdPersonActive then
            restoreThirdPerson()
        end
        return
    end

    if not isThirdPersonActive then
        thirdPersonSaved = {
            cameraMode = player.CameraMode,
            minZoom = camera.CameraMinZoomDistance,
            maxZoom = camera.CameraMaxZoomDistance
        }
        isThirdPersonActive = true
    end

    -- XC behavior:
    -- use Roblox's native third-person camera instead of forcing
    -- a Scriptable camera. This preserves touch-look, joystick and
    -- the game's normal camera pipeline on both mobile and PC.
    pcall(function()
        player.CameraMode = Enum.CameraMode.Classic
    end)

    local distance = math.clamp(
        tonumber(XCConfig.thirdPersonDistance) or 12,
        5,
        50
    )

    camera.CameraMinZoomDistance = distance
    camera.CameraMaxZoomDistance = distance
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = hum
end

function setThirdPersonEnabled(enabled)
    XCConfig.thirdPersonEnabled = enabled and true or false

    if not enabled then
        restoreThirdPerson()
    else
        isThirdPersonActive = false
        thirdPersonSaved = nil
    end
end

function refreshThirdPerson()
    if XCConfig.thirdPersonEnabled then
        applyThirdPerson()
    end
end

-- ==========================================
-- LIGHTING & ATMOSPHERE FUNCTIONS WORK
-- ==========================================
function applyNightPreset(presetName)
    local cfg = nightPresets[presetName]
    if not cfg then return end
    XCConfig.nightPreset = presetName
    XCConfig.nightClockTime = cfg.ClockTime
    XCConfig.nightBrightness = cfg.Brightness
    
    if XCConfig.nightModeEnabled then
        Lighting.ClockTime = cfg.ClockTime
        Lighting.Brightness = cfg.Brightness
        Lighting.OutdoorAmbient = cfg.OutdoorAmbient
        Lighting.Ambient = cfg.Ambient
        Lighting.GlobalShadows = true
        if not XCConfig.removeFogEnabled then
            Lighting.FogColor = fogLibrary[presetName] or cfg.FogColor
        end
        updateWorldChanger()
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
        Lighting.FogStart = defaultLighting.FogStart or 0
        Lighting.FogColor = defaultLighting.FogColor
        Lighting.ExposureCompensation = 0
        restoreWorldSkybox()
        local fx = Lighting:FindFirstChild("XCWorldColorFX")
        if fx then fx:Destroy() end
    end)
end

-- ==========================================
--  WORLD VISUALS
-- ==========================================
local worldSkyboxData = {
    ["Night"] = {"rbxassetid://1514717643","rbxassetid://1514716936","rbxassetid://1514715910","rbxassetid://1514714945","rbxassetid://1514714011","rbxassetid://1514713374"},
    ["Ocean Sunset"] = {"rbxassetid://17525686840","rbxassetid://17525678473","rbxassetid://17525684686","rbxassetid://17525680663","rbxassetid://17525682665","rbxassetid://17525674545"},
    ["My Summer Car"] = {"rbxassetid://16648590964","rbxassetid://16648617436","rbxassetid://16648595424","rbxassetid://16648566370","rbxassetid://16648577071","rbxassetid://16648598180"},
    ["Minecraft"] = {"http://www.roblox.com/asset/?id=8735166756","http://www.roblox.com/asset/?id=8735166707","http://www.roblox.com/asset/?id=8735231668","http://www.roblox.com/asset/?id=8735166755","http://www.roblox.com/asset/?id=8735166751","http://www.roblox.com/asset/?id=8735166729"},
    ["Deep Space"] = {"http://www.roblox.com/asset/?id=159248188","http://www.roblox.com/asset/?id=159248183","http://www.roblox.com/asset/?id=159248187","http://www.roblox.com/asset/?id=159248173","http://www.roblox.com/asset/?id=159248192","http://www.roblox.com/asset/?id=159248176"},
    ["Clouded Sky"] = {"http://www.roblox.com/asset/?id=252760981","http://www.roblox.com/asset/?id=252763035","http://www.roblox.com/asset/?id=252761439","http://www.roblox.com/asset/?id=252760980","http://www.roblox.com/asset/?id=252760986","http://www.roblox.com/asset/?id=252762652"},
    ["City"] = {"http://www.roblox.com/asset/?id=9134792889","http://www.roblox.com/asset/?id=9134791975","http://www.roblox.com/asset/?id=9134793457","http://www.roblox.com/asset/?id=9134791234","http://www.roblox.com/asset/?id=9134790419","http://www.roblox.com/asset/?id=9134791633"}
}

local originalSkybox = nil
local originalPostFX = nil
local weaponVisualState = setmetatable({}, {__mode = "k"})
local weaponGlowObjects = setmetatable({}, {__mode = "k"})

-- Weapon visual engine.
-- Supports the five visual variants used by the reference implementation,
-- while keeping XC's own configuration/state system and restoring every
-- property that was changed when the module is disabled or the weapon changes.
if XCConfig.weaponChamsMode == "Crystal" then XCConfig.weaponChamsMode = "Glass" end
if XCConfig.weaponChamsMode == "Field" then XCConfig.weaponChamsMode = "ForceField" end
if XCConfig.weaponChamsMode == "Chrome" then XCConfig.weaponChamsMode = "Metal" end
if XCConfig.weaponChamsMode == "Glow" then XCConfig.weaponChamsMode = "Highlight" end

local function resolveWeaponModel()
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end

    local directCandidates = {}
    for _, child in ipairs(cam:GetChildren()) do
        if child:IsA("Model") then
            local lower = child.Name:lower()
            if not lower:find("light") and lower ~= "arms" and lower ~= "arms1" and lower ~= "arms2" then
                local weapon = child:FindFirstChild("Weapon")
                if weapon and weapon:IsA("Model") then
                    return weapon
                end
                table.insert(directCandidates, child)
            end
        end
    end

    -- Some Blox Strike builds put the weapon one level deeper in the
    -- viewmodel. Prefer an explicit Weapon model before falling back.
    for _, root in ipairs(directCandidates) do
        for _, node in ipairs(root:GetDescendants()) do
            if node:IsA("Model") and node.Name == "Weapon" then
                return node
            end
        end
    end

    -- Fallback: use a camera child that actually contains renderable parts,
    -- but do not mistake the arms/light containers for the weapon.
    for _, root in ipairs(directCandidates) do
        local lower = root.Name:lower()
        if lower ~= "viewmodel" and not lower:find("viewmodel") then
            if root:FindFirstChildWhichIsA("BasePart", true) then
                return root
            end
        end
    end

    return nil
end

local function saveWeaponPartState(part)
    if weaponVisualState[part] then return end
    local state = {
        material = part.Material,
        color = part.Color,
        transparency = part.Transparency,
        reflectance = part.Reflectance,
        children = {}
    }

    -- The reference removes SurfaceAppearance/Texture/Decal for most modes.
    -- XC keeps backups so switching the module off never permanently
    -- destroys the weapon's original appearance.
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("SurfaceAppearance") or child:IsA("Texture") or child:IsA("Decal") then
            local ok, clone = pcall(function() return child:Clone() end)
            if ok and clone then
                table.insert(state.children, clone)
            end
        end
    end
    weaponVisualState[part] = state
end

local function restoreWeaponPart(part, state)
    if not part or not state then return end
    pcall(function()
        part.Material = state.material
        part.Color = state.color
        part.Transparency = state.transparency
        part.Reflectance = state.reflectance
    end)

    pcall(function()
        for _, child in ipairs(part:GetChildren()) do
            if child:IsA("SurfaceAppearance") or child:IsA("Texture") or child:IsA("Decal") then
                child:Destroy()
            end
        end
        for _, clone in ipairs(state.children or {}) do
            if clone then clone:Clone().Parent = part end
        end
    end)
end

local function clearWeaponVisuals()
    for part, state in pairs(weaponVisualState) do
        if part and part.Parent then
            restoreWeaponPart(part, state)
        end
        weaponVisualState[part] = nil
    end
    for part, obj in pairs(weaponGlowObjects) do
        if obj and obj.Parent then pcall(function() obj:Destroy() end) end
        weaponGlowObjects[part] = nil
    end
end

local function clearWeaponGlow(part)
    local glow = weaponGlowObjects[part]
    if glow then
        pcall(function() glow:Destroy() end)
        weaponGlowObjects[part] = nil
    end
end

local function setWeaponVisuals()
    if not XCConfig.weaponChamsEnabled then
        clearWeaponVisuals()
        return
    end

    local model = resolveWeaponModel()
    if not model then
        clearWeaponVisuals()
        return
    end

    local style = XCConfig.weaponChamsMode or "Glass"
    local validStyles = {
        Glass = true,
        ForceField = true,
        Metal = true,
        Highlight = true,
        Neon = true,
    }
    if not validStyles[style] then style = "Glass" end

    local tint = rgb(
        XCConfig.weaponChamsColorR,
        XCConfig.weaponChamsColorG,
        XCConfig.weaponChamsColorB
    )
    local activeParts = {}

    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart")
            and part.Name ~= "Hitbox"
            and part.Name ~= "HumanoidRootPart"
            and part.Name ~= "ViewmodelLight"
            and not part:FindFirstAncestor("ViewmodelLight")
        then
            activeParts[part] = true
            saveWeaponPartState(part)

            pcall(function()
                if style == "Highlight" then
                    local h = weaponGlowObjects[part]
                    if not h or not h.Parent then
                        h = Instance.new("Highlight")
                        h.Name = "XCWeaponChams"
                        h.Adornee = part
                        h.FillTransparency = 0
                        h.OutlineTransparency = 1
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = part
                        weaponGlowObjects[part] = h
                    end
                    h.FillColor = tint
                else
                    clearWeaponGlow(part)

                    -- Match the reference behavior: remove surface overlays for
                    -- material-based variants so the selected material is visible.
                    for _, child in ipairs(part:GetChildren()) do
                        if child:IsA("SurfaceAppearance") or child:IsA("Texture") or child:IsA("Decal") then
                            child:Destroy()
                        end
                    end

                    if style == "Glass" then
                        part.Material = Enum.Material.Glass
                        part.Color = tint
                        part.Transparency = math.clamp(
                            tonumber(XCConfig.weaponChamsTransparency) or 0.4, 0, 1
                        )
                        part.Reflectance = 0
                    elseif style == "ForceField" then
                        part.Material = Enum.Material.ForceField
                        part.Color = tint
                        part.Transparency = 0
                        part.Reflectance = 0
                    elseif style == "Metal" then
                        part.Material = Enum.Material.Metal
                        part.Color = tint
                        part.Reflectance = math.clamp(
                            tonumber(XCConfig.weaponChamsReflectance) or 1.0, 0, 1
                        )
                        part.Transparency = 0
                    elseif style == "Neon" then
                        part.Material = Enum.Material.Neon
                        part.Color = tint
                        part.Transparency = 0
                        part.Reflectance = 0
                    end
                end
            end)
        end
    end

    -- Restore parts belonging to the previous weapon/model and remove stale
    -- Highlight instances when the weapon is switched or rebuilt.
    for part, state in pairs(weaponVisualState) do
        if not activeParts[part] then
            if part and part.Parent then restoreWeaponPart(part, state) end
            weaponVisualState[part] = nil
            clearWeaponGlow(part)
        end
    end
end

local function applyWorldSkybox()
    local data = worldSkyboxData[XCConfig.worldSkyboxPreset]
    if not data or not XCConfig.worldSkyboxEnabled then return end
    pcall(function()
        if not originalSkybox then
            originalSkybox = Lighting:FindFirstChildOfClass("Sky")
            if originalSkybox then originalSkybox = originalSkybox:Clone() end
        end
        local sky = Lighting:FindFirstChild("XCWorldSky")
        if not sky then
            sky = Instance.new("Sky")
            sky.Name = "XCWorldSky"
            sky.Parent = Lighting
        end
        sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt = data[1], data[2], data[3]
        sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = data[4], data[5], data[6]
    end)
end

local function restoreWorldSkybox()
    pcall(function()
        local sky = Lighting:FindFirstChild("XCWorldSky")
        if sky then sky:Destroy() end
        if originalSkybox then
            originalSkybox.Parent = Lighting
            originalSkybox = nil
        end
    end)
end

local function updateWorldPostFX()
    if not XCConfig.worldPostFXEnabled then
        local fx = Lighting:FindFirstChild("XCWorldColorFX")
        if fx then fx:Destroy() end
        Lighting.ExposureCompensation = 0
        return
    end
    local fx = Lighting:FindFirstChild("XCWorldColorFX")
    if not fx then
        fx = Instance.new("ColorCorrectionEffect")
        fx.Name = "XCWorldColorFX"
        fx.Parent = Lighting
    end
    fx.Saturation = math.clamp(XCConfig.worldSaturation or 0, -1, 1)
    fx.Contrast = math.clamp(XCConfig.worldContrast or 0, -1, 1)
    fx.TintColor = rgb(XCConfig.worldColorR, XCConfig.worldColorG, XCConfig.worldColorB)
    Lighting.ExposureCompensation = math.clamp(XCConfig.worldExposure or 0, -5, 5)
end

local function updateWorldChanger()
    if not XCConfig.nightModeEnabled then
        restoreWorldSkybox()
        local fx = Lighting:FindFirstChild("XCWorldColorFX")
        if fx then fx:Destroy() end
        return
    end
    if XCConfig.worldSkyboxEnabled then applyWorldSkybox() else restoreWorldSkybox() end
    updateWorldPostFX()
    if XCConfig.worldFogEnd and XCConfig.worldFogEnd > 0 then
        Lighting.FogStart = math.max(0, XCConfig.worldFogStart or 0)
        Lighting.FogEnd = math.max(Lighting.FogStart + 1, XCConfig.worldFogEnd)
    end
end

-- ==========================================================================
-- [ CUBE CHECKER ]
-- camera-ray surface marker.
-- ==========================================================================
do
    local cubePart = Instance.new("Part")
    cubePart.Name = "XC_CubeChecker"
    cubePart.Anchored = true
    cubePart.CanCollide = false
    cubePart.CanTouch = false
    cubePart.CanQuery = false
    cubePart.CastShadow = false
    cubePart.Material = Enum.Material.Neon
    cubePart.Transparency = 0.98
    cubePart.Size = Vector3.new(1.5, 1.5, 0.01)

    local cubeOutline = Instance.new("SelectionBox")
    cubeOutline.Name = "CubeCheckerOutline"
    cubeOutline.Adornee = cubePart
    cubeOutline.Color3 = Color3.fromRGB(210, 45, 55)
    cubeOutline.LineThickness = 0.04
    cubeOutline.Transparency = 0.2
    cubeOutline.Parent = cubePart

    local cubeRayParams = RaycastParams.new()
    cubeRayParams.FilterType = Enum.RaycastFilterType.Exclude
    cubeRayParams.IgnoreWater = true

    local cubeRenderConnection = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not XCConfig.cubeCheckerEnabled then
                cubePart.Parent = nil
                return
            end

            local cam = Workspace.CurrentCamera
            if not cam then
                cubePart.Parent = nil
                return
            end

            local distance = math.clamp(tonumber(XCConfig.cubeCheckerDistance) or 20, 1, 200)
            local size = math.clamp(tonumber(XCConfig.cubeCheckerSize) or 1.5, 0.1, 10)
            local lineThickness = math.clamp(tonumber(XCConfig.cubeCheckerLineThickness) or 0.04, 0.01, 0.2)
            local outlineTransparency = math.clamp(tonumber(XCConfig.cubeCheckerTransparency) or 0.2, 0, 1)
            local col = XCConfig.cubeCheckerRainbow
                and Color3.fromHSV((os.clock() * 0.2) % 1, 1, 1)
                or rgb(XCConfig.bulletTracerColorR, XCConfig.bulletTracerColorG, XCConfig.bulletTracerColorB)

            cubeRayParams.FilterDescendantsInstances = {player.Character, cubePart}
            local origin = cam.CFrame.Position
            local result = Workspace:Raycast(origin, cam.CFrame.LookVector * distance, cubeRayParams)

            if not result then
                cubePart.Parent = nil
                return
            end

            cubePart.Size = Vector3.new(size, size, 0.01)
            cubePart.Color = col
            cubePart.CFrame = CFrame.lookAt(result.Position + result.Normal * 0.02, result.Position + result.Normal)
            cubeOutline.Color3 = col
            cubeOutline.LineThickness = lineThickness
            cubeOutline.Transparency = outlineTransparency
            cubePart.Parent = Workspace
        end)
    end)
    table.insert(connections, cubeRenderConnection)
end

-- Scope overlay adapted from XC: FOV override, removable scope and configurable crosshair.
local function findSniperScope()
    local pg = player and player:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end
    local main = pg:FindFirstChild("MainGui")
    local gameplay = main and main:FindFirstChild("Gameplay")
    local middle = gameplay and gameplay:FindFirstChild("Middle")
    return middle and middle:FindFirstChild("SniperScope") or nil
end

local function ensureScopeGui()
    if scopeGui and scopeGui.Parent then return end
    scopeGui = Instance.new("ScreenGui")
    scopeGui.Name = "XCCustomScope"
    scopeGui.ResetOnSpawn = false
    scopeGui.IgnoreGuiInset = true
    pcall(function() scopeGui.Parent = targetGui end)
    if not scopeGui.Parent then scopeGui.Parent = CoreGui end
    scopeContainer = Instance.new("Frame")
    scopeContainer.BackgroundTransparency = 1
    scopeContainer.AnchorPoint = Vector2.new(0.5,0.5)
    scopeContainer.Position = UDim2.fromScale(0.5,0.5)
    scopeContainer.Size = UDim2.fromOffset(0,0)
    scopeContainer.Parent = scopeGui
    for name,anchor in pairs({Left=Vector2.new(1,.5),Right=Vector2.new(0,.5),Top=Vector2.new(.5,1),Bottom=Vector2.new(.5,0)}) do
        local f=Instance.new("Frame")
        f.Name=name; f.AnchorPoint=anchor; f.BorderSizePixel=0; f.Parent=scopeContainer
    end
    local dot=Instance.new("Frame")
    dot.Name="Dot"; dot.AnchorPoint=Vector2.new(.5,.5); dot.BorderSizePixel=0; dot.Parent=scopeContainer
end

local function updateCustomScope()
    ensureScopeGui()
    local scope = findSniperScope()
    local scoped = scope and scope.Visible == true
    if scope and scopeSavedSize == nil then scopeSavedSize = scope.Size end

    -- Never permanently alter the game's original scope size.
    if scope then
        if XCConfig.scopeRemoveOriginal and scoped then
            scope.Size = UDim2.fromOffset(0,0)
        elseif scopeSavedSize then
            scope.Size = scopeSavedSize
        end
    end

    local cam = Workspace.CurrentCamera or camera
    if XCConfig.customScopeEnabled and scoped then
        if XCConfig.scopeFovEnabled and cam then
            if scopeSavedFov == nil then scopeSavedFov = cam.FieldOfView end
            cam.FieldOfView = math.clamp(tonumber(XCConfig.scopeFov) or 70, 10, 120)
        end

        local enabled = XCConfig.scopeCrosshairEnabled ~= false
        scopeContainer.Visible = enabled
        if not enabled then return end

        local col = rgb(XCConfig.scopeCrosshairColorR, XCConfig.scopeCrosshairColorG, XCConfig.scopeCrosshairColorB)
        local len = math.clamp(tonumber(XCConfig.scopeCrosshairLength) or 85, 2, 500)
        local thick = math.clamp(tonumber(XCConfig.scopeCrosshairThickness) or 2, 1, 12)
        local gap = math.clamp(tonumber(XCConfig.scopeCrosshairGap) or 8, 0, 150)
        local dynamic = XCConfig.scopeDynamicGap and math.clamp((1/(cam and cam.FieldOfView or 70))*700, 2, 30) or 0
        gap = gap + dynamic
        local opacity = math.clamp(tonumber(XCConfig.scopeCrosshairOpacity) or 0, 0, 1)
        local style = XCConfig.scopeCrosshairStyle or "Cross"

        local l=scopeContainer.Left; local r=scopeContainer.Right
        local t=scopeContainer.Top; local b=scopeContainer.Bottom; local d=scopeContainer.Dot
        local arms = {l,r,t,b,d}

        for _,f in ipairs(arms) do
            f.BackgroundColor3 = col
            f.BackgroundTransparency = opacity
            f.BorderSizePixel = 0
            f.Visible = false
            local st = f:FindFirstChild("ScopeOutline")
            if not st then
                st = Instance.new("UIStroke")
                st.Name = "ScopeOutline"
                st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                st.Parent = f
            end
            st.Enabled = XCConfig.scopeCrosshairOutline == true
            st.Thickness = math.clamp(tonumber(XCConfig.scopeCrosshairOutlineThickness) or 1, 1, 6)
            st.Color = rgb(XCConfig.scopeCrosshairOutlineR,XCConfig.scopeCrosshairOutlineG,XCConfig.scopeCrosshairOutlineB)
            st.Transparency = opacity
        end

        local function show(f, size, pos, rotation)
            f.Size=size; f.Position=pos; f.Rotation=rotation or 0; f.Visible=true
        end

        -- Style presets: Cross, T, X and Dot. Individual arms still remain toggleable.
        if style == "X" then
            local xLen = math.max(2, len * 0.72)
            if XCConfig.scopeCrosshairLeft ~= false then show(l,UDim2.fromOffset(xLen,thick),UDim2.fromOffset(-gap,-gap),45) end
            if XCConfig.scopeCrosshairRight ~= false then show(r,UDim2.fromOffset(xLen,thick),UDim2.fromOffset(gap,-gap),-45) end
            if XCConfig.scopeCrosshairTop ~= false then show(t,UDim2.fromOffset(xLen,thick),UDim2.fromOffset(-gap,gap),-45) end
            if XCConfig.scopeCrosshairBottom ~= false then show(b,UDim2.fromOffset(xLen,thick),UDim2.fromOffset(gap,gap),45) end
        elseif style == "T" then
            if XCConfig.scopeCrosshairTop ~= false then show(t,UDim2.fromOffset(thick,len),UDim2.fromOffset(0,gap),0) end
            if XCConfig.scopeCrosshairLeft ~= false then show(l,UDim2.fromOffset(len,thick),UDim2.fromOffset(-gap,0),0) end
            if XCConfig.scopeCrosshairRight ~= false then show(r,UDim2.fromOffset(len,thick),UDim2.fromOffset(gap,0),0) end
            -- Bottom can be independently disabled/enabled; enabled means a short lower arm.
            if XCConfig.scopeCrosshairBottom ~= false then show(b,UDim2.fromOffset(thick,math.max(2,len*0.55)),UDim2.fromOffset(0,gap),0) end
        elseif style == "Dot" then
            -- Only the center dot is drawn for Dot style.
        else -- Cross
            if XCConfig.scopeCrosshairLeft ~= false then show(l,UDim2.fromOffset(len,thick),UDim2.fromOffset(-gap,0),0) end
            if XCConfig.scopeCrosshairRight ~= false then show(r,UDim2.fromOffset(len,thick),UDim2.fromOffset(gap,0),0) end
            if XCConfig.scopeCrosshairTop ~= false then show(t,UDim2.fromOffset(thick,len),UDim2.fromOffset(0,-gap),0) end
            if XCConfig.scopeCrosshairBottom ~= false then show(b,UDim2.fromOffset(thick,len),UDim2.fromOffset(0,gap),0) end
        end

        d.Size=UDim2.fromOffset(math.max(1,thick*2),math.max(1,thick*2))
        d.Position=UDim2.fromOffset(0,0)
        d.Rotation=0
        d.Visible = XCConfig.scopeCrosshairDot ~= false
    else
        scopeContainer.Visible=false
        if scopeSavedFov and cam then cam.FieldOfView=scopeSavedFov end
        scopeSavedFov=nil
    end
end

table.insert(connections, RunService.RenderStepped:Connect(function()
    if not XCConfig.weaponChamsEnabled
        and not XCConfig.customScopeEnabled
        and not XCConfig.customFovEnabled
        and not XCConfig.nightModeEnabled then
        return
    end
    pcall(function()
        setWeaponVisuals()
        updateCustomScope()
        -- XC Custom FOV: apply the camera FOV every render frame while enabled.
        if XCConfig.customFovEnabled then
            local cam = Workspace.CurrentCamera or camera
            if cam then
                cam.FieldOfView = math.clamp(tonumber(XCConfig.customFov) or 90, 70, 120)
            end
        end
        if XCConfig.nightModeEnabled then updateWorldChanger() end
    end)
end))

-- ==========================================
-- JUMP CIRCLE NO WORK BLOXSTRIKE
-- ==========================================
local jumpRayParams = RaycastParams.new()
jumpRayParams.FilterType = Enum.RaycastFilterType.Exclude
jumpRayParams.IgnoreWater = true

local function getGroundY(originPos, char)
    jumpRayParams.FilterDescendantsInstances = {char, jumpCircleFolder, camera}
    local cast = Workspace:Raycast(originPos + Vector3.new(0, 2, 0), Vector3.new(0, -15, 0), jumpRayParams)
    if cast then
        return cast.Position.Y + 0.04
    end
    return originPos.Y - 2.8
end

function buildJumpRing(segmentCount, radius, thickness, height)
    local container = Instance.new("Folder")
    container.Name = "JumpCircleContainer"

    local segments = {}
    local angleStep = (math.pi * 2) / segmentCount
    local chordLength = 2 * radius * math.sin(angleStep / 2) + 0.03
    local lineH = height or 0.03
    local lineThick = thickness or 0.06

    for i = 1, segmentCount do
        local angle = (i - 1) * angleStep
        local part = Instance.new("Part")
        part.Name = "Seg_" .. i
        part.Size = Vector3.new(lineThick, lineH, chordLength)
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.CastShadow = false
        part.Material = Enum.Material.Neon
        part.Color = currentTheme.Accent
        part.Transparency = 0
        part.Parent = container

        segments[i] = {
            Part = part,
            Angle = angle,
            BaseChord = chordLength,
            BaseThick = lineThick,
            BaseHeight = lineH
        }
    end

    return container, segments
end

function updateJumpRingLayout(segments, centerPosition, radius, thicknessMult)
    local n = #segments
    local tMult = thicknessMult or 1.0
    for i, seg in ipairs(segments) do
        local angle = seg.Angle
        local nextAngle = angle + (math.pi * 2 / n)
        local p1 = centerPosition + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        local p2 = centerPosition + Vector3.new(math.cos(nextAngle) * radius, 0, math.sin(nextAngle) * radius)
        local mid = (p1 + p2) * 0.5
        local length = (p2 - p1).Magnitude + 0.02

        if seg.Part and seg.Part.Parent then
            seg.Part.Size = Vector3.new(seg.BaseThick * tMult, seg.BaseHeight, length)
            seg.Part.CFrame = CFrame.lookAt(mid, p2)
        end
    end
end

function spawnJumpRipple(position)
    if not XCConfig.jumpCircleEnabled then return end
    task.spawn(function()
        local rippleFolder, segments = buildJumpRing(XCConfig.jumpCircleSegmentCount, XCConfig.jumpCircleRadius, 0.08, 0.04)
        rippleFolder.Parent = jumpCircleFolder

        local startT = os.clock()
        local duration = 0.55
        local maxR = XCConfig.jumpCircleRadius * 2.2
        local col1 = currentTheme.Accent
        local col2 = Color3.fromRGB(255, 255, 255)

        local rippleConn
        rippleConn = RunService.RenderStepped:Connect(function()
            local elapsed = os.clock() - startT
            local alpha = elapsed / duration
            if alpha >= 1 or not XCConfig.jumpCircleEnabled then
                if rippleConn then rippleConn:Disconnect() end
                if rippleFolder then rippleFolder:Destroy() end
                return
            end

            local eased = 1 - math.pow(1 - alpha, 3)
            local curR = XCConfig.jumpCircleRadius + (maxR - XCConfig.jumpCircleRadius) * eased
            updateJumpRingLayout(segments, position, curR, 1.0 - (alpha * 0.5))

            for _, seg in ipairs(segments) do
                if seg.Part and seg.Part.Parent then
                    seg.Part.Transparency = alpha
                    seg.Part.Color = col1:Lerp(col2, alpha)
                end
            end
        end)
    end)
end

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

function initJumpCircleForCharacter(char)
    clearActiveJumpCircle()
    if not XCConfig.jumpCircleEnabled or not char then return end

    local hrp = char:WaitForChild("HumanoidRootPart", 4)
    local hum = char:WaitForChild("Humanoid", 4)
    if not hrp or not hum then return end

    local container, segments = buildJumpRing(XCConfig.jumpCircleSegmentCount, XCConfig.jumpCircleRadius, 0.06, 0.03)
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
    local pulse = 0
    local pulseDir = 1

    local loopConn = RunService.RenderStepped:Connect(function(dt)
        if not XCConfig.jumpCircleEnabled or not hrp or not hrp.Parent or not hum or not hum.Parent or hum.Health <= 0 then
            clearActiveJumpCircle()
            return
        end

        local elapsed = os.clock() - startClock

        pulse = pulse + dt * 3.5 * pulseDir
        if pulse > 1 then pulse = 1; pulseDir = -1 end
        if pulse < 0 then pulse = 0; pulseDir = 1 end

        local groundY = getGroundY(hrp.Position, char)
        local groundCenter = Vector3.new(hrp.Position.X, groundY, hrp.Position.Z)

        local pulseThickMult = 1.0 + (pulse * 0.45)
        updateJumpRingLayout(segments, groundCenter, XCConfig.jumpCircleRadius, pulseThickMult)

        if XCConfig.jumpCircleStyle == "GradientWave" then
            local n = #segments
            local spin = (elapsed * 3) % (math.pi * 2)
            local c1 = currentTheme.Accent
            local c2 = Color3.fromRGB(0, 230, 255)
            for i, seg in ipairs(segments) do
                local ratio = ((i / n) + spin) % 1
                local wave = (math.sin(ratio * math.pi * 2) + 1) * 0.5
                if seg.Part and seg.Part.Parent then
                    seg.Part.Color = c1:Lerp(c2, wave)
                    seg.Part.Transparency = 0.05 + (pulse * 0.25)
                end
            end
        elseif XCConfig.jumpCircleStyle == "ChromaPulse" then
            local hue = (elapsed * 0.35) % 1
            local col = Color3.fromHSV(hue, 0.85, 1)
            for _, seg in ipairs(segments) do
                if seg.Part and seg.Part.Parent then
                    seg.Part.Color = col
                    seg.Part.Transparency = 0.1 + (pulse * 0.3)
                end
            end
        elseif XCConfig.jumpCircleStyle == "StaticNeon" then
            for _, seg in ipairs(segments) do
                if seg.Part and seg.Part.Parent then
                    seg.Part.Color = currentTheme.Accent
                    seg.Part.Transparency = 0.05 + (pulse * 0.25)
                end
            end
        end
    end)
    table.insert(circleData.Connections, loopConn)

    local stateConn = hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Jumping then
            local groundY = getGroundY(hrp.Position, char)
            local footPos = Vector3.new(hrp.Position.X, groundY, hrp.Position.Z)
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
-- XC WORLD WEATHER + CAMERA DIRECTOR
-- Inspired by the useful visual/camera ideas shown in the GameSense review.
-- Both systems are local-only and use a single lightweight render path.
-- ==========================================
local weatherRig
local weatherEmitter
local weatherAtmosphere
local weatherUpdateAccumulator = 0
local weatherSignature

local function destroyXCWeather()
    if weatherRig then pcall(function() weatherRig:Destroy() end) end
    if weatherAtmosphere then pcall(function() weatherAtmosphere:Destroy() end) end
    weatherRig = nil
    weatherEmitter = nil
    weatherAtmosphere = nil
    weatherSignature = nil
end

local function ensureXCWeatherObjects()
    if not weatherRig or not weatherRig.Parent then
        weatherRig = Instance.new("Part")
        weatherRig.Name = "XCWeatherEmitter"
        weatherRig.Size = Vector3.new(1, 1, 1)
        weatherRig.Transparency = 1
        weatherRig.Anchored = true
        weatherRig.CanCollide = false
        pcall(function() weatherRig.CanQuery = false; weatherRig.CanTouch = false end)
        weatherRig.Parent = Workspace

        weatherEmitter = Instance.new("ParticleEmitter")
        weatherEmitter.Name = "XCWeatherParticles"
        weatherEmitter.LockedToPart = false
        weatherEmitter.LightInfluence = 0
        weatherEmitter.Orientation = Enum.ParticleOrientation.FacingCamera
        weatherEmitter.Shape = Enum.ParticleEmitterShape.Box
        weatherEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
        weatherEmitter.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
        weatherEmitter.Parent = weatherRig
    end
end

local function applyXCWeather()
    if not XCConfig.weatherEnabled then
        destroyXCWeather()
        return
    end

    ensureXCWeatherObjects()
    local mode = tostring(XCConfig.weatherMode or "Rain")
    local intensity = math.clamp(tonumber(XCConfig.weatherIntensity) or 45, 1, 100)
    local wind = math.clamp(tonumber(XCConfig.weatherWind) or 0, -40, 40)
    local signature = mode .. ":" .. tostring(intensity) .. ":" .. tostring(wind)
    if weatherSignature == signature and weatherEmitter and weatherEmitter.Parent then return end
    weatherSignature = signature
    weatherEmitter.Enabled = mode ~= "Fog"

    if weatherAtmosphere then
        weatherAtmosphere.Density = mode == "Fog" and (0.18 + intensity * 0.0045) or 0
        weatherAtmosphere.Haze = mode == "Fog" and (1 + intensity * 0.045) or 0
    elseif mode == "Fog" then
        weatherAtmosphere = Instance.new("Atmosphere")
        weatherAtmosphere.Name = "XCWeatherAtmosphere"
        weatherAtmosphere.Color = Color3.fromRGB(190, 198, 205)
        weatherAtmosphere.Decay = Color3.fromRGB(90, 96, 105)
        weatherAtmosphere.Density = 0.18 + intensity * 0.0045
        weatherAtmosphere.Haze = 1 + intensity * 0.045
        weatherAtmosphere.Glare = 0
        weatherAtmosphere.Parent = Lighting
    end

    if mode == "Rain" then
        weatherRig.Size = Vector3.new(90, 1, 90)
        weatherEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        weatherEmitter.Rate = intensity * 3.2
        weatherEmitter.Lifetime = NumberRange.new(0.65, 1.05)
        weatherEmitter.Speed = NumberRange.new(65, 90)
        weatherEmitter.Acceleration = Vector3.new(wind, -65, 0)
        weatherEmitter.SpreadAngle = Vector2.new(4, 4)
        weatherEmitter.Size = NumberSequence.new(0.075)
        weatherEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.85, 0.45),
            NumberSequenceKeypoint.new(1, 1),
        })
        weatherEmitter.Color = ColorSequence.new(Color3.fromRGB(190, 220, 255))
    elseif mode == "Snow" then
        weatherRig.Size = Vector3.new(100, 1, 100)
        weatherEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        weatherEmitter.Rate = intensity * 1.45
        weatherEmitter.Lifetime = NumberRange.new(4.5, 7)
        weatherEmitter.Speed = NumberRange.new(5, 11)
        weatherEmitter.Acceleration = Vector3.new(wind * 0.35, -2.5, 0)
        weatherEmitter.SpreadAngle = Vector2.new(18, 18)
        weatherEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.12),
            NumberSequenceKeypoint.new(0.5, 0.28),
            NumberSequenceKeypoint.new(1, 0.08),
        })
        weatherEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.18),
            NumberSequenceKeypoint.new(1, 0.55),
        })
        weatherEmitter.Color = ColorSequence.new(Color3.fromRGB(245, 248, 255))
    elseif mode == "Ash" then
        weatherRig.Size = Vector3.new(85, 1, 85)
        weatherEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
        weatherEmitter.Rate = intensity * 1.15
        weatherEmitter.Lifetime = NumberRange.new(3.5, 6)
        weatherEmitter.Speed = NumberRange.new(4, 9)
        weatherEmitter.Acceleration = Vector3.new(wind * 0.5, 5, 0)
        weatherEmitter.SpreadAngle = Vector2.new(22, 22)
        weatherEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.16),
            NumberSequenceKeypoint.new(1, 0.26),
        })
        weatherEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 0.8),
        })
        weatherEmitter.Color = ColorSequence.new(Color3.fromRGB(135, 135, 135))
    end
end

local xcCameraMode
local xcSavedCameraState
local xcCameraFrame
local xcCameraPosition
local xcCameraYaw = 0
local xcCameraPitch = 0
local xcCameraTouch
local xcCameraTouchLast
local xcCameraTouchDelta = Vector2.zero
local streamerSnapshot

local STREAMER_HIDDEN_KEYS = {
    "watermarkEnabled", "spectatorListEnabled", "nametagsEnabled", "boxEspEnabled",
    "cornerBoxEnabled", "healthBarEnabled", "headDotEnabled", "tracersEnabled",
    "grenadeEspEnabled", "jumpCircleEnabled", "hitmarkerEnabled", "chamsEnabled",
    "showFovCircle", "showSilentFovCircle",
}

local function refreshXCToggle(key)
    local refresh = UI_Bind_Registry[key]
    if refresh then pcall(refresh, XCConfig[key] == true) end
end

local function setXCStreamerMode(enabled)
    enabled = enabled == true
    if enabled and not streamerSnapshot then
        streamerSnapshot = {}
        for _, key in ipairs(STREAMER_HIDDEN_KEYS) do
            streamerSnapshot[key] = XCConfig[key]
            XCConfig[key] = false
            refreshXCToggle(key)
        end
        XCConfig.streamerModeEnabled = true
        clearActiveJumpCircle()
    elseif not enabled and streamerSnapshot then
        for key, value in pairs(streamerSnapshot) do
            XCConfig[key] = value
            refreshXCToggle(key)
        end
        streamerSnapshot = nil
        XCConfig.streamerModeEnabled = false
        if XCConfig.jumpCircleEnabled and player.Character then
            initJumpCircleForCharacter(player.Character)
        end
    else
        XCConfig.streamerModeEnabled = enabled
    end
    refreshXCToggle("streamerModeEnabled")
end

local function stopXCCameraMode()
    xcCameraMode = nil
    XCConfig.freecamEnabled = false
    XCConfig.freelookEnabled = false
    local cam = Workspace.CurrentCamera or camera
    if cam and xcSavedCameraState then
        pcall(function()
            cam.CameraType = xcSavedCameraState.CameraType or Enum.CameraType.Custom
            if xcSavedCameraState.CameraSubject then cam.CameraSubject = xcSavedCameraState.CameraSubject end
            cam.CFrame = xcSavedCameraState.CFrame or cam.CFrame
        end)
    end
    if xcSavedCameraState then
        pcall(function()
            UserInputService.MouseBehavior = xcSavedCameraState.MouseBehavior
            UserInputService.MouseIconEnabled = xcSavedCameraState.MouseIconEnabled
        end)
    end
    xcSavedCameraState = nil
    refreshXCToggle("freecamEnabled")
    refreshXCToggle("freelookEnabled")
end

local function setXCCameraMode(mode, enabled)
    if not enabled then
        if xcCameraMode == mode then stopXCCameraMode() end
        return
    end

    local cam = Workspace.CurrentCamera or camera
    if not cam then return end
    if not xcSavedCameraState then
        xcSavedCameraState = {
            CameraType = cam.CameraType,
            CameraSubject = cam.CameraSubject,
            CFrame = cam.CFrame,
            MouseBehavior = UserInputService.MouseBehavior,
            MouseIconEnabled = UserInputService.MouseIconEnabled,
        }
    end

    xcCameraMode = mode
    XCConfig.freecamEnabled = mode == "Freecam"
    XCConfig.freelookEnabled = mode == "Freelook"
    xcCameraFrame = cam.CFrame
    xcCameraPosition = cam.CFrame.Position
    local pitch, yaw = cam.CFrame:ToOrientation()
    xcCameraPitch = pitch
    xcCameraYaw = yaw
    cam.CameraType = Enum.CameraType.Scriptable
    if not UserInputService.TouchEnabled then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false
    end
    refreshXCToggle("freecamEnabled")
    refreshXCToggle("freelookEnabled")
end

table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Touch and xcCameraMode and not processed then
        local cam = Workspace.CurrentCamera or camera
        if cam and input.Position.X >= cam.ViewportSize.X * 0.45 then
            xcCameraTouch = input
            xcCameraTouchLast = input.Position
            xcCameraTouchDelta = Vector2.zero
        end
    end
    if processed then return end
    local freecamKey = Enum.KeyCode[XCConfig.freecamKey or "F4"]
    local freelookKey = Enum.KeyCode[XCConfig.freelookKey or "LeftAlt"]
    local streamerKey = Enum.KeyCode[XCConfig.streamerKey or "F8"]
    if freecamKey and input.KeyCode == freecamKey then
        setXCCameraMode("Freecam", not XCConfig.freecamEnabled)
    elseif freelookKey and input.KeyCode == freelookKey then
        setXCCameraMode("Freelook", not XCConfig.freelookEnabled)
    elseif streamerKey and input.KeyCode == streamerKey then
        setXCStreamerMode(not XCConfig.streamerModeEnabled)
    end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
    if input == xcCameraTouch and xcCameraTouchLast then
        local current = input.Position
        xcCameraTouchDelta += Vector2.new(current.X - xcCameraTouchLast.X, current.Y - xcCameraTouchLast.Y)
        xcCameraTouchLast = current
    end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
    if input == xcCameraTouch then
        xcCameraTouch = nil
        xcCameraTouchLast = nil
        xcCameraTouchDelta = Vector2.zero
    end
end))

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    if XCConfig.weatherEnabled then
        weatherUpdateAccumulator += dt
        if weatherUpdateAccumulator >= 0.1 then
            weatherUpdateAccumulator = 0
            applyXCWeather()
            local cam = Workspace.CurrentCamera or camera
            if weatherRig and cam then
                weatherRig.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 30, 0))
            end
        end
    elseif weatherRig or weatherAtmosphere then
        destroyXCWeather()
    end

    if not xcCameraMode then return end
    local cam = Workspace.CurrentCamera or camera
    if not cam then return end
    if (xcCameraMode == "Freecam" and not XCConfig.freecamEnabled)
        or (xcCameraMode == "Freelook" and not XCConfig.freelookEnabled) then
        stopXCCameraMode()
        return
    end

    cam.CameraType = Enum.CameraType.Scriptable
    local delta = UserInputService:GetMouseDelta() + xcCameraTouchDelta * 0.55
    xcCameraTouchDelta = Vector2.zero
    local sensitivity = xcCameraMode == "Freecam"
        and (tonumber(XCConfig.freecamSensitivity) or 0.18)
        or (tonumber(XCConfig.freelookSensitivity) or 0.16)
    xcCameraYaw -= math.rad(delta.X * sensitivity)
    xcCameraPitch = math.clamp(xcCameraPitch - math.rad(delta.Y * sensitivity), math.rad(-85), math.rad(85))
    local rotation = CFrame.Angles(0, xcCameraYaw, 0) * CFrame.Angles(xcCameraPitch, 0, 0)

    if xcCameraMode == "Freecam" then
        local movement = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then movement += Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then movement += Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then movement += Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then movement += Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then movement += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then movement += Vector3.new(0, -1, 0) end
        local speed = math.max(5, tonumber(XCConfig.freecamSpeed) or 55)
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then speed *= 2.5 end
        if movement.Magnitude > 0 then
            xcCameraPosition += rotation:VectorToWorldSpace(movement.Unit) * speed * dt
        end
        if UserInputService.TouchEnabled then
            local character = player and player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.MoveDirection.Magnitude > 0.05 then
                xcCameraPosition += humanoid.MoveDirection.Unit * speed * dt
            end
        end
    end

    xcCameraFrame = CFrame.new(xcCameraPosition) * rotation
    cam.CFrame = xcCameraFrame
end))

-- ==========================================
-- CLEANUP ROUTINES
-- ==========================================
function cleanup()
    setXCStreamerMode(false)
    stopXCCameraMode()
    destroyXCWeather()
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
    
    pcall(function()
        if bulletTrail then bulletTrail:Destroy() end
        if bulletFlash then bulletFlash:Destroy() end
    end)
    
    if genv then genv.XCShowHitmarker = nil end
    if mobileSlideBtn then
        pcall(function() mobileSlideBtn:Destroy() end)
        mobileSlideBtn = nil
    end
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

    pcall(function() if targetGui:FindFirstChild("XCScreenGui") then targetGui.XCScreenGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("XCToggleGui") then targetGui.XCToggleGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("XCFovGui") then targetGui.XCFovGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("XCWatermarkGui") then targetGui.XCWatermarkGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("XCNotificationsGui") then targetGui.XCNotificationsGui:Destroy() end end)
    pcall(function() if spectatorGui then spectatorGui:Destroy() end end)
    stopXCAnimation()
    pcall(function() if targetGui:FindFirstChild("XCMainContainer") then targetGui.XCMainContainer:Destroy() end end)
end

if genv then genv.XCRunning = cleanup end

function bindTouch(btn, callback)
    btn.Activated:Connect(callback)
end

-- ==========================================
-- HUD & WATEMARK
-- ==========================================
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "XCFovGui"
fovGui.ResetOnSpawn = false
fovGui.DisplayOrder = 9
fovGui.IgnoreGuiInset = true
fovGui.Parent = targetGui

local fovFrame = Instance.new("Frame", fovGui)
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovFrame.BackgroundTransparency = 1
fovFrame.BorderSizePixel = 0
fovFrame.Visible = false
local fovStroke = Instance.new("UIStroke", fovFrame)
fovStroke.Color = currentTheme.Accent
fovStroke.Thickness = 0.8
local fovCorner = Instance.new("UICorner", fovFrame)
fovCorner.CornerRadius = UDim.new(1, 0)

local silentFovFrame = Instance.new("Frame", fovGui)
silentFovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
silentFovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
silentFovFrame.BackgroundTransparency = 1
silentFovFrame.BorderSizePixel = 0
silentFovFrame.Visible = false
local silentFovStroke = Instance.new("UIStroke", silentFovFrame)
silentFovStroke.Color = Color3.fromRGB(0, 230, 255)
silentFovStroke.Thickness = 0.8
local silentFovCorner = Instance.new("UICorner", silentFovFrame)
silentFovCorner.CornerRadius = UDim.new(1, 0)

local watermarkGui = Instance.new("ScreenGui")
watermarkGui.Name = "XCWatermarkGui"
watermarkGui.ResetOnSpawn = false
watermarkGui.DisplayOrder = 20
watermarkGui.IgnoreGuiInset = true
watermarkGui.Parent = targetGui

local wmCard = Instance.new("Frame", watermarkGui)
wmCard.Position = UDim2.new(0, 14, 0, 14)
wmCard.Size = UDim2.new(0, 0, 0, 22)
wmCard.AutomaticSize = Enum.AutomaticSize.X
wmCard.BackgroundColor3 = currentTheme.Background
wmCard.BorderSizePixel = 0
Instance.new("UICorner", wmCard).CornerRadius = UDim.new(0, 5)

local wmStroke = Instance.new("UIStroke", wmCard)
wmStroke.Color = currentTheme.Border
wmStroke.Thickness = 1.0

local wmPad = Instance.new("UIPadding", wmCard)
wmPad.PaddingLeft = UDim.new(0, 8)
wmPad.PaddingRight = UDim.new(0, 8)

local wmLayout = Instance.new("UIListLayout", wmCard)
wmLayout.FillDirection = Enum.FillDirection.Horizontal
wmLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wmLayout.Padding = UDim.new(0, 5)

local wmDot = Instance.new("Frame", wmCard)
wmDot.Size = UDim2.new(0, 5, 0, 5)
wmDot.BackgroundColor3 = currentTheme.Accent
wmDot.BorderSizePixel = 0
Instance.new("UICorner", wmDot).CornerRadius = UDim.new(1, 0)

local wmTitle = Instance.new("TextLabel", wmCard)
wmTitle.AutomaticSize = Enum.AutomaticSize.X
wmTitle.Size = UDim2.new(0, 0, 1, 0)
wmTitle.BackgroundTransparency = 1
wmTitle.Text = "XC"
wmTitle.TextColor3 = currentTheme.Accent
wmTitle.TextSize = 9
wmTitle.Font = Enum.Font.GothamBold

local wmDivider = Instance.new("Frame", wmCard)
wmDivider.Size = UDim2.new(0, 1, 0, 10)
wmDivider.BackgroundColor3 = currentTheme.Border
wmDivider.BorderSizePixel = 0

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
-- GRENADE TRAJECTORY ENGINE
-- ==========================================
local grenadeRayParams = RaycastParams.new()
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
    lbl.TextSize = 9
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
    if not XCConfig.grenadeEspEnabled then
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
                    if dist <= XCConfig.grenadeMaxDist then
                        activeGrenades[item] = true
                        local ui = getOrCreateGrenadeUI(item)
                        local scrPos, onScreen = camera:WorldToViewportPoint(part.Position)

                        if onScreen and scrPos.Z > 0 then
                            ui.Tag.Position = UDim2.new(0, scrPos.X, 0, scrPos.Y - 6)
                            ui.Label.Text = string.format("%s [%dm]", nadeType, math.floor(dist))
                            ui.Label.TextColor3 = nadeColor
                            ui.Tag.Visible = true

                            if XCConfig.showGrenadePath and part.AssemblyLinearVelocity and part.AssemblyLinearVelocity.Magnitude > 2 then
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

                            local shouldShowRadius = (nadeType == "MOLOTOV" and XCConfig.showMolotovRadius) or (nadeType == "SMOKE" and XCConfig.showSmokeRadius)
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
--  AIM ENGINE SHLAK
-- ==========================================
local visRayParams = RaycastParams.new()
visRayParams.FilterType = Enum.RaycastFilterType.Exclude
visRayParams.IgnoreWater = true

function isTargetVisible(originPos, targetPart, targetChar)
    if not XCConfig.visibleCheck or XCConfig.wallbangEnabled then return true end
    local myChar = player.Character
    visRayParams.FilterDescendantsInstances = {myChar, camera}
    local dir = targetPart.Position - originPos
    
    local hit = Workspace:Raycast(originPos, dir, visRayParams)
    if hit and (hit.Instance:IsDescendantOf(targetChar) or hit.Instance == targetPart) then
        return true
    end
    return false
end

local function getPingLatency()
    local ping = 0.03
    pcall(function()
        local serverStats = Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem")
        if serverStats and serverStats:FindFirstChild("Data Ping") then
            ping = (serverStats["Data Ping"]:GetValue() / 1000)
        end
    end)
    return ping
end

function getKinematicAimPosition(targetPart)
    local rawPos = targetPart.Position
    if not XCConfig.predictionEnabled then
        return rawPos
    end

    local ping = getPingLatency()
    local predDelta = (XCConfig.predictionFactor * 0.5) + ping
    local targetVel = targetPart.AssemblyLinearVelocity or Vector3.zero

    local myChar = player.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myVel = (myHrp and myHrp.AssemblyLinearVelocity) or Vector3.zero
    
    local relativeVel = targetVel - (myVel * 0.15)
    return rawPos + (relativeVel * predDelta)
end

function getClosestTarget()
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end

    local camCFrame = cam.CFrame
    local camPos = camCFrame.Position
    local camLook = camCFrame.LookVector
    local maxAngleRad = math.rad(XCConfig.aimFov * 0.5)

    if currentAimTarget then
        local cChar = currentAimTarget.Char
        local cHum = currentAimTarget.Hum
        local cPart = currentAimTarget.Part
        local priorityName = tostring(XCConfig.priorityPlayerName or "None")
        local currentPlayer = currentAimTarget.Player
        local priorityAllowsSticky = priorityName == "None"
            or (currentPlayer and (currentPlayer.Name == priorityName or currentPlayer.DisplayName == priorityName))
        if isEntityAlive(cChar, cHum) and cPart and cPart.Parent then
            local predPos = getKinematicAimPosition(cPart)
            local toTarget = (predPos - camPos).Unit
            local angle = math.acos(math.clamp(camLook:Dot(toTarget), -1, 1))
            
            if priorityAllowsSticky and angle <= (maxAngleRad * 1.15) then
                currentAimTarget.AimPosition = predPos
                return currentAimTarget
            end
        end
    end

    local bestTarget = nil
    local bestScore = math.huge
    local allPlayers = Players:GetPlayers()

    for i = 1, #allPlayers do
        local plr = allPlayers[i]
        local char = plr.Character
        if char and plr ~= player and isTargetEnemy(plr, char) then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if isEntityAlive(char, hum) then
                local hitPart = getTargetHitbox(char)
                if hitPart then
                    local aimPos = getKinematicAimPosition(hitPart)
                    local toTarget = (aimPos - camPos).Unit
                    local angle = math.acos(math.clamp(camLook:Dot(toTarget), -1, 1))

                    if angle <= maxAngleRad then
                        local dist = (aimPos - camPos).Magnitude
                        local score = (angle * 0.7) + ((dist / 1000) * 0.3)
                        local priorityName = tostring(XCConfig.priorityPlayerName or "None")
                        if priorityName ~= "None"
                            and (plr.Name == priorityName or plr.DisplayName == priorityName) then
                            score -= 1000
                        end
                        if score < bestScore then
                            bestScore = score
                            bestTarget = {
                                Player = plr,
                                Char = char,
                                Part = hitPart,
                                Hum = hum,
                                Position = hitPart.Position,
                                AimPosition = aimPos,
                                AngularDelta = angle
                            }
                        end
                    end
                end
            end
        end
    end

    if bestTarget and (tick() - lastTargetSwitchTick > TARGET_HYSTERESIS_TIME) then
        currentAimTarget = bestTarget
        lastTargetSwitchTick = tick()
    elseif not bestTarget then
        currentAimTarget = nil
    end

    return currentAimTarget
end

-- ==========================================
-- RAGEBOT TT
-- ==========================================
function getRageTarget()
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end
    local camPos = cam.CFrame.Position
    local camLook = cam.CFrame.LookVector

    local bestTarget = nil
    local bestScore = math.huge
    local allPlayers = Players:GetPlayers()

    for i = 1, #allPlayers do
        local plr = allPlayers[i]
        local char = plr.Character
        if char and plr ~= player and isTargetEnemy(plr, char) then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if isEntityAlive(char, hum) then
                local hitPart = getTargetHitbox(char)
                if hitPart then
                    if XCConfig.wallbangEnabled or isVisibleThroughWalls(hitPart, char) then
                        local aimPos = getKinematicAimPosition(hitPart)
                        local score = math.huge
                        
                        if XCConfig.rageTargetMode == "Distance" then
                            score = (aimPos - camPos).Magnitude
                        elseif XCConfig.rageTargetMode == "Health" then
                            score = hum.Health
                        elseif XCConfig.rageTargetMode == "FOV" then
                            local direction = (aimPos - camPos).Unit
                            score = math.acos(math.clamp(camLook:Dot(direction), -1, 1))
                        elseif XCConfig.rageTargetMode == "Priority" then
                            local priorityName = tostring(XCConfig.priorityPlayerName or "None")
                            local isPriority = priorityName ~= "None"
                                and (plr.Name == priorityName or plr.DisplayName == priorityName)
                            score = (isPriority and -100000 or 0) + (aimPos - camPos).Magnitude
                        end

                        if score < bestScore then
                            bestScore = score
                            bestTarget = {
                                Player = plr,
                                Char = char,
                                Part = hitPart,
                                Hum = hum,
                                Position = hitPart.Position,
                                AimPosition = aimPos
                            }
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- ==========================================
-- TRIGGERBOT + MATERIAL/THICKNESS PENETRATION
-- ==========================================
local triggerRayParams = RaycastParams.new()
triggerRayParams.FilterType = Enum.RaycastFilterType.Exclude
triggerRayParams.IgnoreWater = true

-- Conservative BloxStrike material limits adapted from the existing
-- penetration model. Values are maximum accumulated thickness.
local triggerMaterialLimits = {
    [Enum.Material.Asphalt] = 0.25, [Enum.Material.Basalt] = 0.25,
    [Enum.Material.Brick] = 0.25, [Enum.Material.Cobblestone] = 0.25,
    [Enum.Material.Concrete] = 0.25, [Enum.Material.CrackedLava] = 0.25,
    [Enum.Material.DiamondPlate] = 0.25, [Enum.Material.Foil] = 0.25,
    [Enum.Material.Glacier] = 0.25, [Enum.Material.Granite] = 0.25,
    [Enum.Material.Grass] = 0.25, [Enum.Material.Ground] = 0.25,
    [Enum.Material.Ice] = 0.25, [Enum.Material.LeafyGrass] = 0.25,
    [Enum.Material.Limestone] = 0.25, [Enum.Material.Marble] = 0.25,
    [Enum.Material.Metal] = 0.25, [Enum.Material.Mud] = 0.25,
    [Enum.Material.Pavement] = 0.25, [Enum.Material.Rock] = 0.25,
    [Enum.Material.Salt] = 0.25, [Enum.Material.Sand] = 0.25,
    [Enum.Material.Sandstone] = 0.25, [Enum.Material.Slate] = 0.25,
    [Enum.Material.Snow] = 0.25, [Enum.Material.ForceField] = 0.25,
    [Enum.Material.Neon] = 0.25, [Enum.Material.CorrodedMetal] = 0.25,
    [Enum.Material.Pebble] = 0.25, [Enum.Material.CeramicTiles] = 0.25,
    [Enum.Material.Plaster] = 0.25,
    [Enum.Material.Plastic] = 7, [Enum.Material.SmoothPlastic] = 7,
    [Enum.Material.Wood] = 7, [Enum.Material.WoodPlanks] = 7,
    [Enum.Material.Cardboard] = 7, [Enum.Material.Glass] = 100,
    [Enum.Material.Fabric] = 100,
}

local triggerMaterialVariantLimits = {
    IndoorWall = 0.25,
    ["Sandy Brick"] = 0.25,
}

local function triggerIsCharacterPart(part, targetModel)
    return part and targetModel and part:IsDescendantOf(targetModel)
end

local function triggerFindTargetAlongRay(origin, direction, targetModel)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local filter = {player.Character}
    params.FilterDescendantsInstances = filter

    local currentOrigin = origin
    local remaining = direction.Unit * math.min(direction.Magnitude, 1000)
    local accumulated = {}
    local steps = 0

    while remaining.Magnitude > 0.05 and steps < 100 do
        steps += 1
        local hit = Workspace:Raycast(currentOrigin, remaining, params)
        if not hit or not hit.Instance then
            return nil
        end

        if triggerIsCharacterPart(hit.Instance, targetModel) then
            return hit
        end

        local part = hit.Instance
        if not part:IsA("BasePart") then
            table.insert(filter, part)
            params.FilterDescendantsInstances = filter
            currentOrigin = hit.Position + remaining.Unit * 0.01
            remaining = direction.Unit * math.max(0, (origin + direction.Unit * math.min(direction.Magnitude, 1000) - currentOrigin).Magnitude)
            continue
        end

        -- Find the exit point through THIS exact hit part.
        local backParams = RaycastParams.new()
        backParams.FilterType = Enum.RaycastFilterType.Include
        backParams.IgnoreWater = true
        backParams.FilterDescendantsInstances = {part}

        local farPoint = hit.Position + remaining.Unit * 1000
        local exitHit = Workspace:Raycast(farPoint, hit.Position - farPoint, backParams)
        if not exitHit then
            return nil
        end

        local thickness = (hit.Position - exitHit.Position).Magnitude
        local variant = part.MaterialVariant
        local limit = triggerMaterialVariantLimits[variant]
        local key = variant ~= "" and variant or part.Material

        if limit then
            accumulated[key] = (accumulated[key] or 0) + thickness
            if accumulated[key] > limit then
                return nil
            end
        else
            limit = triggerMaterialLimits[part.Material]
            if limit == nil then
                -- Unknown surfaces are treated conservatively rather than
                -- allowing a blind shot through an arbitrary map object.
                limit = 0.25
            end
            accumulated[key] = (accumulated[key] or 0) + thickness
            if accumulated[key] > limit then
                return nil
            end
        end

        table.insert(filter, part)
        params.FilterDescendantsInstances = filter

        local endPoint = origin + direction.Unit * math.min(direction.Magnitude, 1000)
        currentOrigin = exitHit.Position + direction.Unit * 0.01
        local left = (endPoint - currentOrigin).Magnitude
        if left <= 0.05 then
            return nil
        end
        remaining = direction.Unit * left
    end

    return nil
end

local function triggerbotFire(vp)
    pcall(function()
        local myChar = player.Character
        local equippedTool = myChar and myChar:FindFirstChildOfClass("Tool")
        if equippedTool then
            equippedTool:Activate()
            return
        end

        if VirtualInputManager then
            VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, false, game, 0)
        end
    end)
end

function runMobileTriggerbot()
    if not XCConfig.triggerbotEnabled then return end

    local cam = Workspace.CurrentCamera or camera
    if not cam then return end

    local now = tick()
    if (now - lastTriggerTick) < triggerbotDelay then return end

    local vp = cam.ViewportSize
    local origin = cam.CFrame.Position
    local rayDirection = cam.CFrame.LookVector * 1000

    -- First pass: only consider whatever is actually under the FOV center.
    triggerRayParams.FilterDescendantsInstances = {player.Character}
    local first = Workspace:Raycast(origin, rayDirection, triggerRayParams)
    if not first or not first.Instance then return end

    local firstModel = first.Instance:FindFirstAncestorOfClass("Model")
    local firstPlayer = firstModel and Players:GetPlayerFromCharacter(firstModel)

    if firstPlayer and firstPlayer ~= player then
        local _, onScreen = cam:WorldToViewportPoint(first.Instance.Position)
        if not onScreen then return end
        if firstModel:GetAttribute("Dead") or firstModel:GetAttribute("Invincible") then return end
        local hum = firstModel:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then return end
        if not isTargetEnemy(firstPlayer, firstModel) then return end
        if triggerbotHeadOnly and first.Instance.Name ~= "Head" then return end

        lastTriggerTick = now
        if triggerbotMobileAutoFire then triggerbotFire(vp) end
        return
    end

    -- Wall hit: find enemy candidates near the FOV center, then test the
    -- exact camera -> candidate line for material + physical penetration.
    local bestTarget, bestScreenDistance = nil, math.huge
    for _, hitPlayer in ipairs(Players:GetPlayers()) do
        if hitPlayer ~= player and isTargetEnemy(hitPlayer, hitPlayer.Character) then
            local char = hitPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health > 0 and not char:GetAttribute("Dead") and not char:GetAttribute("Invincible") then
                local targetPart = char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    if not triggerbotHeadOnly or targetPart.Name == "Head" then
                        local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                        if onScreen and screenPos.Z > 0 then
                            local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                            local fovRadius = tonumber(XCConfig.triggerbotFov) or tonumber(XCConfig.aimFov) or 160
                            if dist <= fovRadius and dist < bestScreenDistance then
                                bestScreenDistance = dist
                                bestTarget = {Player = hitPlayer, Model = char, Part = targetPart}
                            end
                        end
                    end
                end
            end
        end
    end

    if not bestTarget then return end

    local targetDirection = bestTarget.Part.Position - origin
    local confirmed = triggerFindTargetAlongRay(origin, targetDirection, bestTarget.Model)
    if not confirmed then return end

    lastTriggerTick = now
    if triggerbotMobileAutoFire then triggerbotFire(vp) end
end

-- ==========================================
-- 2D ESP 
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
    stroke.Thickness = XCConfig.boxThickness
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
    tagCard.BackgroundColor3 = currentTheme.Sidebar
    tagCard.BackgroundTransparency = XCConfig.tagTransparency
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
    tagLabel.TextSize = XCConfig.espTextSize
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
-- TACTICAL ESP
-- ==========================================
local tacticalOverlayWasActive = false
local function hideTacticalOverlay()
    for _, esp in pairs(screenEspCache) do
        esp.Box.Visible = false
        esp.HealthBarBg.Visible = false
        esp.TagCard.Visible = false
        for _, corner in ipairs(esp.Corners) do
            corner.H.Visible = false
            corner.V.Visible = false
        end
    end
end

function renderTacticalOverlay()
    local active = XCConfig.nametagsEnabled or XCConfig.boxEspEnabled or XCConfig.cornerBoxEnabled
    if not active then
        if tacticalOverlayWasActive then hideTacticalOverlay() end
        tacticalOverlayWasActive = false
        return
    end
    tacticalOverlayWasActive = true
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

        if isEnemy and isAlive and rootPart and (XCConfig.nametagsEnabled or XCConfig.boxEspEnabled or XCConfig.cornerBoxEnabled) then
            local dist = (rootPart.Position - camPos).Magnitude

            if dist <= XCConfig.espMaxDist then
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

                    if XCConfig.boxEspEnabled and not XCConfig.cornerBoxEnabled then
                        esp.BoxStroke.Color = sideColor
                        esp.BoxStroke.Thickness = XCConfig.boxThickness
                        esp.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                        esp.Box.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                        esp.Box.Visible = true
                        for _, corner in ipairs(esp.Corners) do
                            corner.H.Visible = false
                            corner.V.Visible = false
                        end
                    elseif XCConfig.cornerBoxEnabled then
                        esp.Box.Visible = false
                        local lengthX = math.max(boxWidth * 0.25, 4)
                        local lengthY = math.max(boxHeight * 0.25, 4)
                        local thick = XCConfig.boxThickness + 0.5

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

                    if (XCConfig.boxEspEnabled or XCConfig.cornerBoxEnabled) and XCConfig.healthBarEnabled and hum then
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

                    if XCConfig.nametagsEnabled then
                        esp.TagCard.BackgroundTransparency = XCConfig.tagTransparency
                        esp.TagCardStroke.Color = currentTheme.Border
                        esp.TagLabel.TextSize = XCConfig.espTextSize

                        local baseName = plr.DisplayName or plr.Name
                        local infoText = baseName
                        
                        if XCConfig.espShowDistance then
                            infoText = string.format("%s [%dm]", infoText, math.floor(dist))
                        end
                        if XCConfig.espShowHealth and hum then
                            local curHealth = math.floor(hum.Health)
                            infoText = string.format("%s [%dHP]", infoText, curHealth > 0 and curHealth or 100)
                        end
                        if XCConfig.tagShowWeapon then
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
-- 3D ESP
-- ==========================================
function attachEspToPlayer(plr)
    if plr == player then return end

    local holder = Instance.new("Folder")
    holder.Name = "XCESP_" .. plr.Name
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
    hl.Name = "XCChams_" .. plr.Name
    hl.FillTransparency = XCConfig.chamsFillTransparency
    hl.OutlineTransparency = XCConfig.chamsOutlineTransparency
    hl.Enabled = false
    hl.FillColor = chamsColorVisible
    hl.OutlineColor = chamsOutlineColor
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = holder

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
    local charRemConn = plr.CharacterRemoving:Connect(function()
        if hl then
            hl.Adornee = nil
            hl.Enabled = false
        end
    end)
    table.insert(connections, charConn)
    table.insert(connections, charRemConn)

    activeEspHolders[plr] = {
        Holder = holder,
        HeadDot = dotBillboard,
        DotFrame = dotFrame,
        Tracer = tracerLine,
        Highlight = hl
    }
end

for _, v in pairs(Players:GetPlayers()) do attachEspToPlayer(v) end
table.insert(connections, Players.PlayerAdded:Connect(attachEspToPlayer))

-- ==========================================
-- MAIN ENGINE RENDER LOOP
-- ==========================================
local visualOverlayAccumulator = 0
local threeDEspWasActive = false
table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    camera = Workspace.CurrentCamera or camera
    if not camera then return end

    applyThirdPerson(dt)

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
        local parts = {}
        if XCConfig.watermarkShowFPS then table.insert(parts, string.format("FPS: %d", currentFps)) end
        if XCConfig.watermarkShowPing then table.insert(parts, string.format("PING: %dms", pingVal)) end
        wmMetrics.Text = table.concat(parts, " | ")
        fpsCounter = 0
        lastFpsUpdate = nowTick
    end
    wmCard.Visible = XCConfig.watermarkEnabled
    wmTitle.Text = XCConfig.watermarkText or "XC"
    if XCConfig.watermarkShowName then
        wmTitle.Text = (XCConfig.watermarkText or "XC") .. " • " .. player.Name
    end
    wmMetrics.Visible = XCConfig.watermarkShowFPS or XCConfig.watermarkShowPing
    wmDivider.Visible = wmMetrics.Visible

    if fovFrame then
        local isFovVisible = XCConfig.aimbotEnabled and XCConfig.showFovCircle
        fovFrame.Visible = isFovVisible
        if isFovVisible then
            local diameter = XCConfig.aimFov * 2
            fovFrame.Size = UDim2.new(0, diameter, 0, diameter)
        end
    end

    if silentFovFrame then
        local isSilentFovVisible = XCConfig.silentAimEnabled and XCConfig.showSilentFovCircle
        silentFovFrame.Visible = isSilentFovVisible
        if isSilentFovVisible then
            local diameter = XCConfig.silentAimFov * 2
            silentFovFrame.Size = UDim2.new(0, diameter, 0, diameter)
        end
    end

    if XCConfig.silentAimEnabled then
        -- Cache only the current target for legacy camera/mouse hooks.
        -- Actual ShootWeapon interception resolves its own target at fire time
        -- and performs Hit Chance once per shot.
        silentAimResolved = getSilentAimTarget()
    else
        silentAimResolved = nil
    end

    if (XCConfig.rcsEnabled or XCConfig.noRecoilEnabled) and noRecoil.isShooting then
        local comp = (XCConfig.noRecoilEnabled and (XCConfig.recoilStrength * 0.0035) or 0) + (XCConfig.rcsEnabled and ((XCConfig.rcsStrength / 100) * 0.004 * XCConfig.rcsPitchFactor) or 0)
        camera.CFrame = camera.CFrame * CFrame.Angles(-comp, 0, 0)
    end

    -- RAGEBOT & AIMBOT EXECUTION
    if XCConfig.rageBotEnabled then
        local target = getRageTarget()
        if target and target.Part and target.Part.Parent then
            local aimPos = getKinematicAimPosition(target.Part)
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, aimPos)
            
            if XCConfig.rageAutoFire and tick() - lastTriggerTick > triggerbotDelay then
                lastTriggerTick = tick()
                pcall(function()
                    local vp = camera.ViewportSize
                    if VirtualInputManager then
                        VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, true, game, 0)
                        task.wait(0.01)
                        VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, false, game, 0)
                    end
                end)
            end
        end
    elseif XCConfig.aimbotEnabled then
        local target = getClosestTarget()
        if target and target.Part and target.Part.Parent then
            local aimPos = getKinematicAimPosition(target.Part)
            local currentCF = camera.CFrame
            local desiredCF = CFrame.lookAt(currentCF.Position, aimPos)

            if XCConfig.snapAimMode then
                camera.CFrame = desiredCF
            else
                local responsiveness = math.clamp(XCConfig.aimbotSpeed, 1, 100)
                local damping = 1 - math.clamp(XCConfig.aimbotSmoothness, 0, 0.95)
                local effectiveFactor = 1 - math.exp(-responsiveness * damping * dt)
                camera.CFrame = currentCF:Lerp(desiredCF, effectiveFactor)
            end
        end
    else
        currentAimTarget = nil
    end

    runMobileTriggerbot()

    visualOverlayAccumulator += dt
    if visualOverlayAccumulator >= (1 / 30) then
        visualOverlayAccumulator = 0
        renderTacticalOverlay()
        renderGrenadeOverlays()

        local threeDEspActive = XCConfig.chamsEnabled or XCConfig.headDotEnabled or XCConfig.tracersEnabled
        if threeDEspActive or threeDEspWasActive then
        for plr, data in pairs(activeEspHolders) do
        if not threeDEspActive then
            data.HeadDot.Enabled = false
            data.Highlight.Enabled = false
            data.Tracer.Visible = false
            continue
        end
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local rootPart = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        local head = char and char:FindFirstChild("Head")
        
        local ally = isAlly(plr)
        local isAlive = isEntityAlive(char, hum)
        local dist = rootPart and (rootPart.Position - localPos).Magnitude or 9999

        if char and isAlive and (dist <= XCConfig.espMaxDist) then
            local isVisible = isVisibleThroughWalls(head or rootPart, char)
            
            if XCConfig.chamsEnabled then
                if ally and not XCConfig.chamsShowTeammates then
                    data.Highlight.Enabled = false
                else
                    data.Highlight.Enabled = true
                    if data.Highlight.Adornee ~= char then
                        data.Highlight.Adornee = char
                    end
                    data.Highlight.FillTransparency = XCConfig.chamsFillTransparency
                    data.Highlight.OutlineTransparency = XCConfig.chamsOutlineTransparency
                    data.Highlight.OutlineColor = chamsOutlineColor

                    if ally then
                        data.Highlight.FillColor = chamsColorAlly
                    else
                        data.Highlight.FillColor = XCConfig.chamsOcclusion and (isVisible and chamsColorVisible or chamsColorHidden) or chamsColorVisible
                    end
                end
            else
                data.Highlight.Enabled = false
            end

            if not ally then
                local activeAccent = isVisible and currentTheme.Enemy_Accent or currentTheme.Enemy_Hidden
                
                if head and data.HeadDot.Adornee ~= head then
                    data.HeadDot.Adornee = head
                end
                data.DotFrame.BackgroundColor3 = activeAccent
                data.HeadDot.Enabled = XCConfig.headDotEnabled

                if XCConfig.tracersEnabled and rootPart then
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
                data.Tracer.Visible = false
            end
        else
            data.HeadDot.Enabled = false
            data.Highlight.Enabled = false
            data.Tracer.Visible = false
            if data.Highlight.Adornee then data.Highlight.Adornee = nil end
            if data.HeadDot.Adornee then data.HeadDot.Adornee = nil end
        end
        end
        end
        threeDEspWasActive = threeDEspActive
    end

    if XCConfig.fullBrightEnabled then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    elseif XCConfig.nightModeEnabled then
        local cfg = nightPresets[XCConfig.nightPreset] or nightPresets["Midnight"]
        Lighting.Brightness = XCConfig.nightBrightness or cfg.Brightness
        Lighting.ClockTime = XCConfig.nightClockTime or cfg.ClockTime
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = cfg.OutdoorAmbient
        Lighting.Ambient = cfg.Ambient
    end

    if XCConfig.removeFogEnabled then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = defaultLighting.FogEnd
    end
    if XCConfig.antiFlashEnabled then
        pcall(function()
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("ColorCorrectionEffect") and v.Saturation < -0.5 then v.Enabled = false end
            end
        end)
    end
end))

-- ==========================================
-- ANTI-AIM ROTATION SHLAK
-- ==========================================
table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    if not XCConfig.flightEnabled
        and not XCConfig.slideEnabled
        and not XCConfig.bunnyHopEnabled
        and not XCConfig.speedEnabled then
        return
    end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not XCConfig.antiAimEnabled then
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

    currentSpinAngle = (currentSpinAngle + (XCConfig.spinSpeed * dt * 60)) % 360
    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(currentSpinAngle), 0)
end))

-- ==========================================
-- GROUND CHECK & MOBILE INPUT HOOKS
-- ==========================================
local groundRayParams = RaycastParams.new()
groundRayParams.FilterType = Enum.RaycastFilterType.Exclude
groundRayParams.IgnoreWater = true

function isPlayerGrounded(char, hrp)
    groundRayParams.FilterDescendantsInstances = {char, camera}
    local origin = hrp.Position
    local direction = Vector3.new(0, -3.2, 0)
    return Workspace:Raycast(origin, direction, groundRayParams) ~= nil
end

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
    local stroke = mobileSlideBtn:FindFirstChild("XCSlideStroke")
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
        mobileSlideBtn.Visible = XCConfig.slideEnabled and UserInputService.TouchEnabled
        if not XCConfig.slideEnabled then
            mobileSlideToggleActive = false
            isSliding = false
            currentSlideVel = Vector3.zero
            updateMobileSlideIndicator()
        end
    end
end

function triggerMobileSlideStart()
    if not XCConfig.slideEnabled then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum and isEntityAlive(char, hum) and isPlayerGrounded(char, hrp)) then return false end

    local moveDir = hum.MoveDirection.Magnitude > 0.1 and hum.MoveDirection or hrp.CFrame.LookVector
    currentSlideVel = moveDir * (16 * XCConfig.slideSpeedBoost)
    isSliding = true
    hum.HipHeight = defaultHipHeight * 0.4
    return true
end

function triggerMobileSlideEnd()
    isSliding = false
    currentSlideVel = Vector3.zero
    restoreDefaultHipHeight()
end

function toggleMobileSlide()
    if not XCConfig.slideEnabled then return end
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
    mobileSlideBtn.Name = "XCMobileSlideBtn"
    mobileSlideBtn.Size = UDim2.new(0, 50, 0, 50)
    mobileSlideBtn.Position = UDim2.new(1, -145, 1, -115)
    mobileSlideBtn.BackgroundColor3 = currentTheme.CardBg
    mobileSlideBtn.BackgroundTransparency = 0.3
    mobileSlideBtn.Text = "SLIDE"
    mobileSlideBtn.TextColor3 = currentTheme.Accent
    mobileSlideBtn.TextSize = 9.5
    mobileSlideBtn.Font = Enum.Font.GothamBold
    mobileSlideBtn.Visible = XCConfig.slideEnabled and UserInputService.TouchEnabled
    mobileSlideBtn.ZIndex = 80
    mobileSlideBtn.Active = true
    mobileSlideBtn.AutoButtonColor = false
    mobileSlideBtn.Parent = mainContainer

    Instance.new("UICorner", mobileSlideBtn).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", mobileSlideBtn)
    stroke.Name = "XCSlideStroke"
    stroke.Color = currentTheme.Border
    stroke.Thickness = 1.2

    local tapConn = mobileSlideBtn.Activated:Connect(function()
        if mobileSlideDragging then
            mobileSlideDragging = false
            return
        end
        toggleMobileSlide()
    end)
    table.insert(connections, tapConn)

    local dragStart, buttonStart = nil, nil
    local dragConn = mobileSlideBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            buttonStart = mobileSlideBtn.Position
            mobileSlideDragging = false
        end
    end)
    table.insert(connections, dragConn)

    local changedConn = mobileSlideBtn.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch or not dragStart or not buttonStart then return end
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

        for _, conn in ipairs(mobileJumpConnections) do pcall(function() conn:Disconnect() end) end
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
    local childAddedConnection = char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then scanAndMorphKnives(child) end
    end)
    table.insert(connections, childAddedConnection)
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then scanAndMorphKnives(tool) end
    end
end

table.insert(connections, player.CharacterAdded:Connect(function(char)
    mobileSlideToggleActive = false
    mobileSlideDragging = false
    isSliding = false
    currentSlideVel = Vector3.zero
    mobileSlideInputActive = false
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

local jumpReqConn = UserInputService.JumpRequest:Connect(function() isMobileJumpHeld = true end)
table.insert(connections, jumpReqConn)

local inBeganConn = UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then isMobileJumpHeld = true end
    if XCConfig.slideEnabled and (input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.LeftControl) then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and isEntityAlive(char, hum) and isPlayerGrounded(char, hrp) then
            if not defaultHipHeightCaptured then captureDefaultHipHeight(char) end
            local moveDir = hum.MoveDirection.Magnitude > 0.1 and hum.MoveDirection or hrp.CFrame.LookVector
            currentSlideVel = moveDir * (16 * XCConfig.slideSpeedBoost)
            isSliding = true
            hum.HipHeight = defaultHipHeight * 0.4
        end
    end
end)
table.insert(connections, inBeganConn)

local inEndedConn = UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then isMobileJumpHeld = false end
    if input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.LeftControl then
        isSliding = false
        currentSlideVel = Vector3.zero
        restoreDefaultHipHeight()
    end
end)
table.insert(connections, inEndedConn)

-- ==========================================
-- HITMARKER & PHYSICS LOOP NO WORK
-- ==========================================
table.insert(connections, RunService.Heartbeat:Connect(function()
    if not XCConfig.hitmarkerEnabled then
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

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or not isEntityAlive(char, hum) then return end

    local moveDir = hum.MoveDirection
    if moveDir.Magnitude < 0.05 then
        local camCFrame = Workspace.CurrentCamera.CFrame
        local kbDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then kbDir += camCFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then kbDir -= camCFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then kbDir -= camCFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then kbDir += camCFrame.RightVector end
        kbDir = Vector3.new(kbDir.X, 0, kbDir.Z)
        if kbDir.Magnitude > 0 then moveDir = kbDir.Unit end
    end

    local currentMove = moveDir
    if currentMove.Magnitude > 0.05 then lastMoveDirection = currentMove end

    local currentVel = hrp.AssemblyLinearVelocity
    local finalVelocity = nil
    local activeMode = "Normal"

    if XCConfig.flightEnabled then
        activeMode = "Flight"
        finalVelocity = camera.CFrame.LookVector * XCConfig.flightSpeed
    elseif XCConfig.slideEnabled and isSliding then
        if isPlayerGrounded(char, hrp) and currentSlideVel.Magnitude > XCConfig.slideMinSpeed then
            activeMode = "Slide"
            local frictionFactor = math.pow(math.clamp(XCConfig.slideFriction, 0, 1), math.max(dt, 0) * 60)
            currentSlideVel = currentSlideVel * frictionFactor
            finalVelocity = Vector3.new(currentSlideVel.X, currentVel.Y, currentSlideVel.Z)
        else
            isSliding = false
            currentSlideVel = Vector3.zero
            restoreDefaultHipHeight()
        end
    end

    if activeMode == "Normal" and XCConfig.bunnyHopEnabled then
        local grounded = isPlayerGrounded(char, hrp) or hum.FloorMaterial ~= Enum.Material.Air
        local isSpacePressed = UserInputService:IsKeyDown(Enum.KeyCode.Space)
        local shouldJump = XCConfig.bhopAutoJump or isMobileJumpHeld or hum.Jump or isSpacePressed

        if grounded and shouldJump then
            activeMode = "Bhop"
            hum.Jump = true
            
            local currentX = finalVelocity and finalVelocity.X or currentVel.X
            local currentZ = finalVelocity and finalVelocity.Z or currentVel.Z
            finalVelocity = Vector3.new(currentX, XCConfig.bhopJumpPower, currentZ)
            
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            
        elseif not grounded and XCConfig.bhopAirStrafe and currentMove.Magnitude > 0.05 then
            activeMode = "AutoStrafe"
            local targetSpeed = 16 * XCConfig.bhopSpeedBoost
            local targetVel = currentMove * targetSpeed
            
            local currentY = finalVelocity and finalVelocity.Y or currentVel.Y
            finalVelocity = Vector3.new(targetVel.X, currentY, targetVel.Z)
        end
    end

    if activeMode == "Normal" and XCConfig.speedEnabled and currentMove.Magnitude > 0 then
        activeMode = "Speed"
        local targetVel = currentMove * (16 * XCConfig.walkMultiplier)
        finalVelocity = Vector3.new(targetVel.X, currentVel.Y, targetVel.Z)
    end

    if finalVelocity then 
        hrp.AssemblyLinearVelocity = finalVelocity 
    end
end))

-- ==========================================
-- UI BUILDER
-- ==========================================
function setAntiAfkEnabled(enabled)
    XCConfig.antiAfkEnabled = enabled
    if antiAfkConnection then
        pcall(function() antiAfkConnection:Disconnect() end)
        antiAfkConnection = nil
    end
    if not XCConfig.antiAfkEnabled then return end

    antiAfkConnection = player.Idled:Connect(function()
        pcall(function()
            if VirtualInputManager then
                VirtualInputManager:SendMouseButtonEvent(1, 1, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(1, 1, 0, false, game, 0)
            end
        end)
    end)
end

-- ==========================================
-- XC SKEET / GAMESENSE INTERFACE
-- ==========================================
function buildXCUI()
    setAntiAfkEnabled(XCConfig.antiAfkEnabled)

    local C = {
        Main = Color3.fromRGB(17, 17, 17),
        Sidebar = Color3.fromRGB(13, 13, 13),
        Panel = Color3.fromRGB(12, 12, 12),
        Control = Color3.fromRGB(25, 25, 25),
        Control2 = Color3.fromRGB(35, 35, 35),
        Border = Color3.fromRGB(44, 44, 44),
        Black = Color3.fromRGB(0, 0, 0),
        Lime = Color3.fromRGB(152, 204, 0),
        White = Color3.fromRGB(235, 235, 235),
        Text = Color3.fromRGB(200, 200, 200),
        Muted = Color3.fromRGB(110, 110, 110),
    }

    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "XCToggleGui"
    toggleGui.ResetOnSpawn = false
    toggleGui.IgnoreGuiInset = true
    toggleGui.DisplayOrder = 100
    toggleGui.Parent = targetGui

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "XCScreenGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 50
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = targetGui

    local main = Instance.new("Frame")
    main.Name = "SkeetMain"
    main.Size = UDim2.fromOffset(680, 450)
    main.Position = UDim2.new(0.5, -340, 0.5, -225)
    main.BackgroundColor3 = C.Main
    main.BorderColor3 = C.Border
    main.BorderSizePixel = 1
    main.Active = true
    main.Parent = screenGui

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = C.Black
    mainStroke.Thickness = 2
    mainStroke.Parent = main

    local scale = Instance.new("UIScale")
    scale.Name = "ResponsiveScale"
    scale.Parent = main

    local function updateScale()
        local viewport = screenGui.AbsoluteSize
        if viewport.X <= 0 or viewport.Y <= 0 then return end
        local preferred = UserInputService.TouchEnabled and 0.82 or 1
        if XCConfig.settingsCompactMode then preferred *= 0.88 end
        scale.Scale = math.min(preferred, (viewport.X - 20) / 680, (viewport.Y - 20) / 450)
        main.Position = UDim2.new(0.5, -340 * scale.Scale, 0.5, -225 * scale.Scale)
    end
    updateScale()
    task.defer(updateScale)
    table.insert(connections, screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale))

    local topLine = Instance.new("Frame")
    topLine.Size = UDim2.new(1, -4, 0, 2)
    topLine.Position = UDim2.fromOffset(2, 2)
    topLine.BorderSizePixel = 0
    topLine.BackgroundColor3 = C.Lime
    topLine.Parent = main
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 210, 255)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(160, 75, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 65, 140)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 135, 20)),
        ColorSequenceKeypoint.new(1, C.Lime),
    })
    gradient.Parent = topLine

    local dragBar = Instance.new("Frame")
    dragBar.Name = "DragBar"
    dragBar.Size = UDim2.new(1, -52, 0, 10)
    dragBar.Position = UDim2.fromOffset(52, 0)
    dragBar.BackgroundTransparency = 1
    dragBar.Active = true
    dragBar.ZIndex = 20
    dragBar.Parent = main

    local sidebar = Instance.new("Frame")
    sidebar.Name = "IconBar"
    sidebar.Size = UDim2.new(0, 48, 1, -4)
    sidebar.Position = UDim2.fromOffset(2, 2)
    sidebar.BackgroundColor3 = C.Sidebar
    sidebar.BorderColor3 = C.Border
    sidebar.BorderSizePixel = 1
    sidebar.Parent = main

    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 1)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = sidebar

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -64, 1, -18)
    content.Position = UDim2.fromOffset(56, 10)
    content.BackgroundTransparency = 1
    content.Parent = main

    local pages = {}
    local tabData = {}
    local currentPage
    local refreshers = {}
    local activeSliderInput
    local activeSliderMove

    local CONTROL_HELP = {
        aimbotEnabled = "Tracks a valid target inside the configured field of view.",
        silentAimEnabled = "Redirects supported shot data without visibly snapping the camera.",
        triggerbotEnabled = "Fires when a valid target is under the crosshair.",
        rageBotEnabled = "Aggressive target selection using the Rage FOV and priority settings.",
        noRecoilEnabled = "Suppresses supported weapon and camera recoil callbacks.",
        noSpreadEnabled = "Requests zero spread from supported weapon calculations.",
        wallbangEnabled = "Allows target selection through surfaces when supported by the game.",
        thirdPersonEnabled = "Moves the native camera behind the character.",
        flightEnabled = "Moves the character along the camera direction.",
        chamsEnabled = "Adds a local highlight to valid player models.",
        grenadeEspEnabled = "Shows nearby grenade labels, paths and effect radiuses.",
        nightModeEnabled = "Applies the selected lighting preset locally.",
        worldSkyboxEnabled = "Applies the selected custom skybox locally.",
        worldPostFXEnabled = "Enables local color correction and post-processing.",
        weatherEnabled = "Local weather layer. Uses one particle emitter to avoid frame spikes.",
        weatherMode = "Rain, snow, fog or ash. The effect follows the active camera.",
        weatherIntensity = "Controls particle rate or fog density.",
        weatherWind = "Horizontal drift of rain, snow and ash particles.",
        freecamEnabled = "Detaches the camera. WASD moves, Space/E rises, Q/Ctrl lowers, Shift boosts.",
        freecamSpeed = "Movement speed of the detached camera.",
        freecamKey = "Hotkey that toggles Freecam without opening the menu.",
        freelookEnabled = "Rotates the view in place without moving the character or camera origin.",
        freelookSensitivity = "Mouse sensitivity used by Freelook.",
        freelookKey = "Hotkey that toggles Freelook without opening the menu.",
        streamerModeEnabled = "Roblox-safe capture mode: temporarily hides XC overlays without deleting their settings.",
        streamerKey = "Hotkey for quickly hiding or restoring XC overlays.",
        priorityPlayerName = "Roblox player selected as the preferred target. The list uses live server usernames.",
        customScopeEnabled = "Draws the XC scope overlay when scoped.",
        customHandsEnabled = "Offsets the detected first-person weapon or hands model.",
        spectatorListEnabled = "Shows players currently observing the local player when detectable.",
        menuKey = "Keyboard shortcut used to show or hide XC.",
    }

    local helpPopup = Instance.new("Frame")
    helpPopup.Name = "ContextHelp"
    helpPopup.Size = UDim2.fromOffset(UserInputService.TouchEnabled and 260 or 235, 0)
    helpPopup.AutomaticSize = Enum.AutomaticSize.Y
    helpPopup.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    helpPopup.BorderColor3 = C.Lime
    helpPopup.BorderSizePixel = 1
    helpPopup.Visible = false
    helpPopup.ZIndex = 300
    helpPopup.Parent = screenGui
    local helpPadding = Instance.new("UIPadding")
    helpPadding.PaddingTop = UDim.new(0, 7)
    helpPadding.PaddingBottom = UDim.new(0, 7)
    helpPadding.PaddingLeft = UDim.new(0, 9)
    helpPadding.PaddingRight = UDim.new(0, 9)
    helpPadding.Parent = helpPopup
    local helpText = Instance.new("TextLabel")
    helpText.Size = UDim2.new(1, 0, 0, 0)
    helpText.AutomaticSize = Enum.AutomaticSize.Y
    helpText.BackgroundTransparency = 1
    helpText.TextColor3 = C.Text
    helpText.Font = Enum.Font.Code
    helpText.TextSize = UserInputService.TouchEnabled and 11 or 10
    helpText.TextWrapped = true
    helpText.TextXAlignment = Enum.TextXAlignment.Left
    helpText.TextYAlignment = Enum.TextYAlignment.Top
    helpText.ZIndex = 301
    helpText.Parent = helpPopup
    local helpToken = 0

    local function hideHelp()
        helpToken += 1
        helpPopup.Visible = false
    end

    local function showHelp(target, message)
        if not message or message == "" or not target or not target.Parent then return end
        helpToken += 1
        helpText.Text = message
        helpPopup.Visible = true
        task.defer(function()
            if not helpPopup.Visible or not target.Parent then return end
            local viewport = screenGui.AbsoluteSize
            local width = helpPopup.AbsoluteSize.X
            local height = math.max(helpPopup.AbsoluteSize.Y, 34)
            local x = math.clamp(target.AbsolutePosition.X, 6, math.max(6, viewport.X - width - 6))
            local below = target.AbsolutePosition.Y + target.AbsoluteSize.Y + 5
            local y = below + height <= viewport.Y - 6 and below
                or math.max(6, target.AbsolutePosition.Y - height - 5)
            helpPopup.Position = UDim2.fromOffset(x, y)
        end)
    end

    local function attachHelp(target, key)
        local message = CONTROL_HELP[key]
        if not message then return end
        target.MouseEnter:Connect(function() showHelp(target, message) end)
        target.MouseLeave:Connect(hideHelp)
        target.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch then return end
            helpToken += 1
            local token = helpToken
            task.delay(0.45, function()
                if token == helpToken then showHelp(target, message) end
            end)
        end)
        target.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then hideHelp() end
        end)
    end

    local function createPage(name)
        local page = Instance.new("Frame")
        page.Name = name
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = content
        pages[name] = page
        return page
    end

    local function createPanel(page, title, x, width)
        local panel = Instance.new("Frame")
        panel.Name = title
        panel.Size = UDim2.new(width, 0, 1, 0)
        panel.Position = UDim2.new(x, 0, 0, 0)
        panel.BackgroundColor3 = C.Panel
        panel.BorderColor3 = C.Border
        panel.BorderSizePixel = 1
        panel.Parent = page

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -16, 0, 24)
        titleLabel.Position = UDim2.fromOffset(8, 3)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = C.Text
        titleLabel.Font = Enum.Font.Code
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = panel

        local scroll = Instance.new("ScrollingFrame")
        scroll.Name = "Controls"
        scroll.Size = UDim2.new(1, -14, 1, -32)
        scroll.Position = UDim2.fromOffset(7, 28)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 2
        scroll.ScrollBarImageColor3 = C.Border
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new()
        scroll.Parent = panel

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 4)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 7)
        padding.PaddingRight = UDim.new(0, 7)
        padding.PaddingBottom = UDim.new(0, 9)
        padding.Parent = scroll
        return scroll
    end

    local function section(parent, text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 17)
        label.BackgroundTransparency = 1
        label.Text = text:upper()
        label.TextColor3 = C.Lime
        label.Font = Enum.Font.Code
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent
    end

    local function addToggle(parent, label, key, onChanged)
        local row = Instance.new("TextButton")
        row.Name = key
        row.Size = UDim2.new(1, 0, 0, 20)
        row.BackgroundTransparency = 1
        row.Text = ""
        row.AutoButtonColor = false
        row.Parent = parent
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, -36, 1, 0)
        text.Position = UDim2.fromOffset(0, 0)
        text.BackgroundTransparency = 1
        text.Text = label
        text.TextColor3 = C.Text
        text.Font = Enum.Font.Code
        text.TextSize = 11
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Parent = row

        local track = Instance.new("Frame")
        track.Name = "SwitchTrack"
        track.Size = UDim2.fromOffset(27, 13)
        track.Position = UDim2.new(1, -28, 0.5, -6)
        track.BackgroundColor3 = C.Control2
        track.BorderColor3 = C.Black
        track.BorderSizePixel = 1
        track.Parent = row
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track

        local knob = Instance.new("Frame")
        knob.Name = "Knob"
        knob.Size = UDim2.fromOffset(9, 9)
        knob.Position = UDim2.new(0, 2, 0.5, -4)
        knob.BackgroundColor3 = C.Muted
        knob.BorderSizePixel = 0
        knob.Parent = track
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob

        local function refresh(value)
            track.BackgroundColor3 = value and Color3.fromRGB(76, 102, 0) or C.Control2
            knob.BackgroundColor3 = value and C.Lime or C.Muted
            knob.Position = value and UDim2.new(1, -11, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
            text.TextColor3 = value and C.White or C.Text
        end
        refresh(XCConfig[key] == true)
        UI_Bind_Registry[key] = refresh
        refreshers[key] = refreshers[key] or {}
        table.insert(refreshers[key], refresh)
        row.Activated:Connect(function()
            XCConfig[key] = not XCConfig[key]
            refresh(XCConfig[key])
            if onChanged then onChanged(XCConfig[key]) end
            if key ~= "settingsShowNotifications" then
                XCNotify(label, XCConfig[key] and "Enabled" or "Disabled", XCConfig[key] and "success" or "warning", 1.5)
            end
        end)
        attachHelp(row, key)
        return row
    end

    local function addSlider(parent, label, key, minValue, maxValue, step, suffix, onChanged)
        local holder = Instance.new("Frame")
        holder.Name = key
        holder.Size = UDim2.new(1, 0, 0, 36)
        holder.BackgroundTransparency = 1
        holder.Active = true
        holder.Parent = parent
        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(0.68, 0, 0, 16)
        name.BackgroundTransparency = 1
        name.Text = label
        name.TextColor3 = C.Text
        name.Font = Enum.Font.Code
        name.TextSize = 10
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.Parent = holder
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.32, 0, 0, 16)
        valueLabel.Position = UDim2.new(0.68, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.TextColor3 = C.Text
        valueLabel.Font = Enum.Font.Code
        valueLabel.TextSize = 10
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = holder
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 7)
        bar.Position = UDim2.fromOffset(0, 21)
        bar.BackgroundColor3 = C.Control2
        bar.BorderColor3 = C.Black
        bar.BorderSizePixel = 1
        bar.Active = true
        bar.Parent = holder
        local fill = Instance.new("Frame")
        fill.BorderSizePixel = 0
        fill.BackgroundColor3 = C.Lime
        fill.Parent = bar
        local function refresh(value)
            value = math.clamp(tonumber(value) or minValue, minValue, maxValue)
            fill.Size = UDim2.new((value - minValue) / (maxValue - minValue), 0, 1, 0)
            local shown = step < 1 and string.format("%.2f", value) or tostring(math.floor(value + 0.5))
            valueLabel.Text = shown .. (suffix or "")
        end
        local function setFromX(x)
            if bar.AbsoluteSize.X <= 0 then return end
            local pct = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local raw = minValue + (maxValue - minValue) * pct
            local value = math.floor(raw / step + 0.5) * step
            XCConfig[key] = value
            refresh(value)
            if onChanged then onChanged(value) end
        end
        refresh(XCConfig[key])
        refreshers[key] = refreshers[key] or {}
        table.insert(refreshers[key], refresh)
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                activeSliderInput = input
                activeSliderMove = setFromX
                setFromX(input.Position.X)
            end
        end)
        attachHelp(holder, key)
    end

    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if activeSliderMove and activeSliderInput
            and (input == activeSliderInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
            activeSliderMove(input.Position.X)
        end
    end))
    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input == activeSliderInput
            or (activeSliderInput and activeSliderInput.UserInputType == Enum.UserInputType.MouseButton1
                and input.UserInputType == Enum.UserInputType.MouseButton1) then
            activeSliderInput = nil
            activeSliderMove = nil
        end
    end))

    local activeDropdown
    local function closeDropdown()
        if activeDropdown and activeDropdown.popup then
            activeDropdown.popup:Destroy()
        end
        activeDropdown = nil
    end

    local function pointInside(gui, point)
        if not gui or not gui.Parent then return false end
        local pos, size = gui.AbsolutePosition, gui.AbsoluteSize
        return point.X >= pos.X and point.X <= pos.X + size.X
            and point.Y >= pos.Y and point.Y <= pos.Y + size.Y
    end

    table.insert(connections, UserInputService.InputBegan:Connect(function(input)
        if not activeDropdown then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not pointInside(activeDropdown.button, input.Position)
            and not pointInside(activeDropdown.popup, input.Position) then
            closeDropdown()
        end
    end))

    local function openDropdown(button, key, values, onChanged, refresh)
        hideHelp()
        if activeDropdown and activeDropdown.button == button then
            closeDropdown()
            return
        end
        closeDropdown()

        local rowHeight = UserInputService.TouchEnabled and 28 or 23
        local visibleRows = math.min(#values, UserInputService.TouchEnabled and 5 or 7)
        local popupHeight = visibleRows * rowHeight + 2
        local buttonPos, buttonSize = button.AbsolutePosition, button.AbsoluteSize
        local viewport = screenGui.AbsoluteSize
        local belowY = buttonPos.Y + buttonSize.Y + 2
        local aboveY = buttonPos.Y - popupHeight - 2
        local openAbove = belowY + popupHeight > viewport.Y - 6 and aboveY >= 6

        local popup = Instance.new("ScrollingFrame")
        popup.Name = "SmartDropdown_" .. key
        popup.Position = UDim2.fromOffset(
            math.clamp(buttonPos.X, 6, math.max(6, viewport.X - buttonSize.X - 6)),
            openAbove and aboveY or math.min(belowY, viewport.Y - popupHeight - 6)
        )
        popup.Size = UDim2.fromOffset(buttonSize.X, popupHeight)
        popup.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
        popup.BorderColor3 = C.Border
        popup.BorderSizePixel = 1
        popup.ScrollBarThickness = #values > visibleRows and 2 or 0
        popup.ScrollBarImageColor3 = C.Lime
        popup.CanvasSize = UDim2.fromOffset(0, #values * rowHeight)
        popup.ZIndex = 200
        popup.Parent = screenGui

        local popupStroke = Instance.new("UIStroke")
        popupStroke.Color = C.Black
        popupStroke.Thickness = 1
        popupStroke.Parent = popup

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = popup

        for index, option in ipairs(values) do
            local selected = XCConfig[key] == option
            local optionButton = Instance.new("TextButton")
            optionButton.Name = tostring(option)
            optionButton.LayoutOrder = index
            optionButton.Size = UDim2.new(1, 0, 0, rowHeight)
            optionButton.BackgroundColor3 = selected and Color3.fromRGB(32, 39, 17) or Color3.fromRGB(18, 18, 18)
            optionButton.BorderSizePixel = 0
            optionButton.Text = tostring(option)
            optionButton.TextColor3 = selected and C.White or C.Text
            optionButton.Font = Enum.Font.Code
            optionButton.TextSize = UserInputService.TouchEnabled and 11 or 10
            optionButton.TextXAlignment = Enum.TextXAlignment.Left
            optionButton.AutoButtonColor = false
            optionButton.ZIndex = 201
            optionButton.Parent = popup
            local optionPadding = Instance.new("UIPadding")
            optionPadding.PaddingLeft = UDim.new(0, 18)
            optionPadding.PaddingRight = UDim.new(0, 8)
            optionPadding.Parent = optionButton

            local marker = Instance.new("Frame")
            marker.Name = "SelectionMarker"
            marker.Size = UDim2.fromOffset(selected and 7 or 4, selected and 7 or 4)
            marker.Position = UDim2.new(0, 7, 0.5, selected and -3 or -2)
            marker.BackgroundColor3 = selected and C.Lime or C.Border
            marker.BorderSizePixel = 0
            marker.ZIndex = 202
            marker.Parent = optionButton
            local markerCorner = Instance.new("UICorner")
            markerCorner.CornerRadius = UDim.new(1, 0)
            markerCorner.Parent = marker

            optionButton.MouseEnter:Connect(function()
                optionButton.BackgroundColor3 = selected and Color3.fromRGB(38, 48, 18) or C.Control2
                optionButton.TextColor3 = C.White
            end)
            optionButton.MouseLeave:Connect(function()
                optionButton.BackgroundColor3 = selected and Color3.fromRGB(32, 39, 17) or Color3.fromRGB(18, 18, 18)
                optionButton.TextColor3 = selected and C.White or C.Text
            end)
            optionButton.Activated:Connect(function()
                XCConfig[key] = option
                refresh(option)
                if onChanged then onChanged(option) end
                closeDropdown()
            end)
        end

        local selectedIndex = table.find(values, XCConfig[key]) or 1
        popup.CanvasPosition = Vector2.new(0, math.max(0, (selectedIndex - 2) * rowHeight))
        activeDropdown = {popup = popup, button = button, key = key}
    end

    local function addChoice(parent, label, key, values, onChanged)
        local holder = Instance.new("Frame")
        holder.Size = UDim2.new(1, 0, 0, 38)
        holder.BackgroundTransparency = 1
        holder.Active = true
        holder.Parent = parent
        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(1, 0, 0, 14)
        name.BackgroundTransparency = 1
        name.Text = label
        name.TextColor3 = C.Text
        name.Font = Enum.Font.Code
        name.TextSize = 10
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.Parent = holder
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 22)
        button.Position = UDim2.fromOffset(0, 15)
        button.BackgroundColor3 = C.Control
        button.BorderColor3 = C.Black
        button.BorderSizePixel = 1
        button.Text = ""
        button.AutoButtonColor = false
        button.Parent = holder

        local valueText = Instance.new("TextLabel")
        valueText.Size = UDim2.new(1, -30, 1, 0)
        valueText.Position = UDim2.fromOffset(8, 0)
        valueText.BackgroundTransparency = 1
        valueText.TextColor3 = C.Text
        valueText.Font = Enum.Font.Code
        valueText.TextSize = 10
        valueText.TextXAlignment = Enum.TextXAlignment.Left
        valueText.TextTruncate = Enum.TextTruncate.AtEnd
        valueText.Parent = button

        local arrow = Instance.new("Frame")
        arrow.Name = "Chevron"
        arrow.Size = UDim2.fromOffset(14, 12)
        arrow.Position = UDim2.new(1, -20, 0.5, -6)
        arrow.BackgroundTransparency = 1
        arrow.Parent = button
        local arrowLeft = Instance.new("Frame")
        arrowLeft.AnchorPoint = Vector2.new(0.5, 0.5)
        arrowLeft.Position = UDim2.fromOffset(5, 5)
        arrowLeft.Size = UDim2.fromOffset(6, 1.4)
        arrowLeft.BackgroundColor3 = C.Muted
        arrowLeft.BorderSizePixel = 0
        arrowLeft.Rotation = 42
        arrowLeft.Parent = arrow
        local arrowRight = Instance.new("Frame")
        arrowRight.AnchorPoint = Vector2.new(0.5, 0.5)
        arrowRight.Position = UDim2.fromOffset(9, 5)
        arrowRight.Size = UDim2.fromOffset(6, 1.4)
        arrowRight.BackgroundColor3 = C.Muted
        arrowRight.BorderSizePixel = 0
        arrowRight.Rotation = -42
        arrowRight.Parent = arrow

        local function refresh(value)
            valueText.Text = tostring(value)
            valueText.TextColor3 = C.Text
        end
        refresh(XCConfig[key] or values[1])
        refreshers[key] = refreshers[key] or {}
        table.insert(refreshers[key], refresh)
        button.Activated:Connect(function()
            openDropdown(button, key, values, onChanged, refresh)
        end)
        attachHelp(holder, key)
    end

    local function addButton(parent, label, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 24)
        button.BackgroundColor3 = C.Control
        button.BorderColor3 = C.Black
        button.BorderSizePixel = 1
        button.Text = label
        button.TextColor3 = C.Text
        button.Font = Enum.Font.Code
        button.TextSize = 10
        button.AutoButtonColor = false
        button.Parent = parent
        button.Activated:Connect(callback)
        return button
    end

    local function specialToggle(key, value)
        if value then
            if key == "fireRateEnabled" then lazyFeatureRequests.fireRate = true end
            if key == "noRecoilEnabled" or key == "noSpreadEnabled" then lazyFeatureRequests.recoilSpread = true end
            if key == "silentAimEnabled" then lazyFeatureRequests.silentFallback = true end
        end
        if key == "slideEnabled" then updateMobileSlideVisibility()
        elseif key == "jumpCircleEnabled" then
            if value and player.Character then initJumpCircleForCharacter(player.Character) else clearActiveJumpCircle() end
        elseif key == "skinChangerEnabled" and value then
            hookBloxStrikeModules(true); scanAndMorphKnives(camera)
        elseif key == "gloveChangerEnabled" and value then applyXCGloves()
        elseif key == "nightModeEnabled" then
            if value then applyNightPreset(XCConfig.nightPreset); updateWorldChanger() else restoreLightingState() end
        elseif key == "fullBrightEnabled" and not value and not XCConfig.nightModeEnabled then restoreLightingState()
        elseif key == "removeFogEnabled" and not value then restoreLightingState()
        elseif key == "thirdPersonEnabled" then setThirdPersonEnabled(value)
        elseif key == "antiAfkEnabled" then setAntiAfkEnabled(value)
        elseif key == "spectatorListEnabled" and value then buildSpectatorGui()
        elseif key == "animationsEnabled" then if value then playXCAnimation() else stopXCAnimation() end
        elseif key == "weaponChamsEnabled" then setWeaponVisuals()
        elseif key == "customScopeEnabled" then updateCustomScope()
        elseif key == "weatherEnabled" then applyXCWeather()
        elseif key == "freecamEnabled" then setXCCameraMode("Freecam", value)
        elseif key == "freelookEnabled" then setXCCameraMode("Freelook", value)
        elseif key == "streamerModeEnabled" then setXCStreamerMode(value)
        elseif key == "settingsCompactMode" then updateScale()
        end
    end
    local function toggle(parent, label, key)
        return addToggle(parent, label, key, function(v) specialToggle(key, v) end)
    end

    local ICON_OFF = Color3.fromRGB(88, 88, 88)
    local ICON_HOVER = Color3.fromRGB(155, 155, 155)
    local ICON_ON = C.White

    local function iconLine(parent, x, y, w, h, color, rotation)
        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.Position = UDim2.fromOffset(x, y)
        line.Size = UDim2.fromOffset(w, h)
        line.BackgroundColor3 = color
        line.BorderSizePixel = 0
        line.Rotation = rotation or 0
        line.Parent = parent
        return line
    end

    local function iconCircle(parent, x, y, size, color, filled)
        local circle = Instance.new("Frame")
        circle.AnchorPoint = Vector2.new(0.5, 0.5)
        circle.Position = UDim2.fromOffset(x, y)
        circle.Size = UDim2.fromOffset(size, size)
        circle.BackgroundColor3 = color
        circle.BackgroundTransparency = filled and 0 or 1
        circle.BorderSizePixel = 0
        circle.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = circle
        if not filled then
            local stroke = Instance.new("UIStroke")
            stroke.Color = color
            stroke.Thickness = 1.4
            stroke.Parent = circle
        end
        return circle
    end

    local function drawTabIcon(parent, kind, color)
        local root = Instance.new("Frame")
        root.Name = "VectorIcon"
        root.Size = UDim2.fromOffset(22, 22)
        root.Position = UDim2.fromScale(0.5, 0.5)
        root.AnchorPoint = Vector2.new(0.5, 0.5)
        root.BackgroundTransparency = 1
        root.Parent = parent
        local cx, cy = 11, 11

        if kind == "target" then
            iconCircle(root, cx, cy, 14, color, false)
            iconCircle(root, cx, cy, 5, color, false)
            iconLine(root, cx, 2.5, 1.5, 5, color)
            iconLine(root, cx, 19.5, 1.5, 5, color)
            iconLine(root, 2.5, cy, 5, 1.5, color)
            iconLine(root, 19.5, cy, 5, 1.5, color)
        elseif kind == "antiaim" then
            iconCircle(root, cx, cy, 15, color, false)
            iconLine(root, 7, 9, 7, 1.5, color, -32)
            iconLine(root, 15, 9, 7, 1.5, color, 32)
            iconLine(root, cx, 15, 1.5, 7, color)
        elseif kind == "visuals" then
            iconCircle(root, cx, cy, 7, color, false)
            for _, angle in ipairs({0, 45, 90, 135}) do
                iconLine(root, cx, 2, 1.5, 4, color, angle)
                iconLine(root, cx, 20, 1.5, 4, color, angle)
            end
        elseif kind == "world" then
            iconCircle(root, cx, cy, 15, color, false)
            iconLine(root, cx, cy, 1.5, 13, color)
            iconLine(root, cx, cy, 13, 1.5, color)
            iconCircle(root, cx, cy, 8, color, false)
        elseif kind == "misc" then
            iconCircle(root, cx, cy, 9, color, false)
            iconCircle(root, cx, cy, 3, color, false)
            for _, angle in ipairs({0, 45, 90, 135}) do iconLine(root, cx, 2, 3, 5, color, angle) end
        elseif kind == "skins" then
            iconLine(root, 12, 10, 14, 2, color, -42)
            iconLine(root, 6, 16, 7, 2, color, 42)
            iconLine(root, 8, 17.5, 6, 2, color, -42)
        elseif kind == "players" then
            iconCircle(root, cx, 6, 7, color, false)
            iconLine(root, cx, 14, 10, 1.6, color)
            iconLine(root, 7, 17, 1.7, 7, color, 18)
            iconLine(root, 15, 17, 1.7, 7, color, -18)
        elseif kind == "configs" then
            local box = Instance.new("Frame")
            box.Size = UDim2.fromOffset(14, 16)
            box.Position = UDim2.fromOffset(4, 3)
            box.BackgroundTransparency = 1
            box.Parent = root
            local stroke = Instance.new("UIStroke")
            stroke.Color = color
            stroke.Thickness = 1.4
            stroke.Parent = box
            iconLine(root, 8, 8, 7, 1.4, color)
            iconLine(root, 8, 12, 7, 1.4, color)
            iconLine(root, 8, 16, 7, 1.4, color)
        end
        return root
    end

    local function recolorTabIcon(root, color)
        for _, object in ipairs(root:GetDescendants()) do
            if object:IsA("UIStroke") then
                object.Color = color
            elseif object:IsA("Frame") and object.BackgroundTransparency < 1 then
                object.BackgroundColor3 = color
            end
        end
    end

    local tabs = {
        {"Rage", "target"}, {"AntiAim", "antiaim"}, {"Visuals", "visuals"}, {"World", "world"},
        {"Misc", "misc"}, {"Skins", "skins"}, {"Players", "players"}, {"Configs", "configs"},
    }
    local function switchPage(name)
        closeDropdown()
        hideHelp()
        currentPage = name
        for pageName, page in pairs(pages) do page.Visible = pageName == name end
        for tabName, data in pairs(tabData) do
            data.active.Visible = tabName == name
            recolorTabIcon(data.icon, tabName == name and ICON_ON or ICON_OFF)
        end
    end
    for index, info in ipairs(tabs) do
        local holder = Instance.new("Frame")
        holder.Size = UDim2.new(1, 0, 0, 41)
        holder.LayoutOrder = index
        holder.BackgroundTransparency = 1
        holder.Parent = sidebar
        local active = Instance.new("Frame")
        active.Size = UDim2.fromOffset(2, 30)
        active.Position = UDim2.new(0, -1, 0.5, -15)
        active.BackgroundColor3 = C.Lime
        active.BorderSizePixel = 0
        active.Visible = false
        active.Parent = holder
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -8, 1, 0)
        button.Position = UDim2.fromOffset(4, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.AutoButtonColor = false
        button.Parent = holder
        local icon = drawTabIcon(button, info[2], ICON_OFF)
        button.MouseEnter:Connect(function()
            if currentPage ~= info[1] then recolorTabIcon(icon, ICON_HOVER) end
        end)
        button.MouseLeave:Connect(function()
            if currentPage ~= info[1] then recolorTabIcon(icon, ICON_OFF) end
        end)
        button.Activated:Connect(function() switchPage(info[1]) end)
        tabData[info[1]] = {button = button, active = active, icon = icon}
        createPage(info[1])
    end

    local function columns(name, leftTitle, rightTitle)
        local page = pages[name]
        return createPanel(page, leftTitle, 0, 0.49), createPanel(page, rightTitle, 0.51, 0.49)
    end

    local function currentPlayerChoices()
        local values = {"None"}
        local names = {}
        for _, serverPlayer in ipairs(Players:GetPlayers()) do
            if serverPlayer ~= player then table.insert(names, serverPlayer.Name) end
        end
        table.sort(names, function(a, b) return a:lower() < b:lower() end)
        for _, name in ipairs(names) do table.insert(values, name) end
        return values
    end

    local L, R = columns("Rage", "Aimbot", "Weapon mechanics")
    section(L, "aim assistants")
    toggle(L, "Tracking", "aimbotEnabled")
    toggle(L, "Silent aim", "silentAimEnabled")
    toggle(L, "Triggerbot", "triggerbotEnabled")
    toggle(L, "Ragebot", "rageBotEnabled")
    toggle(L, "Recoil control", "rcsEnabled")
    addSlider(L, "Aim FOV", "aimFov", 10, 360, 1, "°")
    addSlider(L, "Aim speed", "aimbotSpeed", 1, 100, 1, "%")
    addSlider(L, "Smoothness", "aimbotSmoothness", 0.01, 1, 0.01, "")
    toggle(L, "Visible check", "visibleCheck")
    addSlider(L, "Silent FOV", "silentAimFov", 10, 360, 1, "°")
    addSlider(L, "Hit chance", "silentAimHitChance", 1, 100, 1, "%")
    toggle(L, "Silent team check", "silentAimTeamCheck")
    toggle(L, "Silent visible check", "silentAimVisibleCheck")
    toggle(L, "Silent head", "silentAimAimHead")
    toggle(L, "Perfect silent", "pSilentEnabled")
    toggle(L, "Wall penetration", "wallbangEnabled")

    section(R, "weapon")
    toggle(R, "No recoil", "noRecoilEnabled")
    toggle(R, "No spread", "noSpreadEnabled")
    toggle(R, "Fire rate", "fireRateEnabled")
    addSlider(R, "Fire interval", "fireRate", 0.01, 0.2, 0.01, "s")
    addSlider(R, "RCS strength", "rcsStrength", 10, 100, 1, "%")
    addSlider(R, "RCS pitch", "rcsPitchFactor", 0.1, 2, 0.1, "x")
    addSlider(R, "RCS yaw", "rcsYawFactor", 0.1, 2, 0.1, "x")
    addSlider(R, "Rage FOV", "rageFov", 30, 360, 1, "°")
    toggle(R, "Rage auto fire", "rageAutoFire")
    addChoice(R, "Target priority", "rageTargetMode", {"Distance", "Health", "FOV", "Priority"})
    addSlider(R, "Trigger FOV", "triggerbotFov", 10, 360, 1, "px")

    task.wait()
    L, R = columns("AntiAim", "Anti-aim", "Movement")
    toggle(L, "Anti-aim", "antiAimEnabled")
    addSlider(L, "Spin speed", "spinSpeed", 10, 150, 1, "")
    toggle(L, "Third person", "thirdPersonEnabled")
    addSlider(L, "Third person distance", "thirdPersonDistance", 5, 25, 1, "")
    addSlider(L, "Third person height", "thirdPersonHeight", -3, 6, 0.5, "")
    section(R, "movement")
    toggle(R, "Bhop engine", "bunnyHopEnabled")
    toggle(R, "Slide", "slideEnabled")
    toggle(R, "Flight", "flightEnabled")
    toggle(R, "Speed boost", "speedEnabled")
    toggle(R, "No fall damage", "noFallDamageEnabled")
    addSlider(R, "Bhop power", "bhopJumpPower", 30, 100, 1, "")
    addSlider(R, "Bhop speed", "bhopSpeedBoost", 1, 3, 0.1, "x")
    toggle(R, "Auto jump", "bhopAutoJump")
    toggle(R, "Air strafe", "bhopAirStrafe")
    addSlider(R, "Slide boost", "slideSpeedBoost", 1.2, 3, 0.1, "x")
    addSlider(R, "Flight speed", "flightSpeed", 10, 150, 1, "")
    addSlider(R, "Walk multiplier", "walkMultiplier", 1, 5, 0.1, "x")

    task.wait()
    L, R = columns("Visuals", "Player ESP", "Indicators")
    toggle(L, "Chams", "chamsEnabled")
    toggle(L, "Nametags", "nametagsEnabled")
    toggle(L, "Box overlay", "boxEspEnabled")
    toggle(L, "Grenade ESP", "grenadeEspEnabled")
    toggle(L, "Tracers", "tracersEnabled")
    toggle(L, "Head dot", "headDotEnabled")
    addSlider(L, "ESP distance", "espMaxDist", 100, 5000, 50, "")
    addSlider(L, "Text size", "espTextSize", 8, 20, 1, "")
    toggle(L, "Show distance", "espShowDistance")
    toggle(L, "Show health", "espShowHealth")
    toggle(L, "Show weapon", "tagShowWeapon")
    toggle(R, "Jump circle", "jumpCircleEnabled")
    toggle(R, "Hitmarker", "hitmarkerEnabled")
    addSlider(R, "Hitmarker size", "hitmarkerSize", 5, 30, 1, "")
    addSlider(R, "Hitmarker duration", "hitmarkerDuration", 0.05, 1, 0.05, "s")
    addSlider(R, "Jump radius", "jumpCircleRadius", 1.5, 8, 0.5, "")
    addChoice(R, "Jump style", "jumpCircleStyle", {"GradientWave", "ChromaPulse", "StaticNeon"})
    toggle(R, "Corner box", "cornerBoxEnabled")
    toggle(R, "Health bar", "healthBarEnabled")

    task.wait()
    L, R = columns("World", "Environment", "Scope & camera")
    toggle(L, "World changer", "nightModeEnabled")
    toggle(L, "Fullbright", "fullBrightEnabled")
    toggle(L, "Remove fog", "removeFogEnabled")
    toggle(L, "Anti flash", "antiFlashEnabled")
    addChoice(L, "Night preset", "nightPreset", {"Midnight", "Nebula", "DeepBlood", "CyberPurple", "EmeraldNight", "PitchBlack"}, function(v) if XCConfig.nightModeEnabled then applyNightPreset(v) end end)
    addSlider(L, "Brightness", "nightBrightness", 0, 5, 0.1, "")
    addSlider(L, "Clock time", "nightClockTime", 0, 24, 0.5, "h")
    toggle(L, "Custom skybox", "worldSkyboxEnabled")
    toggle(L, "Post FX", "worldPostFXEnabled")
    section(L, "weather")
    toggle(L, "Weather effects", "weatherEnabled")
    addChoice(L, "Weather type", "weatherMode", {"Rain", "Snow", "Fog", "Ash"}, function() applyXCWeather() end)
    addSlider(L, "Weather intensity", "weatherIntensity", 1, 100, 1, "%", function() applyXCWeather() end)
    addSlider(L, "Wind", "weatherWind", -40, 40, 1, "", function() applyXCWeather() end)
    toggle(R, "Custom scope", "customScopeEnabled")
    toggle(R, "Custom FOV", "customFovEnabled")
    addSlider(R, "Camera FOV", "customFov", 70, 120, 1, "°")
    toggle(R, "Remove original scope", "scopeRemoveOriginal")
    toggle(R, "Scope crosshair", "scopeCrosshairEnabled")
    addChoice(R, "Crosshair style", "scopeCrosshairStyle", {"Cross", "T", "X", "Dot"})
    addSlider(R, "Scope FOV", "scopeFov", 10, 120, 1, "°")
    addSlider(R, "Crosshair gap", "scopeCrosshairGap", 0, 80, 1, "")
    addSlider(R, "Crosshair length", "scopeCrosshairLength", 5, 300, 1, "")
    section(R, "camera director")
    toggle(R, "Freecam", "freecamEnabled")
    addSlider(R, "Freecam speed", "freecamSpeed", 5, 180, 1, "")
    addSlider(R, "Freecam sensitivity", "freecamSensitivity", 0.05, 0.5, 0.01, "")
    addChoice(R, "Freecam bind", "freecamKey", {"F3", "F4", "F5", "F6", "LeftAlt", "RightAlt"})
    toggle(R, "Freelook", "freelookEnabled")
    addSlider(R, "Look sensitivity", "freelookSensitivity", 0.05, 0.5, 0.01, "")
    addChoice(R, "Freelook bind", "freelookKey", {"LeftAlt", "RightAlt", "F3", "F4", "F5", "F6"})

    task.wait()
    L, R = columns("Skins", "Cosmetics", "Bullet effects")
    toggle(L, "Skin changer", "skinChangerEnabled")
    toggle(L, "Glove changer", "gloveChangerEnabled")
    addChoice(L, "Knife", "selectedKnifeType", {"Butterfly Knife", "Karambit", "Bayonet", "Default"})
    addChoice(L, "Skin", "selectedSkin", {"Fade", "Doppler", "Crimson Web", "Default"})
    addChoice(L, "Glove model", "selectedGloveModel", {"Sports Gloves", "Driver Gloves", "Default"})
    toggle(L, "Weapon chams", "weaponChamsEnabled")
    addChoice(L, "Weapon material", "weaponChamsMode", {"Glass", "ForceField", "Metal", "Highlight", "Neon"})
    toggle(R, "Bullet trail", "bulletTrailEnabled")
    toggle(R, "Bullet flash", "bulletFlashEnabled")
    toggle(R, "Cube checker", "cubeCheckerEnabled")
    toggle(R, "Bullet impacts", "bulletImpactEnabled")
    toggle(R, "Rainbow trail", "bulletTracerRainbow")
    addChoice(R, "Trail style", "bulletTracerStyle", {"Block", "Cylinder"})
    addSlider(R, "Trail duration", "bulletTracerDuration", 0.05, 3, 0.05, "s")
    addSlider(R, "Trail width", "bulletTracerWidth", 0.02, 0.5, 0.01, "")
    addSlider(R, "Cube distance", "cubeCheckerDistance", 1, 100, 1, "")

    task.wait()
    L, R = columns("Misc", "Utilities", "Viewmodel")
    toggle(L, "Anti AFK", "antiAfkEnabled")
    toggle(L, "Spectator list", "spectatorListEnabled")
    toggle(L, "Animations", "animationsEnabled")
    toggle(L, "Custom hands", "customHandsEnabled")
    toggle(L, "Streamer mode", "streamerModeEnabled")
    addChoice(L, "Streamer bind", "streamerKey", {"F6", "F7", "F8", "F9", "F10"})
    addSlider(L, "Animation speed", "animationSpeed", 0.1, 3, 0.1, "x")
    toggle(L, "Animation loop", "animationLoop")
    addSlider(R, "Hands X", "customHandsX", -2, 2, 0.1, "")
    addSlider(R, "Hands Y", "customHandsY", -2, 2, 0.1, "")
    addSlider(R, "Hands Z", "customHandsZ", -2, 2, 0.1, "")
    addSlider(R, "Hands pitch", "customHandsPitch", -45, 45, 1, "°")
    addSlider(R, "Hands yaw", "customHandsYaw", -45, 45, 1, "°")
    addSlider(R, "Hands roll", "customHandsRoll", -90, 90, 1, "°")

    task.wait()
    L, R = columns("Players", "Target filtering", "Overlay options")
    toggle(L, "Ignore teammates", "silentAimTeamCheck")
    toggle(L, "Visible targets only", "silentAimVisibleCheck")
    toggle(L, "Show teammates", "chamsShowTeammates")
    toggle(L, "Chams team check", "chamsTeamCheck")
    toggle(L, "Chams occlusion", "chamsOcclusion")
    addChoice(L, "Priority player", "priorityPlayerName", currentPlayerChoices())
    addSlider(L, "Chams fill", "chamsFillTransparency", 0, 1, 0.05, "")
    addSlider(L, "Chams outline", "chamsOutlineTransparency", 0, 1, 0.05, "")
    toggle(R, "Nametag distance", "espShowDistance")
    toggle(R, "Nametag health", "espShowHealth")
    toggle(R, "Nametag weapon", "tagShowWeapon")
    addSlider(R, "Tag transparency", "tagTransparency", 0, 0.9, 0.05, "")
    addSlider(R, "Box thickness", "boxThickness", 1, 3, 0.1, "")
    addSlider(R, "Grenade distance", "grenadeMaxDist", 200, 3000, 50, "")

    task.wait()
    L, R = columns("Configs", "Interface", "Config manager")
    toggle(L, "Notifications", "settingsShowNotifications")
    toggle(L, "Compact mode", "settingsCompactMode")
    toggle(L, "Watermark", "watermarkEnabled")
    toggle(L, "Show FPS", "watermarkShowFPS")
    toggle(L, "Show ping", "watermarkShowPing")
    toggle(L, "Show name", "watermarkShowName")
    addChoice(L, "Menu key", "menuKey", {"RightShift", "LeftControl", "RightControl", "F6", "F7", "F8", "F9", "F10"})

    local configName = "Default"
    local function safeName(value)
        value = tostring(value or "Default"):gsub("[^%w%-%_ ]", ""):sub(1, 48)
        return value ~= "" and value or "Default"
    end
    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(1, 0, 0, 24)
    nameBox.BackgroundColor3 = C.Control
    nameBox.BorderColor3 = C.Black
    nameBox.BorderSizePixel = 1
    nameBox.PlaceholderText = "Config name"
    nameBox.Text = configName
    nameBox.TextColor3 = C.Text
    nameBox.Font = Enum.Font.Code
    nameBox.TextSize = 10
    nameBox.Parent = R
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.BackgroundTransparency = 1
    status.Text = "XCConfigs/Default.json"
    status.TextColor3 = C.Muted
    status.Font = Enum.Font.Code
    status.TextSize = 9
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = R
    local function configPath() return "XCConfigs/" .. safeName(nameBox.Text) .. ".json" end
    local function refreshAll()
        for key, keyRefreshers in pairs(refreshers) do
            for _, refresh in ipairs(keyRefreshers) do refresh(XCConfig[key]) end
        end
        updateScale()
    end
    addButton(R, "SAVE CONFIG", function()
        local ok = pcall(function()
            if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("XCConfigs") then makefolder("XCConfigs") end
            assert(type(writefile) == "function", "File API unavailable")
            local saveData = {}
            for key, value in pairs(XCConfig) do saveData[key] = value end
            if streamerSnapshot then
                for key, value in pairs(streamerSnapshot) do saveData[key] = value end
                saveData.streamerModeEnabled = false
            end
            writefile(configPath(), HttpService:JSONEncode(saveData))
        end)
        status.Text = ok and ("saved: " .. safeName(nameBox.Text)) or "save failed"
    end)
    addButton(R, "LOAD CONFIG", function()
        local ok = pcall(function()
            setXCStreamerMode(false)
            assert(type(readfile) == "function", "File API unavailable")
            local data = HttpService:JSONDecode(readfile(configPath()))
            for key, value in pairs(data) do if XCConfig[key] ~= nil then XCConfig[key] = value end end
            lazyFeatureRequests.fireRate = XCConfig.fireRateEnabled == true
            lazyFeatureRequests.recoilSpread = XCConfig.noRecoilEnabled == true or XCConfig.noSpreadEnabled == true
            lazyFeatureRequests.silentFallback = XCConfig.silentAimEnabled == true
            refreshAll()
            updateMobileSlideVisibility(); refreshThirdPerson(); setWeaponVisuals(); updateCustomScope(); updateWorldPostFX()
            applyXCWeather()
            if XCConfig.freecamEnabled then setXCCameraMode("Freecam", true)
            elseif XCConfig.freelookEnabled then setXCCameraMode("Freelook", true)
            else stopXCCameraMode() end
            setXCStreamerMode(XCConfig.streamerModeEnabled)
            setAntiAfkEnabled(XCConfig.antiAfkEnabled)
            if XCConfig.animationsEnabled then playXCAnimation() else stopXCAnimation() end
            if XCConfig.nightModeEnabled then applyNightPreset(XCConfig.nightPreset); updateWorldChanger() else restoreLightingState() end
        end)
        status.Text = ok and ("loaded: " .. safeName(nameBox.Text)) or "load failed"
    end)
    addButton(R, "RESET DEFAULTS", function()
        setXCStreamerMode(false)
        for key, value in pairs(XCConfigDefaults) do XCConfig[key] = deepCopyConfigValue(value) end
        lazyFeatureRequests.fireRate = false
        lazyFeatureRequests.recoilSpread = false
        lazyFeatureRequests.silentFallback = false
        refreshAll(); updateMobileSlideVisibility(); refreshThirdPerson(); setWeaponVisuals(); updateCustomScope(); updateWorldPostFX()
        stopXCCameraMode(); destroyXCWeather()
        setAntiAfkEnabled(XCConfig.antiAfkEnabled)
        status.Text = "defaults restored"
    end)
    addButton(R, "DELETE CONFIG", function()
        local ok = pcall(function() assert(type(delfile) == "function"); delfile(configPath()) end)
        status.Text = ok and "config deleted" or "delete failed"
    end)

    switchPage("Rage")

    local menuVisible = true
    local function toggleMenu()
        closeDropdown()
        hideHelp()
        main.Visible = not main.Visible
        menuVisible = main.Visible
    end
    table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        local key = Enum.KeyCode[XCConfig.menuKey or "RightShift"]
        if key and input.KeyCode == key then toggleMenu() end
    end))

    local function dragObject(handle, object, saveButtonPosition)
        local activeInput, startInput, startPos, moved
        handle.InputBegan:Connect(function(input)
            if activeInput then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                activeInput, startInput, startPos, moved = input, input.Position, object.Position, false
            end
        end)
        table.insert(connections, UserInputService.InputChanged:Connect(function(input)
            if not activeInput then return end
            if input == activeInput or input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - startInput
                if delta.Magnitude >= 7 then moved = true end
                if moved then
                    object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    if saveButtonPosition then savedPos.OpenBtn = object.Position; if genv then genv.XCSavedPos.OpenBtn = object.Position end end
                end
            end
        end))
        table.insert(connections, UserInputService.InputEnded:Connect(function(input)
            if input ~= activeInput then return end
            local tap = not moved
            activeInput = nil
            if tap and saveButtonPosition then toggleMenu() end
        end))
    end
    dragObject(dragBar, main, false)

    local openBtn = Instance.new("TextButton")
    openBtn.Name = "XCButton"
    openBtn.Size = UDim2.fromOffset(56, 48)
    openBtn.Position = savedPos.OpenBtn
    openBtn.BackgroundColor3 = C.Panel
    openBtn.BorderColor3 = C.Lime
    openBtn.BorderSizePixel = 1
    openBtn.RichText = true
    openBtn.Text = '<font color="rgb(152,204,0)">X</font><font color="rgb(255,255,255)">C</font>'
    openBtn.TextColor3 = C.White
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = 23
    openBtn.AutoButtonColor = false
    openBtn.Active = true
    openBtn.Parent = toggleGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = openBtn
    dragObject(openBtn, openBtn, true)
end

-- ==========================================
-- XC-STYLE THIRD PERSON PROTECTION
-- ==========================================
local thirdPersonCameraConnection
local thirdPersonMetaInstalled = false

local function installThirdPersonProtection()
    if thirdPersonMetaInstalled then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" then return end
    if type(newcclosure) ~= "function" then return end

    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end

        local oldNewIndex = mt.__newindex
        if type(oldNewIndex) ~= "function" then return end

        setreadonly(mt, false)
        mt.__newindex = newcclosure(function(self, key, value)
            if self == player and XCConfig.thirdPersonEnabled then
                local distance = math.clamp(
                    tonumber(XCConfig.thirdPersonDistance) or 12,
                    5,
                    50
                )

                if key == "CameraMode" then
                    return oldNewIndex(self, key, Enum.CameraMode.Classic)
                elseif key == "CameraMaxZoomDistance" then
                    return oldNewIndex(self, key, distance)
                elseif key == "CameraMinZoomDistance" then
                    return oldNewIndex(self, key, distance)
                end
            end

            return oldNewIndex(self, key, value)
        end)
        setreadonly(mt, true)
        thirdPersonMetaInstalled = true
    end)
end

local function reconnectThirdPersonCamera()
    if thirdPersonCameraConnection then
        thirdPersonCameraConnection:Disconnect()
        thirdPersonCameraConnection = nil
    end

    if not camera then return end

    thirdPersonCameraConnection = camera:GetPropertyChangedSignal("CameraType"):Connect(function()
        if not XCConfig.thirdPersonEnabled or not camera then return end

        -- XC keeps the native Custom camera pipeline.
        if camera.CameraType ~= Enum.CameraType.Custom then
            camera.CameraType = Enum.CameraType.Custom
        end

        local char, hum = getThirdPersonTarget()
        if hum then
            camera.CameraSubject = hum
        end
    end)
    table.insert(connections, thirdPersonCameraConnection)
end

task.spawn(function()
    installThirdPersonProtection()
end)

reconnectThirdPersonCamera()

local currentCameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    camera = Workspace.CurrentCamera or camera
    reconnectThirdPersonCamera()

    if XCConfig.thirdPersonEnabled and camera then
        applyThirdPerson()
    end
end)
table.insert(connections, currentCameraConnection)

-- ==========================================
-- XC WEAPON MODS (ADAPTED)
-- XC No Recoil + No Spread + FireRate logic only.
-- FireRate follows the source approach: discover weapon tables containing
-- FireRate, remember their original values, and periodically write the
-- configured interval while the XC toggle is enabled.
-- ==========================================
local xcRecoilSpreadInstalled = false
local xcFireRateInstalled = false
local xcFireRateObjects = {}
local xcFireRateOriginal = {}
local xcFireRateScanDone = false
local xcRecoilSpreadRetrying = false

local function scanXCFireRateObjects()
    if xcFireRateScanDone then return #xcFireRateObjects > 0 end
    if type(getgc) ~= "function" then return false end

    local found = false
    pcall(function()
        for _, obj in next, getgc(true) do
            if type(obj) == "table" then
                local fireRate = rawget(obj, "FireRate")
                if type(fireRate) == "number" then
                    local already = false
                    for _, existing in ipairs(xcFireRateObjects) do
                        if existing == obj then
                            already = true
                            break
                        end
                    end
                    if not already then
                        table.insert(xcFireRateObjects, obj)
                        xcFireRateOriginal[obj] = fireRate
                        found = true
                    end
                end
            end
        end
    end)

    xcFireRateScanDone = true
    return found or #xcFireRateObjects > 0
end

local function restoreXCFireRates()
    for _, obj in ipairs(xcFireRateObjects) do
        pcall(function()
            if type(setreadonly) == "function" then setreadonly(obj, false) end
            local original = xcFireRateOriginal[obj]
            if type(original) == "number" then
                rawset(obj, "FireRate", original)
            end
            if type(setreadonly) == "function" then setreadonly(obj, true) end
        end)
    end
end

local function applyXCFireRate()
    local value = math.max(tonumber(XCConfig.fireRate) or 0.01, 0.01)
    for _, obj in ipairs(xcFireRateObjects) do
        pcall(function()
            if type(setreadonly) == "function" then setreadonly(obj, false) end
            rawset(obj, "FireRate", value)
            if type(setreadonly) == "function" then setreadonly(obj, true) end
        end)
    end
end

task.spawn(function()
    local wasEnabled = false
    while xcSessionActive() and task.wait(0.1) do
        pcall(function()
            if XCConfig.fireRateEnabled and lazyFeatureRequests.fireRate then
                if not xcFireRateScanDone then scanXCFireRateObjects() end
                if #xcFireRateObjects == 0 then
                    -- The game can create weapon data after injection/respawn.
                    xcFireRateScanDone = false
                    scanXCFireRateObjects()
                end
                applyXCFireRate()
            elseif wasEnabled then
                restoreXCFireRates()
            end
            wasEnabled = XCConfig.fireRateEnabled
        end)
    end
end)

local function installXCRecoilSpread()
    if xcRecoilSpreadInstalled then return true end
    if type(getgc) ~= "function" or type(hookfunction) ~= "function" then
        return false
    end
    if type(debug) ~= "table" or type(debug.getinfo) ~= "function" then
        return false
    end

    local hookedSomething = false

    pcall(function()
        for _, obj in next, getgc(true) do
            -- XC: setWeaponRecoil -> suppress the recoil setter.
            if type(obj) == "table" then
                local setRecoil = rawget(obj, "setWeaponRecoil")
                if typeof(setRecoil) == "function" then
                    pcall(function()
                        local oldSetRecoil
                        oldSetRecoil = hookfunction(setRecoil, function(...)
                            if XCConfig.noRecoilEnabled then
                                return
                            end
                            return oldSetRecoil(...)
                        end)
                        hookedSomething = true
                    end)
                end

                -- XC: weaponKick -> suppress the camera/weapon kick.
                local weaponKick = rawget(obj, "weaponKick")
                if typeof(weaponKick) == "function" then
                    pcall(function()
                        local oldKick
                        oldKick = hookfunction(weaponKick, function(...)
                            if XCConfig.noRecoilEnabled then
                                return
                            end
                            return oldKick(...)
                        end)
                        hookedSomething = true
                    end)
                end

                -- XC: getTrueSpread -> zero the calculated spread.
                local getSpread = rawget(obj, "getTrueSpread")
                if typeof(getSpread) == "function" then
                    pcall(function()
                        local oldSpread
                        oldSpread = hookfunction(getSpread, function(...)
                            if XCConfig.noSpreadEnabled then
                                return 0
                            end
                            return oldSpread(...)
                        end)
                        hookedSomething = true
                    end)
                end
            end

            -- XC: calculateRecoilOffset -> return a neutral UDim2.
            if type(obj) == "function" then
                local info
                pcall(function() info = debug.getinfo(obj) end)
                if type(info) == "table" and info.name == "calculateRecoilOffset" then
                    pcall(function()
                        local oldCalc
                        oldCalc = hookfunction(obj, function(...)
                            if XCConfig.noRecoilEnabled then
                                return UDim2.new()
                            end
                            return oldCalc(...)
                        end)
                        hookedSomething = true
                    end)
                end
            end
        end
    end)

    if hookedSomething then
        xcRecoilSpreadInstalled = true
        return true
    end
    return false
end

-- Delay GC scanning until XC UI has finished building. This is intentionally
-- separate from the launch path so unsupported executors don't block injection.
task.spawn(function()
    if xcRecoilSpreadRetrying then return end
    xcRecoilSpreadRetrying = true

    local attempts = 0
    while xcSessionActive() and not xcRecoilSpreadInstalled and attempts < 20 do
        if lazyFeatureRequests.recoilSpread
            and (XCConfig.noRecoilEnabled or XCConfig.noSpreadEnabled) then
            attempts += 1
            if installXCRecoilSpread() then break end
            task.wait(0.75)
        else
            task.wait(0.25)
        end
    end

    xcRecoilSpreadRetrying = false
end)

-- ==========================================
-- XC-STYLE SEND HOOK FALLBACK FOR SILENT AIM
-- ==========================================
local xcSilentSendHooked = false
local function setupXCSilentSendHook()
    if xcSilentSendHooked then return end
    if type(getgc) ~= "function" or type(hookfunction) ~= "function" then return end

    local sendFunc = nil
    local shootContainer = nil
    pcall(function()
        for _, obj in next, getgc(true) do
            if type(obj) == "table" and rawget(obj, "shoot") and typeof(obj.shoot) == "function" then
                for _, uv in pairs(debug.getupvalues(obj.shoot)) do
                    if type(uv) == "table" then
                        local inventory = rawget(uv, "Inventory")
                        local shootWeapon = inventory and rawget(inventory, "ShootWeapon")
                        if type(shootWeapon) == "table" and typeof(shootWeapon.Send) == "function" then
                            sendFunc = shootWeapon.Send
                            shootContainer = shootWeapon
                            break
                        end
                    end
                end
            end
            if sendFunc then break end
        end
    end)

    if type(sendFunc) ~= "function" then return end
    if shootContainer and rawget(shootContainer, "__XCSilentSendHooked") then
        xcSilentSendHooked = true
        return
    end

    local oldSend
    oldSend = hookfunction(sendFunc, function(...)
        local args = {...}
        if XCConfig.silentAimEnabled and type(args[1]) == "table" and type(args[1].Bullets) == "table" then
            local targetPart = getSilentAimTarget and getSilentAimTarget() or silentAimResolved
            if targetPart then
                local chance = math.clamp(tonumber(XCConfig.silentAimHitChance) or 100, 0, 100)
                local allowed = chance >= 100 or math.random(1, 100) <= chance
                if allowed then
                    silentAimResolved = targetPart
                    for _, bullet in pairs(args[1].Bullets) do
                        if type(bullet) == "table" and type(bullet.Hits) == "table" then
                            for _, hitData in pairs(bullet.Hits) do
                                if type(hitData) == "table" then
                                    hitData.Instance = targetPart
                                    hitData.Position = targetPart.Position
                                end
                            end
                        end
                    end
                end
            end
        end
        return oldSend(unpack(args))
    end)

    if shootContainer then rawset(shootContainer, "__XCSilentSendHooked", true) end
    xcSilentSendHooked = true
end

-- ==========================================
-- ENGINE LAUNCH / XC VISUAL EXTENSION
-- ==========================================
setupSilentAimHooks()
setupBloxStrikeShootHook()
task.spawn(function()
    while xcSessionActive() and not xcSilentSendHooked do
        if XCConfig.silentAimEnabled and lazyFeatureRequests.silentFallback then
            setupXCSilentSendHook()
            if not xcSilentSendHooked then task.wait(1.5) end
        else
            task.wait(0.25)
        end
    end
end)
buildXCUI()

-- XC-style active navigation accent.
local function XCApplyXCTabAccent(button, active)
    pcall(function()
        local accent = button:FindFirstChild("XCActiveAccent")
        if active then
            if not accent then
                accent = Instance.new("Frame")
                accent.Name = "XCActiveAccent"
                accent.BorderSizePixel = 0
                accent.AnchorPoint = Vector2.new(0, 0.5)
                accent.Position = UDim2.new(0, 0, 0.5, 0)
                accent.Size = UDim2.new(0, 2, 0, 22)
                accent.BackgroundColor3 = Color3.fromRGB(152, 204, 0)
                accent.Parent = button
            end
            accent.Visible = true
        elseif accent then
            accent.Visible = false
        end
    end)
end

-- ==========================================
-- XC CONFIG SYSTEM v2
-- Named profiles, save/load/delete/reset, export/import.
-- Uses executor file APIs when available.
-- ==========================================
local XCConfigSystem = {}
XCConfigSystem.Folder = "XCConfigs"
XCConfigSystem.ActiveName = "Default"

local function cfgFileAPI()
    return type(isfile)=="function" and type(readfile)=="function" and type(writefile)=="function"
end

local function cfgSafeName(name)
    name=tostring(name or "Default"):gsub("[^%w%-%_ ]",""):sub(1,48)
    return name~="" and name or "Default"
end

local function cfgPath(name)
    return XCConfigSystem.Folder.."/"..cfgSafeName(name)..".json"
end

local function cfgJSONEncode(v)
    local ok,res=pcall(function() return game:GetService("HttpService"):JSONEncode(v) end)
    return ok and res or nil
end

local function cfgJSONDecode(v)
    local ok,res=pcall(function() return game:GetService("HttpService"):JSONDecode(v) end)
    return ok and res or nil
end

local function cfgEnsureFolder()
    if type(makefolder)=="function" and type(isfolder)=="function" then
        pcall(function() if not isfolder(XCConfigSystem.Folder) then makefolder(XCConfigSystem.Folder) end end)
    end
end

local function cfgSerialize()
    local out={}
    for k,v in pairs(XCConfig) do
        local t=typeof(v)
        if t=="boolean" or t=="number" or t=="string" then
            out[k]=v
        elseif t=="Color3" then
            out[k]={__type="Color3",r=v.R,g=v.G,b=v.B}
        elseif t=="UDim2" then
            out[k]={__type="UDim2",xs=v.X.Scale,xo=v.X.Offset,ys=v.Y.Scale,yo=v.Y.Offset}
        end
    end
    if streamerSnapshot then
        for key,value in pairs(streamerSnapshot) do out[key]=value end
        out.streamerModeEnabled=false
    end
    return out
end

local function cfgApply(data)
    if type(data)~="table" then return false end
    setXCStreamerMode(false)
    local requestedStreamerMode=data.streamerModeEnabled==true
    for k,v in pairs(data) do
        if XCConfig[k]~=nil then
            pcall(function()
                if type(v)=="table" and v.__type=="Color3" then
                    XCConfig[k]=Color3.new(tonumber(v.r) or 1,tonumber(v.g) or 1,tonumber(v.b) or 1)
                elseif type(v)=="table" and v.__type=="UDim2" then
                    XCConfig[k]=UDim2.new(tonumber(v.xs) or 0,tonumber(v.xo) or 0,tonumber(v.ys) or 0,tonumber(v.yo) or 0)
                else XCConfig[k]=v end
            end)
        end
    end
    setXCStreamerMode(requestedStreamerMode)
    return true
end

function XCConfigSystem.Save(name)
    if not cfgFileAPI() then return false,"File API unavailable" end
    name=cfgSafeName(name or XCConfigSystem.ActiveName)
    cfgEnsureFolder()
    local raw=cfgJSONEncode({schema=2,product="XC",name=name,savedAt=os.time(),settings=cfgSerialize()})
    if not raw then return false,"JSON encode failed" end
    local ok,err=pcall(function() writefile(cfgPath(name),raw) end)
    if ok then XCConfigSystem.ActiveName=name end
    return ok,ok and "Saved" or tostring(err)
end

function XCConfigSystem.Load(name)
    if not cfgFileAPI() then return false,"File API unavailable" end
    name=cfgSafeName(name or XCConfigSystem.ActiveName)
    local path=cfgPath(name)
    if not isfile(path) then return false,"Config not found" end
    local ok,raw=pcall(readfile,path)
    if not ok then return false,"Read failed" end
    local data=cfgJSONDecode(raw)
    if type(data)~="table" or type(data.settings)~="table" then return false,"Invalid config" end
    cfgApply(data.settings)
    XCConfigSystem.ActiveName=name
    return true,"Loaded"
end

function XCConfigSystem.Delete(name)
    if type(delfile)~="function" then return false,"Delete API unavailable" end
    name=cfgSafeName(name or XCConfigSystem.ActiveName)
    local path=cfgPath(name)
    if not isfile(path) then return false,"Config not found" end
    local ok,err=pcall(delfile,path)
    return ok,ok and "Deleted" or tostring(err)
end

function XCConfigSystem.List()
    local out={}
    if type(listfiles)~="function" then return out end
    cfgEnsureFolder()
    local ok,files=pcall(listfiles,XCConfigSystem.Folder)
    if ok and type(files)=="table" then
        for _,path in ipairs(files) do
            local n=tostring(path):match("([^/\\]+)%.json$")
            if n then table.insert(out,n) end
        end
    end
    table.sort(out)
    return out
end

function XCConfigSystem.Reset()
    setXCStreamerMode(false)
    for k,v in pairs(XCConfigDefaults or {}) do pcall(function() XCConfig[k]=v end) end
    return true,"Reset"
end

function XCConfigSystem.Export()
    return cfgJSONEncode({schema=2,product="XC",name=XCConfigSystem.ActiveName,settings=cfgSerialize()})
end

function XCConfigSystem.Import(raw,name)
    local data=cfgJSONDecode(raw)
    if type(data)~="table" or type(data.settings)~="table" then return false,"Invalid import" end
    cfgApply(data.settings)
    XCConfigSystem.ActiveName=cfgSafeName(name or data.name or "Imported")
    return true,"Imported"
end

if type(getgenv) == "function" then
    pcall(function() getgenv().XCConfigSystem = XCConfigSystem end)
end
