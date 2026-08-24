-- Gestio UI
pcall(function()
    if getgenv and getgenv().GestioRunning then
        getgenv().GestioRunning()
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local Stats = game:GetService("Stats")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer or Players:GetPlayers()[1]
if not player then
    player = Players.PlayerAdded:Wait()
end

local camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")

local function getSafeGui()
    local gui = nil
    pcall(function()
        if gethui then 
            gui = gethui() 
        end
    end)
    if gui then return gui end
    
    pcall(function()
        if CoreGui and not RunService:IsStudio() then
            gui = CoreGui
        end
    end)
    if gui then return gui end
    
    return player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 5)
end

local targetGui = getSafeGui()
local connections = {}
local activeEspHolders = {}
local screenEspCache = {}
local grenadePool = {}
local chamsCache = {}
local offScreenArrows = {}
local skeletonCache = {}

if not getgenv().GestioSavedPos then
    getgenv().GestioSavedPos = {
        OpenBtn = UDim2.new(0.5, -45, 0, 15)
    }
end

-- ==========================================
-- THEME CONFIGURATION (CHARCOAL CRIMSON)
-- ==========================================
local currentTheme = {
    Name = "Charcoal Crimson",
    Background = Color3.fromRGB(24, 25, 28),
    Sidebar = Color3.fromRGB(30, 32, 36),
    CardBg = Color3.fromRGB(35, 38, 43),
    Accent = Color3.fromRGB(210, 45, 55),
    TextPrimary = Color3.fromRGB(235, 238, 242),
    TextSecondary = Color3.fromRGB(140, 145, 155),
    Border = Color3.fromRGB(45, 48, 55),
    
    -- T Side Palette (Crimson)
    T_Accent = Color3.fromRGB(210, 45, 55),
    T_Fill = Color3.fromRGB(210, 45, 55),
    
    -- CT Side Palette (Charcoal)
    CT_Accent = Color3.fromRGB(75, 80, 92),
    CT_Fill = Color3.fromRGB(45, 48, 55),
    
    -- Nametag Font Color
    NametagTextColor = Color3.fromRGB(255, 45, 55),
    
    -- Grenade Colors
    MolotovColor = Color3.fromRGB(255, 95, 35),
    SmokeColor = Color3.fromRGB(180, 185, 195),
    HEColor = Color3.fromRGB(255, 45, 55),

    -- Visual Additions
    CrosshairColor = Color3.fromRGB(210, 45, 55),
    HitmarkerColor = Color3.fromRGB(255, 255, 255),
    SkeletonColor = Color3.fromRGB(210, 45, 55),
    ArrowColor = Color3.fromRGB(210, 45, 55),
    BeamColor = Color3.fromRGB(210, 45, 55),
    ViewmodelColor = Color3.fromRGB(210, 45, 55),

    -- Radiant Crystal Chams Theme
    CrystalColor = Color3.fromRGB(255, 15, 35),
    CrystalOutline = Color3.fromRGB(255, 45, 65),
    CrystalLightColor = Color3.fromRGB(255, 0, 25)
}

-- ==========================================
-- MODULE CONFIGURATION
-- ==========================================
local nametagsEnabled = false
local espMaxDist = 3000
local espShowDistance = true
local espShowHealth = true
local espShowTeamTag = true
local espTextSize = 8
local tagTransparency = 0.35
local tagBgColor = Color3.fromRGB(18, 19, 22)
local tagShowWeapon = true

local boxEspEnabled = false
local boxThickness = 1.0

-- New Visual Features
local skeletonEspEnabled = false
local skeletonThickness = 1.2

local offScreenArrowsEnabled = false
local arrowRadius = 140
local arrowSize = 14

local customCrosshairEnabled = false
local crosshairGap = 4
local crosshairSize = 6
local crosshairThickness = 2
local crosshairDot = true

local hitmarkerEnabled = false
local hitmarkerSoundEnabled = true
local hitmarkerSoundId = "rbxassetid://4817809188"
local lastHealthStates = {}

local bulletTracersEnabled = false
local tracerBeamDuration = 0.65

local viewmodelChamsEnabled = false
local viewmodelChamsMaterial = Enum.Material.ForceField
local viewmodelChamsColor = currentTheme.ViewmodelColor

local thirdpersonEnabled = false
local thirdpersonDistance = 12

-- Crystal Chams
local chamsEnabled = false
local crystalOrbitSpeed = 3.5
local crystalOrbitRadius = 3.2
local crystalCount = 4
local crystalLightEnabled = true
local crystalLightBrightness = 4.0
local crystalLightRange = 12

-- Grenades
local grenadeEspEnabled = false
local showGrenadePath = true
local showMolotovRadius = true
local showSmokeRadius = true
local grenadeMaxDist = 1500

-- Combat & Movement
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

local triggerbotEnabled = false
local triggerbotDelay = 0.02
local triggerbotHeadOnly = false
local triggerbotMobileAutoFire = true
local lastTriggerTick = 0

local bunnyHopEnabled = false
local bhopAutoJump = true
local bhopAirStrafe = true
local bhopSpeedBoost = 1.35
local bhopJumpPower = 52
local lastMoveDirection = Vector3.zero

local speedEnabled = false
local walkMultiplier = 2.0
local flightEnabled = false
local flightSpeed = 50

local highlightEnabled = false
local headDotEnabled = false
local tracersEnabled = false
local antiFlashEnabled = true
local fullBrightEnabled = false
local nightModeEnabled = false
local nightClockTime = 0.0
local nightBrightness = 0.2
local nightOutdoorAmbient = Color3.fromRGB(25, 25, 40)
local removeFogEnabled = true

local defaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor
}

-- Native Containers
local mainContainer = Instance.new("ScreenGui")
mainContainer.Name = "GestioMainContainer"
mainContainer.ResetOnSpawn = false
mainContainer.DisplayOrder = 10
mainContainer.IgnoreGuiInset = true
mainContainer.Parent = targetGui

local overlayContainer = Instance.new("Folder", mainContainer)
local grenadeContainer = Instance.new("Folder", mainContainer)
local skeletonContainer = Instance.new("Folder", mainContainer)
local arrowContainer = Instance.new("Folder", mainContainer)

local worldContainer = Instance.new("Folder")
worldContainer.Name = "Gestio_World3D"
worldContainer.Parent = Workspace

local hitSoundInstance = Instance.new("Sound")
hitSoundInstance.Name = "GestioHitSound"
hitSoundInstance.SoundId = hitmarkerSoundId
hitSoundInstance.Volume = 2.5
hitSoundInstance.Parent = SoundService

local hitmarkerGui = Instance.new("ScreenGui")
hitmarkerGui.Name = "GestioHitmarkerGui"
hitmarkerGui.ResetOnSpawn = false
hitmarkerGui.DisplayOrder = 30
hitmarkerGui.IgnoreGuiInset = true
hitmarkerGui.Parent = targetGui

local hmCenter = Instance.new("Frame", hitmarkerGui)
hmCenter.AnchorPoint = Vector2.new(0.5, 0.5)
hmCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
hmCenter.Size = UDim2.new(0, 0, 0, 0)
hmCenter.BackgroundTransparency = 1
hmCenter.Visible = false

local function createHmLine(angle)
    local line = Instance.new("Frame", hmCenter)
    line.Size = UDim2.new(0, 8, 0, 1.5)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = currentTheme.HitmarkerColor
    line.BorderSizePixel = 0
    line.Rotation = angle
    line.Position = UDim2.new(0, math.cos(math.rad(angle)) * 6, 0, math.sin(math.rad(angle)) * 6)
    return line
end
createHmLine(45)
createHmLine(135)
createHmLine(225)
createHmLine(315)

local crosshairGui = Instance.new("ScreenGui")
crosshairGui.Name = "GestioCrosshairGui"
crosshairGui.ResetOnSpawn = false
crosshairGui.DisplayOrder = 25
crosshairGui.IgnoreGuiInset = true
crosshairGui.Parent = targetGui

local chCenter = Instance.new("Frame", crosshairGui)
chCenter.AnchorPoint = Vector2.new(0.5, 0.5)
chCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
chCenter.Size = UDim2.new(0, 0, 0, 0)
chCenter.BackgroundTransparency = 1
chCenter.Visible = false

local chDot = Instance.new("Frame", chCenter)
chDot.AnchorPoint = Vector2.new(0.5, 0.5)
chDot.Size = UDim2.new(0, 3, 0, 3)
chDot.BackgroundColor3 = currentTheme.CrosshairColor
chDot.BorderSizePixel = 0
Instance.new("UICorner", chDot).CornerRadius = UDim.new(1, 0)

local chTop = Instance.new("Frame", chCenter)
chTop.AnchorPoint = Vector2.new(0.5, 1)
chTop.BorderSizePixel = 0
chTop.BackgroundColor3 = currentTheme.CrosshairColor

local chBottom = Instance.new("Frame", chCenter)
chBottom.AnchorPoint = Vector2.new(0.5, 0)
chBottom.BorderSizePixel = 0
chBottom.BackgroundColor3 = currentTheme.CrosshairColor

local chLeft = Instance.new("Frame", chCenter)
chLeft.AnchorPoint = Vector2.new(1, 0.5)
chLeft.BorderSizePixel = 0
chLeft.BackgroundColor3 = currentTheme.CrosshairColor

local chRight = Instance.new("Frame", chCenter)
chRight.AnchorPoint = Vector2.new(0, 0.5)
chRight.BorderSizePixel = 0
chRight.BackgroundColor3 = currentTheme.CrosshairColor

local function updateCrosshairStyle()
    chCenter.Visible = customCrosshairEnabled
    chDot.Visible = crosshairDot
    chDot.BackgroundColor3 = currentTheme.CrosshairColor
    
    chTop.Size = UDim2.new(0, crosshairThickness, 0, crosshairSize)
    chTop.Position = UDim2.new(0, 0, 0, -crosshairGap)
    chTop.BackgroundColor3 = currentTheme.CrosshairColor

    chBottom.Size = UDim2.new(0, crosshairThickness, 0, crosshairSize)
    chBottom.Position = UDim2.new(0, 0, 0, crosshairGap)
    chBottom.BackgroundColor3 = currentTheme.CrosshairColor

    chLeft.Size = UDim2.new(0, crosshairSize, 0, crosshairThickness)
    chLeft.Position = UDim2.new(0, -crosshairGap, 0, 0)
    chLeft.BackgroundColor3 = currentTheme.CrosshairColor

    chRight.Size = UDim2.new(0, crosshairSize, 0, crosshairThickness)
    chRight.Position = UDim2.new(0, crosshairGap, 0, 0)
    chRight.BackgroundColor3 = currentTheme.CrosshairColor
end

local function triggerHitmarker()
    if not hitmarkerEnabled then return end
    if hitmarkerSoundEnabled then
        pcall(function() hitSoundInstance:Play() end)
    end
    hmCenter.Visible = true
    task.spawn(function()
        task.wait(0.12)
        hmCenter.Visible = false
    end)
end

local function createBulletTracer(origin, hitPosition)
    if not bulletTracersEnabled then return end
    local part = Instance.new("Part")
    part.Name = "GestioBeamTracer"
    part.Anchored = true
    part.CanCollide = false
    part.CastShadow = false
    part.Material = Enum.Material.Neon
    part.Color = currentTheme.BeamColor
    part.Transparency = 0.2
    
    local dist = (hitPosition - origin).Magnitude
    part.Size = Vector3.new(0.08, 0.08, dist)
    part.CFrame = CFrame.new(origin, hitPosition) * CFrame.new(0, 0, -dist / 2)
    part.Parent = worldContainer

    task.spawn(function()
        local steps = 15
        for i = 1, steps do
            task.wait(tracerBeamDuration / steps)
            part.Transparency = 0.2 + (0.8 * (i / steps))
        end
        part:Destroy()
    end)
end

local function cleanup()
    for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
    for _, holder in pairs(activeEspHolders) do
        pcall(function() holder.Holder:Destroy() end)
        if holder.Highlight then pcall(function() holder.Highlight:Destroy() end) end
    end
    for _, esp in pairs(screenEspCache) do
        pcall(function()
            esp.Box:Destroy()
            esp.TagCard:Destroy()
        end)
    end
    for _, gUi in pairs(grenadePool) do
        pcall(function()
            gUi.Tag:Destroy()
            gUi.RadiusCircle:Destroy()
            for _, l in ipairs(gUi.Lines) do l:Destroy() end
        end)
    end
    for _, ch in pairs(chamsCache) do
        pcall(function()
            if ch.Highlight then ch.Highlight:Destroy() end
            if ch.CrystalFolder then ch.CrystalFolder:Destroy() end
        end)
    end
    for _, a in pairs(offScreenArrows) do pcall(function() a:Destroy() end) end
    for _, sk in pairs(skeletonCache) do
        for _, line in pairs(sk) do pcall(function() line:Destroy() end) end
    end
    
    activeEspHolders = {}
    screenEspCache = {}
    grenadePool = {}
    chamsCache = {}
    offScreenArrows = {}
    skeletonCache = {}
    
    pcall(function() worldContainer:Destroy() end)
    pcall(function()
        player.CameraMinZoomDistance = 0.5
        player.CameraMaxZoomDistance = 400
    end)

    pcall(function()
        Lighting.Brightness = defaultLighting.Brightness
        Lighting.ClockTime = defaultLighting.ClockTime
        Lighting.GlobalShadows = defaultLighting.GlobalShadows
        Lighting.Ambient = defaultLighting.Ambient
        Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
        Lighting.FogEnd = defaultLighting.FogEnd
        Lighting.FogColor = defaultLighting.FogColor
    end)

    pcall(function() if targetGui:FindFirstChild("GestioScreenGui") then targetGui.GestioScreenGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioToggleGui") then targetGui.GestioToggleGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioFovGui") then targetGui.GestioFovGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioWatermarkGui") then targetGui.GestioWatermarkGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioMainContainer") then targetGui.GestioMainContainer:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioHitmarkerGui") then targetGui.GestioHitmarkerGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioCrosshairGui") then targetGui.GestioCrosshairGui:Destroy() end end)
end

if getgenv then getgenv().GestioRunning = cleanup end

local function bindTouch(btn, callback)
    btn.Activated:Connect(callback)
end

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
fovStroke.Thickness = 1.5
local fovCorner = Instance.new("UICorner", fovFrame)
fovCorner.CornerRadius = UDim.new(1, 0)

-- Watermark
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

local function getPlayerSide(plr)
    if not plr then return "T" end
    if plr.Team then
        local tName = tostring(plr.Team.Name):lower()
        if tName:find("counter") or tName:find("ct") or tName:find("police") or tName:find("swat") or tName:find("guard") or tName:find("blue") or tName:find("defend") or tName:find("spec") then
            return "CT"
        elseif tName:find("terror") or tName:find("t") or tName:find("anarch") or tName:find("rebel") or tName:find("red") or tName:find("attack") then
            return "T"
        end
    end
    if plr.TeamColor then
        local colName = plr.TeamColor.Name:lower()
        if colName:find("blue") or colName:find("navy") or colName:find("cyan") or colName:find("teal") or colName:find("lapis") or colName:find("grey") or colName:find("gray") or colName:find("black") then
            return "CT"
        elseif colName:find("red") or colName:find("orange") or colName:find("yellow") or colName:find("rust") or colName:find("crimson") then
            return "T"
        end
    end
    local char = plr.Character
    local teamAttr = plr:GetAttribute("Team") or (char and char:GetAttribute("Team")) or plr:GetAttribute("Side") or (char and char:GetAttribute("Side"))
    if teamAttr ~= nil then
        local tStr = tostring(teamAttr):lower()
        if tStr:find("ct") or tStr:find("counter") or tStr == "2" or tStr:find("blue") or tStr:find("defend") then
            return "CT"
        elseif tStr:find("t") or tStr:find("terror") or tStr == "1" or tStr:find("red") or tStr:find("attack") then
            return "T"
        end
    end
    if plr ~= player and player.Team and plr.Team then
        return (plr.Team == player.Team) and getPlayerSide(player) or ((getPlayerSide(player) == "CT") and "T" or "CT")
    end
    return "T"
end

local function isTargetEnemy(plr, char)
    if not plr or plr == player then return false end
    if char and char == player.Character then return false end
    if player.Neutral or plr.Neutral then return true end
    if plr.Team ~= nil and player.Team ~= nil then return plr.Team ~= player.Team end
    if plr.TeamColor ~= nil and player.TeamColor ~= nil and plr.TeamColor ~= BrickColor.new("White") then return plr.TeamColor ~= player.TeamColor end
    return getPlayerSide(player) ~= getPlayerSide(plr)
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
    if not char or not char.Parent or not char:IsDescendantOf(Workspace) then return false end
    if hum and hum.Parent then
        local health = 100
        pcall(function() health = hum.Health end)
        if health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return false end
    end
    return (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")) ~= nil
end

-- ==========================================
-- SKELETON ESP ENGINE
-- ==========================================
local function getOrCreateSkeleton(plr)
    if skeletonCache[plr] then return skeletonCache[plr] end
    local lines = {}
    for i = 1, 14 do
        local l = Instance.new("Frame", skeletonContainer)
        l.BorderSizePixel = 0
        l.AnchorPoint = Vector2.new(0.5, 0.5)
        l.BackgroundColor3 = currentTheme.SkeletonColor
        l.Visible = false
        table.insert(lines, l)
    end
    skeletonCache[plr] = lines
    return lines
end

local function drawSkeletonBone(line, partA, partB)
    if not partA or not partB then line.Visible = false return end
    local p1, on1 = camera:WorldToViewportPoint(partA.Position)
    local p2, on2 = camera:WorldToViewportPoint(partB.Position)
    if on1 and on2 and p1.Z > 0 and p2.Z > 0 then
        local v1 = Vector2.new(p1.X, p1.Y)
        local v2 = Vector2.new(p2.X, p2.Y)
        local dist = (v2 - v1).Magnitude
        local center = (v1 + v2) * 0.5
        local angle = math.deg(math.atan2(v2.Y - v1.Y, v2.X - v1.X))
        line.Size = UDim2.new(0, dist, 0, skeletonThickness)
        line.Position = UDim2.new(0, center.X, 0, center.Y)
        line.Rotation = angle
        line.BackgroundColor3 = currentTheme.SkeletonColor
        line.Visible = true
    else
        line.Visible = false
    end
end

local function renderSkeletonESP()
    for plr, lines in pairs(skeletonCache) do
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if skeletonEspEnabled and char and isTargetEnemy(plr, char) and isEntityAlive(char, hum) then
            local head = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            local root = char:FindFirstChild("HumanoidRootPart") or torso
            local lArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
            local rArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
            local lHand = char:FindFirstChild("LeftHand") or lArm
            local rHand = char:FindFirstChild("RightHand") or rArm
            local lLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
            local rLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
            local lFoot = char:FindFirstChild("LeftFoot") or lLeg
            local rFoot = char:FindFirstChild("RightFoot") or rLeg

            drawSkeletonBone(lines[1], head, torso)
            drawSkeletonBone(lines[2], torso, root)
            drawSkeletonBone(lines[3], torso, lArm)
            drawSkeletonBone(lines[4], lArm, lHand)
            drawSkeletonBone(lines[5], torso, rArm)
            drawSkeletonBone(lines[6], rArm, rHand)
            drawSkeletonBone(lines[7], root, lLeg)
            drawSkeletonBone(lines[8], lLeg, lFoot)
            drawSkeletonBone(lines[9], root, rLeg)
            drawSkeletonBone(lines[10], rLeg, rFoot)
            for i = 11, #lines do lines[i].Visible = false end
        else
            for _, l in ipairs(lines) do l.Visible = false end
        end
    end
end

-- ==========================================
-- OFF-SCREEN ARROWS ENGINE
-- ==========================================
local function getOrCreateArrow(plr)
    if offScreenArrows[plr] then return offScreenArrows[plr] end
    local arrow = Instance.new("ImageLabel", arrowContainer)
    arrow.Size = UDim2.new(0, arrowSize, 0, arrowSize)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Image = "rbxassetid://6031094678"
    arrow.ImageColor3 = currentTheme.ArrowColor
    arrow.Visible = false
    offScreenArrows[plr] = arrow
    return arrow
end

local function renderOffScreenArrows()
    local vp = camera.ViewportSize
    local screenCenter = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    for _, plr in ipairs(Players:GetPlayers()) do
        local arrow = getOrCreateArrow(plr)
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
        if offScreenArrowsEnabled and char and isTargetEnemy(plr, char) and isEntityAlive(char, hum) and root then
            local _, onScreen = camera:WorldToViewportPoint(root.Position)
            if not onScreen then
                local camCFrame = camera.CFrame
                local dir = (root.Position - camCFrame.Position).Unit
                local forward = camCFrame.LookVector
                local right = camCFrame.RightVector
                local up = camCFrame.UpVector
                
                local dotForward = forward:Dot(dir)
                local dotRight = right:Dot(dir)
                local dotUp = up:Dot(dir)

                local angle = math.atan2(-dotRight, dotUp)
                local arrowPos = screenCenter + Vector2.new(math.sin(angle) * arrowRadius, -math.cos(angle) * arrowRadius)

                arrow.Position = UDim2.new(0, arrowPos.X, 0, arrowPos.Y)
                arrow.Rotation = math.deg(angle) + 180
                arrow.ImageColor3 = currentTheme.ArrowColor
                arrow.Visible = true
            else
                arrow.Visible = false
            end
        else
            arrow.Visible = false
        end
    end
end

-- ==========================================
-- VIEWMODEL CHAMS CONTROLLER
-- ==========================================
local function updateViewmodelChams()
    local char = player.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if viewmodelChamsEnabled then
        if tool then
            for _, p in ipairs(tool:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Material = viewmodelChamsMaterial
                    p.Color = currentTheme.ViewmodelColor
                end
            end
        end
        for _, p in ipairs(char:GetChildren()) do
            if (p.Name:find("Arm") or p.Name:find("Hand")) and p:IsA("BasePart") then
                p.Material = viewmodelChamsMaterial
                p.Color = currentTheme.ViewmodelColor
            end
        end
    end
end

-- ==========================================
-- HITMARKER HEALTH HOOK
-- ==========================================
local function trackEnemiesHealth()
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and isTargetEnemy(plr, char) then
            local lastHp = lastHealthStates[plr] or hum.Health
            if hum.Health < lastHp and isEntityAlive(char, hum) then
                triggerHitmarker()
            end
            lastHealthStates[plr] = hum.Health
        else
            lastHealthStates[plr] = nil
        end
    end
end

-- ==========================================
-- GRENADE & CRYSTAL CHAMS ENGINE
-- ==========================================
local function getOrCreateCrystalChams(plr)
    if chamsCache[plr] then return chamsCache[plr] end
    local hl = Instance.new("Highlight")
    hl.Name = "GestioCrystalOutline_" .. plr.Name
    hl.FillColor = currentTheme.CrystalColor
    hl.OutlineColor = currentTheme.CrystalOutline
    hl.FillTransparency = 1.0
    hl.OutlineTransparency = 0.0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = false
    hl.Parent = worldContainer

    local crystalFolder = Instance.new("Folder")
    crystalFolder.Name = "Crystals_" .. plr.Name
    crystalFolder.Parent = worldContainer

    local crystals, lights = {}, {}
    for i = 1, crystalCount do
        local p = Instance.new("Part")
        p.Name = "RadiantShard"
        p.Size = Vector3.new(0.6, 1.1, 0.6)
        p.Material = Enum.Material.Neon
        p.Color = currentTheme.CrystalColor
        p.CanCollide = false
        p.Anchored = true
        p.CastShadow = false
        p.Transparency = 0.1

        local sm = Instance.new("SpecialMesh", p)
        sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = "rbxassetid://9756362"
        sm.Scale = Vector3.new(0.4, 0.7, 0.4)

        local pl = Instance.new("PointLight")
        pl.Color = currentTheme.CrystalLightColor
        pl.Brightness = crystalLightBrightness
        pl.Range = crystalLightRange
        pl.Shadows = false
        pl.Enabled = true
        pl.Parent = p

        p.Parent = crystalFolder
        table.insert(crystals, p)
        table.insert(lights, pl)
    end
    local data = { Highlight = hl, CrystalFolder = crystalFolder, Crystals = crystals, Lights = lights }
    chamsCache[plr] = data
    return data
end

local grenadeRayParams = RaycastParams.new()
grenadeRayParams.FilterType = Enum.RaycastFilterType.Exclude
grenadeRayParams.IgnoreWater = true

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

    local data = { Tag = tag, Label = lbl, RadiusCircle = radiusCircle, RadiusStroke = radStroke, Lines = {} }
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
        local nName = item.Name:lower()
        local isNade, nadeType, nadeColor, effectRadiusStuds = false, "NADE", currentTheme.HEColor, 14
        if nName:find("molotov") or nName:find("incendiary") or nName:find("fire") then
            isNade, nadeType, nadeColor, effectRadiusStuds = true, "MOLOTOV", currentTheme.MolotovColor, 17
        elseif nName:find("smoke") then
            isNade, nadeType, nadeColor, effectRadiusStuds = true, "SMOKE", currentTheme.SmokeColor, 20
        elseif nName:find("grenade") or nName:find("hegrenade") or nName:find("frag") then
            isNade, nadeType, nadeColor, effectRadiusStuds = true, "HE", currentTheme.HEColor, 15
        elseif nName:find("flash") then
            isNade, nadeType, nadeColor, effectRadiusStuds = true, "FLASH", Color3.fromRGB(245, 235, 120), 10
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
-- TARGETING & OVERLAY MODULES
-- ==========================================
local visRayParams = RaycastParams.new()
visRayParams.FilterType = Enum.RaycastFilterType.Exclude
visRayParams.IgnoreWater = true

local function isTargetVisible(originPos, targetPart, targetChar)
    if not visibleCheck then return true end
    visRayParams.FilterDescendantsInstances = {player.Character, camera}
    local hit = Workspace:Raycast(originPos, targetPart.Position - originPos, visRayParams)
    return hit and (hit.Instance:IsDescendantOf(targetChar) or hit.Instance == targetPart)
end

local function getClosestTarget()
    if not camera then camera = Workspace.CurrentCamera if not camera then return nil end end
    local closestTarget, closestDist = nil, aimFov
    local vp, camPos = camera.ViewportSize, camera.CFrame.Position
    local screenCenter = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    for _, plr in ipairs(Players:GetPlayers()) do
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
                        if screenDist <= closestDist and isTargetVisible(camPos, targetPart, char) then
                            closestDist = screenDist
                            closestTarget = { Player = plr, Char = char, Part = targetPart, Hum = hum, Position = calcPos }
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

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
        local hitPlr = Players:GetPlayerFromCharacter(hitChar) or (hitChar.Parent and Players:GetPlayerFromCharacter(hitChar.Parent))
        if hitPlr and isTargetEnemy(hitPlr, hitChar) and isEntityAlive(hitChar, hitChar:FindFirstChildOfClass("Humanoid")) then
            if triggerbotHeadOnly and res.Instance.Name ~= "Head" then return end
            lastTriggerTick = now
            if triggerbotMobileAutoFire then
                pcall(function()
                    VirtualUser:Button1Down(Vector2.new(0, 0))
                    task.wait(0.02)
                    VirtualUser:Button1Up(Vector2.new(0, 0))
                end)
            end
        end
    end
end

local function getOrCreateScreenEsp(plr)
    if screenEspCache[plr] then return screenEspCache[plr] end
    local box = Instance.new("Frame", overlayContainer)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false

    local stroke = Instance.new("UIStroke", box)
    stroke.Color = currentTheme.T_Accent
    stroke.Thickness = boxThickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local tagCard = Instance.new("Frame", overlayContainer)
    tagCard.AnchorPoint = Vector2.new(0.5, 1)
    tagCard.Size = UDim2.new(0, 0, 0, 16)
    tagCard.AutomaticSize = Enum.AutomaticSize.X
    tagCard.BackgroundColor3 = tagBgColor
    tagCard.BackgroundTransparency = tagTransparency
    tagCard.BorderSizePixel = 0
    tagCard.Visible = false

    Instance.new("UICorner", tagCard).CornerRadius = UDim.new(0, 4)
    local pad = Instance.new("UIPadding", tagCard)
    pad.PaddingRight = UDim.new(0, 5)
    pad.PaddingLeft = UDim.new(0, 5)

    local tagLabel = Instance.new("TextLabel", tagCard)
    tagLabel.AutomaticSize = Enum.AutomaticSize.X
    tagLabel.Size = UDim2.new(0, 0, 1, 0)
    tagLabel.BackgroundTransparency = 1
    tagLabel.TextColor3 = currentTheme.NametagTextColor
    tagLabel.TextSize = espTextSize
    tagLabel.Font = Enum.Font.GothamBold

    local data = { Box = box, BoxStroke = stroke, TagCard = tagCard, TagLabel = tagLabel, LastText = "" }
    screenEspCache[plr] = data
    return data
end

local function renderTacticalOverlay()
    local camPos = camera.CFrame.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        local esp = getOrCreateScreenEsp(plr)
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local rootPart = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        local head = char and char:FindFirstChild("Head")

        if isTargetEnemy(plr, char) and isEntityAlive(char, hum) and rootPart and (nametagsEnabled or boxEspEnabled) then
            local dist = (rootPart.Position - camPos).Magnitude
            if dist <= espMaxDist then
                local topWorld = (head and head.Position or rootPart.Position) + (head and Vector3.new(0, 0.6, 0) or Vector3.new(0, 2.0, 0))
                local bottomWorld = rootPart.Position - Vector3.new(0, 3.0, 0)
                local topScreen, topVisible = camera:WorldToViewportPoint(topWorld)
                local bottomScreen, _ = camera:WorldToViewportPoint(bottomWorld)

                if topVisible and topScreen.Z > 0 then
                    local boxHeight = math.abs(bottomScreen.Y - topScreen.Y)
                    local boxWidth = boxHeight * 0.65
                    local side = getPlayerSide(plr)
                    local sideColor = (side == "T") and currentTheme.T_Accent or currentTheme.CT_Accent

                    if boxEspEnabled then
                        esp.BoxStroke.Color = sideColor
                        esp.BoxStroke.Thickness = boxThickness
                        esp.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                        esp.Box.Position = UDim2.new(0, topScreen.X - (boxWidth * 0.5), 0, topScreen.Y)
                        esp.Box.Visible = true
                    else
                        esp.Box.Visible = false
                    end

                    if nametagsEnabled then
                        esp.TagCard.BackgroundTransparency = tagTransparency
                        esp.TagLabel.TextSize = espTextSize
                        esp.TagLabel.TextColor3 = currentTheme.NametagTextColor

                        local infoText = (espShowTeamTag and string.format("[%s] ", side) or "") .. (plr.DisplayName or plr.Name)
                        if espShowDistance then infoText = string.format("%s [%dm]", infoText, math.floor(dist)) end
                        if espShowHealth and hum then infoText = string.format("%s [%dHP]", infoText, math.max(1, math.floor(hum.Health))) end
                        if tagShowWeapon and char:FindFirstChildOfClass("Tool") then infoText = string.format("%s {%s}", infoText, char:FindFirstChildOfClass("Tool").Name) end

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
                    esp.TagCard.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.TagCard.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.TagCard.Visible = false
        end
    end
end

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
    dotFrame.BackgroundColor3 = currentTheme.T_Accent
    dotFrame.BorderSizePixel = 0
    Instance.new("UICorner", dotFrame).CornerRadius = UDim.new(1, 0)

    local tracerLine = Instance.new("Frame", mainContainer)
    tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
    tracerLine.BorderSizePixel = 0
    tracerLine.BackgroundColor3 = currentTheme.T_Accent
    tracerLine.Visible = false

    local hl = Instance.new("Highlight", worldContainer)
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0.0
    hl.Enabled = false
    hl.FillColor = currentTheme.T_Fill
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    activeEspHolders[plr] = { Holder = holder, HeadDot = dotBillboard, DotFrame = dotFrame, Tracer = tracerLine, Highlight = hl }

    local function setupCharacter(char)
        if not char then return end
        task.spawn(function()
            local head = char:WaitForChild("Head", 3)
            if head and dotBillboard then dotBillboard.Adornee = head end
            if hl then hl.Adornee = char end
            local ch = getOrCreateCrystalChams(plr)
            if ch then ch.Highlight.Adornee = char end
        end)
    end
    if plr.Character then setupCharacter(plr.Character) end
    plr.CharacterAdded:Connect(setupCharacter)
end

for _, v in pairs(Players:GetPlayers()) do attachEspToPlayer(v) end
table.insert(connections, Players.PlayerAdded:Connect(attachEspToPlayer))

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    if not camera then camera = Workspace.CurrentCamera return end
    local localPos = camera.CFrame.Position

    fpsCounter = fpsCounter + 1
    local nowTick = tick()
    if nowTick - lastFpsUpdate >= 0.5 then
        local pingVal = 0
        pcall(function()
            local serverStats = Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem")
            if serverStats and serverStats:FindFirstChild("Data Ping") then
                pingVal = math.floor(serverStats["Data Ping"]:GetValue())
            end
        end)
        wmMetrics.Text = string.format("FPS: %d | PING: %dms", math.floor(fpsCounter / (nowTick - lastFpsUpdate)), pingVal)
        fpsCounter = 0
        lastFpsUpdate = nowTick
    end

    if fovFrame then
        local isFovVisible = aimbotEnabled and showFovCircle
        fovFrame.Visible = isFovVisible
        if isFovVisible then fovFrame.Size = UDim2.new(0, aimFov * 2, 0, aimFov * 2) end
    end

    if rcsEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        camera.CFrame = camera.CFrame * CFrame.Angles((rcsStrength / 100) * 0.005 * rcsPitchFactor, 0, 0)
    end

    if aimbotEnabled and isAiming then
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
    renderGrenadeOverlays()
    renderSkeletonESP()
    renderOffScreenArrows()
    trackEnemiesHealth()
    updateViewmodelChams()

    -- Thirdperson Camera
    if thirdpersonEnabled then
        player.CameraMinZoomDistance = thirdpersonDistance
        player.CameraMaxZoomDistance = thirdpersonDistance
    else
        player.CameraMinZoomDistance = 0.5
        player.CameraMaxZoomDistance = 400
    end

    local timeTick = tick() * crystalOrbitSpeed
    local pulse = (math.sin(tick() * 5.0) + 1) * 0.5

    for plr, data in pairs(activeEspHolders) do
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local rootPart = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        local head = char and char:FindFirstChild("Head")
        local isEnemy = isTargetEnemy(plr, char)
        local isAlive = isEntityAlive(char, hum)
        local dist = rootPart and (rootPart.Position - localPos).Magnitude or 9999
        local chams = getOrCreateCrystalChams(plr)

        if char and isEnemy and isAlive and (dist <= espMaxDist) then
            local side = getPlayerSide(plr)
            local activeAccent = (side == "T") and currentTheme.T_Accent or currentTheme.CT_Accent

            if data.Highlight.Adornee ~= char then data.Highlight.Adornee = char end
            if head and data.HeadDot.Adornee ~= head then data.HeadDot.Adornee = head end
            data.Highlight.FillColor = (side == "T") and currentTheme.T_Fill or currentTheme.CT_Fill
            data.Highlight.Enabled = highlightEnabled
            data.DotFrame.BackgroundColor3 = activeAccent
            data.HeadDot.Enabled = headDotEnabled

            if chams then
                if chams.Highlight.Adornee ~= char then chams.Highlight.Adornee = char end
                chams.Highlight.Enabled = chamsEnabled
                if chamsEnabled and rootPart then
                    local rootPos = rootPart.Position
                    local count = #chams.Crystals
                    for idx, shard in ipairs(chams.Crystals) do
                        local currentAngle = timeTick + ((idx / count) * (math.pi * 2))
                        shard.CFrame = CFrame.new(rootPos + Vector3.new(math.cos(currentAngle) * crystalOrbitRadius, math.sin(timeTick * 1.5 + idx) * 0.75, math.sin(currentAngle) * crystalOrbitRadius)) * CFrame.Angles(timeTick, currentAngle, 0)
                        shard.Transparency = 0.1
                        local light = chams.Lights[idx]
                        if light then
                            light.Enabled = crystalLightEnabled
                            light.Brightness = crystalLightBrightness + (pulse * 2.5)
                            light.Range = crystalLightRange
                        end
                    end
                else
                    for idx, shard in ipairs(chams.Crystals) do
                        shard.Transparency = 1.0
                        if chams.Lights[idx] then chams.Lights[idx].Enabled = false end
                    end
                end
            end

            if tracersEnabled and rootPart then
                local scrPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                if onScreen and scrPos.Z > 0 then
                    local origin = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y)
                    local dest = Vector2.new(scrPos.X, scrPos.Y)
                    data.Tracer.BackgroundColor3 = activeAccent
                    data.Tracer.Size = UDim2.new(0, (dest - origin).Magnitude, 0, 1.5)
                    data.Tracer.Position = UDim2.new(0, (origin + dest).X * 0.5, 0, (origin + dest).Y * 0.5)
                    data.Tracer.Rotation = math.deg(math.atan2(dest.Y - origin.Y, dest.X - origin.X))
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
            if chams then
                chams.Highlight.Enabled = false
                for idx, shard in ipairs(chams.Crystals) do
                    shard.Transparency = 1.0
                    if chams.Lights[idx] then chams.Lights[idx].Enabled = false end
                end
            end
        end
    end

    if fullBrightEnabled then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    elseif nightModeEnabled then
        Lighting.Brightness = nightBrightness
        Lighting.ClockTime = nightClockTime
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = nightOutdoorAmbient
    end

    if removeFogEnabled then Lighting.FogEnd = 100000 end
    if antiFlashEnabled then
        pcall(function()
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("ColorCorrectionEffect") and v.Saturation < -0.5 then v.Enabled = false end
            end
        end)
    end
end))

-- Bullet Tracers Input Hook
UserInputService.InputBegan:Connect(function(input, gpe)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not gpe then
        if bulletTracersEnabled then
            local mouseRay = camera:ViewportPointToRay(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y * 0.5)
            local myChar = player.Character
            visRayParams.FilterDescendantsInstances = {myChar, camera}
            local hit = Workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, visRayParams)
            local endPoint = hit and hit.Position or (mouseRay.Origin + mouseRay.Direction * 200)
            local startPoint = (myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position) or (mouseRay.Origin - Vector3.new(0, 1, 0))
            createBulletTracer(startPoint, endPoint)
        end
    end
end)

-- Movement Controller Loop
local groundRayParams = RaycastParams.new()
groundRayParams.FilterType = Enum.RaycastFilterType.Exclude
groundRayParams.IgnoreWater = true

table.insert(connections, RunService.Heartbeat:Connect(function(dt)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or not isEntityAlive(char, hum) then return end

    if hum.MoveDirection.Magnitude > 0.05 then lastMoveDirection = hum.MoveDirection end

    if bunnyHopEnabled then
        groundRayParams.FilterDescendantsInstances = {char, camera}
        local grounded = Workspace:Raycast(hrp.Position, Vector3.new(0, -3.2, 0), groundRayParams) ~= nil or hum.FloorMaterial ~= Enum.Material.Air
        if hum.MoveDirection.Magnitude > 0.05 or lastMoveDirection.Magnitude > 0.05 then
            local activeDirection = hum.MoveDirection.Magnitude > 0.05 and hum.MoveDirection or lastMoveDirection
            if grounded and bhopAutoJump then
                hum.Jump = true
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, bhopJumpPower, hrp.AssemblyLinearVelocity.Z)
            elseif not grounded and bhopAirStrafe then
                local targetSpeed = 16 * bhopSpeedBoost
                local targetVel = activeDirection * targetSpeed
                hrp.AssemblyLinearVelocity = Vector3.new(targetVel.X, hrp.AssemblyLinearVelocity.Y, targetVel.Z)
            end
        end
    end

    if speedEnabled and hum.MoveDirection.Magnitude > 0 then
        local targetVel = hum.MoveDirection * (16 * walkMultiplier)
        hrp.AssemblyLinearVelocity = Vector3.new(targetVel.X, hrp.AssemblyLinearVelocity.Y, targetVel.Z)
    end

    if flightEnabled then
        hrp.AssemblyLinearVelocity = camera.CFrame.LookVector * flightSpeed
    end
end))

-- ==========================================
-- RESPONSIVE USER INTERFACE (TOUCH READY)
-- ==========================================
local toggleGui = Instance.new("ScreenGui", targetGui)
toggleGui.Name = "GestioToggleGui"
toggleGui.ResetOnSpawn = false
toggleGui.DisplayOrder = 100
toggleGui.IgnoreGuiInset = true

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

local screenGui = Instance.new("ScreenGui", targetGui)
screenGui.Name = "GestioScreenGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 50
screenGui.IgnoreGuiInset = true

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

local function toggleMenu() masterFrame.Visible = not masterFrame.Visible end

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
            if (input.Position - btnInputStart).Magnitude < 15 then toggleMenu() end
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
local vBtn = createNavBtn(98, "VISUALS")
local envBtn = createNavBtn(120, "ENV")
local micsBtn = createNavBtn(142, "SETTINGS")
cBtn.BackgroundColor3 = currentTheme.CardBg
cBtn.TextColor3 = currentTheme.Accent

local function makeGridContainer()
    local c = Instance.new("ScrollingFrame", mainFrame)
    c.Size = UDim2.new(1, -82, 1, -12)
    c.Position = UDim2.new(0, 78, 0, 6)
    c.BackgroundTransparency = 1
    c.ScrollBarThickness = 2
    c.CanvasSize = UDim2.new(0, 0, 0, 600)
    c.Visible = false
    c.ZIndex = 6

    local grid = Instance.new("UIGridLayout", c)
    grid.CellSize = UDim2.new(0, 60, 0, 60)
    grid.CellPadding = UDim2.new(0, 5, 0, 5)

    local pad = Instance.new("UIPadding", c)
    pad.PaddingLeft = UDim.new(0, 3)
    pad.PaddingTop = UDim.new(0, 3)
    return c
end

local cPage = makeGridContainer()
local mPage = makeGridContainer()
local ePage = makeGridContainer()
local vPage = makeGridContainer()
local envPage = makeGridContainer()
local micsPage = makeGridContainer()
cPage.Visible = true

local function switch(tab)
    cPage.Visible = (tab == "C")
    mPage.Visible = (tab == "M")
    ePage.Visible = (tab == "E")
    vPage.Visible = (tab == "V")
    envPage.Visible = (tab == "ENV")
    micsPage.Visible = (tab == "MICS")

    local btns = {{cBtn, "C"}, {mBtn, "M"}, {eBtn, "E"}, {vBtn, "V"}, {envBtn, "ENV"}, {micsBtn, "MICS"}}
    for _, item in ipairs(btns) do
        local on = (item[2] == tab)
        item[1].BackgroundColor3 = on and currentTheme.CardBg or currentTheme.Sidebar
        item[1].TextColor3 = on and currentTheme.Accent or currentTheme.TextSecondary
    end
end

bindTouch(cBtn, function() switch("C") end)
bindTouch(mBtn, function() switch("M") end)
bindTouch(eBtn, function() switch("E") end)
bindTouch(vBtn, function() switch("V") end)
bindTouch(envBtn, function() switch("ENV") end)
bindTouch(micsBtn, function() switch("MICS") end)

local inspectorPanel = Instance.new("Frame", masterFrame)
inspectorPanel.Size = UDim2.new(0.40, 0, 1, 0)
inspectorPanel.BackgroundColor3 = currentTheme.Background
inspectorPanel.BorderSizePixel = 0
inspectorPanel.ZIndex = 5
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
        local pct = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X) / track.AbsoluteSize.X
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
    bindTouch(btn, function()
        state = not state
        btn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
        circle.Position = state and UDim2.new(1, -11, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
        onToggle(state)
    end)
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
    elseif moduleName == "Crosshair" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 200)
        addInspectorSlider(6, "Size", 2, 20, crosshairSize, false, function(v) crosshairSize = v updateCrosshairStyle() end)
        addInspectorSlider(38, "Gap", 0, 15, crosshairGap, false, function(v) crosshairGap = v updateCrosshairStyle() end)
        addInspectorSlider(70, "Thickness", 1, 5, crosshairThickness, false, function(v) crosshairThickness = v updateCrosshairStyle() end)
        addInspectorToggle(108, "Center Dot", crosshairDot, function(v) crosshairDot = v updateCrosshairStyle() end)
    elseif moduleName == "Thirdperson" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorSlider(6, "Distance", 4, 30, thirdpersonDistance, false, function(v) thirdpersonDistance = v end)
    elseif moduleName == "Arrows" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 120)
        addInspectorSlider(6, "Radius", 60, 300, arrowRadius, false, function(v) arrowRadius = v end)
        addInspectorSlider(38, "Arrow Size", 8, 30, arrowSize, false, function(v) arrowSize = v for _, a in pairs(offScreenArrows) do a.Size = UDim2.new(0, v, 0, v) end end)
    elseif moduleName == "Skeleton" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorSlider(6, "Thickness", 1.0, 4.0, skeletonThickness, true, function(v) skeletonThickness = v end)
    elseif moduleName == "Hitmarkers" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorToggle(6, "Hit Sound", hitmarkerSoundEnabled, function(v) hitmarkerSoundEnabled = v end)
    elseif moduleName == "Bullet Beams" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorSlider(6, "Duration", 0.1, 2.0, tracerBeamDuration, true, function(v) tracerBeamDuration = v end)
    elseif moduleName == "Crystal Chams" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 240)
        addInspectorSlider(6, "Orbit Speed", 1.0, 10.0, crystalOrbitSpeed, true, function(v) crystalOrbitSpeed = v end)
        addInspectorSlider(38, "Orbit Radius", 2.0, 6.0, crystalOrbitRadius, true, function(v) crystalOrbitRadius = v end)
        addInspectorSlider(70, "Light Brightness", 1.0, 15.0, crystalLightBrightness, true, function(v) crystalLightBrightness = v end)
        addInspectorSlider(102, "Light Range", 4, 30, crystalLightRange, false, function(v) crystalLightRange = v end)
        addInspectorToggle(140, "Crystal Light (Aura)", crystalLightEnabled, function(v) crystalLightEnabled = v end)
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
        addInspectorToggle(76, "Auto Jump", bhopAutoJump, function(v) bhopAutoJump = v end)
        addInspectorToggle(102, "Air Strafe", bhopAirStrafe, function(v) bhopAirStrafe = v end)
    elseif moduleName == "Nametags" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 340)
        addInspectorSlider(6, "Max Distance", 100, 5000, espMaxDist, false, function(v) espMaxDist = v end)
        addInspectorSlider(38, "Text Size", 8, 20, espTextSize, false, function(v) espTextSize = v end)
        addInspectorSlider(70, "Transparency", 0.0, 0.9, tagTransparency, true, function(v) tagTransparency = v end)
        addInspectorToggle(108, "Show Distance", espShowDistance, function(v) espShowDistance = v end)
        addInspectorToggle(134, "Show Health", espShowHealth, function(v) espShowHealth = v end)
        addInspectorToggle(160, "Show Team Tag", espShowTeamTag, function(v) espShowTeamTag = v end)
        addInspectorToggle(186, "Show Weapon", tagShowWeapon, function(v) tagShowWeapon = v end)
    elseif moduleName == "Night Mode" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 150)
        addInspectorSlider(6, "Clock Time", 0, 24, nightClockTime, false, function(v) nightClockTime = v end)
        addInspectorSlider(38, "Brightness", 0.0, 2.0, nightBrightness, true, function(v) nightBrightness = v end)
    elseif moduleName == "RCS" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 240)
        addInspectorSlider(6, "RCS Strength", 10, 100, rcsStrength, false, function(v) rcsStrength = v end)
        addInspectorSlider(38, "Pitch Factor", 0.1, 2.0, rcsPitchFactor, true, function(v) rcsPitchFactor = v end)
    elseif moduleName == "Trigger Assistant" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 150)
        addInspectorSlider(6, "Trigger Delay", 0.0, 0.2, triggerbotDelay, true, function(v) triggerbotDelay = v end)
        addInspectorToggle(44, "Head Only", triggerbotHeadOnly, function(v) triggerbotHeadOnly = v end)
        addInspectorToggle(70, "Auto Trigger", triggerbotMobileAutoFire, function(v) triggerbotMobileAutoFire = v end)
    end
end

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
    bindTouch(toggleBtn, function()
        state = not state
        toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
        circle.Position = state and UDim2.new(1, -10, 0.5, -4.5) or UDim2.new(0, 2, 0.5, -4.5)
        onToggle(state)
        
        if name == "Night Mode" and not state and not fullBrightEnabled then
            pcall(function()
                Lighting.Brightness = defaultLighting.Brightness
                Lighting.ClockTime = defaultLighting.ClockTime
                Lighting.GlobalShadows = defaultLighting.GlobalShadows
                Lighting.Ambient = defaultLighting.Ambient
                Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
            end)
        elseif name == "FullBright" and not state and not nightModeEnabled then
            pcall(function()
                Lighting.Brightness = defaultLighting.Brightness
                Lighting.ClockTime = defaultLighting.ClockTime
                Lighting.GlobalShadows = defaultLighting.GlobalShadows
            end)
        end
    end)
end

-- Tab Registration
addCard(cPage, "Tracking", aimbotEnabled, function(v) aimbotEnabled = v end)
addCard(cPage, "RCS", rcsEnabled, function(v) rcsEnabled = v end)
addCard(cPage, "Trigger Assistant", triggerbotEnabled, function(v) triggerbotEnabled = v end)

addCard(mPage, "Bhop Engine", bunnyHopEnabled, function(v) bunnyHopEnabled = v end)
addCard(mPage, "Speed Boost", speedEnabled, function(v) speedEnabled = v end)
addCard(mPage, "Flight", flightEnabled, function(v) flightEnabled = v end)

addCard(ePage, "Nametags", nametagsEnabled, function(v) nametagsEnabled = v end)
addCard(ePage, "Skeleton", skeletonEspEnabled, function(v) skeletonEspEnabled = v end)
addCard(ePage, "Arrows", offScreenArrowsEnabled, function(v) offScreenArrowsEnabled = v end)
addCard(ePage, "Crystal Chams", chamsEnabled, function(v) chamsEnabled = v end)
addCard(ePage, "Highlight", highlightEnabled, function(v) highlightEnabled = v end)
addCard(ePage, "Box Overlay", boxEspEnabled, function(v) boxEspEnabled = v end)
addCard(ePage, "Head Dot", headDotEnabled, function(v) headDotEnabled = v end)
addCard(ePage, "Snaplines", tracersEnabled, function(v) tracersEnabled = v end)
addCard(ePage, "Grenade ESP", grenadeEspEnabled, function(v) grenadeEspEnabled = v end)

addCard(vPage, "Crosshair", customCrosshairEnabled, function(v) customCrosshairEnabled = v updateCrosshairStyle() end)
addCard(vPage, "Hitmarkers", hitmarkerEnabled, function(v) hitmarkerEnabled = v end)
addCard(vPage, "Bullet Beams", bulletTracersEnabled, function(v) bulletTracersEnabled = v end)
addCard(vPage, "Hand Chams", viewmodelChamsEnabled, function(v) viewmodelChamsEnabled = v end)
addCard(vPage, "Thirdperson", thirdpersonEnabled, function(v) thirdpersonEnabled = v end)

addCard(envPage, "Night Mode", nightModeEnabled, function(v) nightModeEnabled = v end)
addCard(envPage, "FullBright", fullBrightEnabled, function(v) fullBrightEnabled = v end)
addCard(envPage, "Anti-Flash", antiFlashEnabled, function(v) antiFlashEnabled = v end)

addCard(micsPage, "Anti-AFK", true, function(v) end)
addCard(micsPage, "Theme Sync", true, function(v) end)

updateCrosshairStyle()
openInspectorFor("Tracking")
