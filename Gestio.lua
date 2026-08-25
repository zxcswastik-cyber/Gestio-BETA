-- ==============================================================================
-- [Gestio UI - Blox Strike Ultimate Mobile Engine (Full Suite 2600+ Lines)]
-- Version: 5.4.3 Enterprise Production Edition (Delta Native Isolation)
-- Target Game: Blox Strike (Roblox Mobile)
-- ==============================================================================

local function initGestioSuite()
    local successCleanup, errCleanup = pcall(function()
        if rawget(_G, "GestioRunning") and type(rawget(_G, "GestioRunning")) == "function" then
            rawget(_G, "GestioRunning")()
        end
    end)

    -- ==========================================
    -- SYSTEM SERVICES IMPORT
    -- ==========================================
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local VirtualUser = game:GetService("VirtualUser")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local Stats = game:GetService("Stats")
    local Debris = game:GetService("Debris")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")

    -- ==========================================
    -- CLIENT ENVIRONMENT VALIDATION
    -- ==========================================
    local player = Players.LocalPlayer
    if not player then
        local plrs = Players:GetPlayers()
        player = plrs[1]
    end

    local camera = Workspace.CurrentCamera
    if not camera then
        camera = Workspace:FindFirstChildOfClass("Camera")
    end

    local defaultCameraFOV = 70
    if camera then
        pcall(function()
            defaultCameraFOV = camera.FieldOfView
        end)
    end

    local function getSafeGui()
        if type(gethui) == "function" then
            local success, res = pcall(gethui)
            if success and res then return res end
        end

        if player and player:FindFirstChild("PlayerGui") then
            return player.PlayerGui
        end

        local success, res = pcall(function() return CoreGui end)
        if success and res then return res end

        if player then
            return player:WaitForChild("PlayerGui", 2) or CoreGui
        end

        return CoreGui
    end

    local targetGui = getSafeGui()
    local connections = {}
    local activeEspHolders = {}
    local screenEspCache = {}
    local activeTracersCache = {}
    local activeHeadDotsCache = {}
    local themeUpdateListeners = {}

    local defaultPos = {
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

    local function applyCurrentTheme()
        for _, callback in ipairs(themeUpdateListeners) do
            pcall(callback, currentTheme)
        end
    end

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
    -- RECOIL CONTROL SYSTEM (RCS) VARIABLES
    -- ==========================================
    local rcsEnabled = false
    local rcsStrength = 75
    local rcsPitchFactor = 1.0
    local rcsYawFactor = 1.0
    local rcsSmoothness = 0.2
    local rcsHorizontalComp = true
    local rcsBurstOnly = false
    local rcsRandomize = true

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
    -- MOVEMENT, BHOP, SLIDE & AUTO-STRAFE
    -- ==========================================
    local bunnyHopEnabled = false
    local bhopAutoJump = false
    local bhopAirStrafe = true
    local bhopSpeedBoost = 1.35
    local bhopJumpPower = 52
    local isMobileJumpHeld = false
    local lastMoveDirection = Vector3.zero

    local autoStrafeEnabled = false
    local strafeStrength = 1.0

    local slideEnabled = false
    local isSliding = false
    local slideSpeedBoost = 1.8
    local slideFriction = 0.94
    local slideMinSpeed = 16
    local currentSlideVel = Vector3.zero
    local defaultHipHeight = 2.0

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

    -- ==========================================
    -- INTEGRATED GRENADE DANGER ENGINE VARIABLES
    -- ==========================================
    local grenadeDangerEnabled = false
    local grenadeDangerMaxDist = 500
    local grenadeDangerShowDist = true
    local grenadeDangerShowRadius = true

    local GrenadeDangerConfig = {
        Molotov = { Label = "MOLOTOV", Radius = 8, Color = Color3.fromRGB(255, 70, 40), Danger = true },
        Incendiary = { Label = "INCENDIARY", Radius = 8, Color = Color3.fromRGB(255, 90, 35), Danger = true },
        HEGrenade = { Label = "HE", Radius = 6, Color = Color3.fromRGB(235, 60, 60), Danger = true },
        Flash = { Label = "FLASH", Radius = 5, Color = Color3.fromRGB(255, 255, 180), Danger = true },
        Smoke = { Label = "SMOKE", Radius = 6, Color = Color3.fromRGB(160, 160, 170), Danger = false }
    }

    local dangerGrenadeObjects = {}

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
    -- ENVIRONMENT, LIGHTING & FOV CHANGER
    -- ==========================================
    local customFovEnabled = false
    local customFovValue = 95

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
        Brightness = 2,
        ClockTime = 14,
        GlobalShadows = true,
        Ambient = Color3.fromRGB(128, 128, 128),
        OutdoorAmbient = Color3.fromRGB(128, 128, 128),
        FogEnd = 100000,
        FogColor = Color3.fromRGB(192, 192, 192)
    }

    pcall(function()
        defaultLighting.Brightness = Lighting.Brightness
        defaultLighting.ClockTime = Lighting.ClockTime
        defaultLighting.GlobalShadows = Lighting.GlobalShadows
        defaultLighting.Ambient = Lighting.Ambient
        defaultLighting.OutdoorAmbient = Lighting.OutdoorAmbient
        defaultLighting.FogEnd = Lighting.FogEnd
        defaultLighting.FogColor = Lighting.FogColor
    end)

    -- ==========================================
    -- KROATON INFO HUD & ANTI-AFK VARIABLES
    -- ==========================================
    local infoHudEnabled = false
    local infoHudShowFps = true
    local infoHudShowPing = true
    local infoHudShowSpeed = true
    local infoHudShowFov = true
    local antiAfkEnabled = true

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

    local dangerOverlayFolder = nil
    local jumpCircleFolder = nil

    local function getOrCreateDangerFolder()
        if dangerOverlayFolder and dangerOverlayFolder.Parent then return dangerOverlayFolder end
        pcall(function()
            dangerOverlayFolder = Workspace:FindFirstChild("Gestio_GrenadeDangerWorld")
            if not dangerOverlayFolder then
                dangerOverlayFolder = Instance.new("Folder")
                dangerOverlayFolder.Name = "Gestio_GrenadeDangerWorld"
                dangerOverlayFolder.Parent = Workspace
            end
        end)
        return dangerOverlayFolder
    end

    local function getOrCreateJumpFolder()
        if jumpCircleFolder and jumpCircleFolder.Parent then return jumpCircleFolder end
        pcall(function()
            jumpCircleFolder = Workspace:FindFirstChild("Gestio_JumpCircleWorld")
            if not jumpCircleFolder then
                jumpCircleFolder = Instance.new("Folder")
                jumpCircleFolder.Name = "Gestio_JumpCircleWorld"
                jumpCircleFolder.Parent = Workspace
            end
        end)
        return jumpCircleFolder
    end

    -- ==========================================
    -- KROATON HUD COMPONENT INSTANTIATION
    -- ==========================================
    local hudContainer = Instance.new("Frame", mainContainer)
    hudContainer.Name = "KroatonHUD_Frame"
    hudContainer.AnchorPoint = Vector2.new(1, 0)
    hudContainer.Position = UDim2.new(1, -14, 0, 45)
    hudContainer.Size = UDim2.new(0, 160, 0, 105)
    hudContainer.BackgroundColor3 = Color3.fromRGB(18, 19, 22)
    hudContainer.BackgroundTransparency = 0.15
    hudContainer.BorderSizePixel = 0
    hudContainer.Visible = false
    hudContainer.ZIndex = 50

    Instance.new("UICorner", hudContainer).CornerRadius = UDim.new(0, 7)
    local hudStroke = Instance.new("UIStroke", hudContainer)
    hudStroke.Color = currentTheme.Accent
    hudStroke.Thickness = 1
    hudStroke.Transparency = 0.2

    local hudTitle = Instance.new("TextLabel", hudContainer)
    hudTitle.Size = UDim2.new(1, -16, 0, 20)
    hudTitle.Position = UDim2.new(0, 8, 0, 5)
    hudTitle.BackgroundTransparency = 1
    hudTitle.Font = Enum.Font.GothamBold
    hudTitle.TextSize = 11
    hudTitle.TextColor3 = currentTheme.Accent
    hudTitle.TextXAlignment = Enum.TextXAlignment.Left
    hudTitle.Text = "KROATON HUD"
    hudTitle.ZIndex = 51

    local hudFpsLabel = Instance.new("TextLabel", hudContainer)
    hudFpsLabel.Size = UDim2.new(1, -16, 0, 16)
    hudFpsLabel.Position = UDim2.new(0, 8, 0, 26)
    hudFpsLabel.BackgroundTransparency = 1
    hudFpsLabel.Font = Enum.Font.Gotham
    hudFpsLabel.TextSize = 9.5
    hudFpsLabel.TextColor3 = Color3.fromRGB(225, 228, 232)
    hudFpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    hudFpsLabel.Text = "FPS: 60"
    hudFpsLabel.ZIndex = 51

    local hudPingLabel = Instance.new("TextLabel", hudContainer)
    hudPingLabel.Size = UDim2.new(1, -16, 0, 16)
    hudPingLabel.Position = UDim2.new(0, 8, 0, 44)
    hudPingLabel.BackgroundTransparency = 1
    hudPingLabel.Font = Enum.Font.Gotham
    hudPingLabel.TextSize = 9.5
    hudPingLabel.TextColor3 = Color3.fromRGB(225, 228, 232)
    hudPingLabel.TextXAlignment = Enum.TextXAlignment.Left
    hudPingLabel.Text = "PING: 0 ms"
    hudPingLabel.ZIndex = 51

    local hudSpeedLabel = Instance.new("TextLabel", hudContainer)
    hudSpeedLabel.Size = UDim2.new(1, -16, 0, 16)
    hudSpeedLabel.Position = UDim2.new(0, 8, 0, 62)
    hudSpeedLabel.BackgroundTransparency = 1
    hudSpeedLabel.Font = Enum.Font.Gotham
    hudSpeedLabel.TextSize = 9.5
    hudSpeedLabel.TextColor3 = Color3.fromRGB(225, 228, 232)
    hudSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    hudSpeedLabel.Text = "SPEED: 0"
    hudSpeedLabel.ZIndex = 51

    local hudFovLabel = Instance.new("TextLabel", hudContainer)
    hudFovLabel.Size = UDim2.new(1, -16, 0, 16)
    hudFovLabel.Position = UDim2.new(0, 8, 0, 80)
    hudFovLabel.BackgroundTransparency = 1
    hudFovLabel.Font = Enum.Font.Gotham
    hudFovLabel.TextSize = 9.5
    hudFovLabel.TextColor3 = Color3.fromRGB(225, 228, 232)
    hudFovLabel.TextXAlignment = Enum.TextXAlignment.Left
    hudFovLabel.Text = "FOV: 70"
    hudFovLabel.ZIndex = 51

    table.insert(themeUpdateListeners, function(theme)
        hudStroke.Color = theme.Accent
        hudTitle.TextColor3 = theme.Accent
    end)

    -- ==========================================
    -- LIGHTING FUNCTIONS
    -- ==========================================
    local function applyNightPreset(presetName)
        local cfg = nightPresets[presetName]
        if not cfg then return end
        nightPreset = presetName
        nightClockTime = cfg.ClockTime
        nightBrightness = cfg.Brightness
        nightOutdoorAmbient = cfg.OutdoorAmbient

        if nightModeEnabled then
            pcall(function()
                Lighting.ClockTime = cfg.ClockTime
                Lighting.Brightness = cfg.Brightness
                Lighting.OutdoorAmbient = cfg.OutdoorAmbient
                Lighting.Ambient = cfg.Ambient
                Lighting.GlobalShadows = true
                if not removeFogEnabled then
                    Lighting.FogColor = cfg.FogColor
                end
            end)
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
        if camera then
            pcall(function() camera.FieldOfView = defaultCameraFOV end)
        end
    end

    -- ==========================================
    -- GRENADE DANGER CORE FUNCTIONS
    -- ==========================================
    local function getDangerObjectRoot(object)
        if not object then return nil end
        if object:IsA("BasePart") then
            return object
        end
        if object:IsA("Model") then
            return object.PrimaryPart
                or object:FindFirstChild("HumanoidRootPart")
                or object:FindFirstChildWhichIsA("BasePart")
        end
        return nil
    end

    local function getDangerGrenadeType(object)
        if not object or not object.Name then return nil end
        local name = tostring(object.Name):lower()
        for grenadeName, settings in pairs(GrenadeDangerConfig) do
            if name:find(grenadeName:lower(), 1, true) then
                return settings
            end
        end
        if name:find("grenade") or name:find("he") then
            return GrenadeDangerConfig.HEGrenade
        elseif name:find("molotov") or name:find("fire") then
            return GrenadeDangerConfig.Molotov
        elseif name:find("incendiary") then
            return GrenadeDangerConfig.Incendiary
        elseif name:find("smoke") then
            return GrenadeDangerConfig.Smoke
        elseif name:find("flash") then
            return GrenadeDangerConfig.Flash
        end
        return nil
    end

    local function removeDangerIndicator(object)
        local data = dangerGrenadeObjects[object]
        if not data then return end
        if data.billboard then
            pcall(function() data.billboard:Destroy() end)
        end
        if data.radius then
            pcall(function() data.radius:Destroy() end)
        end
        dangerGrenadeObjects[object] = nil
    end

    local function createDangerIndicator(object)
        if not object then return end
        if object.Name == "GestioDangerRadius" or object.Name == "GestioGrenadeIndicator" or object:IsDescendantOf(mainContainer) then
            return
        end

        local root = getDangerObjectRoot(object)
        if not root then return end
        local settings = getDangerGrenadeType(object)
        if not settings then return end
        if dangerGrenadeObjects[object] then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "GestioGrenadeIndicator"
        billboard.Adornee = root
        billboard.Size = UDim2.fromOffset(135, 36)
        billboard.StudsOffset = Vector3.new(0, 2.4, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = grenadeDangerMaxDist
        billboard.Enabled = grenadeDangerEnabled
        billboard.Parent = root

        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = Color3.fromRGB(18, 19, 22)
        frame.BackgroundTransparency = 0.15
        frame.BorderSizePixel = 0
        frame.Size = UDim2.fromScale(1, 1)
        frame.Parent = billboard

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = settings.Color
        stroke.Thickness = 1.2
        stroke.Transparency = 0.1
        stroke.Parent = frame

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -8, 0.55, 0)
        label.Position = UDim2.fromOffset(4, 2)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 10
        label.TextColor3 = settings.Color
        label.Text = settings.Label
        label.Parent = frame

        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Size = UDim2.new(1, -8, 0.45, 0)
        distanceLabel.Position = UDim2.new(0, 4, 0.52, 0)
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.TextSize = 8.5
        distanceLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
        distanceLabel.Text = "0m"
        distanceLabel.Parent = frame

        local radiusPart = nil
        if settings.Radius > 0 then
            local parentFolder = getOrCreateDangerFolder()
            radiusPart = Instance.new("Part")
            radiusPart.Name = "GestioDangerRadius"
            radiusPart.Shape = Enum.PartType.Cylinder
            radiusPart.Anchored = true
            radiusPart.CanCollide = false
            radiusPart.CanTouch = false
            radiusPart.CanQuery = false
            radiusPart.CastShadow = false
            radiusPart.Material = Enum.Material.Neon
            radiusPart.Transparency = (grenadeDangerEnabled and grenadeDangerShowRadius) and 0.88 or 1
            radiusPart.Color = settings.Color
            radiusPart.Size = Vector3.new(0.08, settings.Radius * 2, settings.Radius * 2)
            radiusPart.Parent = parentFolder
        end

        dangerGrenadeObjects[object] = {
            root = root,
            settings = settings,
            billboard = billboard,
            distanceLabel = distanceLabel,
            radius = radiusPart
        }
    end

    local function scanGrenadeObjects()
        task.spawn(function()
            pcall(function()
                for _, object in ipairs(Workspace:GetChildren()) do
                    if getDangerGrenadeType(object) then
                        createDangerIndicator(object)
                    end
                end
            end)
        end)
    end

    -- ==========================================
    -- JUMP CIRCLE RENDER ENGINE
    -- ==========================================
    local function buildJumpRing(segmentCount, radius, thickness)
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

    local function updateJumpRingLayout(segments, centerPosition, radius)
        if not segments then return end
        local n = #segments
        for i, seg in ipairs(segments) do
            if seg.Part and seg.Part.Parent then
                local angle = seg.Angle
                local nextAngle = angle + (math.pi * 2 / n)
                local p1 = centerPosition + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                local p2 = centerPosition + Vector3.new(math.cos(nextAngle) * radius, 0, math.sin(nextAngle) * radius)
                local mid = (p1 + p2) * 0.5

                seg.Part.CFrame = CFrame.lookAt(mid, p2)
            end
        end
    end

    local function spawnJumpRipple(position)
        if not jumpCircleEnabled then return end
        task.spawn(function()
            local parentFolder = getOrCreateJumpFolder()
            local rippleFolder, segments = buildJumpRing(jumpCircleSegmentCount, jumpCircleRadius, 0.3)
            rippleFolder.Parent = parentFolder

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
                    rippleConn:Disconnect()
                    rippleFolder:Destroy()
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

    local function initJumpCircleForCharacter(char)
        clearActiveJumpCircle()
        if not jumpCircleEnabled or not char then return end

        local hrp = char:WaitForChild("HumanoidRootPart", 4)
        local hum = char:WaitForChild("Humanoid", 4)
        if not hrp or not hum then return end

        local parentFolder = getOrCreateJumpFolder()
        local container, segments = buildJumpRing(jumpCircleSegmentCount, jumpCircleRadius, 0.25)
        container.Parent = parentFolder

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
            if not jumpCircleEnabled or not activeJumpCircleData or activeJumpCircleData ~= circleData then
                return
            end
            if not hrp or not hrp.Parent or not hum or not hum.Parent or hum.Health <= 0 then
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
                    if seg.Part and seg.Part.Parent then
                        local ratio = ((i / n) + spin) % 1
                        local wave = (math.sin(ratio * math.pi * 2) + 1) * 0.5
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

    if player then
        table.insert(connections, player.CharacterAdded:Connect(initJumpCircleForCharacter))
        table.insert(connections, player.CharacterRemoving:Connect(clearActiveJumpCircle))
        if player.Character then
            task.spawn(function()
                initJumpCircleForCharacter(player.Character)
            end)
        end
    end

    -- ==========================================
    -- HOOK DESCENDANTS FOR DANGER ESP
    -- ==========================================
    table.insert(connections, Workspace.ChildAdded:Connect(function(object)
        task.spawn(function()
            task.wait(0.05)
            pcall(function() createDangerIndicator(object) end)
        end)
    end))

    table.insert(connections, Workspace.ChildRemoved:Connect(function(object)
        pcall(function() removeDangerIndicator(object) end)
    end))

    scanGrenadeObjects()

    -- ==========================================
    -- TARGET SELECTION & AIMBOT MATHEMATICS
    -- ==========================================
    local visRayParams = RaycastParams.new()
    visRayParams.FilterType = Enum.RaycastFilterType.Exclude
    visRayParams.IgnoreWater = true

    local function isTargetVisible(originPos, targetPart, targetChar)
        if not visibleCheck then return true end
        local myChar = player and player.Character
        visRayParams.FilterDescendantsInstances = {myChar, camera}
        local dir = targetPart.Position - originPos
        local hit = Workspace:Raycast(originPos, dir, visRayParams)
        if hit and (hit.Instance:IsDescendantOf(targetChar) or hit.Instance == targetPart) then
            return true
        end
        return false
    end

    local function getClosestTarget()
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
                        if predictionEnabled and targetPart.AssemblyLinearVelocity then
                            calcPos = calcPos + (targetPart.AssemblyLinearVelocity * predictionFactor)
                        end
                        local screenPos, onScreen = camera:WorldToViewportPoint(calcPos)
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
    -- AIMLOCK & INPUT CAPTURE BINDINGS
    -- ==========================================
    table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
            isAiming = true
        end
    end))

    table.insert(connections, UserInputService.InputEnded:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
            isAiming = false
        end
    end))

    -- ==========================================
    -- TRIGGERBOT PROCESSING LOGIC
    -- ==========================================
    local triggerRayParams = RaycastParams.new()
    triggerRayParams.FilterType = Enum.RaycastFilterType.Exclude
    triggerRayParams.IgnoreWater = true

    local function runMobileTriggerbot()
        if not triggerbotEnabled or not camera then return end
        local now = tick()
        if (now - lastTriggerTick) < triggerbotDelay then return end

        local vp = camera.ViewportSize
        local ray = camera:ViewportPointToRay(vp.X * 0.5, vp.Y * 0.5)
        local myChar = player and player.Character
        triggerRayParams.FilterDescendantsInstances = {myChar, camera}

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
                            local equippedTool = myChar and myChar:FindFirstChildOfClass("Tool")
                            if equippedTool then
                                equippedTool:Activate()
                            elseif VirtualInputManager then
                                VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, true, game, 0)
                                task.wait(0.01)
                                VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, false, game, 0)
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
    local function getOrCreateScreenEsp(plr)
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
    local function renderTacticalOverlay()
        if not camera then return end
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

                        local sideColor = currentTheme.Enemy_Accent

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

                            esp.Corners[1].H.BackgroundColor3 = sideColor
                            esp.Corners[1].H.Size = UDim2.new(0, lengthX, 0, thick)
                            esp.Corners[1].H.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                            esp.Corners[1].V.BackgroundColor3 = sideColor
                            esp.Corners[1].V.Size = UDim2.new(0, thick, 0, lengthY)
                            esp.Corners[1].V.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                            esp.Corners[1].H.Visible = true
                            esp.Corners[1].V.Visible = true

                            esp.Corners[2].H.BackgroundColor3 = sideColor
                            esp.Corners[2].H.Size = UDim2.new(0, lengthX, 0, thick)
                            esp.Corners[2].H.Position = UDim2.new(0, boxPosX + boxWidth - lengthX, 0, boxPosY)
                            esp.Corners[2].V.BackgroundColor3 = sideColor
                            esp.Corners[2].V.Size = UDim2.new(0, thick, 0, lengthY)
                            esp.Corners[2].V.Position = UDim2.new(0, boxPosX + boxWidth - thick, 0, boxPosY)
                            esp.Corners[2].H.Visible = true
                            esp.Corners[2].V.Visible = true

                            esp.Corners[3].H.BackgroundColor3 = sideColor
                            esp.Corners[3].H.Size = UDim2.new(0, lengthX, 0, thick)
                            esp.Corners[3].H.Position = UDim2.new(0, boxPosX, 0, boxPosY + boxHeight - thick)
                            esp.Corners[3].V.BackgroundColor3 = sideColor
                            esp.Corners[3].V.Size = UDim2.new(0, thick, 0, lengthY)
                            esp.Corners[3].V.Position = UDim2.new(0, boxPosX, 0, boxPosY + boxHeight - lengthY)
                            esp.Corners[3].H.Visible = true
                            esp.Corners[3].V.Visible = true

                            esp.Corners[4].H.BackgroundColor3 = sideColor
                            esp.Corners[4].H.Size = UDim2.new(0, lengthX, 0, thick)
                            esp.Corners[4].H.Position = UDim2.new(0, boxPosX + boxWidth - lengthX, 0, boxPosY + boxHeight - thick)
                            esp.Corners[4].V.BackgroundColor3 = sideColor
                            esp.Corners[4].V.Size = UDim2.new(0, thick, 0, lengthY)
                            esp.Corners[4].V.Position = UDim2.new(0, boxPosX + boxWidth - thick, 0, boxPosY + boxHeight - lengthY)
                            esp.Corners[4].H.Visible = true
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
    local function attachEspToPlayer(plr)
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
        local charAddedConn = plr.CharacterAdded:Connect(setupCharacter)
        table.insert(connections, charAddedConn)
    end

    for _, v in pairs(Players:GetPlayers()) do attachEspToPlayer(v) end
    table.insert(connections, Players.PlayerAdded:Connect(attachEspToPlayer))

    -- ==========================================
    -- MAIN ENGINE RENDER LOOP
    -- ==========================================
    table.insert(connections, RunService.RenderStepped:Connect(function(dt)
        if not camera then camera = Workspace.CurrentCamera return end
        local localPos = camera.CFrame.Position

        fpsCounter = fpsCounter + 1
        local nowTick = tick()
        if nowTick - lastFpsUpdate >= 0.5 then
            calculatedCurrentFps = math.floor(fpsCounter / (nowTick - lastFpsUpdate))
            local pingVal = 0
            pcall(function()
                local serverStats = Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem")
                if serverStats and serverStats:FindFirstChild("Data Ping") then
                    pingVal = math.floor(serverStats["Data Ping"]:GetValue())
                end
            end)
            wmMetrics.Text = string.format("FPS: %d | PING: %dms", calculatedCurrentFps, pingVal)
            fpsCounter = 0
            lastFpsUpdate = nowTick
        end

        if customFovEnabled and camera then
            camera.FieldOfView = customFovValue
        end

        if infoHudEnabled then
            hudContainer.Visible = true
            hudFpsLabel.Visible = infoHudShowFps
            hudPingLabel.Visible = infoHudShowPing
            hudSpeedLabel.Visible = infoHudShowSpeed
            hudFovLabel.Visible = infoHudShowFov

            if infoHudShowFps then
                hudFpsLabel.Text = "FPS:       " .. tostring(calculatedCurrentFps)
            end
            if infoHudShowPing then
                local currentPing = 0
                pcall(function()
                    local net = Stats:FindFirstChild("Network")
                    local item = net and net:FindFirstChild("ServerStatsItem")
                    local p = item and item:FindFirstChild("Data Ping")
                    if p then currentPing = math.floor(p:GetValue()) end
                end)
                hudPingLabel.Text = "PING:      " .. tostring(currentPing) .. " ms"
            end
            if infoHudShowSpeed then
                local myChar = player and player.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHrp then
                    local vel = myHrp.AssemblyLinearVelocity
                    local horiz = Vector3.new(vel.X, 0, vel.Z).Magnitude
                    hudSpeedLabel.Text = "SPEED:     " .. tostring(math.floor(horiz))
                else
                    hudSpeedLabel.Text = "SPEED:     0"
                end
            end
            if infoHudShowFov and camera then
                hudFovLabel.Text = "FOV:       " .. tostring(math.floor(camera.FieldOfView))
            end
        else
            hudContainer.Visible = false
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
            local randPitch = rcsRandomize and (1 + (math.random(-5, 5) / 100)) or 1
            local randYaw = rcsRandomize and ((math.random(-5, 5) / 100)) or 0
            local pitchAngle = rcsComp * rcsPitchFactor * randPitch
            local yawAngle = rcsHorizontalComp and (rcsComp * 0.35 * rcsYawFactor * randYaw) or 0

            if rcsSmoothness > 0 then
                camera.CFrame = camera.CFrame:Lerp(camera.CFrame * CFrame.Angles(pitchAngle, yawAngle, 0), math.clamp(1 - rcsSmoothness, 0.1, 1))
            else
                camera.CFrame = camera.CFrame * CFrame.Angles(pitchAngle, yawAngle, 0)
            end
        end

        local shouldAimbotLock = aimbotEnabled and (snapAimMode or isAiming)
        if shouldAimbotLock then
            if not lockedTarget or not isEntityAlive(lockedTarget.Char, lockedTarget.Hum) then
                lockedTarget = getClosestTarget()
            end
            if lockedTarget and lockedTarget.Position then
                local targetLook = CFrame.lookAt(camera.CFrame.Position, lockedTarget.Position)
                if snapAimMode or aimbotSmoothness <= 0.01 then
                    camera.CFrame = targetLook
                else
                    camera.CFrame = camera.CFrame:Lerp(targetLook, math.clamp((1 - aimbotSmoothness) * (aimbotSpeed / 10) * (dt * 60) * aimSensitivity, 0.1, 1))
                end
            end
        else
            lockedTarget = nil
        end

        runMobileTriggerbot()
        renderTacticalOverlay()

        if grenadeDangerEnabled then
            local myChar = player and player.Character
            local localRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if localRoot then
                for object, data in pairs(dangerGrenadeObjects) do
                    if not object.Parent or not data.root.Parent then
                        removeDangerIndicator(object)
                    else
                        local dist = (localRoot.Position - data.root.Position).Magnitude
                        if dist <= grenadeDangerMaxDist then
                            data.billboard.Enabled = true
                            if grenadeDangerShowDist then
                                data.distanceLabel.Text = string.format("%d studs", math.floor(dist))
                            else
                                data.distanceLabel.Text = ""
                            end

                            if data.radius and data.radius.Parent then
                                data.radius.Transparency = grenadeDangerShowRadius and 0.88 or 1
                                data.radius.CFrame = CFrame.new(data.root.Position) * CFrame.Angles(0, 0, math.rad(90))
                            end

                            if data.settings.Danger then
                                local alpha = math.clamp(1 - dist / 30, 0, 1)
                                data.billboard.Size = UDim2.fromOffset(135 + alpha * 18, 36 + alpha * 5)
                            end
                        else
                            data.billboard.Enabled = false
                            if data.radius and data.radius.Parent then
                                data.radius.Transparency = 1
                            end
                        end
                    end
                end
            end
        else
            for _, data in pairs(dangerGrenadeObjects) do
                data.billboard.Enabled = false
                if data.radius and data.radius.Parent then
                    data.radius.Transparency = 1
                end
            end
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
                local activeAccent = currentTheme.Enemy_Accent
                local activeHighlight = currentTheme.Enemy_Fill

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
            pcall(function()
                Lighting.Brightness = nightBrightness or cfg.Brightness
                Lighting.ClockTime = nightClockTime or cfg.ClockTime
                Lighting.GlobalShadows = true
                Lighting.OutdoorAmbient = nightOutdoorAmbient or cfg.OutdoorAmbient
                Lighting.Ambient = cfg.Ambient
            end)
        end

        if removeFogEnabled then
            pcall(function() Lighting.FogEnd = 100000 end)
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
        if not antiAimEnabled then return end

        local char = player and player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not hrp or not hum or hum.Health <= 0 then return end

        currentSpinAngle = (currentSpinAngle + (spinSpeed * dt * 60)) % 360
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(currentSpinAngle), 0)
    end))

    -- ==========================================
    -- RAYCAST GROUND CHECK
    -- ==========================================
    local groundRayParams = RaycastParams.new()
    groundRayParams.FilterType = Enum.RaycastFilterType.Exclude
    groundRayParams.IgnoreWater = true

    local function isPlayerGrounded(char, hrp)
        groundRayParams.FilterDescendantsInstances = {char, camera}
        local origin = hrp.Position
        local direction = Vector3.new(0, -3.2, 0)
        local hit = Workspace:Raycast(origin, direction, groundRayParams)
        return hit ~= nil
    end

    -- ==========================================
    -- MOBILE INPUT TOUCH HOOK
    -- ==========================================
    local jumpHookConnected = false
    local function hookMobileJumpButton()
        if jumpHookConnected then return end
        task.spawn(function()
            if not player then return end
            local pGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
            if not pGui then return end
            local touchGui = pGui:WaitForChild("TouchGui", 5)
            if not touchGui then return end
            local controlFrame = touchGui:WaitForChild("TouchControlFrame", 5)
            if not controlFrame then return end
            local jumpBtn = controlFrame:WaitForChild("JumpButton", 5)
            if not jumpBtn then return end

            jumpHookConnected = true
            local conn1 = jumpBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isMobileJumpHeld = true
                end
            end)
            table.insert(connections, conn1)

            local conn2 = jumpBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isMobileJumpHeld = false
                end
            end)
            table.insert(connections, conn2)
        end)
    end

    hookMobileJumpButton()

    local jumpReqConn = UserInputService.JumpRequest:Connect(function()
        isMobileJumpHeld = true
    end)
    table.insert(connections, jumpReqConn)

    local inpBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.Space then
            isMobileJumpHeld = true
        end

        if slideEnabled and (input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.LeftControl) then
            local char = player and player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and isEntityAlive(char, hum) and isPlayerGrounded(char, hrp) then
                local moveDir = hum.MoveDirection.Magnitude > 0.1 and hum.MoveDirection or hrp.CFrame.LookVector
                currentSlideVel = moveDir * (16 * slideSpeedBoost)
                isSliding = true
                hum.HipHeight = defaultHipHeight * 0.4
            end
        end
    end)
    table.insert(connections, inpBeganConn)

    local inpEndedConn = UserInputService.InputEnded:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.Space then
            isMobileJumpHeld = false
        end
        if input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.LeftControl then
            isSliding = false
            local char = player and player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.HipHeight = defaultHipHeight
            end
        end
    end)
    table.insert(connections, inpEndedConn)

    -- ==========================================
    -- PHYSICS & KINEMATICS HEARTBEAT
    -- ==========================================
    table.insert(connections, RunService.Heartbeat:Connect(function(dt)
        local char = player and player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or not isEntityAlive(char, hum) then return end

        local currentMove = hum.MoveDirection
        if currentMove.Magnitude > 0.05 then
            lastMoveDirection = currentMove
        end

        if bunnyHopEnabled then
            local grounded = isPlayerGrounded(char, hrp) or hum.FloorMaterial ~= Enum.Material.Air
            local shouldJump = bhopAutoJump or isMobileJumpHeld or hum.Jump

            if grounded and shouldJump then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                hrp.AssemblyLinearVelocity = Vector3.new(
                    hrp.AssemblyLinearVelocity.X,
                    bhopJumpPower,
                    hrp.AssemblyLinearVelocity.Z
                )
            elseif not grounded and bhopAirStrafe and currentMove.Magnitude > 0.05 then
                local targetSpeed = 16 * bhopSpeedBoost
                local targetVel = currentMove * targetSpeed
                hrp.AssemblyLinearVelocity = Vector3.new(
                    targetVel.X,
                    hrp.AssemblyLinearVelocity.Y,
                    targetVel.Z
                )
            end
        end

        if autoStrafeEnabled and not isPlayerGrounded(char, hrp) then
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
                if currentMove.Magnitude > 0 and camera then
                    local camLook = camera.CFrame.LookVector * Vector3.new(1, 0, 1)
                    local camRight = camera.CFrame.RightVector * Vector3.new(1, 0, 1)

                    local fwd = camLook.Magnitude > 0 and camLook.Unit or Vector3.zero
                    local rgt = camRight.Magnitude > 0 and camRight.Unit or Vector3.zero

                    local fAmount = currentMove:Dot(fwd)
                    local rAmount = currentMove:Dot(rgt)
                    local finalDir = fwd * fAmount + rgt * rAmount

                    if finalDir.Magnitude > 0 then
                        hum:Move(finalDir.Unit * strafeStrength, false)
                    end
                end
            end
        end

        if slideEnabled and isSliding then
            local grounded = isPlayerGrounded(char, hrp)
            if grounded and currentSlideVel.Magnitude > slideMinSpeed then
                currentSlideVel = currentSlideVel * slideFriction
                hrp.AssemblyLinearVelocity = Vector3.new(
                    currentSlideVel.X,
                    hrp.AssemblyLinearVelocity.Y,
                    currentSlideVel.Z
                )
            else
                isSliding = false
                hum.HipHeight = defaultHipHeight
            end
        end

        if speedEnabled and hum.MoveDirection.Magnitude > 0 and not isSliding then
            local targetVel = hum.MoveDirection * (16 * walkMultiplier)
            hrp.AssemblyLinearVelocity = Vector3.new(targetVel.X, targetVel.Y, targetVel.Z)
        end

        if flightEnabled and camera then
            local camLook = camera.CFrame.LookVector
            hrp.AssemblyLinearVelocity = camLook * flightSpeed
        end
    end))

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
    openBtn.Position = defaultPos.OpenBtn
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

    table.insert(themeUpdateListeners, function(theme)
        openBtn.BackgroundColor3 = theme.Background
        openBtn.TextColor3 = theme.Accent
        openStroke.Color = theme.Border
    end)

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

    local function toggleMenu() 
        masterFrame.Visible = not masterFrame.Visible 
    end

    local btnDrag, btnStartPos, btnInputStart = false, nil, nil
    local dragBeganConn = openBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDrag = true
            btnStartPos = openBtn.Position
            btnInputStart = input.Position
        end
    end)
    table.insert(connections, dragBeganConn)

    local dragChangeConn = UserInputService.InputChanged:Connect(function(input)
        if btnDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - btnInputStart
            local newPos = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
            openBtn.Position = newPos
        end
    end)
    table.insert(connections, dragChangeConn)

    local dragEndConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if btnDrag then
                btnDrag = false
                if (input.Position - btnInputStart).Magnitude < 15 then 
                    toggleMenu() 
                end
            end
        end
    end)
    table.insert(connections, dragEndConn)

    local mainFrame = Instance.new("Frame", masterFrame)
    mainFrame.Size = UDim2.new(0.58, 0, 1, 0)
    mainFrame.BackgroundColor3 = currentTheme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 5
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = currentTheme.Border

    table.insert(themeUpdateListeners, function(theme)
        mainFrame.BackgroundColor3 = theme.Background
        mainStroke.Color = theme.Border
    end)

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

    local sidebar = Instance.new("Frame", mainFrame)
    sidebar.Size = UDim2.new(0, 75, 1, 0)
    sidebar.BackgroundColor3 = currentTheme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 6
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

    local logoBtn = Instance.new("TextButton", sidebar)
    logoBtn.Size = UDim2.new(1, 0, 0, 30)
    logoBtn.BackgroundTransparency = 1
    logoBtn.Text = "Gestio"
    logoBtn.TextColor3 = currentTheme.Accent
    logoBtn.TextSize = 12
    logoBtn.Font = Enum.Font.GothamBold
    logoBtn.ZIndex = 7

    local function bindTouchLocal(btn, callback)
        local conn = btn.Activated:Connect(callback)
        table.insert(connections, conn)
    end

    bindTouchLocal(logoBtn, toggleMenu)

    table.insert(themeUpdateListeners, function(theme)
        sidebar.BackgroundColor3 = theme.Sidebar
        logoBtn.TextColor3 = theme.Accent
    end)

    local function createNavBtn(y, txt)
        local b = Instance.new("TextButton", sidebar)
        b.Size = UDim2.new(0.86, 0, 0, 20)
        b.Position = UDim2.new(0.07, 0, 0, y)
        b.BackgroundColor3 = currentTheme.Sidebar
        b.TextColor3 = currentTheme.TextSecondary
        b.Text = txt
        b.TextSize = 8
        b.Font = Enum.Font.GothamBold
        b.ZIndex = 7
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        return b
    end

    local cBtn = createNavBtn(32, "COMBAT")
    local mBtn = createNavBtn(54, "MOVEMENT")
    local eBtn = createNavBtn(76, "ESP")
    local envBtn = createNavBtn(98, "ENV")
    local micsBtn = createNavBtn(120, "MICS")
    local setsBtn = createNavBtn(142, "SETTINGS")
    cBtn.BackgroundColor3 = currentTheme.CardBg
    cBtn.TextColor3 = currentTheme.Accent

    local function makePageContainer()
        local c = Instance.new("ScrollingFrame", mainFrame)
        c.Size = UDim2.new(1, -82, 1, -12)
        c.Position = UDim2.new(0, 78, 0, 6)
        c.BackgroundTransparency = 1
        c.ScrollBarThickness = 2
        c.CanvasSize = UDim2.new(0, 0, 0, 0)
        c.AutomaticCanvasSize = Enum.AutomaticSize.Y
        c.Visible = false
        c.ZIndex = 6

        local list = Instance.new("UIListLayout", c)
        list.FillDirection = Enum.FillDirection.Vertical
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 8)

        local pad = Instance.new("UIPadding", c)
        pad.PaddingLeft = UDim.new(0, 4)
        pad.PaddingRight = UDim.new(0, 6)
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 6)
        return c
    end

    local function makeCategorySection(page, title, layoutOrder)
        local sectionContainer = Instance.new("Frame", page)
        sectionContainer.Size = UDim2.new(1, 0, 0, 0)
        sectionContainer.AutomaticSize = Enum.AutomaticSize.Y
        sectionContainer.BackgroundTransparency = 1
        sectionContainer.LayoutOrder = layoutOrder or 1
        sectionContainer.ZIndex = 6

        local sectionList = Instance.new("UIListLayout", sectionContainer)
        sectionList.FillDirection = Enum.FillDirection.Vertical
        sectionList.SortOrder = Enum.SortOrder.LayoutOrder
        sectionList.Padding = UDim.new(0, 4)

        local headerFrame = Instance.new("Frame", sectionContainer)
        headerFrame.Size = UDim2.new(1, 0, 0, 16)
        headerFrame.BackgroundTransparency = 1
        headerFrame.LayoutOrder = 1
        headerFrame.ZIndex = 6

        local headerLabel = Instance.new("TextLabel", headerFrame)
        headerLabel.Size = UDim2.new(1, 0, 1, 0)
        headerLabel.BackgroundTransparency = 1
        headerLabel.Text = title:upper()
        headerLabel.TextColor3 = currentTheme.Accent
        headerLabel.TextSize = 8.5
        headerLabel.Font = Enum.Font.GothamBold
        headerLabel.TextXAlignment = Enum.TextXAlignment.Left
        headerLabel.ZIndex = 7

        local gridFrame = Instance.new("Frame", sectionContainer)
        gridFrame.Size = UDim2.new(1, 0, 0, 0)
        gridFrame.AutomaticSize = Enum.AutomaticSize.Y
        gridFrame.BackgroundTransparency = 1
        gridFrame.LayoutOrder = 2
        gridFrame.ZIndex = 6

        local grid = Instance.new("UIGridLayout", gridFrame)
        grid.CellSize = UDim2.new(0, 58, 0, 58)
        grid.CellPadding = UDim2.new(0, 5, 0, 5)

        table.insert(themeUpdateListeners, function(theme)
            headerLabel.TextColor3 = theme.Accent
        end)

        return gridFrame
    end

    local cPage = makePageContainer()
    local mPage = makePageContainer()
    local ePage = makePageContainer()
    local envPage = makePageContainer()
    local micsPage = makePageContainer()
    local setsPage = makePageContainer()
    cPage.Visible = true

    local currentSelectedTab = "C"
    local function switch(tab)
        currentSelectedTab = tab
        cPage.Visible = (tab == "C")
        mPage.Visible = (tab == "M")
        ePage.Visible = (tab == "E")
        envPage.Visible = (tab == "ENV")
        micsPage.Visible = (tab == "MICS")
        setsPage.Visible = (tab == "SETS")

        local btns = {{cBtn, "C"}, {mBtn, "M"}, {eBtn, "E"}, {envBtn, "ENV"}, {micsBtn, "MICS"}, {setsBtn, "SETS"}}
        for _, item in ipairs(btns) do
            local on = (item[2] == tab)
            item[1].BackgroundColor3 = on and currentTheme.CardBg or currentTheme.Sidebar
            item[1].TextColor3 = on and currentTheme.Accent or currentTheme.TextSecondary
        end
    end

    table.insert(themeUpdateListeners, function(theme)
        switch(currentSelectedTab)
    end)

    bindTouchLocal(cBtn, function() switch("C") end)
    bindTouchLocal(mBtn, function() switch("M") end)
    bindTouchLocal(eBtn, function() switch("E") end)
    bindTouchLocal(envBtn, function() switch("ENV") end)
    bindTouchLocal(micsBtn, function() switch("MICS") end)
    bindTouchLocal(setsBtn, function() switch("SETS") end)

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

    table.insert(themeUpdateListeners, function(theme)
        inspectorPanel.BackgroundColor3 = theme.Background
        insStroke.Color = theme.Border
    end)

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
    bindTouchLocal(closeBtn, toggleMenu)

    local insContent = Instance.new("ScrollingFrame", inspectorPanel)
    insContent.Size = UDim2.new(1, 0, 1, -32)
    insContent.Position = UDim2.new(0, 0, 0, 30)
    insContent.BackgroundTransparency = 1
    insContent.ScrollBarThickness = 2
    insContent.CanvasSize = UDim2.new(0, 0, 0, 650)
    insContent.ZIndex = 6

    local function addInspectorSlider(y, txt, min, max, cur, isFloat, onChange)
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

        local trackBegan = track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                drag = true 
                update(input)
            end
        end)
        table.insert(connections, trackBegan)

        local trackEnded = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                drag = false
            end
        end)
        table.insert(connections, trackEnded)

        local trackChanged = UserInputService.InputChanged:Connect(function(input)
            if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
        table.insert(connections, trackChanged)
    end

    local function addInspectorToggle(y, txt, default, onToggle)
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

        bindTouchLocal(btn, executeToggle)
    end

    local function addInspectorChoice(y, txt, choices, currentChoice, onSelect)
        local lbl = Instance.new("TextLabel", insContent)
        lbl.Size = UDim2.new(0.86, 0, 0, 12)
        lbl.Position = UDim2.new(0.07, 0, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.Text = txt .. ":"
        lbl.TextColor3 = currentTheme.TextSecondary
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextSize = 8.5
        lbl.Font = Enum.Font.GothamBold
        lbl.ZIndex = 7

        local container = Instance.new("Frame", insContent)
        container.Size = UDim2.new(0.86, 0, 0, 22)
        container.Position = UDim2.new(0.07, 0, 0, y + 14)
        container.BackgroundTransparency = 1
        container.ZIndex = 7

        local layout = Instance.new("UIListLayout", container)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 4)

        for _, choiceName in ipairs(choices) do
            local choiceBtn = Instance.new("TextButton", container)
            choiceBtn.Size = UDim2.new(0, 48, 1, 0)
            choiceBtn.BackgroundColor3 = (choiceName == currentChoice) and currentTheme.Accent or currentTheme.CardBg
            choiceBtn.Text = choiceName
            choiceBtn.TextColor3 = (choiceName == currentChoice) and Color3.fromRGB(255, 255, 255) or currentTheme.TextSecondary
            choiceBtn.TextSize = 7.5
            choiceBtn.Font = Enum.Font.GothamBold
            choiceBtn.ZIndex = 8
            Instance.new("UICorner", choiceBtn).CornerRadius = UDim.new(0, 4)

            bindTouchLocal(choiceBtn, function()
                for _, child in ipairs(container:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = currentTheme.CardBg
                        child.TextColor3 = currentTheme.TextSecondary
                    end
                end
                choiceBtn.BackgroundColor3 = currentTheme.Accent
                choiceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                onSelect(choiceName)
            end)
        end
    end

    -- ==========================================
    -- DETAILED INSPECTOR ROUTING
    -- ==========================================
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
        elseif moduleName == "Anti-Aim" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
            addInspectorSlider(6, "Spin Speed", 10, 150, spinSpeed, false, function(v) 
                spinSpeed = v 
            end)
        elseif moduleName == "Auto Strafe" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
            addInspectorSlider(6, "Strafe Strength", 0.1, 2.0, strafeStrength, true, function(v) 
                strafeStrength = v 
            end)
        elseif moduleName == "FOV Changer" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
            addInspectorSlider(6, "Field Of View", 60, 140, customFovValue, false, function(v) 
                customFovValue = v 
                if customFovEnabled and camera then
                    pcall(function() camera.FieldOfView = v end)
                end
            end)
        elseif moduleName == "Kroaton HUD" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 180)
            addInspectorToggle(6, "Show FPS", infoHudShowFps, function(v) infoHudShowFps = v end)
            addInspectorToggle(34, "Show Ping", infoHudShowPing, function(v) infoHudShowPing = v end)
            addInspectorToggle(62, "Show Speed", infoHudShowSpeed, function(v) infoHudShowSpeed = v end)
            addInspectorToggle(90, "Show FOV", infoHudShowFov, function(v) infoHudShowFov = v end)
        elseif moduleName == "Slide" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 180)
            addInspectorSlider(6, "Speed Boost", 1.2, 3.0, slideSpeedBoost, true, function(v) slideSpeedBoost = v end)
            addInspectorSlider(38, "Friction", 0.85, 0.99, slideFriction, true, function(v) slideFriction = v end)
            addInspectorSlider(70, "Min Speed Threshold", 8, 24, slideMinSpeed, false, function(v) slideMinSpeed = v end)
        elseif moduleName == "Jump Circle" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 240)
            addInspectorSlider(6, "Radius", 1.5, 8.0, jumpCircleRadius, true, function(v)
                jumpCircleRadius = v
                if player and player.Character then initJumpCircleForCharacter(player.Character) end
            end)
            addInspectorSlider(38, "Segments", 12, 48, jumpCircleSegmentCount, false, function(v)
                jumpCircleSegmentCount = v
                if player and player.Character then initJumpCircleForCharacter(player.Character) end
            end)
            addInspectorChoice(80, "Style", {"GradientWave", "ChromaPulse", "StaticNeon"}, jumpCircleStyle, function(v)
                jumpCircleStyle = v
                if player and player.Character then initJumpCircleForCharacter(player.Character) end
            end)
        elseif moduleName == "Grenade Danger" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 200)
            addInspectorSlider(6, "Max Distance", 100, 1500, grenadeDangerMaxDist, false, function(v) 
                grenadeDangerMaxDist = v 
                for _, d in pairs(dangerGrenadeObjects) do
                    if d.billboard then d.billboard.MaxDistance = v end
                end
            end)
            addInspectorToggle(42, "Show Distance", grenadeDangerShowDist, function(v) grenadeDangerShowDist = v end)
            addInspectorToggle(70, "Danger Radius", grenadeDangerShowRadius, function(v) grenadeDangerShowRadius = v end)
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
        elseif moduleName == "Night Mode" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 260)
            addInspectorChoice(6, "Presets", {"Midnight", "DeepBlood", "CyberPurple", "EmeraldNight", "PitchBlack"}, nightPreset, function(selected)
                applyNightPreset(selected)
            end)
            addInspectorSlider(48, "Brightness", 0.0, 2.0, nightBrightness, true, function(v) 
                nightBrightness = v 
                if nightModeEnabled then pcall(function() Lighting.Brightness = v end) end
            end)
            addInspectorSlider(80, "Clock Time", 0.0, 24.0, nightClockTime, true, function(v) 
                nightClockTime = v 
                if nightModeEnabled then pcall(function() Lighting.ClockTime = v end) end
            end)
        elseif moduleName == "RCS" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 260)
            addInspectorSlider(6, "RCS Strength", 10, 100, rcsStrength, false, function(v) rcsStrength = v end)
            addInspectorSlider(38, "Pitch Factor", 0.1, 2.0, rcsPitchFactor, true, function(v) rcsPitchFactor = v end)
            addInspectorSlider(70, "Yaw Factor", 0.1, 2.0, rcsYawFactor, true, function(v) rcsYawFactor = v end)
            addInspectorSlider(102, "Smoothness", 0.0, 0.9, rcsSmoothness, true, function(v) rcsSmoothness = v end)
            addInspectorToggle(140, "Horizontal Comp", rcsHorizontalComp, function(v) rcsHorizontalComp = v end)
            addInspectorToggle(166, "Randomize", rcsRandomize, function(v) rcsRandomize = v end)
        elseif moduleName == "Trigger Assistant" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 150)
            addInspectorSlider(6, "Trigger Delay", 0.0, 0.2, triggerbotDelay, true, function(v) triggerbotDelay = v end)
            addInspectorToggle(44, "Head Only", triggerbotHeadOnly, function(v) triggerbotHeadOnly = v end)
            addInspectorToggle(70, "Auto Trigger", triggerbotMobileAutoFire, function(v) triggerbotMobileAutoFire = v end)
        elseif moduleName == "Theme" then
            insContent.CanvasSize = UDim2.new(0, 0, 0, 150)
            addInspectorChoice(6, "Color Palette", {"Charcoal Crimson", "Cyberpunk Neon", "Emerald Shadow"}, currentTheme.Name, function(selected)
                if themeLibrary[selected] then
                    currentTheme = themeLibrary[selected]
                    applyCurrentTheme()
                end
            end)
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
    local function addCard(parent, name, defaultState, onToggle)
        local card = Instance.new("Frame", parent)
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
        bindTouchLocal(textBtn, function() openInspectorFor(name) end)

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

            if name == "Night Mode" then
                if state then
                    applyNightPreset(nightPreset)
                else
                    restoreLightingState()
                end
            elseif name == "FullBright" and not state and not nightModeEnabled then
                restoreLightingState()
            elseif name == "FOV Changer" and not state then
                if camera then pcall(function() camera.FieldOfView = defaultCameraFOV end) end
            end
        end

        bindTouchLocal(toggleBtn, executeToggle)

        table.insert(themeUpdateListeners, function(theme)
            card.BackgroundColor3 = theme.CardBg
            cardStroke.Color = theme.Border
            textBtn.TextColor3 = theme.TextPrimary
            toggleBtn.BackgroundColor3 = state and theme.Accent or Color3.fromRGB(50, 53, 60)
        end)
    end

    -- ==========================================
    -- TAB SECTIONS & MODULE POPULATION
    -- ==========================================

    -- COMBAT TAB
    local cAimSection = makeCategorySection(cPage, "Aim & Ballistics", 1)
    local cRageSection = makeCategorySection(cPage, "HVH & Anti-Aim", 2)

    addCard(cAimSection, "Tracking", aimbotEnabled, function(v) aimbotEnabled = v end)
    addCard(cAimSection, "RCS", rcsEnabled, function(v) rcsEnabled = v end)
    addCard(cAimSection, "Trigger Assistant", triggerbotEnabled, function(v) triggerbotEnabled = v end)
    addCard(cRageSection, "Anti-Aim", antiAimEnabled, function(v) antiAimEnabled = v end)

    -- MOVEMENT TAB
    local mHopSection = makeCategorySection(mPage, "Bhop Mechanics", 1)
    local mBoostSection = makeCategorySection(mPage, "Physics Modifications", 2)

    addCard(mHopSection, "Bhop Engine", bunnyHopEnabled, function(v) bunnyHopEnabled = v end)
    addCard(mHopSection, "Auto Strafe", autoStrafeEnabled, function(v) autoStrafeEnabled = v end)
    addCard(mBoostSection, "Slide", slideEnabled, function(v) slideEnabled = v end)
    addCard(mBoostSection, "Speed Boost", speedEnabled, function(v) speedEnabled = v end)
    addCard(mBoostSection, "Flight", flightEnabled, function(v) flightEnabled = v end)

    -- ESP TAB
    local ePlayerSection = makeCategorySection(ePage, "Player Visuals", 1)
    local eWorldSection = makeCategorySection(ePage, "World & Projectiles", 2)

    addCard(ePlayerSection, "Nametags", nametagsEnabled, function(v) nametagsEnabled = v end)
    addCard(ePlayerSection, "Highlight", highlightEnabled, function(v) highlightEnabled = v end)
    addCard(ePlayerSection, "Box Overlay", boxEspEnabled, function(v) boxEspEnabled = v end)
    addCard(ePlayerSection, "Head Dot", headDotEnabled, function(v) headDotEnabled = v end)
    addCard(ePlayerSection, "Snaplines", tracersEnabled, function(v) tracersEnabled = v end)

    addCard(eWorldSection, "Grenade Danger", grenadeDangerEnabled, function(v) 
        grenadeDangerEnabled = v 
        for _, d in pairs(dangerGrenadeObjects) do
            d.billboard.Enabled = v
            if d.radius and d.radius.Parent then
                d.radius.Transparency = (v and grenadeDangerShowRadius) and 0.88 or 1
            end
        end
    end)

    addCard(eWorldSection, "Jump Circle", jumpCircleEnabled, function(v) 
        jumpCircleEnabled = v 
        if v and player and player.Character then
            initJumpCircleForCharacter(player.Character)
        else
            clearActiveJumpCircle()
        end
    end)

    -- ENVIRONMENT TAB
    local envLightSection = makeCategorySection(envPage, "Atmosphere & World", 1)
    addCard(envLightSection, "Night Mode", nightModeEnabled, function(v) nightModeEnabled = v end)
    addCard(envLightSection, "FullBright", fullBrightEnabled, function(v) fullBrightEnabled = v end)
    addCard(envLightSection, "Anti-Flash", antiFlashEnabled, function(v) antiFlashEnabled = v end)
    addCard(envLightSection, "FOV Changer", customFovEnabled, function(v) 
        customFovEnabled = v 
        if not v and camera then
            pcall(function() camera.FieldOfView = defaultCameraFOV end)
        end
    end)

    -- MISC TAB
    local miscGeneralSection = makeCategorySection(micsPage, "Utilities", 1)
    addCard(miscGeneralSection, "Kroaton HUD", infoHudEnabled, function(v) infoHudEnabled = v end)
    addCard(miscGeneralSection, "Anti-AFK", antiAfkEnabled, function(v) antiAfkEnabled = v end)

    -- SETTINGS TAB
    local setsGeneralSection = makeCategorySection(setsPage, "Configuration", 1)
    addCard(setsGeneralSection, "Theme", true, function(v) openInspectorFor("Theme") end)

    -- ==========================================
    -- SAFE ANTI-AFK INITIALIZATION
    -- ==========================================
    if player then
        local afkConn = player.Idled:Connect(function()
            if antiAfkEnabled then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.zero)
                end)
            end
        end)
        table.insert(connections, afkConn)
    end

    rawset(_G, "GestioRunning", cleanup)

    openInspectorFor("Tracking")
end

task.spawn(function()
    local success, err = pcall(initGestioSuite)
    if not success then
        warn("[Gestio Error]: " .. tostring(err))
    end
end)
