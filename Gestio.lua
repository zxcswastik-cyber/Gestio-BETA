-- ==============================================================================
-- [Gestio UI - Blox Strike Ultimate Mobile Engine (Full Monolithic Build 2200+)]
-- Architecture: Uncompressed Extended Pipeline
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
local player = Players.LocalPlayer or Players:GetPlayers()[1]
if not player then
    player = Players.PlayerAdded:Wait()
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
    
    return player:WaitForChild("PlayerGui", 2) or player.PlayerGui
end

local targetGui = getSafeGui()
local connections = {}
local activeEspHolders = {}
local screenEspCache = {}
local activeTracersCache = {}
local activeHeadDotsCache = {}

if not getgenv().GestioSavedPos then
    getgenv().GestioSavedPos = {
        OpenBtn = UDim2.new(0.5, -45, 0, 15),
        MainFrame = UDim2.new(0.5, 0, 0.5, 0)
    }
end

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
local tagShowWeapon = false

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

local grenadePool = {}

-- ==========================================
-- LIGHTING & ATMOSPHERE FUNCTIONS
-- ==========================================
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

-- ==========================================
-- CLEANUP ROUTINES
-- ==========================================
local function clearActiveJumpCircle()
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
    for _, gUi in pairs(grenadePool) do
        pcall(function()
            gUi.Tag:Destroy()
            gUi.RadiusCircle:Destroy()
            for _, l in ipairs(gUi.Lines) do l:Destroy() end
        end)
    end
    clearActiveJumpCircle()
    pcall(function() jumpCircleFolder:Destroy() end)
    activeEspHolders = {}
    screenEspCache = {}
    grenadePool = {}
    
    restoreLightingState()

    pcall(function() if targetGui:FindFirstChild("GestioScreenGui") then targetGui.GestioScreenGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioToggleGui") then targetGui.GestioToggleGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioFovGui") then targetGui.FovGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioWatermarkGui") then targetGui.WatermarkGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioMainContainer") then targetGui.GestioMainContainer:Destroy() end end)
end

if getgenv then getgenv().GestioRunning = cleanup end

local function bindTouch(btn, callback)
    btn.Activated:Connect(callback)
end

-- ==========================================
-- HUD OVERLAYS (FOV & WATERMARK)
-- ==========================================
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "GestioFovGui"
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

local watermarkGui = Instance.new("ScreenGui")
watermarkGui.Name = "GestioWatermarkGui"
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
wmTitle.Text = "GESTIO"
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
-- FACTION CHECK & HEALTH CHECK LOGIC
-- ==========================================
local function isAlly(plr)
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

local function isTargetEnemy(plr, char)
    if not plr or plr == player then return false end
    if char and char == player.Character then return false end
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
-- VISIBILITY CHECK SYSTEM (Raycast для стен)
-- ==========================================
local wallRayParams = RaycastParams.new()
wallRayParams.FilterType = Enum.RaycastFilterType.Exclude
wallRayParams.IgnoreWater = true

local function isVisibleThroughWalls(targetPart, targetChar)
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

local function spawnJumpRipple(position)
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

local function initJumpCircleForCharacter(char)
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
local grenadeRayParams = RaycastParams.new()
grenadeRayParams.FilterType = Enum.RaycastFilterType.Exclude
grenadeRayParams.IgnoreWater = true

local function isEntityCharacter(inst)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and inst:IsDescendantOf(p.Character) then
            return true
        end
    end
    return false
end

local function getOrCreateGrenadeUI(nadeInstance)
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

local function renderGrenadeOverlays()
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
-- TRIGGERBOT PROCESSING LOGIC
-- ==========================================
local triggerRayParams = RaycastParams.new()
triggerRayParams.FilterType = Enum.RaycastFilterType.Exclude
triggerRayParams.IgnoreWater = true

local function runMobileTriggerbot()
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

                        local parts = {}
                        if espShowHealth and hum then
                            table.insert(parts, string.format("%dHP", math.floor(hum.Health)))
                        end
                        if espShowDistance then
                            table.insert(parts, string.format("%dm", math.floor(dist)))
                        end
                        if tagShowWeapon then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then
                                table.insert(parts, tool.Name)
                            end
                        end

                        local infoText = #parts > 0 and table.concat(parts, " | ") or (plr.DisplayName or plr.Name)

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
    plr.CharacterAdded:Connect(setupCharacter)
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
            local aimPos = lockedTarget.Position
            if predictionEnabled and lockedTarget.Part and lockedTarget.Part.AssemblyLinearVelocity then
                aimPos = aimPos + (lockedTarget.Part.AssemblyLinearVelocity * predictionFactor)
            end
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, aimPos)
        end
    else
        lockedTarget = nil
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
    
    local char = player.Character
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
local function hookMobileJumpButton()
    task.spawn(function()
        local pGui = player:WaitForChild("PlayerGui", 5)
        if not pGui then return end
        local touchGui = pGui:WaitForChild("TouchGui", 5)
        if not touchGui then return end
        local controlFrame = touchGui:WaitForChild("TouchControlFrame", 5)
        if not controlFrame then return end
        local jumpBtn = controlFrame:WaitForChild("JumpButton", 5)
        if not jumpBtn then return end

        jumpBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                isMobileJumpHeld = true
            end
        end)

        jumpBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                isMobileJumpHeld = false
            end
        end)
    end)
end

hookMobileJumpButton()
player.CharacterAdded:Connect(hookMobileJumpButton)

UserInputService.JumpRequest:Connect(function()
    isMobileJumpHeld = true
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.Space then
        isMobileJumpHeld = true
    end

    if slideEnabled and (input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.LeftControl) then
        local char = player.Character
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

UserInputService.InputEnded:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.Space then
        isMobileJumpHeld = false
    end
    if input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.LeftControl then
        isSliding = false
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.HipHeight = defaultHipHeight
        end
    end
end)

-- ==========================================
-- PHYSICS & KINEMATICS HEARTBEAT
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
openBtn.Position = getgenv().GestioSavedPos.OpenBtn
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

local function toggleMenu() 
    masterFrame.Visible = not masterFrame.Visible 
end

local btnDrag, btnStartPos, btnInputStart = false, nil, nil
openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDrag = true
        btnStartPos = openBtn.Position
        btnInputStart = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if btnDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnInputStart
        local newPos = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
        openBtn.Position = newPos
        getgenv().GestioSavedPos.OpenBtn = newPos
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if btnDrag then
            btnDrag = false
            if (input.Position - btnInputStart).Magnitude < 15 then 
                toggleMenu() 
            end
        end
    end
end)

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
bindTouch(logoBtn, toggleMenu)

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

    return gridFrame
end

local cPage = makePageContainer()
local mPage = makePageContainer()
local ePage = makePageContainer()
local envPage = makePageContainer()
local micsPage = makePageContainer()
local setsPage = makePageContainer()
cPage.Visible = true

local function switch(tab)
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

bindTouch(cBtn, function() switch("C") end)
bindTouch(mBtn, function() switch("M") end)
bindTouch(eBtn, function() switch("E") end)
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

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true 
            update(input)
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

        bindTouch(choiceBtn, function()
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
    elseif moduleName == "Night Mode" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 260)
        addInspectorChoice(6, "Presets", {"Midnight", "DeepBlood", "CyberPurple", "EmeraldNight", "PitchBlack"}, nightPreset, function(selected)
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
        
        if name == "Night Mode" then
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

addCard(eWorldSection, "Grenade ESP", grenadeEspEnabled, function(v) grenadeEspEnabled = v end)
addCard(eWorldSection, "Jump Circle", jumpCircleEnabled, function(v) 
    jumpCircleEnabled = v 
    if v and player.Character then
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

-- MISC TAB
local miscGeneralSection = makeCategorySection(micsPage, "Utilities", 1)
addCard(miscGeneralSection, "Anti-AFK", true, function(v) end)

-- SETTINGS TAB
local setsGeneralSection = makeCategorySection(setsPage, "Configuration", 1)
addCard(setsGeneralSection, "Theme", true, function(v) end)

openInspectorFor("Tracking")
