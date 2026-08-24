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
local jumpCircles = {}

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
    
    T_Accent = Color3.fromRGB(210, 45, 55),
    T_Fill = Color3.fromRGB(210, 45, 55),
    CT_Accent = Color3.fromRGB(75, 80, 92),
    CT_Fill = Color3.fromRGB(45, 48, 55),
    NametagTextColor = Color3.fromRGB(255, 45, 55),
    
    MolotovColor = Color3.fromRGB(255, 95, 35),
    SmokeColor = Color3.fromRGB(180, 185, 195),
    HEColor = Color3.fromRGB(255, 45, 55),

    CrosshairColor = Color3.fromRGB(210, 45, 55),
    HitmarkerColor = Color3.fromRGB(255, 255, 255),
    SkeletonColor = Color3.fromRGB(210, 45, 55),
    ArrowColor = Color3.fromRGB(210, 45, 55),
    BeamColor = Color3.fromRGB(210, 45, 55),
    ViewmodelColor = Color3.fromRGB(210, 45, 55),

    CrystalColor = Color3.fromRGB(255, 15, 35),
    CrystalOutline = Color3.fromRGB(255, 45, 65),
    CrystalLightColor = Color3.fromRGB(255, 0, 25)
}

-- ==========================================
-- MODULE CONFIGURATION & STYLES
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
local boxMode = "2D Full"

local jumpCircleEnabled = false
local jumpCircleMode = "Gradient Fade"
local jumpCircleRadius = 6.0
local jumpCircleDuration = 0.85

local playerTrailEnabled = false
local playerTrailMode = "Speed-Based Fade"

local grenadeTrailEnabled = false
local grenadeTrailMode = "Glow Rope"

local bulletTracersEnabled = false
local bulletTracerMode = "Beam Tracers"
local tracerBeamDuration = 0.65

-- Advanced Chams Styles
local advancedChamsEnabled = false
local advancedChamsStyle = "Glow" -- "Glow", "Metallic / Gold", "Glass / Crystal", "Wireframe", "Flat", "Animated / Texture"

local skeletonEspEnabled = false
local skeletonThickness = 1.2

local offScreenArrowsEnabled = false
local arrowSize = 14

local customCrosshairEnabled = false
local crosshairGap = 4
local crosshairSize = 6
local crosshairThickness = 2
local crosshairDot = true

local hitmarkerEnabled = false
local hitmarkerSoundEnabled = true
local hitmarkerSoundId = "rbxassetid://4817809188"

local viewmodelChamsEnabled = false
local viewmodelChamsMaterial = Enum.Material.ForceField

local thirdpersonEnabled = false
local thirdpersonDistance = 12

local chamsEnabled = false
local crystalOrbitSpeed = 3.5
local crystalOrbitRadius = 3.2
local crystalCount = 4
local crystalLightEnabled = true
local crystalLightBrightness = 4.0
local crystalLightRange = 12

local grenadeEspEnabled = false
local showGrenadePath = true
local showMolotovRadius = true
local showSmokeRadius = true
local grenadeMaxDist = 1500

local aimbotEnabled = false
local aimbotSpeed = 25.0
local aimbotSmoothness = 0.05
local aimFov = 160
local showFovCircle = true
local snapAimMode = false
local isAiming = false
local lockedTarget = nil
local aimboneIndex = 1
local bodyAimOnly = false
local predictionEnabled = true
local predictionFactor = 0.085
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
local effectContainer = Instance.new("Folder", mainContainer)
effectContainer.Name = "Gestio_Effects3D"
effectContainer.Parent = Workspace

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

local function createBulletTracer(origin, hitPosition, isHit)
    if not bulletTracersEnabled then return end
    local part = Instance.new("Part")
    part.Name = "GestioBeamTracer"
    part.Anchored = true
    part.CanCollide = false
    part.CastShadow = false
    part.Material = Enum.Material.Neon
    part.Color = isHit and currentTheme.T_Accent or currentTheme.BeamColor
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

local function spawnJumpCircle(pos)
    if not jumpCircleEnabled then return end
    local part = Instance.new("Part")
    part.Name = "GestioJumpCircle"
    part.Anchored = true
    part.CanCollide = false
    part.CastShadow = false
    part.Transparency = 1
    part.Position = pos - Vector3.new(0, 2.5, 0)
    part.Parent = effectContainer

    if jumpCircleMode == "Gradient Fade" then
        local cyl = Instance.new("Part")
        cyl.Size = Vector3.new(0.2, 0.1, 0.1)
        cyl.Shape = Enum.PartType.Cylinder
        cyl.Material = Enum.Material.Neon
        cyl.Color = currentTheme.Accent
        cyl.Anchored = true
        cyl.CanCollide = false
        cyl.CastShadow = false
        cyl.CFrame = part.CFrame * CFrame.Angles(0, 0, math.rad(90))
        cyl.Parent = part
        task.spawn(function()
            local startTick = tick()
            while true do
                local alpha = (tick() - startTick) / jumpCircleDuration
                if alpha >= 1 then break end
                local curR = jumpCircleRadius * alpha
                cyl.Size = Vector3.new(0.2, curR * 2, curR * 2)
                cyl.Transparency = alpha
                task.wait()
            end
            part:Destroy()
        end)
    elseif jumpCircleMode == "Blur & Neon" then
        local ring = Instance.new("Part")
        ring.Size = Vector3.new(0.4, 0.2, 0.2)
        ring.Shape = Enum.PartType.Cylinder
        ring.Material = Enum.Material.Glass
        ring.Color = currentTheme.Accent
        ring.Anchored = true
        ring.CanCollide = false
        ring.Transparency = 0.2
        ring.CFrame = part.CFrame * CFrame.Angles(0, 0, math.rad(90))
        ring.Parent = part
        local pl = Instance.new("PointLight", ring)
        pl.Color = currentTheme.Accent
        pl.Range = 14
        pl.Brightness = 6
        task.spawn(function()
            local startTick = tick()
            while true do
                local alpha = (tick() - startTick) / jumpCircleDuration
                if alpha >= 1 then break end
                local curR = (jumpCircleRadius * 1.2) * alpha
                ring.Size = Vector3.new(0.4, curR * 2, curR * 2)
                ring.Transparency = 0.2 + (0.8 * alpha)
                pl.Brightness = 6 * (1 - alpha)
                task.wait()
            end
            part:Destroy()
        end)
    elseif jumpCircleMode == "Particle Ring" then
        local sparks = {}
        for i = 1, 16 do
            local sp = Instance.new("Part")
            sp.Size = Vector3.new(0.25, 0.25, 0.25)
            sp.Shape = Enum.PartType.Ball
            sp.Material = Enum.Material.Neon
            sp.Color = currentTheme.Accent
            sp.Anchored = true
            sp.CanCollide = false
            sp.Position = part.Position
            sp.Parent = part
            table.insert(sparks, {Part = sp, Angle = (i / 16) * (math.pi * 2), Speed = math.random(8, 14)})
        end
        task.spawn(function()
            local startTick = tick()
            while true do
                RunService.RenderStepped:Wait()
                local alpha = (tick() - startTick) / jumpCircleDuration
                if alpha >= 1 then break end
                for _, s in ipairs(sparks) do
                    local dist = s.Speed * alpha * jumpCircleRadius * 0.4
                    local x = math.cos(s.Angle) * dist
                    local z = math.sin(s.Angle) * dist
                    s.Part.Position = part.Position + Vector3.new(x, alpha * 1.5, z)
                    s.Part.Transparency = alpha
                end
            end
            part:Destroy()
        end)
    elseif jumpCircleMode == "Textured / Wave" then
        local wave = Instance.new("Part")
        wave.Size = Vector3.new(0.3, 0.1, 0.1)
        wave.Shape = Enum.PartType.Cylinder
        wave.Material = Enum.Material.Neon
        wave.Color = currentTheme.T_Accent
        wave.Anchored = true
        wave.CanCollide = false
        wave.CFrame = part.CFrame * CFrame.Angles(0, 0, math.rad(90))
        wave.Parent = part
        task.spawn(function()
            local startTick = tick()
            while true do
                local alpha = (tick() - startTick) / jumpCircleDuration
                if alpha >= 1 then break end
                local curR = jumpCircleRadius * math.sin(alpha * math.pi * 1.5)
                wave.Size = Vector3.new(0.3, curR * 2, curR * 2)
                wave.Transparency = alpha
                task.wait()
            end
            part:Destroy()
        end)
    end
end

-- ==========================================
-- ADVANCED CHAMS APPLIER
-- ==========================================
local function applyAdvancedChams(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if advancedChamsEnabled then
                if advancedChamsStyle == "Glow" then
                    part.Material = Enum.Material.Neon
                    part.Color = currentTheme.T_Accent
                elseif advancedChamsStyle == "Metallic / Gold" then
                    part.Material = Enum.Material.Metal
                    part.Color = Color3.fromRGB(255, 215, 0)
                elseif advancedChamsStyle == "Glass / Crystal" then
                    part.Material = Enum.Material.Glass
                    part.Transparency = 0.3
                    part.Color = currentTheme.CrystalColor
                elseif advancedChamsStyle == "Wireframe" then
                    part.Material = Enum.Material.SmoothPlastic
                    part.Color = currentTheme.T_Accent
                elseif advancedChamsStyle == "Flat" then
                    part.Material = Enum.Material.SmoothPlastic
                    part.Color = currentTheme.T_Accent
                elseif advancedChamsStyle == "Animated / Texture" then
                    part.Material = Enum.Material.ForceField
                    part.Color = Color3.fromHSV((tick() % 3) / 3, 1, 1)
                end
            end
        end
    end
end

table.insert(connections, RunService.RenderStepped:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if playerTrailEnabled and hrp then
        if playerTrailMode == "Speed-Based Fade" and hrp.AssemblyLinearVelocity.Magnitude > 8 then
            local trailPart = Instance.new("Part")
            trailPart.Size = Vector3.new(2, 4, 1)
            trailPart.CFrame = hrp.CFrame
            trailPart.Anchored = true
            trailPart.CanCollide = false
            trailPart.Material = Enum.Material.Glass
            trailPart.Color = currentTheme.T_Accent
            trailPart.Transparency = 0.4
            trailPart.Parent = effectContainer
            task.spawn(function()
                for i = 1, 10 do
                    trailPart.Transparency = 0.4 + (0.6 * (i / 10))
                    task.wait(0.03)
                end
                trailPart:Destroy()
            end)
        elseif playerTrailMode == "RGB Rainbow Wave" then
            local trailPart = Instance.new("Part")
            trailPart.Size = Vector3.new(1.5, 3, 1)
            trailPart.CFrame = hrp.CFrame
            trailPart.Anchored = true
            trailPart.CanCollide = false
            trailPart.Material = Enum.Material.Neon
            trailPart.Color = Color3.fromHSV((tick() % 5) / 5, 1, 1)
            trailPart.Transparency = 0.3
            trailPart.Parent = effectContainer
            task.spawn(function()
                for i = 1, 8 do
                    trailPart.Transparency = 0.3 + (0.7 * (i / 8))
                    task.wait(0.04)
                end
                trailPart:Destroy()
            end)
        elseif playerTrailMode == "Wireframe / Mesh" and hrp.AssemblyLinearVelocity.Magnitude > 5 then
            local ghost = Instance.new("Part")
            ghost.Size = Vector3.new(2, 5, 2)
            ghost.CFrame = hrp.CFrame
            ghost.Anchored = true
            ghost.CanCollide = false
            ghost.Material = Enum.Material.ForceField
            ghost.Color = currentTheme.Accent
            ghost.Transparency = 0.5
            ghost.Parent = effectContainer
            task.spawn(function()
                for i = 1, 12 do
                    ghost.Transparency = 0.5 + (0.5 * (i / 12))
                    task.wait(0.04)
                end
                ghost:Destroy()
            end)
        end
    end

    if grenadeTrailEnabled then
        for _, item in ipairs(Workspace:GetDescendants()) do
            if item:IsA("BasePart") and (item.Name:lower():find("grenade") or item.Name:lower():find("molotov") or item.Name:lower():find("smoke") or item.Name:lower():find("flash")) then
                if item.AssemblyLinearVelocity.Magnitude > 3 then
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(0.4, 0.4, 0.4)
                    p.Shape = Enum.PartType.Ball
                    p.Material = Enum.Material.Neon
                    p.Color = (grenadeTrailMode == "Glow Rope") and currentTheme.MolotovColor or Color3.fromRGB(255, 255, 255)
                    p.Position = item.Position
                    p.Anchored = true
                    p.CanCollide = false
                    p.Parent = effectContainer
                    task.spawn(function()
                        for i = 1, 10 do
                            p.Transparency = i / 10
                            task.wait(0.03)
                        end
                        p:Destroy()
                    end)
                end
            end
        end
    end

    if advancedChamsEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and isTargetEnemy(p, p.Character) then
                applyAdvancedChams(p.Character)
            end
        end
    end
end))

local lastJumpTick = 0
table.Inst = table.insert
table.insert(connections, RunService.RenderStepped:Connect(function()
    if not jumpCircleEnabled then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if char and hrp and hum then
        local state = nil
        pcall(function() state = hum:GetState() end)
        if state == Enum.HumanoidStateType.Jumping or (hrp.AssemblyLinearVelocity.Y > 2 and hum.FloorMaterial == Enum.Material.Air) then
            if (tick() - lastJumpTick) > 0.4 then
                lastJumpTick = tick()
                spawnJumpCircle(hrp.Position)
            end
        end
    end
end))

local function cleanup()
    for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
    for _, holder in pairs(activeEspHolders) do
        pcall(function() holder.Holder:Destroy() end)
        if holder.Highlight then pcall(function() holder.Highlight:Destroy() end) end
    end
    for _, esp in pairs(screenEspCache) do
        pcall(function()
            for _, p in pairs(esp.Parts) do p:Destroy() end
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
    pcall(function() effectContainer:Destroy() end)
    pcall(function()
        player.CameraMinZoomDistance = 0.5
        player.CameraMaxZoomDistance = 400
        player.CameraMode = Enum.CameraMode.Classic
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
    pcall(function() if targetGui:FindFirstChild("GestioFovGui") then targetGui.FovGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioWatermarkGui") then targetGui.WatermarkGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioMainContainer") then targetGui.GestioMainContainer:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioHitmarkerGui") then targetGui.HitmarkerGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("GestioCrosshairGui") then targetGui.CrosshairGui:Destroy() end end)
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

local function getOrCreateScreenEsp(plr)
    if screenEspCache[plr] then return screenEspCache[plr] end
    local parts = {}
    for i = 1, 8 do
        local line = Instance.new("Frame", overlayContainer)
        line.BackgroundColor3 = currentTheme.T_Accent
        line.BorderSizePixel = 0
        line.Visible = false
        table.insert(parts, line)
    end
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
    local data = { Parts = parts, TagCard = tagCard, TagLabel = tagLabel, LastText = "" }
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
                    local boxPosX = topScreen.X - (boxWidth * 0.5)
                    local boxPosY = topScreen.Y
                    local side = getPlayerSide(plr)
                    local sideColor = (side == "T") and currentTheme.T_Accent or currentTheme.CT_Accent

                    if boxEspEnabled then
                        for _, p in ipairs(esp.Parts) do p.Visible = false end
                        if boxMode == "2D Full" then
                            local line = esp.Parts[1]
                            line.Size = UDim2.new(0, boxWidth, 0, boxThickness)
                            line.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                            line.BackgroundColor3 = sideColor
                            line.Visible = true

                            local line2 = esp.Parts[2]
                            line2.Size = UDim2.new(0, boxWidth, 0, boxThickness)
                            line2.Position = UDim2.new(0, boxPosX, 0, boxPosY + boxHeight)
                            line2.BackgroundColor3 = sideColor
                            line2.Visible = true

                            local line3 = esp.Parts[3]
                            line3.Size = UDim2.new(0, boxThickness, 0, boxHeight)
                            line3.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                            line3.BackgroundColor3 = sideColor
                            line3.Visible = true

                            local line4 = esp.Parts[4]
                            line4.Size = UDim2.new(0, boxThickness, 0, boxHeight)
                            line4.Position = UDim2.new(0, boxPosX + boxWidth, 0, boxPosY)
                            line4.BackgroundColor3 = sideColor
                            line4.Visible = true
                        elseif boxMode == "2D Corner" then
                            local cLenX = math.max(4, boxWidth * 0.25)
                            local cLenY = math.max(4, boxHeight * 0.25)

                            local tl1 = esp.Parts[1]
                            tl1.Size = UDim2.new(0, cLenX, 0, boxThickness)
                            tl1.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                            tl1.BackgroundColor3 = sideColor
                            tl1.Visible = true

                            local tl2 = esp.Parts[2]
                            tl2.Size = UDim2.new(0, boxThickness, 0, cLenY)
                            tl2.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                            tl2.BackgroundColor3 = sideColor
                            tl2.Visible = true

                            local tr1 = esp.Parts[3]
                            tr1.Size = UDim2.new(0, cLenX, 0, boxThickness)
                            tr1.Position = UDim2.new(0, boxPosX + boxWidth - cLenX, 0, boxPosY)
                            tr1.BackgroundColor3 = sideColor
                            tr1.Visible = true

                            local tr2 = esp.Parts[4]
                            tr2.Size = UDim2.new(0, boxThickness, 0, cLenY)
                            tr2.Position = UDim2.new(0, boxPosX + boxWidth, 0, boxPosY)
                            tr2.BackgroundColor3 = sideColor
                            tr2.Visible = true

                            local bl1 = esp.Parts[5]
                            bl1.Size = UDim2.new(0, cLenX, 0, boxThickness)
                            bl1.Position = UDim2.new(0, boxPosX, 0, boxPosY + boxHeight)
                            bl1.BackgroundColor3 = sideColor
                            bl1.Visible = true

                            local bl2 = esp.Parts[6]
                            bl2.Size = UDim2.new(0, boxThickness, 0, cLenY)
                            bl2.Position = UDim2.new(0, boxPosX, 0, boxPosY + boxHeight - cLenY)
                            bl2.BackgroundColor3 = sideColor
                            bl2.Visible = true

                            local br1 = esp.Parts[7]
                            br1.Size = UDim2.new(0, cLenX, 0, boxThickness)
                            br1.Position = UDim2.new(0, boxPosX + boxWidth - cLenX, 0, boxPosY + boxHeight)
                            br1.BackgroundColor3 = sideColor
                            br1.Visible = true

                            local br2 = esp.Parts[8]
                            br2.Size = UDim2.new(0, boxThickness, 0, cLenY)
                            br2.Position = UDim2.new(0, boxPosX + boxWidth, 0, boxPosY + boxHeight - cLenY)
                            br2.BackgroundColor3 = sideColor
                            br2.Visible = true
                        end
                    else
                        for _, p in ipairs(esp.Parts) do p.Visible = false end
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
                    for _, p in ipairs(esp.Parts) do p.Visible = false end
                    esp.TagCard.Visible = false
                end
            else
                for _, p in ipairs(esp.Parts) do p.Visible = false end
                esp.TagCard.Visible = false
            end
        else
            for _, p in ipairs(esp.Parts) do p.Visible = false end
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
            local targetPos = lockedTarget.Position
            if predictionEnabled and lockedTarget.Part and lockedTarget.Part.AssemblyLinearVelocity then
                targetPos = lockedTarget.Part.Position + (lockedTarget.Part.AssemblyLinearVelocity * predictionFactor)
            end
            local targetLook = CFrame.lookAt(camera.CFrame.Position, targetPos)
            if snapAimMode or aimbotSmoothness <= 0.001 then
                camera.CFrame = targetLook
            else
                local smoothAlpha = math.clamp((1 - aimbotSmoothness) * (aimbotSpeed / 5) * dt * 60 * aimSensitivity, 0.05, 1)
                camera.CFrame = camera.CFrame:Lerp(targetLook, smoothAlpha)
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
    updateViewmodelChams()

    if thirdpersonEnabled then
        player.CameraMode = Enum.CameraMode.Custom
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

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isAiming = false
        lockedTarget = nil
    end
end)

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
insContent.CanvasSize = UDim2.new(0, 0, 0, 950)
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

local function addInspectorDropdown(y, txt, options, currentVal, onSelect)
    local f = Instance.new("Frame", insContent)
    f.Size = UDim2.new(0.86, 0, 0, 32)
    f.Position = UDim2.new(0.07, 0, 0, y)
    f.BackgroundTransparency = 1
    f.ZIndex = 7

    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 12)
    t.BackgroundTransparency = 1
    t.Text = txt
    t.TextColor3 = currentTheme.TextSecondary
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextSize = 8.5
    t.Font = Enum.Font.GothamBold
    t.ZIndex = 7

    local dropBtn = Instance.new("TextButton", f)
    dropBtn.Size = UDim2.new(1, 0, 0, 18)
    dropBtn.Position = UDim2.new(0, 0, 0, 14)
    dropBtn.BackgroundColor3 = currentTheme.CardBg
    dropBtn.Text = "  " .. currentVal .. " ▼"
    dropBtn.TextColor3 = currentTheme.TextPrimary
    dropBtn.TextSize = 8
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.ZIndex = 8
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 4)
    local dropStroke = Instance.new("UIStroke", dropBtn)
    dropStroke.Color = currentTheme.Border

    local listFrame = Instance.new("Frame", insContent)
    listFrame.Size = UDim2.new(0.86, 0, 0, #options * 20)
    listFrame.Position = UDim2.new(0.07, 0, 0, y + 34)
    listFrame.BackgroundColor3 = currentTheme.Sidebar
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ZIndex = 25
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 4)
    local listStroke = Instance.new("UIStroke", listFrame)
    listStroke.Color = currentTheme.Accent

    local listLayout = Instance.new("UIListLayout", listFrame)
    listLayout.FillDirection = Enum.FillDirection.Vertical

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton", listFrame)
        optBtn.Size = UDim2.new(1, 0, 0, 20)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = "  " .. opt
        optBtn.TextColor3 = (opt == currentVal) and currentTheme.Accent or currentTheme.TextPrimary
        optBtn.TextSize = 8
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.Font = Enum.Font.GothamBold
        optBtn.ZIndex = 26

        bindTouch(optBtn, function()
            currentVal = opt
            dropBtn.Text = "  " .. opt .. " ▼"
            listFrame.Visible = false
            onSelect(opt)
        end)
    end

    bindTouch(dropBtn, function()
        listFrame.Visible = not listFrame.Visible
    end)
end

local function openInspectorFor(moduleName)
    insHeader.Text = moduleName
    for _, child in pairs(insContent:GetChildren()) do child:Destroy() end

    if moduleName == "Advanced Chams" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorDropdown(6, "Chams Style", {"Glow", "Metallic / Gold", "Glass / Crystal", "Wireframe", "Flat", "Animated / Texture"}, advancedChamsStyle, function(v) advancedChamsStyle = v end)
    elseif moduleName == "Box Overlay" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 160)
        addInspectorSlider(6, "Max Distance", 100, 5000, espMaxDist, false, function(v) espMaxDist = v end)
        addInspectorSlider(38, "Thickness", 1.0, 3.0, boxThickness, true, function(v) boxThickness = v end)
        addInspectorDropdown(76, "Box Style", {"2D Full", "2D Corner"}, boxMode, function(v) boxMode = v end)
    elseif moduleName == "Jump Circle" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 160)
        addInspectorSlider(6, "Radius", 3, 15, jumpCircleRadius, false, function(v) jumpCircleRadius = v end)
        addInspectorSlider(38, "Duration", 0.3, 2.0, jumpCircleDuration, true, function(v) jumpCircleDuration = v end)
        addInspectorDropdown(76, "Circle Style", {"Gradient Fade", "Blur & Neon", "Particle Ring", "Textured / Wave"}, jumpCircleMode, function(v) jumpCircleMode = v end)
    elseif moduleName == "Player Trail" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorDropdown(6, "Trail Style", {"Speed-Based Fade", "RGB Rainbow Wave", "Wireframe / Mesh"}, playerTrailMode, function(v) playerTrailMode = v end)
    elseif moduleName == "Grenade Trail" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorDropdown(6, "Trail Style", {"Glow Rope", "Particle Sparkle"}, grenadeTrailMode, function(v) grenadeTrailMode = v end)
    elseif moduleName == "Bullet Beams" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorSlider(6, "Duration", 0.1, 2.0, tracerBeamDuration, true, function(v) tracerBeamDuration = v end)
    elseif moduleName == "Tracking" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 580)
        addInspectorSlider(6, "FOV Radius", 50, 400, aimFov, false, function(v) aimFov = v end)
        addInspectorSlider(38, "Speed", 1.0, 50.0, aimbotSpeed, true, function(v) aimbotSpeed = v end)
        addInspectorSlider(70, "Smoothness", 0.0, 0.95, aimbotSmoothness, true, function(v) aimbotSmoothness = v end)
        addInspectorSlider(102, "Prediction Factor", 0.01, 0.3, predictionFactor, true, function(v) predictionFactor = v end)
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
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorSlider(6, "Arrow Size", 8, 30, arrowSize, false, function(v) arrowSize = v for _, a in pairs(offScreenArrows) do a.Size = UDim2.new(0, v, 0, v) end end)
    elseif moduleName == "Skeleton" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorSlider(6, "Thickness", 1.0, 4.0, skeletonThickness, true, function(v) skeletonThickness = v end)
    elseif moduleName == "Hitmarkers" then
        insContent.CanvasSize = UDim2.new(0, 0, 0, 100)
        addInspectorToggle(6, "Hit Sound", hitmarkerSoundEnabled, function(v) hitmarkerSoundEnabled = v end)
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
addCard(mPage, "Jump Circle", jumpCircleEnabled, function(v) jumpCircleEnabled = v end)
addCard(mPage, "Player Trail", playerTrailEnabled, function(v) playerTrailEnabled = v end)

addCard(ePage, "Nametags", nametagsEnabled, function(v) nametagsEnabled = v end)
addCard(ePage, "Skeleton", skeletonEspEnabled, function(v) skeletonEspEnabled = v end)
addCard(ePage, "Arrows", offScreenArrowsEnabled, function(v) offScreenArrowsEnabled = v end)
addCard(ePage, "Crystal Chams", chamsEnabled, function(v) chamsEnabled = v end)
addCard(ePage, "Advanced Chams", advancedChamsEnabled, function(v) advancedChamsEnabled = v end)
addCard(ePage, "Highlight", highlightEnabled, function(v) highlightEnabled = v end)
addCard(ePage, "Box Overlay", boxEspEnabled, function(v) boxEspEnabled = v end)
addCard(ePage, "Head Dot", headDotEnabled, function(v) headDotEnabled = v end)
addCard(ePage, "Snaplines", tracersEnabled, function(v) tracersEnabled = v end)
addCard(ePage, "Grenade ESP", grenadeEspEnabled, function(v) grenadeEspEnabled = v end)
addCard(ePage, "Grenade Trail", grenadeTrailEnabled, function(v) grenadeTrailEnabled = v end)

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
