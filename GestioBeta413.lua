-- ==============================================================================
-- [Gestio UI - Blox Strike Ultimate Mobile Engine | Version 4.3.5 ESP Fixed]
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
local waitStart = tick()
while not player and (tick() - waitStart) < 10 do
    player = Players.LocalPlayer
    task.wait(0.1)
end
if not player then
    player = Players:GetPlayers()[1]
end

local camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")

local function getSafeGui()
    local res = nil
    pcall(function()
        if gethui then res = gethui() end
    end)
    if res then return res end

    pcall(function()
        res = CoreGui
    end)
    if res then return res end

    if player then
        pcall(function()
            res = player:WaitForChild("PlayerGui", 5) or player:FindFirstChildOfClass("PlayerGui")
        end)
    end
    return res
end

local targetGui = getSafeGui()
if not targetGui and player then
    pcall(function() targetGui = player:WaitForChild("PlayerGui", 10) end)
end
if not targetGui then
    warn("[Gestio] GUI initialization failed")
    return
end

local connections = {}
local activeEspHolders = {}
local screenEspCache = {}
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
-- THEMES & COLORS
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
        Enemy_Accent = Color3.fromRGB(255, 55, 75),
        Enemy_Fill = Color3.fromRGB(220, 50, 50),
        Enemy_Hidden = Color3.fromRGB(130, 135, 145),
        NametagTextColor = Color3.fromRGB(255, 255, 255),
        HealthHigh = Color3.fromRGB(46, 204, 113),
        HealthMid = Color3.fromRGB(241, 196, 15),
        HealthLow = Color3.fromRGB(231, 76, 60),
        MolotovColor = Color3.fromRGB(255, 95, 35),
        SmokeColor = Color3.fromRGB(180, 185, 195),
        HEColor = Color3.fromRGB(255, 45, 55)
    }
}

local currentTheme = themeLibrary["Charcoal Crimson"]

-- ==========================================
-- STATE TOGGLES & CONFIGURATION
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
local bodyAimOnly = false
local predictionEnabled = true
local predictionFactor = 0.135
local visibleCheck = false

-- SILENT AIM
local silentAimEnabled = false
local silentAimFov = 150
local silentAimTeamCheck = true
local silentAimVisibleCheck = false
local silentAimHitChance = 100
local silentAimAimHead = true
local silentAimResolved = nil
local silentAimHooked = false

-- ESP & VISUALS (По умолчанию включено для теста)
local nametagsEnabled = true
local boxEspEnabled = true
local cornerBoxEnabled = false
local healthBarEnabled = true
local headDotEnabled = false
local tracersEnabled = false
local espShowTeammates = true
local espIgnoreBots = false
local espMaxDist = 3000
local espShowDistance = true
local espShowHealth = true
local espTextSize = 9
local tagTransparency = 0.25
local tagBgColor = Color3.fromRGB(16, 17, 20)
local tagShowWeapon = true
local boxThickness = 1.2

-- CHAMS
local chamsEnabled = true
local chamsTeamCheck = false
local chamsShowTeammates = true
local chamsOcclusion = true
local chamsFillTransparency = 0.45
local chamsOutlineTransparency = 0.10
local chamsColorVisible = Color3.fromRGB(255, 45, 85)
local chamsColorHidden = Color3.fromRGB(110, 115, 125)
local chamsColorAlly = Color3.fromRGB(0, 230, 255)
local chamsOutlineColor = Color3.fromRGB(240, 240, 245)

-- HITMARKER & MISC
local hitmarkerEnabled = false
local hitmarkerDuration = 0.28
local hitmarkerSize = 13
local hitmarkerThickness = 2
local hitmarkerGlow = true
local hitmarkerLastHealth = {}
local thirdPersonEnabled = false
local thirdPersonDistance = 12
local thirdPersonHeight = 1.5
local thirdPersonPreviousOffset = nil

-- MOVEMENT
local bunnyHopEnabled = false
local bhopAutoJump = false
local bhopAirStrafe = true
local bhopSpeedBoost = 1.35
local bhopJumpPower = 52
local isMobileJumpHeld = false
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

-- RECOIL
local noRecoil = { enabled = false, strength = 0.85, isShooting = false }
local rcsEnabled = false
local rcsStrength = 60
local rcsPitchFactor = 1.0
local rcsYawFactor = 1.0
local rcsHorizontalComp = false

-- GRENADE & JUMP CIRCLE
local grenadeEspEnabled = false
local showGrenadePath = true
local showMolotovRadius = true
local showSmokeRadius = true
local grenadeMaxDist = 1500
local jumpCircleEnabled = false
local jumpCircleStyle = "GradientWave"
local jumpCircleSegmentCount = 32
local jumpCircleRadius = 3.5
local jumpCircleHeightOffset = -2.8
local activeJumpCircleData = nil

-- SKINS
local skinChangerEnabled = false
local selectedKnifeType = "Butterfly Knife"
local selectedSkin = "Fade"
local knifeSkinCatalog = {
    ["Butterfly Knife"] = { ["Vanilla"] = "rbxassetid://4991206306", ["Fade"] = "rbxassetid://4991206411", ["Doppler"] = "rbxassetid://4991206517", ["Lore"] = "rbxassetid://4991206622" },
    ["Karambit"] = { ["Vanilla"] = "rbxassetid://4991206306", ["Fade"] = "rbxassetid://4991206411", ["Doppler"] = "rbxassetid://4991206517", ["Lore"] = "rbxassetid://4991206622" }
}
local knifeTypeNames = { "Butterfly Knife", "Karambit" }

-- ENVIRONMENT
local antiFlashEnabled = true
local fullBrightEnabled = false
local removeFogEnabled = true
local nightModeEnabled = false
local nightPreset = "Midnight"
local nightClockTime = 0.0
local nightBrightness = 0.2
local nightOutdoorAmbient = Color3.fromRGB(25, 25, 40)
local defaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor
}

local triggerbotEnabled = false
local triggerbotDelay = 0.02
local triggerbotHeadOnly = false
local triggerbotMobileAutoFire = true
local lastTriggerTick = 0
local antiAimEnabled = false
local spinSpeed = 50
local currentSpinAngle = 0

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
local mobileSlideBtn = nil

-- ==========================================
-- RELIABLE CHECK & TEAM SYSTEM
-- ==========================================
local function isBotPlayer(plr)
    if not plr then return true end
    local ok, uid = pcall(function() return plr.UserId end)
    if ok and (uid == 0 or uid < 0 or uid > 1e9) then return true end
    return false
end

local function getPlayerTeamName(plr)
    if not plr then return nil end
    if plr.Team and plr.Team.Name ~= "" then return plr.Team.Name end
    local char = plr.Character
    if char then
        if char:GetAttribute("Team") then return tostring(char:GetAttribute("Team")) end
        if char:GetAttribute("Faction") then return tostring(char:GetAttribute("Faction")) end
        if char.Parent and (char.Parent.Name:find("Terrorist") or char.Parent.Name:find("Counter")) then
            return char.Parent.Name
        end
    end
    if plr:GetAttribute("Team") then return tostring(plr:GetAttribute("Team")) end
    if plr.TeamColor and plr.TeamColor ~= BrickColor.new("White") then return plr.TeamColor.Name end
    return nil
end

local function isAlly(plr)
    if not plr or plr == player then return true end
    local myTeam = getPlayerTeamName(player)
    local targetTeam = getPlayerTeamName(plr)
    if myTeam and targetTeam and myTeam ~= "" and targetTeam ~= "" then
        return myTeam == targetTeam
    end
    if plr.Team and player.Team then return plr.Team == player.Team end
    if plr.TeamColor and player.TeamColor and plr.TeamColor ~= BrickColor.new("White") then
        return plr.TeamColor == player.TeamColor
    end
    return false
end

local function getCharacterRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChildWhichIsA("BasePart")
end

local function isEntityAlive(char, hum)
    if not char or not char.Parent or not char:IsDescendantOf(Workspace) then return false end
    if hum and hum.Parent then
        local hp = 100
        pcall(function() hp = hum.Health end)
        if hp <= 0 then return false end
    end
    return getCharacterRoot(char) ~= nil
end

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

    local healthBarFill = Instance.new("Frame", healthBarBg)
    healthBarFill.Name = "Fill"
    healthBarFill.AnchorPoint = Vector2.new(0, 1)
    healthBarFill.Position = UDim2.new(0, 0, 1, 0)
    healthBarFill.Size = UDim2.new(1, 0, 1, 0)
    healthBarFill.BackgroundColor3 = currentTheme.HealthHigh
    healthBarFill.BorderSizePixel = 0
    Instance.new("UICorner", healthBarFill).CornerRadius = UDim.new(0, 2)

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
        TagCard = tagCard,
        TagLabel = tagLabel
    }
    screenEspCache[plr] = data
    return data
end

-- ==========================================
-- 3D ESP & HIGHLIGHT ATTACHMENT
-- ==========================================
local function attachEspToPlayer(plr)
    if plr == player then return end

    local holder = Instance.new("Folder")
    holder.Name = "GestioESP_" .. plr.Name
    holder.Parent = mainContainer

    local hl = Instance.new("Highlight")
    hl.Name = "GestioChams_" .. plr.Name
    hl.FillTransparency = chamsFillTransparency
    hl.OutlineTransparency = chamsOutlineTransparency
    hl.Enabled = false
    hl.FillColor = chamsColorVisible
    hl.OutlineColor = chamsOutlineColor
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = holder

    local espData = {
        Holder = holder,
        Highlight = hl
    }
    activeEspHolders[plr] = espData

    local function setupChar(char)
        if not char then return end
        task.spawn(function()
            if hl then
                hl.Adornee = char
            end
        end)
    end

    if plr.Character then setupChar(plr.Character) end
    table.insert(connections, plr.CharacterAdded:Connect(setupChar))
    table.insert(connections, plr.CharacterRemoving:Connect(function()
        if hl then hl.Adornee = nil; hl.Enabled = false end
    end))
end

for _, v in pairs(Players:GetPlayers()) do attachEspToPlayer(v) end
table.insert(connections, Players.PlayerAdded:Connect(attachEspToPlayer))

-- ==========================================
-- RENDER STEPS: 2D ESP & CHAMS OVERLAY
-- ==========================================
local function renderTacticalOverlay()
    local camPos = camera.CFrame.Position
    local allPlayers = Players:GetPlayers()

    for i = 1, #allPlayers do
        local plr = allPlayers[i]
        if plr ~= player then
            local esp = getOrCreateScreenEsp(plr)
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local rootPart = getCharacterRoot(char)
            local head = char and char:FindFirstChild("Head")

            local ally = isAlly(plr)
            local isAlive = isEntityAlive(char, hum)
            local shouldShow = (not ally or espShowTeammates) and isAlive and rootPart

            if shouldShow then
                local dist = (rootPart.Position - camPos).Magnitude
                if dist <= espMaxDist then
                    local isVisible = isVisibleThroughWalls(head or rootPart, char)
                    local sideColor = ally and currentTheme.HealthHigh or (isVisible and currentTheme.Enemy_Accent or currentTheme.Enemy_Hidden)

                    local topWorld = (head and head.Position or rootPart.Position) + Vector3.new(0, 1.8, 0)
                    local bottomWorld = rootPart.Position - Vector3.new(0, 3.0, 0)

                    local topScreen, topVisible = camera:WorldToViewportPoint(topWorld)
                    local bottomScreen, _ = camera:WorldToViewportPoint(bottomWorld)

                    if topVisible and topScreen.Z > 0 then
                        local boxHeight = math.abs(bottomScreen.Y - topScreen.Y)
                        local boxWidth = boxHeight * 0.65
                        local boxPosX = topScreen.X - (boxWidth * 0.5)
                        local boxPosY = topScreen.Y

                        if boxEspEnabled then
                            esp.BoxStroke.Color = sideColor
                            esp.BoxStroke.Thickness = boxThickness
                            esp.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                            esp.Box.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                            esp.Box.Visible = true
                        else
                            esp.Box.Visible = false
                        end

                        if healthBarEnabled and hum then
                            local maxHp = hum.MaxHealth > 0 and hum.MaxHealth or 100
                            local curHp = math.clamp(hum.Health, 0, maxHp)
                            local hpPercent = math.clamp(curHp / maxHp, 0, 1)

                            esp.HealthBarBg.Size = UDim2.new(0, 3, 0, boxHeight)
                            esp.HealthBarBg.Position = UDim2.new(0, boxPosX - 7, 0, boxPosY)
                            esp.HealthBarBg.Visible = true
                            esp.HealthBarFill.Size = UDim2.new(1, 0, hpPercent, 0)
                        else
                            esp.HealthBarBg.Visible = false
                        end

                        if nametagsEnabled then
                            local baseName = plr.DisplayName or plr.Name
                            local infoText = baseName
                            if espShowDistance then
                                infoText = string.format("%s [%dm]", infoText, math.floor(dist))
                            end
                            esp.TagLabel.Text = infoText
                            esp.TagCard.Position = UDim2.new(0, topScreen.X, 0, topScreen.Y - 4)
                            esp.TagCard.Visible = true
                        else
                            esp.TagCard.Visible = false
                        end
                    else
                        esp.Box.Visible = false
                        esp.HealthBarBg.Visible = false
                        esp.TagCard.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.HealthBarBg.Visible = false
                    esp.TagCard.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.HealthBarBg.Visible = false
                esp.TagCard.Visible = false
            end
        end
    end
end

-- ==========================================
-- SILENT AIM BALLISTICS & RESOLVER
-- ==========================================
local function getPredictedSilentPosition(targetPart)
    if not targetPart then return Vector3.zero end
    local targetPos = targetPart.Position
    if not predictionEnabled then return targetPos end

    local myChar = player.Character
    local myHrp = getCharacterRoot(myChar)
    local targetVel = targetPart.AssemblyLinearVelocity or Vector3.zero
    local myVel = (myHrp and myHrp.AssemblyLinearVelocity) or Vector3.zero
    local relativeVelocity = targetVel - (myVel * 0.45)
    return targetPos + (relativeVelocity * predictionFactor)
end

local function getSilentAimTarget()
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end
    local vp = cam.ViewportSize
    local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    local bestPart = nil
    local shortestDist = silentAimFov

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and not (silentAimTeamCheck and isAlly(plr)) then
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if isEntityAlive(char, hum) then
                local part = char:FindFirstChild(silentAimAimHead and "Head" or "Torso") or getCharacterRoot(char)
                if part and part:IsA("BasePart") then
                    local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen and screenPos.Z > 0 then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if screenDist <= shortestDist then
                            if not silentAimVisibleCheck or isVisibleThroughWalls(part, char) then
                                shortestDist = screenDist
                                bestPart = part
                            end
                        end
                    end
                end
            end
        end
    end
    return bestPart
end

local function setupTrueSilentAimHook()
    if silentAimHooked then return end
    pcall(function()
        if not hookmetamethod then return end

        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            if silentAimEnabled and silentAimResolved and not (type(checkcaller) == "function" and checkcaller()) then
                if method == "Raycast" and self == Workspace then
                    local origin = args[1]
                    local targetPos = getPredictedSilentPosition(silentAimResolved)
                    args[2] = (targetPos - origin).Unit * 1500
                    return oldNamecall(self, table.unpack(args))
                end

                if (method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist") and self == Workspace then
                    local currentRay = args[1]
                    if typeof(currentRay) == "Ray" then
                        local origin = currentRay.Origin
                        local targetPos = getPredictedSilentPosition(silentAimResolved)
                        args[1] = Ray.new(origin, (targetPos - origin).Unit * 1500)
                        return oldNamecall(self, table.unpack(args))
                    end
                end

                if (method == "ViewportPointToRay" or method == "ScreenPointToRay") and self == (Workspace.CurrentCamera or camera) then
                    local camPos = (Workspace.CurrentCamera or camera).CFrame.Position
                    local targetPos = getPredictedSilentPosition(silentAimResolved)
                    return Ray.new(camPos, (targetPos - camPos).Unit)
                end
            end

            return oldNamecall(self, ...)
        end)

        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(self, key)
            if silentAimEnabled and silentAimResolved and not (type(checkcaller) == "function" and checkcaller()) then
                if typeof(self) == "Instance" and self:IsA("Mouse") then
                    local camPos = (Workspace.CurrentCamera or camera).CFrame.Position
                    local targetPos = getPredictedSilentPosition(silentAimResolved)
                    if key == "Hit" then
                        return CFrame.new(camPos, targetPos)
                    elseif key == "UnitRay" then
                        return Ray.new(camPos, (targetPos - camPos).Unit)
                    elseif key == "Target" then
                        return silentAimResolved
                    end
                end
            end
            return oldIndex(self, key)
        end)

        silentAimHooked = true
    end)
end

-- ==========================================
-- MAIN ENGINE RENDER LOOP
-- ==========================================
table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    camera = Workspace.CurrentCamera or camera
    if not camera then return end

    -- Silent Aim Resolver
    if silentAimEnabled then
        setupTrueSilentAimHook()
        if math.random(1, 100) <= silentAimHitChance then
            silentAimResolved = getSilentAimTarget()
        else
            silentAimResolved = nil
        end
    else
        silentAimResolved = nil
    end

    renderTacticalOverlay()

    -- 3D Chams Render Loop
    for plr, data in pairs(activeEspHolders) do
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local rootPart = getCharacterRoot(char)
        local ally = isAlly(plr)
        local isAlive = isEntityAlive(char, hum)

        if char and isAlive and rootPart and chamsEnabled then
            if ally and not chamsShowTeammates then
                data.Highlight.Enabled = false
            else
                data.Highlight.Enabled = true
                data.Highlight.Adornee = char
                data.Highlight.FillColor = ally and chamsColorAlly or chamsColorVisible
            end
        else
            data.Highlight.Enabled = false
        end
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

openBtn.Activated:Connect(toggleMenu)

local mainFrame = Instance.new("Frame", masterFrame)
mainFrame.Size = UDim2.new(0.58, 0, 1, 0)
mainFrame.BackgroundColor3 = currentTheme.Background
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 5
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = currentTheme.Border

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

local function createNavBtn(order, txt)
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
local eBtn = createNavBtn(4, "ESP")
cBtn.BackgroundColor3 = currentTheme.CardBg
cBtn.TextColor3 = currentTheme.Accent

local function makePageContainer()
    local c = Instance.new("ScrollingFrame", mainFrame)
    c.Size = UDim2.new(1, -84, 1, -12)
    c.Position = UDim2.new(0, 80, 0, 6)
    c.BackgroundTransparency = 1
    c.ScrollBarThickness = 2
    c.CanvasSize = UDim2.new(0, 0, 0, 400)
    c.Visible = false
    c.ZIndex = 6

    local list = Instance.new("UIListLayout", c)
    list.FillDirection = Enum.FillDirection.Vertical
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 10)
    return c
end

local cPage = makePageContainer()
local ePage = makePageContainer()
cPage.Visible = true

local function switch(tab)
    cPage.Visible = (tab == "C")
    ePage.Visible = (tab == "E")
    cBtn.BackgroundColor3 = (tab == "C") and currentTheme.CardBg or currentTheme.Sidebar
    cBtn.TextColor3 = (tab == "C") and currentTheme.Accent or currentTheme.TextSecondary
    eBtn.BackgroundColor3 = (tab == "E") and currentTheme.CardBg or currentTheme.Sidebar
    eBtn.TextColor3 = (tab == "E") and currentTheme.Accent or currentTheme.TextSecondary
end

cBtn.Activated:Connect(function() switch("C") end)
eBtn.Activated:Connect(function() switch("E") end)

local function addCard(parent, name, defaultState, onToggle)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(0, 60, 0, 50)
    card.BackgroundColor3 = currentTheme.CardBg
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

    local textBtn = Instance.new("TextButton", card)
    textBtn.Size = UDim2.new(1, 0, 0, 20)
    textBtn.BackgroundTransparency = 1
    textBtn.Text = name
    textBtn.TextColor3 = currentTheme.TextPrimary
    textBtn.TextSize = 7.5
    textBtn.Font = Enum.Font.GothamBold

    local toggleBtn = Instance.new("TextButton", card)
    toggleBtn.Size = UDim2.new(0, 24, 0, 13)
    toggleBtn.Position = UDim2.new(0.5, -12, 1, -16)
    toggleBtn.BackgroundColor3 = defaultState and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local state = defaultState
    toggleBtn.Activated:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and currentTheme.Accent or Color3.fromRGB(50, 53, 60)
        onToggle(state)
    end)
end

addCard(cPage, "Silent Aim", silentAimEnabled, function(v) silentAimEnabled = v end)
addCard(ePage, "Box ESP", boxEspEnabled, function(v) boxEspEnabled = v end)
addCard(ePage, "Nametags", nametagsEnabled, function(v) nametagsEnabled = v end)
addCard(ePage, "Chams", chamsEnabled, function(v) chamsEnabled = v end)
addCard(ePage, "Show All", espShowTeammates, function(v) espShowTeammates = v; chamsShowTeammates = v end)

if genv then
    genv.GestioRunning = function()
        for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
        pcall(function() mainContainer:Destroy() end)
        pcall(function() toggleGui:Destroy() end)
        pcall(function() screenGui:Destroy() end)
    end
end
