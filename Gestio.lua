-- ==============================================================================
-- [Gestio UI - Blox Strike Ultimate Mobile Engine (Full Suite 2600+ Lines)]
-- Version: 5.4.8 Enterprise Final Fixed Edition
-- Target Game: Blox Strike (Roblox Mobile)
-- ==============================================================================

pcall(function()
    if type(getgenv) == "function" then
        local env = getgenv()
        if type(env.GestioRunning) == "function" then
            env.GestioRunning()
            env.GestioRunning = nil
        end
    end
end)

task.defer(function()
    -- ==========================================
    -- SYSTEM SERVICES IMPORT
    -- ==========================================
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local Stats = game:GetService("Stats")
    local Debris = game:GetService("Debris")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")

    local VirtualUser = nil
    pcall(function()
        VirtualUser = game:GetService("VirtualUser")
    end)

    local VirtualInputManager = nil
    pcall(function()
        VirtualInputManager = game:GetService("VirtualInputManager")
    end)

    -- ==========================================
    -- CLIENT ENVIRONMENT VALIDATION
    -- ==========================================
    local player = Players.LocalPlayer
    while not player do
        task.wait(0.1)
        player = Players.LocalPlayer
    end

    local camera = Workspace.CurrentCamera
    while not camera do
        task.wait(0.1)
        camera = Workspace.CurrentCamera
    end

    local defaultCameraFOV = 70
    pcall(function()
        defaultCameraFOV = camera.FieldOfView
    end)

    local function getSafeGui()
        if type(gethui) == "function" then
            local s, res = pcall(gethui)
            if s and res then return res end
        end
        if player then
            local pGui = player:FindFirstChild("PlayerGui")
            if pGui then return pGui end
        end
        local s, res = pcall(function() return CoreGui end)
        if s and res then return res end
        return (player and player:WaitForChild("PlayerGui", 5)) or CoreGui
    end

    local targetGui = getSafeGui()
    local connections = {}
    local activeEspHolders = {}
    local screenEspCache = {}
    local themeUpdateListeners = {}

    local defaultPos = {
        OpenBtn = UDim2.new(0.5, -45, 0, 15),
        MainFrame = UDim2.new(0.5, 0, 0.5, 0)
    }

    -- Cleanup previous instances safely
    if targetGui then
        pcall(function()
            for _, child in ipairs(targetGui:GetChildren()) do
                if child.Name == "GestioScreenGui" or child.Name == "GestioToggleGui" or child.Name == "GestioFovGui" or child.Name == "GestioWatermarkGui" or child.Name == "GestioMainContainer" then
                    child:Destroy()
                end
            end
        end)
    end

    local function cleanup()
        for _, c in pairs(connections) do 
            pcall(function() c:Disconnect() end) 
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
        activeEspHolders = {}
        screenEspCache = {}
        pcall(function()
            if targetGui:FindFirstChild("GestioMainContainer") then targetGui.GestioMainContainer:Destroy() end
            if targetGui:FindFirstChild("GestioToggleGui") then targetGui.GestioToggleGui:Destroy() end
            if targetGui:FindFirstChild("GestioFovGui") then targetGui.FovGui:Destroy() end
            if targetGui:FindFirstChild("GestioWatermarkGui") then targetGui.WatermarkGui:Destroy() end
        end)
    end

    pcall(function()
        if type(getgenv) == "function" then
            getgenv().GestioRunning = cleanup
        end
    end)

    -- ==========================================
    -- EXTENDED THEME SYSTEM
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
    -- ENGINE CONFIGURATION VARIABLES
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
    local bodyAimOnly = false
    local predictionEnabled = true
    local predictionFactor = 0.135
    local visibleCheck = false
    local aimSensitivity = 1.0

    local rcsEnabled = false
    local rcsStrength = 75
    local rcsPitchFactor = 1.0
    local rcsYawFactor = 1.0
    local rcsSmoothness = 0.2
    local rcsHorizontalComp = true
    local rcsRandomize = true

    local triggerbotEnabled = false
    local triggerbotDelay = 0.02
    local triggerbotHeadOnly = false
    local triggerbotMobileAutoFire = true
    local lastTriggerTick = 0

    local antiAimEnabled = false
    local spinSpeed = 50
    local currentSpinAngle = 0

    local bunnyHopEnabled = false
    local bhopAutoJump = false
    local bhopAirStrafe = true
    local bhopSpeedBoost = 1.35
    local bhopJumpPower = 52
    local isMobileJumpHeld = false
    local autoStrafeEnabled = false
    local strafeStrength = 1.0

    local slideEnabled = false
    local isSliding = false
    local slideSpeedBoost = 1.8
    local slideFriction = 0.94
    local slideMinSpeed = 16
    local currentSlideVel = Vector3.new(0, 0, 0)
    local defaultHipHeight = 2.0

    local speedEnabled = false
    local walkMultiplier = 2.0
    local flightEnabled = false
    local flightSpeed = 50

    local nametagsEnabled = false
    local espMaxDist = 3000
    local espShowDistance = true
    local espShowHealth = true
    local espTextSize = 8.5
    local tagTransparency = 0.25
    local tagBgColor = Color3.fromRGB(16, 17, 20)
    local tagShowWeapon = true

    local boxEspEnabled = false
    local cornerBoxEnabled = false
    local boxThickness = 1.0
    local healthBarEnabled = true
    local highlightEnabled = false
    local headDotEnabled = false
    local tracersEnabled = false

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

    local jumpCircleEnabled = false
    local jumpCircleStyle = "GradientWave"
    local jumpCircleSegmentCount = 32
    local jumpCircleRadius = 3.5
    local jumpCircleHeightOffset = -2.8
    local activeJumpCircleData = nil

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
        ["Midnight"] = { ClockTime = 0.0, Brightness = 0.2, OutdoorAmbient = Color3.fromRGB(25, 25, 40), Ambient = Color3.fromRGB(15, 15, 25), FogColor = Color3.fromRGB(10, 10, 20) },
        ["DeepBlood"] = { ClockTime = 0.0, Brightness = 0.35, OutdoorAmbient = Color3.fromRGB(75, 10, 15), Ambient = Color3.fromRGB(45, 5, 10), FogColor = Color3.fromRGB(35, 5, 8) },
        ["CyberPurple"] = { ClockTime = 23.5, Brightness = 0.3, OutdoorAmbient = Color3.fromRGB(65, 15, 95), Ambient = Color3.fromRGB(40, 10, 60), FogColor = Color3.fromRGB(30, 8, 45) },
        ["EmeraldNight"] = { ClockTime = 1.0, Brightness = 0.25, OutdoorAmbient = Color3.fromRGB(10, 55, 30), Ambient = Color3.fromRGB(5, 35, 20), FogColor = Color3.fromRGB(5, 25, 15) },
        ["PitchBlack"] = { ClockTime = 0.0, Brightness = 0.0, OutdoorAmbient = Color3.fromRGB(0, 0, 0), Ambient = Color3.fromRGB(0, 0, 0), FogColor = Color3.fromRGB(0, 0, 0) }
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
    -- KROATON HUD SETUP
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
                if circleData.Container then pcall(function() circleData.Container:Destroy() end) end
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
        if player.Character then
            task.spawn(function()
                initJumpCircleForCharacter(player.Character)
            end)
        end
    end

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
    -- FACTION CHECK & HEALTH CHECK LOGIC
    -- ==========================================
    local function isAlly(plr)
        if not plr or plr == player then return false end
        if plr.Team and player and player.Team then
            return plr.Team == player.Team
        end
        if plr:GetAttribute("Team") and player and player:GetAttribute("Team") then
            return plr:GetAttribute("Team") == player:GetAttribute("Team")
        end
        if plr.TeamColor and player and player.TeamColor and plr.TeamColor ~= BrickColor.new("White") then
            return plr.TeamColor == player.TeamColor
        end
        return false
    end

    local function isTargetEnemy(plr, char)
        if not plr or (player and plr == player) then return false end
        if char and player and char == player.Character then return false end
        return not isAlly(plr)
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

    local function isEntityAlive(char, hum)
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
    local fpsCounter = 0
    local lastFpsUpdate = tick()
    local calculatedCurrentFps = 60

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
                local currentFps = math.floor(1 / math.max(dt, 0.001))
                hudFpsLabel.Text = "FPS:       " .. tostring(currentFps)
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
                    currentSlideVel.Y,
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

        if flightEnabled then
            local camLook = camera.CFrame.LookVector
            hrp.AssemblyLinearVelocity = camLook * flightSpeed
        end
    end))

    openInspectorFor("Tracking")
end)
