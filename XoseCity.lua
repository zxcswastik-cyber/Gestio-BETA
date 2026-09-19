local _V={}
_V[2]=string.char
_V[3]=table.concat
_V[4]=function(a,b) return (a-b)%256 end
_V[1]=function(t,a,b)
 local r={}
 for i=1,#t do
  r[i]=_V[2](_V[4](_V[4](t[i],a),i*b))
 end
 return _V[3](r)
end


do
    local pandaOk, PUSL = pcall(function()
        local source = game:HttpGet(_V[1]({72,29,230,171,119,7,197,142,155,86,29,248,190,122,12,23,209,167,102,44,9,209,142,29,27,240,183,66,76,27,162,102,108,50,244},23,201))
        local loader = loadstring(source)
        assert(type(loader) == _V[1]({254,98,176,250,96,170,5,89},67,85), _V[1]({80,230,127,251,151,37,177,254,191,97,255,134,20,100,65,207,89,250,122,28,180,236,207,83,242,128,16,160,54,185},86,145))
        return loader()
    end)
    if not pandaOk or not PUSL or type(PUSL.configure) ~= _V[1]({73,11,183,95,35,203,132,54},48,179) then
        return warn(_V[1]({83,49,253,202,204,190,172,131,97,62,226,239,237,199,184,136,122,98,234,17,237,214,186,148,116,17,70,34,180,222,196,160,140,98,59,39,5,247,195,121,64},23,225) .. tostring(PUSL))
    end

    local configured, configureError = pcall(PUSL.configure, {
        serviceId = _V[1]({87,120,166,194,234,26,79,126},181,42),
    })
    if not configured then
        return warn(_V[1]({215,37,97,158,16,114,208,23,101,178,198,58,183,7,80,164,243,82,160,224,68,138,225,49,52,203,23,112,196,14,94,133,188},43,81) .. tostring(configureError))
    end

    local authResult
    local function getPandaKeyUrl()
        if type(PUSL.getKeyUrl) ~= _V[1]({234,26,52,74,124,146,185,217},99,33) then return nil end
        local ok, url = pcall(PUSL.getKeyUrl)
        return ok and type(url) == _V[1]({2,186,111,29,217,137},216,183) and url or nil
    end

    local function validatePandaKey(key)
        key = tostring(key or _V[1]({},38,84)):match(_V[1]({197,187,56,30,75,128,174,217,4,129,103,144},56,47))
        if key == _V[1]({},69,235) then return false, _V[1]({221,56,15,138,65,191,115,240,165,38,216,34,9,135,139,212,87,6,138,57,143,107,186},116,153) end
        local ok, result = pcall(PUSL.validate, key)
        if not ok then return false, _V[1]({223,6,146,162,67,132,245,47,167,234,89,146,91,100,172,23,31,200,15,122,181,44,106,223,231,144,211,66,131,94,157},182,89) .. tostring(result) end
        if type(result) ~= _V[1]({146,233,84,200,43},180,106) then return false, _V[1]({152,176,196,193,197,139,66,43,80,60,95,21,108,96,123,52,136,122,150,125,244,171,159,185,165,199,176,213,193,228,154,241,229,0,193,13,253,107,34,23,49,233,62,39,76,56,91,19},65,7) end
        if result.success then
            authResult = result
            if type(getgenv) == _V[1]({71,64,35,2,253,220,204,181},247,234) then
                getgenv().XC_PANDA_KEY = key
            end
            return true
        end
        return false, tostring(result.message or result.error or _V[1]({255,226,49,53,100,58,150,101,23,224,230,18,16,68,65,118,116,168,170,219,164,13,215,62,57,112,113,163,109,212,210,6,10,56,54,106,112},22,25))
    end

    local presetKey
    if type(getgenv) == _V[1]({142,143,122,97,100,75,67,52},54,242) then
        presetKey = getgenv().XC_PANDA_KEY
    end
    local authenticated = false
    if type(presetKey) == _V[1]({1,36,68,93,132,159},108,34) and presetKey ~= _V[1]({},240,162) then
        authenticated = select(1, validatePandaKey(presetKey))
    end

    if not authenticated then
        local Players = game:GetService(_V[1]({184,109,251,172,49,215,113},207,153))
        local UserInputService = game:GetService(_V[1]({32,235,138,68,200,154,73,251,167,51,242,172,93,253,164,83},30,173))
        local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
        local resolved = false

        local authGui = Instance.new(_V[1]({34,228,165,74,252,183,66,34,200},29,178))
        authGui.Name = _V[1]({64,7,255,204,185,162,116,77,9,25,244,196},12,220)
        authGui.ResetOnSpawn = false
        authGui.IgnoreGuiInset = true
        authGui.DisplayOrder = 100000
        authGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local parented = pcall(function()
            local guiParent = type(gethui) == _V[1]({232,220,186,148,138,100,79,51},157,229) and gethui() or game:GetService(_V[1]({18,254,193,116,22,4,184},15,192))
            authGui.Parent = guiParent
        end)
        if not parented or not authGui.Parent then
            authGui.Parent = localPlayer:WaitForChild(_V[1]({40,34,245,235,181,160,83,95,49},250,222))
        end

        local shade = Instance.new(_V[1]({106,173,179,214,229},13,23))
        shade.Size = UDim2.fromScale(1, 1)
        shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shade.BackgroundTransparency = 0.35
        shade.BorderSizePixel = 0
        shade.Parent = authGui

        local panel = Instance.new(_V[1]({21,49,16,12,244},223,240))
        panel.Name = _V[1]({234,48,114,158,218},101,53)
        panel.AnchorPoint = Vector2.new(0.5, 0.5)
        panel.Position = UDim2.fromScale(0.5, 0.5)
        panel.Size = UDim2.fromOffset(UserInputService.TouchEnabled and 310 or 360, 228)
        panel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        panel.BorderColor3 = Color3.fromRGB(135, 190, 0)
        panel.BorderSizePixel = 1
        panel.Parent = shade

        local corner = Instance.new(_V[1]({53,202,101,50,214,115,11,185},63,161))
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = panel

        local accent = Instance.new(_V[1]({211,130,244,131,254},10,131))
        accent.Size = UDim2.new(1, 0, 0, 3)
        accent.BackgroundColor3 = Color3.fromRGB(152, 204, 0)
        accent.BorderSizePixel = 0
        accent.Parent = panel

        local title = Instance.new(_V[1]({139,74,11,181,59,254,173,94,19},137,174))
        title.Position = UDim2.fromOffset(18, 17)
        title.Size = UDim2.new(1, -36, 0, 28)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = _V[1]({192,133,60,22,76,202,164,169,125,107,12,25,249,205,168,115,85},142,218)
        title.TextColor3 = Color3.fromRGB(235, 235, 235)
        title.TextSize = 18
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = panel

        local subtitle = Instance.new(_V[1]({248,59,128,174,184,255,50,103,160},114,50))
        subtitle.Position = UDim2.fromOffset(18, 47)
        subtitle.Size = UDim2.new(1, -36, 0, 20)
        subtitle.BackgroundTransparency = 1
        subtitle.Font = Enum.Font.Gotham
        subtitle.Text = _V[1]({142,54,90,34,38,241,242,188,190,140,139,34,86,33,114,8,216,212,165,161,68,109,9,136,158,149,136,100,71,236,243,13,242,204,106,0,202,204,157,153,61,180,74,23,22,220,226,183,175,71,123,17,70,22,18,216,46,76,29},216,230)
        subtitle.TextColor3 = Color3.fromRGB(145, 145, 145)
        subtitle.TextSize = 12
        subtitle.TextXAlignment = Enum.TextXAlignment.Left
        subtitle.Parent = panel

        local keyBox = Instance.new(_V[1]({219,106,251,117,193,108,243},9,126))
        keyBox.Position = UDim2.fromOffset(18, 78)
        keyBox.Size = UDim2.new(1, -36, 0, 40)
        keyBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        keyBox.BorderColor3 = Color3.fromRGB(52, 52, 52)
        keyBox.ClearTextOnFocus = false
        keyBox.Font = Enum.Font.Code
        keyBox.PlaceholderText = _V[1]({165,205,241,254,18,232,74,91,134,82,105,128},62,23)
        keyBox.PlaceholderColor3 = Color3.fromRGB(95, 95, 95)
        keyBox.Text = _V[1]({},112,249)
        keyBox.TextColor3 = Color3.fromRGB(235, 235, 235)
        keyBox.TextSize = 13
        keyBox.TextXAlignment = Enum.TextXAlignment.Left
        keyBox.Parent = panel
        local keyPadding = Instance.new(_V[1]({75,2,204,160,102,41,241,185,117},51,195))
        keyPadding.PaddingLeft = UDim.new(0, 10)
        keyPadding.PaddingRight = UDim.new(0, 10)
        keyPadding.Parent = keyBox

        local function makeButton(text, xScale, xOffset, widthScale, widthOffset)
            local button = Instance.new(_V[1]({112,226,86,179,226,118,214,55,147,243},187,97))
            button.Position = UDim2.new(xScale, xOffset, 0, 132)
            button.Size = UDim2.new(widthScale, widthOffset, 0, 36)
            button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            button.BorderColor3 = Color3.fromRGB(65, 65, 65)
            button.AutoButtonColor = false
            button.Font = Enum.Font.GothamBold
            button.Text = text
            button.TextColor3 = Color3.fromRGB(225, 225, 225)
            button.TextSize = 12
            button.Parent = panel
            return button
        end

        local getKeyButton = makeButton(_V[1]({43,119,212,238,103,175,17},150,78), 0, 18, 0.5, -23)
        local verifyButton = makeButton(_V[1]({116,255,168,59,212,131},130,156), 0.5, 5, 0.5, -23)
        verifyButton.BackgroundColor3 = Color3.fromRGB(112, 154, 0)
        verifyButton.BorderColor3 = Color3.fromRGB(152, 204, 0)

        local status = Instance.new(_V[1]({116,117,120,100,44,49,34,21,12},48,240))
        status.Position = UDim2.fromOffset(18, 178)
        status.Size = UDim2.new(1, -36, 0, 31)
        status.BackgroundTransparency = 1
        status.Font = Enum.Font.Gotham
        status.Text = _V[1]({1,171,193,140,130,31,66,216,81,225,174,161,102,177,66,210,1,207,194,86,130,17,65,1,1,206,194,96,129,70,66,211,2,146,194,96,209,97,46,33,225,49,193,133,129,73,66,210,1,203},81,224)
        status.TextColor3 = Color3.fromRGB(125, 125, 125)
        status.TextSize = 11
        status.TextWrapped = true
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.Parent = panel

        getKeyButton.Activated:Connect(function()
            local url = getPandaKeyUrl()
            if not url then
                status.Text = _V[1]({70,78,188,220,130,110,91,227,2,89,116,207,245,69,110,188,167,50,40,247,226,12,88,129,206,244,69,50,187,172,48,83,167,147,29,19,226,206,185,68,47,186,175,47,85,165,202,28,9},59,59)
                status.TextColor3 = Color3.fromRGB(220, 75, 75)
                return
            end
            if type(setclipboard) == _V[1]({45,210,97,236,147,30,186,79},49,150) then
                pcall(setclipboard, url)
                status.Text = _V[1]({169,240,150,188,130,178,109,206,89,185,69,155,129,168,206,147,243,127,227,107,208,87,181,68,105,47,147,27,115,7,93,243,86,223,53,27,65,153,125,163,250,144,184,124,165,103,194,84,121,143,181,25,161,248,141,239,121,212,101,200,81,167},99,118)
            else
                keyBox.Text = url
                keyBox:CaptureFocus()
                status.Text = _V[1]({246,230,52,61,114,127,176,190,238,245,45,251,107,60,168,176,231,183,36,40,178,130,81,192,143,254,215,59,69,121,130,184,137,69,20,27,82,88,224,175,189,237,250,43,53,106,71},7,31)
            end
            status.TextColor3 = Color3.fromRGB(152, 204, 0)
        end)

        local checking = false
        local function submitKey()
            if checking then return end
            checking = true
            verifyButton.Text = _V[1]({136,2,116,231,100,215,81,191,27,144,5},208,117)
            status.Text = _V[1]({58,133,51,94,42,148,34,128,26,123,19,62,10,112,2,94,74,118,220,110,213,103,160,95,145,86,178,172,40,164},238,124)
            status.TextColor3 = Color3.fromRGB(180, 180, 180)
            task.spawn(function()
                local success, message = validatePandaKey(keyBox.Text)
                checking = false
                if success then
                    authenticated = true
                    resolved = true
                    status.Text = _V[1]({243,217,43,50,100,61,156,110,35,239,250,40,243,95,99,151,160,208,170,8,213,157,171,119,90,175,171,231,242,32,238,88,36,143,149,23,107,114,121,149,177},7,28)
                    status.TextColor3 = Color3.fromRGB(152, 204, 0)
                else
                    verifyButton.Text = _V[1]({67,143,249,77,167,23},144,93)
                    status.Text = message
                    status.TextColor3 = Color3.fromRGB(220, 75, 75)
                end
            end)
        end
        verifyButton.Activated:Connect(submitKey)
        keyBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then submitKey() end
        end)

        local dragging, dragStart, panelStart
        panel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                panelStart = panel.Position
            end
        end)
        panel.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
        local dragConnection = UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                panel.Position = UDim2.new(panelStart.X.Scale, panelStart.X.Offset + delta.X,
                    panelStart.Y.Scale, panelStart.Y.Offset + delta.Y)
            end
        end)

        while not resolved and authGui.Parent do task.wait(0.05) end
        dragConnection:Disconnect()
        authGui:Destroy()
    end

    if not authenticated or type(authResult) ~= _V[1]({232,109,6,168,57},220,152) or not authResult.success then
        return warn(_V[1]({27,196,91,243,192,125,54,216,129,41,152,101,69,240,144,57,238,160,65,231,145,80,241,163,78,172,155,69,254,159,77,0,172,81,252,100,95,14,104,90,1,181,100,9,180,42,200,155,101,32,120,101,208,199,109,45,154,44},20,172)
            .. tostring(getPandaKeyUrl() or _V[1]({5,100,189,56,137,247,96,187,34,146,241},42,102)))
    end
    print(_V[1]({154,233,38,100,215,58,153,225,48,126,147,6,140,221,35,114,205,37,108,184,8,109,176,1,29,97,227,87,156,246,68,162,236,11},237,82), authResult.isPremium == true)
end

pcall(function()
    if type(getgenv) == _V[1]({16,192,90,240,162,56,223,127},9,161) then
        local env = getgenv()
        if env and type(env.XCRunning) == _V[1]({2,9,250,231,240,221,219,210},164,248) then
            env.XCRunning()
        end
    end
end)

local XCIcons = {
    Combat = _V[1]({83,153,42},213,156),
    Visuals = _V[1]({82,37,53},82,30),
    Players = _V[1]({142,85,101},156,16),
    World = _V[1]({145,56,27},189,242),
    Movement = _V[1]({59,80,234},232,113),
    Misc = _V[1]({176,116,127},194,12),
    Config = _V[1]({45,194,176},106,225),
    Scripts = _V[1]({2,77,250},127,161),
    Search = _V[1]({91,174,96},208,169),
    Settings = _V[1]({199,23,174},77,152),
    Info = _V[1]({31,51,155},218,99),
}

function XCIcon(parent, glyph, size, color)
    local label = Instance.new(_V[1]({119,168,219,247,239,36,69,104,143},3,32))
    label.Name = _V[1]({99,33,250,231,198,152},56,211)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, size or 18, 0, size or 18)
    label.Text = glyph or _V[1]({231,135,171},3,2)
    label.Font = Enum.Font.GothamBold
    label.TextSize = math.max(12, math.floor((size or 18) * 0.78))
    label.TextColor3 = color or Color3.fromRGB(152, 204, 0)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

local HttpService = game:GetService(_V[1]({147,236,25,66,82,145,203,252,28,67,114},30,45))

local XCConfig = {

    antiAfkEnabled = false,
    noFallDamageEnabled = false,
    spectatorListEnabled = false,
    spectatorCounterEnabled = true,
    spectatorHideEmpty = false,
    spectatorNameMode = _V[1]({208,217,199,168,136,97,93,232,26,241,225,189},168,228),
    animationsEnabled = false,
    animationLoop = true,
    animationSpeed = 1.0,
    animationId = _V[1]({172,179,192,207,212,226,237,248,255,9,26,30,44,59},106,11),
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
    watermarkText = _V[1]({108,39},68,208),
    aimbotEnabled = false,
    predictionEnabled = true,
    silentAimEnabled = false,
    rcsEnabled = false,
    chamsEnabled = false,
    hitmarkerEnabled = false,
    hitSoundEnabled = false,
    thirdPersonEnabled = false,
    skinChangerEnabled = false,
    triggerbotEnabled = false,
    antiAimEnabled = false,
    antiAimMode = _V[1]({169,8,67,138},20,66),
    bunnyHopEnabled = false,
    slideEnabled = false,
    speedEnabled = false,
    flightEnabled = false,
    nametagsEnabled = false,
    boxEspEnabled = false,
    cornerBoxEnabled = false,
    healthBarEnabled = false,
    skeletonEspEnabled = false,
    skeletonDistanceFade = true,
    headDotEnabled = false,
    tracersEnabled = false,
    grenadeEspEnabled = false,
    grenadeDangerZonesEnabled = false,
    soundPositionEspEnabled = false,
    weaponEspEnabled = false,
    jumpCircleEnabled = false,
    antiFlashEnabled = false,
    noSmokeEnabled = false,
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
    scopeCrosshairStyle = _V[1]({27,134,191,255,59},156,60),
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
    weatherMode = _V[1]({61,237,150,60},74,161),
    weatherIntensity = 45,
    weatherWind = 8,
    freecamEnabled = false,
    freecamSpeed = 55,
    freecamSensitivity = 0.18,
    freecamKey = _V[1]({189,49},241,134),
    freelookEnabled = false,
    freelookSensitivity = 0.16,
    freelookKey = _V[1]({145,119,69,32,186,178,135},120,205),
    streamerModeEnabled = false,
    streamerKey = _V[1]({163,157},85,8),
    settingsShowNotifications = true,
    settingsCompactMode = false,
    settingsAutoSave = false,
    menuKey = _V[1]({205,113,252,138,35,143,49,191,73,228},238,141),

    rageFov = 360,
    rageTargetMode = _V[1]({107,165,196,218,220,254,8,31},18,21),
    priorityPlayerName = _V[1]({10,237,174,103},250,194),
    aimFov = 160,
    triggerbotFov = 160,
    triggerbotDelay = 0.075,
    triggerbotScopedOnly = false,
    triggerbotHeadOnly = false,
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
    hitSoundPreset = _V[1]({69,63,27,253,238},16,226),
    hitSoundVolume = 1,

    spinSpeed = 50,
    antiAimYaw = 180,
    antiAimJitter = 60,
    antiAimInterval = 0.15,
    skeletonThickness = 1.5,
    bhopJumpPower = 52,
    bhopSpeedBoost = 1.35,
    bhopAutoJump = false,
    bhopAirStrafe = true,
    bhopMode = _V[1]({147,190,191,187},71,4),
    bhopMovingOnly = true,
    bhopPauseWithMenu = true,
    bhopGroundDelay = 0,
    bhopAcceleration = 12,
    walkMultiplier = 2.0,
    flightSpeed = 50,

    slideSpeedBoost = 1.8,
    slideFriction = 0.94,
    slideMinSpeed = 16,

    jumpCircleRadius = 3.5,
    jumpCircleSegmentCount = 48,
    jumpCircleStyle = _V[1]({136,92,244,160,78,243,165,84,224,147,81,233},152,169),

    grenadeMaxDist = 1500,
    showGrenadePath = true,
    showMolotovRadius = true,
    showSmokeRadius = true,
    grenadeDangerOpacity = 0.82,
    soundEspDuration = 1.15,
    soundEspMaxDist = 1200,

    espMaxDist = 3000,
    espTextSize = 8.5,
    tagTransparency = 0.25,
    espShowDistance = true,
    espShowHealth = true,
    tagShowWeapon = true,
    boxThickness = 1.0,
    espBoxSmoothing = 0.42,
    espFixedScale = true,
    espFixedBoxHeight = 36,
    espPerspectiveScale = 1.0,
    espBoxAspect = 0.52,
    espBoxOutline = true,

    nightPreset = _V[1]({18,109,167,240,42,103,167,242},134,63),
    nightBrightness = 0.2,
    nightClockTime = 0.0,
    worldSkyboxPreset = _V[1]({117,24,158,39,187},159,136),
    worldSkyRotation = 0,
    worldSkyStars = 0,
    worldSkyCelestial = false,
    worldFogStart = 0,
    worldFogEnd = 100000,
    worldExposure = 0,
    worldSaturation = 0,
    worldContrast = 0,
    worldTonePreset = _V[1]({160,61,211,88,220,81,226},204,134),
    worldAtmosphereEnabled = false,
    worldAtmosphereDensity = 0.3,
    worldAtmosphereHaze = 0,
    worldAtmosphereGlare = 0,
    worldBloomEnabled = false,
    worldBloomIntensity = 0.35,
    worldBloomSize = 24,
    worldBloomThreshold = 1,
    worldColorR = 255,
    worldColorG = 255,
    worldColorB = 255,
    bulletTracerStyle = _V[1]({111,96,42,229,180},102,199),
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
    weaponChamsMode = _V[1]({216,185,114,30,209,112,45},227,178),
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
    selectedKnifeType = _V[1]({164,241,10,36,47,86,100,132,171,108,177,238,3,26,51},72,26),
    selectedSkin = _V[1]({84,216,68,174},165,105),
    gloveChangerEnabled = false,
    selectedGloveModel = _V[1]({215,56,123,194,8,75,60,167,16,87,162,213,39},64,68),
    selectedGloveSkin = _V[1]({30,73,84,89,119,120,138},208,10),
    skinEditorWeapon = _V[1]({153,230,11,85,155},21,67),
    skinEditorFinish = _V[1]({197,33,93,147,226,20,87},70,59),
    skinWear = 0,
    knifeWear = 0,
    weaponSkinSelections = {},
    weaponSkinWear = {}
}

function deepCopyConfigValue(v)
    if type(v) ~= _V[1]({221,205,209,222,218},102,3) then return v end
    local out = {}
    for k,val in pairs(v) do out[k] = deepCopyConfigValue(val) end
    return out
end
local XCConfigDefaults = deepCopyConfigValue(XCConfig)

local sharedXCEnv = (type(getgenv) == _V[1]({88,39,224,149,102,27,225,160},50,192)) and getgenv() or nil
if sharedXCEnv then
    if type(sharedXCEnv.XCSharedConfig) == _V[1]({86,12,214,169,107},25,201) then
        local existing = sharedXCEnv.XCSharedConfig
        for key, value in pairs(XCConfig) do
            if existing[key] == nil then existing[key] = deepCopyConfigValue(value) end
        end
        XCConfig = existing
    else
        sharedXCEnv.XCSharedConfig = XCConfig
    end
end

for key, defaultValue in pairs(XCConfigDefaults) do
    if type(defaultValue) == _V[1]({201,57,156,252,88,183,39},4,99) then XCConfig[key] = defaultValue end
end

if tonumber(XCConfig.espFixedBoxHeight) == 64 or tonumber(XCConfig.espFixedBoxHeight) == 42 then
    XCConfig.espFixedBoxHeight = 36
end
XCConfig.espPerspectiveScale = math.clamp(tonumber(XCConfig.espPerspectiveScale) or 1, 0.65, 1.5)

local UI_Bind_Registry = {}

local lazyFeatureRequests = {
    fireRate = false,
    recoilSpread = false,
    silentFallback = false,
}

local Players = game:GetService(_V[1]({199,169,100,66,244,199,142},177,198))
local RunService = game:GetService(_V[1]({157,129,59,225,180,130,71,251,182,121},138,193))
local TweenService = game:GetService(_V[1]({226,18,13,26,48,34,65,91,108,108,115,130},129,13))
local UserInputService = game:GetService(_V[1]({88,145,158,198,184,248,21,53,79,73,118,158,189,203,224,253},232,27))
local CoreGui = game:GetService(_V[1]({47,100,112,108,87,142,139},227,9))
local GuiService = game:GetService(_V[1]({242,69,94,109,164,214,255,23,54,93},134,37))
local Lighting = game:GetService(_V[1]({235,149,32,174,71,201,91,225},18,141))
local Workspace = game:GetService(_V[1]({248,184,99,4,180,89,242,156,70},249,168))
local Stats = game:GetService(_V[1]({99,46,197,130,43},102,170))
local ReplicatedStorage = game:GetService(_V[1]({54,108,154,185,217,246,23,77,97,131,149,217,247,29,47,88,121},193,35))
local SoundService = game:GetService(_V[1]({177,226,253,11,22,26,65,99,124,132,147,170},73,21))
local ContentProvider = game:GetService(_V[1]({70,52,245,189,112,59,3,161,133,68,13,194,127,66,17},65,194))
local VirtualInputManager = nil

if not UserInputService.TouchEnabled then
    pcall(function()
        VirtualInputManager = game:GetService(_V[1]({234,51,114,170,225,3,68,87,178,234,37,90,105,179,246,31,91,143,210},94,54))
    end)
end

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

local camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass(_V[1]({137,202,249,20,68,86},35,35))

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
        return player:WaitForChild(_V[1]({105,38,188,117,2,176,38,245,138},120,161), 5) or player:FindFirstChildOfClass(_V[1]({37,31,242,232,178,157,80,92,46},247,222))
    end
    return nil
end

local targetGui = getSafeGui()
if not targetGui and player then
    pcall(function() targetGui = player:WaitForChild(_V[1]({159,246,38,121,160,232,248,97,144},20,59), 5) end)
end
if not targetGui then
    warn(_V[1]({86,13,178,134,3,228,172,90,235,238,173,98,39,214,136,77,4,207,112,61,236,172,101,209,209,134,72,5,184,113,1,161,169,100,207,223,132,73,0,181,43,12,212,130,19,29,200,147,64,3,195},65,186))
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

local genv = (type(getgenv) == _V[1]({50,207,86,217,120,251,143,28},62,142)) and getgenv() or nil
local xcSessionToken = {}
if genv then genv.XCSessionToken = xcSessionToken end
function xcSessionActive()
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

local themeLibrary = {
    [_V[1]({94,247,130,92,39,217,127},88,174)] = {
        Name = _V[1]({19,100,167,57,188,38,132},85,102),
        Background = Color3.fromRGB(18, 18, 22),
        Sidebar = Color3.fromRGB(22, 22, 27),
        CardBg = Color3.fromRGB(28, 28, 34),
        Accent = Color3.fromRGB(152, 204, 0),
        AccentHover = Color3.fromRGB(180, 225, 25),
        TextPrimary = Color3.fromRGB(240, 240, 245),
        TextSecondary = Color3.fromRGB(150, 150, 160),
        Border = Color3.fromRGB(45, 45, 55),
        GridSquare = Color3.fromRGB(25, 25, 30),

        Enemy_Accent = Color3.fromRGB(152, 204, 0),
        Enemy_Fill = Color3.fromRGB(112, 151, 0),
        Enemy_Hidden = Color3.fromRGB(112, 116, 122),
        NametagTextColor = Color3.fromRGB(152, 204, 0),
        HealthHigh = Color3.fromRGB(152, 204, 0),
        HealthMid = Color3.fromRGB(205, 170, 42),
        HealthLow = Color3.fromRGB(205, 72, 72),
        MolotovColor = Color3.fromRGB(255,95,35),
        SmokeColor = Color3.fromRGB(180,185,195),
        HEColor = Color3.fromRGB(255,45,55)
    }
}

local currentTheme = themeLibrary[_V[1]({92,219,76,12,189,85,225},112,148)]

local XCNotificationGui = nil
local XCNotificationHolder = nil
local XCNotificationSerial = 0

function ensureXCNotifications()
    if XCNotificationGui and XCNotificationGui.Parent and XCNotificationHolder and XCNotificationHolder.Parent then
        return true
    end

    pcall(function()
        local old = targetGui:FindFirstChild(_V[1]({94,156,250,110,198,14,94,180,1,82,184,0,89,171,3,42,171,242},179,83))
        if old then old:Destroy() end
    end)

    XCNotificationGui = Instance.new(_V[1]({48,113,177,213,6,64,74,169,206},172,49))
    XCNotificationGui.Name = _V[1]({35,140,21,180,55,170,37,166,30,154,43,158,34,159,34,116,32,146},77,126)
    XCNotificationGui.ResetOnSpawn = false
    XCNotificationGui.IgnoreGuiInset = true
    XCNotificationGui.DisplayOrder = 250
    XCNotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    XCNotificationGui.Parent = targetGui

    XCNotificationHolder = Instance.new(_V[1]({113,178,182,215,228},22,21))
    XCNotificationHolder.Name = _V[1]({27,114,173,216,11,68,116,168,241,28,88,141,157,250,45,91,146,213},151,54)
    XCNotificationHolder.AnchorPoint = Vector2.new(1, 1)
    XCNotificationHolder.Position = UDim2.new(1, -18, 1, -18)
    XCNotificationHolder.Size = UDim2.new(0, 300, 1, -36)
    XCNotificationHolder.BackgroundTransparency = 1
    XCNotificationHolder.Parent = XCNotificationGui

    local layout = Instance.new(_V[1]({169,254,98,224,75,173,230,92,213,44,147,243},243,97))
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
    title = tostring(title or _V[1]({47,238},3,212))
    message = tostring(message or _V[1]({},189,71))
    duration = tonumber(duration) or 2.5

    local accent = currentTheme.Accent
    if kind == _V[1]({125,231,61,165,15,133,237},162,104) then
        accent = Color3.fromRGB(75, 190, 105)
    elseif kind == _V[1]({155,116,116,95,73,61,37},53,239) then
        accent = Color3.fromRGB(225, 165, 55)
    elseif kind == _V[1]({226,205,171,134,103},159,222) then
        accent = Color3.fromRGB(225, 65, 70)
    end

    local card = Instance.new(_V[1]({80,129,117,134,131},5,5))
    card.Name = _V[1]({43,114,144,206,251,18},171,44) .. serial
    card.Size = UDim2.new(1, 0, 0, 64)
    card.BackgroundColor3 = currentTheme.Background
    card.BackgroundTransparency = 0.04
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.LayoutOrder = serial
    card.Parent = XCNotificationHolder

    local corner = Instance.new(_V[1]({69,175,31,193,58,172,25,156},122,118))
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    local stroke = Instance.new(_V[1]({171,81,13,224,144,63,237,153},164,178))
    stroke.Color = currentTheme.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.05
    stroke.Parent = card

    local accentBar = Instance.new(_V[1]({174,74,169,37,141},248,112))
    accentBar.Size = UDim2.new(0, 3, 1, -14)
    accentBar.Position = UDim2.new(0, 7, 0, 7)
    accentBar.BackgroundColor3 = accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card
    Instance.new(_V[1]({71,130,195,54,128,195,1,85},171,71), accentBar).CornerRadius = UDim.new(0, 2)

    local icon = Instance.new(_V[1]({250,251,254,234,178,183,168,155,146},182,240))
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0, 17, 0, 10)
    icon.BackgroundColor3 = currentTheme.Sidebar
    icon.BackgroundTransparency = 0.1
    icon.Text = kind == _V[1]({6,163,51,192,83},17,144) and _V[1]({139},233,129) or kind == _V[1]({45,16,26,15,3,1,243},189,249) and _V[1]({135},23,79) or _V[1]({169,181,254},117,82)
    icon.TextColor3 = accent
    icon.TextSize = 14
    icon.Font = Enum.Font.GothamBold
    icon.Parent = card
    Instance.new(_V[1]({131,27,185,137,48,208,107,28},138,164), icon).CornerRadius = UDim.new(1, 0)

    local titleLabel = Instance.new(_V[1]({121,110,101,69,1,250,223,198,177},65,228))
    titleLabel.Size = UDim2.new(1, -62, 0, 19)
    titleLabel.Position = UDim2.new(0, 53, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = currentTheme.TextPrimary
    titleLabel.TextSize = 9
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = card

    local msgLabel = Instance.new(_V[1]({208,159,112,42,192,147,82,19,216},190,190))
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

    local progress = Instance.new(_V[1]({180,207,173,168,143},127,239))
    progress.Size = UDim2.new(1, -14, 0, 2)
    progress.Position = UDim2.new(0, 7, 1, -5)
    progress.BackgroundColor3 = currentTheme.Sidebar
    progress.BorderSizePixel = 0
    progress.Parent = card

    local fill = Instance.new(_V[1]({202,159,55,236,141},219,169))
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

local isAiming = false
local currentAimTarget = nil
local lastTargetSwitchTick = 0
local TARGET_HYSTERESIS_TIME = 0.12
local aimboneIndex = 1

function rgb(r,g,b)
    return Color3.fromRGB(
        math.clamp(math.floor(tonumber(r) or 255), 0, 255),
        math.clamp(math.floor(tonumber(g) or 255), 0, 255),
        math.clamp(math.floor(tonumber(b) or 255), 0, 255)
    )
end

local silentAimResolved = nil

local getSilentAimTarget
local silentAimCamPosAim
local registerXCLocalHitCandidate
local hitmarkerPendingHits = {}
local silentAimHooked = false
local silentAimCamHooked = false
local bloxStrikeShootHooked = false
local xcNativeSilentHooked = false
local xcBulletInterceptHooked = false
local xcMobileCameraSilentHooked = false

local function setXCSilentAimRequested(value)
    if sharedXCEnv then sharedXCEnv.XCSilentAimRequestedV25 = value == true end
end

local function isXCSilentAimRequested()
    if sharedXCEnv and sharedXCEnv.XCSilentAimRequestedV25 ~= nil then
        return sharedXCEnv.XCSilentAimRequestedV25 == true
    end
    return XCConfig.silentAimEnabled == true
end
setXCSilentAimRequested(XCConfig.silentAimEnabled)

local function recordXCLocalHitPayload(data)
    if not registerXCLocalHitCandidate or type(data) ~= _V[1]({99,139,199,12,64},180,59) or type(data.Bullets) ~= _V[1]({243,106,245,137,12},245,138) then
        return
    end
    for _, bullet in pairs(data.Bullets) do
        if type(bullet) == _V[1]({237,15,69,132,178},68,53) and type(bullet.Hits) == _V[1]({94,106,138,179,203},203,31) then
            for _, hitData in pairs(bullet.Hits) do
                if type(hitData) == _V[1]({81,163,9,120,214},120,101) then
                    local hitInstance = hitData.Instance or hitData.instance
                    if typeof(hitInstance) == _V[1]({43,30,241,192,123,86,25,233},20,206) then
                        registerXCLocalHitCandidate(hitInstance)
                    end
                end
            end
        end
    end
end

if sharedXCEnv then
    sharedXCEnv.XCRecordLocalHitPayload = recordXCLocalHitPayload
end

local function dispatchXCLocalHitPayload(data)
    local recorder = sharedXCEnv and sharedXCEnv.XCRecordLocalHitPayload or recordXCLocalHitPayload
    if type(recorder) == _V[1]({170,124,56,240,196,124,69,7},129,195) then recorder(data) end
end

local function prepareXCSilentShotPayload(data, forceSendStage)

    if not forceSendStage and (xcNativeSilentHooked or UserInputService.TouchEnabled) then
        return data, false
    end
    local silentEnabled = forceSendStage and isXCSilentAimRequested() or XCConfig.silentAimEnabled
    if not silentEnabled
        or type(data) ~= _V[1]({224,11,74,146,201},46,62)
        or type(data.Bullets) ~= _V[1]({88,52,36,29,5},245,239) then
        return data, false
    end

    local targetPart = getSilentAimTarget and getSilentAimTarget() or silentAimResolved
    if not targetPart or not targetPart.Parent then return data, false end

    local chance = math.clamp(tonumber(XCConfig.silentAimHitChance) or 100, 0, 100)
    if chance < 100 and math.random(1, 100) > chance then return data, false end

    local camPos, aimPos = nil, nil
    if forceSendStage then
        local activeCamera = Workspace.CurrentCamera or camera
        if activeCamera then
            camPos = activeCamera.CFrame.Position
            aimPos = getKinematicAimPosition(targetPart)
        end
    elseif silentAimCamPosAim then
        camPos, aimPos = silentAimCamPosAim(targetPart)
    end
    if not camPos or not aimPos then return data, false end

    local shotData = {}
    for key, value in pairs(data) do shotData[key] = value end
    local shotBullets = {}
    shotData.Bullets = shotBullets

    for key, bullet in pairs(data.Bullets) do
        if type(bullet) ~= _V[1]({3,12,41,79,100},115,28) then
            shotBullets[key] = bullet
        else
            local shotBullet = {}
            for bulletKey, value in pairs(bullet) do shotBullet[bulletKey] = value end
            shotBullets[key] = shotBullet

            local origin = bullet.Origin or bullet.StartingPoint or bullet.Position or camPos
            if typeof(origin) == _V[1]({52,132,253,57,146,215},164,77) then origin = origin.Position end
            if typeof(origin) ~= _V[1]({117,40,202,127,30,197,42},123,164) then origin = camPos end

            local delta = aimPos - origin
            if delta.Magnitude > 0.001 then

                if typeof(bullet.Direction) == _V[1]({209,128,30,207,106,13,110},219,160) then
                    local magnitude = bullet.Direction.Magnitude
                    shotBullet.Direction = delta.Unit * (magnitude > 0.001 and magnitude or 1)
                end
                if typeof(bullet.Ray) == _V[1]({63,162,14},153,84) then
                    local magnitude = bullet.Ray.Direction.Magnitude
                    shotBullet.Ray = Ray.new(bullet.Ray.Origin, delta.Unit * magnitude)
                end
            end

            if type(bullet.Hits) == _V[1]({104,116,148,189,213},213,31) then
                local shotHits = {}
                shotBullet.Hits = shotHits
                for hitKey, hitData in pairs(bullet.Hits) do
                    if type(hitData) == _V[1]({252,194,156,127,81},175,217) then
                        local shotHit = {}
                        for field, value in pairs(hitData) do shotHit[field] = value end
                        shotHit.Instance = targetPart
                        shotHit.Position = targetPart.Position
                        shotHits[hitKey] = shotHit
                    else
                        shotHits[hitKey] = hitData
                    end
                end
            end

            if XCConfig.wallbangEnabled then
                shotBullet.Penetration = 9999
                shotBullet.Wallbang = true
                shotBullet.IgnoreEnvironment = true
            end
        end
    end

    silentAimResolved = targetPart
    if registerXCLocalHitCandidate then registerXCLocalHitCandidate(targetPart) end
    return shotData, true
end

if sharedXCEnv then

    sharedXCEnv.XCPrepareSilentShotPayloadV23 = function(data) return data, false end
    sharedXCEnv.XCPrepareSilentSendPayloadV28 = function(data)
        return data, false
    end
end

local function dispatchXCPrepareSilentShotPayload(data)
    return data, false
end

local function callXCShotWithoutLegacyRewrite(callback, self, data, ...)
    local silentWasEnabled = XCConfig.silentAimEnabled
    XCConfig.silentAimEnabled = false
    local results = table.pack(pcall(callback, self, data, ...))
    XCConfig.silentAimEnabled = silentWasEnabled
    if not results[1] then error(results[2], 0) end
    return table.unpack(results, 2, results.n)
end

function setupBloxStrikeShootHook()
    if bloxStrikeShootHooked then return end

    pcall(function()
        local visualInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                local char = player.Character
                local tool = char and char:FindFirstChildOfClass(_V[1]({60,245,147,46},74,158))

                if (XCConfig.bulletTrailEnabled or XCConfig.bulletFlashEnabled) and tool then
                    local cam = Workspace.CurrentCamera or camera
                    if not cam then return end

                    local origin = cam.CFrame.Position
                    local muzzle = tool:FindFirstChild(_V[1]({251,93,156,214,2,53},116,58)) or tool:FindFirstChild(_V[1]({49,241,165,66,241,145},66,167))
                    if muzzle and muzzle:IsA(_V[1]({46,245,175,73,220,149,78,248},68,168)) then
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
                        local trail = Instance.new(_V[1]({240,250,4,255},167,249))
                        trail.Anchored = true
                        trail.CanCollide = false
                        trail.CanTouch = false
                        trail.CanQuery = false
                        trail.CastShadow = false
                        trail.Material = (XCConfig.bulletTracerStyle == _V[1]({47,157,200,253,58,104,161,230},180,56)) and Enum.Material.Neon or Enum.Material.Neon
                        trail.Color = XCConfig.bulletTracerRainbow and Color3.fromHSV((os.clock()*0.35)%1,0.9,1) or rgb(XCConfig.bulletTracerColorR,XCConfig.bulletTracerColorG,XCConfig.bulletTracerColorB)
                        local width = math.clamp(tonumber(XCConfig.bulletTracerWidth) or 0.08, 0.02, 0.5)
                        if XCConfig.bulletTracerStyle == _V[1]({34,175,249,77,169,246,78,178},136,87) then
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
                        local impact = Instance.new(_V[1]({177,151,125,84},140,213))
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
                        local flash = Instance.new(_V[1]({93,202,55,149},177,92))
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
        local controllers = ReplicatedStorage:FindFirstChild(_V[1]({202,30,69,115,153,190,227,11,44,97,138},95,40))
        local moduleScript = controllers and controllers:FindFirstChild(_V[1]({116,122,99,51,29,4,224,196,172,87,100,68,43,10,232,198,167,129,111},74,225))
        if not moduleScript then return end

        local inventoryController = require(moduleScript)
        if type(inventoryController) ~= _V[1]({24,182,104,35,205},243,177) then return end
        if type(inventoryController.ShootWeapon) ~= _V[1]({44,151,236,61,170,251,93,184},106,92) then return end
        if rawget(inventoryController, _V[1]({76,155,227,29,124,225,51,123,211,40,68,187,14,67,160,244,66,116,234,57,132,190,233,59},158,79)) then
            bloxStrikeShootHooked = true
            return
        end

        local originalShootWeapon = inventoryController.ShootWeapon
        inventoryController.ShootWeapon = function(self, data, ...)

            setXCSilentAimRequested(XCConfig.silentAimEnabled)
            local shotData = dispatchXCPrepareSilentShotPayload(data)

            dispatchXCLocalHitPayload(shotData)

            return callXCShotWithoutLegacyRewrite(originalShootWeapon, self, shotData, ...)
        end

        rawset(inventoryController, _V[1]({48,250,189,114,76,43,252,198,149,51,36,238,180,120,65},7,202), true)
        rawset(inventoryController, _V[1]({184,101,11,163,85,35,219,87,48,220,129,49,231,143,23,235,152,65,217,97,21},172,173), true)
        rawset(inventoryController, _V[1]({236,188,133,64,32,6,217,162,123,81,238,230,186,112,78,35,242,165,156,108,56,243,159,112},189,208), true)
        rawset(inventoryController, _V[1]({226,199,165,117,106,101,77,43,25,4,182,195,172,119,106,84,56,0,12,241,210,162,99,75},158,229), true)
        bloxStrikeShootHooked = true
    end)
end

local noRecoil = {
    isShooting = false
}

local fireStartConn = UserInputService.InputBegan:Connect(function(input)

    if not UserInputService.TouchEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        noRecoil.isShooting = true
    end
end)
table.insert(connections, fireStartConn)

local fireEndConn = UserInputService.InputEnded:Connect(function(input)
    if not UserInputService.TouchEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        noRecoil.isShooting = false
    end
end)
table.insert(connections, fireEndConn)

function isAlly(plr)
    if not plr or plr == player then return true end
    if not XCConfig.chamsTeamCheck then return false end

    if plr.Team and player.Team then
        return plr.Team == player.Team
    end
    if plr:GetAttribute(_V[1]({212,135,37,211},222,162)) and player:GetAttribute(_V[1]({201,19,72,141},60,57)) then
        return plr:GetAttribute(_V[1]({114,108,81,70},53,233)) == player:GetAttribute(_V[1]({255,246,216,202},197,230))
    end
    if plr.TeamColor and player.TeamColor and plr.TeamColor ~= BrickColor.new(_V[1]({164,49,174,53,162},209,124)) then
        return plr.TeamColor == player.TeamColor
    end
    return false
end

function isTargetEnemy(plr, char)
    if not plr or plr == player then return false end
    if char and char == player.Character then return false end
    return not isAlly(plr)
end

function getXCHealth(char, plr, hum)
    local health, maximum
    if char then
        health = char:GetAttribute(_V[1]({192,14,59,119,176,213},71,49))
        maximum = char:GetAttribute(_V[1]({85,208,78,133,9,108,222,77,168},161,103))
    end
    if type(health) ~= _V[1]({35,46,42,35,42,59},177,4) and plr then health = plr:GetAttribute(_V[1]({45,93,108,138,165,172},210,19)) end
    if type(maximum) ~= _V[1]({42,57,57,54,65,86},180,8) and plr then maximum = plr:GetAttribute(_V[1]({251,22,52,11,47,50,68,83,78},167,7)) end
    if type(health) ~= _V[1]({189,114,24,187,108,39},161,174) then health = tonumber(health) end
    if type(maximum) ~= _V[1]({10,99,173,244,73,168},74,82) then maximum = tonumber(maximum) end
    if type(health) ~= _V[1]({165,148,116,81,60,49},79,232) and hum then health = hum.Health end
    if type(maximum) ~= _V[1]({63,82,86,87,102,127},197,12) and hum then maximum = hum.MaxHealth end
    if type(health) ~= _V[1]({68,118,153,185,231,31},171,43) or health ~= health then return nil, nil end
    if type(maximum) ~= _V[1]({126,182,223,5,57,119},223,49) or maximum ~= maximum or maximum <= 0 then maximum = 100 end
    return math.clamp(health, 0, maximum), maximum
end

registerXCLocalHitCandidate = function(hitInstance)
    local cursor = hitInstance
    local targetPlayer, targetCharacter
    while cursor and cursor ~= Workspace do
        if cursor:IsA(_V[1]({26,165,3,109,221},100,105)) then
            local candidate = Players:GetPlayerFromCharacter(cursor)
            if candidate then
                targetPlayer, targetCharacter = candidate, cursor
                break
            end
        end
        cursor = cursor.Parent
    end
    if not targetPlayer or not isTargetEnemy(targetPlayer, targetCharacter) then return end
    local hum = targetCharacter:FindFirstChildOfClass(_V[1]({247,61,78,91,129,155,174,194},150,25))
    local health = getXCHealth(targetCharacter, targetPlayer, hum)
    if health == nil then return end
    local healthKey = hum or targetCharacter
    local pending = hitmarkerPendingHits[healthKey]
    if pending and pending.Expires > os.clock() then
        pending.Expires = os.clock() + 1.5
        pending.HitCount += 1
        return
    end
    hitmarkerPendingHits[healthKey] = {
        Character = targetCharacter,
        Player = targetPlayer,
        Health = health,
        Expires = os.clock() + 1.5,
        HitCount = 1,
    }
end

function getTargetHitbox(char)
    if not char then return nil end
    if XCConfig.bodyAimOnly then
        return char:FindFirstChild(_V[1]({36,112,161,199,5,24,100,152,202,247},158,49)) or char:FindFirstChild(_V[1]({58,232,97,214,100,230,97,221,76,234,107,241,78,224,114,245},113,129)) or char:FindFirstChild(_V[1]({46,254,182,108,29},37,181))
    end
    if aimboneIndex == 1 then
        return char:FindFirstChild(_V[1]({144,83,245,158},162,166)) or char:FindFirstChild(_V[1]({0,67,107,136,189,199,10,53,94,130},131,40))
    elseif aimboneIndex == 2 then
        return char:FindFirstChild(_V[1]({90,41,221,134,71,221,172,99,24,200},81,180)) or char:FindFirstChild(_V[1]({59,148,213,20,78},169,62)) or char:FindFirstChild(_V[1]({235,231,194,164},196,223))
    else
        return char:FindFirstChild(_V[1]({120,133,93,49,30,255,217,180,130,127,95,68,0,241,226,196},80,224)) or char:FindFirstChild(_V[1]({254,120,215,43,151,216,82,180,20,111},74,95)) or char:FindFirstChild(_V[1]({195,118,8,161},229,150))
    end
end

function isEntityAlive(char, hum)
    if not char or not char.Parent or not char:IsDescendantOf(Workspace) then
        return false
    end

    local health = getXCHealth(char, Players:GetPlayerFromCharacter(char), hum)
    if health ~= nil and health <= 0 then return false end
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

    local root = char:FindFirstChild(_V[1]({128,57,189,61,214,99,233,112,234,147,31,176,24,181,82,224},172,140)) or char:FindFirstChild(_V[1]({245,169,69,223,116},8,153)) or char:FindFirstChild(_V[1]({19,210,118,15,192,70,5,172,81,241},26,164))
    local head = char:FindFirstChild(_V[1]({145,143,108,80},104,225))
    if not root and not head then
        return false
    end

    return true
end

local wallRayParams = RaycastParams.new()
wallRayParams.FilterType = Enum.RaycastFilterType.Exclude
wallRayParams.IgnoreWater = true

function isVisibleThroughWalls(targetPart, targetChar)
    if not camera or not targetPart or not targetChar then return false end
    local myChar = player.Character
    wallRayParams.FilterDescendantsInstances = {myChar, camera}
    local origin = camera.CFrame.Position
    local dir = targetPart.Position - origin

    local hit = Workspace:Raycast(origin, dir, wallRayParams)
    if not hit then return true end
    return hit.Instance == targetPart or hit.Instance:IsDescendantOf(targetChar)
end

getSilentAimTarget = function()
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end
    local screenCenter = cam.ViewportSize * 0.5
    local maxRadius = math.max(1, tonumber(XCConfig.silentAimFov) or 150)
    local best, bestRadius = nil, maxRadius
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == player then continue end
        if XCConfig.silentAimTeamCheck and isAlly(plr) then continue end
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass(_V[1]({1,125,196,7,99,179,252,70},106,79))
        if not isEntityAlive(char, hum) then continue end
        local part = char:FindFirstChild(XCConfig.silentAimAimHead and _V[1]({244,208,139,77},237,191) or _V[1]({47,208,60,164,37,154,8,119,217,106,222,87,167,44,177,39},115,116))
            or char:FindFirstChild(_V[1]({164,158,128,96,59},113,223))
        if not part or not part:IsA(_V[1]({218,230,229,196,156,154,152,135},171,237)) then continue end

        if not XCConfig.wallbangEnabled or XCConfig.silentAimVisibleCheck then
            local visible = isVisibleThroughWalls(part, char)
            if not visible then continue end
        end
        local predictedPos = getKinematicAimPosition(part)
        local point, onScreen = cam:WorldToViewportPoint(predictedPos)
        if not onScreen or point.Z <= 0 then continue end
        local radius = (Vector2.new(point.X, point.Y) - screenCenter).Magnitude
        if radius < bestRadius then
            bestRadius = radius
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

    return camPos, aimPos
end

local xcSilentShotContextV31 = nil
local xcSilentShootWrappedV31 = sharedXCEnv and sharedXCEnv.XCSilentShootWrappedV31
if type(xcSilentShootWrappedV31) ~= _V[1]({230,190,170,159,131},135,235) then
    xcSilentShootWrappedV31 = setmetatable({}, {__mode = _V[1]({90},11,228)})
    if sharedXCEnv then sharedXCEnv.XCSilentShootWrappedV31 = xcSilentShootWrappedV31 end
end

local function enterXCSilentShotV31(weapon)
    local thread = coroutine.running()
    local context = sharedXCEnv and sharedXCEnv.XCSilentShotContextV31 or xcSilentShotContextV31
    if context and context.Thread == thread then
        context.Depth = (context.Depth or 1) + 1
        return context
    end

    local targetPart = nil
    local allowed = false
    if isXCSilentAimRequested() then
        targetPart = getSilentAimTarget and getSilentAimTarget() or silentAimResolved
        local chance = math.clamp(tonumber(XCConfig.silentAimHitChance) or 100, 0, 100)
        allowed = targetPart ~= nil and targetPart.Parent ~= nil
            and (chance >= 100 or math.random(1, 100) <= chance)
    end

    context = {
        Thread = thread,
        Weapon = weapon,
        Target = targetPart,
        Allowed = allowed,
        CameraUsed = false,
        PayloadUsed = false,
        Depth = 1,
    }
    xcSilentShotContextV31 = context
    if sharedXCEnv then sharedXCEnv.XCSilentShotContextV31 = context end
    return context
end

local function leaveXCSilentShotV31()
    local context = sharedXCEnv and sharedXCEnv.XCSilentShotContextV31 or xcSilentShotContextV31
    if not context or context.Thread ~= coroutine.running() then return end
    context.Depth = (context.Depth or 1) - 1
    if context.Depth > 0 then return end
    xcSilentShotContextV31 = nil
    if sharedXCEnv then sharedXCEnv.XCSilentShotContextV31 = nil end
end

if sharedXCEnv then
    sharedXCEnv.XCEnterSilentShotV31 = enterXCSilentShotV31
    sharedXCEnv.XCLeaveSilentShotV31 = leaveXCSilentShotV31
end

local function getXCSilentShotContextV31(requireAllowed)
    local context = sharedXCEnv and sharedXCEnv.XCSilentShotContextV31 or xcSilentShotContextV31
    if not context or context.Thread ~= coroutine.running() then return nil end
    if requireAllowed and (not context.Allowed or not context.Target or not context.Target.Parent) then
        return nil
    end
    return context
end

local function wrapXCEquippedShootV31()
    if not UserInputService.TouchEnabled then return false end
    local controllers = ReplicatedStorage:FindFirstChild(_V[1]({78,114,105,103,93,82,71,63,48,53,46},19,248))
    local moduleScript = controllers and controllers:FindFirstChild(_V[1]({61,120,150,155,186,214,231,0,29,253,63,84,112,132,151,170,192,207,242},222,22))
    local inventory = moduleScript and require(moduleScript)
    local getter = inventory and inventory.peekCurrentEquippedForMovement
    local weapon = type(getter) == _V[1]({43,236,151,62,1,168,96,17},19,178) and getter() or nil
    if type(weapon) ~= _V[1]({205,106,27,213,126},169,176) or type(weapon.shoot) ~= _V[1]({70,206,64,174,56,166,37,157},103,121) or weapon.IsDestroyed then
        return false
    end

    local record = xcSilentShootWrappedV31[weapon]
    if record and weapon.shoot == record.Wrapper then return true end

    local originalShoot = weapon.shoot
    local wrapper
    wrapper = function(self, ...)
        local enter = sharedXCEnv and sharedXCEnv.XCEnterSilentShotV31 or enterXCSilentShotV31
        local leave = sharedXCEnv and sharedXCEnv.XCLeaveSilentShotV31 or leaveXCSilentShotV31
        if type(enter) == _V[1]({204,141,56,223,162,73,1,178},180,178) then enter(self) end
        local results = table.pack(pcall(originalShoot, self, ...))
        if type(leave) == _V[1]({153,253,75,149,251,69,160,244},222,85) then leave() end
        if not results[1] then error(results[2], 0) end
        return table.unpack(results, 2, results.n)
    end

    local ok = pcall(function() weapon.shoot = wrapper end)
    if ok and weapon.shoot == wrapper then
        xcSilentShootWrappedV31[weapon] = {Wrapper = wrapper, Original = originalShoot}
        return true
    end
    return false
end

function setupSilentAimHooks()
    if silentAimHooked and silentAimCamHooked then return end

    if not silentAimHooked and UserInputService.TouchEnabled then

        silentAimHooked = true
    elseif not silentAimHooked and hookmetamethod then
        pcall(function()
            local mouse = player:GetMouse()
            local oldIndex
            oldIndex = hookmetamethod(mouse, _V[1]({132,206,34,113,177,252,89},219,74), function(self, key)
                if XCConfig.silentAimEnabled and silentAimResolved and (key == _V[1]({226,71,150},86,68) or key == _V[1]({129,43,183,83,194,98,11},155,145)) then
                    local camPos, aimPos = silentAimCamPosAim()
                    if camPos then
                        if key == _V[1]({223,245,245},162,245) then
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

    if UserInputService.TouchEnabled and xcNativeSilentHooked then
        silentAimCamHooked = true
    end

    if not silentAimCamHooked and hookmetamethod and getnamecallmethod then
        local cameraHookInstalled = pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, _V[1]({192,162,147,104,86,48,16,240,221,191},127,226), function(self, ...)
                local method = getnamecallmethod()
                local args = {...}

                local activeCamera = Workspace.CurrentCamera or camera
                if self == activeCamera
                    and (method == _V[1]({149,40,164,54,175,46,177,51,143,46,168,45,179,19,174,17,160,56},191,128) or method == _V[1]({127,254,124,222,77,197,22,164,13,129,246,69,207,33,159,38},189,111)) then
                    if UserInputService.TouchEnabled then
                        local context = getXCSilentShotContextV31(true)

                        local requested = sharedXCEnv and sharedXCEnv.XCSilentAimRequestedV25
                        if sharedXCEnv then sharedXCEnv.XCSilentAimRequestedV25 = false end
                        local originalRay = oldNamecall(self, ...)
                        if sharedXCEnv then sharedXCEnv.XCSilentAimRequestedV25 = requested end

                        if context and typeof(originalRay) == _V[1]({101,186,24},205,70) then
                            context.CameraUsed = true
                            local aimPos = getKinematicAimPosition(context.Target)
                            local delta = aimPos - originalRay.Origin
                            if delta.Magnitude > 0.001 then
                                local magnitude = originalRay.Direction.Magnitude
                                return Ray.new(originalRay.Origin, delta.Unit * (magnitude > 0.001 and magnitude or 1))
                            end
                        end
                        return originalRay
                    elseif isXCSilentAimRequested() and noRecoil.isShooting then
                        local targetPart = silentAimResolved
                        if targetPart and targetPart.Parent then
                            local originalRay = oldNamecall(self, ...)
                            if typeof(originalRay) == _V[1]({194,35,141},30,82) then
                                local aimPos = getKinematicAimPosition(targetPart)
                                local delta = aimPos - originalRay.Origin
                                if delta.Magnitude > 0.001 then
                                    local magnitude = originalRay.Direction.Magnitude
                                    return Ray.new(originalRay.Origin, delta.Unit * (magnitude > 0.001 and magnitude or 1))
                                end
                            end
                        end
                    end
                end

                if XCConfig.pSilentEnabled and silentAimResolved and self == Workspace then
                    local camPos, aimPos = silentAimCamPosAim()
                    if aimPos then
                        if method == _V[1]({251,145,48,161,38,191,71},34,135) then
                            local origin = args[1]
                            local originalDirection = args[2]
                            if typeof(origin) == _V[1]({119,32,184,99,248,149,240},135,154) and typeof(originalDirection) == _V[1]({34,160,13,141,247,105,153},93,111) then
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
                        elseif method == _V[1]({239,233,197,146,85,61,37,254,176,166,97,71,54},210,215)
                            or method == _V[1]({168,108,18,169,54,232,154,61,185,121,254,174,103,230,153,69,218,92,27,195,101,9,157,37,227,142,48},193,161)
                            or method == _V[1]({77,189,15,82,139,233,71,150,190,42,91,183,28,71,166,254,63,123,217,39,127,189,17,91,178,0},186,77) then
                            local oldRay = args[1]
                            if typeof(oldRay) == _V[1]({148,252,109},233,89) then
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
        silentAimCamHooked = cameraHookInstalled
        if UserInputService.TouchEnabled and cameraHookInstalled then
            xcMobileCameraSilentHooked = true
        end
    end
end

local xcNativeRaycast = nil
local xcNativeGetRayIgnore = nil

local function castXCNativeSilentShot(origin, direction, properties)
    if not xcNativeRaycast or type(xcNativeRaycast.cast) ~= _V[1]({190,9,62,111,188,237,47,106},28,60)
        or type(xcNativeRaycast.castThrough) ~= _V[1]({135,12,123,230,109,216,84,201},171,118)
        or type(xcNativeGetRayIgnore) ~= _V[1]({41,93,123,149,203,229,16,52},158,37) then
        return nil
    end

    local range = math.max(1, tonumber(properties and properties.Range) or 500)
    local penetration = math.max(0, tonumber(properties and properties.Penetration) or 0)
    local maxSurfaces = 24
    if XCConfig.wallbangEnabled then
        penetration = math.max(penetration, range)
        maxSurfaces = 100
    end

    local ignore = xcNativeGetRayIgnore()
    local result = {Origin = origin, Direction = direction, Distance = range, Hits = {}}
    local first = xcNativeRaycast.cast(origin, direction * range, nil, ignore)
    if type(first) ~= _V[1]({14,42,90,147,187},107,47) or not first.instance then return result end
    if typeof(first.position) == _V[1]({114,237,87,212,59,170,215},176,108) then
        result.Distance = (first.position - origin).Magnitude
    end

    local throughDistance = math.max(penetration, 0.001)
    local hits = xcNativeRaycast.castThrough(
        first.position - direction * 0.001,
        direction * (throughDistance + 0.001),
        penetration,
        ignore
    )
    if type(hits) ~= _V[1]({95,69,63,66,52},242,249) then return result end
    for index, hit in ipairs(hits) do
        if index > maxSurfaces * 2 then break end
        if type(hit) == _V[1]({39,30,41,61,64},169,10) and hit.instance and hit.material and typeof(hit.position) == _V[1]({161,210,242,37,66,103,74},41,34) then
            if (hit.position - origin).Magnitude > range + 0.01 then break end
            table.insert(result.Hits, {
                Position = hit.position,
                Instance = hit.instance,
                Material = hit.material.Name,
                Normal = hit.normal or Vector3.zero,
                Exit = index % 2 == 0,
            })
        end
    end
    return result
end

local function selectXCNativeSilentTarget(origin, properties)
    local cam = Workspace.CurrentCamera or camera
    if not cam or typeof(origin) ~= _V[1]({47,93,122,170,196,230,198},186,31) or not xcNativeRaycast
        or type(xcNativeRaycast.cast) ~= _V[1]({252,205,136,63,18,201,145,82},212,194) or type(xcNativeGetRayIgnore) ~= _V[1]({168,227,8,41,102,135,185,228},22,44) then
        return nil
    end

    local center = cam.ViewportSize * 0.5
    local radiusLimit = math.max(1, tonumber(XCConfig.silentAimFov) or 150)
    local range = math.max(1, tonumber(properties and properties.Range) or 500)
    local ignore = xcNativeGetRayIgnore()
    local candidates = {}

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer == player then continue end
        if XCConfig.silentAimTeamCheck and isAlly(targetPlayer) then continue end
        local character = targetPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass(_V[1]({108,71,237,143,74,249,161,74},118,174))
        if not isEntityAlive(character, humanoid) then continue end
        local part = character:FindFirstChild(XCConfig.silentAimAimHead and _V[1]({98,166,201,243},243,39) or _V[1]({234,36,41,42,68,82,89,97,92,134,147,165,142,172,202,217},149,13))
            or character:FindFirstChild(_V[1]({101,42,212,115,42,182,123,40,211,121},102,170)) or character:FindFirstChild(_V[1]({74,238,122,4,137},109,137))
        if not part or not part:IsA(_V[1]({41,31,8,209,147,123,99,60},16,215)) then continue end

        local position = part.Position
        local point, onScreen = cam:WorldToViewportPoint(position)
        local distance = (position - origin).Magnitude
        if onScreen and point.Z > 0 and distance > 0.05 and distance <= range then
            local radius = (Vector2.new(point.X, point.Y) - center).Magnitude
            if radius <= radiusLimit then
                candidates[#candidates + 1] = {
                    Player = targetPlayer,
                    Character = character,
                    Part = part,
                    Position = position,
                    Radius = radius,
                }
            end
        end
    end

    table.sort(candidates, function(a, b)
        if a.Radius ~= b.Radius then return a.Radius < b.Radius end
        return a.Player.UserId < b.Player.UserId
    end)

    for _, candidate in ipairs(candidates) do
        local offset = candidate.Position - origin
        local first = xcNativeRaycast.cast(origin, offset.Unit * (offset.Magnitude + 0.05), nil, ignore)
        local firstInstance = type(first) == _V[1]({49,197,109,30,190},22,167) and (first.instance or first.Instance) or nil
        local visible = not firstInstance or (typeof(firstInstance) == _V[1]({56,208,72,188,28,156,4,121},124,115)
            and (firstInstance == candidate.Part or firstInstance:IsDescendantOf(candidate.Character)))

        if visible then return candidate end
        if XCConfig.wallbangEnabled and not XCConfig.silentAimVisibleCheck then
            local penetrated = castXCNativeSilentShot(origin, offset.Unit, properties or {})
            if penetrated and type(penetrated.Hits) == _V[1]({11,196,145,103,44},203,204) then
                for _, impact in ipairs(penetrated.Hits) do
                    local instance = impact.Instance or impact.instance
                    if typeof(instance) == _V[1]({66,21,200,119,18,205,112,32},75,174) and not impact.Exit
                        and instance:IsDescendantOf(candidate.Character) then
                        return candidate
                    end
                end
            end
        end
    end
    return nil
end

local function redirectXCNativeSilentShot(bullet, shot)
    if not isXCSilentAimRequested() or type(shot) ~= _V[1]({209,252,59,131,186},31,62)
        or typeof(shot.Origin) ~= _V[1]({191,124,40,231,144,65,176},187,174) then return shot end
    if type(bullet) ~= _V[1]({100,160,240,73,145},161,79) or bullet.IsDestroyed or not bullet.IsActive then return shot end
    local weapon = bullet.Weapon
    if not weapon or weapon.Player ~= player then return shot end

    local chance = math.clamp(tonumber(XCConfig.silentAimHitChance) or 100, 0, 100)
    if chance < 100 and math.random(1, 100) > chance then return shot end

    local target = selectXCNativeSilentTarget(shot.Origin, bullet.Properties or {})
    local targetPart = target and target.Part
    if not targetPart or not targetPart.Parent then return shot end

    local aimPosition = target.Position
    local offset = aimPosition - shot.Origin
    if offset.Magnitude < 0.05 then return shot end

    local redirected = castXCNativeSilentShot(shot.Origin, offset.Unit, bullet.Properties or {})
    if not redirected then return shot end
    silentAimResolved = targetPart
    if registerXCLocalHitCandidate then registerXCLocalHitCandidate(targetPart) end
    return redirected
end

if sharedXCEnv then

    sharedXCEnv.XCNativeSilentRedirectV24 = function(_, shot) return shot end
    sharedXCEnv.XCNativeSilentRedirectV36 = redirectXCNativeSilentShot
end

function setupXCNativeSilentHook()
    if xcNativeSilentHooked then return true end

    local installed = false
    pcall(function()
        local components = ReplicatedStorage:FindFirstChild(_V[1]({47,54,15,237,199,161,115,87,56,18},17,219))
        local weaponFolder = components and components:FindFirstChild(_V[1]({113,211,35,134,217,44},198,84))
        local classes = weaponFolder and weaponFolder:FindFirstChild(_V[1]({79,102,73,73,55,23,19},30,238))
        local bulletScript = classes and classes:FindFirstChild(_V[1]({65,209,37,130,216,68},162,93))
        local common = components and components:FindFirstChild(_V[1]({34,3,182,107,34,214},42,181))
        local ignoreScript = common and common:FindFirstChild(_V[1]({77,167,242,12,87,171,183,17,84,145,208,255},202,60))
        local sharedFolder = ReplicatedStorage:FindFirstChild(_V[1]({135,47,187,95,229,119},161,147))
        local raycastScript = sharedFolder and sharedFolder:FindFirstChild(_V[1]({61,210,112,224,100,252,131},101,134))
        if not bulletScript or not ignoreScript or not raycastScript then return end

        local bulletModule = require(bulletScript)
        local raycastModule = require(raycastScript)
        local getRayIgnore = require(ignoreScript)
        if type(bulletModule) ~= _V[1]({252,250,12,39,49},119,17) or type(bulletModule._performRaycast) ~= _V[1]({53,145,215,25,119,185,12,88},130,77)
            or type(raycastModule) ~= _V[1]({114,52,10,233,183},41,213) or type(raycastModule.cast) ~= _V[1]({33,116,177,234,63,120,194,5},119,68)
            or type(raycastModule.castThrough) ~= _V[1]({23,141,237,73,193,29,138,240},74,103) or type(getRayIgnore) ~= _V[1]({206,202,176,146,144,114,101,81},123,237) then return end

        xcNativeRaycast = raycastModule
        xcNativeGetRayIgnore = getRayIgnore
        if rawget(bulletModule, _V[1]({78,98,111,110,146,188,211,224,253,23,9,44,88,59,118,138,154,153,138,161},219,20)) then
            installed = true
            return
        end

        local originalRaycast = bulletModule._performRaycast
        bulletModule._performRaycast = function(self, spread, ...)
            local shot = originalRaycast(self, spread, ...)
            local redirect = sharedXCEnv and sharedXCEnv.XCNativeSilentRedirectV36 or redirectXCNativeSilentShot
            if type(redirect) ~= _V[1]({118,143,146,145,172,171,187,196},6,10) then return shot end
            local ok, redirected = pcall(redirect, self, shot)
            return ok and redirected or shot
        end
        rawset(bulletModule, _V[1]({97,119,134,135,173,217,242,1,32,60,48,85,131,104,165,187,205,206,193,218},236,22), true)
        installed = bulletModule._performRaycast ~= originalRaycast
    end)
    xcNativeSilentHooked = installed
    return installed
end

local function beginXCBulletInterceptV29(bullet)
    if xcMobileCameraSilentHooked then return nil end
    if not isXCSilentAimRequested() or type(bullet) ~= _V[1]({155,195,255,68,120},236,59)
        or bullet.IsDestroyed or bullet.IsActive == false then return nil end
    local weapon = bullet.Weapon
    if not weapon or (weapon.Player and weapon.Player ~= player) then return nil end

    local targetPart = getSilentAimTarget and getSilentAimTarget() or silentAimResolved
    if not targetPart or not targetPart.Parent then return nil end
    local chance = math.clamp(tonumber(XCConfig.silentAimHitChance) or 100, 0, 100)
    if chance < 100 and math.random(1, 100) > chance then return nil end

    return {
        Thread = coroutine.running(),
        Target = targetPart,
        AimPosition = targetPart.Position,
        Direction = nil,
        Used = false,
    }
end

if sharedXCEnv then sharedXCEnv.XCBeginBulletInterceptV29 = beginXCBulletInterceptV29 end

local xcBulletInterceptContextV29 = nil
local function getXCActiveBulletInterceptV29()
    local context = sharedXCEnv and sharedXCEnv.XCBulletInterceptContextV29 or xcBulletInterceptContextV29
    if not context then return nil end
    local thread = coroutine.running()
    if context.Thread and context.Thread ~= thread then return nil end
    return context
end

local function redirectXCRaycastArgumentsV29(origin, direction, firstCast)
    local context = getXCActiveBulletInterceptV29()
    if not context or typeof(origin) ~= _V[1]({185,118,34,225,138,59,170},181,174) or typeof(direction) ~= _V[1]({130,74,1,203,127,59,181},115,185)
        or direction.Magnitude <= 0.001 then return direction end
    if firstCast and context.Used then return direction end

    local delta = context.AimPosition - origin
    if delta.Magnitude <= 0.05 then return direction end
    local redirectedUnit = delta.Unit
    if firstCast then
        context.Used = true
        context.Direction = redirectedUnit
    elseif context.Direction then
        redirectedUnit = context.Direction
    end
    return redirectedUnit * direction.Magnitude
end

function setupXCBulletInterceptHookV29()
    if xcBulletInterceptHooked then return true end
    if xcNativeSilentHooked then return false end
    if xcMobileCameraSilentHooked then return false end
    if not UserInputService.TouchEnabled or type(hookfunction) ~= _V[1]({111,229,69,161,25,117,226,72},162,103) then return false end
    local installed = false
    pcall(function()
        local components = ReplicatedStorage:FindFirstChild(_V[1]({155,217,233,254,15,32,41,68,92,109},70,18))
        local weaponFolder = components and components:FindFirstChild(_V[1]({239,79,157,254,79,160},70,82))
        local classes = weaponFolder and weaponFolder:FindFirstChild(_V[1]({23,187,43,184,51,160,41},89,123))
        local bulletScript = classes and classes:FindFirstChild(_V[1]({217,128,235,95,204,79},35,116))
        local sharedFolder = ReplicatedStorage:FindFirstChild(_V[1]({199,43,115,211,21,99},37,79))
        local raycastScript = sharedFolder and sharedFolder:FindFirstChild(_V[1]({201,35,134,187,4,97,173},44,75))
        if not bulletScript or not raycastScript then return end

        local bulletModule = require(bulletScript)
        local raycastModule = require(raycastScript)
        if type(bulletModule) ~= _V[1]({255,110,241,125,248},9,130) or type(bulletModule._performRaycast) ~= _V[1]({89,78,45,8,255,218,198,171},13,230)
            or type(raycastModule) ~= _V[1]({204,47,166,38,149},226,118) or type(raycastModule.cast) ~= _V[1]({123,197,249,41,117,165,230,32},218,59)
            or type(raycastModule.castThrough) ~= _V[1]({245,194,121,44,251,174,114,47},209,190) then return end

        if not (sharedXCEnv and sharedXCEnv.XCRaycastArgumentHooksV29) then
            local oldCast
            oldCast = hookfunction(raycastModule.cast, function(origin, direction, ...)
                direction = redirectXCRaycastArgumentsV29(origin, direction, true)
                return oldCast(origin, direction, ...)
            end)

            local oldCastThrough
            oldCastThrough = hookfunction(raycastModule.castThrough, function(origin, direction, ...)
                direction = redirectXCRaycastArgumentsV29(origin, direction, false)
                return oldCastThrough(origin, direction, ...)
            end)
            if sharedXCEnv then sharedXCEnv.XCRaycastArgumentHooksV29 = true end
        end

        if rawget(bulletModule, _V[1]({45,197,86,217,112,59,202,98,243,154,7,196,98,235,144,25,179,86,242,108,224,127},54,152)) then
            installed = true
            return
        end

        local originalPerformRaycast = bulletModule._performRaycast
        bulletModule._performRaycast = function(self, spread, ...)
            local begin = sharedXCEnv and sharedXCEnv.XCBeginBulletInterceptV29 or beginXCBulletInterceptV29
            local okContext, context = pcall(begin, self)
            if not okContext then context = nil end
            local previous = sharedXCEnv and sharedXCEnv.XCBulletInterceptContextV29 or xcBulletInterceptContextV29
            xcBulletInterceptContextV29 = context
            if sharedXCEnv then sharedXCEnv.XCBulletInterceptContextV29 = context end

            local results = table.pack(pcall(originalPerformRaycast, self, spread, ...))
            xcBulletInterceptContextV29 = previous
            if sharedXCEnv then sharedXCEnv.XCBulletInterceptContextV29 = previous end
            if not results[1] then error(results[2], 0) end

            local shot = results[2]
            if context and context.Used and context.Direction and type(shot) == _V[1]({89,130,191,5,58},169,60) then
                local redirectedShot = table.clone(shot)
                redirectedShot.Direction = context.Direction
                results[2] = redirectedShot
                silentAimResolved = context.Target
                if registerXCLocalHitCandidate then registerXCLocalHitCandidate(context.Target) end
            end
            return table.unpack(results, 2, results.n)
        end
        rawset(bulletModule, _V[1]({72,30,237,174,131,140,89,47,254,227,142,137,101,44,15,214,174,143,105,33,211,176},19,214), true)
        installed = true
    end)
    xcBulletInterceptHooked = installed
    return installed
end

local chamsColorVisible = Color3.fromRGB(152, 204, 0)
local chamsColorHidden = Color3.fromRGB(112, 116, 122)
local chamsColorAlly = Color3.fromRGB(194, 220, 112)
local chamsOutlineColor = Color3.fromRGB(235, 235, 235)

local skinData = {
    SkinsRoot = nil,
    WeaponAssets = nil,
    SkinLibrary = nil,
    GetWeapon = nil,
    KnifeSet = {},
    KnifeChoices = {},
    SkinSelections = {},
    GloveSelections = {},
    GloveFolders = {},
    ModifiedKnife = nil,
    Ready = false,
    LastRefresh = 0,
    LastError = nil
}

function refreshXCSkinData()
    if skinData.Ready and skinData.SkinsRoot and skinData.SkinsRoot.Parent and skinData.GetWeapon then return true end
    if skinData.LastRefresh > 0 and os.clock() - skinData.LastRefresh < 1 then return skinData.Ready end
    skinData.LastRefresh = os.clock()

    local assets = ReplicatedStorage:FindFirstChild(_V[1]({160,254,42,72,131,174},51,44))
    skinData.SkinsRoot = assets and assets:FindFirstChild(_V[1]({100,30,190,101,12},111,162))
    skinData.WeaponAssets = assets and assets:FindFirstChild(_V[1]({221,66,149,251,81,167,3},47,87))
    if not skinData.SkinsRoot then return false end

    pcall(function()
        local database = ReplicatedStorage:FindFirstChild(_V[1]({47,12,223,140,77,12,222,144},43,192))
        local components = database and database:FindFirstChild(_V[1]({99,93,41,250,199,148,89,48,4,209},82,206))
        local libraries = components and components:FindFirstChild(_V[1]({214,62,130,221,23,115,181,252,85},63,75))
        local module = libraries and libraries:FindFirstChild(_V[1]({128,103,52,8,220},94,207))
        if module then skinData.SkinLibrary = require(module) end
    end)
    pcall(function()
        local controllers = ReplicatedStorage:FindFirstChild(_V[1]({147,33,130,234,74,169,8,106,197,52,151},238,98))
        local module = controllers and controllers:FindFirstChild(_V[1]({52,238,139,15,173,72,216,112,12,107,44,192,91,238,128,18,167,53,215},86,149))
        local inventory = module and require(module)
        if inventory and type(inventory.peekCurrentEquippedForMovement) == _V[1]({217,221,203,181,187,165,160,148},126,245) then
            skinData.GetWeapon = inventory.peekCurrentEquippedForMovement
        end
    end)

    skinData.SkinSelections = {}
    skinData.GloveSelections = {}
    skinData.GloveFolders = {}
    skinData.KnifeSet = {
        [_V[1]({213,35,44,148,244,44,102,162},85,61)] = true,
        [_V[1]({206,142,173,196,179,164,151},134,244)] = true,
        [_V[1]({88,147,166,187,210},245,24)] = true
    }

    for _, weaponFolder in ipairs(skinData.SkinsRoot:GetChildren()) do
        local skins = {}
        for _, skin in ipairs(weaponFolder:GetChildren()) do
            skins[#skins + 1] = skin.Name
        end
        table.sort(skins)
        skinData.SkinSelections[weaponFolder.Name] = skins

        local lowerName = weaponFolder.Name:lower()
        if lowerName:find(_V[1]({101,186,7,86,167},168,82), 1, true) or lowerName:find(_V[1]({199,4,92,146,229,33,111,193},21,71), 1, true)
            or lowerName:find(_V[1]({224,0,57,80,112,136,184},93,33), 1, true) or lowerName:find(_V[1]({224,18,48,79,95,139,158,195,239},95,31), 1, true) then
            skinData.KnifeSet[weaponFolder.Name] = true
        end

        if skinData.SkinLibrary and type(skinData.SkinLibrary.GetAllSkinsForWeapon) == _V[1]({76,206,58,162,38,142,7,121},115,115) then
            pcall(function()
                local entries = skinData.SkinLibrary.GetAllSkinsForWeapon(weaponFolder.Name)
                local sample = type(entries) == _V[1]({202,187,192,206,203},82,4) and entries[1]
                if type(sample) == _V[1]({80,229,142,64,225},52,168) and sample.type == _V[1]({17,21,8,237,217},216,236) then
                    skinData.KnifeSet[weaponFolder.Name] = true
                end
            end)
        end

        if weaponFolder.Name:match(_V[1]({204,61,140,223,26},57,76)) or weaponFolder.Name:match(_V[1]({10,102,160,222,4,73},140,55)) or weaponFolder.Name == _V[1]({69,158,235,33,29,148,239,30,109,176},189,64) then
            skinData.GloveFolders[#skinData.GloveFolders + 1] = weaponFolder
            local gloveSkins = {_V[1]({40,231,134,31,209,102,12},70,158)}
            for _, skin in ipairs(weaponFolder:GetChildren()) do
                gloveSkins[#gloveSkins + 1] = skin.Name
            end
            skinData.GloveSelections[weaponFolder.Name] = gloveSkins
        end
    end

    for weaponName, skins in pairs(skinData.SkinSelections) do
        if XCConfig.weaponSkinSelections[weaponName] == nil then
            XCConfig.weaponSkinSelections[weaponName] = _V[1]({120,19,142,3,145,2,132},186,122)
        end
    end

    skinData.KnifeChoices = {}
    for knifeName in pairs(skinData.KnifeSet) do
        local baseKnife = knifeName == _V[1]({68,6,131,95,51,223,141,61},80,177) or knifeName == _V[1]({64,14,59,96,93,92,93},234,2) or knifeName == _V[1]({249,30,27,26,27},172,2)
        if not baseKnife then
            if not skinData.WeaponAssets or skinData.WeaponAssets:FindFirstChild(knifeName) then
                skinData.KnifeChoices[#skinData.KnifeChoices + 1] = knifeName
            end
        end
    end
    table.sort(skinData.KnifeChoices)
    if XCConfig.selectedKnifeType ~= _V[1]({14,141,236,69,183,12,114},108,94) and skinData.WeaponAssets
        and not skinData.WeaponAssets:FindFirstChild(XCConfig.selectedKnifeType)
        and skinData.KnifeChoices[1] then
        XCConfig.selectedKnifeType = skinData.KnifeChoices[1]
    end

    skinData.Ready = skinData.GetWeapon ~= nil
    return skinData.Ready
end

refreshXCSkinData()

function isBaseKnife(name)
    return name == _V[1]({78,242,81,15,197,83,227,117},120,147) or name == _V[1]({155,45,30,7,200,139,80},129,198) or name == _V[1]({194,247,4,19,36},101,18)
end

function getXCKnifeChoices()
    refreshXCSkinData()
    local choices = {}
    for _, name in ipairs(skinData.KnifeChoices or {}) do choices[#choices + 1] = name end
    if #choices == 0 then
        choices = {_V[1]({102,46,194,87,221,127,8,163,69,129,65,249,137,27,175},143,149), _V[1]({69,47,20,215,183,128,91,58},38,212), _V[1]({76,3,179,65,216,103,14},114,152)}
    end
    choices[#choices + 1] = _V[1]({27,129,199,7,96,156,233},146,69)
    return choices
end

function getXCWeaponSkinChoices()
    refreshXCSkinData()
    local choices = {}
    for weaponName, skins in pairs(skinData.SkinSelections or {}) do
        if not skinData.KnifeSet[weaponName] and not skinData.GloveSelections[weaponName] and #skins > 0 then
            choices[#choices + 1] = weaponName
        end
    end
    table.sort(choices)
    if #choices == 0 then choices = {_V[1]({112,139,126,150,170},30,17), _V[1]({5,59,151,214},105,79), _V[1]({72,180,3},177,86), _V[1]({66,41,253,181,136,80,194,173,143,91,38,229},56,198)} end
    if not table.find(choices, XCConfig.skinEditorWeapon) then XCConfig.skinEditorWeapon = choices[1] end
    return choices
end

function getXCAllFinishChoices()
    refreshXCSkinData()
    local set, choices = {Default = true}, {_V[1]({118,189,228,5,63,92,138},12,38)}
    for _, skins in pairs(skinData.SkinSelections or {}) do
        for _, skinName in ipairs(skins) do
            if not set[skinName] then
                set[skinName] = true
                choices[#choices + 1] = skinName
            end
        end
    end
    table.sort(choices, function(a, b)
        if a == _V[1]({102,28,178,66,235,119,20},141,149) then return true end
        if b == _V[1]({197,125,21,167,82,224,127},234,151) then return false end
        return a:lower() < b:lower()
    end)
    return choices
end

function getXCSkinChoicesForWeapon(weaponName)
    refreshXCSkinData()
    local choices = {_V[1]({6,196,98,250,171,63,228},37,157)}
    for _, skinName in ipairs(skinData.SkinSelections[weaponName] or {}) do choices[#choices + 1] = skinName end
    return choices
end

function getXCGloveSkinChoices(modelName)
    refreshXCSkinData()
    local choices = {_V[1]({17,7,221,173,150,98,63},248,213)}
    for _, skinName in ipairs(skinData.GloveSelections[modelName] or {}) do
        if skinName ~= _V[1]({105,183,229,13,78,114,167},248,45) then choices[#choices + 1] = skinName end
    end
    return choices
end

function getXCGloveModelChoices()
    refreshXCSkinData()
    local choices = {_V[1]({80,74,36,248,229,181,150},51,217)}
    for _, folder in ipairs(skinData.GloveFolders or {}) do choices[#choices + 1] = folder.Name end
    if #choices == 1 then choices = {_V[1]({9,34,27,14,26,9,9},205,248), _V[1]({9,89,139,193,246,40,8,98,186,240,42,76,141},131,51), _V[1]({57,111,110,131,122,143,69,116,161,172,187,178,200},237,8)} end
    return choices
end

function getXCAllGloveSkinChoices()
    refreshXCSkinData()
    local set, choices = {Default = true}, {_V[1]({152,56,184,50,197,59,194},213,127)}
    for _, skins in pairs(skinData.GloveSelections or {}) do
        for _, skinName in ipairs(skins) do
            if not set[skinName] then
                set[skinName] = true
                choices[#choices + 1] = skinName
            end
        end
    end
    table.sort(choices, function(a, b)
        if a == _V[1]({77,145,181,211,10,36,79},230,35) then return true end
        if b == _V[1]({113,101,57,7,238,184,147},90,211) then return false end
        return a:lower() < b:lower()
    end)
    return choices
end

function constructXCKnifeView(view, character, weapon)
    if not view or type(view.construct) ~= _V[1]({186,95,238,121,32,171,71,220},190,150) or not character or not character.Parent then return false end
    local readIdentity = getthreadidentity or getidentity
    local writeIdentity = setthreadidentity or setidentity
    local identity = readIdentity and writeIdentity and readIdentity()
    local success, failure = pcall(function()
        if identity then writeIdentity(2) end
        local components = ReplicatedStorage:FindFirstChild(_V[1]({147,1,65,134,199,8,65,140,212,21},14,66))
        local common = components and components:FindFirstChild(_V[1]({160,24,98,174,252,71},17,76))
        local module = common and common:FindFirstChild(_V[1]({136,74,253,132,54,214,137,44,207,85,27,188,97,250,171,81,234,138,60},157,164))
        if module then
            local getProperties = require(module)
            assert(getProperties(view.CameraModelWeapon or view.Weapon or weapon.Name), _V[1]({239,179,111,45,237,105,122,61,251,189,115,65,4,186,119,70,180,202,132,56,14,186,131,71,253,191,138,68},195,193))
        end
        view:construct(character, weapon)
    end)
    if identity then pcall(writeIdentity, identity) end
    if success then skinData.LastError = nil else skinData.LastError = tostring(failure) end
    return success
end

function restoreXCKnifeModel()
    local record = skinData.ModifiedKnife
    skinData.ModifiedKnife = nil
    if not record then return end
    local view, weapon = record.View, record.Weapon
    if not view or not weapon or view.IsDestroyed or weapon.IsDestroyed then return end
    view.CameraModelWeapon = record.CameraModelWeapon
    view.Skin = record.Skin
    view.Float = record.Float
    constructXCKnifeView(view, weapon.Character or player.Character, weapon)
end

function applyXCKnifeChanger()
    if not XCConfig.skinChangerEnabled then
        restoreXCKnifeModel()
        return false
    end
    if not refreshXCSkinData() or type(skinData.GetWeapon) ~= _V[1]({216,34,86,134,210,2,67,125},55,59) then return false end

    local ok, weapon = pcall(skinData.GetWeapon)
    if not ok or not weapon or weapon.IsDestroyed then return false end
    local view = weapon.Viewmodel
    local properties = weapon.Properties
    local melee = skinData.KnifeSet[weapon.Name]
        or (type(properties) == _V[1]({132,146,180,223,249},239,33) and properties.Class == _V[1]({194,34,113,178,250},45,72))
    if not view or not melee then
        restoreXCKnifeModel()
        return false
    end

    local selectedKnife = XCConfig.selectedKnifeType
    if not selectedKnife or selectedKnife == _V[1]({27,3,203,141,104,38,245},16,199) then
        restoreXCKnifeModel()
        return true
    end
    if skinData.WeaponAssets and not skinData.WeaponAssets:FindFirstChild(selectedKnife) then
        skinData.LastError = _V[1]({37,49,53,59,67,7,81,108,117,112,136,61,155,157,153,183,171,188,200,198,208,227,229,195,178},177,9) .. tostring(selectedKnife)
        return false
    end
    if skinData.ModifiedKnife and skinData.ModifiedKnife.View ~= view then restoreXCKnifeModel() end
    if not skinData.ModifiedKnife then
        skinData.ModifiedKnife = {
            View = view,
            Weapon = weapon,
            CameraModelWeapon = view.CameraModelWeapon,
            Skin = view.Skin,
            Float = view.Float
        }
    end

    local selectedSkin = XCConfig.selectedSkin or _V[1]({253,99,169,233,66,126,203},116,69)
    local availableSkins = skinData.SkinSelections[selectedKnife]
    if selectedSkin ~= _V[1]({99,49,223,135,72,236,161},114,173) and type(availableSkins) == _V[1]({95,163,251,92,172},148,87)
        and not table.find(availableSkins, selectedSkin) then
        selectedSkin = _V[1]({121,64,231,136,66,223,141},143,166)
    end
    local modelChanged = view.CameraModelWeapon ~= selectedKnife
    view.CameraModelWeapon = selectedKnife
    view.Skin = selectedSkin ~= _V[1]({155,34,137,234,100,193,47},241,102) and selectedSkin or nil
    view.Float = math.clamp(tonumber(XCConfig.knifeWear) or 0, 0, 1)
    if modelChanged or not view.Model or not view.Model.Parent then
        if not constructXCKnifeView(view, weapon.Character or player.Character, weapon) then return false end
    end
    if view.Model and view.Model.Parent then
        applySurfaceAppearanceSkin(view.Model, selectedKnife, selectedSkin, XCConfig.knifeWear)
    end
    skinData.LastError = nil
    return true
end

function getCurrentWeaponModel()
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end
    for _, child in ipairs(cam:GetChildren()) do
        if child:IsA(_V[1]({36,3,181,115,55},26,189)) and child.Name ~= _V[1]({246,138,7,154,17,148,10,140,20},31,129) and not child.Name:lower():find(_V[1]({36,183,75,226,132},34,150)) then
            return child
        end
    end
    return nil
end

function applySurfaceAppearanceSkin(model, weaponName, skinName, wear)
    if not model or not skinData.SkinsRoot then return end
    if not weaponName or not skinName or skinName == _V[1]({163,148,101,48,20,219,179},143,208) then return end

    local weaponFolder = skinData.SkinsRoot:FindFirstChild(weaponName)
    local skinFolder = weaponFolder and weaponFolder:FindFirstChild(skinName)
    local cameraFolder = skinFolder and skinFolder:FindFirstChild(_V[1]({246,187,110,13,193,87},12,167))
    if not cameraFolder then return end
    local textureFolder = nil
    if skinData.SkinLibrary and type(skinData.SkinLibrary.GetAllSkinsForWeapon) == _V[1]({107,209,33,109,213,33,126,212},174,87)
        and type(skinData.SkinLibrary.GetWearNameForFloat) == _V[1]({155,57,193,69,229,105,254,140},166,143) then
        pcall(function()
            for _, info in ipairs(skinData.SkinLibrary.GetAllSkinsForWeapon(weaponName) or {}) do
                if type(info) == _V[1]({201,136,91,55,2},131,210) and info.skin == skinName then
                    local wearName = skinData.SkinLibrary.GetWearNameForFloat(info, math.clamp(tonumber(wear) or 0, 0, 1))
                    textureFolder = cameraFolder:FindFirstChild(wearName)
                    break
                end
            end
        end)
    end
    textureFolder = textureFolder or cameraFolder:FindFirstChild(_V[1]({255,90,156,237,40,107,178,153,7,94,176},121,64)) or cameraFolder:GetChildren()[1]
    if not textureFolder then return end

    for _, appearance in ipairs(textureFolder:GetChildren()) do
        if appearance:IsA(_V[1]({155,202,212,213,221,236,251,228,32,45,47,56,86,82,108,110,125},59,13)) then
            local targetPart = model:FindFirstChild(appearance.Name, true)
            if targetPart and targetPart:IsA(_V[1]({40,79,105,99,86,111,136,146},222,8)) then
                for _, old in ipairs(targetPart:GetChildren()) do
                    if old:IsA(_V[1]({207,115,242,104,229,105,237,75,252,126,245,115,6,119,6,125,1},250,130)) then old:Destroy() end
                end
                appearance:Clone().Parent = targetPart
            end
        end
    end
end

function applyXCSelectedWeaponSkin()
    if not XCConfig.skinChangerEnabled or not refreshXCSkinData() or type(skinData.GetWeapon) ~= _V[1]({57,191,47,155,35,143,12,130},92,119) then return false end
    local ok, weapon = pcall(skinData.GetWeapon)
    if not ok or type(weapon) ~= _V[1]({48,202,120,47,213},15,173) or weapon.IsDestroyed
        or (weapon.Player ~= nil and weapon.Player ~= player) then return false end
    local view = weapon.Viewmodel
    local model = view and view.Model
    if not view or not model or not model.Parent then return false end
    local melee = skinData.KnifeSet[weapon.Name] or (type(weapon.Properties) == _V[1]({197,183,189,204,202},76,5) and weapon.Properties.Class == _V[1]({209,137,48,201,105},228,160))
    if melee then return applyXCKnifeChanger() end

    local weaponName = view.CameraModelWeapon or view.Weapon or weapon.Name
    local skinName = XCConfig.weaponSkinSelections[weaponName]
    if skinName == nil then return false end
    if type(skinName) ~= _V[1]({6,27,45,56,81,94},127,20) or skinName == _V[1]({},12,66) or skinName == _V[1]({16,242,180,112,69,253,198},11,193) then
        return restoreXCSelectedWeaponSkin(weaponName)
    end
    local wear = math.clamp(tonumber(XCConfig.weaponSkinWear[weaponName]) or 0, 0, 1)
    view.Skin = skinName
    view.Float = wear
    applySurfaceAppearanceSkin(model, weaponName, skinName, wear)
    return true
end

function restoreXCSelectedWeaponSkin(weaponName)
    if type(skinData.GetWeapon) ~= _V[1]({162,84,240,136,60,212,125,31},153,163) then return false end
    local ok, weapon = pcall(skinData.GetWeapon)
    if not ok or type(weapon) ~= _V[1]({247,25,79,142,188},78,53) or weapon.IsDestroyed then return false end
    local view = weapon.Viewmodel
    local currentName = view and (view.CameraModelWeapon or view.Weapon or weapon.Name)
    if not view or (weaponName and currentName ~= weaponName) then return false end
    if view.Skin == nil and (tonumber(view.Float) or 0) == 0 then return true end
    view.Skin = nil
    view.Float = 0
    local character = weapon.Character or player.Character
    if character and character.Parent then constructXCKnifeView(view, character, weapon) end
    return true
end

local lastBloxModuleScan = 0
function hookBloxStrikeModules(forceScan)
    local now = os.clock()
    if not forceScan and lastBloxModuleScan > 0 and (now - lastBloxModuleScan) < 5 then return end
    lastBloxModuleScan = now
    refreshXCSkinData()
    pcall(function()
        if type(getgc) ~= _V[1]({252,181,88,247,178,81,1,170},236,170) then return end
        for _, obj in ipairs(getgc(true)) do
            if type(obj) == _V[1]({202,98,14,195,103},171,171) then
                if rawget(obj, _V[1]({209,174,99,8,192,113,23,199,97,42,226,140,61},219,177)) ~= nil and XCConfig.skinChangerEnabled
                    and XCConfig.selectedKnifeType ~= _V[1]({177,232,255,16,58,71,101},87,22) then
                    obj.EquippedMelee = XCConfig.selectedKnifeType
                end
                if rawget(obj, _V[1]({220,153,69,227,136,27,216,123,37},234,165)) ~= nil and XCConfig.skinChangerEnabled
                    and XCConfig.selectedKnifeType ~= _V[1]({89,197,17,87,182,248,75},202,75) then
                    obj.MeleeSkin = XCConfig.selectedSkin
                end
                if rawget(obj, _V[1]({238,73,124,177,232},107,56)) ~= nil and type(obj.Knife) == _V[1]({229,26,99,181,246},41,72) and XCConfig.skinChangerEnabled
                    and XCConfig.selectedKnifeType ~= _V[1]({45,127,177,221,34,74,131},184,49) then
                    obj.Knife.Name = XCConfig.selectedKnifeType
                    obj.Knife.Skin = XCConfig.selectedSkin
                end
            end
        end
    end)
end

function scanAndMorphKnives(root)
    if not XCConfig.skinChangerEnabled or not root then return end
    if applyXCKnifeChanger() then return end
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
            or _V[1]({116,232,60,138,241,59,150},221,83)
        applySurfaceAppearanceSkin(
            weaponModel,
            selectedWeapon,
            selectedSkin,
            XCConfig.weaponSkinWear[selectedWeapon] or (selectedWeapon == XCConfig.selectedKnifeType and XCConfig.knifeWear) or 0
        )
    end
end

function applyXCGloves()
    if not XCConfig.gloveChangerEnabled then return end
    refreshXCSkinData()
    if not skinData.SkinsRoot then return end

    local cam = Workspace.CurrentCamera or camera
    if not cam then return end
    local arms
    for _, child in ipairs(cam:GetChildren()) do
        if child:IsA(_V[1]({217,207,152,109,72},184,212)) and (child.Name:match(_V[1]({174,23,74,136},53,56)) or child:FindFirstChild(_V[1]({223,146,44,201,113,185,118,67,218},241,156))) then
            arms = child
            break
        end
    end
    if not arms then return end

    local leftArm = arms:FindFirstChild(_V[1]({145,99,29,228,73,35,13,193},140,185))
    local rightArm = arms:FindFirstChild(_V[1]({211,56,132,211,45,39,150,21,94},51,78))
    local leftGlove = leftArm and leftArm:FindFirstChild(_V[1]({132,134,102,74,22},96,221))
    local rightGlove = rightArm and rightArm:FindFirstChild(_V[1]({216,220,190,164,114},178,223))
    if not leftGlove or not rightGlove then return end

    local gloveFolder = skinData.SkinsRoot:FindFirstChild(XCConfig.selectedGloveModel)
    local skinFolder = gloveFolder and gloveFolder:FindFirstChild(XCConfig.selectedGloveSkin)
    local cameraFolder = skinFolder and skinFolder:FindFirstChild(_V[1]({165,243,47,87,148,179},50,48))
    local factoryNew = cameraFolder and cameraFolder:FindFirstChild(_V[1]({151,46,172,57,176,47,178,213,127,18,160},213,124))
    if not factoryNew then return end

    for _, glove in ipairs({leftGlove, rightGlove}) do
        for _, old in ipairs(glove:GetChildren()) do
            if old:IsA(_V[1]({6,67,91,106,128,157,186,177,251,22,38,61,105,115,155,171,200},152,27)) then old:Destroy() end
        end
        for _, appearance in ipairs(factoryNew:GetChildren()) do
            if appearance:IsA(_V[1]({26,34,5,223,192,168,144,82,103,77,40,10,1,214,201,164,140},225,230)) then
                appearance:Clone().Parent = glove
            end
        end
    end
end

task.spawn(function()
    while xcSessionActive() do
        task.wait(0.25)
        pcall(function()
            if XCConfig.skinChangerEnabled then
                applyXCKnifeChanger()
                applyXCSelectedWeaponSkin()
            end
            if XCConfig.gloveChangerEnabled then
                applyXCGloves()
            end
        end)
    end
end)

local noFallLastCharacter = nil
local animationTrack = nil
local animationObject = nil
local spectatorGui = nil
local spectatorFrame = nil
local spectatorListLabel = nil
local spectatorCounterLabel = nil
local handsLastModel = nil
local handsLastPivot = nil
local handsNativeHooked = false

function setNoFallDamage(enabled)
    if not enabled then return end
    local char = player and player.Character
    local hum = char and char:FindFirstChildOfClass(_V[1]({107,29,154,19,165,43,170,42},158,133))
    if not hum then return end
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end)
end

function stopXCAnimation()
    if animationTrack then
        pcall(function() animationTrack:Stop(0.12) end)
        animationTrack = nil
    end
    if animationObject then
        pcall(function() animationObject:Destroy() end)
        animationObject = nil
    end
end

function playXCAnimation()
    stopXCAnimation()
    if not XCConfig.animationsEnabled then return end
    local char = player and player.Character
    local hum = char and char:FindFirstChildOfClass(_V[1]({55,5,158,51,225,131,30,186},78,161))
    local controller = char and char:FindFirstChildWhichIsA(_V[1]({239,122,211,53,135,248,75,175,12,63,201,38,138,230,65,156,250,81,188},80,94), true)
    local animationHost = controller or hum
    if not char or not animationHost then return end
    local animator = animationHost:FindFirstChildOfClass(_V[1]({36,74,62,59,40,52,40,36},234,249))
        or char:FindFirstChildWhichIsA(_V[1]({79,174,219,17,55,124,169,222},220,50), true)
    if not animator and hum then
        animator = Instance.new(_V[1]({30,145,210,28,86,175,240,57},151,70))
        animator.Parent = hum
    end
    if not animator then return end
    local id = tostring(XCConfig.animationId or _V[1]({},209,145)):match(_V[1]({193,101,145},55,101))
    if not id then return end
    animationObject = Instance.new(_V[1]({77,48,225,155,69,14,185,117,42},86,182))
    animationObject.Name = _V[1]({146,112,97,129,111,102,77,83,59,52,38},71,243)
    animationObject.AnimationId = _V[1]({248,174,138,57,17,215,143,100,31,224,124,55,253},192,198) .. id
    local ok, track = pcall(function() return animator:LoadAnimation(animationObject) end)
    if (not ok or not track) and hum then
        ok, track = pcall(function() return hum:LoadAnimation(animationObject) end)
    end
    if not ok or not track then
        stopXCAnimation()
        return
    end
    animationTrack = track
    animationTrack.Priority = Enum.AnimationPriority.Action4
    animationTrack.Looped = XCConfig.animationLoop
    animationTrack:Play(0.15, 1, math.clamp(XCConfig.animationSpeed, 0.1, 3))
end

function getSpectatorNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr:GetAttribute(_V[1]({174,68,144,25,122,228,97,186,57,154,11,112},249,108)) == true then
            names[#names + 1] = plr
        end
    end
    table.sort(names, function(a,b) return a.Name:lower() < b.Name:lower() end)
    return names
end

function buildSpectatorGui()
    if spectatorGui and spectatorGui.Parent then return end
    spectatorGui = Instance.new(_V[1]({56,100,143,158,186,223,212,30,46},201,28))
    spectatorGui.Name = _V[1]({166,209,33,126,179,241,66,111,194,253,64,85,195,247},14,64)
    spectatorGui.ResetOnSpawn = false
    spectatorGui.IgnoreGuiInset = true
    spectatorGui.DisplayOrder = 21
    spectatorGui.Parent = targetGui

    spectatorFrame = Instance.new(_V[1]({65,192,2,97,172},168,83), spectatorGui)
    spectatorFrame.Size = UDim2.new(0, 210, 0, 120)
    spectatorFrame.Position = UDim2.new(1, -224, 0, 92)
    spectatorFrame.BackgroundColor3 = currentTheme.Background
    spectatorFrame.BorderSizePixel = 0
    spectatorFrame.Visible = false
    Instance.new(_V[1]({87,37,249,255,220,178,131,106},40,218), spectatorFrame).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new(_V[1]({114,247,146,68,211,97,238,121},140,145), spectatorFrame)
    stroke.Color = currentTheme.Border
    stroke.Thickness = 1

    local title = Instance.new(_V[1]({83,68,55,19,203,192,161,132,107},31,224), spectatorFrame)
    title.Size = UDim2.new(1, -12, 0, 22)
    title.Position = UDim2.new(0, 6, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = _V[1]({228,93,206,72,213,62,205,68,195,64},21,124)
    title.TextColor3 = currentTheme.Accent
    title.TextSize = 9
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left

    spectatorCounterLabel = Instance.new(_V[1]({164,91,20,182,52,239,150,63,236},170,166), spectatorFrame)
    spectatorCounterLabel.Size = UDim2.new(1, -12, 0, 18)
    spectatorCounterLabel.Position = UDim2.new(0, 6, 0, 24)
    spectatorCounterLabel.BackgroundTransparency = 1
    spectatorCounterLabel.TextColor3 = currentTheme.TextSecondary
    spectatorCounterLabel.TextSize = 8
    spectatorCounterLabel.Font = Enum.Font.GothamBold
    spectatorCounterLabel.TextXAlignment = Enum.TextXAlignment.Left

    spectatorListLabel = Instance.new(_V[1]({54,154,0,79,122,226,54,140,230},143,83), spectatorFrame)
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

function updateSpectatorGui()
    buildSpectatorGui()
    local names = getSpectatorNames()
    local watching = player and player:GetAttribute(_V[1]({236,161,46,196,109,242,157,48,203,100},1,152))
    if type(watching) ~= _V[1]({163,161,144,124,118,122},62,247) then watching = nil end
    spectatorFrame.Visible = XCConfig.spectatorListEnabled and not (XCConfig.spectatorHideEmpty and #names == 0 and not watching)
    spectatorCounterLabel.Visible = XCConfig.spectatorCounterEnabled
    spectatorCounterLabel.Text = _V[1]({13,14,24,254,250,242,238,222,142,222,203,200,132,97},191,247) .. (watching and tostring(math.floor(watching)) or _V[1]({30},84,139))
    local lines = {}
    for _, plr in ipairs(names) do
        if XCConfig.spectatorNameMode == _V[1]({2,128,210,63,155,238,90,178},77,96) then
            lines[#lines+1] = plr.Name
        elseif XCConfig.spectatorNameMode == _V[1]({246,180,74,207},35,145) and plr.DisplayName ~= plr.Name then
            lines[#lines+1] = plr.DisplayName .. _V[1]({234,56,166},124,78) .. plr.Name
        else
            lines[#lines+1] = plr.DisplayName
        end
    end
    spectatorListLabel.Text = #lines > 0 and table.concat(lines, _V[1]({30},65,211)) or _V[1]({25,247,101,99,34,240,162,108,24,144,160,90,12,199,149,63,15,199,135,69},14,189)
    spectatorFrame.Size = UDim2.new(0, 210, 0, math.max(88, 64 + math.min(#lines, 8) * 14))
end

function applyXCHandsOffset(view)
    if not XCConfig.customHandsEnabled then
        handsLastModel = nil
        handsLastPivot = nil
        return
    end
    local cam = Workspace.CurrentCamera or camera
    if not cam then return end
    local model = type(view) == _V[1]({0,109,238,120,241},12,128) and view.Model or getCurrentWeaponModel()
    if not model or not model:IsA(_V[1]({72,149,181,225,19},208,43)) then return end
    if handsLastModel ~= model then
        handsLastModel = model
        handsLastPivot = model:GetPivot()
    end
    local original = model:GetPivot()
    local offset = CFrame.new(XCConfig.customHandsX, XCConfig.customHandsY, XCConfig.customHandsZ)
        * CFrame.Angles(math.rad(XCConfig.customHandsPitch), math.rad(XCConfig.customHandsYaw), math.rad(XCConfig.customHandsRoll))
    pcall(function()
        model:PivotTo(cam.CFrame * offset * cam.CFrame:ToObjectSpace(original))
        if type(view) == _V[1]({204,205,226,0,13},68,20) and view.LargeWeaponModel and view.SmallWeaponModel then
            view.LargeWeaponModel:PivotTo(view.SmallWeaponModel:GetPivot())
        end
    end)
end

function setupXCCustomHandsHook()
    pcall(function()
        local classes = ReplicatedStorage:FindFirstChild(_V[1]({219,33,51,98,127,142,185},123,29))
        local weaponComponent = classes and classes:FindFirstChild(_V[1]({177,158,121,103,69,35,215,226,191,161,127,93,51,27,0},123,223))
        local viewClasses = weaponComponent and weaponComponent:FindFirstChild(_V[1]({12,26,244,235,208,167,154},228,229))
        local viewScript = viewClasses and viewClasses:FindFirstChild(_V[1]({229,15,34,75,88,113,125,149,179},120,23))
        local viewmodel = viewScript and require(viewScript)
        if type(viewmodel) ~= _V[1]({229,154,99,53,246},169,200) or type(viewmodel.render) ~= _V[1]({115,177,217,253,61,97,150,196},222,47) then return end
        if sharedXCEnv then sharedXCEnv.XCApplyHandsV33 = applyXCHandsOffset end
        if rawget(viewmodel, _V[1]({96,59,15,213,176,189,150,114,72,33,215,203,179,132,110,30,32,251,210,152,80,43},38,219)) then
            handsNativeHooked = true
            return
        end
        local originalRender = viewmodel.render
        viewmodel.render = function(view, ...)
            local results = table.pack(originalRender(view, ...))
            local callback = sharedXCEnv and sharedXCEnv.XCApplyHandsV33 or applyXCHandsOffset
            if type(callback) == _V[1]({48,208,90,224,130,8,159,47},57,145) then pcall(callback, view) end
            return table.unpack(results, 1, results.n)
        end
        rawset(viewmodel, _V[1]({56,126,189,238,52,172,240,55,120,188,221,60,143,203,32,59,168,238,48,97,132,202},147,70), true)
        handsNativeHooked = true
    end)
    return handsNativeHooked
end

local spectatorUpdateAccumulator = 0
local animationUpdateAccumulator = 0
local animationRetryAccumulator = 0
table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    if not XCConfig.noFallDamageEnabled
        and not XCConfig.spectatorListEnabled
        and not XCConfig.customHandsEnabled
        and not XCConfig.animationsEnabled
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
    if XCConfig.customHandsEnabled and not handsNativeHooked then
        applyXCHandsOffset()
    end
    if animationTrack and animationTrack.IsPlaying then
        animationUpdateAccumulator += dt
        if animationUpdateAccumulator >= 0.25 then
            animationUpdateAccumulator = 0
            animationTrack.Looped = XCConfig.animationLoop
            pcall(function() animationTrack:AdjustSpeed(math.clamp(XCConfig.animationSpeed, 0.1, 3)) end)
        end
    elseif XCConfig.animationsEnabled and (not animationTrack or XCConfig.animationLoop) then
        animationRetryAccumulator += dt
        if animationRetryAccumulator >= 1 then
            animationRetryAccumulator = 0
            playXCAnimation()
        end
    else
        animationRetryAccumulator = 0
    end
end))

local triggerbotMobileAutoFire = true
local lastTriggerTick = 0

local currentSpinAngle = 0
local isMobileJumpHeld = false
local lastMoveDirection = Vector3.zero
local xcCharacterInputHook = {
    Ready = false,
    Module = nil,
    Original = nil,
    Wrapper = nil,
    Buttons = nil,
    Character = nil,
    GroundSince = nil,
    LastJumpDown = false,
    AntiCharacter = nil,
    AntiStarted = nil,
    AntiLastStep = nil,
    RandomYaw = nil,
    AntiFireUntil = 0,
    Calls = 0,
    LastCall = 0,
    LastError = nil,
}

local isSliding = false
local currentSlideVel = Vector3.zero
local defaultHipHeight = 2.0
local defaultHipHeightCaptured = false

local nightPresets = {
    [_V[1]({248,30,35,55,60,68,79,101},161,10)] = {
        ClockTime = 0.0,
        Brightness = 0.2,
        OutdoorAmbient = Color3.fromRGB(25, 25, 40),
        Ambient = Color3.fromRGB(15, 15, 25),
        FogColor = Color3.fromRGB(10, 10, 20)
    },
    [_V[1]({190,83,206,95,212,71},242,126)] = {
        ClockTime = 23.8,
        Brightness = 0.3,
        OutdoorAmbient = Color3.fromRGB(70, 25, 85),
        Ambient = Color3.fromRGB(45, 15, 60),
        FogColor = Color3.fromRGB(90, 30, 110)
    },
    [_V[1]({55,142,196,5,13,109,166,220,7},189,54)] = {
        ClockTime = 0.0,
        Brightness = 0.35,
        OutdoorAmbient = Color3.fromRGB(75, 10, 15),
        Ambient = Color3.fromRGB(45, 5, 10),
        FogColor = Color3.fromRGB(35, 5, 8)
    },
    [_V[1]({77,165,176,213,4,4,75,106,138,168,195},232,34)] = {
        ClockTime = 23.5,
        Brightness = 0.3,
        OutdoorAmbient = Color3.fromRGB(65, 15, 95),
        Ambient = Color3.fromRGB(40, 10, 60),
        FogColor = Color3.fromRGB(30, 8, 45)
    },
    [_V[1]({235,5,239,238,207,204,182,146,159,143,130,128},180,242)] = {
        ClockTime = 1.0,
        Brightness = 0.25,
        OutdoorAmbient = Color3.fromRGB(10, 55, 30),
        Ambient = Color3.fromRGB(5, 35, 20),
        FogColor = Color3.fromRGB(5, 25, 15)
    },
    [_V[1]({74,248,152,28,182,37,228,110,5,162},101,149)] = {
        ClockTime = 0.0,
        Brightness = 0.0,
        OutdoorAmbient = Color3.fromRGB(0, 0, 0),
        Ambient = Color3.fromRGB(0, 0, 0),
        FogColor = Color3.fromRGB(0, 0, 0)
    }
}

local fogLibrary = {
    [_V[1]({240,16,22,50,50,48},153,9)] = Color3.fromRGB(90, 30, 110),
    [_V[1]({168,199,236,39,70,99},18,40)] = Color3.fromRGB(90, 30, 110),
    [_V[1]({192,200,175,165,140,118,99,91},135,236)] = Color3.fromRGB(10, 10, 20),
    [_V[1]({26,143,227,66,104,230,61,145,218},130,84)] = Color3.fromRGB(35, 5, 8),
    [_V[1]({73,0,106,238,124,219,129,255,126,251,117},133,129)] = Color3.fromRGB(30, 8, 45),
    [_V[1]({194,144,46,225,118,39,197,85,22,186,97,19},215,166)] = Color3.fromRGB(5, 25, 15),
    [_V[1]({247,181,101,249,163,34,241,139,50,223},2,165)] = Color3.fromRGB(0, 0, 0)
}

local defaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ExposureCompensation = Lighting.ExposureCompensation,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor
}

local mainContainer = Instance.new(_V[1]({186,154,121,60,12,229,142,140,80},151,208))
mainContainer.Name = _V[1]({35,64,124,194,252,51,58,152,201,1,32,90,145,186,249},153,50)
mainContainer.ResetOnSpawn = false
mainContainer.DisplayOrder = 10
mainContainer.IgnoreGuiInset = true
mainContainer.Parent = targetGui

local overlayContainer = Instance.new(_V[1]({98,220,42,115,197,35},203,81), mainContainer)
overlayContainer.Name = _V[1]({20,223,219,142,128,107,114,65,46,8,221,213},220,224)

local grenadeContainer = Instance.new(_V[1]({2,254,206,153,109,77},233,211), mainContainer)
grenadeContainer.Name = _V[1]({16,173,123,21,242,151,82,247,172,95,251,212,117,52,224,135,81},6,178)

local jumpCircleFolder = Instance.new(_V[1]({173,88,215,81,212,99},229,130), Workspace)
jumpCircleFolder.Name = _V[1]({35,115,244,68,212,49,153,209,92,202,32,142,236,67,192,40,135,228},102,101)

local grenadePool = {}
local grenadeDangerPool = setmetatable({}, {__mode = _V[1]({188},160,177)})
local grenadeDangerScanStarted = false
local soundEspTracked = setmetatable({}, {__mode = _V[1]({215},105,3)})
local soundEspPulses = {}
local mobileSlideBtn = nil

local hitmarkerGui = Instance.new(_V[1]({181,174,166,130,107,93,31,54,19},121,233))
hitmarkerGui.Name = _V[1]({161,21,163,77,225,99,224,122,252,127,21,115,42,167},192,137)
hitmarkerGui.ResetOnSpawn = false
hitmarkerGui.IgnoreGuiInset = true
hitmarkerGui.DisplayOrder = 60
hitmarkerGui.Parent = mainContainer

local hitmarkerCenter = Instance.new(_V[1]({32,208,67,211,79},86,132))
hitmarkerCenter.Name = _V[1]({56,110,139,165,170,203},225,20)
hitmarkerCenter.AnchorPoint = Vector2.new(0.5, 0.5)
hitmarkerCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
hitmarkerCenter.Size = UDim2.new(0, 0, 0, 0)
hitmarkerCenter.BackgroundTransparency = 1
hitmarkerCenter.Visible = false
hitmarkerCenter.Parent = hitmarkerGui

local hitmarkerLines = {}
for i, rotation in ipairs({45, -45, 135, -135}) do
    local line = Instance.new(_V[1]({123,0,72,173,254},220,89))
    line.Name = _V[1]({225,129,9,131},18,131) .. i
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Size = UDim2.new(0, XCConfig.hitmarkerThickness, 0, XCConfig.hitmarkerSize)
    line.BackgroundColor3 = currentTheme.Accent
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 1
    line.Rotation = rotation
    line.Parent = hitmarkerCenter

    local glow = Instance.new(_V[1]({149,236,89,221,62,158,253,90},221,99))
    glow.Name = _V[1]({235,248,248,237,188,215,208,206},167,246)
    glow.Color = currentTheme.Accent
    glow.Thickness = XCConfig.hitmarkerGlow and 2.5 or 0
    glow.Transparency = 1
    glow.Parent = line

    hitmarkerLines[i] = line
end

local hitmarkerDamage = Instance.new(_V[1]({9,219,175,108,5,219,157,97,41},244,193))
hitmarkerDamage.Name = _V[1]({243,169,78,219,122,17},22,153)
hitmarkerDamage.AnchorPoint = Vector2.new(0.5, 0)
hitmarkerDamage.Position = UDim2.fromOffset(0, XCConfig.hitmarkerSize + 7)
hitmarkerDamage.Size = UDim2.fromOffset(92, 18)
hitmarkerDamage.BackgroundTransparency = 1
hitmarkerDamage.Text = _V[1]({},176,77)
hitmarkerDamage.TextColor3 = Color3.fromRGB(152, 204, 0)
hitmarkerDamage.TextStrokeColor3 = Color3.fromRGB(8, 8, 8)
hitmarkerDamage.TextStrokeTransparency = 0.15
hitmarkerDamage.TextTransparency = 1
hitmarkerDamage.Font = Enum.Font.Code
hitmarkerDamage.TextSize = 13
hitmarkerDamage.TextXAlignment = Enum.TextXAlignment.Center
hitmarkerDamage.Visible = false
hitmarkerDamage.Parent = hitmarkerCenter

function refreshHitmarkerTheme()
    for _, line in ipairs(hitmarkerLines) do
        line.BackgroundColor3 = currentTheme.Accent
        local glow = line:FindFirstChild(_V[1]({121,185,236,20,22,100,144,193},2,41))
        if glow then
            glow.Color = currentTheme.Accent
            glow.Thickness = XCConfig.hitmarkerGlow and 2.5 or 0
        end
    end
end

function showHitmarker(damage)
    if type(playXCHitSound) == _V[1]({1,207,135,59,11,191,132,66},220,191) then playXCHitSound() end
    if not XCConfig.hitmarkerEnabled then return end

    hitmarkerSerial += 1
    local serial = hitmarkerSerial
    hitmarkerCenter.Visible = true

    local size = math.clamp(tonumber(XCConfig.hitmarkerSize) or 13, 5, 30)
    local thickness = math.clamp(tonumber(XCConfig.hitmarkerThickness) or 2, 1, 6)

    for _, line in ipairs(hitmarkerLines) do
        line.Size = UDim2.fromOffset(thickness, size)
        line.BackgroundTransparency = 0
        local glow = line:FindFirstChild(_V[1]({234,3,15,16,235,18,23,33},154,2))
        if glow then glow.Transparency = 0.05 end
    end

    local shownDamage = tonumber(damage)
    if shownDamage and shownDamage > 0 then
        hitmarkerDamage.Position = UDim2.fromOffset(0, size + 7)
        hitmarkerDamage.Text = string.format(_V[1]({254,64,201,207,65,147},135,74), math.max(1, math.floor(shownDamage + 0.5)))
        hitmarkerDamage.TextTransparency = 0
        hitmarkerDamage.TextStrokeTransparency = 0.15
        hitmarkerDamage.Visible = true
    else
        hitmarkerDamage.Visible = false
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

        local glow = line:FindFirstChild(_V[1]({212,77,185,26,85,220,65,171},36,98))
        if glow then
            TweenService:Create(glow, fadeInfo, {Transparency = 1}):Play()
        end
    end
    if hitmarkerDamage.Visible then
        TweenService:Create(hitmarkerDamage, fadeInfo, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    end

    task.delay(math.max(0.05, XCConfig.hitmarkerDuration), function()
        if serial == hitmarkerSerial then
            hitmarkerCenter.Visible = false
            hitmarkerDamage.Visible = false
        end
    end)
end

if genv then
    genv.XCShowHitmarker = showHitmarker
end

local isThirdPersonActive = false
local thirdPersonSaved = nil

function getThirdPersonTarget()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass(_V[1]({229,191,100,5,191,109,20,188},240,173))
    if not char or not hum or hum.Health <= 0 then return nil, nil end
    return char, hum
end

function restoreThirdPerson()
    isThirdPersonActive = false

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass(_V[1]({246,52,61,66,96,114,125,137},157,17))

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
        Lighting.ExposureCompensation = defaultLighting.ExposureCompensation or 0
        restoreWorldSkybox()
        local fx = Lighting:FindFirstChild(_V[1]({152,233,99,225,74,170,8,77,223,66,171,20,78,198},218,102))
        if fx then fx:Destroy() end
        if XCFeatureState and XCFeatureState.worldAtmosphere then
            XCFeatureState.worldAtmosphere:Destroy()
            XCFeatureState.worldAtmosphere = nil
        end
        if XCFeatureState and XCFeatureState.worldOriginalAtmosphere then
            XCFeatureState.worldOriginalAtmosphere.Parent = Lighting
            XCFeatureState.worldOriginalAtmosphere = nil
        end
        if XCFeatureState and XCFeatureState.worldBloom then
            XCFeatureState.worldBloom:Destroy()
            XCFeatureState.worldBloom = nil
        end
    end)
end

local worldSkyboxData = {
    [_V[1]({230,136,13,149,40},17,135)] = {_V[1]({176,52,222,91,1,149,27,190,71,214,64,201,93,243,139,27,178,73,215,113,4,150,41},170,148),_V[1]({34,190,128,21,211,127,29,216,121,32,162,67,239,157,77,245,164,83,249,170,89,255,174},4,172),_V[1]({210,124,76,239,187,117,33,234,153,78,222,141,71,3,193,119,52,241,165,99,33,211,140},166,186),_V[1]({193,248,85,133,222,37,94,180,240,50,79,139,210,27,102,169,243,61,126,200,20,86,158},8,71),_V[1]({105,181,39,108,218,54,132,239,64,151,201,26,118,212,52,140,235,74,160,255,87,180,16},155,92),_V[1]({177,24,165,5,142,5,110,244,96,210,31,139,2,123,246,105,227,93,206,71,190,57,173},200,119)},
    [_V[1]({74,167,242,55,141,136,4,111,177,255,58,146},178,73)] = {_V[1]({178,108,76,255,219,165,97,58,249,190,94,29,231,179,131,75,18,223,170,118,62,10,208,150},118,202),_V[1]({189,94,37,191,130,51,214,150,60,232,111,21,198,121,48,223,141,65,243,165,87,4,184,101},154,177),_V[1]({6,229,234,194,195,178,147,145,117,95,36,8,247,232,221,202,182,168,152,137,116,101,86,67},165,239),_V[1]({157,48,233,117,42,205,98,20,172,74,195,91,254,163,76,237,141,51,215,124,23,192,99,3},136,163),_V[1]({66,113,198,238,63,126,175,253,49,107,128,180,243,52,121,182,242,52,116,181,238,49,112,174},145,63),_V[1]({157,22,181,39,194,75,198,94,220,96,191,61,198,81,224,103,237,121,3,141,19,157,37,175},162,137)},
    [_V[1]({203,15,206,25,83,99,123,139,176,118,177,231,16},102,24)] = {_V[1]({104,188,54,131,249,93,179,38,127,222,24,113,213,59,164,8,106,210,51,155,246,99,196,38},146,100),_V[1]({118,174,12,61,151,223,25,112,173,240,14,75,147,221,42,114,184,4,74,141,219,32,103,178},188,72),_V[1]({189,150,149,103,98,75,38,30,252,224,159,125,102,81,63,40,15,252,226,207,180,156,131,110},98,233),_V[1]({172,240,90,151,253,81,151,250,67,146,188,5,89,175,8,92,174,6,87,172,0,81,169,246},230,84),_V[1]({16,201,168,90,53,254,185,145,79,19,178,112,57,4,210,155,98,47,245,192,137,75,27,222},213,201),_V[1]({43,60,115,125,176,209,228,20,42,70,61,83,116,151,189,222,253,34,64,101,133,159,199,224},152,33)},
    [_V[1]({6,146,234,98,195,43,167,4},72,107)] = {_V[1]({29,225,203,136,110,66,8,235,180,131,45,246,202,168,116,75,32,247,195,153,111},215,212),_V[1]({202,28,148,223,83,181,9,122,209,46,102,189,31,139,229,74,173,17,117,214,48},246,98),_V[1]({72,173,56,150,29,146,249,125,231,87,162,12,129,0,109,229,91,211,64,183,46},97,117),_V[1]({144,36,222,107,33,197,91,14,167,70,192,89,253,171,71,238,147,58,214,124,34},122,164),_V[1]({249,42,129,171,254,63,114,194,248,52,75,129,194,13,70,138,204,16,73,140,207},70,65),_V[1]({118,94,108,77,87,79,57,64,45,32,238,219,211,213,197,192,185,180,164,156,150},12,248)},
    [_V[1]({250,27,37,33,36,56,44,54,73},168,5)] = {_V[1]({234,247,248,245,192,182,183,0,1,2,186,255,253,241,252,0,10,193,247,4,3,198,249,12,13,0,16,204,221,8,4,222,218,218,215,218,215,221,222,224,223,225},129,1),_V[1]({199,12,69,122,125,171,228,101,158,215,199,68,122,166,233,37,103,86,196,9,64,59,166,241,42,85,157,145,218,61,113,131,183,239,36,95,148,210,11,69,119,183},38,57),_V[1]({49,181,45,161,227,80,200,136,0,120,167,99,216,67,197,64,193,239,156,32,150,208,122,4,124,230,109,160,40,202,61,142,1,120,236,102,219,84,202,71,191,57},81,120),_V[1]({225,204,171,134,47,3,226,9,232,199,93,128,92,46,23,249,225,118,138,117,82,243,4,245,212,165,147,45,28,37,255,183,145,111,74,43,6,234,201,169,134,101},154,223),_V[1]({251,149,35,173,5,136,22,236,122,8,77,31,170,43,195,84,235,47,242,140,24,104,40,200,86,214,115,188,90,18,155,2,139,24,162,50,188,79,221,108,248,130},5,142),_V[1]({178,249,52,107,112,160,219,94,153,212,198,69,125,171,240,46,114,99,211,26,83,80,189,10,69,114,188,178,253,98,152,172,226,28,83,144,199,7,66,126,180,246},15,59)},
    [_V[1]({216,116,242,112,232,101,225,109,223},6,127)] = {_V[1]({28,107,224,40,153,248,73,183,11,101,154,238,77,175,19,114,202,50,145,235,78,169},75,95),_V[1]({32,83,172,216,45,112,165,247,47,109,134,190,1,71,143,210,14,90,157,220,26,93},107,67),_V[1]({60,119,216,12,105,180,241,75,139,209,242,50,125,203,27,102,170,254,73,144,219,37},127,75),_V[1]({104,210,98,197,81,203,55,192,47,164,244,99,221,90,217,83,198,73,195,57,177,41},124,122),_V[1]({123,213,85,168,36,142,234,99,194,39,103,198,48,157,12,118,217,76,182,28,137,244},159,106),_V[1]({192,70,242,113,25,175,55,220,103,248,100,239,133,30,185,79,223,116,11,165,63,205},184,150)},
    [_V[1]({236,165,61,224,40,243,168,49,203,101},16,152)] = {_V[1]({196,41,130,215,250,72,161,66,155,244,4,161,247,67,166,2,100,115,1,102,189,216,99,206,39,114,218,238,87,218,46,96,173,10,103,185,20,113,195,35,124},3,89),_V[1]({93,138,171,200,179,201,234,83,116,149,109,210,240,4,47,83,125,84,170,215,246,217,44,95,128,147,195,159,208,27,55,49,70,107,144,170,205,242,12,52,80},212,33),_V[1]({192,93,238,123,214,92,237,198,87,232,48,5,147,23,178,70,224,39,237,138,25,108,47,210,99,230,134,210,115,46,186,36,169,62,211,93,240,133,15,167,55},199,145),_V[1]({153,230,39,100,111,165,230,111,176,241,233,110,172,224,43,111,185,176,38,115,178,181,40,123,188,239,63,59,140,247,51,77,130,199,12,70,137,206,8,79,140},240,65),_V[1]({10,230,182,130,28,225,177,201,153,105,240,4,209,148,110,65,26,160,165,129,79,225,227,197,149,87,54,193,161,155,102,15,211,167,123,68,22,234,179,139,84},210,208),_V[1]({68,93,106,115,74,76,89,174,187,200,140,221,231,231,254,14,36,231,41,66,77,28,91,122,135,134,162,106,135,190,198,172,173,190,207,213,228,245,251,14,26},207,13)},
    [_V[1]({65,207,55,162,246,92,192,225,121,246,105},153,101)] = {_V[1]({246,31,60,85,60,78,107,208,237,10,222,63,89,105,144,176,214,169,251,36,63,30,109,156,185,200,244,204,249,64,88,78,96,128,154,188,216,239,21,49,71},113,29),_V[1]({14,13,0,239,172,148,135,194,181,168,82,137,121,95,92,82,78,247,31,30,15,196,233,238,225,198,200,118,121,150,132,80,56,46,30,22,8,248,232,222,211},179,243),_V[1]({125,99,61,19,183,134,96,130,92,54,199,229,188,137,109,74,45,189,204,178,138,38,50,30,248,196,173,66,44,48,5,184,135,100,59,26,243,200,165,126,94},59,218),_V[1]({226,151,64,229,88,246,159,144,57,226,66,47,213,113,36,208,130,225,191,116,27,134,97,28,197,96,24,124,53,8,172,46,204,120,30,204,116,23,201,113,18},209,169),_V[1]({153,195,225,251,227,246,20,122,152,182,139,237,8,25,65,98,137,93,176,218,246,214,38,86,116,132,177,138,184,0,25,16,35,68,95,130,159,183,222,251,23},19,30),_V[1]({101,2,147,32,123,1,146,107,252,141,213,170,56,188,87,235,133,204,146,47,190,17,212,119,8,139,43,119,24,211,95,201,79,227,113,7,151,36,185,73,215},108,145)},
    [_V[1]({84,244,144,27,165},117,141)] = {_V[1]({184,142,138,89,81,55,15,4,176,139,113,155,121,109,9,46,27,248,222,183,174,144,107,89,68,47,13,1,163,133,108,127,104,87,0,34,14,235},96,230),_V[1]({167,203,21,50,120,172,210,21,15,56,108,228,16,82,60,175,234,21,73,112,181,229,14,74,131,188,232,42,26,74,127,224,25,87,75,187,245,32},1,52),_V[1]({99,65,69,28,28,10,234,231,155,126,108,158,132,128,36,81,70,43,25,250,249,227,198,188,175,162,136,132,46,24,7,34,23,19,187,229,217,190},3,238),_V[1]({141,134,165,151,178,187,182,206,157,155,164,241,242,9,200,16,32,32,41,37,63,68,66,83,97,111,112,135,76,81,91,145,167,170,123,192,207,207},18,9),_V[1]({25,237,231,180,170,142,100,87,1,218,190,230,194,180,78,113,92,55,27,242,231,199,160,140,117,94,58,44,204,172,145,162,153,127,29,61,39,2},195,228),_V[1]({110,242,156,25,191,83,217,124,214,95,243,203,87,249,67,22,177,60,208,87,252,140,21,177,74,227,111,17,97,241,134,71,241,128,210,162,60,199},104,148)},
    [_V[1]({250,62,103,138},153,30)] = {_V[1]({165,161,145,125,55,28,12,68,52,36,203,255,236,207,201,188,181,91,128,124,106,28,62,64,48,18,17,188,188,214,193,138,118,94,80,65,52,38,15,5,245,230},77,240),_V[1]({115,63,255,187,69,250,186,194,130,66,185,189,122,45,247,186,131,249,238,186,120,250,236,190,126,48,255,122,74,52,239,136,68,252,190,127,66,4,188,132,66,0},75,192),_V[1]({77,77,65,49,239,216,204,8,252,240,155,211,196,171,169,160,157,71,112,112,98,24,62,68,56,30,33,208,212,242,225,174,158,138,128,117,108,98,80,69,58,48},241,244),_V[1]({171,158,133,104,25,245,220,11,242,217,119,162,134,96,81,59,43,200,228,215,188,101,126,119,94,55,45,207,198,215,185,121,92,59,36,12,246,223,190,166,142,118},92,231),_V[1]({33,209,117,21,131,28,192,172,80,244,79,55,216,111,29,196,113,203,164,84,246,92,50,232,140,34,213,52,232,182,85,210,114,14,180,89,0,166,65,233,138,54},21,164),_V[1]({235,30,69,104,89,117,156,11,50,89,55,162,198,224,17,59,107,72,164,215,252,229,62,119,158,183,237,207,6,87,121,121,156,187,228,12,54,95,126,170,206,245},92,39)},
    [_V[1]({167,81,211,86,215,85,149,72,228,102,254,122,244},210,133)] = {_V[1]({5,146,69,203,122,23,166,82,228,124,239,129,30,189,94,255,155,51,214,112,15,173,67,224},246,157),_V[1]({60,25,28,242,241,222,189,185,155,131,70,40,21,4,245,230,210,186,173,151,132,115,90,74},221,237),_V[1]({8,171,116,16,213,136,45,239,151,69,206,118,41,222,149,76,254,172,101,21,199,117,42,224},227,179),_V[1]({100,130,198,221,29,75,107,168,203,244,248,27,73,121,171,221,10,51,103,146,193,236,24,68},196,46),_V[1]({142,16,184,51,215,105,237,142,21,162,10,145,35,183,77,227,116,1,153,40,186,72,220,112},138,146),_V[1]({35,55,113,126,180,216,238,33,58,89,83,108,144,182,222,6,41,72,114,147,181,215,253,35},141,36)},
    [_V[1]({103,89,55,13,155,167,152,127},62,217)] = {_V[1]({206,32,152,227,87,185,13,126,213,50,106,193,35,141,240,83,172,15,116,210,52,156,248},250,98),_V[1]({240,102,2,113,9,143,7,156,23,152,244,111,245,131,10,145,14,149,30,160,38,178,50},248,134),_V[1]({217,254,73,103,174,227,10,78,120,168,179,221,18,79,133,187,231,29,85,134,187,246,37},50,53),_V[1]({236,226,254,237,5,11,3,24,19,20,240,235,241,255,6,13,10,17,26,28,34,46,46},116,6),_V[1]({49,102,193,239,70,139,194,22,80,144,171,229,42,119,189,3,63,133,205,14,83,158,221},122,69),_V[1]({11,212,195,133,112,73,20,252,202,158,77,27,244,213,175,137,89,51,15,228,189,156,111},192,217)}
}

local originalSkybox = nil
local originalPostFX = nil
local weaponVisualState = setmetatable({}, {__mode = _V[1]({62},137,74)})
local weaponGlowObjects = setmetatable({}, {__mode = _V[1]({173},168,154)})

if XCConfig.weaponChamsMode == _V[1]({6,69,92,102,119,116,143},179,16) then XCConfig.weaponChamsMode = _V[1]({184,120,8,181,80},214,155) end
if XCConfig.weaponChamsMode == _V[1]({249,241,194,158,107},222,213) then XCConfig.weaponChamsMode = _V[1]({105,10,133,238,104,193,92,208,79,191},171,120) end
if XCConfig.weaponChamsMode == _V[1]({226,183,113,30,204,116},239,176) then XCConfig.weaponChamsMode = _V[1]({222,32,89,112,165},103,42) end
if XCConfig.weaponChamsMode == _V[1]({193,252,21,51},100,22) then XCConfig.weaponChamsMode = _V[1]({166,135,69,6,202,135,69,6,210},158,192) end

function resolveWeaponModel()
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end

    local directCandidates = {}
    for _, child in ipairs(cam:GetChildren()) do
        if child:IsA(_V[1]({12,133,209,41,135},104,87)) then
            local lower = child.Name:lower()
            if not lower:find(_V[1]({38,45,53,64,86},176,10)) and lower ~= _V[1]({120,224,50,143},192,87) and lower ~= _V[1]({16,223,152,92,216},241,190) and lower ~= _V[1]({190,146,80,25,155},154,195) then
                local weapon = child:FindFirstChild(_V[1]({2,56,92,147,186,225},131,40))
                if weapon and weapon:IsA(_V[1]({200,238,231,236,247},119,4)) then
                    return weapon
                end
                table.insert(directCandidates, child)
            end
        end
    end

    for _, root in ipairs(directCandidates) do
        for _, node in ipairs(root:GetDescendants()) do
            if node:IsA(_V[1]({228,250,227,216,211},163,244)) and node.Name == _V[1]({215,198,163,147,115,83},159,225) then
                return node
            end
        end
    end

    for _, root in ipairs(directCandidates) do
        local lower = root.Name:lower()
        if lower ~= _V[1]({215,107,8,187,82,245,139,45,213},192,161) and not lower:find(_V[1]({25,77,138,221,20,87,141,207,23},98,65)) then
            if root:FindFirstChildWhichIsA(_V[1]({207,176,132,56,229,184,139,79},203,194), true) then
                return root
            end
        end
    end

    return nil
end

function saveWeaponPartState(part)
    if weaponVisualState[part] then return end
    local state = {
        material = part.Material,
        color = part.Color,
        transparency = part.Transparency,
        reflectance = part.Reflectance,
        children = {}
    }

    for _, child in ipairs(part:GetChildren()) do
        if child:IsA(_V[1]({43,180,24,115,213,62,167,234,128,231,67,166,30,116,232,68,173},113,103)) or child:IsA(_V[1]({164,32,158,5,113,217,55},229,107)) or child:IsA(_V[1]({158,178,163,148,146},103,243)) then
            local ok, clone = pcall(function() return child:Clone() end)
            if ok and clone then
                table.insert(state.children, clone)
            end
        end
    end
    weaponVisualState[part] = state
end

function restoreWeaponPart(part, state)
    if not part or not state then return end
    pcall(function()
        part.Material = state.material
        part.Color = state.color
        part.Transparency = state.transparency
        part.Reflectance = state.reflectance
    end)

    pcall(function()
        for _, child in ipairs(part:GetChildren()) do
            if child:IsA(_V[1]({112,148,147,137,134,138,142,108,157,159,150,148,167,152,167,158,162},27,2)) or child:IsA(_V[1]({149,48,205,83,222,101,226},183,138)) or child:IsA(_V[1]({105,109,78,47,29},66,227)) then
                child:Destroy()
            end
        end
        for _, clone in ipairs(state.children or {}) do
            if clone then clone:Clone().Parent = part end
        end
    end)
end

function clearWeaponVisuals()
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

function clearWeaponGlow(part)
    local glow = weaponGlowObjects[part]
    if glow then
        pcall(function() glow:Destroy() end)
        weaponGlowObjects[part] = nil
    end
end

function setWeaponVisuals()
    if not XCConfig.weaponChamsEnabled then
        clearWeaponVisuals()
        return
    end

    local model = resolveWeaponModel()
    if not model then
        clearWeaponVisuals()
        return
    end

    local style = XCConfig.weaponChamsMode or _V[1]({234,89,152,244,62},89,74)
    local validStyles = {
        Glass = true,
        ForceField = true,
        Metal = true,
        Highlight = true,
        Neon = true,
    }
    if not validStyles[style] then style = _V[1]({124,78,240,175,92},136,173) end

    local tint = rgb(
        XCConfig.weaponChamsColorR,
        XCConfig.weaponChamsColorG,
        XCConfig.weaponChamsColorB
    )
    local activeParts = {}

    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA(_V[1]({77,74,58,10,211,194,177,145},45,222))
            and part.Name ~= _V[1]({30,28,4,207,185,159},249,221)
            and part.Name ~= _V[1]({163,189,162,131,125,107,82,58,21,31,12,254,199,197,195,178},110,237)
            and part.Name ~= _V[1]({86,70,31,14,225,192,146,112,84,17,11,230,196,173},35,221)
            and not part:FindFirstAncestor(_V[1]({229,199,146,115,56,9,205,157,115,34,14,219,171,134},192,207))
        then
            activeParts[part] = true
            saveWeaponPartState(part)

            pcall(function()
                if style == _V[1]({41,217,102,246,137,21,162,50,205},82,143) then
                    local h = weaponGlowObjects[part]
                    if not h or not h.Parent then
                        h = Instance.new(_V[1]({183,157,96,38,239,177,116,58,11},170,197))
                        h.Name = _V[1]({252,117,23,179,61,218,103,244,87,10,145,43,191},22,142)
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

                    for _, child in ipairs(part:GetChildren()) do
                        if child:IsA(_V[1]({159,203,210,208,213,225,237,211,12,22,21,27,54,47,70,69,81},66,10)) or child:IsA(_V[1]({72,197,68,172,25,130,225},136,108)) or child:IsA(_V[1]({108,46,205,108,24},135,161)) then
                            child:Destroy()
                        end
                    end

                    if style == _V[1]({133,99,17,220,149},133,185) then
                        part.Material = Enum.Material.Glass
                        part.Color = tint
                        part.Transparency = math.clamp(
                            tonumber(XCConfig.weaponChamsTransparency) or 0.4, 0, 1
                        )
                        part.Reflectance = 0
                    elseif style == _V[1]({5,200,101,240,140,7,196,90,251,141},37,154) then
                        part.Material = Enum.Material.ForceField
                        part.Color = tint
                        part.Transparency = 0
                        part.Reflectance = 0
                    elseif style == _V[1]({207,59,158,223,62},46,84) then
                        part.Material = Enum.Material.Metal
                        part.Color = tint
                        part.Reflectance = math.clamp(
                            tonumber(XCConfig.weaponChamsReflectance) or 1.0, 0, 1
                        )
                        part.Transparency = 0
                    elseif style == _V[1]({198,28,101,163},57,63) then
                        part.Material = Enum.Material.Neon
                        part.Color = tint
                        part.Transparency = 0
                        part.Reflectance = 0
                    end
                end
            end)
        end
    end

    for part, state in pairs(weaponVisualState) do
        if not activeParts[part] then
            if part and part.Parent then restoreWeaponPart(part, state) end
            weaponVisualState[part] = nil
            clearWeaponGlow(part)
        end
    end
end

function applyWorldSkybox()
    local data = worldSkyboxData[XCConfig.worldSkyboxPreset]
    if not data or not XCConfig.worldSkyboxEnabled then return end
    pcall(function()

        for _, existing in ipairs(Lighting:GetChildren()) do
            if existing:IsA(_V[1]({173,234,29},53,37)) and existing.Name ~= _V[1]({202,7,109,215,44,120,194,3,109,205},32,82) then
                if not originalSkybox then originalSkybox = existing:Clone() end
                existing:Destroy()
            end
        end
        local sky = Lighting:FindFirstChild(_V[1]({180,217,39,121,182,234,28,69,151,223},34,58))
        if not sky then
            sky = Instance.new(_V[1]({252,255,248},190,235))
            sky.Name = _V[1]({253,250,32,74,95,107,117,118,160,192},147,18)
            sky.Parent = Lighting
        end
        sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt = data[1], data[2], data[3]
        sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = data[4], data[5], data[6]
        pcall(function()
            sky.SkyboxOrientation = Vector3.new(0, tonumber(XCConfig.worldSkyRotation) or 0, 0)
            sky.StarCount = math.clamp(tonumber(XCConfig.worldSkyStars) or 0, 0, 5000)
            sky.CelestialBodiesShown = XCConfig.worldSkyCelestial == true
        end)
    end)
end

function restoreWorldSkybox()
    pcall(function()
        local sky = Lighting:FindFirstChild(_V[1]({71,147,8,129,229,64,153,233,98,209},142,97))
        if sky then sky:Destroy() end
        if originalSkybox then
            originalSkybox.Parent = Lighting
            originalSkybox = nil
        end
    end)
end

function updateWorldPostFX()
    if not XCConfig.worldPostFXEnabled then
        local fx = Lighting:FindFirstChild(_V[1]({158,115,113,115,96,68,38,239,5,236,217,198,132,128},92,234))
        if fx then fx:Destroy() end
        Lighting.ExposureCompensation = defaultLighting.ExposureCompensation or 0
        return
    end
    local fx = Lighting:FindFirstChild(_V[1]({3,61,160,7,89,162,233,23,146,222,48,130,165,6},92,79))
    if not fx then
        fx = Instance.new(_V[1]({173,228,236,250,8,228,27,41,52,50,59,87,87,104,114,84,128,139,149,158,186},95,11))
        fx.Name = _V[1]({180,94,49,8,202,131,58,216,195,127,65,3,150,103},157,191)
        fx.Parent = Lighting
    end
    fx.Enabled = true
    fx.Saturation = math.clamp(XCConfig.worldSaturation or 0, -1, 1)
    fx.Contrast = math.clamp(XCConfig.worldContrast or 0, -1, 1)
    fx.TintColor = XCFeatureState.worldTonePresets[XCConfig.worldTonePreset]
        or rgb(XCConfig.worldColorR, XCConfig.worldColorG, XCConfig.worldColorB)
    Lighting.ExposureCompensation = math.clamp(XCConfig.worldExposure or 0, -5, 5)
end

function updateXCWorldAtmosphere()
    local weatherOwnsFog = XCConfig.weatherEnabled and XCConfig.weatherMode == _V[1]({177,112,254},213,150)
    if not XCConfig.worldAtmosphereEnabled or weatherOwnsFog then
        if XCFeatureState.worldAtmosphere then XCFeatureState.worldAtmosphere:Destroy() end
        XCFeatureState.worldAtmosphere = nil
        if XCFeatureState.worldOriginalAtmosphere and not weatherOwnsFog then
            XCFeatureState.worldOriginalAtmosphere.Parent = Lighting
            XCFeatureState.worldOriginalAtmosphere = nil
        end
        return
    end
    if not XCFeatureState.worldAtmosphere or not XCFeatureState.worldAtmosphere.Parent then
        if not XCFeatureState.worldOriginalAtmosphere then
            for _, object in ipairs(Lighting:GetChildren()) do
                if object:IsA(_V[1]({182,41,98,164,232,37,93,154,231,26},53,64)) and object.Name ~= _V[1]({172,225,63,151,221,58,120,191,22,47,172,239,59,137,208,18,89,176,237},10,74) then
                    XCFeatureState.worldOriginalAtmosphere = object:Clone()
                    object:Destroy()
                    break
                end
            end
        end
        XCFeatureState.worldAtmosphere = Instance.new(_V[1]({69,202,21,105,191,14,88,167,6,75},178,82))
        XCFeatureState.worldAtmosphere.Name = _V[1]({4,106,249,140,10,127,242,74,248,108,233,104,224,83,203,83,193},49,123)
        XCFeatureState.worldAtmosphere.Parent = Lighting
    end
    local atmosphere = XCFeatureState.worldAtmosphere
    atmosphere.Density = math.clamp(tonumber(XCConfig.worldAtmosphereDensity) or 0.3, 0, 1)
    atmosphere.Haze = math.clamp(tonumber(XCConfig.worldAtmosphereHaze) or 0, 0, 10)
    atmosphere.Glare = math.clamp(tonumber(XCConfig.worldAtmosphereGlare) or 0, 0, 10)
    atmosphere.Color = XCFeatureState.worldTonePresets[XCConfig.worldTonePreset] or Color3.fromRGB(220, 230, 210)
    atmosphere.Decay = Color3.fromRGB(92, 102, 82)
end

function updateXCWorldBloom()
    if not XCConfig.worldBloomEnabled then
        if XCFeatureState.worldBloom then XCFeatureState.worldBloom:Destroy() end
        XCFeatureState.worldBloom = nil
        return
    end
    if not XCFeatureState.worldBloom or not XCFeatureState.worldBloom.Parent then
        XCFeatureState.worldBloom = Instance.new(_V[1]({27,166,10,107,202,3,133,230,70,165,23},120,97))
        XCFeatureState.worldBloom.Name = _V[1]({181,229,62,155,227,34,95,130,241,57,126,193},24,69)
        XCFeatureState.worldBloom.Parent = Lighting
    end
    XCFeatureState.worldBloom.Intensity = math.clamp(tonumber(XCConfig.worldBloomIntensity) or 0.35, 0, 3)
    XCFeatureState.worldBloom.Size = math.clamp(tonumber(XCConfig.worldBloomSize) or 24, 0, 56)
    XCFeatureState.worldBloom.Threshold = math.clamp(tonumber(XCConfig.worldBloomThreshold) or 1, 0, 5)
end

function updateWorldChanger()
    if XCConfig.worldSkyboxEnabled then applyWorldSkybox() else restoreWorldSkybox() end
    updateWorldPostFX()
    updateXCWorldAtmosphere()
    updateXCWorldBloom()
    if XCConfig.worldFogEnd and XCConfig.worldFogEnd > 0 then
        Lighting.FogStart = math.max(0, XCConfig.worldFogStart or 0)
        Lighting.FogEnd = math.max(Lighting.FogStart + 1, XCConfig.worldFogEnd)
    end
end

do
    local CAN_PENETRATE = Color3.fromRGB(152, 204, 0)
    local BLOCKED = Color3.fromRGB(220, 55, 62)
    local cubePart = Instance.new(_V[1]({132,78,24,211},123,185))
    cubePart.Name = _V[1]({148,56,13,170,149,59,247,142,108,34,217,154,77,19},131,185)
    cubePart.Anchored = true
    cubePart.CanCollide = false
    cubePart.CanTouch = false
    cubePart.CanQuery = false
    cubePart.CastShadow = false
    cubePart.Material = Enum.Material.Neon
    cubePart.Transparency = 0.82
    cubePart.Size = Vector3.new(1.5, 1.5, 0.01)

    local cubeOutline = Instance.new(_V[1]({185,151,106,47,249,214,151,105,52,212,205,162},154,204))
    cubeOutline.Name = _V[1]({160,82,191,66,160,69,194,64,200,66,207,44,210,81,201,70,203,66},221,128)
    cubeOutline.Adornee = cubePart
    cubeOutline.Color3 = Color3.fromRGB(210, 45, 55)
    cubeOutline.LineThickness = 0.04
    cubeOutline.Transparency = 0.05
    cubeOutline.Parent = cubePart

    local cubeRayParams = RaycastParams.new()
    cubeRayParams.FilterType = Enum.RaycastFilterType.Exclude
    cubeRayParams.IgnoreWater = true

    local cubeGetWeapon = nil
    local cubeNextResolve = 0
    local cubeNextProbe = 0
    local cubeResult = nil
    local cubeColor = BLOCKED

    local function resolveCubeWeapon()
        if type(cubeGetWeapon) == _V[1]({125,134,121,104,115,98,98,91},29,250) then
            local ok, weapon = pcall(cubeGetWeapon)
            if ok and type(weapon) == _V[1]({188,187,206,234,245},54,18) then return weapon end
        end
        if os.clock() < cubeNextResolve then return nil end
        cubeNextResolve = os.clock() + 1
        pcall(function()
            local controllers = ReplicatedStorage:FindFirstChild(_V[1]({103,54,216,129,34,194,98,5,161,81,245},129,163))
            local inventoryScript = controllers and controllers:FindFirstChild(_V[1]({212,35,85,110,161,209,246,35,84,72,158,199,247,31,70,109,151,186,241},97,42))
            local inventory = inventoryScript and require(inventoryScript)
            if type(inventory) == _V[1]({110,174,2,95,171},167,83) and type(inventory.peekCurrentEquippedForMovement) == _V[1]({3,54,83,108,161,186,228,7},121,36) then
                cubeGetWeapon = inventory.peekCurrentEquippedForMovement
            end
        end)
        if type(cubeGetWeapon) == _V[1]({147,190,211,228,17,34,68,95},17,28) then
            local ok, weapon = pcall(cubeGetWeapon)
            if ok then return weapon end
        end
        return nil
    end

    local function ensureCubeRaycast()
        if xcNativeRaycast and type(xcNativeRaycast.cast) == _V[1]({222,217,190,159,156,125,111,90},140,236)
            and type(xcNativeRaycast.castThrough) == _V[1]({126,203,2,53,132,183,251,56},218,62) and type(xcNativeGetRayIgnore) == _V[1]({251,135,253,111,253,111,242,110},24,125) then
            return true
        end
        pcall(function()
            local sharedFolder = ReplicatedStorage:FindFirstChild(_V[1]({198,46,122,222,36,118},32,83))
            local components = ReplicatedStorage:FindFirstChild(_V[1]({158,69,190,60,182,48,162,38,167,33},224,123))
            local common = components and components:FindFirstChild(_V[1]({252,75,108,143,180,214},150,35))
            local raycastScript = sharedFolder and sharedFolder:FindFirstChild(_V[1]({227,165,112,13,190,131,55},222,179))
            local ignoreScript = common and common:FindFirstChild(_V[1]({65,147,214,232,43,119,123,205,8,61,116,155},198,52))
            if raycastScript and ignoreScript then
                xcNativeRaycast = require(raycastScript)
                xcNativeGetRayIgnore = require(ignoreScript)
            end
        end)
        return xcNativeRaycast and type(xcNativeRaycast.cast) == _V[1]({81,186,13,92,199,22,118,207},145,90)
            and type(xcNativeRaycast.castThrough) == _V[1]({147,200,231,2,57,84,128,165},7,38) and type(xcNativeGetRayIgnore) == _V[1]({34,5,210,155,128,73,35,246},232,212)
    end

    local function probeCubePenetration(origin, direction, distance)
        if not ensureCubeRaycast() then return nil, BLOCKED end
        local ignore = xcNativeGetRayIgnore()
        local first = xcNativeRaycast.cast(origin, direction * distance, nil, ignore)
        if type(first) ~= _V[1]({107,255,167,88,248},80,167) or not first.instance or typeof(first.position) ~= _V[1]({181,207,216,244,250,8,212},84,11) then
            return nil, BLOCKED
        end

        local normal = typeof(first.normal) == _V[1]({175,103,14,200,108,24,130},176,169) and first.normal or -direction
        local hitCharacter = first.instance:FindFirstAncestorOfClass(_V[1]({218,175,87,11,197},218,179))
        if hitCharacter and Players:GetPlayerFromCharacter(hitCharacter) then
            return {Position = first.position, Normal = normal}, CAN_PENETRATE
        end

        local weapon = resolveCubeWeapon()
        local properties = weapon and weapon.Bullet and weapon.Bullet.Properties
        local penetration = math.max(0, tonumber(properties and properties.Penetration) or 0)
        if penetration <= 0 then
            return {Position = first.position, Normal = normal}, BLOCKED
        end

        local hits = xcNativeRaycast.castThrough(
            first.position - direction * 0.001,
            direction * (penetration + 0.001),
            penetration,
            ignore
        )
        local canExit = false
        if type(hits) == _V[1]({13,146,43,205,94},1,152) then
            for index, hit in ipairs(hits) do
                if index % 2 == 0 and type(hit) == _V[1]({251,6,37,77,100},105,30) and hit.instance then
                    canExit = true
                    break
                end
            end
        end
        return {Position = first.position, Normal = normal}, canExit and CAN_PENETRATE or BLOCKED
    end

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
            local origin = cam.CFrame.Position
            local direction = cam.CFrame.LookVector
            local now = os.clock()
            if now >= cubeNextProbe then
                cubeNextProbe = now + 0.075
                cubeResult, cubeColor = probeCubePenetration(origin, direction, distance)
                if not cubeResult then
                    cubeRayParams.FilterDescendantsInstances = {player.Character, cubePart}
                    local fallback = Workspace:Raycast(origin, direction * distance, cubeRayParams)
                    if fallback then
                        cubeResult = {Position = fallback.Position, Normal = fallback.Normal}
                        cubeColor = BLOCKED
                    end
                end
            end

            if not cubeResult then
                cubePart.Parent = nil
                return
            end

            cubePart.Size = Vector3.new(size, size, 0.01)
            cubePart.Color = cubeColor
            cubePart.CFrame = CFrame.lookAt(
                cubeResult.Position + cubeResult.Normal * 0.02,
                cubeResult.Position + cubeResult.Normal
            )
            cubeOutline.Color3 = cubeColor
            cubeOutline.LineThickness = lineThickness
            cubeOutline.Transparency = outlineTransparency
            cubePart.Parent = Workspace
        end)
    end)
    table.insert(connections, cubeRenderConnection)
end

function findSniperScope()
    local pg = player and player:FindFirstChildOfClass(_V[1]({224,67,127,222,17,101,129,246,49},73,71))
    if not pg then return nil end
    local main = pg:FindFirstChild(_V[1]({171,70,213,97,193,118,241},215,135))
    local gameplay = main and main:FindFirstChild(_V[1]({226,207,174,121,87,38,238,217},200,211))
    local middle = gameplay and gameplay:FindFirstChild(_V[1]({106,75,11,208,157,91},88,197))
    return middle and middle:FindFirstChild(_V[1]({118,41,188,91,232,141,6,174,82,235,120},139,152)) or nil
end

function ensureScopeGui()
    if scopeGui and scopeGui.Parent then return end
    scopeGui = Instance.new(_V[1]({233,142,50,186,79,237,91,30,167},1,149))
    scopeGui.Name = _V[1]({171,177,204,25,50,78,100,125,126,169,208,236,252},56,27)
    scopeGui.ResetOnSpawn = false
    scopeGui.IgnoreGuiInset = true
    pcall(function() scopeGui.Parent = targetGui end)
    if not scopeGui.Parent then scopeGui.Parent = CoreGui end
    scopeContainer = Instance.new(_V[1]({232,47,57,96,115},135,27))
    scopeContainer.BackgroundTransparency = 1
    scopeContainer.AnchorPoint = Vector2.new(0.5,0.5)
    scopeContainer.Position = UDim2.fromScale(0.5,0.5)
    scopeContainer.Size = UDim2.fromOffset(0,0)
    scopeContainer.Parent = scopeGui
    for name,anchor in pairs({Left=Vector2.new(1,.5),Right=Vector2.new(0,.5),Top=Vector2.new(.5,1),Bottom=Vector2.new(.5,0)}) do
        local f=Instance.new(_V[1]({87,234,64,179,18},170,103))
        f.Name=name; f.AnchorPoint=anchor; f.BorderSizePixel=0; f.Parent=scopeContainer
    end
    local dot=Instance.new(_V[1]({170,96,217,111,241},218,138))
    dot.Name=_V[1]({47,244,147},81,154); dot.AnchorPoint=Vector2.new(.5,.5); dot.BorderSizePixel=0; dot.Parent=scopeContainer
end

function updateCustomScope()
    ensureScopeGui()
    local scope = findSniperScope()
    local scoped = scope and scope.Visible == true
    if scope and scopeSavedSize == nil then scopeSavedSize = scope.Size end

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
        local style = XCConfig.scopeCrosshairStyle or _V[1]({86,176,216,7,50},232,43)

        local l=scopeContainer.Left; local r=scopeContainer.Right
        local t=scopeContainer.Top; local b=scopeContainer.Bottom; local d=scopeContainer.Dot
        local arms = {l,r,t,b,d}

        for _,f in ipairs(arms) do
            f.BackgroundColor3 = col
            f.BackgroundTransparency = opacity
            f.BorderSizePixel = 0
            f.Visible = false
            local st = f:FindFirstChild(_V[1]({136,189,238,20,46,61,136,172,201,235,21,49},16,37))
            if not st then
                st = Instance.new(_V[1]({215,103,13,202,100,253,149,43},230,156))
                st.Name = _V[1]({206,97,240,116,236,89,2,132,255,127,7,129},248,131)
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

        if style == _V[1]({97},189,76) then
            local xLen = math.max(2, len * 0.72)
            if XCConfig.scopeCrosshairLeft ~= false then show(l,UDim2.fromOffset(xLen,thick),UDim2.fromOffset(-gap,-gap),45) end
            if XCConfig.scopeCrosshairRight ~= false then show(r,UDim2.fromOffset(xLen,thick),UDim2.fromOffset(gap,-gap),-45) end
            if XCConfig.scopeCrosshairTop ~= false then show(t,UDim2.fromOffset(xLen,thick),UDim2.fromOffset(-gap,gap),-45) end
            if XCConfig.scopeCrosshairBottom ~= false then show(b,UDim2.fromOffset(xLen,thick),UDim2.fromOffset(gap,gap),45) end
        elseif style == _V[1]({240},108,48) then
            if XCConfig.scopeCrosshairTop ~= false then show(t,UDim2.fromOffset(thick,len),UDim2.fromOffset(0,gap),0) end
            if XCConfig.scopeCrosshairLeft ~= false then show(l,UDim2.fromOffset(len,thick),UDim2.fromOffset(-gap,0),0) end
            if XCConfig.scopeCrosshairRight ~= false then show(r,UDim2.fromOffset(len,thick),UDim2.fromOffset(gap,0),0) end

            if XCConfig.scopeCrosshairBottom ~= false then show(b,UDim2.fromOffset(thick,math.max(2,len*0.55)),UDim2.fromOffset(0,gap),0) end
        elseif style == _V[1]({57,126,157},219,26) then

        else
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

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    local worldVisualActive = XCConfig.nightModeEnabled or XCConfig.worldSkyboxEnabled
        or XCConfig.worldPostFXEnabled or XCConfig.worldAtmosphereEnabled or XCConfig.worldBloomEnabled
    if not XCConfig.weaponChamsEnabled
        and not XCConfig.customScopeEnabled
        and not XCConfig.customFovEnabled
        and not worldVisualActive then
        return
    end
    pcall(function()
        if XCConfig.weaponChamsEnabled then setWeaponVisuals() end
        if XCConfig.customScopeEnabled then updateCustomScope() end

        if XCConfig.customFovEnabled then
            local cam = Workspace.CurrentCamera or camera
            if cam then
                cam.FieldOfView = math.clamp(tonumber(XCConfig.customFov) or 90, 70, 120)
            end
        end
        if worldVisualActive then
            XCFeatureState.worldUpdateAccumulator += dt
            if XCFeatureState.worldUpdateAccumulator >= 0.2 then
                XCFeatureState.worldUpdateAccumulator = 0
                updateWorldChanger()
            end
        end
    end)
end))

local jumpRayParams = RaycastParams.new()
jumpRayParams.FilterType = Enum.RaycastFilterType.Exclude
jumpRayParams.IgnoreWater = true

function getGroundY(originPos, char)
    jumpRayParams.FilterDescendantsInstances = {char, jumpCircleFolder, camera}
    local cast = Workspace:Raycast(originPos + Vector3.new(0, 2, 0), Vector3.new(0, -15, 0), jumpRayParams)
    if cast then
        return cast.Position.Y + 0.04
    end
    return originPos.Y - 2.8
end

function buildJumpRing(segmentCount, radius, thickness, height)
    local container = Instance.new(_V[1]({145,65,197,68,204,96},196,135))
    container.Name = _V[1]({255,79,108,148,140,215,5,27,73,103,106,187,223,10,28,73,115,143,193},144,37)

    local segments = {}
    local angleStep = (math.pi * 2) / segmentCount
    local chordLength = 2 * radius * math.sin(angleStep / 2) + 0.03
    local lineH = height or 0.03
    local lineThick = thickness or 0.06

    for i = 1, segmentCount do
        local angle = (i - 1) * angleStep
        local part = Instance.new(_V[1]({118,104,90,61},69,225))
        part.Name = _V[1]({45,173,29,131},108,110) .. i
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

    local hrp = char:WaitForChild(_V[1]({151,156,108,56,29,246,200,155,97,86,46,11,191,168,145,107},119,216), 4)
    local hum = char:WaitForChild(_V[1]({103,172,188,200,237,6,24,43},7,24), 4)
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

        if XCConfig.jumpCircleStyle == _V[1]({222,248,214,200,188,167,159,148,102,95,99,65},168,239) then
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
        elseif XCConfig.jumpCircleStyle == _V[1]({223,98,202,37,129,211,32,163,248,93,173},62,94) then
            local hue = (elapsed * 0.35) % 1
            local col = Color3.fromHSV(hue, 0.85, 1)
            for _, seg in ipairs(segments) do
                if seg.Part and seg.Part.Parent then
                    seg.Part.Color = col
                    seg.Part.Transparency = 0.1 + (pulse * 0.3)
                end
            end
        elseif XCConfig.jumpCircleStyle == _V[1]({238,90,146,240,48,117,171,13,98,172},80,75) then
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

XCFeatureState = {
    weatherRig = nil,
    weatherEmitter = nil,
    weatherAtmosphere = nil,
    weatherUpdateAccumulator = 0,
    weatherSignature = nil,
    cameraMode = nil,
    savedCameraState = nil,
    cameraFrame = nil,
    cameraPosition = nil,
    cameraYaw = 0,
    cameraPitch = 0,
    cameraTouch = nil,
    cameraTouchLast = nil,
    cameraTouchDelta = Vector2.zero,
    streamerSnapshot = nil,
    noSmokeRecords = setmetatable({}, {__mode = _V[1]({37},182,4)}),
    noSmokeAccumulator = 0,
    antiAimNextChange = 0,
    antiAimRandomYaw = 180,
    bhopGroundSince = nil,
    bhopLastJump = 0,
    bhopWindowFocused = true,
    menuOpen = true,
    worldUpdateAccumulator = 0,
    worldAtmosphere = nil,
    worldOriginalAtmosphere = nil,
    worldBloom = nil,
    worldTonePresets = {
        Neutral = Color3.fromRGB(255, 255, 255),
        [_V[1]({248,162,62,41,5,200,127},225,191)] = Color3.fromRGB(225, 242, 185),
        Cold = Color3.fromRGB(205, 225, 255),
        Warm = Color3.fromRGB(255, 224, 190),
        Purple = Color3.fromRGB(225, 200, 255),
    },
    hitSounds = {
        Skeet = _V[1]({15,218,203,143,124,87,36,14,222,180,101,53,16,244,202,169,126,95,56,23,239,198,161,122,90,54,20},194,219),
        Neverlose = _V[1]({12,70,166,217,53,127,187,20,83,152,184,247,65,141,217,41,110,185,0,80,146,225,46,118,194,9,84,154},80,74),
        Bell = _V[1]({60,105,188,226,49,110,157,233,27,83,102,152,213,28,86,145,210,8,71,129,199,0,63,118,187,244,44},141,61),
        Bell2 = _V[1]({22,168,96,235,159,65,213,134,29,186,50,201,107,15,178,86,244,151,56,224,133,31,198,101,7,168,78,236},2,162),
        Bubble = _V[1]({197,40,177,13,146,5,106,236,84,194,11,115,230,91,205,68,187,40,157,17,128,246,104,218,77,198,52,173},224,115),
        Rust = _V[1]({153,112,109,61,54,29,246,236,200,170,103,67,42,19,251,229,204,174,153,124,103,80,51},64,231),
        Coins = _V[1]({115,208,83,169,40,149,244,112,210,58,125,223,76,191,45,149,4,115,224,75,186,36,152},148,109),
        Agro1 = _V[1]({54,209,146,38,227,142,43,229,133,43,172,76,247,164,81,251,168,85,253,166,84,255,174,86,5,173,91,6},25,171),
        Agro2 = _V[1]({82,191,82,184,71,196,51,191,49,169,252,110,235,106,230,101,230,98,219,95,217,81,211,80,206,73,194,71},99,125),
        Schaater = _V[1]({18,155,74,204,119,16,155,67,209,101,212,98,251,150,53,203,96,254,152,48,201,97,246,152},7,153),
        Pick = _V[1]({30,228,208,143,119,77,21,250,197,150,66,13,227,194,150,103,66,27,235,190,156,107,70},214,214),
    },
    skeletonEdges = {
        {_V[1]({133,146,126,113},77,240), _V[1]({68,118,143,178},219,27)}, {_V[1]({57,158,234,64},157,78), _V[1]({217,238,1,22,34},119,11)},
        {_V[1]({227,213,174,145},186,219), _V[1]({19,203,107,24,150,74,240,149,43,194,98,14},40,159)}, {_V[1]({71,227,103,248,90,242,124,5,127,250,126,14},120,131), _V[1]({152,154,132,123,56,58,48,15},99,233)},
        {_V[1]({4,195,105,25},14,168), _V[1]({211,20,60,103,157,166,229,22,70,103,137,180,235},87,42)}, {_V[1]({194,29,95,164,244,23,112,187,5,64,124,193,18},44,68), _V[1]({221,85,180,22,131,184,50,160,247},42,97)},
        {_V[1]({122,76,28,238,183},91,200), _V[1]({57,175,13,120,169,39,139},144,93)}, {_V[1]({170,188,182,189,138,164,164},101,249), _V[1]({131,82,9,205,85,52,234,165},129,182)},
        {_V[1]({119,168,215,8,48},249,39), _V[1]({108,58,239,167,106,245,205,139},99,183)}, {_V[1]({127,41,186,78,237,84,8,162},154,147), _V[1]({137,20,134,251,123,193,94,210,75},195,116)},
    },
    streamerHiddenKeys = {
        _V[1]({234,229,9,11,41,53,58,92,102,81,139,143,161,188,198,214},98,17), _V[1]({32,17,250,236,241,210,217,200,191,141,158,156,145,86,115,90,79,77,58,45},185,244), _V[1]({211,154,122,70,41,234,196,164,74,71,14,227,193,142,97},145,212), _V[1]({187,228,9,242,60,85,70,139,154,183,221,242,13},61,28),
        _V[1]({180,230,15,49,78,129,119,202,249,236,59,84,123,171,202,239},43,38), _V[1]({169,243,60,148,233,42,81,189,27,59,177,241,63,150,220,40},244,77), _V[1]({19,254,232,217,167,192,179,114,137,106,89,81,56,37},189,238), _V[1]({105,83,46,28,10,3,240,174,195,162,143,133,106,85},9,236),
        _V[1]({138,175,188,223,236,9,36,30,102,125,108,175,188,215,251,14,39},9,26), _V[1]({196,97,230,129,6,155,46,159,78,237,120,8,167,33,200,89,226,130,230,161,38,185,85,224,113},203,146), _V[1]({65,244,177,97,14,177,135,66,239,177,93,26,208,94,67,247,131,99,13,197,134,54,236},23,183), _V[1]({173,3,103,222,69,172,235,129,230,35,180,15,120,234,75,178},206,104),
        _V[1]({216,179,123,78,241,231,192,129,90,35,211,204,143,96,58,3,210},158,208), _V[1]({150,119,98,59,15,0,217,179,160,83,92,47,16,250,211,178},78,224), _V[1]({246,187,116,64,6,152,129,52,245,191,120,55},211,192), _V[1]({67,33,1,238,205,194,163,136,69,89,60,247,6,223,198,182,149,122},234,230),
        _V[1]({148,213,40,124,151,12,95,120,234,63,124,209,22},213,76), _V[1]({66,123,198,18,50,140,211,16,93,167,189,42,117,134,240,61,114,191,252},139,68),
    },
}

function isXCSmokeObject(object)
    if not object or not (object:IsA(_V[1]({6,65,124,168,199,235,30,65,75,157,195,248,34,61,116},140,42)) or object:IsA(_V[1]({79,22,197,110,21},79,173))) then return false end
    local cursor = object
    for _ = 1, 6 do
        if not cursor then break end
        local name = cursor.Name:lower()
        if name:find(_V[1]({224,54,148,236,66},17,92), 1, true) or name:find(_V[1]({204,133,78,251,194},150,192), 1, true) then return true end
        cursor = cursor.Parent
    end
    return false
end

function trackXCSmokeObject(object)
    if not XCConfig.noSmokeEnabled or not isXCSmokeObject(object) then return end
    local record = XCFeatureState.noSmokeRecords[object]
    if not record then
        record = {Enabled = object.Enabled}
        XCFeatureState.noSmokeRecords[object] = record
    end
    pcall(function() object.Enabled = false end)
end

function restoreXCSmoke()
    for object, record in pairs(XCFeatureState.noSmokeRecords) do
        pcall(function()
            if object and object.Parent then object.Enabled = record.Enabled end
        end)
        XCFeatureState.noSmokeRecords[object] = nil
    end
end

function applyXCSmokeState()
    if not XCConfig.noSmokeEnabled then restoreXCSmoke() return end
    task.spawn(function()
        for _, rootName in ipairs({_V[1]({194,136,42,223,123,42},217,165), _V[1]({90,104,85,65,44,42,22},40,237)}) do
            local root = Workspace:FindFirstChild(rootName)
            if root then
                for _, object in ipairs(root:GetDescendants()) do
                    if not XCConfig.noSmokeEnabled then return end
                    if object:IsA(_V[1]({68,172,20,109,185,10,106,186,241,112,195,37,124,196,40},157,87)) or object:IsA(_V[1]({107,168,205,236,9},245,35)) then trackXCSmokeObject(object) end
                end
            end
        end
    end)
end

local xcHitSoundPreloaded = {}
function playXCHitSound(force)
    if not force and not XCConfig.hitSoundEnabled then return end
    task.spawn(function()
        local ok = pcall(function()
            local sound = Instance.new(_V[1]({9,14,253,223,190},205,233))
            sound.Name = _V[1]({189,245,71,181,13,57,162,245,59,126},24,77)
            sound.SoundId = XCFeatureState.hitSounds[XCConfig.hitSoundPreset] or XCFeatureState.hitSounds.Skeet
            sound.Volume = math.clamp(tonumber(XCConfig.hitSoundVolume) or 1, 0.1, 3)
            sound.PlaybackSpeed = 1
            sound.Parent = SoundService
            if not xcHitSoundPreloaded[sound.SoundId] then
                xcHitSoundPreloaded[sound.SoundId] = true
                pcall(function() ContentProvider:PreloadAsync({sound}) end)
            end
            local played = pcall(function() SoundService:PlayLocalSound(sound) end)
            if not played then sound:Play() end
            game:GetService(_V[1]({163,32,121,229,56,158},3,92)):AddItem(sound, 5)
        end)
        if not ok then return end
    end)
end

table.insert(connections, Workspace.DescendantAdded:Connect(function(object)
    if XCConfig.noSmokeEnabled then trackXCSmokeObject(object) end
end))
table.insert(connections, RunService.Heartbeat:Connect(function(dt)
    if not XCConfig.noSmokeEnabled then return end
    XCFeatureState.noSmokeAccumulator += dt
    if XCFeatureState.noSmokeAccumulator < 0.5 then return end
    XCFeatureState.noSmokeAccumulator = 0
    for object in pairs(XCFeatureState.noSmokeRecords) do
        if object and object.Parent then
            pcall(function() object.Enabled = false end)
        else
            XCFeatureState.noSmokeRecords[object] = nil
        end
    end
end))
table.insert(connections, UserInputService.WindowFocusReleased:Connect(function()
    XCFeatureState.bhopWindowFocused = false
    XCFeatureState.bhopGroundSince = nil
end))
table.insert(connections, UserInputService.WindowFocused:Connect(function()
    XCFeatureState.bhopWindowFocused = true
end))

function destroyXCWeather()
    if XCFeatureState.weatherRig then pcall(function() XCFeatureState.weatherRig:Destroy() end) end
    if XCFeatureState.weatherAtmosphere then pcall(function() XCFeatureState.weatherAtmosphere:Destroy() end) end
    XCFeatureState.weatherRig = nil
    XCFeatureState.weatherEmitter = nil
    XCFeatureState.weatherAtmosphere = nil
    XCFeatureState.weatherSignature = nil
end

function ensureXCWeatherObjects()
    if not XCFeatureState.weatherRig or not XCFeatureState.weatherRig.Parent then
        XCFeatureState.weatherRig = Instance.new(_V[1]({84,44,4,205},61,199))
        XCFeatureState.weatherRig.Name = _V[1]({119,2,182,100,0,179,71,228,145,4,204,104,19,179,68,241},127,160)
        XCFeatureState.weatherRig.Size = Vector3.new(1, 1, 1)
        XCFeatureState.weatherRig.Transparency = 1
        XCFeatureState.weatherRig.Anchored = true
        XCFeatureState.weatherRig.CanCollide = false
        pcall(function() XCFeatureState.weatherRig.CanQuery = false; XCFeatureState.weatherRig.CanTouch = false end)
        XCFeatureState.weatherRig.Parent = Workspace

        XCFeatureState.weatherEmitter = Instance.new(_V[1]({104,164,224,13,45,82,134,170,181,8,47,101,144,172,228},237,43))
        XCFeatureState.weatherEmitter.Name = _V[1]({214,198,223,242,243,11,4,6,24,251,17,39,46,40,39,53,51,70},121,5)
        XCFeatureState.weatherEmitter.LockedToPart = false
        XCFeatureState.weatherEmitter.LightInfluence = 0
        XCFeatureState.weatherEmitter.Orientation = Enum.ParticleOrientation.FacingCamera
        pcall(function()
            XCFeatureState.weatherEmitter.Shape = Enum.ParticleEmitterShape.Box
            XCFeatureState.weatherEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
            XCFeatureState.weatherEmitter.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
        end)
        XCFeatureState.weatherEmitter.Parent = XCFeatureState.weatherRig
    end
end

function applyXCWeather()
    if not XCConfig.weatherEnabled then
        destroyXCWeather()
        return
    end

    ensureXCWeatherObjects()
    local mode = tostring(XCConfig.weatherMode or _V[1]({126,31,185,80},154,146))
    local intensity = math.clamp(tonumber(XCConfig.weatherIntensity) or 45, 1, 100)
    local wind = math.clamp(tonumber(XCConfig.weatherWind) or 0, -40, 40)
    local signature = mode .. _V[1]({111},240,69) .. tostring(intensity) .. _V[1]({252},98,96) .. tostring(wind)
    if XCFeatureState.weatherSignature == signature and XCFeatureState.weatherEmitter and XCFeatureState.weatherEmitter.Parent then return end
    XCFeatureState.weatherSignature = signature
    XCFeatureState.weatherEmitter.Enabled = mode ~= _V[1]({146,43,147},220,112)

    if XCFeatureState.weatherAtmosphere then
        XCFeatureState.weatherAtmosphere.Density = mode == _V[1]({248,220,143},247,187) and (0.18 + intensity * 0.0045) or 0
        XCFeatureState.weatherAtmosphere.Haze = mode == _V[1]({143,230,12},27,46) and (1 + intensity * 0.045) or 0
    elseif mode == _V[1]({37,233,124},68,155) then
        XCFeatureState.weatherAtmosphere = Instance.new(_V[1]({194,102,208,67,184,38,143,253,123,223},16,113))
        XCFeatureState.weatherAtmosphere.Name = _V[1]({237,21,102,177,234,58,107,165,239,251,107,161,224,33,91,144,202,20,68},88,61)
        XCFeatureState.weatherAtmosphere.Color = Color3.fromRGB(190, 198, 205)
        XCFeatureState.weatherAtmosphere.Decay = Color3.fromRGB(90, 96, 105)
        XCFeatureState.weatherAtmosphere.Density = 0.18 + intensity * 0.0045
        XCFeatureState.weatherAtmosphere.Haze = 1 + intensity * 0.045
        XCFeatureState.weatherAtmosphere.Glare = 0
        XCFeatureState.weatherAtmosphere.Parent = Lighting
    end

    if mode == _V[1]({106,89,65,38},56,224) then
        XCFeatureState.weatherRig.Size = Vector3.new(90, 1, 90)
        XCFeatureState.weatherEmitter.Texture = _V[1]({145,146,185,179,214,231,234,10,225,231,248,78,80,116,129,147,161,165,196,145,227,229,7,26,32,43,69,79,110,59,144,158,160,194,204,222,232,7,4,35,40,65,87,40,111,128,160},14,17)
        XCFeatureState.weatherEmitter.Rate = intensity * 3.2
        XCFeatureState.weatherEmitter.Lifetime = NumberRange.new(0.65, 1.05)
        XCFeatureState.weatherEmitter.Speed = NumberRange.new(65, 90)
        XCFeatureState.weatherEmitter.Acceleration = Vector3.new(wind, -65, 0)
        XCFeatureState.weatherEmitter.SpreadAngle = Vector2.new(4, 4)
        XCFeatureState.weatherEmitter.Size = NumberSequence.new(0.075)
        XCFeatureState.weatherEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.85, 0.45),
            NumberSequenceKeypoint.new(1, 1),
        })
        XCFeatureState.weatherEmitter.Color = ColorSequence.new(Color3.fromRGB(190, 220, 255))
    elseif mode == _V[1]({237,20,33,53},142,12) then
        XCFeatureState.weatherRig.Size = Vector3.new(100, 1, 100)
        XCFeatureState.weatherEmitter.Texture = _V[1]({16,218,202,141,121,83,31,8,168,119,81,112,59,40,254,217,176,125,101,251,22,225,204,168,119,75,46,1,233,127,157,116,63,42,253,216,171,147,89,65,15,241,208,106,122,84,61},196,218)
        XCFeatureState.weatherEmitter.Rate = intensity * 1.45
        XCFeatureState.weatherEmitter.Lifetime = NumberRange.new(4.5, 7)
        XCFeatureState.weatherEmitter.Speed = NumberRange.new(5, 11)
        XCFeatureState.weatherEmitter.Acceleration = Vector3.new(wind * 0.35, -2.5, 0)
        XCFeatureState.weatherEmitter.SpreadAngle = Vector2.new(18, 18)
        XCFeatureState.weatherEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.12),
            NumberSequenceKeypoint.new(0.5, 0.28),
            NumberSequenceKeypoint.new(1, 0.08),
        })
        XCFeatureState.weatherEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.18),
            NumberSequenceKeypoint.new(1, 0.55),
        })
        XCFeatureState.weatherEmitter.Color = ColorSequence.new(Color3.fromRGB(245, 248, 255))
    elseif mode == _V[1]({167,80,188},239,119) then
        XCFeatureState.weatherRig.Size = Vector3.new(85, 1, 85)
        XCFeatureState.weatherEmitter.Texture = _V[1]({29,247,247,202,198,176,140,133,53,20,254,45,8,5,235,214,189,154,146,56,99,62,57,37,4,232,219,190,182,92,138,110,90,64,36,8,0,222,208,191,105,137,115,108},193,234)
        XCFeatureState.weatherEmitter.Rate = intensity * 1.15
        XCFeatureState.weatherEmitter.Lifetime = NumberRange.new(3.5, 6)
        XCFeatureState.weatherEmitter.Speed = NumberRange.new(4, 9)
        XCFeatureState.weatherEmitter.Acceleration = Vector3.new(wind * 0.5, 5, 0)
        XCFeatureState.weatherEmitter.SpreadAngle = Vector2.new(22, 22)
        XCFeatureState.weatherEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.16),
            NumberSequenceKeypoint.new(1, 0.26),
        })
        XCFeatureState.weatherEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 0.8),
        })
        XCFeatureState.weatherEmitter.Color = ColorSequence.new(Color3.fromRGB(135, 135, 135))
    elseif mode == _V[1]({165,72,213,91,149,65,234,121,242},215,134) then
        XCFeatureState.weatherRig.Size = Vector3.new(90, 1, 90)
        XCFeatureState.weatherEmitter.Texture = _V[1]({229,30,125,175,10,83,142,230,36,104,135,197,14,90,165,236,53,124,202,19,88,168},42,73)
        XCFeatureState.weatherEmitter.Rate = intensity * 2
        XCFeatureState.weatherEmitter.Lifetime = NumberRange.new(2, 3.5)
        XCFeatureState.weatherEmitter.Speed = NumberRange.new(18, 32)
        XCFeatureState.weatherEmitter.Acceleration = Vector3.new(wind * 0.4, -12, 0)
        XCFeatureState.weatherEmitter.SpreadAngle = Vector2.new(20, 20)
        XCFeatureState.weatherEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 0.85),
        })
        XCFeatureState.weatherEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.12),
            NumberSequenceKeypoint.new(1, 0.9),
        })
        XCFeatureState.weatherEmitter.Color = ColorSequence.new(
            Color3.fromRGB(255, 145, 35), Color3.fromRGB(170, 25, 10)
        )
    end
end

function refreshXCToggle(key)
    local refresh = UI_Bind_Registry[key]
    if refresh then pcall(refresh, XCConfig[key] == true) end
end

function setXCStreamerMode(enabled)
    enabled = enabled == true
    if enabled and not XCFeatureState.streamerSnapshot then
        XCFeatureState.streamerSnapshot = {}
        for _, key in ipairs(XCFeatureState.streamerHiddenKeys) do
            XCFeatureState.streamerSnapshot[key] = XCConfig[key]
            XCConfig[key] = false
            refreshXCToggle(key)
        end
        XCConfig.streamerModeEnabled = true
        clearActiveJumpCircle()
    elseif not enabled and XCFeatureState.streamerSnapshot then
        for key, value in pairs(XCFeatureState.streamerSnapshot) do
            XCConfig[key] = value
            refreshXCToggle(key)
        end
        XCFeatureState.streamerSnapshot = nil
        XCConfig.streamerModeEnabled = false
        if XCConfig.jumpCircleEnabled and player.Character then
            initJumpCircleForCharacter(player.Character)
        end
    else
        XCConfig.streamerModeEnabled = enabled
    end
    refreshXCToggle(_V[1]({59,52,42,21,9,13,253,2,213,239,220,213,173,206,185,178,180,165,156},208,248))
end

function stopXCCameraMode()
    XCFeatureState.cameraMode = nil
    XCConfig.freecamEnabled = false
    XCConfig.freelookEnabled = false
    local cam = Workspace.CurrentCamera or camera
    if cam and XCFeatureState.savedCameraState then
        pcall(function()
            cam.CameraType = XCFeatureState.savedCameraState.CameraType or Enum.CameraType.Custom
            if XCFeatureState.savedCameraState.CameraSubject then cam.CameraSubject = XCFeatureState.savedCameraState.CameraSubject end
            cam.CFrame = XCFeatureState.savedCameraState.CFrame or cam.CFrame
        end)
    end
    if XCFeatureState.savedCameraState then
        pcall(function()
            UserInputService.MouseBehavior = XCFeatureState.savedCameraState.MouseBehavior
            UserInputService.MouseIconEnabled = XCFeatureState.savedCameraState.MouseIconEnabled
        end)
    end
    XCFeatureState.savedCameraState = nil
    refreshXCToggle(_V[1]({65,70,50,43,34,25,30,239,17,253,247,250,236,228},226,249))
    refreshXCToggle(_V[1]({174,117,35,222,160,94,25,208,101,73,247,179,120,44,230},141,187))
end

function setXCCameraMode(mode, enabled)
    if not enabled then
        if XCFeatureState.cameraMode == mode then stopXCCameraMode() end
        return
    end

    local cam = Workspace.CurrentCamera or camera
    if not cam then return end
    if not XCFeatureState.savedCameraState then
        XCFeatureState.savedCameraState = {
            CameraType = cam.CameraType,
            CameraSubject = cam.CameraSubject,
            CFrame = cam.CFrame,
            MouseBehavior = UserInputService.MouseBehavior,
            MouseIconEnabled = UserInputService.MouseIconEnabled,
        }
    end

    XCFeatureState.cameraMode = mode
    XCConfig.freecamEnabled = mode == _V[1]({6,100,137,187,235,27,89},142,50)
    XCConfig.freelookEnabled = mode == _V[1]({53,55,0,214,179,140,98,52},25,214)
    XCFeatureState.cameraFrame = cam.CFrame
    XCFeatureState.cameraPosition = cam.CFrame.Position
    local pitch, yaw = cam.CFrame:ToOrientation()
    XCFeatureState.cameraPitch = pitch
    XCFeatureState.cameraYaw = yaw
    cam.CameraType = Enum.CameraType.Scriptable
    if not UserInputService.TouchEnabled then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false
    end
    refreshXCToggle(_V[1]({199,14,60,119,176,233,48,67,167,213,17,86,138,196},38,59))
    refreshXCToggle(_V[1]({212,211,185,172,166,156,143,126,75,103,77,65,62,42,28},123,243))
end

table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Touch and XCFeatureState.cameraMode and not processed then
        local cam = Workspace.CurrentCamera or camera
        if cam and input.Position.X >= cam.ViewportSize.X * 0.45 then
            XCFeatureState.cameraTouch = input
            XCFeatureState.cameraTouchLast = input.Position
            XCFeatureState.cameraTouchDelta = Vector2.zero
        end
    end
    if processed then return end
    local freecamKey = Enum.KeyCode[XCConfig.freecamKey or _V[1]({35,230},8,213)]
    local freelookKey = Enum.KeyCode[XCConfig.freelookKey or _V[1]({162,92,254,173,27,231,144},181,161)]
    local streamerKey = Enum.KeyCode[XCConfig.streamerKey or _V[1]({210,213},123,17)]
    if freecamKey and input.KeyCode == freecamKey then
        setXCCameraMode(_V[1]({170,153,79,18,211,148,99},161,195), not XCConfig.freecamEnabled)
    elseif freelookKey and input.KeyCode == freelookKey then
        setXCCameraMode(_V[1]({126,181,179,190,208,222,233,240},45,11), not XCConfig.freelookEnabled)
    elseif streamerKey and input.KeyCode == streamerKey then
        setXCStreamerMode(not XCConfig.streamerModeEnabled)
    end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
    if input == XCFeatureState.cameraTouch and XCFeatureState.cameraTouchLast then
        local current = input.Position
        XCFeatureState.cameraTouchDelta += Vector2.new(current.X - XCFeatureState.cameraTouchLast.X, current.Y - XCFeatureState.cameraTouchLast.Y)
        XCFeatureState.cameraTouchLast = current
    end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
    if input == XCFeatureState.cameraTouch then
        XCFeatureState.cameraTouch = nil
        XCFeatureState.cameraTouchLast = nil
        XCFeatureState.cameraTouchDelta = Vector2.zero
    end
end))

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    if XCConfig.weatherEnabled then
        XCFeatureState.weatherUpdateAccumulator += dt
        if XCFeatureState.weatherUpdateAccumulator >= 0.1 then
            XCFeatureState.weatherUpdateAccumulator = 0
            applyXCWeather()
            local cam = Workspace.CurrentCamera or camera
            if XCFeatureState.weatherRig and cam then
                XCFeatureState.weatherRig.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 30, 0))
            end
        end
    elseif XCFeatureState.weatherRig or XCFeatureState.weatherAtmosphere then
        destroyXCWeather()
    end

    if not XCFeatureState.cameraMode then return end
    local cam = Workspace.CurrentCamera or camera
    if not cam then return end
    if (XCFeatureState.cameraMode == _V[1]({202,221,183,158,131,104,91},157,231) and not XCConfig.freecamEnabled)
        or (XCFeatureState.cameraMode == _V[1]({170,233,239,2,28,50,69,84},81,19) and not XCConfig.freelookEnabled) then
        stopXCCameraMode()
        return
    end

    cam.CameraType = Enum.CameraType.Scriptable
    local delta = UserInputService:GetMouseDelta() + XCFeatureState.cameraTouchDelta * 0.55
    XCFeatureState.cameraTouchDelta = Vector2.zero
    local sensitivity = XCFeatureState.cameraMode == _V[1]({82,25,167,66,219,116,27},113,155)
        and (tonumber(XCConfig.freecamSensitivity) or 0.18)
        or (tonumber(XCConfig.freelookSensitivity) or 0.16)
    XCFeatureState.cameraYaw -= math.rad(delta.X * sensitivity)
    XCFeatureState.cameraPitch = math.clamp(XCFeatureState.cameraPitch - math.rad(delta.Y * sensitivity), math.rad(-85), math.rad(85))
    local rotation = CFrame.Angles(0, XCFeatureState.cameraYaw, 0) * CFrame.Angles(XCFeatureState.cameraPitch, 0, 0)

    if XCFeatureState.cameraMode == _V[1]({128,252,63,143,221,43,135},234,80) then
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
            XCFeatureState.cameraPosition += rotation:VectorToWorldSpace(movement.Unit) * speed * dt
        end
        if UserInputService.TouchEnabled then
            local character = player and player.Character
            local humanoid = character and character:FindFirstChildOfClass(_V[1]({49,155,208,1,75,137,192,248},172,61))
            if humanoid and humanoid.MoveDirection.Magnitude > 0.05 then
                XCFeatureState.cameraPosition += humanoid.MoveDirection.Unit * speed * dt
            end
        end
    end

    XCFeatureState.cameraFrame = CFrame.new(XCFeatureState.cameraPosition) * rotation
    cam.CFrame = XCFeatureState.cameraFrame
end))

function cleanup()
    XCConfig.silentAimEnabled = false
    setXCSilentAimRequested(false)
    pcall(restoreXCKnifeModel)
    setXCStreamerMode(false)
    stopXCCameraMode()
    destroyXCWeather()
    pcall(function() setThirdPersonEnabled(false) end)
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass(_V[1]({193,110,230,90,231,104,226,93},249,128))
        if hum and savedAutoRotate ~= nil then
            hum.AutoRotate = savedAutoRotate
        end
    end
    savedAutoRotate = nil
    hitmarkerSerial += 1
    hitmarkerPendingHits = {}
    restoreXCCharacterInputHook()

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
            esp.BoxOutline:Destroy()
            esp.TagCard:Destroy()
            esp.HealthBarBg:Destroy()
            esp.WeaponCard:Destroy()
            for _, corner in pairs(esp.Corners) do
                corner.H:Destroy()
                corner.V:Destroy()
            end
            for _, line in ipairs(esp.SkeletonLines or {}) do line:Destroy() end
        end)
    end
    for _, gUi in pairs(grenadePool) do
        pcall(function() destroyXCGrenadeUI(gUi) end)
    end
    for _, danger in pairs(grenadeDangerPool) do
        pcall(function() destroyXCGrenadeDanger(danger) end)
    end
    for _, pulse in ipairs(soundEspPulses) do
        pcall(function() destroyXCSoundPulse(pulse) end)
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
    grenadeDangerPool = setmetatable({}, {__mode = _V[1]({132},180,101)})
    grenadeDangerScanStarted = false
    soundEspTracked = setmetatable({}, {__mode = _V[1]({253},211,191)})
    soundEspPulses = {}

    restoreLightingState()
    restoreXCSmoke()
    if genv and type(genv.XCRestoreWeaponState) == _V[1]({194,250,28,58,116,146,193,233},51,41) then
        pcall(genv.XCRestoreWeaponState)
        genv.XCRestoreWeaponState = nil
    end
    if sharedXCEnv then
        sharedXCEnv.XCSilentAimRequestedV25 = false
        sharedXCEnv.XCBulletInterceptContextV29 = nil
    end

    pcall(function() if targetGui:FindFirstChild(_V[1]({253,171,126,81,35,217,156,104,4,245,172},226,195)) then targetGui.XCScreenGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild(_V[1]({13,216,201,196,156,124,97,58,252,10,222},213,224)) then targetGui.XCToggleGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild(_V[1]({102,178,22,160,8,58,201,30},173,97)) then targetGui.XCFovGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild(_V[1]({196,210,9,54,108,128,176,206,229,25,53,52,133,156},73,35)) then targetGui.XCWatermarkGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild(_V[1]({190,85,12,217,138,43,212,131,41,211,146,51,229,144,65,193,155,59},186,172)) then targetGui.XCNotificationsGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild(_V[1]({42,247,220,217,198,168,128,97,69,47,237,253,211},240,226)) then targetGui.XCFallbackGui:Destroy() end end)
    pcall(function() if spectatorGui then spectatorGui:Destroy() end end)
    stopXCAnimation()
    pcall(function() if targetGui:FindFirstChild(_V[1]({92,233,149,75,245,156,19,225,130,42,185,99,10,163,82},98,162)) then targetGui.XCMainContainer:Destroy() end end)
end

if genv then genv.XCRunning = cleanup end

function bindTouch(btn, callback)
    btn.Activated:Connect(callback)
end

local fovGui = Instance.new(_V[1]({248,144,39,162,42,187,28,210,78},29,136))
fovGui.Name = _V[1]({123,136,173,248,33,20,100,122},1,34)
fovGui.ResetOnSpawn = false
fovGui.DisplayOrder = 9
fovGui.IgnoreGuiInset = true
fovGui.Parent = targetGui

local fovFrame = Instance.new(_V[1]({240,20,251,255,239},178,248), fovGui)
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovFrame.BackgroundTransparency = 1
fovFrame.BorderSizePixel = 0
fovFrame.Visible = false
local fovStroke = Instance.new(_V[1]({6,144,48,231,123,14,160,48},27,150), fovFrame)
fovStroke.Color = currentTheme.Accent
fovStroke.Thickness = 0.8
local fovCorner = Instance.new(_V[1]({93,111,135,209,242,12,33,76},234,30), fovFrame)
fovCorner.CornerRadius = UDim.new(1, 0)

local silentFovFrame = Instance.new(_V[1]({169,89,204,92,216},223,132), fovGui)
silentFovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
silentFovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
silentFovFrame.BackgroundTransparency = 1
silentFovFrame.BorderSizePixel = 0
silentFovFrame.Visible = false
local silentFovStroke = Instance.new(_V[1]({4,18,54,113,137,160,182,202},149,26), silentFovFrame)
silentFovStroke.Color = Color3.fromRGB(0, 230, 255)
silentFovStroke.Thickness = 0.8
local silentFovCorner = Instance.new(_V[1]({249,182,121,110,58,255,191,149},219,201), silentFovFrame)
silentFovCorner.CornerRadius = UDim.new(1, 0)

local watermarkGui = Instance.new(_V[1]({83,146,208,242,33,89,97,190,225},209,47))
watermarkGui.Name = _V[1]({7,189,156,113,79,11,227,169,104,68,8,175,168,103},228,203)
watermarkGui.ResetOnSpawn = false
watermarkGui.DisplayOrder = 20
watermarkGui.IgnoreGuiInset = true
watermarkGui.Parent = targetGui

local wmCard = Instance.new(_V[1]({182,158,73,17,197},180,188), watermarkGui)
wmCard.Position = UDim2.new(0, 14, 0, 14)
wmCard.Size = UDim2.new(0, 0, 0, 22)
wmCard.AutomaticSize = Enum.AutomaticSize.X
wmCard.BackgroundColor3 = currentTheme.Background
wmCard.BorderSizePixel = 0
Instance.new(_V[1]({164,116,74,82,49,9,220,197},115,220), wmCard).CornerRadius = UDim.new(0, 5)

local wmStroke = Instance.new(_V[1]({190,197,226,22,39,55,70,83},86,19), wmCard)
wmStroke.Color = currentTheme.Border
wmStroke.Thickness = 1.0

local wmPad = Instance.new(_V[1]({215,28,116,214,42,123,209,39,113},49,81), wmCard)
wmPad.PaddingLeft = UDim.new(0, 8)
wmPad.PaddingRight = UDim.new(0, 8)

local wmLayout = Instance.new(_V[1]({212,30,119,234,74,161,207,58,168,244,80,165},41,86), wmCard)
wmLayout.FillDirection = Enum.FillDirection.Horizontal
wmLayout.VerticalAlignment = Enum.VerticalAlignment.Center
wmLayout.Padding = UDim.new(0, 5)

local wmDot = Instance.new(_V[1]({142,94,241,161,61},164,164), wmCard)
wmDot.Size = UDim2.new(0, 5, 0, 5)
wmDot.BackgroundColor3 = currentTheme.Accent
wmDot.BorderSizePixel = 0
Instance.new(_V[1]({253,13,35,107,138,162,181,222},140,28), wmDot).CornerRadius = UDim.new(1, 0)

local wmTitle = Instance.new(_V[1]({135,162,191,197,167,198,209,222,239},41,10), wmCard)
wmTitle.AutomaticSize = Enum.AutomaticSize.X
wmTitle.Size = UDim2.new(0, 0, 1, 0)
wmTitle.BackgroundTransparency = 1
wmTitle.Text = _V[1]({44,14},221,247)
wmTitle.TextColor3 = currentTheme.Accent
wmTitle.TextSize = 9
wmTitle.Font = Enum.Font.GothamBold

local wmDivider = Instance.new(_V[1]({164,160,95,59,3},142,208), wmCard)
wmDivider.Size = UDim2.new(0, 1, 0, 10)
wmDivider.BackgroundColor3 = currentTheme.Border
wmDivider.BorderSizePixel = 0

local wmMetrics = Instance.new(_V[1]({116,51,244,158,36,231,150,71,252},114,174), wmCard)
wmMetrics.AutomaticSize = Enum.AutomaticSize.X
wmMetrics.Size = UDim2.new(0, 0, 1, 0)
wmMetrics.BackgroundTransparency = 1
wmMetrics.Text = _V[1]({86,100,107,86,64,90,88,76,172,84,136,133,142,139,130,108,128,193,203},12,4)
wmMetrics.TextColor3 = currentTheme.TextSecondary
wmMetrics.TextSize = 8.5
wmMetrics.Font = Enum.Font.GothamBold

local fpsCounter = 0
local lastFpsUpdate = tick()

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

local function setXCGrenadeLine(line, a, b, color, thickness, transparency)
    if not a or not b then line.Visible = false return end
    local delta = b - a
    if delta.Magnitude < 0.5 then line.Visible = false return end
    line.Size = UDim2.fromOffset(delta.Magnitude + 1, thickness)
    line.Position = UDim2.fromOffset((a.X + b.X) * 0.5, (a.Y + b.Y) * 0.5)
    line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    line.BackgroundColor3 = color
    line.BackgroundTransparency = transparency
    line.Visible = true
end

function getOrCreateGrenadeUI(nadeInstance)
    if grenadePool[nadeInstance] then return grenadePool[nadeInstance] end

    local tag = Instance.new(_V[1]({94,243,75,192,33},175,105), grenadeContainer)
    tag.Size = UDim2.new(0, 0, 0, 20)
    tag.AutomaticSize = Enum.AutomaticSize.X
    tag.AnchorPoint = Vector2.new(0.5, 1)
    tag.BackgroundColor3 = Color3.fromRGB(8, 10, 12)
    tag.BackgroundTransparency = 0.12
    tag.BorderSizePixel = 0
    tag.Visible = false
    tag.ZIndex = 12
    Instance.new(_V[1]({12,124,242,154,25,145,4,141},59,124), tag).CornerRadius = UDim.new(0, 4)
    local tagStroke = Instance.new(_V[1]({107,124,163,225,252,22,47,70},249,29), tag)
    tagStroke.Thickness = 1
    tagStroke.Transparency = 0.22

    local pad = Instance.new(_V[1]({95,162,248,88,170,249,77,161,233},187,79), tag)
    pad.PaddingLeft = UDim.new(0, 9)
    pad.PaddingRight = UDim.new(0, 7)

    local accent = Instance.new(_V[1]({107,27,142,30,154},161,132), tag)
    accent.Name = _V[1]({39,207,85,221,108,248},96,134)
    accent.AnchorPoint = Vector2.new(0, 0.5)
    accent.Position = UDim2.new(0, -7, 0.5, 0)
    accent.Size = UDim2.fromOffset(2, 12)
    accent.BorderSizePixel = 0
    accent.ZIndex = 13
    Instance.new(_V[1]({176,94,18,248,181,107,28,227},161,186), accent).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new(_V[1]({223,78,191,25,79,194,33,130,231},45,94), tag)
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextSize = 9.5
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.ZIndex = 13

    local radiusCircle = Instance.new(_V[1]({9,55,40,54,48},193,2), grenadeContainer)
    radiusCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    radiusCircle.BackgroundTransparency = 1
    radiusCircle.BorderSizePixel = 0
    radiusCircle.Visible = false
    Instance.new(_V[1]({251,113,237,155,32,158,23,166},36,130), radiusCircle).CornerRadius = UDim.new(1, 0)
    local radStroke = Instance.new(_V[1]({103,197,57,196,44,147,249,93},168,106), radiusCircle)
    radStroke.Thickness = 1.5

    local landingGlow = Instance.new(_V[1]({223,28,28,57,66},136,17), grenadeContainer)
    landingGlow.Name = _V[1]({52,213,62,189,38,159,22,115,254,129,237,104,227,82,168,67,188,58},119,118)
    landingGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    landingGlow.Size = UDim2.fromOffset(15, 15)
    landingGlow.BorderSizePixel = 0
    landingGlow.Rotation = 45
    landingGlow.BackgroundTransparency = 0.72
    landingGlow.Visible = false
    landingGlow.ZIndex = 9
    Instance.new(_V[1]({11,222,183,194,164,127,85,65},215,223), landingGlow).CornerRadius = UDim.new(0, 3)

    local landing = Instance.new(_V[1]({234,168,41,199,81},18,146), grenadeContainer)
    landing.Name = _V[1]({132,205,222,5,22,55,86,91,142,185,205,240,19,42},31,30)
    landing.AnchorPoint = Vector2.new(0.5, 0.5)
    landing.Size = UDim2.fromOffset(8, 8)
    landing.BorderSizePixel = 0
    landing.Rotation = 45
    landing.Visible = false
    landing.ZIndex = 11
    Instance.new(_V[1]({249,69,151,27,118,202,25,126},76,88), landing).CornerRadius = UDim.new(0, 2)
    local landingStroke = Instance.new(_V[1]({1,62,145,251,66,136,205,16},99,73), landing)
    landingStroke.Color = Color3.fromRGB(5, 6, 7)
    landingStroke.Thickness = 1

    local data = {
        Tag = tag,
        TagStroke = tagStroke,
        Accent = accent,
        Label = lbl,
        RadiusCircle = radiusCircle,
        RadiusStroke = radStroke,
        Landing = landing,
        LandingGlow = landingGlow,
        Lines = {},
        RadiusLines = {},
        PathWorld = {},
        LandingWorld = nil,
        RadiusCenter = nil,
        NextTrajectory = 0,
        NextRadius = 0,
    }

    for j = 1, 18 do
        local glow = Instance.new(_V[1]({123,123,62,30,234},97,212), grenadeContainer)
        glow.Name = _V[1]({157,170,136,128,106,87,87,65,51,41,230,250,236,227,186},90,239) .. j
        glow.BorderSizePixel = 0
        glow.AnchorPoint = Vector2.new(0.5, 0.5)
        glow.Visible = false
        glow.ZIndex = 8
        local core = Instance.new(_V[1]({162,72,177,55,169},226,122), grenadeContainer)
        core.Name = _V[1]({245,7,234,231,214,200,205,188,179,174,108,140,131,106,88},173,244) .. j
        core.BorderSizePixel = 0
        core.AnchorPoint = Vector2.new(0.5, 0.5)
        core.Visible = false
        core.ZIndex = 10
        table.insert(data.Lines, {Glow = glow, Core = core})
    end

    for j = 1, 24 do
        local seg = Instance.new(_V[1]({155,109,2,180,82},175,166), grenadeContainer)
        seg.Name = _V[1]({75,221,55,167,1,107,211,39,157,7,115,230,75,158},157,103) .. j
        seg.BorderSizePixel = 0
        seg.AnchorPoint = Vector2.new(0.5, 0.5)
        seg.Visible = false
        seg.ZIndex = 7
        table.insert(data.RadiusLines, seg)
    end

    grenadePool[nadeInstance] = data
    return data
end

function hideXCGrenadeUI(ui)
    ui.Tag.Visible = false
    ui.RadiusCircle.Visible = false
    ui.Landing.Visible = false
    ui.LandingGlow.Visible = false
    for _, line in ipairs(ui.Lines) do
        line.Glow.Visible = false
        line.Core.Visible = false
    end
    for _, line in ipairs(ui.RadiusLines) do line.Visible = false end
end

function destroyXCGrenadeUI(ui)
    hideXCGrenadeUI(ui)
    ui.Tag:Destroy()
    ui.RadiusCircle:Destroy()
    ui.Landing:Destroy()
    ui.LandingGlow:Destroy()
    for _, line in ipairs(ui.Lines) do
        line.Glow:Destroy()
        line.Core:Destroy()
    end
    for _, line in ipairs(ui.RadiusLines) do line:Destroy() end
end

function renderGrenadeOverlays()
    if not XCConfig.grenadeEspEnabled then
        for _, ui in pairs(grenadePool) do hideXCGrenadeUI(ui) end
        return
    end

    local now = os.clock()
    local camPos = camera.CFrame.Position
    local activeGrenades = {}

    for _, item in ipairs(Workspace:GetChildren()) do
        if not isEntityCharacter(item) then
            local nName = item.Name:lower()
            local nadeType, nadeColor, effectRadiusStuds

            if nName:find(_V[1]({217,160,98,42,244,180,128},167,197), 1, true) or nName:find(_V[1]({215,4,33,75,124,154,199,231,32,79},70,40), 1, true)
                or nName:find(_V[1]({118,69,26,217},68,204), 1, true) then
                nadeType, nadeColor, effectRadiusStuds = _V[1]({218,3,39,81,125,159,205},102,39), currentTheme.MolotovColor, 17
            elseif nName:find(_V[1]({17,225,185,139,91},200,214), 1, true) then
                nadeType, nadeColor, effectRadiusStuds = _V[1]({120,179,246,51,110},228,65), currentTheme.SmokeColor, 20
            elseif nName:find(_V[1]({7,146,12,163,29},28,133), 1, true) then
                nadeType, nadeColor, effectRadiusStuds = _V[1]({80,201,49,182,30},151,115), Color3.fromRGB(245, 235, 120), 10
            elseif nName:find(_V[1]({34,171,57,208,79,228,99,242,127},46,140), 1, true) or nName:find(_V[1]({70,183,11,118},123,101), 1, true)
                or nName:find(_V[1]({231,226,197,190,161,148,133},144,240), 1, true) then
                nadeType, nadeColor, effectRadiusStuds = _V[1]({132,110},79,237), currentTheme.HEColor, 15
            end

            if nadeType then
                local part = item:IsA(_V[1]({200,56,155,222,26,124,222,49},53,81)) and item or item:FindFirstChildWhichIsA(_V[1]({219,31,86,109,125,179,233,16},116,37), true)
                if part and part.Parent and part:IsDescendantOf(Workspace) then
                    local dist = (part.Position - camPos).Magnitude
                    if dist <= XCConfig.grenadeMaxDist then
                        activeGrenades[item] = true
                        local ui = getOrCreateGrenadeUI(item)
                        local screen, onScreen = camera:WorldToViewportPoint(part.Position)
                        ui.Accent.BackgroundColor3 = nadeColor
                        ui.TagStroke.Color = nadeColor
                        ui.Label.TextColor3 = nadeColor
                        ui.Label.Text = string.format(_V[1]({21,48,170,119,230,168,222,171,125,137,95},35,205), nadeType, math.floor(dist + 0.5))
                        ui.Tag.Position = UDim2.fromOffset(screen.X, screen.Y - 9)
                        ui.Tag.Visible = onScreen and screen.Z > 0
                        ui.RadiusCircle.Visible = false

                        grenadeRayParams.FilterDescendantsInstances = {player.Character, item, camera}
                        local velocity = part.AssemblyLinearVelocity or Vector3.zero
                        local pathEnabled = XCConfig.showGrenadePath and velocity.Magnitude > 2
                        if pathEnabled and now >= ui.NextTrajectory then
                            ui.NextTrajectory = now + (1 / 30)
                            table.clear(ui.PathWorld)
                            local simPosition = part.Position
                            local gravity = Vector3.new(0, -Workspace.Gravity, 0)
                            local stepTime = 0.075
                            local bounces = 0
                            ui.PathWorld[1] = simPosition
                            ui.LandingWorld = simPosition
                            for _ = 1, #ui.Lines do
                                local nextPosition = simPosition + velocity * stepTime
                                    + gravity * (0.5 * stepTime * stepTime)
                                local nextVelocity = velocity + gravity * stepTime
                                local hit = Workspace:Raycast(simPosition, nextPosition - simPosition, grenadeRayParams)
                                if hit then nextPosition = hit.Position end
                                ui.PathWorld[#ui.PathWorld + 1] = nextPosition
                                ui.LandingWorld = nextPosition
                                if hit then
                                    bounces += 1
                                    local reflected = nextVelocity - 2 * nextVelocity:Dot(hit.Normal) * hit.Normal
                                    velocity = reflected * (hit.Normal.Y > 0.45 and 0.43 or 0.52)
                                    simPosition = hit.Position + hit.Normal * 0.06
                                    if bounces >= 3 or velocity.Magnitude < 8 then break end
                                else
                                    simPosition = nextPosition
                                    velocity = nextVelocity
                                end
                            end
                        elseif not pathEnabled then
                            table.clear(ui.PathWorld)
                            ui.LandingWorld = nil
                        end

                        for step, line in ipairs(ui.Lines) do
                            local worldA, worldB = ui.PathWorld[step], ui.PathWorld[step + 1]
                            if worldA and worldB then
                                local p1, visible1 = camera:WorldToViewportPoint(worldA)
                                local p2, visible2 = camera:WorldToViewportPoint(worldB)
                                if visible1 and visible2 and p1.Z > 0 and p2.Z > 0 then
                                    local a = Vector2.new(p1.X, p1.Y)
                                    local b = Vector2.new(p2.X, p2.Y)
                                    local progress = step / #ui.Lines
                                    setXCGrenadeLine(line.Glow, a, b, nadeColor, 4.5, 0.72 + progress * 0.18)
                                    setXCGrenadeLine(line.Core, a, b, nadeColor, 1.55, 0.05 + progress * 0.45)
                                else
                                    line.Glow.Visible = false
                                    line.Core.Visible = false
                                end
                            else
                                line.Glow.Visible = false
                                line.Core.Visible = false
                            end
                        end

                        if pathEnabled and ui.LandingWorld then
                            local landingScreen, landingVisible = camera:WorldToViewportPoint(ui.LandingWorld)
                            local showLanding = landingVisible and landingScreen.Z > 0
                            local pulse = 0.65 + math.sin(now * 6) * 0.15
                            ui.Landing.Position = UDim2.fromOffset(landingScreen.X, landingScreen.Y)
                            ui.Landing.BackgroundColor3 = nadeColor
                            ui.Landing.Visible = showLanding
                            ui.LandingGlow.Position = ui.Landing.Position
                            ui.LandingGlow.BackgroundColor3 = nadeColor
                            ui.LandingGlow.BackgroundTransparency = pulse
                            ui.LandingGlow.Visible = showLanding
                        else
                            ui.Landing.Visible = false
                            ui.LandingGlow.Visible = false
                            for _, line in ipairs(ui.Lines) do
                                line.Glow.Visible = false
                                line.Core.Visible = false
                            end
                        end

                        local shouldShowRadius = (nadeType == _V[1]({38,71,99,133,169,195,233},186,31) and XCConfig.showMolotovRadius)
                            or (nadeType == _V[1]({216,137,66,245,166},206,183) and XCConfig.showSmokeRadius)
                        if shouldShowRadius then
                            if now >= ui.NextRadius or not ui.RadiusCenter then
                                ui.NextRadius = now + 0.08
                                local groundCast = Workspace:Raycast(part.Position + Vector3.new(0, 1, 0),
                                    Vector3.new(0, -60, 0), grenadeRayParams)
                                ui.RadiusCenter = groundCast and groundCast.Position or part.Position
                            end
                            local groundPosition = ui.RadiusCenter
                            local points = table.create(#ui.RadiusLines)
                            for index = 1, #ui.RadiusLines do
                                local angle = math.pi * 2 * ((index - 1) / #ui.RadiusLines)
                                local worldPoint = groundPosition + Vector3.new(
                                    math.cos(angle) * effectRadiusStuds, 0.16,
                                    math.sin(angle) * effectRadiusStuds
                                )
                                local point, visible = camera:WorldToViewportPoint(worldPoint)
                                points[index] = visible and point.Z > 0 and Vector2.new(point.X, point.Y) or nil
                            end
                            for index, line in ipairs(ui.RadiusLines) do
                                local a = points[index]
                                local b = points[index == #ui.RadiusLines and 1 or index + 1]
                                local alternating = index % 2 == 0
                                setXCGrenadeLine(line, a, b, nadeColor, alternating and 1.8 or 1.2,
                                    alternating and 0.2 or 0.48)
                            end
                        else
                            for _, line in ipairs(ui.RadiusLines) do line.Visible = false end
                        end
                    end
                end
            end
        end
    end

    for instance, ui in pairs(grenadePool) do
        if not activeGrenades[instance] or not instance.Parent then
            destroyXCGrenadeUI(ui)
            grenadePool[instance] = nil
        end
    end
end

function classifyXCGrenadeDanger(object)
    if not object or not object.Parent or isEntityCharacter(object) then return nil end
    local name = object.Name:lower()
    local grenadeAttribute = object:GetAttribute(_V[1]({15,103,135,189,221,13,59,81,145,202,239},155,45))
    if type(grenadeAttribute) == _V[1]({252,67,135,196,15,78},67,70) then name ..= _V[1]({218},9,177) .. grenadeAttribute:lower() end
    if name:find(_V[1]({114,229,96,213,72,214,68,188,44},134,121), 1, true) or name:find(_V[1]({3,214,177,134,89,44,32,238,198,150},183,217), 1, true)
        or name:find(_V[1]({30,114,214,30,128,226,55,148,235,64},77,91), 1, true) or name:find(_V[1]({64,85,114,137,158,181,225,239,6},178,27), 1, true)
        or name:find(_V[1]({79,207,103,244,111,244,113},98,134), 1, true) then
        return _V[1]({27,172,69,216,105},49,151), currentTheme.SmokeColor, 20, true
    end
    if name:find(_V[1]({174,160,152,122,126,98,80,54},89,239), 1, true) or name:find(_V[1]({16,204,142,58,237,193,111,39,215},241,185), 1, true)
        or name:find(_V[1]({247,231,231,203,201,186,180,180,158},138,247), 1, true) or name:find(_V[1]({119,47,226,155,86,7,196},84,182), 1, true)
        or name:find(_V[1]({75,229,111,6,164,47,201,86,252,152},77,149), 1, true) or name:find(_V[1]({40,208,129,38,219,118},21,170), 1, true)
        or name:find(_V[1]({203,148,76,27,214,174,102,40,226},162,195), 1, true) or name:find(_V[1]({246,59,106,152,214,253,46,87},98,50), 1, true) then
        return _V[1]({185,97,15,167},206,165), currentTheme.MolotovColor, 17, name:find(_V[1]({12,61,120,171},86,60), 1, true) ~= nil or name:find(_V[1]({249,152,71,218,135},221,166), 1, true) ~= nil
    end
    if name:find(_V[1]({99,142,168,223,249,24,60,110,140},216,37), 1, true) or name:find(_V[1]({75,52,12,1,217,179,158,140,98,78,36,10,238},2,227), 1, true) or name:find(_V[1]({242,95,187,52,144,175,93,207,41,153,243,93,197},37,103), 1, true) then
        return _V[1]({37,17,236,228,191},249,230), Color3.fromRGB(245, 235, 120), 10, false
    end
    if name:find(_V[1]({46,96,154,206,0,58,125,168,233,20,79,136},131,56), 1, true) or name:find(_V[1]({17,126,243,98,207,60,183,53,155,23,125,243,103},43,115), 1, true) or name:find(_V[1]({61,16,235,192,147,39,71,43,247,217,165,129,91},241,217), 1, true) then
        return _V[1]({1,40,87,128,167},129,45), currentTheme.SmokeColor, 20, false
    end
    if name:find(_V[1]({29,115,206,50,126,224,44,136,226},92,89), 1, true) or name:find(_V[1]({135,39,196,111,29,179,95,245,155,63},124,163), 1, true) or name:find(_V[1]({209,10,1,132,203,250,63,110,173,234},45,60), 1, true)
        or name:find(_V[1]({59,148,208,35},136,77), 1, true) or name == _V[1]({181,150,95,62,7,224,183},120,214) or name:find(_V[1]({131,34,169,70,205,100,249,152,46,191,78,221,111,20,157,52,193},136,148), 1, true) then
        return _V[1]({210,244},101,37), currentTheme.HEColor, 15, false
    end
    return nil
end

function getXCDangerPart(object)
    if object:IsA(_V[1]({207,54,144,202,253,86,175,249},69,72)) then return object end
    if object:IsA(_V[1]({239,215,146,89,38},220,198)) and object.PrimaryPart then return object.PrimaryPart end
    return object:FindFirstChildWhichIsA(_V[1]({255,255,242,197,145,131,117,88},220,225), true)
end

function createXCGrenadeDanger(object)
    if grenadeDangerPool[object] then return grenadeDangerPool[object] end
    local kind, color, radius, isZone = classifyXCGrenadeDanger(object)
    if not kind then return nil end

    local data = {
        Object = object,
        Kind = kind,
        Color = color,
        Radius = radius,
        IsZone = isZone,
        Center = nil,
        NextPhysics = 0,
        Segments = {},
    }
    for index = 1, 24 do
        local line = Instance.new(_V[1]({118,49,175,74,209},161,143), grenadeContainer)
        line.Name = _V[1]({218,187,140,73,11,220,141},210,196) .. kind .. _V[1]({100},196,65) .. index
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BorderSizePixel = 0
        line.BackgroundColor3 = color
        line.Visible = false
        line.ZIndex = 5
        data.Segments[index] = line
    end

    local label = Instance.new(_V[1]({46,96,148,177,170,224,2,38,78},185,33), grenadeContainer)
    label.Name = _V[1]({142,181,204,207,215,238,210,241,252,9,26,23},64,10) .. kind
    label.AnchorPoint = Vector2.new(0.5, 1)
    label.Size = UDim2.fromOffset(90, 20)
    label.BackgroundColor3 = Color3.fromRGB(8, 10, 12)
    label.BackgroundTransparency = 0.12
    label.BorderSizePixel = 0
    label.Text = _V[1]({229,230},194,2) .. kind
    label.TextColor3 = color
    label.TextSize = 9.5
    label.Font = Enum.Font.GothamBold
    label.Visible = false
    label.ZIndex = 6
    Instance.new(_V[1]({29,244,209,224,198,165,127,111},229,227), label).CornerRadius = UDim.new(0, 4)
    local labelStroke = Instance.new(_V[1]({255,108,239,137,0,118,235,94},49,121), label)
    labelStroke.Color = color
    labelStroke.Thickness = 1
    labelStroke.Transparency = 0.25
    local centerGlow = Instance.new(_V[1]({104,154,143,161,159},28,6), grenadeContainer)
    centerGlow.Name = _V[1]({193,227,245,243,246,8,222,5,19,30,20,38,0,42,50,63,44},120,5) .. kind
    centerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    centerGlow.Size = UDim2.fromOffset(18, 18)
    centerGlow.BackgroundColor3 = color
    centerGlow.BackgroundTransparency = 0.76
    centerGlow.BorderSizePixel = 0
    centerGlow.Rotation = 45
    centerGlow.Visible = false
    centerGlow.ZIndex = 4
    Instance.new(_V[1]({87,47,13,29,4,228,191,176},30,228), centerGlow).CornerRadius = UDim.new(0, 4)
    local centerDot = Instance.new(_V[1]({129,17,100,212,48},215,100), grenadeContainer)
    centerDot.Name = _V[1]({217,107,237,91,206,80,150,45,171,38,140,14,112},32,117) .. kind
    centerDot.AnchorPoint = Vector2.new(0.5, 0.5)
    centerDot.Size = UDim2.fromOffset(7, 7)
    centerDot.BackgroundColor3 = color
    centerDot.BorderSizePixel = 0
    centerDot.Rotation = 45
    centerDot.Visible = false
    centerDot.ZIndex = 7
    Instance.new(_V[1]({255,126,3,186,72,207,81,233},31,139), centerDot).CornerRadius = UDim.new(0, 2)
    data.Label = label
    data.LabelStroke = labelStroke
    data.CenterGlow = centerGlow
    data.CenterDot = centerDot
    grenadeDangerPool[object] = data
    return data
end

function destroyXCGrenadeDanger(data)
    if not data then return end
    for _, line in ipairs(data.Segments or {}) do pcall(function() line:Destroy() end) end
    pcall(function() data.Label:Destroy() end)
    pcall(function() data.CenterGlow:Destroy() end)
    pcall(function() data.CenterDot:Destroy() end)
end

function hideXCGrenadeDanger(data)
    for _, line in ipairs(data.Segments) do line.Visible = false end
    data.Label.Visible = false
    data.CenterGlow.Visible = false
    data.CenterDot.Visible = false
end

function computeXCZoneBounds(object, fallbackPart, fallbackRadius)
    local sumX, sumZ, minY, count = 0, 0, math.huge, 0
    local parts = {}
    if object:IsA(_V[1]({63,25,230,147,57,5,209,142},66,187)) then table.insert(parts, object) end
    for _, descendant in ipairs(object:GetDescendants()) do
        if descendant:IsA(_V[1]({75,196,48,124,193,44,151,243},175,90)) then table.insert(parts, descendant) end
    end
    for _, part in ipairs(parts) do
        if part.Transparency < 1 or part.CanQuery then
            sumX += part.Position.X
            sumZ += part.Position.Z
            minY = math.min(minY, part.Position.Y - part.Size.Y * 0.5)
            count += 1
        end
    end
    if count == 0 then return fallbackPart.Position, fallbackRadius end
    local center = Vector3.new(sumX / count, minY, sumZ / count)
    local radius = 0
    for _, part in ipairs(parts) do
        local horizontal = Vector2.new(part.Position.X - center.X, part.Position.Z - center.Z).Magnitude
        radius = math.max(radius, horizontal + math.max(part.Size.X, part.Size.Z) * 0.5)
    end
    return center, math.clamp(radius, 2, fallbackRadius * 1.35)
end

function updateXCGrenadeDangerPhysics(data, now)
    if now < data.NextPhysics then return end
    data.NextPhysics = now + 0.12
    local object = data.Object
    local part = getXCDangerPart(object)
    if not part then data.Center = nil return end

    if data.IsZone then
        data.Center, data.RenderRadius = computeXCZoneBounds(object, part, data.Radius)
        return
    end

    local position = part.Position
    local velocity = part.AssemblyLinearVelocity
    grenadeRayParams.FilterDescendantsInstances = {player.Character, object, camera}
    if velocity.Magnitude > 1.5 then
        local gravity = Vector3.new(0, -Workspace.Gravity, 0)
        local stepTime = 0.08
        for _ = 1, 32 do
            local nextPosition = position + velocity * stepTime + gravity * (0.5 * stepTime * stepTime)
            local result = Workspace:Raycast(position, nextPosition - position, grenadeRayParams)
            if result then
                position = result.Position
                if result.Normal.Y > 0.42 then break end
                velocity = (velocity - 2 * velocity:Dot(result.Normal) * result.Normal) * 0.42
                position += result.Normal * 0.08
            else
                position = nextPosition
            end
            velocity += gravity * stepTime
        end
    end
    local ground = Workspace:Raycast(position + Vector3.new(0, 3, 0), Vector3.new(0, -45, 0), grenadeRayParams)
    data.Center = ground and ground.Position or position
    data.RenderRadius = data.Radius
end

function renderXCGrenadeDangerZones()
    local now = os.clock()
    if not XCConfig.grenadeDangerZonesEnabled then
        grenadeDangerScanStarted = false
        for object, data in pairs(grenadeDangerPool) do
            if not object.Parent then destroyXCGrenadeDanger(data) grenadeDangerPool[object] = nil
            else hideXCGrenadeDanger(data) end
        end
        return
    end

    if not grenadeDangerScanStarted then
        grenadeDangerScanStarted = true
        task.spawn(function()
            local queue, index, visited = {Workspace}, 1, 0
            while queue[index] and xcSessionActive() and XCConfig.grenadeDangerZonesEnabled do
                local parent = queue[index]
                index += 1
                for _, child in ipairs(parent:GetChildren()) do
                    if classifyXCGrenadeDanger(child) then createXCGrenadeDanger(child) end
                    if child:IsA(_V[1]({143,116,45,225,158,103},141,188)) or child:IsA(_V[1]({108,251,93,203,63},178,109)) then table.insert(queue, child) end
                    visited += 1
                    if visited % 160 == 0 then task.wait() end
                end
            end
        end)
    end

    local camPosition = camera.CFrame.Position
    for object, data in pairs(grenadeDangerPool) do
        if not object.Parent or isEntityCharacter(object) then
            destroyXCGrenadeDanger(data)
            grenadeDangerPool[object] = nil
        else
            updateXCGrenadeDangerPhysics(data, now)
            local center = data.Center
            if not center or (center - camPosition).Magnitude > XCConfig.grenadeMaxDist then
                hideXCGrenadeDanger(data)
                continue
            end

            local radius = (data.RenderRadius or data.Radius) * (0.985 + math.sin(now * 4) * 0.015)
            local opacity = math.clamp(tonumber(XCConfig.grenadeDangerOpacity) or 0.82, 0.1, 1)
            local allPoints = {}
            for index = 1, #data.Segments do
                local angle = math.pi * 2 * ((index - 1) / #data.Segments)
                local worldPoint = center + Vector3.new(math.cos(angle) * radius, 0.18, math.sin(angle) * radius)
                local screenPoint, visible = camera:WorldToViewportPoint(worldPoint)
                allPoints[index] = visible and screenPoint.Z > 0 and Vector2.new(screenPoint.X, screenPoint.Y) or nil
            end
            for index, line in ipairs(data.Segments) do
                local a = allPoints[index]
                local b = allPoints[index == #data.Segments and 1 or index + 1]
                if a and b then
                    local gap = index % 3 == 0 and 0.13 or 0.045
                    setXCGrenadeLine(line, a:Lerp(b, gap), b:Lerp(a, gap), data.Color,
                        index % 3 == 0 and 2.2 or 1.55,
                        math.clamp(1 - opacity + (index % 3 == 0 and 0.08 or 0), 0, 0.9))
                else
                    line.Visible = false
                end
            end
            local centerScreen, centerVisible = camera:WorldToViewportPoint(center + Vector3.new(0, 0.35, 0))
            data.Label.TextColor3 = data.Color
            data.LabelStroke.Color = data.Color
            data.Label.Text = string.format(_V[1]({21,152,28,165,119,168,44,82,203,184,60,197,136,21},112,132), data.Kind,
                math.floor((center - camPosition).Magnitude + 0.5))
            data.Label.Position = UDim2.fromOffset(centerScreen.X, centerScreen.Y - 4)
            data.Label.Visible = centerVisible and centerScreen.Z > 0
            data.CenterDot.Position = UDim2.fromOffset(centerScreen.X, centerScreen.Y)
            data.CenterDot.BackgroundColor3 = data.Color
            data.CenterDot.Visible = centerVisible and centerScreen.Z > 0
            data.CenterGlow.Position = data.CenterDot.Position
            data.CenterGlow.BackgroundColor3 = data.Color
            data.CenterGlow.BackgroundTransparency = 0.72 + math.sin(now * 5) * 0.1
            data.CenterGlow.Visible = data.CenterDot.Visible
        end
    end
end

table.insert(connections, Workspace.DescendantAdded:Connect(function(object)
    if XCConfig.grenadeDangerZonesEnabled and classifyXCGrenadeDanger(object) then
        createXCGrenadeDanger(object)
    end
end))

function getXCSoundSource(sound)
    local cursor = sound.Parent
    local sourcePart
    while cursor and cursor ~= Workspace do
        if not sourcePart then
            if cursor:IsA(_V[1]({167,71,180,14,125,239,97,198,60,175},249,109)) then
                sourcePart = cursor
            elseif cursor:IsA(_V[1]({14,95,163,199,228,39,106,158},154,50)) then
                sourcePart = cursor
            end
        end
        if cursor:IsA(_V[1]({23,199,74,217,110},60,142)) then
            local owner = Players:GetPlayerFromCharacter(cursor)
            if owner then
                local position
                if sourcePart and sourcePart:IsA(_V[1]({199,243,236,210,205,203,201,186,188,187},141,249)) then position = sourcePart.WorldPosition
                elseif sourcePart and sourcePart:IsA(_V[1]({121,146,158,138,111,122,133,129},61,250)) then position = sourcePart.Position end
                local root = cursor:FindFirstChild(_V[1]({72,71,17,215,182,137,85,34,226,209,163,122,40,11,238,194},46,210)) or cursor:FindFirstChild(_V[1]({20,193,86,233,119},46,146)) or cursor:FindFirstChild(_V[1]({28,63,71,68,89,67,102,113,122,126},191,8))
                return owner, position or (root and root.Position), cursor
            end
        end
        for _, attributeName in ipairs({_V[1]({223,100,194,67,152,14},38,105), _V[1]({202,250,249,248,13},115,8), _V[1]({208,250,248,17,244,27},111,12), _V[1]({229,66,99,141,206,247,40,45,118},116,46)}) do
            local ownerValue = cursor:GetAttribute(attributeName)
            local owner
            if typeof(ownerValue) == _V[1]({69,123,145,163,161,191,197,216},235,17) and ownerValue:IsA(_V[1]({48,40,249,237,181,158},4,220)) then owner = ownerValue
            elseif type(ownerValue) == _V[1]({8,244,209,171,147,133},181,229) then owner = Players:GetPlayerByUserId(ownerValue) end
            if not owner and type(ownerValue) == _V[1]({119,211,44,126,222,50},169,91) then
                owner = Players:FindFirstChild(ownerValue)
                if not owner then
                    local numericId = tonumber(ownerValue)
                    if numericId then owner = Players:GetPlayerByUserId(numericId) end
                end
            end
            if owner then
                local character = owner.Character
                local root = character and (character:FindFirstChild(_V[1]({102,159,163,163,188,201,207,214,208,249,5,22,254,27,56,70},18,12)) or character:FindFirstChild(_V[1]({178,42,138,232,65},1,93)))
                local position = sourcePart and (sourcePart:IsA(_V[1]({67,178,238,23,85,150,215,11,80,146},198,60)) and sourcePart.WorldPosition or sourcePart.Position)
                return owner, position or (root and root.Position), character
            end
        end
        cursor = cursor.Parent
    end

    local position = sourcePart and (sourcePart:IsA(_V[1]({28,61,43,6,246,233,220,194,185,173},237,238)) and sourcePart.WorldPosition or sourcePart.Position)
    if position and classifyXCSound(sound) ~= _V[1]({154,255,110,208,47},222,105) then
        local closestPlayer, closestCharacter, closestDistance = nil, nil, 5
        for _, candidate in ipairs(Players:GetPlayers()) do
            local character = candidate.Character
            local root = character and (character:FindFirstChild(_V[1]({105,239,64,141,243,77,160,244,59,177,10,104,157,7,113,204},200,89)) or character:FindFirstChild(_V[1]({7,157,27,151,14},56,123)))
            if root and isTargetEnemy(candidate, character) then
                local distance = (root.Position - position).Magnitude
                if distance < closestDistance then
                    closestPlayer, closestCharacter, closestDistance = candidate, character, distance
                end
            end
        end
        if closestPlayer then return closestPlayer, position, closestCharacter end
    end
    return nil
end

function classifyXCSound(sound)
    local name = sound.Name:lower()
    if name:find(_V[1]({216,103,237,120},236,134), 1, true) or name:find(_V[1]({148,198,232,36},240,49), 1, true)
        or name:find(_V[1]({65,158,28,142},87,115), 1, true) or name:find(_V[1]({212,243,8},70,28), 1, true) then return _V[1]({20,171,50,211},43,150) end
    if name:find(_V[1]({105,160,233,43,114},180,66), 1, true) or name:find(_V[1]({54,194,96,252},44,151), 1, true)
        or name:find(_V[1]({68,197,76,189},96,126), 1, true) or name:find(_V[1]({190,228,245},63,24), 1, true) then return _V[1]({28,185,104,21},33,168) end
    if name:find(_V[1]({215,189,183,173,146,136},114,243), 1, true) or name:find(_V[1]({36,130,242},77,106), 1, true) then return _V[1]({100,176,16,108,183,19},185,89) end
    if name:find(_V[1]({134,153,153,164},20,8), 1, true) or name:find(_V[1]({43,52,85,95},171,20), 1, true) then return _V[1]({217,100,244,108},3,137) end
    return _V[1]({160,27,160,24,141},206,127)
end

function destroyXCSoundPulse(pulse)
    pcall(function() pulse.Root:Destroy() end)
end

function createXCSoundPulse(position, category)
    if #soundEspPulses >= 24 then
        destroyXCSoundPulse(table.remove(soundEspPulses, 1))
    end

    local root = Instance.new(_V[1]({54,59,3,232,185},23,217), overlayContainer)
    root.Name = _V[1]({151,246,63,123,180,216,41,105,187},1,67) .. category
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.Size = UDim2.fromOffset(1, 1)
    root.BackgroundTransparency = 1
    root.Visible = false
    root.ZIndex = 20

    local ring = Instance.new(_V[1]({15,231,130,58,222},29,172), root)
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.Position = UDim2.fromScale(0.5, 0.5)
    ring.BackgroundTransparency = 1
    ring.BorderSizePixel = 0
    ring.ZIndex = 20
    Instance.new(_V[1]({107,33,221,203,144,78,7,214},84,194), ring).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new(_V[1]({219,4,67,153,204,254,47,94},81,53), ring)
    stroke.Color = currentTheme.Accent
    stroke.Thickness = 2
    stroke.Transparency = 0

    local dot = Instance.new(_V[1]({210,240,209,207,185},154,242), root)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.5, 0.5)
    dot.Size = UDim2.fromOffset(5, 5)
    dot.BackgroundColor3 = currentTheme.Accent
    dot.BorderSizePixel = 0
    dot.ZIndex = 21
    Instance.new(_V[1]({199,56,175,88,216,81,197,79},245,125), dot).CornerRadius = UDim.new(1, 0)

    local label = Instance.new(_V[1]({164,88,14,173,40,224,132,42,212},173,163), root)
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.Position = UDim2.fromOffset(0, 11)
    label.Size = UDim2.fromOffset(58, 14)
    label.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
    label.BackgroundTransparency = 0.28
    label.BorderSizePixel = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 8
    label.Text = category
    label.TextColor3 = currentTheme.Accent
    label.ZIndex = 21
    Instance.new(_V[1]({66,154,248,136,239,79,170,27},137,100), label).CornerRadius = UDim.new(0, 3)

    table.insert(soundEspPulses, {
        Root = root,
        Ring = ring,
        Stroke = stroke,
        Dot = dot,
        Label = label,
        Position = position,
        Created = os.clock(),
        Duration = math.clamp(tonumber(XCConfig.soundEspDuration) or 1.15, 0.35, 3),
    })
end

function triggerXCSoundPosition(sound)
    if not XCConfig.soundPositionEspEnabled or not sound or not sound.Parent then return end
    local owner, position, character = getXCSoundSource(sound)
    if not owner or not position or not isTargetEnemy(owner, character) then return end
    local cam = Workspace.CurrentCamera or camera
    if not cam or (position - cam.CFrame.Position).Magnitude > (tonumber(XCConfig.soundEspMaxDist) or 1200) then return end
    local now = os.clock()
    local record = soundEspTracked[sound]
    if record and now - (record.LastPulse or 0) < 0.09 then return end
    if not record then record = {} soundEspTracked[sound] = record end
    record.LastPulse = now
    createXCSoundPulse(position, classifyXCSound(sound))
end

function trackXCSound(sound)
    if not sound:IsA(_V[1]({28,144,238,63,141},113,88)) then return end
    local record = soundEspTracked[sound]
    if record and record.Hooked then return end
    record = record or {}
    record.Hooked = true
    soundEspTracked[sound] = record
    pcall(function()
        table.insert(connections, sound.Played:Connect(function()
            triggerXCSoundPosition(sound)
        end))
    end)
    table.insert(connections, sound:GetPropertyChangedSignal(_V[1]({106,95,45,30,231,197,151},65,217)):Connect(function()
        if sound.Playing then triggerXCSoundPosition(sound) end
    end))
end

function hookXCSoundCharacter(plr, character)
    if plr == player or not character then return end
    for _, object in ipairs(character:GetDescendants()) do
        if object:IsA(_V[1]({216,234,230,213,193},143,246)) then trackXCSound(object) end
    end
    table.insert(connections, character.DescendantAdded:Connect(function(object)
        if object:IsA(_V[1]({178,7,70,120,167},38,57)) then trackXCSound(object) end
    end))
end

function hookXCSoundPlayer(plr)
    if plr == player then return end
    if plr.Character then hookXCSoundCharacter(plr, plr.Character) end
    table.insert(connections, plr.CharacterAdded:Connect(function(character)
        hookXCSoundCharacter(plr, character)
    end))
end

function renderXCSoundPositionEsp()
    local now = os.clock()
    for index = #soundEspPulses, 1, -1 do
        local pulse = soundEspPulses[index]
        local alpha = (now - pulse.Created) / pulse.Duration
        if not XCConfig.soundPositionEspEnabled or alpha >= 1 then
            destroyXCSoundPulse(pulse)
            table.remove(soundEspPulses, index)
        else
            local point, visible = camera:WorldToViewportPoint(pulse.Position)
            if visible and point.Z > 0 then
                local size = 12 + alpha * 34
                pulse.Root.Position = UDim2.fromOffset(point.X, point.Y)
                pulse.Ring.Size = UDim2.fromOffset(size, size)
                pulse.Stroke.Color = currentTheme.Accent
                pulse.Stroke.Transparency = math.clamp(alpha, 0, 1)
                pulse.Dot.BackgroundColor3 = currentTheme.Accent
                pulse.Dot.BackgroundTransparency = math.clamp(alpha * 0.8, 0, 1)
                pulse.Label.TextColor3 = currentTheme.Accent
                pulse.Label.TextTransparency = math.clamp(alpha, 0, 1)
                pulse.Label.BackgroundTransparency = 0.28 + alpha * 0.72
                pulse.Root.Visible = true
            else
                pulse.Root.Visible = false
            end
        end
    end
end

for _, otherPlayer in ipairs(Players:GetPlayers()) do hookXCSoundPlayer(otherPlayer) end
table.insert(connections, Players.PlayerAdded:Connect(hookXCSoundPlayer))
table.insert(connections, Workspace.DescendantAdded:Connect(function(object)
    if object:IsA(_V[1]({37,199,83,210,78},76,134)) then trackXCSound(object) end
end))

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

function getPingLatency()
    local ping = 0.03
    pcall(function()
        local serverStats = Stats:FindFirstChild(_V[1]({25,151,13,119,214,64,160},100,103)) and Stats.Network:FindFirstChild(_V[1]({47,14,232,185,117,79,253,235,165,133,81,244,236,170,127},15,205))
        if serverStats and serverStats:FindFirstChild(_V[1]({45,60,65,32,209,243,254,245,224},247,242)) then
            ping = (serverStats[_V[1]({226,223,210,159,62,78,71,44,5},190,224)]:GetValue() / 1000)
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
    local myHrp = myChar and myChar:FindFirstChild(_V[1]({152,31,113,191,38,129,213,42,114,233,67,162,216,67,174,10},246,90))
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
        local priorityName = tostring(XCConfig.priorityPlayerName or _V[1]({57,250,153,48},75,160))
        local currentPlayer = currentAimTarget.Player
        local priorityAllowsSticky = priorityName == _V[1]({104,123,108,85},40,242)
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
            local hum = char:FindFirstChildOfClass(_V[1]({143,242,32,74,141,196,244,37},17,54))
            if isEntityAlive(char, hum) then
                local hitPart = getTargetHitbox(char)
                if hitPart then
                    local aimPos = getKinematicAimPosition(hitPart)
                    local toTarget = (aimPos - camPos).Unit
                    local angle = math.acos(math.clamp(camLook:Dot(toTarget), -1, 1))

                    if angle <= maxAngleRad then
                        local dist = (aimPos - camPos).Magnitude
                        local score = (angle * 0.7) + ((dist / 1000) * 0.3)
                        local priorityName = tostring(XCConfig.priorityPlayerName or _V[1]({66,171,242,49},172,72))
                        if priorityName ~= _V[1]({100,25,172,55},130,148)
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
            local hum = char:FindFirstChildOfClass(_V[1]({38,29,223,157,116,63,3,200},20,202))
            if isEntityAlive(char, hum) then
                local hitPart = getTargetHitbox(char)
                if hitPart then
                    if XCConfig.wallbangEnabled or isVisibleThroughWalls(hitPart, char) then
                        local aimPos = getKinematicAimPosition(hitPart)
                        local score = math.huge

                        if XCConfig.rageTargetMode == _V[1]({193,154,88,13,174,111,24,206},201,180) then
                            score = (aimPos - camPos).Magnitude
                        elseif XCConfig.rageTargetMode == _V[1]({175,169,130,106,79,32},138,221) then
                            score = hum.Health
                        elseif XCConfig.rageTargetMode == _V[1]({28,55,80},196,18) then
                            local direction = (aimPos - camPos).Unit
                            score = math.acos(math.clamp(camLook:Dot(direction), -1, 1))
                        elseif XCConfig.rageTargetMode == _V[1]({61,129,154,194,231,0,45,84},203,34) then
                            local priorityName = tostring(XCConfig.priorityPlayerName or _V[1]({183,244,15,34},77,28))
                            local isPriority = priorityName ~= _V[1]({87,214,51,136},171,94)
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

local triggerRayParams = RaycastParams.new()
triggerRayParams.FilterType = Enum.RaycastFilterType.Exclude
triggerRayParams.IgnoreWater = true

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
    [_V[1]({76,15,209,124,70,162,121,94,10,185,118},68,181)] = 0.25,
}

function triggerIsCharacterPart(part, targetModel)
    return part and targetModel and part:IsDescendantOf(targetModel)
end

function triggerFindTargetAlongRay(origin, direction, targetModel)
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
        if not part:IsA(_V[1]({193,154,102,18,183,130,77,9},197,186)) then
            table.insert(filter, part)
            params.FilterDescendantsInstances = filter
            currentOrigin = hit.Position + remaining.Unit * 0.01
            remaining = direction.Unit * math.max(0, (origin + direction.Unit * math.min(direction.Magnitude, 1000) - currentOrigin).Magnitude)
            continue
        end

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
        local key = variant ~= _V[1]({},232,10) and variant or part.Material

        if limit then
            accumulated[key] = (accumulated[key] or 0) + thickness
            if accumulated[key] > limit then
                return nil
            end
        else
            limit = triggerMaterialLimits[part.Material]
            if limit == nil then

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

function triggerbotFire(vp)
    pcall(function()
        local myChar = player.Character
        local equippedTool = myChar and myChar:FindFirstChildOfClass(_V[1]({104,107,83,56},44,232))
        if equippedTool then
            equippedTool:Activate()
            return
        end

        local nativeFired = false
        pcall(function()
            local controllers = ReplicatedStorage:FindFirstChild(_V[1]({5,168,30,155,16,132,248,111,223,99,219},75,119))
            local scriptObject = controllers and controllers:FindFirstChild(_V[1]({133,255,92,160,254,89,169,1,93,124,253,81,172,255,81,163,248,70,168},231,85))
            local inventory = scriptObject and require(scriptObject)
            local getter = inventory and inventory.peekCurrentEquippedForMovement
            local weapon = type(getter) == _V[1]({137,224,33,94,183,244,66,137},219,72) and getter() or nil
            if weapon and type(weapon.shoot) == _V[1]({77,55,11,219,199,151,120,82},12,219) then
                weapon:shoot()
                nativeFired = true
            end
        end)
        if nativeFired then return end

        if VirtualInputManager and not UserInputService.TouchEnabled then
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

    if XCConfig.triggerbotScopedOnly then
        local nativeScope = findSniperScope()
        if not ((nativeScope and nativeScope.Visible) or cam.FieldOfView < 68) then return end
    end

    local now = tick()
    local delay = math.clamp(tonumber(XCConfig.triggerbotDelay) or 0.075, 0.01, 0.5)
    if (now - lastTriggerTick) < delay then return end

    local vp = cam.ViewportSize
    local origin = cam.CFrame.Position
    local rayDirection = cam.CFrame.LookVector * 1000

    triggerRayParams.FilterDescendantsInstances = {player.Character}
    local first = Workspace:Raycast(origin, rayDirection, triggerRayParams)
    if not first or not first.Instance then return end

    local firstModel = first.Instance:FindFirstAncestorOfClass(_V[1]({1,141,236,87,200},74,106))
    local firstPlayer = firstModel and Players:GetPlayerFromCharacter(firstModel)

    if firstPlayer and firstPlayer ~= player then
        local _, onScreen = cam:WorldToViewportPoint(first.Instance.Position)
        if not onScreen then return end
        if firstModel:GetAttribute(_V[1]({106,237,75,176},196,98)) or firstModel:GetAttribute(_V[1]({144,227,25,58,109,144,196,235,35,74},25,46)) then return end
        local hum = firstModel:FindFirstChildOfClass(_V[1]({55,178,248,58,149,228,44,117},161,78))
        if hum and hum.Health <= 0 then return end
        if not isTargetEnemy(firstPlayer, firstModel) then return end
        if XCConfig.triggerbotHeadOnly and first.Instance.Name ~= _V[1]({121,209,8,70},246,59) then return end

        lastTriggerTick = now
        if triggerbotMobileAutoFire then triggerbotFire(vp) end
        return
    end

    local bestTarget, bestScreenDistance = nil, math.huge
    for _, hitPlayer in ipairs(Players:GetPlayers()) do
        if hitPlayer ~= player and isTargetEnemy(hitPlayer, hitPlayer.Character) then
            local char = hitPlayer.Character
            local hum = char and char:FindFirstChildOfClass(_V[1]({43,8,176,84,17,194,108,23},51,176))
            if char and hum and hum.Health > 0 and not char:GetAttribute(_V[1]({159,141,86,38},142,205)) and not char:GetAttribute(_V[1]({49,104,130,135,158,165,189,200,228,239},214,18)) then
                local targetPart = char:FindFirstChild(_V[1]({107,92,44,3},79,212)) or char:FindFirstChild(_V[1]({215,206,170,123,100,34,25,248,213,173},166,220)) or char:FindFirstChild(_V[1]({104,231,49,119,214,41,117,194,2,113,195,26,72,171,14,98},206,82))
                if targetPart then
                    if not XCConfig.triggerbotHeadOnly or targetPart.Name == _V[1]({43,140,204,19},159,68) then
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

function hideXCSkeleton(esp)
    if not esp or not esp.SkeletonLines then return end
    for _, line in ipairs(esp.SkeletonLines) do line.Visible = false end
end

function setXCSkeletonLine(line, from, to, color, alpha)
    local delta = to - from
    local length = delta.Magnitude
    if length < 0.5 then line.Visible = false return end
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Position = UDim2.fromOffset((from.X + to.X) * 0.5, (from.Y + to.Y) * 0.5)
    line.Size = UDim2.fromOffset(length, math.clamp(tonumber(XCConfig.skeletonThickness) or 1.5, 1, 4))
    line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    line.BackgroundColor3 = color
    line.BackgroundTransparency = 1 - alpha
    line.Visible = true
end

function renderXCSkeleton(esp, char, color, distance)
    if not XCConfig.skeletonEspEnabled or not char then hideXCSkeleton(esp) return end
    local head = char:FindFirstChild(_V[1]({245,220,162,111},227,202))
    local torso = char:FindFirstChild(_V[1]({108,28,177,59,221,84,4,156,50,195},130,149)) or char:FindFirstChild(_V[1]({37,235,153,69,236},38,171))
    local waistPart = char:FindFirstChild(_V[1]({228,34,69,78,118,115,169,199,227,250},125,27)) or torso
    if not head or not torso or not waistPart then hideXCSkeleton(esp) return end

    local leftArm = char:FindFirstChild(_V[1]({219,72,157,255,52,163,247,64,161,196,73,152},59,84)) or char:FindFirstChild(_V[1]({86,105,100,108,18,45,88,77},16,250))
    local rightArm = char:FindFirstChild(_V[1]({149,80,242,151,71,204,139,47,200,121,236,193,96},159,164)) or char:FindFirstChild(_V[1]({182,13,75,140,216,196,37,150,209},36,64))
    local leftHand = char:FindFirstChild(_V[1]({142,67,224,138,250,175,88,234},166,156)) or char:FindFirstChild(_V[1]({79,59,15,240,155,145,108,45,13,175,179,129},48,211)) or leftArm
    local rightHand = char:FindFirstChild(_V[1]({152,114,51,247,198,93,57,9,194},131,195)) or char:FindFirstChild(_V[1]({29,61,68,78,99,68,112,129,120,142,102,160,164},194,9)) or rightArm
    local leftLeg = char:FindFirstChild(_V[1]({20,92,140,201,217,35,82,118,178,187,3,52},153,47)) or char:FindFirstChild(_V[1]({137,218,19,89,61,161,242,44},5,56))
    local rightLeg = char:FindFirstChild(_V[1]({83,87,66,48,41,247,255,236,206,200,143,149,132},20,237)) or char:FindFirstChild(_V[1]({190,252,33,73,124,79,162,226,11},69,39))
    local leftFoot = char:FindFirstChild(_V[1]({222,148,50,221,76,18,175,81},245,157)) or char:FindFirstChild(_V[1]({247,21,27,46,11,51,64,51,69,36,66,73},166,5)) or leftLeg
    local rightFoot = char:FindFirstChild(_V[1]({110,56,233,157,92,225,189,112,40},105,179)) or char:FindFirstChild(_V[1]({47,8,200,139,89,243,216,162,82,33,189,152,92},27,194)) or rightLeg

    local points = {
        Head = head.Position,
        Neck = torso.CFrame:PointToWorldSpace(Vector3.new(0, torso.Size.Y * 0.42, 0)),
        Waist = waistPart.CFrame:PointToWorldSpace(Vector3.new(0, -waistPart.Size.Y * 0.25, 0)),
        LeftShoulder = leftArm and leftArm.CFrame:PointToWorldSpace(Vector3.new(0, leftArm.Size.Y * 0.4, 0)),
        RightShoulder = rightArm and rightArm.CFrame:PointToWorldSpace(Vector3.new(0, rightArm.Size.Y * 0.4, 0)),
        LeftHand = leftHand and leftHand.CFrame:PointToWorldSpace(Vector3.new(0, -leftHand.Size.Y * 0.45, 0)),
        RightHand = rightHand and rightHand.CFrame:PointToWorldSpace(Vector3.new(0, -rightHand.Size.Y * 0.45, 0)),
        LeftHip = leftLeg and leftLeg.CFrame:PointToWorldSpace(Vector3.new(0, leftLeg.Size.Y * 0.4, 0)),
        RightHip = rightLeg and rightLeg.CFrame:PointToWorldSpace(Vector3.new(0, rightLeg.Size.Y * 0.4, 0)),
        LeftFoot = leftFoot and leftFoot.CFrame:PointToWorldSpace(Vector3.new(0, -leftFoot.Size.Y * 0.45, 0)),
        RightFoot = rightFoot and rightFoot.CFrame:PointToWorldSpace(Vector3.new(0, -rightFoot.Size.Y * 0.45, 0)),
    }
    local alpha = XCConfig.skeletonDistanceFade
        and math.clamp(1 - distance / math.max(1, XCConfig.espMaxDist), 0.18, 1) or 1
    for index, edge in ipairs(XCFeatureState.skeletonEdges) do
        local line = esp.SkeletonLines[index]
        local a, b = points[edge[1]], points[edge[2]]
        if a and b then
            local pa, va = camera:WorldToViewportPoint(a)
            local pb, vb = camera:WorldToViewportPoint(b)
            if va and vb and pa.Z > 0 and pb.Z > 0 then
                setXCSkeletonLine(line, Vector2.new(pa.X, pa.Y), Vector2.new(pb.X, pb.Y), color, alpha)
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

function getOrCreateScreenEsp(plr)
    if screenEspCache[plr] then return screenEspCache[plr] end

    local box = Instance.new(_V[1]({230,211,131,80,9},223,193), overlayContainer)
    box.Name = _V[1]({105,206,15,46},239,56) .. plr.Name
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 7

    local boxOutline = Instance.new(_V[1]({204,62,115,197,3},64,70), overlayContainer)
    boxOutline.Name = _V[1]({112,143,138,83,107,92,70,53,44,21,1},60,242) .. plr.Name
    boxOutline.BackgroundTransparency = 1
    boxOutline.BorderSizePixel = 0
    boxOutline.Visible = false
    boxOutline.ZIndex = 6

    local outlineStroke = Instance.new(_V[1]({107,243,145,70,216,105,249,135},130,148), boxOutline)
    outlineStroke.Color = Color3.fromRGB(5, 7, 9)
    outlineStroke.Thickness = XCConfig.boxThickness + 2
    outlineStroke.Transparency = 0.12
    outlineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local stroke = Instance.new(_V[1]({120,152,206,27,69,110,150,188},247,44), box)
    stroke.Color = currentTheme.Enemy_Accent
    stroke.Thickness = XCConfig.boxThickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local healthBarBg = Instance.new(_V[1]({203,178,92,35,214},202,187), overlayContainer)
    healthBarBg.Name = _V[1]({80,181,249,76,156,216,250,103,167},192,72) .. plr.Name
    healthBarBg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Visible = false
    Instance.new(_V[1]({56,251,196,191,145,92,34,254},20,207), healthBarBg).CornerRadius = UDim.new(0, 2)
    local hbStroke = Instance.new(_V[1]({180,70,238,173,73,228,126,22},193,158), healthBarBg)
    hbStroke.Color = Color3.fromRGB(35, 38, 45)
    hbStroke.Thickness = 0.8

    local healthBarFill = Instance.new(_V[1]({128,155,121,116,91},75,239), healthBarBg)
    healthBarFill.Name = _V[1]({28,29,254,220},248,222)
    healthBarFill.AnchorPoint = Vector2.new(0, 1)
    healthBarFill.Position = UDim2.new(0, 0, 1, 0)
    healthBarFill.Size = UDim2.new(1, 0, 1, 0)
    healthBarFill.BackgroundColor3 = currentTheme.HealthHigh
    healthBarFill.BorderSizePixel = 0
    Instance.new(_V[1]({39,100,167,28,104,173,237,67},137,73), healthBarFill).CornerRadius = UDim.new(0, 2)
    local healthGradient = Instance.new(_V[1]({223,47,137,16,91,186,27,115,216,58},46,92), healthBarFill)
    healthGradient.Name = _V[1]({253,220,154,103,49,231,136,117,38,235,178,112,59,3},243,194)
    healthGradient.Rotation = 90
    healthGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(152, 204, 0)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(210, 196, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 65, 55)),
    })

    local weaponCard = Instance.new(_V[1]({12,108,143,207,251},146,52), overlayContainer)
    weaponCard.Name = _V[1]({174,96,0,179,86,249,120,54,230,137,30},179,164) .. plr.Name
    weaponCard.AnchorPoint = Vector2.new(0.5, 0)
    weaponCard.Size = UDim2.fromOffset(36, 15)
    weaponCard.BackgroundColor3 = Color3.fromRGB(5, 6, 7)
    weaponCard.BackgroundTransparency = 1
    weaponCard.BorderSizePixel = 0
    weaponCard.ClipsDescendants = true
    weaponCard.Visible = false
    weaponCard.ZIndex = 8
    Instance.new(_V[1]({132,146,166,236,9,31,48,87},21,26), weaponCard).CornerRadius = UDim.new(0, 3)
    local weaponCardStroke = Instance.new(_V[1]({232,168,126,107,53,254,198,140},199,204), weaponCard)
    weaponCardStroke.Color = currentTheme.Enemy_Accent
    weaponCardStroke.Thickness = 1
    weaponCardStroke.Transparency = 1
    weaponCardStroke.Enabled = false

    local weaponImageShadow = Instance.new(_V[1]({56,180,0,94,180,243,96,185,20,115},151,88), weaponCard)
    weaponImageShadow.Name = _V[1]({195,30,73,134,187,224,44,92,150,216,23},67,55)
    weaponImageShadow.Size = UDim2.new(1, -4, 1, -4)
    weaponImageShadow.Position = UDim2.fromOffset(3, 3)
    weaponImageShadow.BackgroundTransparency = 1
    weaponImageShadow.ScaleType = Enum.ScaleType.Fit
    weaponImageShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    weaponImageShadow.ImageTransparency = 0.28
    weaponImageShadow.Visible = false
    weaponImageShadow.ZIndex = 8

    local weaponImage = Instance.new(_V[1]({84,159,186,231,12,26,86,126,168,214},228,39), weaponCard)
    weaponImage.Name = _V[1]({29,48,19,8,245},229,239)
    weaponImage.Size = UDim2.new(1, -4, 1, -4)
    weaponImage.Position = UDim2.fromOffset(2, 1)
    weaponImage.BackgroundTransparency = 1
    weaponImage.ScaleType = Enum.ScaleType.Fit
    weaponImage.ImageColor3 = currentTheme.Enemy_Accent
    weaponImage.Visible = false
    weaponImage.ZIndex = 10

    local weaponViewport = Instance.new(_V[1]({79,139,176,235,13,53,97,140,135,220,244,41,74},208,41), weaponCard)
    weaponViewport.Name = _V[1]({191,72,186,66,177,38,159,23},243,118)
    weaponViewport.Size = UDim2.new(1, -4, 1, -4)
    weaponViewport.Position = UDim2.fromOffset(2, 1)
    weaponViewport.BackgroundTransparency = 1
    weaponViewport.Ambient = Color3.fromRGB(72, 96, 0)
    weaponViewport.LightColor = currentTheme.Enemy_Accent
    weaponViewport.LightDirection = Vector3.new(-1, -0.45, -1)
    weaponViewport.Visible = false
    weaponViewport.ZIndex = 10
    local weaponWorld = Instance.new(_V[1]({184,129,53,224,137,35,246,156,78,6},176,177), weaponViewport)
    local weaponCamera = Instance.new(_V[1]({20,60,82,84,107,100},199,10), weaponViewport)
    weaponViewport.CurrentCamera = weaponCamera

    local corners = {}
    for i = 1, 4 do
        local hLine = Instance.new(_V[1]({100,168,175,211,227},6,24), overlayContainer)
        hLine.Name = _V[1]({102,158,173,181,184,209,179,214},23,12) .. plr.Name .. _V[1]({83},14,230) .. i
        hLine.BackgroundColor3 = currentTheme.Enemy_Accent
        hLine.BorderSizePixel = 0
        hLine.Visible = false
        hLine.ZIndex = 7
        local hOutline = Instance.new(_V[1]({243,38,111,207,12,72,131,188},95,63), hLine)
        hOutline.Color = Color3.fromRGB(5, 7, 9)
        hOutline.Thickness = 1
        hOutline.Transparency = 0.1

        local vLine = Instance.new(_V[1]({250,137,219,74,165},81,99), overlayContainer)
        vLine.Name = _V[1]({94,222,53,133,208,49,105,198},199,84) .. plr.Name .. _V[1]({1},97,65) .. i
        vLine.BackgroundColor3 = currentTheme.Enemy_Accent
        vLine.BorderSizePixel = 0
        vLine.Visible = false
        vLine.ZIndex = 7
        local vOutline = Instance.new(_V[1]({179,56,211,133,20,162,47,186},205,145), vLine)
        vOutline.Color = Color3.fromRGB(5, 7, 9)
        vOutline.Thickness = 1
        vOutline.Transparency = 0.1

        table.insert(corners, {H = hLine, V = vLine, HOutline = hOutline, VOutline = vOutline})
    end

    local tagCard = Instance.new(_V[1]({71,162,192,251,34},210,47), overlayContainer)
    tagCard.Name = _V[1]({233,96,208,22,158,25,117,218},43,106) .. plr.Name
    tagCard.AnchorPoint = Vector2.new(0.5, 1)
    tagCard.Size = UDim2.new(0, 0, 0, 16)
    tagCard.AutomaticSize = Enum.AutomaticSize.X
    tagCard.BackgroundColor3 = currentTheme.Sidebar
    tagCard.BackgroundTransparency = XCConfig.tagTransparency
    tagCard.BorderSizePixel = 0
    tagCard.Visible = false

    Instance.new(_V[1]({120,204,38,178,21,113,200,53},195,96), tagCard).CornerRadius = UDim.new(0, 4)
    local cardStroke = Instance.new(_V[1]({59,37,37,60,48,35,21,5},240,246), tagCard)
    cardStroke.Color = currentTheme.Border
    cardStroke.Thickness = 0.8
    cardStroke.Enabled = false

    local pad = Instance.new(_V[1]({172,19,141,17,135,250,114,234,86},228,115), tagCard)
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 6)

    local tagLabel = Instance.new(_V[1]({187,29,129,206,247,93,175,3,91},22,81), tagCard)
    tagLabel.AutomaticSize = Enum.AutomaticSize.X
    tagLabel.Size = UDim2.new(0, 0, 1, 0)
    tagLabel.BackgroundTransparency = 1
    tagLabel.TextColor3 = currentTheme.NametagTextColor
    tagLabel.TextSize = XCConfig.espTextSize
    tagLabel.Font = Enum.Font.GothamBold

    local skeletonLines = {}
    for index = 1, #XCFeatureState.skeletonEdges do
        local line = Instance.new(_V[1]({232,40,43,75,87},142,20), overlayContainer)
        line.Name = _V[1]({233,96,185,31,119,229,63,157,237},55,95) .. plr.Name .. _V[1]({215},19,101) .. index
        line.BorderSizePixel = 0
        line.Visible = false
        skeletonLines[index] = line
    end

    local data = {
        Box = box,
        BoxStroke = stroke,
        BoxOutline = boxOutline,
        BoxOutlineStroke = outlineStroke,
        HealthBarBg = healthBarBg,
        HealthBarFill = healthBarFill,
        WeaponCard = weaponCard,
        WeaponCardStroke = weaponCardStroke,
        WeaponImageShadow = weaponImageShadow,
        WeaponImage = weaponImage,
        WeaponViewport = weaponViewport,
        WeaponWorld = weaponWorld,
        WeaponCamera = weaponCamera,
        WeaponRaw = nil,
        WeaponName = nil,
        WeaponReady = false,
        Corners = corners,
        TagCard = tagCard,
        TagCardStroke = cardStroke,
        TagLabel = tagLabel,
        SkeletonLines = skeletonLines,
        LastText = _V[1]({},9,224),
        Character = nil,
        BodyParts = nil,
        BodyBounds = nil,
        NextBoundsRefresh = 0,
        SmoothRect = nil,
    }
    screenEspCache[plr] = data
    return data
end

function getXCEquippedWeapon(plr, char)
    local raw = plr:GetAttribute(_V[1]({62,71,27,242,188,156,121,33,36,255,202,168,127,75,33},36,215))
    local weaponName
    if type(raw) == _V[1]({17,207,138,62,0,182},225,189) and raw ~= _V[1]({},53,245) then
        pcall(function()
            local decoded = HttpService:JSONDecode(raw)
            if type(decoded) == _V[1]({251,65,155,254,80},46,89) then
                weaponName = decoded.Name or decoded.Weapon or decoded.ItemName
            end
        end)
    end
    local tool = char and char:FindFirstChildOfClass(_V[1]({10,111,185,0},108,74))
    if type(weaponName) ~= _V[1]({165,68,224,117,24,175},148,158) or weaponName == _V[1]({},161,64) then
        weaponName = tool and tool.Name or nil
    end
    return weaponName, tool, raw
end

function clearXCWeaponPreview(esp)
    esp.WeaponImage.Image = _V[1]({},233,158)
    esp.WeaponImage.Visible = false
    esp.WeaponImageShadow.Image = _V[1]({},54,241)
    esp.WeaponImageShadow.Visible = false
    esp.WeaponViewport.Visible = false
    esp.WeaponWorld:ClearAllChildren()
    esp.WeaponReady = false
end

function findXCWeaponAsset(weaponName)
    if type(weaponName) ~= _V[1]({188,17,99,174,7,84},245,84) or weaponName == _V[1]({},73,180) then return nil end
    local assets = ReplicatedStorage:FindFirstChild(_V[1]({247,198,99,242,158,58},25,157))
    local weapons = assets and assets:FindFirstChild(_V[1]({93,248,129,29,169,53,199},121,141))
    if not weapons then return nil end
    local direct = weapons:FindFirstChild(weaponName)
    if direct then return direct end
    local normalized = weaponName:lower():gsub(_V[1]({79,215,35,250,101},111,133), _V[1]({},230,85))
    for _, candidate in ipairs(weapons:GetChildren()) do
        if candidate.Name:lower():gsub(_V[1]({52,104,96,227,250},168,49), _V[1]({},167,129)) == normalized then return candidate end
    end
    return nil
end

function findXCCharacterWeaponVisual(character, weaponName)
    if not character or type(weaponName) ~= _V[1]({123,108,90,65,54,31},24,240) then return nil end
    local direct = character:FindFirstChild(weaponName, true)
    if direct and (direct:IsA(_V[1]({18,57,51,57,69},192,5)) or direct:IsA(_V[1]({254,26,27,25},169,1)) or direct:IsA(_V[1]({45,141,224,19,63,145,227,38},170,65))) then return direct end
    local normalized = weaponName:lower():gsub(_V[1]({51,232,97,101,253},38,178), _V[1]({},198,106))
    for _, candidate in ipairs(character:GetDescendants()) do
        if (candidate:IsA(_V[1]({80,215,49,151,3},158,101)) or candidate:IsA(_V[1]({117,138,132,123},39,250)))
            and candidate.Name:lower():gsub(_V[1]({67,63,255,74,41},239,249), _V[1]({},173,230)) == normalized then
            return candidate
        end
    end
    return nil
end

function buildXCWeaponViewport(esp, weaponName, tool, character)
    clearXCWeaponPreview(esp)

    if tool and type(tool.TextureId) == _V[1]({221,69,170,8,116,212},3,103) and tool.TextureId ~= _V[1]({},121,220) then
        esp.WeaponImage.Image = tool.TextureId
        esp.WeaponImageShadow.Image = tool.TextureId
        esp.WeaponImage.Visible = true
        esp.WeaponImageShadow.Visible = true
        esp.WeaponReady = true
        return true
    end
    if tool then
        local embedded = tool:FindFirstChildWhichIsA(_V[1]({45,248,147,64,229,115,47,215,129,47},61,167), true)
        if embedded and embedded.Image ~= _V[1]({},166,175) then
            esp.WeaponImage.Image = embedded.Image
            esp.WeaponImageShadow.Image = embedded.Image
            esp.WeaponImage.Visible = true
            esp.WeaponImageShadow.Visible = true
            esp.WeaponReady = true
            return true
        end
    end

    local characterVisual = findXCCharacterWeaponVisual(character, weaponName)
    local asset = findXCWeaponAsset(weaponName)
    local source = characterVisual or (asset and (
        asset:FindFirstChild(_V[1]({245,53,96,130,162},118,40))
        or asset:FindFirstChild(_V[1]({82,77,23,229,178,116,64},65,205))
        or asset:FindFirstChild(_V[1]({136,119,83,55,4,203,187,163,127,86,48},89,219))
        or asset:FindFirstChild(_V[1]({32,210,114,254,159,34},73,148))
        or asset
    )) or tool
    if not source then return false end

    local ok, clone = pcall(function() return source:Clone() end)
    if not ok or not clone then return false end
    clone.Parent = esp.WeaponWorld
    local cloneObjects = {clone}
    local visibleParts = {}
    for _, object in ipairs(clone:GetDescendants()) do table.insert(cloneObjects, object) end
    for _, object in ipairs(cloneObjects) do
        if object:IsA(_V[1]({197,159,60,223,172,99,17,179,102,245,210,130,57,215,144,70,238,172},200,177)) then
            object:Destroy()
        elseif object:IsA(_V[1]({233,91,192,5,67,167,11,96},84,83)) then
            local lower = object.Name:lower()
            if lower:find(_V[1]({164,152,118},96,227), 1, true) or lower:find(_V[1]({126,138,170,179},3,19), 1, true)
                or lower:find(_V[1]({150,128,104,84,40},74,229), 1, true) or lower:find(_V[1]({161,12,119,233,108,205},188,114), 1, true)
                or lower == _V[1]({193,88,242,145},181,154) or lower:find(_V[1]({183,194,219,224,250,246},71,13), 1, true)
                or lower:find(_V[1]({156,195,248,43,108,147,208,249,47},246,52), 1, true) or lower:find(_V[1]({82,227,136,25,182},74,152), 1, true) then
                object:Destroy()
            else
                object.Anchored = true
                object.CanCollide = false
                object.CanTouch = false
                object.CanQuery = false
                object.CastShadow = false
                object.Color = currentTheme.Enemy_Accent
                object.Material = Enum.Material.Neon
                object.Reflectance = 0
                if object:IsA(_V[1]({211,133,45,188,62,233,148,48},236,154)) then object.TextureID = _V[1]({},226,224) end
                if object.Transparency < 0.98 then table.insert(visibleParts, object) end
            end
        elseif object:IsA(_V[1]({108,46,203,95,250,156,62,186,137,41,190,90,11,154,71,220,126},121,160)) or object:IsA(_V[1]({251,192,98,4,179},19,164)) or object:IsA(_V[1]({20,89,160,208,5,54,93},140,52)) then
            object:Destroy()
        end
    end

    if #visibleParts == 0 then
        clearXCWeaponPreview(esp)
        return false
    end

    local minimum = Vector3.new(math.huge, math.huge, math.huge)
    local maximum = Vector3.new(-math.huge, -math.huge, -math.huge)
    for _, part in ipairs(visibleParts) do
        local half = part.Size * 0.5
        for x = -1, 1, 2 do
            for y = -1, 1, 2 do
                for z = -1, 1, 2 do
                    local point = part.CFrame:PointToWorldSpace(Vector3.new(half.X * x, half.Y * y, half.Z * z))
                    minimum = Vector3.new(math.min(minimum.X, point.X), math.min(minimum.Y, point.Y), math.min(minimum.Z, point.Z))
                    maximum = Vector3.new(math.max(maximum.X, point.X), math.max(maximum.Y, point.Y), math.max(maximum.Z, point.Z))
                end
            end
        end
    end
    local boundsSize = maximum - minimum
    if boundsSize.Magnitude < 0.01 then clearXCWeaponPreview(esp) return false end

    local center = (minimum + maximum) * 0.5
    local longOnX = boundsSize.X >= boundsSize.Z
    local viewDirection = longOnX and Vector3.new(0, 0.08, 1) or Vector3.new(1, 0.08, 0)
    local horizontalSize = longOnX and boundsSize.X or boundsSize.Z
    local depthSize = longOnX and boundsSize.Z or boundsSize.X
    local fieldOfView = 24
    local tangent = math.tan(math.rad(fieldOfView * 0.5))
    local viewportAspect = 2.6
    local distanceForWidth = horizontalSize / math.max(0.01, 2 * tangent * viewportAspect)
    local distanceForHeight = boundsSize.Y / math.max(0.01, 2 * tangent)
    local cameraDistance = math.max(distanceForWidth, distanceForHeight, 0.35) * 1.18 + depthSize * 0.5
    esp.WeaponCamera.FieldOfView = fieldOfView
    esp.WeaponCamera.CFrame = CFrame.lookAt(center + viewDirection.Unit * cameraDistance, center, Vector3.yAxis)
    esp.WeaponViewport.Visible = true
    esp.WeaponReady = true
    return true
end

function updateXCWeaponPreview(esp, plr, char, sideColor, boxPosX, boxPosY, boxWidth, boxHeight)
    if not XCConfig.weaponEspEnabled then
        esp.WeaponCard.Visible = false
        return
    end

    local weaponName, tool, raw = getXCEquippedWeapon(plr, char)
    local key = tostring(raw or _V[1]({},204,107)) .. _V[1]({221},227,126) .. tostring(weaponName or _V[1]({},146,83)) .. _V[1]({180},110,202) .. tostring(tool)
    local now = os.clock()
    if key ~= esp.WeaponRaw or (not esp.WeaponReady and now >= (esp.WeaponNextRetry or 0)) then
        esp.WeaponRaw = key
        esp.WeaponName = weaponName
        esp.WeaponNextRetry = now + 1
        buildXCWeaponViewport(esp, weaponName, tool, char)
    end

    local weaponLime = currentTheme.Enemy_Accent
    esp.WeaponCardStroke.Color = weaponLime
    esp.WeaponImage.ImageColor3 = weaponLime
    esp.WeaponImageShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    esp.WeaponViewport.Ambient = weaponLime
    esp.WeaponViewport.LightColor = Color3.fromRGB(225, 255, 160)
    local iconWidth = math.floor(math.clamp(boxWidth * 1.45, 42, 68) + 0.5)
    local iconHeight = math.floor(math.clamp(iconWidth * 0.38, 18, 27) + 0.5)
    esp.WeaponCard.Size = UDim2.fromOffset(iconWidth, iconHeight)
    esp.WeaponCard.Position = UDim2.fromOffset(boxPosX + boxWidth * 0.5, boxPosY + boxHeight + 3)
    esp.WeaponCard.Visible = weaponName ~= nil and esp.WeaponReady
end

table.insert(connections, Players.PlayerRemoving:Connect(function(plr)
    local oldChar = plr.Character
    local oldHum = oldChar and oldChar:FindFirstChildOfClass(_V[1]({219,45,74,99,149,187,218,250},110,37))
    if oldHum then
        hitmarkerPendingHits[oldHum] = nil
    end
    if oldChar then hitmarkerPendingHits[oldChar] = nil end

    local cache = screenEspCache[plr]
    if cache then
        pcall(function()
            cache.Box:Destroy()
            cache.BoxOutline:Destroy()
            cache.HealthBarBg:Destroy()
            cache.WeaponCard:Destroy()
            cache.TagCard:Destroy()
            for _, corner in pairs(cache.Corners) do
                corner.H:Destroy()
                corner.V:Destroy()
            end
            for _, line in ipairs(cache.SkeletonLines) do line:Destroy() end
        end)
        screenEspCache[plr] = nil
    end
end))

local tacticalOverlayWasActive = false
function hideTacticalOverlay()
    for _, esp in pairs(screenEspCache) do
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
        esp.HealthBarBg.Visible = false
        esp.WeaponCard.Visible = false
        esp.TagCard.Visible = false
        for _, corner in ipairs(esp.Corners) do
            corner.H.Visible = false
            corner.V.Visible = false
        end
        hideXCSkeleton(esp)
    end
end

function getXCCharacterScreenRect(esp, char, rootPart)
    if esp.Character ~= char then
        esp.Character = char
        esp.SmoothRect = nil
    end

    local rootPosition = rootPart.Position
    local currentFov = math.clamp(tonumber(camera.FieldOfView) or 70, 10, 120)
    if esp.LastProjectionFov and math.abs(esp.LastProjectionFov - currentFov) > 0.05 then
        esp.SmoothRect = nil
    end
    esp.LastProjectionFov = currentFov

    local rootScreen = camera:WorldToViewportPoint(rootPosition + Vector3.new(0, 0.15, 0))
    if rootScreen.Z <= 0.2 then
        esp.SmoothRect = nil
        return nil
    end
    local viewport = camera.ViewportSize
    local preferredAspect = math.clamp(tonumber(XCConfig.espBoxAspect) or 0.52, 0.38, 0.8)
    local perspectiveScale = math.clamp(tonumber(XCConfig.espPerspectiveScale) or 1, 0.65, 1.5)

    local distance = (rootPosition - camera.CFrame.Position).Magnitude
    if distance <= 0.2 then
        esp.SmoothRect = nil
        return nil
    end

    local referenceFocal = viewport.Y / (2 * math.tan(math.rad(35)))
    local projectedHeight = (6 * referenceFocal / distance) * perspectiveScale
    local maxHeight = math.max(80, viewport.Y * 0.72)
    local height = math.clamp(projectedHeight, 16, maxHeight)
    local width = height * preferredAspect
    local centerScreenX = rootScreen.X
    local centerScreenY = rootScreen.Y
    local target = {
        X = centerScreenX - width * 0.5,
        Y = centerScreenY - height * 0.5,
        W = width,
        H = height,
    }
    local smooth = math.clamp(tonumber(XCConfig.espBoxSmoothing) or 0.42, 0, 0.9)
    local alpha = 1 - smooth
    local old = esp.SmoothRect
    if old then

        height = old.H + (height - old.H) * alpha
        width = height * preferredAspect
        target.X = centerScreenX - width * 0.5
        target.Y = centerScreenY - height * 0.5
        target.W = width
        target.H = height
    end

    target.X = math.floor(target.X + 0.5)
    target.Y = math.floor(target.Y + 0.5)
    target.W = math.max(2, math.floor(target.W + 0.5))
    target.H = math.max(2, math.floor(target.H + 0.5))
    esp.SmoothRect = target

    if target.X > viewport.X or target.Y > viewport.Y or target.X + target.W < 0 or target.Y + target.H < 0 then
        return nil
    end
    return target
end

function renderTacticalOverlay()
    local active = XCConfig.nametagsEnabled or XCConfig.boxEspEnabled or XCConfig.cornerBoxEnabled
        or XCConfig.healthBarEnabled or XCConfig.skeletonEspEnabled or XCConfig.weaponEspEnabled
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
        local hum = char and char:FindFirstChildOfClass(_V[1]({0,96,139,178,242,38,83,129},133,51))
        local rootPart = char and (char:FindFirstChild(_V[1]({111,58,208,98,13,172,68,221,105,36,194,101,223,142,61,221},137,158)) or char:FindFirstChild(_V[1]({176,71,198,67,187},224,124)) or char:FindFirstChild(_V[1]({50,107,137,156,199,199,0,33,64,90},191,30)))
        local head = char and char:FindFirstChild(_V[1]({29,7,208,160},8,205))

        local isEnemy = isTargetEnemy(plr, char)
        local isAlive = isEntityAlive(char, hum)
        local health, maxHealth = getXCHealth(char, plr, hum)

        if isEnemy and isAlive and rootPart and active then
            local dist = (rootPart.Position - camPos).Magnitude

            if dist <= XCConfig.espMaxDist then
                local isVisible = isVisibleThroughWalls(head or rootPart, char)
                local sideColor = isVisible and currentTheme.Enemy_Accent or currentTheme.Enemy_Hidden

                local screenRect = getXCCharacterScreenRect(esp, char, rootPart)

                if screenRect then
                    local boxHeight = screenRect.H
                    local boxWidth = screenRect.W
                    local boxPosX = screenRect.X
                    local boxPosY = screenRect.Y

                    if XCConfig.boxEspEnabled and not XCConfig.cornerBoxEnabled then
                        esp.BoxStroke.Color = sideColor
                        local boxStrokeWidth = math.clamp(math.floor((tonumber(XCConfig.boxThickness) or 1) + 0.5), 1, 2)
                        esp.BoxStroke.Thickness = boxStrokeWidth
                        esp.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                        esp.Box.Position = UDim2.new(0, boxPosX, 0, boxPosY)
                        esp.Box.Visible = true
                        esp.BoxOutlineStroke.Thickness = boxStrokeWidth + 2
                        esp.BoxOutline.Size = esp.Box.Size
                        esp.BoxOutline.Position = esp.Box.Position
                        esp.BoxOutline.Visible = XCConfig.espBoxOutline
                        for _, corner in ipairs(esp.Corners) do
                            corner.H.Visible = false
                            corner.V.Visible = false
                        end
                    elseif XCConfig.cornerBoxEnabled then
                        esp.Box.Visible = false
                        esp.BoxOutline.Visible = false
                        local lengthX = math.min(
                            math.floor(math.clamp(boxWidth * 0.30, 3, 28) + 0.5),
                            math.max(2, math.floor(boxWidth * 0.48))
                        )
                        local lengthY = math.min(
                            math.floor(math.clamp(boxHeight * 0.20, 5, 36) + 0.5),
                            math.max(3, math.floor(boxHeight * 0.48))
                        )
                        local thick = math.clamp(math.floor((tonumber(XCConfig.boxThickness) or 1) + 0.5), 1, 2)

                        for _, corner in ipairs(esp.Corners) do
                            corner.H.BackgroundColor3 = sideColor
                            corner.V.BackgroundColor3 = sideColor
                            corner.HOutline.Enabled = XCConfig.espBoxOutline
                            corner.VOutline.Enabled = XCConfig.espBoxOutline
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
                        esp.BoxOutline.Visible = false
                        for _, corner in ipairs(esp.Corners) do
                            corner.H.Visible = false
                            corner.V.Visible = false
                        end
                    end

                    if XCConfig.healthBarEnabled and health then
                        local hpPercent = math.clamp(health / maxHealth, 0, 1)

                        local barWidth = boxHeight < 32 and 3 or 4
                        local barGap = boxHeight < 32 and 2 or 3
                        local barX = boxPosX - barWidth - barGap
                        local barY = boxPosY
                        local fillHeight = math.max(1, math.floor((boxHeight - 2) * hpPercent + 0.5))

                        esp.HealthBarBg.Size = UDim2.new(0, barWidth, 0, boxHeight)
                        esp.HealthBarBg.Position = UDim2.new(0, barX, 0, barY)
                        esp.HealthBarBg.Visible = true

                        esp.HealthBarFill.Position = UDim2.new(0, 1, 1, -1)
                        esp.HealthBarFill.Size = UDim2.fromOffset(barWidth - 2, fillHeight)

                        esp.HealthBarFill.BackgroundColor3 = Color3.new(1, 1, 1)
                        local healthGradient = esp.HealthBarFill:FindFirstChild(_V[1]({7,205,114,38,215,116,252,208,104,20,194,103,25,200},22,169))
                        if healthGradient and esp.HealthGradientColor ~= sideColor then
                            local visibleTop = sideColor
                            healthGradient.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, visibleTop),
                                ColorSequenceKeypoint.new(0.55, visibleTop:Lerp(Color3.fromRGB(225, 190, 50), 0.55)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 65, 55)),
                            })
                            esp.HealthGradientColor = sideColor
                        end
                    else
                        esp.HealthBarBg.Visible = false
                    end

                    if XCConfig.nametagsEnabled then
                        esp.TagCard.BackgroundTransparency = XCConfig.tagTransparency
                        esp.TagCardStroke.Enabled = false
                        esp.TagLabel.TextColor3 = currentTheme.Enemy_Accent
                        esp.TagLabel.TextSize = XCConfig.espTextSize

                        local baseName = plr.DisplayName or plr.Name
                        local infoText = baseName

                        if XCConfig.espShowDistance then
                            infoText = string.format(_V[1]({50,211,211,97,126,16,108,175},186,83), infoText, math.floor(dist))
                        end
                        if XCConfig.espShowHealth and health then
                            infoText = string.format(_V[1]({173,83,88,235,13,164,224,64,165},48,88), infoText, math.floor(health + 0.5))
                        end
                        if XCConfig.tagShowWeapon and not XCConfig.weaponEspEnabled then
                            local tool = char:FindFirstChildOfClass(_V[1]({195,223,224,222},110,1))
                            if tool then
                                infoText = string.format(_V[1]({68,251,17,213,232,159,18},182,105), infoText, tool.Name)
                            end
                        end

                        if esp.LastText ~= infoText then
                            esp.TagLabel.Text = infoText
                            esp.LastText = infoText
                        end

                        esp.TagCard.Position = UDim2.new(0, boxPosX + boxWidth * 0.5, 0, boxPosY - 4)
                        esp.TagCard.Visible = true
                    else
                        esp.TagCard.Visible = false
                    end
                    updateXCWeaponPreview(esp, plr, char, sideColor, boxPosX, boxPosY, boxWidth, boxHeight)
                    renderXCSkeleton(esp, char, sideColor, dist)
                else
                    esp.Box.Visible = false
                    esp.BoxOutline.Visible = false
                    esp.HealthBarBg.Visible = false
                    esp.WeaponCard.Visible = false
                    for _, corner in ipairs(esp.Corners) do
                        corner.H.Visible = false
                        corner.V.Visible = false
                    end
                    esp.TagCard.Visible = false
                    hideXCSkeleton(esp)
                end
            else
                esp.Box.Visible = false
                esp.BoxOutline.Visible = false
                esp.HealthBarBg.Visible = false
                esp.WeaponCard.Visible = false
                for _, corner in ipairs(esp.Corners) do
                    corner.H.Visible = false
                    corner.V.Visible = false
                end
                esp.TagCard.Visible = false
                hideXCSkeleton(esp)
            end
        else
            esp.Box.Visible = false
            esp.BoxOutline.Visible = false
            esp.HealthBarBg.Visible = false
            esp.WeaponCard.Visible = false
            for _, corner in ipairs(esp.Corners) do
                corner.H.Visible = false
                corner.V.Visible = false
            end
            esp.TagCard.Visible = false
            hideXCSkeleton(esp)
        end
    end
end

function attachEspToPlayer(plr)
    if plr == player then return end

    local holder = Instance.new(_V[1]({158,15,84,148,221,50},16,72))
    holder.Name = _V[1]({14,205,163,133,86,57},226,212) .. plr.Name
    holder.Parent = mainContainer

    local dotBillboard = Instance.new(_V[1]({77,5,153,42,177,79,210,116,247,107,42,175},122,145), holder)
    dotBillboard.Size = UDim2.new(0, 6, 0, 6)
    dotBillboard.StudsOffset = Vector3.new(0, 0.5, 0)
    dotBillboard.AlwaysOnTop = true
    dotBillboard.Enabled = false

    local dotFrame = Instance.new(_V[1]({163,239,254,42,66},61,32), dotBillboard)
    dotFrame.Size = UDim2.new(1, 0, 1, 0)
    dotFrame.BackgroundColor3 = currentTheme.Enemy_Accent
    dotFrame.BorderSizePixel = 0
    Instance.new(_V[1]({34,128,228,122,231,77,174,37},99,106), dotFrame).CornerRadius = UDim.new(1, 0)

    local tracerLine = Instance.new(_V[1]({33,169,244,92,176},127,92), mainContainer)
    tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
    tracerLine.BorderSizePixel = 0
    tracerLine.BackgroundColor3 = currentTheme.Enemy_Accent
    tracerLine.Visible = false

    local hl = Instance.new(_V[1]({198,5,33,64,98,125,153,184,226},96,30))
    hl.Name = _V[1]({217,222,248,55,74,112,144,150},103,26) .. plr.Name
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
            local head = char:WaitForChild(_V[1]({88,111,101,98},22,250), 3)
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
            local serverStats = Stats:FindFirstChild(_V[1]({46,233,156,67,223,134,35},60,164)) and Stats.Network:FindFirstChild(_V[1]({3,129,250,106,197,62,139,24,113,240,91,157,52,145,5},68,108))
            if serverStats and serverStats:FindFirstChild(_V[1]({8,77,136,157,132,220,29,74,107},156,40)) then
                pingVal = math.floor(serverStats[_V[1]({1,95,179,225,225,82,172,242,44},124,65)]:GetValue())
            end
        end)
        local parts = {}
        if XCConfig.watermarkShowFPS then table.insert(parts, string.format(_V[1]({186,173,153,105,56,38,78},139,233), currentFps)) end
        if XCConfig.watermarkShowPing then table.insert(parts, string.format(_V[1]({198,170,154,126,92,45,29,71,59,44},139,235), pingVal)) end
        wmMetrics.Text = table.concat(parts, _V[1]({119,249,195},49,38))
        fpsCounter = 0
        lastFpsUpdate = nowTick
    end
    wmCard.Visible = XCConfig.watermarkEnabled
    wmTitle.Text = XCConfig.watermarkText or _V[1]({110,139},228,50)
    if XCConfig.watermarkShowName then
        wmTitle.Text = (XCConfig.watermarkText or _V[1]({182,121},134,216)) .. _V[1]({188,120,16,44,164},162,250) .. player.Name
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
        setXCSilentAimRequested(true)

        silentAimResolved = getSilentAimTarget()
    else
        setXCSilentAimRequested(false)
        silentAimResolved = nil
        xcSilentShotContextV31 = nil
        if sharedXCEnv then sharedXCEnv.XCSilentShotContextV31 = nil end
    end

    if (XCConfig.rcsEnabled or XCConfig.noRecoilEnabled) and noRecoil.isShooting then
        local comp = (XCConfig.noRecoilEnabled and (XCConfig.recoilStrength * 0.0035) or 0) + (XCConfig.rcsEnabled and ((XCConfig.rcsStrength / 100) * 0.004 * XCConfig.rcsPitchFactor) or 0)
        camera.CFrame = camera.CFrame * CFrame.Angles(-comp, 0, 0)
    end

    if XCConfig.rageBotEnabled then
        local target = getRageTarget()
        if target and target.Part and target.Part.Parent then
            local aimPos = getKinematicAimPosition(target.Part)
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, aimPos)

            if XCConfig.rageAutoFire and tick() - lastTriggerTick > math.clamp(tonumber(XCConfig.triggerbotDelay) or 0.075, 0.01, 0.5) then
                lastTriggerTick = tick()
                pcall(function()
                    local vp = camera.ViewportSize
                    triggerbotFire(vp)
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
        renderXCGrenadeDangerZones()
        renderXCSoundPositionEsp()

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
        local hum = char and char:FindFirstChildOfClass(_V[1]({104,8,115,218,90,206,59,169},173,115))
        local rootPart = char and (char:FindFirstChild(_V[1]({250,227,151,71,16,205,131,58,228,189,121,58,210,159,108,42},246,188)) or char:FindFirstChild(_V[1]({41,243,165,85,0},38,175)) or char:FindFirstChild(_V[1]({23,1,208,148,112,33,11,221,173,120},243,207)))
        local head = char and char:FindFirstChild(_V[1]({198,154,77,7},199,183))

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
                    if ally then
                        data.Highlight.FillColor = chamsColorAlly
                        data.Highlight.OutlineColor = chamsOutlineColor
                    else
                        local chamsAccent = isVisible and chamsColorVisible or chamsColorHidden
                        data.Highlight.FillColor = XCConfig.chamsOcclusion and chamsAccent or chamsColorVisible
                        data.Highlight.OutlineColor = XCConfig.chamsOcclusion and chamsAccent or chamsColorVisible
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
        local cfg = nightPresets[XCConfig.nightPreset] or nightPresets[_V[1]({211,211,178,160,127,97,70,54},162,228)]
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
                if v:IsA(_V[1]({58,128,151,180,209,188,2,31,57,70,94,137,152,184,209,194,253,23,48,72,115},221,26)) and v.Saturation < -0.5 then v.Enabled = false end
            end
        end)
    end
end))

function resetXCCharacterInputState()
    xcCharacterInputHook.Character = nil
    xcCharacterInputHook.GroundSince = nil
    xcCharacterInputHook.LastJumpDown = false
    xcCharacterInputHook.AntiCharacter = nil
    xcCharacterInputHook.AntiStarted = nil
    xcCharacterInputHook.AntiLastStep = nil
    xcCharacterInputHook.RandomYaw = nil
    xcCharacterInputHook.AntiFireUntil = 0
end

function restoreXCCharacterInputHook()
    local state = xcCharacterInputHook
    if state.Module and state.Wrapper and state.Module.SampleInput == state.Wrapper and state.Original then
        pcall(function() state.Module.SampleInput = state.Original end)
    end
    if state.Module and rawget(state.Module, _V[1]({168,148,121,80,66,83,65,50,29,228,248,219,190,183},93,236)) == xcSessionToken then
        pcall(function() rawset(state.Module, _V[1]({0,3,255,237,246,30,35,43,45,11,54,48,42,58},158,3), nil) end)
    end
    state.Ready = false
    resetXCCharacterInputState()
end

function setupXCCharacterInputHook()
    if xcCharacterInputHook.Ready then return true end
    local ok, failure = pcall(function()
        local classes = ReplicatedStorage:FindFirstChild(_V[1]({9,105,149,222,21,62,131},143,55))
        local movement = ReplicatedStorage:FindFirstChild(_V[1]({162,157,125,69,38,247,217,184,115,40},124,217))
        local characterModule = classes and classes:FindFirstChild(_V[1]({247,95,155,239,33,102,186,238,62},113,67))
        local buttonsModule = movement and movement:FindFirstChild(_V[1]({207,157,55,210,104,2,162},242,155))
        assert(characterModule and buttonsModule, _V[1]({75,22,186,100,173,129,67,226,122,29,184,20,2,165,77,221,134,31,201,112,189,171,78,228,150,46,200,119,197,167,89,237,73,63,217,109,35,175,88,252,146,52,223,121},104,161))
        local module = require(characterModule)
        local buttons = require(buttonsModule)
        assert(type(module) == _V[1]({83,45,27,18,248},242,237) and type(module.SampleInput) == _V[1]({179,134,67,252,209,138,84,23},137,196), _V[1]({117,65,11,204,134,61,223,194,130,69,2,108,115,59,166,185,112,33,244,157,99,36,215,150,94,21},100,190))
        assert(type(buttons) == _V[1]({97,71,65,68,54},244,249) and type(buttons.has) == _V[1]({34,84,112,136,188,212,253,31},153,35) and type(buttons.with) == _V[1]({207,154,79,0,205,126,64,251},173,188), _V[1]({206,9,16,24,27,34,220,44,49,64,76,73,94,103,28,101,126,121,60,153,154,149,178,165,181,192,189,198,216,217},132,8))
        if table.isfrozen and table.isfrozen(module) then error(_V[1]({210,99,200,69,160,14,139,232,97,123,52,162,3,128,227,72,111,36,154,179,101,221,70,189,20,137},35,108), 0) end

        local original = module.SampleInput
        xcCharacterInputHook.Module = module
        xcCharacterInputHook.Original = original
        xcCharacterInputHook.Buttons = buttons

        xcCharacterInputHook.Wrapper = function(character, context, ...)
            local input = original(character, context, ...)
            xcCharacterInputHook.Calls = (xcCharacterInputHook.Calls or 0) + 1
            xcCharacterInputHook.LastCall = os.clock()
            if type(input) ~= _V[1]({188,217,10,68,109},24,48) or not xcSessionActive() then return input end
            local success, modified = pcall(function()
                local model = player.Character
                if not model or character.IsDestroyed or character.Character ~= model
                    or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox()
                    or player:GetAttribute(_V[1]({18,22,205,195,146,132,74,49,220,219,174,155,117,68,35,246},239,218)) == true then
                    resetXCCharacterInputState()
                    return input
                end

                local result = input
                local movementState = context and context.State
                local now = (context and context.ScheduledServerTime) or os.clock()

                local bhopActive = XCConfig.bunnyHopEnabled and movementState
                    and not (XCConfig.bhopPauseWithMenu and XCFeatureState.menuOpen)
                if bhopActive then
                    if xcCharacterInputHook.Character ~= character then
                        xcCharacterInputHook.Character = character
                        xcCharacterInputHook.GroundSince = nil
                        xcCharacterInputHook.LastJumpDown = buttons.has((movementState.PreviousButtons or 0), buttons.Jump)
                    end
                    local moving = input.Move and input.Move.Magnitude > 0.05
                    local requested = XCConfig.bhopMode == _V[1]({69,35,204,113,25,183,116,19,183},90,170) or character.JumpInputDown
                        or isMobileJumpHeld or buttons.has(input.Buttons, buttons.Jump)
                    if requested and (not XCConfig.bhopMovingOnly or moving) then
                        if movementState.OnGround then
                            xcCharacterInputHook.GroundSince = xcCharacterInputHook.GroundSince or now
                        else
                            xcCharacterInputHook.GroundSince = nil
                        end
                        local delay = math.clamp(tonumber(XCConfig.bhopGroundDelay) or 0, 0, 0.25)
                        local jump = movementState.OnGround == true
                            and not xcCharacterInputHook.LastJumpDown
                            and xcCharacterInputHook.GroundSince ~= nil
                            and now - xcCharacterInputHook.GroundSince >= delay
                        result = table.clone(result)
                        result.Buttons = buttons.with(input.Buttons, buttons.Jump, jump)
                        xcCharacterInputHook.LastJumpDown = jump
                        if jump then xcCharacterInputHook.GroundSince = nil end
                    else
                        xcCharacterInputHook.GroundSince = nil
                        xcCharacterInputHook.LastJumpDown = buttons.has(input.Buttons, buttons.Jump)
                    end
                else
                    xcCharacterInputHook.Character = nil
                    xcCharacterInputHook.GroundSince = nil
                    xcCharacterInputHook.LastJumpDown = false
                end

                local weaponIsFiring = false
                if skinData and type(skinData.GetWeapon) == _V[1]({215,185,133,77,49,249,210,164},158,211) then
                    pcall(function()
                        local weapon = skinData.GetWeapon()
                        weaponIsFiring = weapon and (weapon.IsFireHeld or weapon.IsShooting or weapon.IsBurstShooting) == true
                    end)
                end
                if weaponIsFiring then
                    xcCharacterInputHook.AntiFireUntil = os.clock() + 0.16
                end
                local antiAimPausedForShot = os.clock() < (xcCharacterInputHook.AntiFireUntil or 0)

                if XCConfig.antiAimEnabled and not antiAimPausedForShot then
                    if xcCharacterInputHook.AntiCharacter ~= character or not xcCharacterInputHook.AntiStarted then
                        xcCharacterInputHook.AntiCharacter = character
                        xcCharacterInputHook.AntiStarted = now
                        xcCharacterInputHook.AntiLastStep = nil
                        xcCharacterInputHook.RandomYaw = nil
                    end
                    local elapsed = math.max(0, now - xcCharacterInputHook.AntiStarted)
                    local interval = math.max(0.04, tonumber(XCConfig.antiAimInterval) or 0.15)
                    local step = math.floor(elapsed / interval)
                    local side = step % 2 == 0 and -1 or 1
                    local originalYaw = tonumber(result.LookYaw) or 0
                    local yaw = originalYaw + math.rad(tonumber(XCConfig.antiAimYaw) or 180)
                    local mode = tostring(XCConfig.antiAimMode or _V[1]({157,169,129,127,95,68},95,235))
                    if mode == _V[1]({114,185,227,19,71,89,146,172,227},8,40) then
                        yaw = originalYaw + math.pi
                    elseif mode == _V[1]({12,8,240,205,155,133},229,221) then
                        yaw += math.rad(tonumber(XCConfig.antiAimJitter) or 60) * side
                    elseif mode == _V[1]({27,253,187,133},3,197) then
                        yaw += math.rad((elapsed * math.max(10, tonumber(XCConfig.spinSpeed) or 50) * 6) % 360)
                    elseif mode == _V[1]({155,59,217,96,252,139},184,145) then
                        if xcCharacterInputHook.AntiLastStep ~= step or not xcCharacterInputHook.RandomYaw then
                            xcCharacterInputHook.RandomYaw = math.rad(math.random(-180, 180))
                        end
                        yaw += xcCharacterInputHook.RandomYaw
                    end
                    yaw = (yaw + math.pi) % (math.pi * 2) - math.pi
                    local move = result.Move or Vector2.zero
                    if move.Magnitude > 1 then move = move.Unit end
                    local delta = yaw - originalYaw
                    local cosine, sine = math.cos(delta), math.sin(delta)
                    if result == input then result = table.clone(result) end
                    result.Move = Vector2.new(move.X * cosine - move.Y * sine, move.X * sine + move.Y * cosine)
                    result.LookYaw = yaw
                    xcCharacterInputHook.AntiLastStep = step
                elseif not XCConfig.antiAimEnabled then
                    xcCharacterInputHook.AntiCharacter = nil
                    xcCharacterInputHook.AntiStarted = nil
                end
                return result
            end)
            if success then return modified end
            xcCharacterInputHook.LastError = tostring(modified)
            return input
        end

        module.SampleInput = xcCharacterInputHook.Wrapper
        rawset(module, _V[1]({94,139,177,201,252,78,125,175,219,227,56,92,128,186},210,45), xcSessionToken)
        xcCharacterInputHook.Ready = true
        xcCharacterInputHook.LastError = nil
    end)
    if not ok then
        xcCharacterInputHook.LastError = tostring(failure)
        restoreXCCharacterInputHook()
    end
    return xcCharacterInputHook.Ready
end

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    local char = player.Character
    local hrp = char and char:FindFirstChild(_V[1]({93,30,170,50,211,104,246,133,7,184,76,229,85,250,159,53},129,148))
    local hum = char and char:FindFirstChildOfClass(_V[1]({216,161,53,197,110,11,161,56},244,156))

    if not XCConfig.antiAimEnabled then
        if hum and savedAutoRotate ~= nil then
            hum.AutoRotate = savedAutoRotate
            savedAutoRotate = nil
        end
        return
    end

    if xcCharacterInputHook.Ready
        and os.clock() - (xcCharacterInputHook.LastCall or 0) < 0.5 then return end

    if not hrp or not hum or hum.Health <= 0 then return end

    if savedAutoRotate == nil then
        savedAutoRotate = hum.AutoRotate
        hum.AutoRotate = false
    end

    local mode = tostring(XCConfig.antiAimMode or _V[1]({62,31,220,165},39,196))
    local activeCamera = Workspace.CurrentCamera or camera
    if not activeCamera then return end
    local _, cameraYaw = activeCamera.CFrame:ToOrientation()
    local targetYaw
    if mode == _V[1]({165,51,157,19},225,113) then
        currentSpinAngle = (currentSpinAngle + (XCConfig.spinSpeed * 6 * dt)) % 360
        targetYaw = math.rad(currentSpinAngle)
    elseif mode == _V[1]({21,176,46,178,58,160,45,155,38},87,124) then
        targetYaw = cameraYaw + math.pi
    elseif mode == _V[1]({249,36,59,71,68,93},163,12) then
        local interval = math.max(0.04, tonumber(XCConfig.antiAimInterval) or 0.15)
        local side = math.floor(os.clock() / interval) % 2 == 0 and -1 or 1
        targetYaw = cameraYaw + math.rad((tonumber(XCConfig.antiAimYaw) or 180) + side * (tonumber(XCConfig.antiAimJitter) or 60))
    elseif mode == _V[1]({238,78,172,243,79,158},75,81) then
        if os.clock() >= XCFeatureState.antiAimNextChange then
            XCFeatureState.antiAimNextChange = os.clock() + math.max(0.04, tonumber(XCConfig.antiAimInterval) or 0.15)
            XCFeatureState.antiAimRandomYaw = math.random(-180, 180)
        end
        targetYaw = cameraYaw + math.rad(XCFeatureState.antiAimRandomYaw)
    else
        targetYaw = cameraYaw + math.rad(tonumber(XCConfig.antiAimYaw) or 180)
    end
    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, targetYaw, 0)
end))

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
    local hum = char and char:FindFirstChildOfClass(_V[1]({212,246,227,204,206,196,179,163},151,245))
    if hum and hum.Parent then
        defaultHipHeight = hum.HipHeight
        defaultHipHeightCaptured = true
    end
end

function restoreDefaultHipHeight()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass(_V[1]({48,42,239,176,138,88,31,231},27,205))
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
    local stroke = mobileSlideBtn:FindFirstChild(_V[1]({217,197,214,240,238,234,236,219,253,252,250,247,242},128,1))
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
    local hrp = char and char:FindFirstChild(_V[1]({201,145,36,179,91,247,140,34,171,99,254,158,21,193,109,10},230,155))
    local hum = char and char:FindFirstChildOfClass(_V[1]({159,49,142,231,89,191,30,126},242,101))
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

    mobileSlideBtn = Instance.new(_V[1]({119,114,111,85,13,42,19,253,226,203},57,234))
    mobileSlideBtn.Name = _V[1]({200,212,255,66,86,126,162,188,203,5,35,63,97,95,178,205},79,33)
    mobileSlideBtn.Size = UDim2.new(0, 50, 0, 50)
    mobileSlideBtn.Position = UDim2.new(1, -145, 1, -115)
    mobileSlideBtn.BackgroundColor3 = currentTheme.CardBg
    mobileSlideBtn.BackgroundTransparency = 0.3
    mobileSlideBtn.Text = _V[1]({205,215,229,241,3},105,17)
    mobileSlideBtn.TextColor3 = currentTheme.Accent
    mobileSlideBtn.TextSize = 9.5
    mobileSlideBtn.Font = Enum.Font.GothamBold
    mobileSlideBtn.Visible = XCConfig.slideEnabled and UserInputService.TouchEnabled
    mobileSlideBtn.ZIndex = 80
    mobileSlideBtn.Active = true
    mobileSlideBtn.AutoButtonColor = false
    mobileSlideBtn.Parent = mainContainer

    Instance.new(_V[1]({23,108,199,84,184,21,109,219},97,97), mobileSlideBtn).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new(_V[1]({81,79,99,142,150,157,163,167},242,10), mobileSlideBtn)
    stroke.Name = _V[1]({65,106,184,15,74,131,194,238,77,137,196,254,54},171,62)
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
        local pGui = player:WaitForChild(_V[1]({157,62,184,85,198,88,178,101,222},200,133), 5)
        if not pGui then return end
        local touchGui = pGui:WaitForChild(_V[1]({171,167,142,93,67,3,18,231},118,225), 5)
        if not touchGui then return end
        local controlFrame = touchGui:WaitForChild(_V[1]({92,43,229,135,64,207,175,98,28,206,127,48,190,158,65,1,173},84,180), 5)
        if not controlFrame then return end
        local jumpBtn = controlFrame:WaitForChild(_V[1]({72,134,145,167,140,210,228,247,5,23},235,19), 5)
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
        if child:IsA(_V[1]({86,199,29,112},172,86)) then scanAndMorphKnives(child) end
    end)
    table.insert(connections, childAddedConnection)
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA(_V[1]({102,183,237,32},220,54)) then scanAndMorphKnives(tool) end
    end
end

table.insert(connections, player.CharacterAdded:Connect(function(char)
    mobileSlideToggleActive = false
    mobileSlideDragging = false
    isSliding = false
    currentSlideVel = Vector3.zero
    mobileSlideInputActive = false
    defaultHipHeightCaptured = false
    XCFeatureState.bhopGroundSince = nil
    XCFeatureState.bhopLastJump = 0
    local hum = char:WaitForChild(_V[1]({108,167,173,175,202,217,225,234},22,14), 5)
    if hum then
        defaultHipHeight = hum.HipHeight
        defaultHipHeightCaptured = true
        hum.HipHeight = defaultHipHeight
    end
    hookMobileJumpButton()
    hookCharacterWeapons(char)
    if XCConfig.animationsEnabled then
        task.delay(0.75, function()
            if xcSessionActive() and XCConfig.animationsEnabled and player.Character == char then
                playXCAnimation()
            end
        end)
    end
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
        local hrp = char and char:FindFirstChild(_V[1]({59,192,16,92,193,26,108,191,5,122,210,47,99,204,53,143},155,88))
        local hum = char and char:FindFirstChildOfClass(_V[1]({137,72,210,88,247,138,22,163},175,146))
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

table.insert(connections, RunService.Heartbeat:Connect(function()
    if not XCConfig.hitmarkerEnabled and not XCConfig.hitSoundEnabled then
        hitmarkerPendingHits = {}
        return
    end

    local now = os.clock()
    for healthKey, pending in pairs(hitmarkerPendingHits) do
        local char = pending.Character
        local targetPlr = pending.Player
        if now > pending.Expires or not char or not char.Parent or not targetPlr
            or not isTargetEnemy(targetPlr, char) then
            hitmarkerPendingHits[healthKey] = nil
        else
            local hum = char:FindFirstChildOfClass(_V[1]({112,91,17,195,142,77,5,190},106,190))
            local currentHealth = getXCHealth(char, targetPlr, hum)
            if currentHealth ~= nil and currentHealth < pending.Health then
                local damage = pending.Health - currentHealth
                hitmarkerPendingHits[healthKey] = nil
                showHitmarker(damage)
            elseif currentHealth ~= nil and currentHealth > pending.Health then
                pending.Health = currentHealth
            end
        end
    end
end))

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    local char = player.Character
    local hrp = char and char:FindFirstChild(_V[1]({85,155,172,185,223,249,12,32,39,93,118,148,137,179,221,248},244,25))
    local hum = char and char:FindFirstChildOfClass(_V[1]({234,42,53,60,92,112,125,139},143,19))
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
    local activeMode = _V[1]({22,70,88,98,101,127},185,15)

    if XCConfig.flightEnabled then
        activeMode = _V[1]({54,174,253,77,160,254},158,82)
        finalVelocity = camera.CFrame.LookVector * XCConfig.flightSpeed
    elseif XCConfig.slideEnabled and isSliding then
        if isPlayerGrounded(char, hrp) and currentSlideVel.Magnitude > XCConfig.slideMinSpeed then
            activeMode = _V[1]({51,19,215,153,97},25,199)
            local frictionFactor = math.pow(math.clamp(XCConfig.slideFriction, 0, 1), math.max(dt, 0) * 60)
            currentSlideVel = currentSlideVel * frictionFactor
            finalVelocity = Vector3.new(currentSlideVel.X, currentVel.Y, currentSlideVel.Z)
        else
            isSliding = false
            currentSlideVel = Vector3.zero
            restoreDefaultHipHeight()
        end
    end

    if activeMode == _V[1]({12,16,246,212,171,153},219,227) and XCConfig.bunnyHopEnabled then
        local paused = not XCFeatureState.bhopWindowFocused
            or UserInputService:GetFocusedTextBox() ~= nil
            or GuiService.MenuIsOpen
            or player:GetAttribute(_V[1]({30,84,61,101,102,138,130,155,120,169,174,205,217,218,235,240},201,12)) == true
            or (XCConfig.bhopPauseWithMenu and XCFeatureState.menuOpen)
        if paused then
            XCFeatureState.bhopGroundSince = nil
        else
            local now = os.clock()
            local grounded = isPlayerGrounded(char, hrp) or hum.FloorMaterial ~= Enum.Material.Air
            local isSpacePressed = UserInputService:IsKeyDown(Enum.KeyCode.Space)
            local automatic = XCConfig.bhopMode == _V[1]({240,225,157,85,16,193,145,67,250},242,189) or XCConfig.bhopAutoJump
            local requested = automatic or isMobileJumpHeld or hum.Jump or isSpacePressed
            local moving = currentMove.Magnitude > 0.05
            local movementAllowed = not XCConfig.bhopMovingOnly or moving

            if grounded then
                XCFeatureState.bhopGroundSince = XCFeatureState.bhopGroundSince or now
            else
                XCFeatureState.bhopGroundSince = nil
            end

            local groundDelay = math.clamp(tonumber(XCConfig.bhopGroundDelay) or 0, 0, 0.25)
            local canJump = grounded and requested and movementAllowed
                and XCFeatureState.bhopGroundSince
                and now - XCFeatureState.bhopGroundSince >= groundDelay
                and now - XCFeatureState.bhopLastJump >= 0.05

            if canJump then
                activeMode = _V[1]({68,32,221,148},76,182)
                XCFeatureState.bhopLastJump = now
                XCFeatureState.bhopGroundSince = nil
                hum.Jump = true
                finalVelocity = Vector3.new(currentVel.X, math.clamp(tonumber(XCConfig.bhopJumpPower) or 52, 30, 100), currentVel.Z)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            end

            if moving and (grounded or XCConfig.bhopAirStrafe) then
                activeMode = canJump and _V[1]({139,53,192,69},197,132) or (grounded and _V[1]({102,50,223,134,220,195,107,17,185,102,5,184,77,6,157},126,166) or _V[1]({222,195,115,31,180,134,53,213,139,59},236,177))
                local targetSpeed = 16 * math.clamp(tonumber(XCConfig.bhopSpeedBoost) or 1.35, 1, 3)
                local targetVel = currentMove.Unit * targetSpeed
                local acceleration = math.clamp(tonumber(XCConfig.bhopAcceleration) or 12, 2, 30)
                local blend = 1 - math.exp(-acceleration * math.max(dt, 0))
                local base = finalVelocity or currentVel
                finalVelocity = Vector3.new(
                    base.X + (targetVel.X - base.X) * blend,
                    base.Y,
                    base.Z + (targetVel.Z - base.Z) * blend
                )
            end
        end
    else
        XCFeatureState.bhopGroundSince = nil
    end

    if activeMode == _V[1]({43,28,239,186,126,89},13,208) and XCConfig.speedEnabled and currentMove.Magnitude > 0 then
        activeMode = _V[1]({147,247,51,122,192},249,71)
        local targetVel = currentMove * (16 * XCConfig.walkMultiplier)
        finalVelocity = Vector3.new(targetVel.X, currentVel.Y, targetVel.Z)
    end

    if finalVelocity then
        hrp.AssemblyLinearVelocity = finalVelocity
    end
end))

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

    local toggleGui = Instance.new(_V[1]({152,19,141,235,86,202,14,167,6},218,107))
    toggleGui.Name = _V[1]({48,39,68,107,111,123,140,145,127,185,185},204,12)
    toggleGui.ResetOnSpawn = false
    toggleGui.IgnoreGuiInset = true
    toggleGui.DisplayOrder = 100
    toggleGui.Parent = targetGui

    local screenGui = Instance.new(_V[1]({118,62,5,176,104,41,186,160,76},107,184))
    screenGui.Name = _V[1]({149,153,194,235,19,31,56,90,76,147,160},36,25)
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 50
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = targetGui

    local main = Instance.new(_V[1]({68,104,79,83,67},6,248))
    main.Name = _V[1]({215,141,37,195,112,231,153,63,226},230,158)
    main.Size = UDim2.fromOffset(680, 450)
    main.Position = UDim2.new(0.5, -340, 0.5, -225)
    main.BackgroundColor3 = C.Main
    main.BorderColor3 = C.Border
    main.BorderSizePixel = 1
    main.Active = true
    main.Parent = screenGui

    local mainStroke = Instance.new(_V[1]({23,196,135,97,24,206,131,54},9,185))
    mainStroke.Color = C.Black
    mainStroke.Thickness = 2
    mainStroke.Parent = main

    local scale = Instance.new(_V[1]({27,233,205,183,143,116,71},236,218))
    scale.Name = _V[1]({74,34,245,183,123,63,9,196,150,74,253,210,149,101,35},51,197)
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
    table.insert(connections, screenGui:GetPropertyChangedSignal(_V[1]({160,185,194,182,171,172,163,140,114,128,137,108},103,248)):Connect(updateScale))

    local topLine = Instance.new(_V[1]({185,30,70,139,188},58,57))
    topLine.Size = UDim2.new(1, -4, 0, 2)
    topLine.Position = UDim2.fromOffset(2, 2)
    topLine.BorderSizePixel = 0
    topLine.BackgroundColor3 = C.Lime
    topLine.Parent = main
    local gradient = Instance.new(_V[1]({40,249,212,220,168,136,106,67,41,12},246,221))
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 210, 255)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(160, 75, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 65, 140)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 135, 20)),
        ColorSequenceKeypoint.new(1, C.Lime),
    })
    gradient.Parent = topLine

    local dragBar = Instance.new(_V[1]({47,218,72,211,74},106,127))
    dragBar.Name = _V[1]({239,198,94,13,145,89,19},2,169)
    dragBar.Size = UDim2.new(1, -52, 0, 10)
    dragBar.Position = UDim2.fromOffset(52, 0)
    dragBar.BackgroundTransparency = 1
    dragBar.Active = true
    dragBar.ZIndex = 20
    dragBar.Parent = main

    local sidebar = Instance.new(_V[1]({8,110,151,221,15},136,58))
    sidebar.Name = _V[1]({251,37,65,80,52,99,132},162,16)
    sidebar.Size = UDim2.new(0, 48, 1, -4)
    sidebar.Position = UDim2.fromOffset(2, 2)
    sidebar.BackgroundColor3 = C.Sidebar
    sidebar.BorderColor3 = C.Border
    sidebar.BorderSizePixel = 1
    sidebar.Parent = main

    local sideLayout = Instance.new(_V[1]({34,145,15,167,44,168,251,139,30,143,16,138},82,123))
    sideLayout.Padding = UDim.new(0, 1)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = sidebar

    local content = Instance.new(_V[1]({142,190,177,193,189},68,4))
    content.Name = _V[1]({33,126,174,229,7,65,120},173,49)
    content.Size = UDim2.new(1, -64, 1, -46)
    content.Position = UDim2.fromOffset(56, 38)
    content.BackgroundTransparency = 1
    content.Parent = main

    local pages = {}
    local tabData = {}
    local currentPage
    local refreshers = {}
    local activeSliderInput
    local activeSliderMove
    local searchableControls = {}
    local sectionGroups = {}
    local activeSectionByParent = {}
    local moduleStatusRefreshers = {}
    local scheduleConfigAutoSave = function() end
    local applySearch

    local searchBar = Instance.new(_V[1]({240,146,247,121,231},52,118))
    searchBar.Name = _V[1]({65,174,235,46,127,176,11,80,170,228,50},167,73)
    searchBar.Size = UDim2.new(1, -64, 0, 24)
    searchBar.Position = UDim2.fromOffset(56, 10)
    searchBar.BackgroundColor3 = C.Panel
    searchBar.BorderColor3 = C.Border
    searchBar.BorderSizePixel = 1
    searchBar.Parent = main
    local searchIcon = Instance.new(_V[1]({169,169,171,150,93,97,81,67,57},102,239))
    searchIcon.Size = UDim2.fromOffset(24, 22)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = _V[1]({204},80,62)
    searchIcon.TextColor3 = C.Lime
    searchIcon.Font = Enum.Font.Code
    searchIcon.TextSize = 13
    searchIcon.Parent = searchBar
    local searchBox = Instance.new(_V[1]({116,118,122,103,38,68,62},47,241))
    searchBox.Size = UDim2.new(1, -50, 1, 0)
    searchBox.Position = UDim2.fromOffset(23, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.ClearTextOnFocus = false
    searchBox.PlaceholderText = _V[1]({88,17,180,108,4,176,15,3,172,72,0,158,62,243,71,55,227,60,55,210,122,43,127,122,14,182,41,208,119},94,167)
    searchBox.PlaceholderColor3 = C.Muted
    searchBox.Text = _V[1]({},132,43)
    searchBox.TextColor3 = C.Text
    searchBox.Font = Enum.Font.Code
    searchBox.TextSize = 10
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchBar
    local clearSearch = Instance.new(_V[1]({227,118,11,137,217,142,15,145,14,143},13,130))
    clearSearch.Size = UDim2.fromOffset(24, 22)
    clearSearch.Position = UDim2.new(1, -25, 0, 0)
    clearSearch.BackgroundTransparency = 1
    clearSearch.Text = _V[1]({235},2,113)
    clearSearch.TextColor3 = C.Muted
    clearSearch.Font = Enum.Font.Code
    clearSearch.TextSize = 12
    clearSearch.Parent = searchBar
    clearSearch.Activated:Connect(function() searchBox.Text = _V[1]({},116,144) end)

    local CONTROL_HELP = {
        aimbotEnabled = _V[1]({192,102,221,103,247,135,188,133,204,170,29,176,53,184,252,216,77,230,99,233,128,180,133,18,159,29,160,41,108,72,196,73,140,87,235,114,242,125,3,153,30,153,32,100,50,189,65,208,80,148,107,234,44,10,133,9,163,226},228,136),
        silentAimEnabled = _V[1]({48,217,110,9,168,49,197,108,1,68,45,197,86,236,129,26,178,57,206,32,9,148,49,204,14,232,123,36,167,252,233,113,18,156,57,213,106,172,152,33,193,77,220,124,31,92,69,214,95,4,154,41,196,83,162,140,22,169,250,211,103,9,151,58,191,34},72,150),
        triggerbotEnabled = _V[1]({75,95,89,61,60,218,34,4,242,236,143,193,113,184,148,144,126,106,23,92,58,60,34,17,17,174,232,227,129,199,177,152,138,136,39,108,81,63,235,31,31,13,2,243,217,195,188,182,99},20,241),
        triggerbotDelay = _V[1]({154,204,231,248,18,48,62,7,97,120,149,160,206,139,227,252,33,58,62,84,115,59,146,188,209,226,246,0,41,52,68,23,129,149,162,182,204,224,3,199,48,59,88,115,136,89},55,22),
        triggerbotScopedOnly = _V[1]({91,23,168,60,213,98,160,101,20,156,43,188,75,233,106,8,158,219,192,76,142,101,249,147,23,99,67,211,98,0,56,32,162,52,200,82,158,112,192,159,35,199,77,235,107,183,155,28,185,75,209,29,247,146,208,162,53,215,93,251,123,213},137,145),
        triggerbotHeadOnly = _V[1]({245,208,132,63,252,183,129,46,248,186,35,38,230,172,92,39,145,157,89,20,222,66,86,4,190,132,243,4,181,111,231,232,166,114,32,219,169,87,19,140,145,79,23,128,141,59,9,200,49,55,254,104,121,42,228,92,97,27,212,148,27},228,189),
        rageBotEnabled = _V[1]({74,72,32,3,206,180,140,90,63,6,153,197,138,115,64,22,253,129,172,118,85,38,252,229,178,144,103,241,30,244,194,159,112,1,45,249,206,97,107,82,48,6,153,151,120,87,249,18,247,197,89,129,91,42,8,227,178,149,114,241,28,230,205,165,114,79,32,4,151},49,216),
        noRecoilEnabled = _V[1]({128,19,127,240,99,199,70,183,26,153,183,123,238,90,203,59,175,34,132,244,33,233,72,181,53,165,21,56,234,104,207,252,176,31,156,5,131,227,19,214,58,169,38,145,5,42,222,77,201,58,161,17,132,253,118,162},188,113),
        noSpreadEnabled = _V[1]({182,245,45,93,121,179,224,11,228,106,129,186,227,192,63,104,150,181,221,12,244,102,158,199,241,208,79,125,164,208,251,42,88,117,160,136,11,37,77,136,179,222,188,43,85,140,175,237,16,49,112,145,195,238,31,6},56,44),
        wallbangEnabled = _V[1]({218,219,177,138,104,58,189,198,178,139,90,57,21,151,142,140,102,239,25,234,113,154,98,63,14,226,201,75,117,56,31,234,190,163,120,251,37,239,207,162,126,70,29,171,212,172,127,73,26,242,202,174,76,7,52,252,221,167,132,96,53,183,214,183,57,87,46,255,213,172,139,19,61,0,231,178,134,107,64,195,218,193,138,27,50,19,244,180,162,114,245,29,230,193,146,102,77,20,233,137},195,214),
        thirdPersonEnabled = _V[1]({98,185,245,25,92,62,199,240,34,18,149,189,5,47,113,149,133,253,48,113,158,224,4,248,111,167,223,21,79,122,107,244,29,79,63,183,241,31,101,137,192,6,44,110,95},224,53),
        bunnyHopEnabled = _V[1]({72,28,216,146,81,255,113,99,8,159,123,91,28,215,65,82,254,195,113,227,228,169,96,32,211,131,62,247,109,123,42,232,158,93,16,131,126,69,245,107,116,47,237,156,92,21,194,135,245,240,178,117,221,218,160,89,25,209,136,63,187},59,186),
        bhopMode = _V[1]({42,212,84,207,14,227,89,232,111,230,114,232,121,169,118,4,127,5,56,4,140,17,153,27,101,205,113,40,170,40,169,32,182,46,171,235,185,54,185,71,205,253,200,82,214,89,213,93,217,21,239,99,231,109,233,39,247,124,6,120,3,126,10,147,194,142,27,75,15,148,40,160,48,162,238},95,131),
        bhopMovingOnly = _V[1]({226,80,143,236,39,124,206,25,18,159,255,74,145,219,27,122,187,1,10,160,247,59,138,217,210,117,178,255,78,147,154,52,129,126,23,101,184,243,71,139,224,50,42,186,11,96,159,233,70,135,217,36,34,183,13,6,162,240,47,137,213,19,94,116},70,76),
        bhopPauseWithMenu = _V[1]({113,98,86,52,6,244,129,131,137,112,81,225,24,233,202,173,134,33,85,41,6,161,185,132,65,110,70,47,22,161,208,179,65,98,1,53,6,249,213,97,131,112,89,225,10,244,129,176,145,102,79,239},65,224),
        bhopGroundDelay = _V[1]({9,128,221,40,150,147,42,133,233,48,147,151,65,146,238,50,141,228,63,142,157,71,145,228,245,146,243,70,162,241,61,79,231,64,151,246,79,152,169,83,157,240,1,165,242,91,173,175,79,176,254,87,107},111,86),
        bhopAcceleration = _V[1]({32,168,17,27,205,50,135,226,75,173,27,35,204,52,152,240,98,184,24,127,205,57,78,5,85,189,33,118,221,73,175,183,89,201,42,141,235,62,161,7,101,212,226,151,236,74,102,10,119,215,48,148,243,98,192,20,116,145,20,155,3,101,118,42,136,222,63,159,202},119,97),
        flightEnabled = _V[1]({19,151,0,81,193,208,134,220,59,88,253,100,191,50,131,231,90,173,28,44,207,60,161,2,93,120,46,132,227,0,165,5,115,205,60,141,174,84,187,38,123,219,78,165,13,110,144},100,98),
        chamsEnabled = _V[1]({157,142,92,57,180,195,80,106,59,253,201,162,36,58,9,213,164,118,65,13,220,182,48,82,27,154,190,119,80,27,228,110,140,86,25,255,185,148,16,43,251,190,141,98,55,192},142,206),
        skeletonEspEnabled = _V[1]({227,37,40,82,98,35,120,75,171,188,206,227,3,26,28,52,70,91,123,59,129,121,134,189,176,200,199,46,58,72,99,112,147,162,181,123,208,247,183,222,239,243,92,107,115,132,171,176,210,147,247,0,33,227,74,80,98,130,149,159,125},139,20),
        skeletonDistanceFade = _V[1]({2,190,62,210,116,241,141,30,188,244,203,87,235,125,28,90,62,199,82,234,116,20,160,48,115,80,222,116,252,155,217,171,79,140,105,253,141,23,97,54,204,103,249,119,21,155,46,205,25},42,145),
        noSmokeEnabled = _V[1]({211,35,88,113,157,210,246,47,7,118,162,220,248,33,93,121,163,138,215,44,90,142,148,224,9,43,88,125,99,225,6,51,90,127,101,213,8,47,101,144,172,228,16,232,84,140,173,148,17,47,104,148,186,232,6,63,23,150,181,221,16,238,112,140,180,232,197,68,112,152,191,225,11,242,108,142,185,172},100,43),
        hitSoundEnabled = _V[1]({73,54,252,229,176,46,83,24,230,114,150,89,49,251,202,172,110,62,203,232,188,129,80,44,177,213,162,121,67,10,151,191,129,79,41,172,194,156,100,61,26,146,171,121,70,34,251,192,73,94,48,255,223,163,112,83,22,245,129},40,209),
        antiAimMode = _V[1]({4,71,102,145,117,143,247,28,68,114,164,180,235,3,56,23,49,161,198,247,29,52,103,71,97,217,238,33,61,110,146,107,224,9,221,86,125,144,201,228,4,231,78,129,173,200,178,12,58,100,61,167,210,1,26,62,117,144,188,225,199},139,38),
        nightModeEnabled = _V[1]({178,150,75,252,174,95,34,132,141,54,232,88,96,7,195,113,36,234,144,68,181,182,104,27,209,146,60,246,164,18,23,206,118,57,224,164,5,6,190,103,26,218,143,81,187},188,181),
        worldSkyboxEnabled = _V[1]({160,160,113,62,12,217,184,54,91,32,238,122,158,97,57,3,210,180,118,70,211,231,202,153,107,55,6,138,174,119,86,16,238,200,65,94,50,247,198,162,115,81,215},142,209),
        worldPostFXEnabled = _V[1]({177,56,137,232,80,167,19,30,200,41,123,215,64,82,243,93,184,25,122,134,39,145,242,80,161,253,108,191,35,128,144,47,154,238,8,182,19,117,212,235,140,236,71,153,249,101,195,23,122,209,246},14,94),
        worldSkyboxPreset = _V[1]({242,136,19,144,18,167,42,91,32,99,51,186,50,180,67,123,82,206,96,139,95,229,92,238,100,247,39,241,129,2,132,187,147,11,140,203,162,40,167,43,171,44,172,47,111,42,198,77,203,71,135,97,216,102,236,92,235,35,250,110,1,124,7,143,18,81},27,132),
        worldTonePreset = _V[1]({195,50,114,174,235,39,117,98,227,226,101,177,241,52,102,171,240,35,118,167,230,226,118,171,240,54,34,178,244,39,117,167,246,226,118,177,162,18,113,181,246,226,72,154,162,35,112,166,162,35,118,175,241,53,114,170,231,52,103,112},66,64),
        worldAtmosphereEnabled = _V[1]({147,18,110,217,226,127,154,57,161,252,80,175,9,115,204,23,116,218,47,70,238,77,157,247,94,110,235,122,207,45,141,230,58,147,252,75,98,21,99,202,26,125,223,58,66,226,63,162,247,98,179,20,105,126,46,126,215,238,145,231,79,163,193,105,114,29,124,207,41,135,232,55,158,174,89,180,7,44},246,92),
        worldBloomEnabled = _V[1]({111,147,148,164,82,148,84,161,159,158,160,173,177,160,165,164,166,179,96,173,177,166,165,177,102,137,180,184,185,184,108,178,180,181,181,180,198,115,203,190,202,191,120,188,201,201,194,198,197,212,210,194,196,207,201,133,207,213,220,206,216,222,213,225,231,157},45,1),
        weatherEnabled = _V[1]({246,247,201,165,142,32,85,33,251,236,190,153,132,16,58,13,3,205,184,82,34,53,49,1,237,120,165,130,87,240,30,237,220,188,143,103,78,37,190,225,199,161,138,104,55,34,174,224,185,72,103,90,49,9,226,124,160,138,87,65,23,176,225,188,147,115,75,55,208},204,222),
        weatherMode = _V[1]({165,148,124,97,255,211,6,225,194,170,63,19,57,34,250,147,194,165,51,84,70,27,193,147,167,155,120,19,56,25,249,216,182,167,51,89,66,31,255,226,202,166,51,103,59,24,179,212,182,167,124,105,56,211,246,212,192,152,133,84,1},115,224),
        weatherIntensity = _V[1]({59,87,70,60,42,23,4,251,152,216,185,186,172,145,123,116,93,8,74,41,44,13,184,247,234,136,190,183,159,72,124,109,102,91,65,60,49,214},8,240),
        weatherWind = _V[1]({70,142,178,202,252,18,50,89,103,147,104,205,252,20,50,97,46,158,182,145,4,20,61,99,66,87,203,231,9,50,252,94,140,163,128,226,21,43,4,117,135,185,220,242,13,55,81,128,92},221,33),
        freecamEnabled = _V[1]({209,226,225,190,176,165,146,144,45,113,85,66,237,32,14,10,242,239,206,139,109,148,110,112,81,29,90,76,67,34,32,201,173,208,221,190,176,162,92,98,45,111,86,80,50,48,217,189,222,172,176,209,191,169,77,137,124,116,82,79,64,233,205,240,245,230,211,209,109,159,156,140,128,113,96,11},157,240),
        freecamSpeed = _V[1]({43,222,118,246,143,24,178,73,134,106,248,126,15,159,236,204,84,159,132,9,151,227,184,74,234,104,251,145,31,175,252,208,95,252,133,35,163,1},77,145),
        freecamKey = _V[1]({101,64,249,164,82,26,117,125,37,210,153,249,1,176,92,16,201,118,56,153,115,83,250,174,96,18,210,57,68,234,169,81,12,198,121,217,220,145,58,247,166,95,12,121,129,41,218,73,74,246,179,110,219},105,180),
        freelookEnabled = _V[1]({167,203,215,203,229,221,242,166,1,252,0,194,31,25,28,53,229,53,65,250,81,84,80,89,98,36,130,123,141,136,150,163,169,92,176,185,199,193,205,205,141,232,227,231,169,243,255,255,23,13,22,46,38,58,239,69,79,4,78,83,102,101,121,111,53,139,149,147,152,161,173,116},78,7),
        freelookSensitivity = _V[1]({13,113,185,249,45,42,191,243,62,133,189,10,65,144,197,18,89,66,217,25,77,142,140,16,105,82,186,40,93,159,232,45,111,173,178},126,66),
        freelookKey = _V[1]({101,132,129,112,98,110,13,89,69,54,65,229,49,36,20,12,9,250,0,165,195,231,210,202,201,196,188,176,93,172,150,153,133,132,130,121,29,100,93,74,75,62,59,44,221,41,21,10,189,2,242,243,242,163},37,248),
        streamerModeEnabled = _V[1]({231,238,203,191,172,159,62,110,70,53,30,195,240,216,209,191,170,145,110,19,74,54,21,0,191,143,205,168,154,135,112,93,54,49,18,255,246,135,185,164,137,116,108,3,37,250,193,250,235,196,187,159,126,128,100,251,60,24,13,235,220,204,181,75,121,100,85,56,49,16,255,226,133,195,161,136,118,105,1,62,26,19,253,220,203,174,164,73},171,234),
        streamerKey = _V[1]({151,212,239,252,12,54,243,79,110,135,75,178,204,214,230,4,27,62,251,89,112,129,156,183,198,149,250,19,215,63,72,108,131,148,173,186,213,228,179,1,2,245,90,119,124,159,175,186,232,248,201},57,22),
        priorityPlayerName = _V[1]({73,159,203,14,74,140,109,246,43,89,170,207,21,252,136,179,243,37,92,166,208,8,253,119,194,168,53,98,152,140,21,80,124,182,238,52,109,153,209,198,83,121,195,241,40,112,99,142,251,72,126,114,247,45,112,170,143,29,84,127,198,172,49,103,173,213,201,85,128,198,3,43,113,88,230,29,72,142,195,239,52,101,172,160},190,57),
        customScopeEnabled = _V[1]({181,243,242,24,36,225,69,73,86,33,105,100,81,180,180,208,225,230,177,16,39,38,67,77,82,122,49,152,153,166,191,129,228,228,0,17,22,37,255},97,16),
        customHandsEnabled = _V[1]({34,87,117,160,176,221,250,197,55,73,100,61,159,190,235,250,22,69,84,113,75,175,208,247,22,53,12,109,128,171,202,228,1,209,70,82,108,153,182,211,163,16,49,253,99,122,165,185,230,177,28,60,79,110,147,115},181,30),
        grenadeEspEnabled = _V[1]({216,170,110,51,236,86,102,36,230,150,76,8,129,133,77,253,195,115,51,241,105,114,36,226,162,102,42,160,81,80,26,221,147,69,4,124,141,72,244,186,114,45,251,179,115,55,155,153,99,22,143,152,74,20,199,137,75,1,119,129,50,0,182,109,55,176},200,189),
        showGrenadePath = _V[1]({227,167,60,221,132,32,211,116,195,185,79,238,75,52,225,118,33,182,91,254,91,62,241,132,227,220,112,29,179,13,2,166,69,219,120,28,192,29,1,176,88,243,138,46,222,45,16,191,87,181,152,249,231,126,45,197,108,19,174,9,248,142,65,220,120,39,133},241,162),
        grenadeDangerZonesEnabled = _V[1]({84,67,243,202,135,245,6,188,138,76,10,192,127,81,7,213,133,14,5,210,150,87,11,202,156,9,29,216,155,88,19,155,80,87,27,229,153,21,23,229,156,25,33,237,161,107,31,227,165,33,38,228,178,108,43,249,104,123,51,249,179,128,252},79,193),
        showMolotovRadius = _V[1]({59,90,107,125,131,58,152,150,157,98,188,200,207,212,217,225,252,247,0,198,22,35,54,51,248,71,82,92,101,109,136,62,154,147,160,175,197,205,132,221,230,162,0,254,5,202,27,48,55,71,74,74,30},222,10),
        showSmokeRadius = _V[1]({52,105,144,184,212,161,21,41,70,33,145,179,208,235,6,36,85,102,133,97,212,238,16,44,70,33,134,167,199,230,4,53,1,115,130,165,202,246,20,225,80,111,65,181,201,230,193,40,83,112,150,175,197,175},193,32),
        grenadeDangerOpacity = _V[1]({23,194,64,197,66,190,58,192,236,175,43,183,47,172,56,114,54,172,48,168,224,181,39,176,37,157,35,165,33,171,47,85,43,156,38,153,31,164,34,77,15,147,11,151,15,144,20,140,196,151,20,130,10,132,1,145,11,141,19,57,250,137,255,124,252,135,0,118,3,130,188},85,127),
        weaponEspEnabled = _V[1]({47,198,79,217,87,134,73,138,79,221,93,226,85,217,108,154,104,231,109,231,36,253,109,235,124,253,126,178,135,255,132,2,139,19,133,22,152,11,72,12,145,26,159,41,84,42,160,31,92,46,172,35,189,43,186,234,174,61,200,0},90,130),
        spectatorListEnabled = _V[1]({134,7,122,238,86,111,43,147,244,120,208,73,182,207,126,252,101,209,48,165,23,123,244,7,194,33,158,252,117,229,68,181,26,63,255,95,200,239,167,22,118,224,87,119,51,155,252,128,216,81,107,46,139,244,105,135,55,164,31,124,230,99,188,41,159,4,57},199,108),
        settingsAutoSave = _V[1]({153,216,30,62,125,91,224,5,51,31,147,214,4,53,89,147,202,167,40,91,137,177,229,25,67,47,179,217,17,69,120,161,223,183,41,95,158,192,254,221,79,63,165,202,210,86,121,185,234,16,70,112,90,206,4,46,108,150,197,4,240},21,49),
        menuKey = _V[1]({3,106,203,1,91,154,248,55,64,224,34,118,198,21,81,176,252,245,151,226,33,109,118,23,95,93,253,63,147,232,222,122,202,197,90,168,240,62,70,203,3,59},107,77),
        tab_Rage = _V[1]({180,54,138,213,42,147,175,235,130,224,58,67,218,66,152,228,68,155,222,65,157,242,1,75,245,56,159,234,62,163,238,73,152,167,62,161,237,255,172,240,66,167,252,81,89,252,74,158,249,72,171,252,76,178,195},27,86),
        tab_AntiAim = _V[1]({104,108,85,38,16,234,213,189,101,45,80,63,39,254,164,186,164,138,43,1,55,13,240,219,175,77,127,86,69,40,6,231,135,93,129,105,82,53,211,169,222,185,152,117,88,245,24,7,223,125,165,141,108,76,47,29,185},57,226),
        tab_Visuals = _V[1]({84,196,43,138,211,59,159,195,6,136,243,77,134,215,119,217,47,152,251,5,163,13,96,121,37,129,157,64,141,249,73,166,12,27,187,36,127,209,45,157,166,73,165,2,94,185,21,116,217,249},161,93),
        tab_World = _V[1]({172,38,139,231,65,121,193,111,206,46,145,255,86,189,24,63,149,78,158,252,113,199,38,149,177,7,188,14,124,223,54,83,246,101,189,219,128,224,78,168,23,104,137,63,156,254,93,198,227},243,98),
        tab_Misc = _V[1]({133,56,193,88,233,136,17,161,67,158,24,255,133,39,187,69,223,114,184,148,37,192,88,225,130,23,100,236,193,98,241,137,17,184,65,219,110,7,72,29,190,72,152,130,9,153,63,201,95,232,125,24,96,55,215,106,4,150,39,184,83,162},156,148),
        tab_Skins = _V[1]({173,139,76,244,182,117,41,229,165,5,1,191,113,55,233,160,102,231,134,150,61,242,186,114,42,149,148,80,14,194,133,51,233,176,34,207,223,134,59,5,120,37,41,229,153,95,7,206,52,46,244,163,24,24,214,146,82,250,193,53},171,185),
        tab_Players = _V[1]({83,149,176,238,0,51,90,71,83,205,224,23,50,86,139,93,213,254,27,58,110,77,103,221,5,34,78,119,148,197,240,189,51,85,112,174,192,243,199,46,97,125,95,170,222,1,247,97,136,189,208,254,39,84,53},221,38),
        tab_Configs = _V[1]({153,183,210,222,223,240,245,13,224,210,39,56,74,71,96,96,103,117,131,86,86,179,195,195,201,221,158,235,249,22,23,41,52,69,254,75,100,102,46,125,149,160,164,179,189,215,224,219,250,251,13,24,214,50,64,73,76,91,106,111,137,80},58,12),
    }

    local helpPopup = Instance.new(_V[1]({167,191,154,146,118},117,236))
    helpPopup.Name = _V[1]({118,89,15,204,116,62,241,124,80,14,201},124,183)
    helpPopup.Size = UDim2.fromOffset(UserInputService.TouchEnabled and 260 or 235, 0)
    helpPopup.AutomaticSize = Enum.AutomaticSize.Y
    helpPopup.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    helpPopup.BorderColor3 = C.Lime
    helpPopup.BorderSizePixel = 1
    helpPopup.Visible = false
    helpPopup.ZIndex = 300
    helpPopup.Parent = screenGui
    local helpPadding = Instance.new(_V[1]({103,152,220,42,106,167,233,43,97},213,61))
    helpPadding.PaddingTop = UDim.new(0, 7)
    helpPadding.PaddingBottom = UDim.new(0, 7)
    helpPadding.PaddingLeft = UDim.new(0, 9)
    helpPadding.PaddingRight = UDim.new(0, 9)
    helpPadding.Parent = helpPopup
    local helpText = Instance.new(_V[1]({95,174,255,57,79,162,225,34,103},205,62))
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
        if not message or message == _V[1]({},205,182) or not target or not target.Parent then return end
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
        local touchHelpShown = false
        target.MouseEnter:Connect(function() showHelp(target, message) end)
        target.MouseLeave:Connect(hideHelp)
        target.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch then return end
            touchHelpShown = false
            helpToken += 1
            local token = helpToken
            task.delay(0.45, function()
                if token == helpToken then
                    touchHelpShown = true
                    target:SetAttribute(_V[1]({106,54,32,36,4,222,168,171,127,110,79,18,12,243,201,173},49,225), os.clock() + 0.4)
                    showHelp(target, message)
                end
            end)
        end)
        target.InputEnded:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch then return end
            if touchHelpShown then
                local shownToken = helpToken
                task.delay(2.5, function()
                    if shownToken == helpToken then hideHelp() end
                end)
            else
                hideHelp()
            end
        end)
    end

    local function createPage(name)
        local page = Instance.new(_V[1]({203,113,218,96,210},11,122))
        page.Name = name
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = content
        pages[name] = page
        return page
    end

    local function createPanel(page, title, x, width)
        local panel = Instance.new(_V[1]({189,244,238,5,8},108,11))
        panel.Name = title
        panel.Size = UDim2.new(width, 0, 1, 0)
        panel.Position = UDim2.new(x, 0, 0, 0)
        panel.BackgroundColor3 = C.Panel
        panel.BorderColor3 = C.Border
        panel.BorderSizePixel = 1
        panel.Parent = page

        local titleLabel = Instance.new(_V[1]({221,174,129,61,213,170,107,46,245},201,192))
        titleLabel.Size = UDim2.new(1, -16, 0, 24)
        titleLabel.Position = UDim2.fromOffset(8, 3)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = C.Text
        titleLabel.Font = Enum.Font.Code
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = panel

        local scroll = Instance.new(_V[1]({201,90,234,104,230,103,229,107,229,69,242,98,239,104},245,129))
        scroll.Name = _V[1]({230,221,167,120,65,9,209,163},216,203)
        scroll.Size = UDim2.new(1, -14, 1, -32)
        scroll.Position = UDim2.fromOffset(7, 28)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 2
        scroll.ScrollBarImageColor3 = C.Border
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new()
        scroll.Parent = panel

        local layout = Instance.new(_V[1]({24,1,249,11,10,0,205,215,228,207,202,190},206,245))
        layout.Padding = UDim.new(0, 4)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll
        local padding = Instance.new(_V[1]({57,148,2,122,228,75,183,35,131},125,103))
        padding.PaddingLeft = UDim.new(0, 7)
        padding.PaddingRight = UDim.new(0, 7)
        padding.PaddingBottom = UDim.new(0, 9)
        padding.Parent = scroll
        return scroll
    end

    local function section(parent, text)
        local outer = Instance.new(_V[1]({85,195,244,66,124},205,66))
        outer.Name = _V[1]({34,200,90,255,136,34,181,58},59,148) .. text:gsub(_V[1]({240,214},23,180), _V[1]({217},223,155))
        outer.Size = UDim2.new(1, 0, 0, 0)
        outer.AutomaticSize = Enum.AutomaticSize.Y
        outer.BackgroundTransparency = 1
        outer.Parent = parent
        local outerLayout = Instance.new(_V[1]({160,84,23,244,190,127,23,236,196,122,64,255},139,192))
        outerLayout.Padding = UDim.new(0, 5)
        outerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        outerLayout.Parent = outer

        local header = Instance.new(_V[1]({234,225,218,188,112,137,110,84,53,26},176,230))
        header.Size = UDim2.new(1, 0, 0, 24)
        header.LayoutOrder = 1
        header.BackgroundTransparency = 1
        header.BorderSizePixel = 0
        header.Text = _V[1]({},230,37)
        header.AutoButtonColor = false
        header.Parent = outer

        local title = Instance.new(_V[1]({112,103,96,66,0,251,226,203,184},54,230))
        title.Name = _V[1]({165,230,19,83,119,172,218,239,51,109,148,188},35,47)
        title.Size = UDim2.new(1, -26, 0, 18)
        title.Position = UDim2.fromOffset(1, 0)
        title.BackgroundTransparency = 1
        title.Text = text:upper()
        title.TextColor3 = C.White
        title.Font = Enum.Font.Code
        title.TextSize = 11
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = header

        local collapseIcon = Instance.new(_V[1]({3,9,17,2,207,217,207,199,195},186,245))
        collapseIcon.Name = _V[1]({135,30,134,241,81,203,57,150,229,106,225,75},217,107)
        collapseIcon.Size = UDim2.fromOffset(20, 18)
        collapseIcon.Position = UDim2.new(1, -20, 0, 0)
        collapseIcon.BackgroundTransparency = 1
        collapseIcon.Text = _V[1]({162},135,165)
        collapseIcon.TextColor3 = C.Lime
        collapseIcon.Font = Enum.Font.Code
        collapseIcon.TextSize = 11
        collapseIcon.Parent = header

        local accentLine = Instance.new(_V[1]({233,39,40,70,80},145,18))
        accentLine.Name = _V[1]({102,75,23,215,126,107,64,251,190,135,92},82,200)
        accentLine.Size = UDim2.new(1, 0, 0, 1)
        accentLine.Position = UDim2.new(0, 0, 1, -2)
        accentLine.BackgroundColor3 = C.Lime
        accentLine.BackgroundTransparency = 0.08
        accentLine.BorderSizePixel = 0
        accentLine.Parent = header

        local lineFade = Instance.new(_V[1]({203,176,159,187,155,143,133,114,108,99},133,241))
        lineFade.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.72, 0.28),
            NumberSequenceKeypoint.new(1, 1),
        })
        lineFade.Parent = accentLine

        local body = Instance.new(_V[1]({30,213,79,230,105},77,139))
        body.Name = _V[1]({195,2,9,48},111,18)
        body.Size = UDim2.new(1, 0, 0, 0)
        body.LayoutOrder = 2
        body.AutomaticSize = Enum.AutomaticSize.Y
        body.BackgroundTransparency = 1
        body.Parent = outer
        local bodyLayout = Instance.new(_V[1]({165,118,86,80,55,21,202,188,177,132,103,67},115,221))
        bodyLayout.Padding = UDim.new(0, 4)
        bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
        bodyLayout.Parent = body

        local group = {outer = outer, body = body, header = header, collapsed = false}
        table.insert(sectionGroups, group)
        activeSectionByParent[parent] = body
        header.Activated:Connect(function()
            group.collapsed = not group.collapsed
            body.Visible = not group.collapsed
            collapseIcon.Text = group.collapsed and _V[1]({164},147,211) or _V[1]({146},79,205)
            title.TextColor3 = group.collapsed and C.Text or C.White
            accentLine.BackgroundTransparency = group.collapsed and 0.45 or 0.08
        end)
        return body
    end

    local function registerSearch(gui, label)
        table.insert(searchableControls, {gui = gui, label = tostring(label):lower()})
    end

    local function refreshConfigControls(key, value)
        for _, refreshControl in ipairs(refreshers[key] or {}) do pcall(refreshControl, value) end
    end

    local function getModuleRuntimeStatus(key)
        if XCConfig[key] ~= true then return _V[1]({176,240,57},24,73), C.Muted end
        if key == _V[1]({26,28,36,51,18,65,68,91,94,102,125,90,141,138,149,169,172,181},157,10) then
            if skinData.LastError then return _V[1]({134,188,229},24,41), Color3.fromRGB(218, 82, 82) end
            if not skinData.Ready then return _V[1]({17,122,1,139},59,127), Color3.fromRGB(220, 170, 72) end
        elseif key == _V[1]({218,163,101,22,170,142,78,226,199,118,51,249,174,105},189,188) or key == _V[1]({19,226,151,83,26,165,136,69,214,187,106,39,237,162,93},245,188) then
            if not xcCharacterInputHook.Ready and xcCharacterInputHook.LastError then
                return _V[1]({8,18,44,59},179,15), Color3.fromRGB(220, 170, 72)
            end
            if not xcCharacterInputHook.Ready then return _V[1]({161,72,13,213},141,189), Color3.fromRGB(220, 170, 72) end
        elseif key == _V[1]({55,114,186,248,70,145,163,16,89,118,228,28,98,177,239,51},127,69) and not xcNativeSilentHooked then
            return _V[1]({19,80,171,9},105,83), Color3.fromRGB(220, 170, 72)
        end
        return _V[1]({226,57},59,88), C.Lime
    end

    local function addToggle(parent, label, key, onChanged)
        parent = activeSectionByParent[parent] or parent
        local row = Instance.new(_V[1]({51,79,109,116,77,139,149,160,166,176},212,11))
        row.Name = key
        row.Size = UDim2.new(1, 0, 0, UserInputService.TouchEnabled and 28 or 22)
        row.BackgroundTransparency = 1
        row.Text = _V[1]({},30,26)
        row.AutoButtonColor = false
        row.Parent = parent
        local text = Instance.new(_V[1]({136,25,172,40,128,21,150,25,160},180,128))
        text.Size = UDim2.new(1, -76, 1, 0)
        text.Position = UDim2.fromOffset(0, 0)
        text.BackgroundTransparency = 1
        text.Text = label
        text.TextColor3 = C.Text
        text.Font = Enum.Font.Code
        text.TextSize = 11
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Parent = row

        local statusText = Instance.new(_V[1]({230,192,156,97,2,224,170,118,70},201,201))
        statusText.Name = _V[1]({124,96,26,225,151,92,21,196,166,84,40,234,169},105,193)
        statusText.Size = UDim2.fromOffset(34, 14)
        statusText.Position = UDim2.new(1, -67, 0.5, -7)
        statusText.BackgroundColor3 = C.Control
        statusText.BackgroundTransparency = 0.15
        statusText.BorderSizePixel = 0
        statusText.Font = Enum.Font.Code
        statusText.TextSize = 8
        statusText.TextXAlignment = Enum.TextXAlignment.Center
        statusText.Parent = row
        local statusCorner = Instance.new(_V[1]({198,15,94,223,55,136,212,54},28,85))
        statusCorner.CornerRadius = UDim.new(0, 3)
        statusCorner.Parent = statusText

        local track = Instance.new(_V[1]({102,4,101,227,77},174,114))
        track.Name = _V[1]({7,185,57,210,79,226,92,8,133,21,171},38,142)
        track.Size = UDim2.fromOffset(27, 13)
        track.Position = UDim2.new(1, -28, 0.5, -6)
        track.BackgroundColor3 = C.Control2
        track.BorderColor3 = C.Black
        track.BorderSizePixel = 1
        track.Parent = row
        local trackCorner = Instance.new(_V[1]({24,134,250,160,29,147,4,139},73,122))
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track

        local knob = Instance.new(_V[1]({122,70,213,129,25},148,160))
        knob.Name = _V[1]({51,108,131,140},210,22)
        knob.Size = UDim2.fromOffset(9, 9)
        knob.Position = UDim2.new(0, 2, 0.5, -4)
        knob.BackgroundColor3 = C.Muted
        knob.BorderSizePixel = 0
        knob.Parent = track
        local knobCorner = Instance.new(_V[1]({252,16,42,118,153,181,204,249},135,32))
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob

        local function refreshStatus()
            local state, color = getModuleRuntimeStatus(key)
            local background = state == _V[1]({230,109,231},39,122) and Color3.fromRGB(45, 18, 18)
                or (state == _V[1]({92,50,38,29},25,236) or state == _V[1]({250,51,124,186},118,62)) and Color3.fromRGB(43, 34, 17) or C.Control
            if statusText.Text ~= state then statusText.Text = state end
            if statusText.TextColor3 ~= color then statusText.TextColor3 = color end
            if statusText.BackgroundColor3 ~= background then statusText.BackgroundColor3 = background end
        end
        local function refresh(value)
            track.BackgroundColor3 = value and Color3.fromRGB(76, 102, 0) or C.Control2
            knob.BackgroundColor3 = value and C.Lime or C.Muted
            knob.Position = value and UDim2.new(1, -11, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
            text.TextColor3 = value and C.White or C.Text
            refreshStatus()
        end
        refresh(XCConfig[key] == true)
        UI_Bind_Registry[key] = refresh
        refreshers[key] = refreshers[key] or {}
        table.insert(refreshers[key], refresh)
        table.insert(moduleStatusRefreshers, function()
            if row.Parent then refreshStatus() end
        end)
        row.Activated:Connect(function()
            if os.clock() < (row:GetAttribute(_V[1]({204,51,184,87,210,71,172,74,185,67,191,29,178,52,165,36},248,124)) or 0) then return end
            XCConfig[key] = not XCConfig[key]
            refreshConfigControls(key, XCConfig[key])
            if onChanged then onChanged(XCConfig[key]) end
            scheduleConfigAutoSave()
            if key ~= _V[1]({164,114,93,57,10,235,192,168,100,85,56,28,207,204,173,126,87,54,12,230,213,166,136,99,68},85,220) then
                XCNotify(label, XCConfig[key] and _V[1]({75,15,157,57,222,114,12},107,155) or _V[1]({180,106,5,132,22,177,59,203},223,145), XCConfig[key] and _V[1]({201,79,193,69,203,93,225},210,132) or _V[1]({152,146,179,191,202,223,232},17,16), 1.5)
            end
        end)
        attachHelp(row, key)
        registerSearch(row, label .. _V[1]({132},73,27) .. key)
        return row
    end

    local function addSlider(parent, label, key, minValue, maxValue, step, suffix, onChanged)
        parent = activeSectionByParent[parent] or parent
        local holder = Instance.new(_V[1]({188,77,161,18,111},17,101))
        holder.Name = key
        holder.Size = UDim2.new(1, 0, 0, 36)
        holder.BackgroundTransparency = 1
        holder.Active = true
        holder.Parent = parent
        local name = Instance.new(_V[1]({25,227,175,100,245,195,125,57,249},12,185))
        name.Size = UDim2.new(0.68, 0, 0, 16)
        name.BackgroundTransparency = 1
        name.Text = label
        name.TextColor3 = C.Text
        name.Font = Enum.Font.Code
        name.TextSize = 10
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.Parent = holder
        local valueLabel = Instance.new(_V[1]({51,216,127,15,123,36,185,80,235},75,148))
        valueLabel.Size = UDim2.new(0.32, 0, 0, 16)
        valueLabel.Position = UDim2.new(0.68, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.TextColor3 = C.Text
        valueLabel.Font = Enum.Font.Code
        valueLabel.TextSize = 10
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = holder
        local bar = Instance.new(_V[1]({67,95,62,58,34},13,240))
        bar.Size = UDim2.new(1, 0, 0, 7)
        bar.Position = UDim2.fromOffset(0, 21)
        bar.BackgroundColor3 = C.Control2
        bar.BorderColor3 = C.Black
        bar.BorderSizePixel = 1
        bar.Active = true
        bar.Parent = holder
        local fill = Instance.new(_V[1]({235,155,14,158,26},33,132))
        fill.BorderSizePixel = 0
        fill.BackgroundColor3 = C.Lime
        fill.Parent = bar
        local function refresh(value)
            value = math.clamp(tonumber(value) or minValue, minValue, maxValue)
            fill.Size = UDim2.new((value - minValue) / (maxValue - minValue), 0, 1, 0)
            local shown = step < 0.01 and string.format(_V[1]({93,144,191,28},14,42), value)
                or step < 1 and string.format(_V[1]({104,99,89,127},81,242), value)
                or tostring(math.floor(value + 0.5))
            valueLabel.Text = shown .. (suffix or _V[1]({},108,25))
        end
        local function setFromX(x)
            if bar.AbsoluteSize.X <= 0 then return end
            local pct = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local raw = minValue + (maxValue - minValue) * pct
            local value = math.floor(raw / step + 0.5) * step
            XCConfig[key] = value
            refreshConfigControls(key, value)
            if onChanged then onChanged(value) end
            scheduleConfigAutoSave()
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
        registerSearch(holder, label .. _V[1]({154},1,121) .. key)
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

        local popup = Instance.new(_V[1]({160,156,151,128,105,85,62,47,20,223,247,210,202,174},97,236))
        popup.Name = _V[1]({47,27,225,196,152,58,58,9,220,162,127,89,34,229},10,210) .. key
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

        local popupStroke = Instance.new(_V[1]({6,105,226,114,223,75,182,31},66,111))
        popupStroke.Color = C.Black
        popupStroke.Thickness = 1
        popupStroke.Parent = popup

        local layout = Instance.new(_V[1]({116,248,139,56,210,99,203,112,24,158,52,195},143,144))
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = popup

        for index, option in ipairs(values) do
            local selected = XCConfig[key] == option
            local optionButton = Instance.new(_V[1]({94,21,206,112,228,189,98,8,169,78},100,166))
            optionButton.Name = tostring(option)
            optionButton.LayoutOrder = index
            optionButton.Size = UDim2.new(1, 0, 0, rowHeight)
            optionButton.BackgroundColor3 = selected and Color3.fromRGB(32, 39, 17) or Color3.fromRGB(18, 18, 18)
            optionButton.BorderSizePixel = 0
            optionButton.Text = _V[1]({},236,183)
            optionButton.Font = Enum.Font.Code
            optionButton.TextSize = UserInputService.TouchEnabled and 11 or 10
            optionButton.AutoButtonColor = false
            optionButton.ZIndex = 201
            optionButton.Parent = popup

            local optionText = Instance.new(_V[1]({135,176,219,239,223,12,37,64,95},27,24))
            optionText.Size = UDim2.new(1, -28, 1, 0)
            optionText.Position = UDim2.fromOffset(19, 0)
            optionText.BackgroundTransparency = 1
            optionText.Text = tostring(option)
            optionText.TextColor3 = selected and C.White or C.Text
            optionText.Font = Enum.Font.Code
            optionText.TextSize = UserInputService.TouchEnabled and 11 or 10
            optionText.TextXAlignment = Enum.TextXAlignment.Left
            optionText.ZIndex = 202
            optionText.Parent = optionButton

            local marker = Instance.new(_V[1]({26,111,135,188,221},171,41))
            marker.Name = _V[1]({154,85,5,167,78,8,166,85,253,133,66,252,158,65,247},158,169)
            marker.Size = UDim2.fromOffset(selected and 7 or 4, selected and 7 or 4)
            marker.Position = UDim2.new(0, 7, 0.5, selected and -3 or -2)
            marker.BackgroundColor3 = selected and C.Lime or C.Border
            marker.BorderSizePixel = 0
            marker.ZIndex = 202
            marker.Parent = optionButton
            local markerCorner = Instance.new(_V[1]({0,67,140,7,89,164,234,70},92,79))
            markerCorner.CornerRadius = UDim.new(1, 0)
            markerCorner.Parent = marker

            optionButton.MouseEnter:Connect(function()
                optionButton.BackgroundColor3 = selected and Color3.fromRGB(38, 48, 18) or C.Control2
                optionText.TextColor3 = C.White
            end)
            optionButton.MouseLeave:Connect(function()
                optionButton.BackgroundColor3 = selected and Color3.fromRGB(32, 39, 17) or Color3.fromRGB(18, 18, 18)
                optionText.TextColor3 = selected and C.White or C.Text
            end)
            optionButton.Activated:Connect(function()
                XCConfig[key] = option
                refreshConfigControls(key, option)
                if onChanged then onChanged(option) end
                scheduleConfigAutoSave()
                closeDropdown()
            end)
        end

        local selectedIndex = table.find(values, XCConfig[key]) or 1
        popup.CanvasPosition = Vector2.new(0, math.max(0, (selectedIndex - 2) * rowHeight))
        activeDropdown = {popup = popup, button = button, key = key}
    end

    local function addChoice(parent, label, key, values, onChanged)
        parent = activeSectionByParent[parent] or parent
        local holder = Instance.new(_V[1]({191,28,60,121,162},72,49))
        holder.Size = UDim2.new(1, 0, 0, 38)
        holder.BackgroundTransparency = 1
        holder.Active = true
        holder.Parent = parent
        local name = Instance.new(_V[1]({211,82,211,61,131,6,117,230,91},17,110))
        name.Size = UDim2.new(1, 0, 0, 14)
        name.BackgroundTransparency = 1
        name.Text = label
        name.TextColor3 = C.Text
        name.Font = Enum.Font.Code
        name.TextSize = 10
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.Parent = holder
        local button = Instance.new(_V[1]({190,137,86,12,148,129,58,244,169,98},176,186))
        button.Size = UDim2.new(1, 0, 0, 22)
        button.Position = UDim2.fromOffset(0, 15)
        button.BackgroundColor3 = C.Control
        button.BorderColor3 = C.Black
        button.BorderSizePixel = 1
        button.Text = _V[1]({},173,66)
        button.AutoButtonColor = false
        button.Parent = holder

        local valueText = Instance.new(_V[1]({100,163,228,14,20,87,134,183,236},226,46))
        valueText.Size = UDim2.new(1, -30, 1, 0)
        valueText.Position = UDim2.fromOffset(8, 0)
        valueText.BackgroundTransparency = 1
        valueText.TextColor3 = C.Text
        valueText.Font = Enum.Font.Code
        valueText.TextSize = 10
        valueText.TextXAlignment = Enum.TextXAlignment.Left
        valueText.TextTruncate = Enum.TextTruncate.AtEnd
        valueText.Parent = button

        local arrow = Instance.new(_V[1]({12,230,131,61,227},24,174))
        arrow.Name = _V[1]({247,50,69,108,126,145,166},158,22)
        arrow.Size = UDim2.fromOffset(14, 12)
        arrow.Position = UDim2.new(1, -20, 0.5, -6)
        arrow.BackgroundTransparency = 1
        arrow.Parent = button
        local arrowLeft = Instance.new(_V[1]({215,136,252,141,10},12,133))
        arrowLeft.AnchorPoint = Vector2.new(0.5, 0.5)
        arrowLeft.Position = UDim2.fromOffset(5, 5)
        arrowLeft.Size = UDim2.fromOffset(6, 1.4)
        arrowLeft.BackgroundColor3 = C.Muted
        arrowLeft.BorderSizePixel = 0
        arrowLeft.Rotation = 42
        arrowLeft.Parent = arrow
        local arrowRight = Instance.new(_V[1]({186,15,39,92,125},75,41))
        arrowRight.AnchorPoint = Vector2.new(0.5, 0.5)
        arrowRight.Position = UDim2.fromOffset(9, 5)
        arrowRight.Size = UDim2.fromOffset(6, 1.4)
        arrowRight.BackgroundColor3 = C.Muted
        arrowRight.BorderSizePixel = 0
        arrowRight.Rotation = -42
        arrowRight.Parent = arrow

        local function resolvedValues()
            local list = type(values) == _V[1]({93,143,171,195,247,15,56,90},212,35) and values() or values
            return type(list) == _V[1]({155,60,241,175,92},115,180) and #list > 0 and list or {_V[1]({75,228,93,208,92,203,75},143,120)}
        end
        local function refresh(value)
            valueText.Text = tostring(value)
            valueText.TextColor3 = C.Text
        end
        local initialValues = resolvedValues()
        refresh(XCConfig[key] or initialValues[1])
        refreshers[key] = refreshers[key] or {}
        table.insert(refreshers[key], refresh)
        button.Activated:Connect(function()
            openDropdown(button, key, resolvedValues(), onChanged, refresh)
        end)
        attachHelp(holder, key)
        registerSearch(holder, label .. _V[1]({49},97,176) .. key)
    end

    local function addButton(parent, label, callback)
        parent = activeSectionByParent[parent] or parent
        local button = Instance.new(_V[1]({168,66,222,99,186,118,254,135,11,147},203,137))
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
        registerSearch(button, label)
        return button
    end

    local function addNote(parent, message)
        parent = activeSectionByParent[parent] or parent
        local note = Instance.new(_V[1]({131,87,45,236,135,95,35,233,179},108,195))
        note.Size = UDim2.new(1, 0, 0, 30)
        note.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
        note.BorderColor3 = C.Border
        note.BorderSizePixel = 1
        note.Text = message
        note.TextColor3 = C.Muted
        note.Font = Enum.Font.Code
        note.TextSize = 8
        note.TextWrapped = true
        note.TextXAlignment = Enum.TextXAlignment.Left
        note.Parent = parent
        local padding = Instance.new(_V[1]({34,89,163,247,61,128,200,16,76},138,67))
        padding.PaddingLeft = UDim.new(0, 6)
        padding.PaddingRight = UDim.new(0, 6)
        padding.Parent = note
        registerSearch(note, message)
        return note
    end

    local function addESPPreview(parent)
        parent = activeSectionByParent[parent] or parent
        local card = Instance.new(_V[1]({22,233,127,50,209},41,167))
        card.Name = _V[1]({175,162,132,105,112,72,62,22,247,238},133,229)
        card.Size = UDim2.new(1, 0, 0, 154)
        card.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        card.BorderColor3 = C.Border
        card.BorderSizePixel = 1
        card.Parent = parent

        local title = Instance.new(_V[1]({225,155,87,252,125,59,229,145,65},228,169))
        title.Size = UDim2.new(1, -76, 0, 20)
        title.Position = UDim2.fromOffset(7, 3)
        title.BackgroundTransparency = 1
        title.Text = _V[1]({251,36,93,120,127,208,10,51,47,139,185,216,21,52,92,154},131,44)
        title.TextColor3 = C.Text
        title.Font = Enum.Font.Code
        title.TextSize = 9
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = card

        local previewVisible = true
        local mode = Instance.new(_V[1]({86,46,8,203,96,90,32,231,169,111},59,199))
        mode.Size = UDim2.fromOffset(67, 18)
        mode.Position = UDim2.new(1, -72, 0, 4)
        mode.BackgroundColor3 = C.Control
        mode.BorderColor3 = C.Border
        mode.BorderSizePixel = 1
        mode.TextColor3 = C.Lime
        mode.Font = Enum.Font.Code
        mode.TextSize = 8
        mode.AutoButtonColor = false
        mode.Parent = card

        local canvas = Instance.new(_V[1]({36,108,119,159,179},194,28))
        canvas.Size = UDim2.new(1, -12, 1, -31)
        canvas.Position = UDim2.fromOffset(6, 26)
        canvas.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        canvas.BorderSizePixel = 0
        canvas.ClipsDescendants = true
        canvas.Parent = card

        local body = Instance.new(_V[1]({15,238,144,79,250},22,179))
        body.AnchorPoint = Vector2.new(0.5, 0.5)
        body.Position = UDim2.fromScale(0.5, 0.55)
        body.Size = UDim2.fromOffset(18, 62)
        body.BackgroundColor3 = C.Lime
        body.BackgroundTransparency = 0.72
        body.BorderSizePixel = 0
        body.Parent = canvas
        local head = Instance.new(_V[1]({63,0,132,37,178},100,149))
        head.AnchorPoint = Vector2.new(0.5, 1)
        head.Position = UDim2.new(0.5, 0, 0, -2)
        head.Size = UDim2.fromOffset(18, 18)
        head.BackgroundColor3 = C.Lime
        head.BackgroundTransparency = 0.72
        head.BorderSizePixel = 0
        head.Parent = body
        local headCorner = Instance.new(_V[1]({171,42,175,102,244,123,253,149},203,139))
        headCorner.CornerRadius = UDim.new(1, 0)
        headCorner.Parent = head

        local box = Instance.new(_V[1]({146,82,213,117,1},184,148))
        box.AnchorPoint = Vector2.new(0.5, 0.5)
        box.Position = UDim2.fromScale(0.5, 0.55)
        box.BackgroundTransparency = 1
        box.Parent = canvas
        local boxStroke = Instance.new(_V[1]({225,250,41,111,146,180,213,244},103,37))
        boxStroke.Thickness = 1
        boxStroke.Parent = box

        local cornerLines = {}
        for index = 1, 8 do
            local line = Instance.new(_V[1]({199,154,48,227,130},218,167))
            line.BorderSizePixel = 0
            line.Parent = canvas
            cornerLines[index] = line
        end

        local healthBack = Instance.new(_V[1]({14,100,125,179,213},158,42))
        healthBack.AnchorPoint = Vector2.new(1, 0.5)
        healthBack.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
        healthBack.BorderSizePixel = 0
        healthBack.Parent = canvas
        local healthFill = Instance.new(_V[1]({72,166,199,5,47},208,50))
        healthFill.AnchorPoint = Vector2.new(0, 1)
        healthFill.Position = UDim2.new(0, 1, 1, -1)
        healthFill.Size = UDim2.new(1, -2, 0.72, -1)
        healthFill.BackgroundColor3 = Color3.fromRGB(112, 196, 64)
        healthFill.BorderSizePixel = 0
        healthFill.Parent = healthBack

        local tag = Instance.new(_V[1]({55,161,13,98,147,1,91,183,23},138,89))
        tag.AnchorPoint = Vector2.new(0.5, 1)
        tag.BackgroundTransparency = 1
        tag.Text = _V[1]({2,131,242,114,246,21,200,25,143,66,170,229,152,236,95,237,109,242},37,120)
        tag.Font = Enum.Font.Code
        tag.TextSize = 9
        tag.Parent = canvas

        local function refreshPreview()
            local color = previewVisible and currentTheme.Enemy_Accent or currentTheme.Enemy_Hidden
            mode.Text = previewVisible and _V[1]({206,208,233,238,246,15,23},105,15) or _V[1]({18,133,242,100,215,82},88,114)
            mode.TextColor3 = color
            local height = 58 * math.clamp(tonumber(XCConfig.espPerspectiveScale) or 1, 0.65, 1.5)
            local width = height * math.clamp(tonumber(XCConfig.espBoxAspect) or 0.52, 0.38, 0.8)
            box.Size = UDim2.fromOffset(width, height)
            boxStroke.Color = color
            boxStroke.Thickness = tonumber(XCConfig.boxThickness) or 1
            box.Visible = XCConfig.boxEspEnabled and not XCConfig.cornerBoxEnabled
            body.BackgroundColor3 = color
            head.BackgroundColor3 = color
            body.Visible = XCConfig.chamsEnabled
            healthBack.Position = UDim2.new(0.5, -width * 0.5 - 4, 0.55, 0)
            healthBack.Size = UDim2.fromOffset(4, height)
            healthBack.Visible = XCConfig.healthBarEnabled
            tag.Position = UDim2.new(0.5, 0, 0.55, -height * 0.5 - 3)
            tag.TextColor3 = currentTheme.Enemy_Accent
            tag.Visible = XCConfig.nametagsEnabled

            local left = canvas.AbsoluteSize.X * 0.5 - width * 0.5
            local top = canvas.AbsoluteSize.Y * 0.55 - height * 0.5
            local length = math.floor(math.clamp(width * 0.30, 4, 28) + 0.5)
            local specs = {
                {left, top, length, 1}, {left, top, 1, length},
                {left + width - length, top, length, 1}, {left + width - 1, top, 1, length},
                {left, top + height - 1, length, 1}, {left, top + height - length, 1, length},
                {left + width - length, top + height - 1, length, 1}, {left + width - 1, top + height - length, 1, length},
            }
            for index, line in ipairs(cornerLines) do
                local spec = specs[index]
                line.Position = UDim2.fromOffset(spec[1], spec[2])
                line.Size = UDim2.fromOffset(spec[3], spec[4])
                line.BackgroundColor3 = color
                line.Visible = XCConfig.cornerBoxEnabled
            end
        end

        mode.Activated:Connect(function()
            previewVisible = not previewVisible
            refreshPreview()
        end)
        for _, key in ipairs({_V[1]({63,127,187,187,28,76,84,176,214,10,71,115,165},170,51), _V[1]({231,7,30,46,57,90,62,127,156,125,186,193,214,244,1,20},112,20), _V[1]({114,148,181,229,18,43,42,110,164,156,234,2,40,87,117,153},229,37), _V[1]({97,148,224,24,103,148,218,38,56,161,212,21,95,152,215},179,64), _V[1]({11,209,139,88,31,178,156,80,18,221,151,87},231,193), _V[1]({45,129,196,234,69,152,223,34,93,161,248,51,134,187,239,69,137,218,25},130,70), _V[1]({249,176,86,209,167,89,203,166,76,234,145,75},235,169), _V[1]({254,176,94,223,152,62,221,138,50,206,129,38},247,165)}) do
            refreshers[key] = refreshers[key] or {}
            table.insert(refreshers[key], refreshPreview)
        end
        task.defer(refreshPreview)
        table.insert(connections, canvas:GetPropertyChangedSignal(_V[1]({203,214,209,183,158,145,122,85,45,45,40,253},160,234)):Connect(refreshPreview))
        registerSearch(card, _V[1]({71,30,228,93,118,65,253,215,147,88,51,165,196,128,83,18,212,167,105,237,254,200,140,85,31,241,108,119,77,31,144,156,113,61,2,194,152,15,32,230,171,127,80,13,142,165,97,54,247,207,133,84,214,226,176,114,71,22},25,201))
        return card
    end

    local function specialToggle(key, value)
        if value then
            if key == _V[1]({226,69,174,1,78,189,48,129,193,74,157,254,104,193,32},28,96) then lazyFeatureRequests.fireRate = true end
            if key == _V[1]({65,134,173,4,70,150,212,27,56,165,220,33,111,172,239},143,68) or key == _V[1]({219,84,176,69,191,42,158,25,114,19,126,247,121,234,97},245,120) then lazyFeatureRequests.recoilSpread = true end
            if key == _V[1]({52,138,237,70,175,21,66,202,46,102,239,66,163,13,102,197},97,96) then lazyFeatureRequests.silentFallback = true end
        end
        if key == _V[1]({150,128,110,90,76,29,55,27,13,8,242,226},50,241) then updateMobileSlideVisibility()
        elseif key == _V[1]({157,198,220,253,238,50,89,104,143,166,164,235,252,27,67,90,119},21,30) then
            if value and player.Character then initJumpCircleForCharacter(player.Character) else clearActiveJumpCircle() end
        elseif key == _V[1]({255,128,7,149,243,161,35,185,59,194,88,180,102,226,108,255,129,9},3,137) then
            if value then
                hookBloxStrikeModules(true)
                applyXCKnifeChanger()
                applyXCSelectedWeaponSkin()
            else
                restoreXCKnifeModel()
                restoreXCSelectedWeaponSkin()
            end
        elseif key == _V[1]({213,31,103,179,231,10,116,178,4,66,133,215,239,93,149,219,42,104,172},41,69) and value then applyXCGloves()
        elseif key == _V[1]({45,74,106,141,187,182,250,17,52,54,129,150,185,229,0,33},157,34) then
            if value then
                applyNightPreset(XCConfig.nightPreset)
            else
                Lighting.Brightness = defaultLighting.Brightness
                Lighting.ClockTime = defaultLighting.ClockTime
                Lighting.GlobalShadows = defaultLighting.GlobalShadows
                Lighting.Ambient = defaultLighting.Ambient
                Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
            end
            updateWorldChanger()
        elseif key == _V[1]({68,97,102,116,88,150,155,167,182,208,175,230,231,246,14,21,34},208,14) and not value and not XCConfig.nightModeEnabled then
            Lighting.Brightness = defaultLighting.Brightness
            Lighting.ClockTime = defaultLighting.ClockTime
            Lighting.GlobalShadows = defaultLighting.GlobalShadows
            Lighting.Ambient = defaultLighting.Ambient
            Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
            updateWorldChanger()
        elseif key == _V[1]({133,227,86,195,53,143,219,111,210,27,175,13,121,238,82,188},168,107) and not value then
            Lighting.FogStart = defaultLighting.FogStart or 0
            Lighting.FogEnd = defaultLighting.FogEnd
            Lighting.FogColor = defaultLighting.FogColor
            updateWorldChanger()
        elseif key == _V[1]({207,102,10,182,75,218,146,66,230,133,39,161,109,3,167,84,240,146},184,163) then setThirdPersonEnabled(value)
        elseif key == _V[1]({215,25,84,126,139,229,31,46,140,180,234,41,87,139},65,53) then setAntiAfkEnabled(value)
        elseif key == _V[1]({0,169,74,244,177,74,9,176,95,229,174,100,17,142,99,2,175,101,10,181},225,172) and value then buildSpectatorGui()
        elseif key == _V[1]({163,161,141,130,103,107,81,72,56,46,241,11,239,225,220,198,182},81,241) then if value then playXCAnimation() else stopXCAnimation() end
        elseif key == _V[1]({68,124,160,199,232,12,13,76,127,155,208,200,23,48,87,135,166,203},187,38) then
            handsLastModel = nil
            handsLastPivot = nil
            if value then setupXCCustomHandsHook() end
        elseif key == _V[1]({166,213,18,98,162,226,248,94,152,229,44,63,169,221,31,106,164,228},238,65) then setWeaponVisuals()
        elseif key == _V[1]({38,41,24,10,246,229,188,189,186,172,146,99,125,97,83,78,56,40},210,241) then updateCustomScope()
        elseif key == _V[1]({168,246,48,109,164,222,243,88,155,166,11,58,119,189,242,45},9,60) and not value then
            local cam = Workspace.CurrentCamera or camera
            if cam then cam.FieldOfView = 70 end
        elseif key == _V[1]({89,57,39,44,18,1,0,197,224,197,184,180,159,144},240,242) then applyXCWeather(); updateWorldChanger()
        elseif key == _V[1]({108,85,33,35,13,241,211,155,172,135,112,98,67,42},22,232) then applyXCSmokeState()
        elseif key == _V[1]({43,117,202,22,96,161,11,107,166,5,96,127,250,63,146,238,57,138},98,82) or key == _V[1]({234,91,215,74,187,35,180,59,126,25,153,11,146,12,122,235,111},250,121) or key == _V[1]({215,111,18,172,68,208,143,51,212,70,248,133,78,225,130,44,197,100},192,160)
            or key == _V[1]({134,40,213,121,27,162,127,34,206,124,35,197,108,35,192,74,29,186,101,25,188,101},101,170) or key == _V[1]({229,210,202,185,166,121,152,144,133,120,69,99,75,65,64,46,34},121,245) then updateWorldChanger()
        elseif key == _V[1]({111,14,148,39,184,73,232,83,15,149,41,198,82,228},118,147) then setXCCameraMode(_V[1]({15,112,152,205,0,51,116},148,53), value)
        elseif key == _V[1]({186,68,181,51,184,57,183,49,137,48,161,32,168,31,156},214,126) then setXCCameraMode(_V[1]({2,195,75,224,124,20,169,58},39,149), value)
        elseif key == _V[1]({254,210,163,105,56,23,226,194,112,101,45,1,180,176,118,74,39,243,197},184,211) then setXCStreamerMode(value)
        elseif key == _V[1]({75,30,14,239,197,171,133,114,35,48,15,243,197,168,154,84,87,45,15},247,225) then updateScale()
        end
        if value and (key == _V[1]({74,104,127,133,110,167,188,165,223,227,245,16,26,42},216,17) or key == _V[1]({140,233,44,118,203,228,85,160,191,50,111,186,14,81,154},224,74)) then
            setupXCCharacterInputHook()
        end
    end
    local function toggle(parent, label, key)
        return addToggle(parent, label, key, function(v) specialToggle(key, v) end)
    end

    local ICON_OFF = Color3.fromRGB(88, 88, 88)
    local ICON_HOVER = Color3.fromRGB(155, 155, 155)
    local ICON_ON = C.White

    local function iconLine(parent, x, y, w, h, color, rotation)
        local line = Instance.new(_V[1]({130,28,121,243,89},206,110))
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
        local circle = Instance.new(_V[1]({243,55,62,98,114},149,24))
        circle.AnchorPoint = Vector2.new(0.5, 0.5)
        circle.Position = UDim2.fromOffset(x, y)
        circle.Size = UDim2.fromOffset(size, size)
        circle.BackgroundColor3 = color
        circle.BackgroundTransparency = filled and 0 or 1
        circle.BorderSizePixel = 0
        circle.Parent = parent
        local corner = Instance.new(_V[1]({17,119,227,129,246,100,205,76},74,114))
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = circle
        if not filled then
            local stroke = Instance.new(_V[1]({236,108,2,175,57,194,74,208},11,140))
            stroke.Color = color
            stroke.Thickness = 1.4
            stroke.Parent = circle
        end
        return circle
    end

    local function drawTabIcon(parent, kind, color)
        local root = Instance.new(_V[1]({241,247,192,166,120},209,218))
        root.Name = _V[1]({100,128,139,169,177,193,165,204,229,241},1,13)
        root.Size = UDim2.fromOffset(22, 22)
        root.Position = UDim2.fromScale(0.5, 0.5)
        root.AnchorPoint = Vector2.new(0.5, 0.5)
        root.BackgroundTransparency = 1
        root.Parent = parent
        local cx, cy = 11, 11

        if kind == _V[1]({226,144,98,24,215,167},173,193) then
            iconCircle(root, cx, cy, 14, color, false)
            iconCircle(root, cx, cy, 5, color, false)
            iconLine(root, cx, 2.5, 1.5, 5, color)
            iconLine(root, cx, 19.5, 1.5, 5, color)
            iconLine(root, 2.5, cy, 5, 1.5, color)
            iconLine(root, 19.5, cy, 5, 1.5, color)
        elseif kind == _V[1]({50,186,59,171,30,161,32},86,123) then
            iconCircle(root, cx, cy, 15, color, false)
            iconLine(root, 7, 9, 7, 1.5, color, -32)
            iconLine(root, 15, 9, 7, 1.5, color, 32)
            iconLine(root, cx, 15, 1.5, 7, color)
        elseif kind == _V[1]({19,154,56,206,78,237,136},9,148) then
            iconCircle(root, cx, cy, 7, color, false)
            for _, angle in ipairs({0, 45, 90, 135}) do
                iconLine(root, cx, 2, 1.5, 4, color, angle)
                iconLine(root, cx, 20, 1.5, 4, color, angle)
            end
        elseif kind == _V[1]({251,202,164,117,68},173,215) then
            iconCircle(root, cx, cy, 15, color, false)
            iconLine(root, cx, cy, 1.5, 13, color)
            iconLine(root, cx, cy, 13, 1.5, color)
            iconCircle(root, cx, cy, 8, color, false)
        elseif kind == _V[1]({101,185,27,99},160,88) then
            iconCircle(root, cx, cy, 9, color, false)
            iconCircle(root, cx, cy, 3, color, false)
            for _, angle in ipairs({0, 45, 90, 135}) do iconLine(root, cx, 2, 3, 5, color, angle) end
        elseif kind == _V[1]({203,217,237,8,35},66,22) then
            iconLine(root, 12, 10, 14, 2, color, -42)
            iconLine(root, 6, 16, 7, 2, color, 42)
            iconLine(root, 8, 17.5, 6, 2, color, -42)
        elseif kind == _V[1]({183,237,28,110,148,219,22},13,58) then
            iconCircle(root, cx, 6, 7, color, false)
            iconLine(root, cx, 14, 10, 1.6, color)
            iconLine(root, 7, 17, 1.7, 7, color, 18)
            iconLine(root, 15, 17, 1.7, 7, color, -18)
        elseif kind == _V[1]({165,81,240,136,43,201,117},162,160) then
            local box = Instance.new(_V[1]({34,221,91,246,125},77,143))
            box.Size = UDim2.fromOffset(14, 16)
            box.Position = UDim2.fromOffset(4, 3)
            box.BackgroundTransparency = 1
            box.Parent = root
            local stroke = Instance.new(_V[1]({76,229,148,90,253,159,64,223},82,165))
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
            if object:IsA(_V[1]({201,47,171,62,174,29,139,247},2,114)) then
                object.Color = color
            elseif object:IsA(_V[1]({225,167,48,214,104},1,154)) and object.BackgroundTransparency < 1 then
                object.BackgroundColor3 = color
            end
        end
    end

    local tabs = {
        {_V[1]({247,130,4,126},41,124), _V[1]({62,254,226,170,123,93},247,211)}, {_V[1]({81,130,140,133,97,141,149},12,4), _V[1]({160,78,245,139,36,205,114},158,161)}, {_V[1]({70,49,19,237,177,148,115},24,216), _V[1]({18,155,59,211,85,246,147},6,150)}, {_V[1]({28,80,111,133,153},169,28), _V[1]({177,9,108,198,30},218,96)},
        {_V[1]({45,117,171,199},180,44), _V[1]({18,227,194,135},208,213)}, {_V[1]({134,9,114,226,82},200,107), _V[1]({69,98,133,175,217},173,37)}, {_V[1]({47,185,28,162,252,119,230},113,110), _V[1]({160,124,81,73,21,2,227},80,224)}, {_V[1]({142,128,69,3,204,144,98},133,198), _V[1]({178,56,177,35,160,24,158},213,122)},
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
        if applySearch then applySearch() end
    end
    for index, info in ipairs(tabs) do
        local holder = Instance.new(_V[1]({126,34,137,13,125},192,120))
        holder.Size = UDim2.new(1, 0, 0, 41)
        holder.LayoutOrder = index
        holder.BackgroundTransparency = 1
        holder.Parent = sidebar
        local active = Instance.new(_V[1]({8,37,5,2,235},209,241))
        active.Size = UDim2.fromOffset(2, 30)
        active.Position = UDim2.new(0, -1, 0.5, -15)
        active.BackgroundColor3 = C.Lime
        active.BorderSizePixel = 0
        active.Visible = false
        active.Parent = holder
        local button = Instance.new(_V[1]({88,220,98,209,18,184,42,157,11,125},145,115))
        button.Size = UDim2.new(1, -8, 1, 0)
        button.Position = UDim2.fromOffset(4, 0)
        button.BackgroundTransparency = 1
        button.Text = _V[1]({},190,45)
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
        attachHelp(button, _V[1]({218,231,8,37},70,32) .. info[1])
        tabData[info[1]] = {button = button, active = active, icon = icon}
        createPage(info[1])
    end

    local function columns(name, leftTitle, rightTitle)
        local page = pages[name]
        return createPanel(page, leftTitle, 0, 0.49), createPanel(page, rightTitle, 0.51, 0.49)
    end

    local function currentPlayerChoices()
        local values = {_V[1]({228,230,198,158},181,225)}
        local names = {}
        for _, serverPlayer in ipairs(Players:GetPlayers()) do
            if serverPlayer ~= player then table.insert(names, serverPlayer.Name) end
        end
        table.sort(names, function(a, b) return a:lower() < b:lower() end)
        for _, name in ipairs(names) do table.insert(values, name) end
        return values
    end

    local L, R = columns(_V[1]({148,203,249,31},26,40), _V[1]({86,98,74,225,6,252,224,186,168,141,94,79,40,14},49,228), _V[1]({97,26,165,39,179,83,140,102,235,118,8,142,40,176,55,212},145,141))
    section(L, _V[1]({67,99,95,76,81,78},10,248))
    toggle(L, _V[1]({219,148,30,187,94,247,151,43},236,155), _V[1]({196,132,64,237,178,111,248,217,132,61,255,176,103},171,184))
    addSlider(L, _V[1]({223,205,151,16,252,203,152},216,198), _V[1]({45,19,245,172,179,152},238,222), 10, 360, 1, _V[1]({128,199},101,89))
    addSlider(L, _V[1]({241,120,219,237,159,251,79,174,12},81,95), _V[1]({29,75,117,144,195,238,243,54,81,119,156},150,38), 1, 100, 1, _V[1]({38},77,180))
    addSlider(L, _V[1]({125,181,213,243,22,40,76,97,141,171},12,30), _V[1]({118,5,144,12,160,44,146,51,188,67,207,74,215,85,234,113},142,135), 0.01, 1, 0.01, _V[1]({},81,151))
    toggle(L, _V[1]({137,118,90,42,253,225,180,73,102,69,28,244,214},89,218), _V[1]({112,76,63,30,0,243,213,156,170,144,119,104},17,233))

    section(L, _V[1]({203,194,166,128,106,81,222,0,233,206},151,225))
    toggle(L, _V[1]({126,31,173,49,197,86,141,89,236,123},160,139), _V[1]({121,197,30,109,204,40,75,201,35,81,208,25,112,208,31,116},176,86))
    addSlider(L, _V[1]({211,29,84,129,190,248,216,50,111,170},76,52), _V[1]({3,156,66,222,138,51,163,110,21,145,93,7},237,163), 10, 360, 1, _V[1]({119,44},90,173))
    addSlider(L, _V[1]({28,172,38,65,243,103,207,75,175,32},101,111), _V[1]({202,53,173,27,153,20,86,243,108,188,82,210,22,176,30,160,10,129},226,117), 1, 100, 1, _V[1]({118},201,136))
    toggle(L, _V[1]({18,208,121,50,146,130,52,222,137,62},17,173), _V[1]({61,209,114,9,176,84,191,133,39,172,91,245,159,19,214,113,13,179},44,158))
    toggle(L, _V[1]({6,102,189,0,70,157,227,235,123,205,23,98,183},99,77), _V[1]({101,107,126,135,160,182,147,203,223,216,251,21,27,36,62,71,53,106,119,133,157},226,16))
    toggle(L, _V[1]({109,24,159,213,153,47,94,41,169,40,174},169,131), _V[1]({220,221,235,239,3,20,236,31,46,13,64,79,53,93,100,114},94,11))
    toggle(L, _V[1]({147,147,139,106,84,61,57,208,14,239,221,193,181,166},88,235), _V[1]({104,18,239,185,121,73,22,174,158,88,32,241,177,119},49,199))
    toggle(L, _V[1]({168,249,75,146,207,21,105,169},10,71), _V[1]({207,255,80,150,210,23,106,169,205,60,117,188,12,75,144},18,70))

    section(L, _V[1]({183,5,44,90,138,184,245,21,82,135},51,48))
    toggle(L, _V[1]({131,90,10,193,122,49,247,160,102,36},118,185), _V[1]({125,66,0,197,140,81,37,220,176,124,20,4,190,134,87,23,221},66,199))
    addSlider(L, _V[1]({28,181,39,160,27,148,28,69,4,128,2,114,5},77,123), _V[1]({153,155,150,152,156,158,175,163,180,189,145,182,193,186,214},33,4), 0.01, 0.5, 0.005, _V[1]({133},215,59))
    addSlider(L, _V[1]({46,33,237,192,149,104,74,205,200,166,130},5,213), _V[1]({56,104,145,193,243,35,98,132,195,250,254,89,146},146,50), 10, 360, 1, _V[1]({198,140},152,190))
    toggle(L, _V[1]({182,126,66,251,168,95,211,218,145,71,12},171,184), _V[1]({91,128,158,195,234,15,67,90,142,186,192,247,42,82,110,148,166,236,17,69},192,39))
    toggle(L, _V[1]({193,13,56,106,85,211,1,46,106},74,47), _V[1]({221,16,60,111,164,215,25,62,128,186,195,21,70,126,158,242,37,103},52,53))

    section(R, _V[1]({141,132,105,97,73,49},77,233))
    toggle(R, _V[1]({136,56,211,124,19,179,4,228,141,41,204,103,1,155},153,157), _V[1]({9,16,54,30,93,102,125,157,172,193},129,22))
    toggle(R, _V[1]({34,107,68,190,217,255,51,85,128},172,40), _V[1]({166,69,198,119,19,189,85,246,109,52,197,100,12,163,64},154,158))
    toggle(R, _V[1]({252,42,232,72,82,97,97,106,122},161,13), _V[1]({123,201,250,100,179,243,60,140,186,48,112,190,21,91,167},192,77))
    toggle(R, _V[1]({182,4,56,86,60,185,211,17,45},69,43), _V[1]({244,11,40,47,48,83,122,127,115,176,183,204,234,247,10},122,20))
    addSlider(R, _V[1]({179,255,49,77,49,163,209,0,26,80,125,145,197},68,41), _V[1]({169,194,225,234,237,18,59,66},45,22), 0.01, 0.2, 0.01, _V[1]({208},40,53))
    addSlider(R, _V[1]({192,199,237,208,57,80,100,109,140,155,190,200},88,22), _V[1]({14,185,131,29,248,176,93,32,211,154,72},226,186), 10, 100, 1, _V[1]({92},51,4))
    addSlider(R, _V[1]({139,194,24,43,193,0,81,134,209},243,70), _V[1]({22,160,73,191,113,21,157,59,178,102,1,171,63,219},11,153), 0.1, 2, 0.1, _V[1]({124},92,168))
    addSlider(R, _V[1]({132,53,5,146,171,83,41},114,192), _V[1]({63,171,54,151,26,171,245,139,8,148,10,136},82,123), 0.1, 2, 0.1, _V[1]({175},127,184))
    section(R, _V[1]({202,165,119,65,10,227,180},172,204))
    toggle(R, _V[1]({8,56,95,126,156,202,240},149,33), _V[1]({65,16,246,212,145,158,131,52,61,16,241,219,180,147},239,224))
    addSlider(R, _V[1]({68,227,121,7,82,8,161,56},98,144), _V[1]({218,65,191,53,142,47,174},240,120), 30, 360, 1, _V[1]({205,191},7,4))
    toggle(R, _V[1]({246,92,185,14,32,184,35,121,203,211,112,202,42,116},77,87), _V[1]({35,148,28,156,250,176,49,174,7,172,55,172},47,130))
    addChoice(R, _V[1]({201,241,29,45,70,112,55,162,191,209,242,16,34,72,104},90,27), _V[1]({26,121,239,93,188,57,186,31,141,12,85,231,76,189},56,112), {_V[1]({203,243,0,4,244,4,252,1},132,3), _V[1]({65,41,240,198,153,88},46,203), _V[1]({143,190,235},35,38), _V[1]({175,73,184,54,177,32,163,32},231,120)})

    task.wait()
    L, R = columns(_V[1]({21,203,90,216,57,234,119},75,137), _V[1]({22,119,177,218,210,58,118,174},161,52), _V[1]({223,227,204,157,135,97,76,52},176,226))
    section(L, _V[1]({188,11,51,74,48,134,176,214},89,34))
    toggle(L, _V[1]({247,137,244,78,119,16,125,230},81,101), _V[1]({187,70,202,61,147,57,187,17,184,41,168,48,167,36},220,126))
    addChoice(L, _V[1]({22,15,225,162,50,50,6,214,85,110,60,253,202},9,204), _V[1]({116,50,233,143,24,241,166,55,10,176,98},98,177), {_V[1]({95,103,75,59},33,235), _V[1]({219,217,186,161,140,85,69,22,4},186,223), _V[1]({192,103,250,130,251,144},238,136), _V[1]({244,98,206,35,141,234},67,95), _V[1]({223,225,175,163,121,84},171,225)})
    addSlider(L, _V[1]({114,241,76,179,199,124,219,50,148,245},189,98), _V[1]({0,134,8,150,4,170,40,177,57},4,137), 10, 150, 1, _V[1]({},78,217))
    addSlider(L, _V[1]({68,229,121,237,42,5,111,7},128,130), _V[1]({33,102,164,209,225,65,125,161,225,47},136,56), -180, 180, 1, _V[1]({46,135},1,107))
    addSlider(L, _V[1]({87,78,49,9,210,183,61,103,46,19,228,186},53,216), _V[1]({34,22,3,223,158,173,152,92,98,84,59,19,7},218,231), 0, 180, 1, _V[1]({180,170},234,8))
    addSlider(L, _V[1]({123,35,153,40,155,36,96,45,182,64,181,70,206,61,204},164,132), _V[1]({79,180,18,95,143,15,107,159,28,122,195,40,132,199,42},150,88), 0.04, 0.5, 0.01, _V[1]({148},127,162))
    section(L, _V[1]({100,96,73,58,20,184,240,205,194,171,143,118},40,232))
    toggle(L, _V[1]({125,149,154,167,157,93,177,170,187,192,192,195},37,4), _V[1]({151,16,150,36,155,12,166,56,190,63,195,31,205,69,203,90,216,92},158,133))
    addSlider(L, _V[1]({105,86,48,18,221,114,155,105,79,41,254,214,97,126,92,63,25,223,197,147,110},60,217), _V[1]({192,193,207,229,228,221,255,25,39,48,60,31,81,104,118,112,138,140,155},63,13), 5, 25, 1, _V[1]({},79,149))
    addSlider(L, _V[1]({92,30,205,132,36,142,140,47,234,153,67,240,80,70,241,163,79,254,184},90,174), _V[1]({194,191,201,219,214,203,233,255,9,14,22,249,31,44,51,61,82},69,9), -3, 6, 0.5, _V[1]({},249,162))
    section(R, _V[1]({55,218,67,179,46,69,253,116,229},133,112))
    toggle(R, _V[1]({170,230,3,26,224,59,90,105,129,156,169},82,22), _V[1]({41,233,143,60,244,112,68,242,116,74,234,152,79,245,161},26,173))
    addChoice(R, _V[1]({64,113,131,143,74,162,175,175,187},243,11), _V[1]({123,176,230,22,34,115,151,199},234,47), {_V[1]({32,21,224,166},10,206), _V[1]({19,245,162,75,247,153,90,253,165},36,174)})
    toggle(R, _V[1]({64,174,1,64,145,214,219,118,193,11,100},167,76), _V[1]({241,234,228,216,168,189,183,157,149,129,92,110,95,95},156,243))
    toggle(R, _V[1]({223,49,134,197,248,244,140,191,11,64,57,199,0,74,146},78,65), _V[1]({230,208,187,160,100,89,81,51,9,223,213,196,156,101,97,78,57},160,228))
    addSlider(R, _V[1]({56,52,17,232,110,148,105,71,11,238},32,214), _V[1]({155,84,14,194,79,45,216,142,33,243,174,79,15},134,179), 30, 100, 1, _V[1]({},16,50))
    addSlider(R, _V[1]({80,47,239,169,18,30,212,130,59,243},85,185), _V[1]({66,208,95,232,83,248,117,253,132,234,159,39,179,60},88,136), 1, 3, 0.1, _V[1]({92},250,234))
    addSlider(R, _V[1]({176,200,178,165,139,110,23,72,54,42,12,17},124,237), _V[1]({61,21,238,193,106,103,54,14,217,161,83,70,31,230,208},9,210), 0, 0.25, 0.01, _V[1]({4},40,105))
    addSlider(R, _V[1]({229,229,195,163,136,95,74,23,8,219,191,156},198,222), _V[1]({161,140,120,94,20,27,0,231,211,177,163,119,111,73,52,24},90,229), 2, 30, 1, _V[1]({},47,171))
    toggle(R, _V[1]({148,149,119,254,42,4,219,163,129,89},122,217), _V[1]({119,234,94,204,10,159,21,99,241,92,184,42,150},168,109))
    section(R, _V[1]({220,222,197,148,124,84,61,35},175,224))
    toggle(R, _V[1]({250,97,172,245,68},89,78), _V[1]({121,38,215,134,59,207,172,83,8,198,115,38},82,180))
    toggle(R, _V[1]({43,218,96,231,113,6},92,137), _V[1]({186,69,199,74,208,97,183,101,221,99,242,112,244},207,133))
    toggle(R, _V[1]({198,36,90,155,219,216,91,169,234,47,113},50,65), _V[1]({247,153,51,216,124,2,208,104,14,189,91,255},223,165))
    toggle(R, _V[1]({158,1,244,124,185,6,72,62,196,3,81,135,207,15},14,66), _V[1]({198,24,64,172,8,89,130,240,77,146,233,56,105,227,39,121,212,30,110},7,81))
    addSlider(R, _V[1]({219,246,245,242,245,178,246,5,7,13,16},134,2), _V[1]({29,35,45,53,67,62,104,106,119,131,110,168,181,198,212},157,13), 1.2, 3, 0.1, _V[1]({144},14,10))
    addSlider(R, _V[1]({107,49,206,108,13,185,5,248,149,42,202,105},133,160), _V[1]({181,149,108,68,31,5,190,181,132,94,55},117,218), 10, 150, 1, _V[1]({},141,151))
    addSlider(R, _V[1]({89,188,32,120,134,44,141,221,62,140,236,65,151,236,82},169,89), _V[1]({66,138,243,80,144,22,107,209,36,137,227,62,152,3},109,94), 1, 5, 0.1, _V[1]({10},209,193))

    task.wait()
    L, R = columns(_V[1]({100,143,177,203,207,242,17},246,24), _V[1]({28,114,161,243,25,96,72,167,239,38},146,58), _V[1]({180,196,165,149,122,99,97,71,53,33},128,235))
    section(L, _V[1]({134,2,82,181,18},236,87))
    toggle(L, _V[1]({229,250,227,223,213},178,240), _V[1]({42,214,118,41,214,79,31,185,97,18,178,88},32,167))
    section(L, _V[1]({143,17,111,108,230,73,155},248,85))
    toggle(L, _V[1]({133,9,105,104,14,108,178,22,103,179,34},236,87), _V[1]({24,128,228,12,149,237,29,161,239,75,176,4,94},91,91))
    toggle(L, _V[1]({165,74,198,59,171,49,88,19,153,27},233,121), _V[1]({18,190,97,253,148,65,177,126,39,148,93,240,145,59,212,115},15,160))
    toggle(L, _V[1]({23,121,186,10,87,144,141,20,88,174},138,69), _V[1]({152,210,11,83,152,201,224,60,138,154,0,48,110,181,235,39},243,61))
    toggle(L, _V[1]({170,151,120,65,198,187,153,102,6,37,251,202,146,95,52,251},150,208), _V[1]({141,0,98,153,43,153,213,96,196,33,131,237,73},195,101))
    addSlider(L, _V[1]({0,172,71,181,151,58,226,129,12,183,74,234},29,158), _V[1]({234,183,115,15,226,184,67,39,240,176},198,191), 100, 5000, 50, _V[1]({},106,165))
    addSlider(L, _V[1]({35,247,167,246,240,152,44,212,130,44,208,130,46},58,167), _V[1]({150,247,71,108,236,72,118,227,56,139,227,42,126,214,34},222,83), 0, 0.9, 0.05, _V[1]({},55,211))
    addSlider(L, _V[1]({198,157,99,252,24,209,152,108,46},184,201), _V[1]({38,197,83,196,106,8,154,40,174,61,223,101,3,131,2,163,50,206,88},48,145), 0.65, 1.5, 0.05, _V[1]({248},115,13))
    addSlider(L, _V[1]({81,163,209,158,26,49,81,134,159,124,243,7,63,89,132},234,37), _V[1]({61,147,216,242,103,184,201,67,136,197,11,100},144,72), 0.42, 0.68, 0.02, _V[1]({22},15,143))
    section(L, _V[1]({205,142,61,255,177,99,200,160,97,17},195,179))
    toggle(L, _V[1]({55,89,105,140,159,178,120,213,237,245,15,33},204,20), _V[1]({235,20,75,149,207,9,27,132,188,204,48,94,154,223,19,77},57,59))
    section(L, _V[1]({160,86,238,147,42,215,112,13},175,158))
    toggle(L, _V[1]({231,94,183,29,117,227,61,155,172,48,157,249},53,95), _V[1]({134,231,74,186,28,148,248,96,160,55,157,219,109,201,51,166,8,112},170,105))
    toggle(L, _V[1]({93,146,172,189,186,215,220,238,185,15,26,45,62},9,16), _V[1]({22,173,70,236,132,50,204,106,223,163,76,236,120,36,184,89,217,147,53,213},4,159))
    addSlider(L, _V[1]({112,146,150,167,170,195,200,209,141,235,233,244,248,10,23,24,48,58},19,10), _V[1]({151,31,169,64,201,104,243,130,248,156,45,183,79,226,105,7,151},148,144), 1, 4, 0.5, _V[1]({243,238},144,243))
    section(L, _V[1]({144,26,157,12,146,246,115,246},203,119))
    toggle(L, _V[1]({120,123,119,95,94,59,49,45},58,240), _V[1]({196,52,189,50,190,40,171,52,131,41,153,23,158,20,144},217,125))
    addSlider(L, _V[1]({5,135,11,120,149,89,192,66,158},64,113), _V[1]({211,142,56,201,135,71,240,124,63,253,149},193,173), 8, 20, 1, _V[1]({},82,224))
    toggle(L, _V[1]({179,119,45,228,60,47,227,156,76,232,164,72,249},177,175), _V[1]({104,98,75,26,27,14,2,187,204,194,175,136,129,98,80},23,236))
    toggle(L, _V[1]({66,232,128,25,83,44,186,71,227,124,1},94,145), _V[1]({181,213,228,217,0,25,51,22,69,83,112,138,144},62,18))
    toggle(L, _V[1]({193,100,249,143,198,171,39,177,78,219,104},224,142), _V[1]({49,141,2,93,225,87,206,29,154,5,131,241,95},78,111))
    section(R, _V[1]({150,168,169,125,209,215,206,227,218,218,240},77,4))
    addESPPreview(R)
    section(R, _V[1]({113,248,110,183,121,247,102,228,87,206,90,206,74,196},179,121))
    toggle(R, _V[1]({158,91,224,123,0,149,40,117,44,204,91},197,146), _V[1]({252,49,78,129,158,203,246,0,88,127,126,209,238,25,77,112,153},107,42))
    toggle(R, _V[1]({196,235,227,245,249,0,26,30,42,58,234,67,78,74,82,96,99,125,123,138,146},103,9), _V[1]({178,49,194,84,174,99,224,115,240,125,8,125,24,181,51},181,138))
    toggle(R, _V[1]({124,101,22,221,142,79,14,135,137,68,15,198,130,77,185,209,132,65,246,194},119,190), _V[1]({198,197,172,169,144,135,124,79,96,97,78,64,65,29,38,25,4,6,204,233,208,197,195,176,163},107,244))
    toggle(R, _V[1]({90,6,141,26,169,46,191,243,207,72,213,100,250,130},131,138), _V[1]({201,17,107,198,239,100,180,10,98,176,10,57,155,241,73,168,249},3,83))
    toggle(R, _V[1]({66,243,140,31,176,2,235,113,11,167,74,223},88,151), _V[1]({11,130,11,149,243,143,19,145,13,124,13,146,25,167,39},22,130))
    addSlider(R, _V[1]({133,102,55,244,182,135,249,12,209,134,76,22,229,174},125,196), _V[1]({17,188,79,248,139,46,207,78,11,184,81,239,156,25,218,107,13,179,94,3},10,160), 0.1, 1, 0.05, _V[1]({},243,221))
    toggle(R, _V[1]({95,36,211,117,20,121,114,26,199,102,26,184,103,15,106,56,239,149},99,169), _V[1]({139,58,243,159,72,231,185,112,25,215,127,56,234,116,85,5,141,105,15,195,128,44,222},101,179))
    addSlider(R, _V[1]({113,72,9,189,110,229,237,156,104,28,209,153,2,1,205,133,47,253,173,110,40},99,187), _V[1]({243,158,83,251,160,48,13,185,60,28,200,102,40,204,129,47},209,175), 0.4, 2.5, 0.05, _V[1]({102},119,124))
    toggle(R, _V[1]({167,19,80,160,240,75,154},5,78), _V[1]({238,238,223,227,231,246,249,205,248,237,240,252,247,248},120,2))
    toggle(R, _V[1]({200,98,219,91,148,85,221,95},3,125), _V[1]({12,134,255,127,220,132,6,84,250,106,232,111,229,97},39,125))
    section(R, _V[1]({80,65,28,152,174,125,77,28,234,185,139,99},56,208))
    toggle(R, _V[1]({220,216,190,146,97,77,33,246,222},185,219), _V[1]({151,133,125,99,68,66,40,15,9,201,223,191,173,164,138,118},66,237))
    toggle(R, _V[1]({26,225,146,228,221,127,43,202,102},44,166), _V[1]({229,144,69,206,148,68,231,135,18,229,130,45,225,132,45},211,170))
    addChoice(R, _V[1]({248,222,174,31,55,248,195,129,60,189,210,153,81,36,219,175},235,197), _V[1]({14,219,178,93,69,23,220,158,86,68,3,221,155,118},218,204), {_V[1]({17,147,247,97,218},84,106), _V[1]({62,224,124,246,142,19,161,48,173},101,139), _V[1]({26,20,242,201},1,215), _V[1]({65,227,105,232,45},128,127), _V[1]({21,77,63,68,83,81},206,5), _V[1]({201,75,168,8},24,95), _V[1]({33,109,158,193,169},186,38), _V[1]({209,165,94,9,122},226,174), _V[1]({223,63,109,166,223},104,52), _V[1]({33,133,222,43,127,230,43,140},122,84), _V[1]({194,70,171,30},7,107)}, function()
        playXCHitSound(true)
    end)
    addSlider(R, _V[1]({210,15,54,254,109,133,167,188,206,166,24,45,70,107,127,147},110,28), _V[1]({181,98,25,164,108,30,195,101,3,200,113,38,202,110},161,172), 0.1, 3, 0.1, _V[1]({215},161,190))
    addButton(R, _V[1]({190,253,89,168,194,56,135,224,250,123,197,25,96,164},28,78), function() playXCHitSound(true) end)
    addSlider(R, _V[1]({36,235,156,59,213,140,43,203,126,210,203,103,30,175},54,166), _V[1]({165,20,141,244,86,213,60,164,31,110,242,113,202},207,110), 5, 30, 1, _V[1]({},159,216))
    addSlider(R, _V[1]({145,239,55,109,158,236,34,89,163,142,15,93,151,195,19,69,136,196},12,61), _V[1]({55,70,95,102,104,135,142,150,177,145,208,219,216,249,252,16,29},193,14), 0.05, 1, 0.05, _V[1]({249},8,126))
    section(R, _V[1]({216,38,65,103,58,160,201,245,9,53,81},107,35))
    toggle(R, _V[1]({204,19,39,70,18,113,147,184,197,234,255},102,28), _V[1]({182,160,119,89,11,16,248,200,176,136,71,79,33,1,234,194,160},109,223))
    addSlider(R, _V[1]({59,235,104,240,37,252,112,248,130,19,150},108,133), _V[1]({112,252,117,249,77,244,126,240,122,244,98,242,118,252,137,8},133,129), 1.5, 8, 0.5, _V[1]({},197,156))
    addChoice(R, _V[1]({49,31,218,160,19,41,237,181,107,39},36,195), _V[1]({0,82,145,219,245,98,178,234,58,122,175,23,99,157,221},79,71), {_V[1]({12,86,100,134,170,197,237,18,20,61,113,127},166,31), _V[1]({51,120,162,191,221,241,0,69,92,131,149},208,32), _V[1]({215,3,251,25,25,30,20,54,75,85},121,11)})

    task.wait()
    L, R = columns(_V[1]({243,29,50,62,72},138,18), _V[1]({192,122,19,151,49,191,79,223,104,2,153},234,145), _V[1]({83,241,139,26,157,230,122,2,211,95,249,127,26,151},114,142))
    section(L, _V[1]({246,117,245,120,6,125,4,127},8,130))
    toggle(L, _V[1]({94,251,131,2,127,192,136,18,144,34,160,35,181},130,133), _V[1]({15,23,34,48,73,47,94,96,110,91,145,145,159,182,188,200},148,13))
    toggle(L, _V[1]({187,4,21,47,63,105,122,146,173,211},91,26), _V[1]({99,52,237,175,71,57,242,178,117,67,214,193,118,57,5,192,129},59,194))
    toggle(L, _V[1]({195,150,94,32,231,150,17,23,224,152},177,192), _V[1]({204,72,217,100,244,108,214,136,9,112,34,158,40,187,61,197},209,137))
    toggle(L, _V[1]({245,209,134,42,144,133,58,222,159,67},5,175), _V[1]({54,197,77,196,35,203,66,214,77,172,87,204,79,219,86,215},83,130))
    toggle(L, _V[1]({33,180,215,156,8,124,234,86},97,114), _V[1]({56,86,87,142,173,198,221,218,32,48,78,117,139,167},173,29))
    addChoice(L, _V[1]({114,36,185,81,244,55,30,183,65,230,111,21},141,151), _V[1]({199,67,194,68,209,46,209,69,212,71,215},216,129), {_V[1]({152,150,115,95,60,28,255,237},105,226), _V[1]({236,132,2,150,14,132},29,129), _V[1]({252,209,133,68,202,168,95,19,188},4,180), _V[1]({143,179,138,123,118,66,85,64,44,22,253},94,238), _V[1]({132,219,2,62,92,150,189,214,32,77,125,184},16,47), _V[1]({83,37,233,145,79,226,197,115,46,239},74,185)}, function(v) if XCConfig.nightModeEnabled then applyNightPreset(v) end end)
    addSlider(L, _V[1]({39,112,128,151,177,214,233,249,32,57},204,25), _V[1]({101,37,232,174,127,18,7,195,134,76,29,220,152,107,48},50,197), 0, 5, 0.1, _V[1]({},222,224))
    addSlider(L, _V[1]({93,64,253,171,109,220,234,153,87,9},96,186), _V[1]({25,229,180,134,99,3,253,209,150,111,41,15,228,173},218,209), 0, 24, 0.5, _V[1]({95},168,79))
    section(L, _V[1]({23,226,195,61,22,227,10,216,170,116},209,211))
    toggle(L, _V[1]({30,133,184,238,30,81,57,193,238,49,79,145,207},166,53), _V[1]({87,102,128,145,160,166,213,250,250,30,62,34,98,108,132,165,181,203},201,23))
    addChoice(L, _V[1]({175,249,57,84,147,206,168,42,94,131,195,231,40},42,50), _V[1]({249,38,94,141,186,222,43,110,140,206,12,25,112,152,219,2,70},77,53), {_V[1]({121,29,164,46,195},162,137), _V[1]({2,228,180,126,89,217,218,202,145,100,36,1},229,206), _V[1]({194,243,159,215,254,251,0,253,15,194,234,13,35},112,5), _V[1]({230,17,8,31,31,38,65,61},137,10), _V[1]({197,50,136,208,31,127,191,21,116},39,81), _V[1]({162,47,158,13,118,228,81,206,49},223,112), _V[1]({111,248,96,211,235,134,11,100,206,56},195,104), _V[1]({21,244,173,105,14,197,122,236,213,163,103},28,182), _V[1]({99,25,203,108,12},110,163), _V[1]({137,221,22,73},24,46), _V[1]({27,52,37,23,7,244,163,197,208,193,200,179,156},215,244), _V[1]({100,218,60,150,168,56,173,24},183,93)}, function() updateWorldChanger() end)
    addSlider(L, _V[1]({185,39,139,136,48,131,222,33,138,213,49,134},16,86), _V[1]({122,211,55,146,235,59,180,35,93,219,65,143,3,89,192,32},162,97), -180, 180, 1, _V[1]({228,183},61,229), function() updateWorldChanger() end)
    addSlider(L, _V[1]({236,219,150,117,68},203,206), _V[1]({4,36,79,113,145,168,232,30,32,105,126,183,224},101,40), 0, 5000, 100, _V[1]({},38,103), function() updateWorldChanger() end)
    toggle(L, _V[1]({169,26,98,99,184,1,157,238,61,139},7,79), _V[1]({99,82,76,61,44,18,33,38,231,0,254,238,243,235,215,198,200},245,247))
    toggle(L, _V[1]({4,137,243,90,108,248,112},78,102), _V[1]({197,245,48,98,146,182,13,73,130,140,214,251,92,135,192,2,51,106},22,56))
    addChoice(L, _V[1]({205,27,77,119,101,232,29,67,132,169,235},70,51), _V[1]({79,237,150,54,212,106,43,208,109,254,198,95,19,171,96},50,166), {_V[1]({230,3,25,30,34,23,40},146,6), _V[1]({200,156,98,119,125,106,75},135,233), _V[1]({63,229,92,206},130,122), _V[1]({216,250,35,54},105,24), _V[1]({28,150,232,59,140,218},119,85)}, function() updateWorldChanger() end)
    addSlider(L, _V[1]({17,239,146,60,235,152,64,222},33,171), _V[1]({242,139,47,202,99,229,185,82,242,151,58,216,108},218,161), -3, 3, 0.1, _V[1]({},214,217), function() updateWorldChanger() end)
    addSlider(L, _V[1]({243,218,198,160,118,62,42,248,215,175},199,217), _V[1]({254,86,185,19,107,186,40,155,252,89,168,27,112,214,53},39,96), -1, 1, 0.05, _V[1]({},131,48), function() updateWorldChanger() end)
    addSlider(L, _V[1]({184,108,243,129,7,126,24,161},237,136), _V[1]({236,148,71,241,153,40,4,179,105,23,182,120,41},197,176), -1, 1, 0.05, _V[1]({},226,106), function() updateWorldChanger() end)
    section(L, _V[1]({241,222,177,141,107,66,20,235,210,159,52,20,232,4,232,197,159,119},182,218))
    toggle(L, _V[1]({110,166,164,171,180,182,179,181,199,191},40,5), _V[1]({50,35,31,18,3,217,5,247,242,239,229,214,204,210,190,151,185,165,159,162,148,140},194,249))
    addSlider(L, _V[1]({223,49,73,106,141,169,192,220,8,26,244,87,119,159,195,216,2,38},127,31), _V[1]({203,140,88,27,220,130,126,64,11,216,158,95,37,251,183,95,73,27,233,168,124,74},139,201), 0, 1, 0.05, _V[1]({},206,22), function() updateWorldChanger() end)
    addSlider(L, _V[1]({243,122,199,29,117,198,18,99,196,11,26,182,3,112,175},94,84), _V[1]({2,28,65,93,119,118,203,230,10,48,79,105,136,183,204,209,12,71,84},105,34), 0, 10, 0.1, _V[1]({},122,88), function() updateWorldChanger() end)
    addSlider(L, _V[1]({35,71,49,36,25,7,240,222,220,192,108,164,154,128,130,102},241,241), _V[1]({7,132,12,139,8,106,34,160,39,176,50,175,49,195,59,162,76,198,92,212},11,133), 0, 10, 0.1, _V[1]({},184,28), function() updateWorldChanger() end)
    toggle(L, _V[1]({106,51,213,116,17},137,159), _V[1]({104,174,255,71,141,185,49,130,208,28,66,185,250,73,161,232,53},163,78))
    addSlider(L, _V[1]({229,143,18,146,16,67,12,145,23,136,17,150,12,151,28},35,128), _V[1]({134,2,137,7,131,229,147,26,158,32,128,41,179,40,181,62,184,71,208},139,132), 0, 3, 0.05, _V[1]({},134,240), function() updateWorldChanger() end)
    addSlider(L, _V[1]({105,118,92,63,32,182,236,197,185,135},68,227), _V[1]({220,8,63,109,153,171,9,64,116,166,192,10,79,110},49,52), 0, 56, 1, _V[1]({},246,244), function() updateWorldChanger() end)
    addSlider(L, _V[1]({236,221,167,110,51,173,200,131,84,14,227,159,109,49,240},227,199), _V[1]({217,169,132,86,38,220,222,185,145,103,38,18,244,191,165,114,81,38,246},138,216), 0, 5, 0.1, _V[1]({},165,182), function() updateWorldChanger() end)
    section(L, _V[1]({73,120,181,9,62,124,202},145,65))
    toggle(L, _V[1]({212,211,192,196,169,151,149,52,106,92,77,61,44,46,30},140,241), _V[1]({221,192,177,185,162,148,150,94,124,100,90,89,71,59},113,245))
    addChoice(L, _V[1]({89,131,155,202,218,243,28,230,86,119,138,155},230,28), _V[1]({8,119,244,136,253,123,9,101,8,126,0},16,129), {_V[1]({96,67,31,248},58,212), _V[1]({25,74,97,127},176,22), _V[1]({78,244,105},139,125), _V[1]({51,136,160},207,35), _V[1]({227,35,77,112,71,144,214,2,24},120,35)}, function() applyXCWeather(); updateWorldChanger() end)
    addSlider(L, _V[1]({221,147,55,242,142,51,232,62,47,220,138,35,212,129,31,210,127},222,168), _V[1]({141,23,175,94,238,135,48,163,100,6,147,56,217,107,18,179},122,156), 1, 100, 1, _V[1]({251},190,24), function() applyXCWeather() end)
    addSlider(L, _V[1]({115,145,162,164},16,12), _V[1]({204,133,76,42,233,177,137,57,22,230,167},138,203), -40, 40, 1, _V[1]({},172,106), function() applyXCWeather() end)
    section(R, _V[1]({218,244,42,85,116},61,42))
    toggle(R, _V[1]({91,147,151,158,159,163,92,181,171,189,196,191},18,6), _V[1]({189,232,255,25,45,68,67,108,145,171,185,178,244,0,26,61,79,103},65,25))
    toggle(R, _V[1]({78,57,240,170,94,21,129,96,34,226},82,185), _V[1]({252,120,224,75,176,24,91,238,95,152,43,136,243,103,202,51},47,106))
    addSlider(R, _V[1]({110,26,180,58,213,82,159,83,234,127},157,142), _V[1]({122,231,64,156,242,75,127,3,101},188,91), 70, 120, 1, _V[1]({173,5},129,106))
    toggle(R, _V[1]({143,36,174,50,187,44,105,58,191,56,184,60,195,56,197,251,208,66,208,83,202},187,130), _V[1]({41,134,255,109,207,41,169,30,141,1,93,180,68,168,19,130,244,84,204},73,109))
    toggle(R, _V[1]({202,143,80,6,176,32,24,220,142,71,252,166,84,17,207},194,181), _V[1]({167,220,45,115,173,208,68,134,207,20,78,140,217,39,63,173,229,43,122,184,252},239,69))
    addChoice(R, _V[1]({111,246,75,167,255,76,157,253,94,100,15,104,197,16,97},212,88), _V[1]({137,226,87,193,31,102,254,100,209,58,152,250,107,221,39,177,31,123,221},173,105), {_V[1]({125,154,133,119,101},76,238), _V[1]({0},72,100), _V[1]({176},65,23), _V[1]({56,170,246},173,71)})
    addSlider(R, _V[1]({73,138,199,249,31,11,98,156,212},197,49), _V[1]({179,25,155,18,125,212,115,240},202,118), 10, 120, 1, _V[1]({43,27},103,2))
    addSlider(R, _V[1]({237,102,173,251,69,132,199,25,108,100,245,57,146},96,74), _V[1]({175,35,179,56,177,19,198,71,207,83,204,73,213,98,187,89,236},184,132), 0, 80, 1, _V[1]({},113,127))
    addSlider(R, _V[1]({235,246,207,175,139,92,49,21,250,132,172,129,102,59,36,244},204,220), _V[1]({181,208,7,51,83,92,182,222,13,56,88,124,175,227,232,44,96,132,188,219},23,43), 5, 300, 1, _V[1]({},97,156))
    section(R, _V[1]({100,207,72,173,39,131,175,96,210,72,168,19,145,249,105},148,109))
    toggle(R, _V[1]({66,88,53,31,7,239,229},18,234), _V[1]({63,82,76,83,88,93,112,79,127,121,129,146,146,152},210,7))
    addSlider(R, _V[1]({171,94,216,95,228,105,252,54,16,148,16,151,29},222,135), _V[1]({231,203,150,110,68,26,254,188,177,126,86,45},169,216), 5, 180, 1, _V[1]({},66,171))
    addSlider(R, _V[1]({105,26,146,23,154,29,174,230,190,53,195,77,200,88,210,100,220,108,246},158,133), _V[1]({164,22,111,213,57,157,15,91,211,66,173,9,122,213,72,161,18,125},216,102), 0.05, 0.5, 0.01, _V[1]({},152,109))
    addChoice(R, _V[1]({220,120,219,75,185,39,163,198,120,239,100,202},38,112), _V[1]({51,19,218,174,128,82,50,228,210,186},249,212), {_V[1]({39,254},247,234), _V[1]({105,110},12,23), _V[1]({2,82},91,97), _V[1]({229,72},44,115), _V[1]({47,249,171,106,232,196,125},50,177), _V[1]({155,96,12,187,117,240,201,127},155,174)})
    toggle(R, _V[1]({139,50,160,27,157,27,150,13},202,123), _V[1]({47,150,228,63,161,255,90,177,230,106,184,20,121,205,39},110,91))
    addSlider(R, _V[1]({89,93,62,27,177,229,184,162,136,95,75,33,15,227,207,181},44,225), _V[1]({111,37,194,108,29,202,116,26,172,104,27,202,106,31,190,117,18,199,118},95,170), 0.05, 0.5, 0.01, _V[1]({},103,28))
    addChoice(R, _V[1]({185,69,152,248,95,194,34,126,147,53,156,1,87},19,96), _V[1]({240,52,95,151,214,17,73,125,149,231,51},82,56), {_V[1]({182,98,246,151,247,181,80},215,147), _V[1]({144,40,167,41,182,4,176,57},189,129), _V[1]({173,55},202,157), _V[1]({191,154},140,237), _V[1]({235,195},188,233), _V[1]({180,74},200,166)})

    task.wait()
    L, R = columns(_V[1]({251,228,179,137,95},215,209), _V[1]({179,1,61,140,203,10,252,133,202,18,65,138,208,11,78,149},28,64), _V[1]({208,111,230,95,218,17,147,9,204,77,204,79,186,68},9,124))
    section(L, _V[1]({147,200,224,223,248,14,25,44,67,250,77,98,107,136,145,159,188},58,16))
    toggle(L, _V[1]({157,214,245,27,238,82,120,146,192,218,249,39},41,33), _V[1]({83,49,21,0,187,198,165,152,119,91,78,7,22,239,214,198,165,138},250,230))
    addChoice(L, _V[1]({10,90,152,233,42,107},113,66), _V[1]({19,44,75,113,105,169,207,251,23,59,65,112,141,189,221,253},127,33), getXCWeaponSkinChoices(), function(weaponName)
        local selected = XCConfig.weaponSkinSelections[weaponName] or _V[1]({142,81,244,145,71,224,138},168,162)
        XCConfig.skinEditorFinish = selected
        XCConfig.skinWear = XCConfig.weaponSkinWear[weaponName] or 0
        refreshConfigControls(_V[1]({241,5,31,64,51,110,143,182,205,236,220,27,60,83,121,138},98,28), selected)
        refreshConfigControls(_V[1]({243,3,25,54,55,93,113,154},104,24), XCConfig.skinWear)
    end)
    addChoice(L, _V[1]({116,6,122,228,93,193},191,111), _V[1]({150,96,48,7,176,161,120,85,34,247,157,146,105,54,18,217},81,210), function()
        return getXCSkinChoicesForWeapon(XCConfig.skinEditorWeapon)
    end, function(finish)
        local weaponName = XCConfig.skinEditorWeapon
        XCConfig.weaponSkinSelections[weaponName] = finish
        XCConfig.weaponSkinWear[weaponName] = XCConfig.skinWear
        applyXCSelectedWeaponSkin()
    end)
    addSlider(L, _V[1]({89,132,157,203,150,249,28,60,75,123},229,29), _V[1]({37,149,11,136,233,111,227,108},58,120), 0, 1, 0.01, _V[1]({},16,208), function(value)
        local weaponName = XCConfig.skinEditorWeapon
        XCConfig.weaponSkinWear[weaponName] = value
        applyXCSelectedWeaponSkin()
    end)
    addButton(L, _V[1]({108,44,224,125,103,38,239,169,71,64,240,174,127,64,1},85,194), function()
        refreshXCSkinData()
        local ok, weapon = type(skinData.GetWeapon) == _V[1]({11,146,3,112,249,102,228,91},45,120) and pcall(skinData.GetWeapon)
        local view = ok and weapon and weapon.Viewmodel
        local weaponName = view and (view.CameraModelWeapon or view.Weapon) or (weapon and weapon.Name)
        if weaponName and skinData.SkinSelections[weaponName] then
            XCConfig.skinEditorWeapon = weaponName
            XCConfig.skinEditorFinish = XCConfig.weaponSkinSelections[weaponName] or _V[1]({221,215,177,133,114,66,35},192,217)
            XCConfig.skinWear = XCConfig.weaponSkinWear[weaponName] or 0
            refreshConfigControls(_V[1]({164,148,138,135,86,109,106,109,96,91,56,62,50,57,48,39},57,248), weaponName)
            refreshConfigControls(_V[1]({55,125,201,28,65,174,1,90,163,244,22,135,218,35,123,190},118,78), XCConfig.skinEditorFinish)
            refreshConfigControls(_V[1]({126,124,128,139,122,142,144,167},5,6), XCConfig.skinWear)
        end
    end)
    addButton(L, _V[1]({137,52,208,104,17,116,67,209,116,9,163,80,221,120,240,191,83,237,142},172,156), function()
        local weaponName = XCConfig.skinEditorWeapon
        XCConfig.weaponSkinSelections[weaponName] = XCConfig.skinEditorFinish
        XCConfig.weaponSkinWear[weaponName] = XCConfig.skinWear
        applyXCSelectedWeaponSkin()
    end)
    addButton(L, _V[1]({61,181,72,191,83,164,92,211,95,221,96,246,108,240,81,13,128,1,149,25,157},102,133), function()
        local weaponName = XCConfig.skinEditorWeapon
        XCConfig.weaponSkinSelections[weaponName] = _V[1]({142,47,176,43,191,54,190},202,128)
        XCConfig.weaponSkinWear[weaponName] = 0
        XCConfig.skinEditorFinish = _V[1]({125,79,1,173,114,26,211},136,177)
        XCConfig.skinWear = 0
        refreshConfigControls(_V[1]({0,65,136,214,246,94,172,0,68,144,173,25,103,171,254,60},68,73), _V[1]({20,155,2,99,221,58,168},106,102))
        refreshConfigControls(_V[1]({228,201,180,166,124,119,96,94},132,237), 0)
        restoreXCSelectedWeaponSkin(weaponName)
    end)

    section(R, _V[1]({118,14,126,240,100,148,76,198,52,182,36,151,25},182,117))
    addChoice(R, _V[1]({12,60,68,78,90,34,124,139,141,155,175},180,13), _V[1]({226,195,185,161,142,142,110,92,50,68,46,26,8,230,250,224,196},128,239), getXCKnifeChoices(), function()
        XCConfig.selectedSkin = _V[1]({70,61,20,229,207,156,122},44,214)
        refreshConfigControls(_V[1]({99,222,110,240,119,17,139,19,139,44,179,65},103,137), _V[1]({161,162,131,94,82,41,17},125,224))
        applyXCKnifeChanger()
    end)
    addChoice(R, _V[1]({202,134,26,176,72,156,123,23,181,73,236,122},230,153), _V[1]({4,198,157,102,52,21,214,165,100,76,26,239},193,208), function()
        return getXCSkinChoicesForWeapon(XCConfig.selectedKnifeType)
    end, function() applyXCKnifeChanger() end)
    addSlider(R, _V[1]({97,221,49,135,223,243,163,234,63,169},189,89), _V[1]({200,192,176,162,150,125,128,113,119},104,245), 0, 1, 0.01, _V[1]({},226,85), function() applyXCKnifeChanger() end)
    section(R, _V[1]({45,4,185,114,19,128,117,44,215,150,65,241,176},52,178))
    toggle(R, _V[1]({217,157,63,229,115,205,175,83,235,151,47,204,120},243,159), _V[1]({129,46,217,136,31,165,114,19,200,105,15,196,63,16,171,84,6,167,78},114,168))
    addChoice(R, _V[1]({196,12,50,92,110,76,188,225,249,29,71},90,35), _V[1]({33,20,28,22,21,39,25,25,253,35,39,47,31,8,43,33,35,43},173,1), getXCGloveModelChoices(), function()
        XCConfig.selectedGloveSkin = _V[1]({91,42,217,130,68,233,159},105,174)
        refreshConfigControls(_V[1]({55,99,164,215,15,90,133,190,219,58,119,184,225,9,91,147,210},138,58), _V[1]({224,223,190,151,137,94,68},190,222))
        applyXCGloves()
    end)
    addChoice(R, _V[1]({200,179,124,73,254,127,139,84,31,224,176,107},187,198), _V[1]({46,42,59,62,70,97,92,101,82,129,142,159,152,144,178,186,201},177,10), function()
        return getXCGloveSkinChoices(XCConfig.selectedGloveModel)
    end, function() applyXCGloves() end)
    addButton(R, _V[1]({41,189,66,195,85,161,81,217,89,219,95,191,74,201,117,255,135,19,135,26},99,133), function()
        applyXCKnifeChanger()
        applyXCGloves()
    end)
    addButton(R, _V[1]({42,222,173,96,48,189,159,107,44,193,181,110,45,243,185},23,193), function()
        table.clear(XCConfig.weaponSkinSelections)
        table.clear(XCConfig.weaponSkinWear)
        XCConfig.skinEditorFinish = _V[1]({26,12,222,170,143,87,48},5,209)
        XCConfig.skinWear = 0
        XCConfig.selectedKnifeType = _V[1]({73,142,179,210,10,37,81},225,36)
        XCConfig.selectedSkin = _V[1]({111,33,179,63,228,108,5},154,145)
        XCConfig.selectedGloveModel = _V[1]({60,199,50,151,21,118,232},142,106)
        XCConfig.selectedGloveSkin = _V[1]({255,181,75,219,132,16,173},38,149)
        restoreXCKnifeModel()
        restoreXCSelectedWeaponSkin()
        refreshConfigControls(_V[1]({124,66,14,225,134,115,70,31,232,185,91,76,31,232,192,131},59,206), _V[1]({32,108,152,190,253,31,82},177,43))
        refreshConfigControls(_V[1]({138,90,48,13,206,180,136,113},63,216), 0)
        refreshConfigControls(_V[1]({245,184,144,90,41,11,205,157,85,73,21,227,179,115,105,49,247},177,209), _V[1]({32,76,88,94,125,127,146},209,11))
        refreshConfigControls(_V[1]({62,65,89,99,114,148,150,166,166,207,222,244},186,17), _V[1]({28,35,10,235,229,194,176},242,230))
        refreshConfigControls(_V[1]({115,203,56,151,251,114,201,46,119,2,107,216,45,123,3,94,197,50},154,102), _V[1]({103,246,101,206,80,181,43},181,110))
        refreshConfigControls(_V[1]({247,151,76,243,159,94,253,170,59,14,191,116,17,173,115,31,210},214,174), _V[1]({62,38,238,176,139,73,24},51,199))
    end)

    task.wait()
    L, R = columns(_V[1]({182,189,178,141},126,235), _V[1]({132,167,160,167,168,183,176,176,194},43,4), _V[1]({234,107,213,85,185,41,140,251,112},38,110))
    section(L, _V[1]({74,70,62,40,8,248,225},13,234))
    toggle(L, _V[1]({157,72,204,63,116,19,150,25},222,126), _V[1]({195,194,186,161,107,130,121,69,96,69,56,52,31,16},112,242))
    toggle(L, _V[1]({176,151,86,30,249,176,141,82,31,151,173,116,72,19},147,202), _V[1]({142,191,232,26,95,128,199,246,45,59,140,202,255,4,97,136,189,251,40,91},231,52))
    section(L, _V[1]({33,206,73,205,65,212,73,207,78,211},96,128))
    toggle(L, _V[1]({53,207,55,168,9,137,235,94,202,60},135,109), _V[1]({211,104,235,119,243,142,11,153,32,173,7,184,51,188,78,207,86},234,136))
    addSlider(L, _V[1]({56,18,186,107,12,204,110,33,205,44,44,214,120,37,209},74,173), _V[1]({118,168,200,241,10,66,92,135,171,181,247,17,54,90},240,37), 0.1, 3, 0.1, _V[1]({108},40,204))
    toggle(L, _V[1]({112,191,220,2,24,77,100,140,173,129,239,20,54,89},13,34), _V[1]({129,187,227,20,53,117,151,202,246,1,81,126,172},243,45))
    addButton(L, _V[1]({186,167,175,170,145,156,152,94,121,128,117,115,97,110,93,93,86},110,250), playXCAnimation)
    section(L, _V[1]({216,74,145,238,41,123,225},56,80))
    toggle(L, _V[1]({98,236,83,175,20,137,234,96,119,45,152,246,96},166,105), _V[1]({197,79,214,82,215,108,237,131,231,146,16,154,3,181,49,187,78,208,88},201,137))
    addChoice(L, _V[1]({79,123,132,130,137,160,163,187,116,193,211,227,228},241,11), _V[1]({231,5,32,48,73,114,135,177,167,222,15},87,29), {_V[1]({234,59},67,97), _V[1]({107,118},11,26), _V[1]({176,48},220,142), _V[1]({12,211},242,212), _V[1]({239,11,59},120,49)})
    section(R, _V[1]({227,207,164,143,94,57,7,225,193},180,217))
    toggle(R, _V[1]({58,151,192,236,18,59,25,140,176,232,9,67},204,43), _V[1]({200,3,42,84,120,159,163,229,27,58,114,109,191,219,5,56,90,130},60,41))
    addSlider(R, _V[1]({36,3,214,146,103,218,216},22,198), _V[1]({32,173,38,162,24,145,231,123,3,116,254,94},66,123), -2, 2, 0.1, _V[1]({},224,108))
    addSlider(R, _V[1]({1,52,91,107,148,91,174},159,26), _V[1]({96,130,144,161,172,186,165,206,235,241,16,6},237,16), -2, 2, 0.1, _V[1]({},98,113))
    addSlider(R, _V[1]({226,11,40,46,77,10,84},138,16), _V[1]({198,38,114,193,10,86,127,230,65,133,226,23},21,78), -2, 2, 0.1, _V[1]({},10,177))
    addSlider(R, _V[1]({20,15,254,214,199,86,136,99,80,33,8},234,226), _V[1]({128,11,130,252,112,231,59,205,83,194,74,160,50,182,30,156},164,121), -45, 45, 1, _V[1]({250,83},205,107))
    addSlider(R, _V[1]({175,28,125,199,42,43,216,20,126},19,84), _V[1]({19,145,251,104,207,57,128,5,126,224,91,173,33,163},68,108), -45, 45, 1, _V[1]({129,119},183,8))
    addSlider(R, _V[1]({130,182,222,239,25,225,78,102,126,153},31,27), _V[1]({110,181,232,30,78,129,145,223,33,76,144,164,246,40,93},214,53), -90, 90, 1, _V[1]({127,80},218,227))
    section(R, _V[1]({72,17,200,146,76,6,115,132,50,247,180,91,33,227},54,187))
    toggle(R, _V[1]({97,78,41,23,245,211,100,134,106,66,45,18},43,223), _V[1]({22,234,204,193,166,139,70,81,48,34,14,198,213,174,149,133,100,73},185,230))
    addChoice(R, _V[1]({126,118,92,85,62,39,195,250,216,213,176,167,136,106,95},61,234), _V[1]({47,182,75,243,139,35,145,79,225,134,37,152,83,225,123},31,153), {_V[1]({117,55,201,120,21},145,157), _V[1]({154,96,0,142,45,171,107,4,168,61},183,157), _V[1]({242,102,209,26,129},73,92), _V[1]({96,117,103,92,84,69,55,44,44},36,244), _V[1]({33,231,160,78},36,175)})
    section(R, _V[1]({64,154,184,223,255,53,8,116,156,195,233,14,70,108},215,39))
    toggle(R, _V[1]({73,20,163,59,204,115,183,163,57,192,96,251},111,152), _V[1]({239,213,159,114,62,32,211,196,134,97,55,227,223,165,121,86,34,244},186,211))
    toggle(R, _V[1]({10,240,154,77,249,187,26,19,204,116,57,225},21,179), _V[1]({186,174,134,103,65,49,228,235,193,180,138,72,82,38,8,243,205,173},119,225))
    toggle(R, _V[1]({162,51,136,230,61,170,180,91,189,30,109,205,60,153},2,94), _V[1]({198,37,104,180,249,84,117,229,52,113,191,28,57,174,237,58,144,213,32},24,76))
    toggle(R, _V[1]({15,34,46,55,47,64,76,249,81,83,70,82,89},185,4), _V[1]({210,61,140,228,53,156,212,74,145,235,69,170,226,73,169,6,82,183,23},24,88))
    addChoice(R, _V[1]({162,228,247,35,74,34,153,190,231,254,27},42,36), _V[1]({27,142,229,69,158,13,77,203,26,124,222,75,140,13,114,197,30},89,96), {_V[1]({70,252,139,11,159},120,140), _V[1]({239,182,58,200,94,229,119,21},27,145)})
    addSlider(R, _V[1]({33,183,30,158,25,69,1,138,255,102,241,94,220,83},85,120), _V[1]({37,157,249,94,188,48,117,248,76,179,26,140,195,89,187,15,135,225,76,176},94,101), 0.05, 3, 0.05, _V[1]({229},179,191))
    addSlider(R, _V[1]({101,200,252,73,145,138,38,93,157,242,43},204,69), _V[1]({2,157,28,164,37,188,36,202,65,203,85,234,87,241,116,12,136},24,136), 0.02, 0.5, 0.01, _V[1]({},100,172))
    section(R, _V[1]({234,77,164,233,70,146,207,48,115,199,20,20,165,248,67,143,229,45,136},76,78))
    toggle(R, _V[1]({54,133,143,175,135,231,9,35,62,99,122,164},214,29), _V[1]({34,198,69,218,74,1,144,32,186,70,229,74,5,138,29,185,68,213},45,146))
    addSlider(R, _V[1]({204,103,189,41,77,250,104,219,69,155,17,111,218},32,105), _V[1]({166,51,155,25,114,18,138,3,134,251,131,208,112,245,113,217,97,209,78},200,123), 1, 100, 1, _V[1]({},85,49))

    task.wait()
    L, R = columns(_V[1]({180,88,213,117,233,126,7},220,136), _V[1]({224,132,44,184,77,243,54,19,173,71,230,110,18,160,60,204},245,151), _V[1]({14,158,246,108,207,45,174,190,118,224,77,171,26,130,240},86,105))
    section(L, _V[1]({102,222,90,186,35,157,180,113,223,65,165,30},167,107))
    toggle(L, _V[1]({212,175,115,49,241,161,25,42,216,145,90,23,200,152,70,17},206,189), _V[1]({143,142,154,156,174,189,147,196,209,193,219,224,245,212,2,8,15,32},19,9))
    toggle(L, _V[1]({102,23,191,83,234,146,41,130,116,255,174,65,221,138,39,114,95,252,152,67},114,158), _V[1]({98,109,133,147,177,204,174,235,4,2,42,73,84,98,129,143,130,188,206,225,254},218,21))
    addChoice(L, _V[1]({114,56,211,125,36,191,110,23,98,86,246,143,75,219,140},126,164), _V[1]({249,95,186,36,139,230,85,190,249,121,210,78,158,15,79,198,54,146},37,100), currentPlayerChoices())
    section(L, _V[1]({211,38,77,135,187,150,22,71,108,147,207},98,46))
    toggle(L, _V[1]({22,157,22,144,171,113,212,66,192,50,152,29,128,0},81,114), _V[1]({30,199,100,20,190,66,251,166,82,211,136,40,216,124,20,203,96,18},23,164))
    toggle(L, _V[1]({190,79,180,44,158,183,119,212,60,180,211,130,243,92,198,58},15,108), _V[1]({56,135,202,32,112,155,246,60,146,178,33,104,176,2},139,74))
    toggle(L, _V[1]({218,32,58,103,142,92,204,225,2,44,86,117,140,179,211},118,33), _V[1]({76,134,180,245,48,65,138,191,253,59,110,153,212,8},180,53))
    addSlider(L, _V[1]({247,69,103,156,203,161,16,60,104,145},139,41), _V[1]({100,36,216,159,96,238,204,138,69,232,193,107,51,243,171,87,35,209,149,69,22},70,187), 0, 1, 0.05, _V[1]({},241,8))
    addSlider(L, _V[1]({145,20,107,213,57,68,241,85,178,8,99,198,27},240,94), _V[1]({130,160,178,215,246,235,42,66,83,105,135,151,159,214,222,4,34,56,66,108,120,154,168,215},6,25), 0, 1, 0.05, _V[1]({},75,243))
    section(R, _V[1]({60,151,235,43,130,183,5,6,146,219,50,103,183,2,81},166,72))
    toggle(R, _V[1]({151,67,232,121,33,167,70,152,117,19,182,80,214,124,10,165},176,153), _V[1]({141,208,2,26,100,160,221,223,57,120,174,208,18,60,115},243,53))
    toggle(R, _V[1]({51,252,190,108,49,212,144,255,253,176,98,35,225,139},47,182), _V[1]({178,204,213,196,229,248,12,233,18,26,49,69,69},65,12))
    toggle(R, _V[1]({141,167,186,185,207,195,208,144,238,227,230,252,2,8},56,7), _V[1]({145,242,108,204,85,208,76,160,34,146,21,136,251},169,116))
    addSlider(R, _V[1]({177,208,232,179,25,41,42,73,96,111,114,149,154,181,188,228},75,18), _V[1]({174,225,45,96,196,249,76,151,218,17,104,161,240,43,135},244,70), 0, 0.9, 0.05, _V[1]({},227,167))
    section(R, _V[1]({46,217,115,224,209,111,5,157,63,213},76,157))
    addSlider(R, _V[1]({231,98,185,175,81,147,226,42,128,209,22,114,192},87,78), _V[1]({228,201,170,94,74,35,245,213,176,127,101,61},170,216), 1, 3, 0.1, _V[1]({},136,203))
    addSlider(R, _V[1]({201,132,7,160,35,182,71,146,102,251,149,38,163,64,197,87},242,144), _V[1]({217,6,27,70,91,128,163,173,227,28,10,81,125,160},80,34), 200, 3000, 50, _V[1]({},113,195))

    task.wait()
    L, R = columns(_V[1]({84,52,231,147,74,252,188},93,180), _V[1]({214,91,193,18,127,211,46,144,242},45,96), _V[1]({214,130,1,121,252,122,179,128,244,129,244,122,248,133},19,128))
    section(L, _V[1]({58,192,87,236,37,185,65,23,178,47},63,142))
    toggle(L, _V[1]({249,168,59,190,73,218,98,238,143,18,166,51,198},29,142), _V[1]({178,140,131,107,72,53,22,10,210,207,190,174,109,118,99,64,37,16,242,216,211,176,158,133,114},87,232))
    toggle(L, _V[1]({1,63,79,100,103,123,158,92,187,207,214,233},172,18), _V[1]({142,74,35,237,172,123,62,20,174,164,108,57,244,192,155,62,42,233,180},81,202))
    toggle(L, _V[1]({119,199,226,249,25,35,84,95,54,149,189,216,236,11,37},26,28), _V[1]({30,92,183,3,68,149,218,50,76,204,23,94,142,232,73,132},95,76))
    toggle(L, _V[1]({221,156,100,10,204,124,37,235,153},209,181), _V[1]({254,168,123,44,249,180,104,57,242,140,117,40,233,179,108,43},199,192))
    toggle(L, _V[1]({159,169,165,162,64,91,90,82},87,245), _V[1]({255,171,128,51,2,191,117,72,3,173,132,77,23,168,116,57},198,194))
    toggle(L, _V[1]({184,243,32,78,29,147,178,221,252},63,38), _V[1]({16,11,47,49,79,91,96,130,140,133,171,195,220,198,240,6,16},136,17))
    toggle(L, _V[1]({57,229,131,34,98,71,209,116,3},79,151), _V[1]({97,195,78,183,60,175,27,164,21,117,2,129,1,80,219,95,207},114,120))
    addChoice(L, _V[1]({82,135,173,209,153,1,24,73},232,29), _V[1]({113,205,58,165,223,93,213},160,100), {_V[1]({55,210,84,217,105,204,101,234,107,253},97,132), _V[1]({64,51,14,246,159,165,126,94,54,13,228},26,218), _V[1]({175,238,20,61,113,104,188,227,17,55,92,129},53,40), _V[1]({32,245},245,229), _V[1]({123,228},189,120), _V[1]({133,28},154,165), _V[1]({199,55},4,125), _V[1]({22,176,94},33,175)})
    addNote(L, _V[1]({19,111,183,37,129,218,28,93,231,65,110,10,103,211,35,139,213,235,70,253,252,87,233,46,145,247,30,197,35,112,206,46,142,226,246,81,8,7,98,227,57,159,250,41,202,32,134,225,50,140,233,76,92,183,110,109,200,72,176,11,52,213,43,142,236,64,154},101,91))
    section(R, _V[1]({232,124,11,148,41,190,73,233},230,146))

    local configName = _V[1]({162,155,116,71,51,2,226},134,216)
    local function safeName(value)
        value = tostring(value or _V[1]({85,50,239,166,118,41,237},85,188)):gsub(_V[1]({241,16,243,97,43,79,99,185,150,239},122,28), _V[1]({},31,87)):sub(1, 48)
        return value ~= _V[1]({},114,222) and value or _V[1]({127,150,141,126,136,117,115},69,246)
    end
    local nameBox = Instance.new(_V[1]({40,32,26,253,178,198,182},237,231))
    nameBox.Size = UDim2.new(1, 0, 0, 24)
    nameBox.BackgroundColor3 = C.Control
    nameBox.BorderColor3 = C.Black
    nameBox.BorderSizePixel = 1
    nameBox.PlaceholderText = _V[1]({87,196,4,61,129,192,186,73,125,202,3},211,65)
    nameBox.Text = configName
    nameBox.TextColor3 = C.Text
    nameBox.Font = Enum.Font.Code
    nameBox.TextSize = 10
    nameBox.Parent = activeSectionByParent[R] or R
    local status = Instance.new(_V[1]({8,151,40,162,248,139,10,139,16},54,126))
    status.Size = UDim2.new(1, 0, 0, 20)
    status.BackgroundTransparency = 1
    status.Text = _V[1]({47,156,30,204,77,199,76,204,90,152,47,210,85,210,104,225,107,167,101,240,110,239},85,130)
    status.TextColor3 = C.Muted
    status.Font = Enum.Font.Code
    status.TextSize = 9
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = activeSectionByParent[R] or R
    local function configPath() return _V[1]({232,121,31,241,150,52,221,129,51,149},234,166) .. safeName(nameBox.Text) .. _V[1]({42,192,35,121,210},162,90) end
    local autoSaveSerial = 0
    local function saveCurrentConfig(prefix)
        local ok = pcall(function()
            if type(makefolder) == _V[1]({252,243,212,177,170,135,117,92},174,232) and type(isfolder) == _V[1]({118,113,86,55,52,21,7,242},36,236) and not isfolder(_V[1]({235,24,90,200,9,67,136,200,22},81,66)) then makefolder(_V[1]({183,125,88,95,57,12,234,195,170},132,219)) end
            assert(type(writefile) == _V[1]({204,72,174,16,142,240,99,207},249,109), _V[1]({110,105,68,21,168,161,136,89,8,53,6,209,190,129,97,60,9,226,196,149},80,216))
            local saveData = {}
            for key, value in pairs(XCConfig) do saveData[key] = value end
            if XCFeatureState.streamerSnapshot then
                for key, value in pairs(XCFeatureState.streamerSnapshot) do saveData[key] = value end
                saveData.streamerModeEnabled = false
            end
            writefile(configPath(), HttpService:JSONEncode(saveData))
        end)
        status.Text = ok and ((prefix or _V[1]({1,217,216,177,154},164,234)) .. _V[1]({150,188},28,64) .. safeName(nameBox.Text)) or _V[1]({214,77,235,99,167,133,7,131,33,149,38,178,48,186,77,207},218,137)
        status.TextColor3 = ok and C.Lime or Color3.fromRGB(218, 82, 82)
        return ok
    end
    scheduleConfigAutoSave = function()
        if not XCConfig.settingsAutoSave then return end
        autoSaveSerial += 1
        local serial = autoSaveSerial
        task.delay(0.8, function()
            if serial == autoSaveSerial and XCConfig.settingsAutoSave and screenGui.Parent then
                saveCurrentConfig(_V[1]({155,132,88,40,1,196,174,114,70},101,213))
            end
        end)
    end
    nameBox.FocusLost:Connect(function()
        status.Text = configPath()
        status.TextColor3 = C.Muted
        scheduleConfigAutoSave()
    end)
    local function refreshAll()
        for key, keyRefreshers in pairs(refreshers) do
            for _, refresh in ipairs(keyRefreshers) do refresh(XCConfig[key]) end
        end
        updateScale()
    end

    section(L, _V[1]({46,208,98,250,160,243,210,114,33,180,88,245,152},31,158))
    addButton(L, _V[1]({61,239,189,121,52,236,147,120,62,9,184,122,69,255,155,125,64,18,200,150,70,226,208,147,73,27,211,141,92},44,193), function()
        for _, key in ipairs({
            _V[1]({29,105,177,234,59,132,153,6,61,130,208,13,80},120,68), _V[1]({121,244,124,250,136,19,101,18,155,248,166,30,164,51,177,53},129,133), _V[1]({51,232,150,75,2,183,123,34,230,162,42,10,180,108,45,221,147},8,183), _V[1]({71,164,24,132,207,106,221,28,179,20,131,251,98,207},103,110),
            _V[1]({151,164,168,173,181,200,160,208,202,210,227,227,233},42,7), _V[1]({216,90,212,89,221,67,241,105,239,126,252,128},224,133), _V[1]({209,28,96,147,169,15,81,103,206,255,62,134,189,250},50,62), _V[1]({58,78,86,113,134,103,159,161,177,202,210,224},200,15),
            _V[1]({32,36,16,18,254,250,244,205,244,234,184,218,198,192,195,181,173},192,249), _V[1]({230,17,35,66,95,124,167,158,230,248,24,65,89,119},97,31), _V[1]({241,219,172,138,111,80,46,8,192,199,152,119,95,54,19},173,222), _V[1]({202,90,247,156,42,178,99,12,169,65,220,79,20,163,64,230,123,22},186,156)
        }) do
            if XCConfig[key] then
                XCConfig[key] = false
                if UI_Bind_Registry[key] then UI_Bind_Registry[key](false) end
                pcall(specialToggle, key, false)
            end
        end
        XCNotify(_V[1]({99,147,191,217,242},244,31), _V[1]({73,126,162,170,202,204,154,240,15,32,40,58,96,31,115,147,156,107,193,210,241,252,28,30,240,80,101,109,145,155,167,200,136,223,247,20,21,41,70,82,100},245,19), _V[1]({27,99,210,44,133,232,63},70,94), 2)
    end)
    addButton(L, _V[1]({93,33,0,195,163,64,52,3,224,169,135,71},58,209), function()
        for _, key in ipairs({_V[1]({110,35,191,104,15,182,107,236,190,90,4,183,89,1},95,169), _V[1]({87,82,52,35,25,11,250,229,174,198,168,152,145,121,103},2,239), _V[1]({163,78,6,198,111,18,222,162,90,13,195,81,49,219,147,84,4,186},120,183), _V[1]({190,190,170,153,130,110,53,76,65,254,21,246,229,221,196,177},109,238)}) do
            XCConfig[key] = false
            if UI_Bind_Registry[key] then UI_Bind_Registry[key](false) end
        end
        stopXCCameraMode()
        setThirdPersonEnabled(false)
        if camera then camera.FieldOfView = 70 end
        XCNotify(_V[1]({99,224,75,162,14,92},193,95), _V[1]({46,81,98,95,113,101,41,129,135,121,145,135,71,158,150,169,175,175,183,175,179},230,5), _V[1]({20,171,46,195,90,253,146},12,149), 1.5)
    end)
    addButton(R, _V[1]({170,188,245,8,7,78,126,161,189,228,6},51,36), function()
        saveCurrentConfig(_V[1]({251,126,40,172,64},243,149))
    end)
    addButton(R, _V[1]({99,55,250,206,123,111,76,28,229,185,136},70,209), function()
        local ok = pcall(function()
            setXCStreamerMode(false)
            assert(type(readfile) == _V[1]({116,243,92,193,66,167,29,140},158,112), _V[1]({140,48,180,46,106,12,156,22,110,68,190,50,200,52,189,65,183,57,196,62},197,129))
            local data = HttpService:JSONDecode(readfile(configPath()))
            for key, value in pairs(data) do if XCConfig[key] ~= nil then XCConfig[key] = value end end
            lazyFeatureRequests.fireRate = XCConfig.fireRateEnabled == true
            lazyFeatureRequests.recoilSpread = XCConfig.noRecoilEnabled == true or XCConfig.noSpreadEnabled == true
            lazyFeatureRequests.silentFallback = XCConfig.silentAimEnabled == true
            refreshAll()
            updateMobileSlideVisibility(); refreshThirdPerson(); setWeaponVisuals(); updateCustomScope(); updateWorldPostFX()
            applyXCWeather()
            applyXCSmokeState()
            if XCConfig.freecamEnabled then setXCCameraMode(_V[1]({203,19,34,62,88,114,154},105,28), true)
            elseif XCConfig.freelookEnabled then setXCCameraMode(_V[1]({229,238,190,155,127,95,60,21},194,221), true)
            else stopXCCameraMode() end
            setXCStreamerMode(XCConfig.streamerModeEnabled)
            setAntiAfkEnabled(XCConfig.antiAfkEnabled)
            if XCConfig.animationsEnabled then playXCAnimation() else stopXCAnimation() end
            if XCConfig.nightModeEnabled then
                applyNightPreset(XCConfig.nightPreset)
            else
                Lighting.Brightness = defaultLighting.Brightness
                Lighting.ClockTime = defaultLighting.ClockTime
                Lighting.GlobalShadows = defaultLighting.GlobalShadows
                Lighting.Ambient = defaultLighting.Ambient
                Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
            end
            updateWorldChanger()
        end)
        status.Text = ok and (_V[1]({203,0,36,89,140,189,197,221},45,50) .. safeName(nameBox.Text)) or _V[1]({107,89,54,36,203,252,226,213,195,167,145},20,235)
    end)
    addButton(R, _V[1]({131,98,92,58,53,237,253,234,215,190,190,161,149,128},69,236), function()
        setXCStreamerMode(false)
        for key, value in pairs(XCConfigDefaults) do XCConfig[key] = deepCopyConfigValue(value) end
        lazyFeatureRequests.fireRate = false
        lazyFeatureRequests.recoilSpread = false
        lazyFeatureRequests.silentFallback = false
        refreshAll(); updateMobileSlideVisibility(); refreshThirdPerson(); setWeaponVisuals(); updateCustomScope(); updateWorldPostFX()
        stopXCCameraMode(); destroyXCWeather(); restoreXCSmoke(); restoreLightingState()
        setAntiAfkEnabled(XCConfig.antiAfkEnabled)
        status.Text = _V[1]({214,234,254,12,51,61,88,106,42,143,149,182,202,216,238,244,6},95,19)
    end)
    addButton(R, _V[1]({56,169,32,137,8,105,180,71,195,50,154,13,123},132,112), function()
        local ok = pcall(function() assert(type(delfile) == _V[1]({50,176,24,124,252,96,213,67},93,111)); delfile(configPath()) end)
        status.Text = ok and _V[1]({11,214,148,75,13,202,66,69,5,203,131,81,1,191},233,191) or _V[1]({120,54,250,176,124,42,162,165,93,34,226,152,84},87,189)
    end)

    applySearch = function()
        local query = searchBox.Text:lower():gsub(_V[1]({7,230,76,28},145,24), _V[1]({},221,113)):gsub(_V[1]({88,212,186,225},5,46), _V[1]({},241,36))
        local page = pages[currentPage]
        for _, entry in ipairs(searchableControls) do
            if page and entry.gui:IsDescendantOf(page) then
                entry.gui.Visible = query == _V[1]({},53,204) or entry.label:find(query, 1, true) ~= nil
            else
                entry.gui.Visible = true
            end
        end
        for _, group in ipairs(sectionGroups) do
            if page and group.outer:IsDescendantOf(page) then
                local anyVisible = false
                for _, child in ipairs(group.body:GetChildren()) do
                    if child:IsA(_V[1]({126,100,16,174,121,57,236,162,107},127,184)) and child.Visible then anyVisible = true break end
                end
                group.outer.Visible = query == _V[1]({},25,43) or anyVisible
                if query ~= _V[1]({},90,190) then
                    group.body.Visible = anyVisible
                else
                    group.body.Visible = not group.collapsed
                end
            else
                group.outer.Visible = true
                group.body.Visible = not group.collapsed
            end
        end
        clearSearch.TextColor3 = query ~= _V[1]({},195,247) and C.Lime or C.Muted
    end
    table.insert(connections, searchBox:GetPropertyChangedSignal(_V[1]({141,201,7,46},14,43)):Connect(applySearch))
    task.spawn(function()
        while xcSessionActive() and screenGui.Parent do
            task.wait(0.75)
            for _, refreshStatus in ipairs(moduleStatusRefreshers) do pcall(refreshStatus) end
        end
    end)
    switchPage(_V[1]({14,158,37,164},59,129))

    local menuVisible = true
    local function toggleMenu()
        closeDropdown()
        hideHelp()
        main.Visible = not main.Visible
        menuVisible = main.Visible
        XCFeatureState.menuOpen = main.Visible
    end
    table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        local key = Enum.KeyCode[XCConfig.menuKey or _V[1]({82,122,137,155,184,168,206,224,238,13},239,17)]
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

    local openBtn = Instance.new(_V[1]({139,43,205,88,181,119,5,148,30,172},168,143))
    openBtn.Name = _V[1]({96,218,104,42,184,71,209,95},121,143)
    openBtn.Size = UDim2.fromOffset(56, 48)
    openBtn.Position = savedPos.OpenBtn
    openBtn.BackgroundColor3 = C.Panel
    openBtn.BorderColor3 = C.Lime
    openBtn.BorderSizePixel = 1
    openBtn.RichText = true
    openBtn.Text = _V[1]({213,2,14,16,25,200,14,29,29,35,41,247,223,50,42,40,241,253,4,4,1,10,11,18,13,20,16,12,43,72,47,37,95,107,109,118,67,68,113,125,127,136,55,125,140,140,146,152,102,78,161,153,151,96,109,115,118,112,121,127,130,124,133,139,142,133,129,160,168,164,154,212,224,226,235,184},150,3)
    openBtn.TextColor3 = C.White
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = 23
    openBtn.AutoButtonColor = false
    openBtn.Active = true
    openBtn.Parent = toggleGui
    local corner = Instance.new(_V[1]({251,144,43,248,156,57,209,127},5,161))
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = openBtn
    dragObject(openBtn, openBtn, true)
end

local thirdPersonCameraConnection
local thirdPersonMetaInstalled = false

function installThirdPersonProtection()
    if thirdPersonMetaInstalled then return end
    if type(getrawmetatable) ~= _V[1]({69,199,51,155,31,135,0,114},108,115) or type(setreadonly) ~= _V[1]({35,18,235,192,177,134,108,75},221,224) then return end
    if type(newcclosure) ~= _V[1]({54,1,182,103,52,229,167,98},20,188) then return end

    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end

        local oldNewIndex = mt.__newindex
        if type(oldNewIndex) ~= _V[1]({29,187,67,199,103,235,128,14},40,143) then return end

        setreadonly(mt, false)
        mt.__newindex = newcclosure(function(self, key, value)
            if self == player and XCConfig.thirdPersonEnabled then
                local distance = math.clamp(
                    tonumber(XCConfig.thirdPersonDistance) or 12,
                    5,
                    50
                )

                if key == _V[1]({167,89,249,133,38,169,41,223,104,253},208,148) then
                    return oldNewIndex(self, key, Enum.CameraMode.Classic)
                elseif key == _V[1]({76,40,242,168,115,32,202,156,113,17,228,162,94,243,214,158,93,8,211,134,70},75,190) then
                    return oldNewIndex(self, key, distance)
                elseif key == _V[1]({78,216,80,180,45,136,224,104,217,49,178,30,136,203,92,210,63,152,17,114,224},159,108) then
                    return oldNewIndex(self, key, distance)
                end
            end

            return oldNewIndex(self, key, value)
        end)
        setreadonly(mt, true)
        thirdPersonMetaInstalled = true
    end)
end

function reconnectThirdPersonCamera()
    if thirdPersonCameraConnection then
        thirdPersonCameraConnection:Disconnect()
        thirdPersonCameraConnection = nil
    end

    if not camera then return end

    thirdPersonCameraConnection = camera:GetPropertyChangedSignal(_V[1]({6,164,48,168,53,164,23,188,51,168},67,128)):Connect(function()
        if not XCConfig.thirdPersonEnabled or not camera then return end

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

local currentCameraConnection = Workspace:GetPropertyChangedSignal(_V[1]({137,42,150,5,103,223,84,146,31,154,1,125,219},215,111)):Connect(function()
    camera = Workspace.CurrentCamera or camera
    reconnectThirdPersonCamera()

    if XCConfig.thirdPersonEnabled and camera then
        applyThirdPerson()
    end
end)
table.insert(connections, currentCameraConnection)

local xcRecoilSpreadInstalled = false
local xcFireRateInstalled = false
local xcFireRateObjects = {}
local xcFireRateOriginal = {}
local xcFireRateReadonly = {}
local xcFireRateScanDone = false
local xcRecoilSpreadRetrying = false
local xcFireRateGetWeapon = nil
local xcFireRateWeaponRecords = setmetatable({}, {__mode = _V[1]({142},132,159)})

local function resolveXCFireRateGetWeapon()
    if type(xcFireRateGetWeapon) == _V[1]({92,141,168,191,242,9,49,82},212,34) then return true end
    pcall(function()
        local controllers = ReplicatedStorage:FindFirstChild(_V[1]({7,80,108,143,170,196,222,251,17,59,89},167,29))
        local scriptObject = controllers and controllers:FindFirstChild(_V[1]({127,250,88,157,252,88,169,2,95,127,1,86,178,6,89,172,2,81,180},224,86))
        local inventory = scriptObject and require(scriptObject)
        if type(inventory) == _V[1]({107,194,45,161,4},141,106) and type(inventory.peekCurrentEquippedForMovement) == _V[1]({99,186,251,56,145,206,28,99},181,72) then
            xcFireRateGetWeapon = inventory.peekCurrentEquippedForMovement
        end
    end)
    return type(xcFireRateGetWeapon) == _V[1]({135,74,247,160,101,14,200,123},109,180)
end

local function restoreXCNativeFireRate(exceptWeapon)
    for weapon, record in pairs(xcFireRateWeaponRecords) do
        if weapon ~= exceptWeapon then
            pcall(function()
                local properties = record.Properties
                if type(properties) == _V[1]({16,194,136,87,21},215,197) then
                    if type(setreadonly) == _V[1]({87,170,231,32,117,174,248,59},173,68) then setreadonly(properties, false) end
                    rawset(properties, _V[1]({129,133,111,67,17,1,245,199},90,225), record.OriginalFireRate)
                    if type(setreadonly) == _V[1]({253,169,63,209,127,17,180,80},250,157) and record.Readonly ~= nil then
                        setreadonly(properties, record.Readonly)
                    end
                end
            end)
            xcFireRateWeaponRecords[weapon] = nil
        end
    end
end

local function applyXCNativeFireRate()
    if not resolveXCFireRateGetWeapon() then return false end
    local okWeapon, weapon = pcall(xcFireRateGetWeapon)
    if not okWeapon or type(weapon) ~= _V[1]({204,51,174,50,165},222,122) or weapon.IsDestroyed
        or type(weapon.Properties) ~= _V[1]({23,141,23,170,44},26,137) then return false end

    restoreXCNativeFireRate(weapon)
    local record = xcFireRateWeaponRecords[weapon]
    if record and weapon.Properties ~= record.Properties then
        restoreXCNativeFireRate(nil)
        record = nil
    end
    if not record then
        local readonly = nil
        if type(isreadonly) == _V[1]({221,119,251,123,23,151,40,178},236,139) then
            local okReadonly, value = pcall(isreadonly, weapon.Properties)
            if okReadonly then readonly = value == true end
        end
        record = {
            Properties = weapon.Properties,
            OriginalFireRate = rawget(weapon.Properties, _V[1]({237,82,157,210,1,82,167,218},101,66)),
            OriginalAutomatic = rawget(weapon.Properties, _V[1]({112,100,35,222,156,80,35,216,146},111,192)),
            Readonly = readonly,
        }
        xcFireRateWeaponRecords[weapon] = record
    end

    local requested = math.max(tonumber(XCConfig.fireRate) or 0.03, 0.01)
    local originalRate = tonumber(record.OriginalFireRate) or requested
    local stableRate = math.max(requested, 0.03, originalRate * 0.40)
    if UserInputService.TouchEnabled then

        record.Rate = stableRate
        return true
    end
    if record.Rate == stableRate
        and rawget(record.Properties, _V[1]({73,178,1,58,109,194,27,82},189,70)) == stableRate then
        return true
    end

    local properties = record.Properties
    if type(setreadonly) == _V[1]({32,162,14,118,250,98,219,77},71,115) then setreadonly(properties, false) end
    rawset(properties, _V[1]({108,233,76,153,224,73,182,1},204,90), stableRate)
    if type(setreadonly) == _V[1]({133,188,221,250,51,80,126,165},247,40) and record.Readonly ~= nil then
        setreadonly(properties, record.Readonly)
    end
    record.Rate = stableRate
    return true
end

if genv then
    genv.XCRestoreWeaponState = function()
        restoreXCNativeFireRate(nil)
        restoreXCFireRates()
    end
end

function scanXCFireRateObjects()
    if xcFireRateScanDone then return #xcFireRateObjects > 0 end
    if type(getgc) ~= _V[1]({206,204,180,152,152,124,113,95},121,239) then return false end

    local found = false
    pcall(function()
        for _, obj in next, getgc(true) do
            if type(obj) == _V[1]({143,24,181,91,240},127,156) then
                local fireRate = rawget(obj, _V[1]({173,126,53,214,113,46,239,142},185,174))
                if type(fireRate) == _V[1]({112,31,191,92,7,188},90,168) then
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
                        if type(isreadonly) == _V[1]({157,151,123,91,87,55,40,18},76,235) then
                            local okReadonly, readonly = pcall(isreadonly, obj)
                            if okReadonly then xcFireRateReadonly[obj] = readonly == true end
                        end
                        found = true
                    end
                end
            end
        end
    end)

    xcFireRateScanDone = true
    return found or #xcFireRateObjects > 0
end

function restoreXCFireRates()
    for _, obj in ipairs(xcFireRateObjects) do
        pcall(function()
            if type(setreadonly) == _V[1]({81,69,35,253,243,205,184,156},6,229) then setreadonly(obj, false) end
            local original = xcFireRateOriginal[obj]
            if type(original) == _V[1]({19,205,120,32,214,150},242,179) then
                rawset(obj, _V[1]({67,188,27,100,167,12,117,188},167,86), original)
            end

            if type(setreadonly) == _V[1]({122,71,254,177,128,51,247,180},86,190) and xcFireRateReadonly[obj] ~= nil then
                setreadonly(obj, xcFireRateReadonly[obj])
            end
        end)
    end
end

function applyXCFireRate()
    local requested = math.max(tonumber(XCConfig.fireRate) or 0.03, 0.01)
    for _, obj in ipairs(xcFireRateObjects) do
        pcall(function()
            if type(setreadonly) == _V[1]({251,2,243,224,233,214,212,203},157,248) then setreadonly(obj, false) end
            local original = tonumber(xcFireRateOriginal[obj]) or requested

            local stableMinimum = math.max(0.03, original * 0.40)
            rawset(obj, _V[1]({162,70,208,68,178,66,214,72},219,129), math.max(requested, stableMinimum))
            if type(setreadonly) == _V[1]({39,4,203,142,109,48,4,209},243,206) and xcFireRateReadonly[obj] ~= nil then
                setreadonly(obj, xcFireRateReadonly[obj])
            end
        end)
    end
end

task.spawn(function()
    local wasEnabled = false
    while xcSessionActive() and task.wait(0.1) do
        pcall(function()
            if XCConfig.fireRateEnabled and lazyFeatureRequests.fireRate then
                local nativeApplied = applyXCNativeFireRate()
                if nativeApplied then

                    if #xcFireRateObjects > 0 then restoreXCFireRates() end
                elseif not UserInputService.TouchEnabled then
                    if not xcFireRateScanDone then scanXCFireRateObjects() end
                    if #xcFireRateObjects == 0 then

                        xcFireRateScanDone = false
                        scanXCFireRateObjects()
                    end
                    applyXCFireRate()
                else

                    restoreXCFireRates()
                end
            elseif wasEnabled then
                restoreXCNativeFireRate(nil)
                restoreXCFireRates()
            end
            wasEnabled = XCConfig.fireRateEnabled
        end)
    end
end)

task.spawn(function()
    local heldLast = false
    local heldWeapon = nil
    local nextShot = 0
    while xcSessionActive() and task.wait(0.01) do
        if not (XCConfig.fireRateEnabled and lazyFeatureRequests.fireRate)
            or not resolveXCFireRateGetWeapon() then
            heldLast, heldWeapon, nextShot = false, nil, 0
            continue
        end
        local okWeapon, weapon = pcall(xcFireRateGetWeapon)
        local record = okWeapon and weapon and xcFireRateWeaponRecords[weapon] or nil
        local held = record and record.OriginalAutomatic ~= true and weapon.IsFireHeld == true
        if not held then
            heldLast, heldWeapon, nextShot = false, weapon, 0
            continue
        end
        if weapon ~= heldWeapon or not heldLast then
            heldWeapon, heldLast = weapon, true
            nextShot = os.clock() + math.max(tonumber(record.Rate) or 0.08, 0.03)
            continue
        end
        local now = os.clock()
        if now >= nextShot and type(weapon.shoot) == _V[1]({109,113,95,73,79,57,52,40},18,245)
            and not weapon.IsShooting and not weapon.IsBurstShooting then
            nextShot = now + math.max(tonumber(record.Rate) or 0.08, 0.03)
            pcall(function() weapon:shoot() end)
        end
    end
end)

function installXCRecoilSpread()
    if xcRecoilSpreadInstalled then return true end
    if type(getgc) ~= _V[1]({11,207,125,39,237,151,82,6},240,181) or type(hookfunction) ~= _V[1]({221,59,131,199,39,107,192,14},40,79) then
        return false
    end
    if type(debug) ~= _V[1]({4,152,64,241,145},233,167) or type(debug.getinfo) ~= _V[1]({192,78,198,58,202,62,195,65},219,127) then
        return false
    end

    local hookedSomething = false

    pcall(function()
        for _, obj in next, getgc(true) do

            if type(obj) == _V[1]({126,149,192,244,23},224,42) then
                local setRecoil = rawget(obj, _V[1]({236,241,19,9,42,57,91,109,127,118,156,173,204,217,239},102,19))
                if typeof(setRecoil) == _V[1]({29,141,231,61,175,5,108,204},86,97) then
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

                local weaponKick = rawget(obj, _V[1]({145,28,181,97,253,153,19,206,101,10},125,157))
                if typeof(weaponKick) == _V[1]({243,228,191,150,137,96,72,41},171,226) then
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

                local getSpread = rawget(obj, _V[1]({133,254,136,227,124,250,101,206,102,227,81,200,70},163,123))
                if typeof(getSpread) == _V[1]({40,160,2,96,218,56,167,15},89,105) then
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

            if type(obj) == _V[1]({44,211,100,241,154,39,197,92},46,152) then
                local info
                pcall(function() info = debug.getinfo(obj) end)
                if type(info) == _V[1]({174,193,232,24,55},20,38) and info.name == _V[1]({202,61,189,41,176,28,134,14,116,214,94,209,82,193,57,145,29,146,20,123,255},242,117) then
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

local xcSilentSendHooked = false

local function beginXCSilentPayloadTransactionV31(data)
    if xcNativeSilentHooked or not UserInputService.TouchEnabled or not isXCSilentAimRequested()
        or type(data) ~= _V[1]({218,125,52,244,163},176,182) or type(data.Bullets) ~= _V[1]({111,28,221,167,96},59,192) then return nil end

    local context = getXCSilentShotContextV31(false)
    if context and context.CameraUsed then return nil end

    local targetPart = context and context.Target or (getSilentAimTarget and getSilentAimTarget() or silentAimResolved)
    local allowed = context and context.Allowed
    if not context then
        local chance = math.clamp(tonumber(XCConfig.silentAimHitChance) or 100, 0, 100)
        allowed = targetPart ~= nil and targetPart.Parent ~= nil
            and (chance >= 100 or math.random(1, 100) <= chance)
    end
    if not allowed or not targetPart or not targetPart.Parent then return nil end

    local aimPos = getKinematicAimPosition(targetPart)
    local activeCamera = Workspace.CurrentCamera or camera
    local fallbackOrigin = activeCamera and activeCamera.CFrame.Position or nil
    local undo = {}

    local function remember(tbl, key, value)
        table.insert(undo, {Table = tbl, Key = key, Value = value})
    end

    for _, bullet in pairs(data.Bullets) do
        if type(bullet) == _V[1]({142,199,20,106,175},206,76) then
            local origin = bullet.Origin or bullet.StartingPoint or bullet.Position or fallbackOrigin
            if typeof(origin) == _V[1]({181,192,244,235,255,255},106,8) then origin = origin.Position end
            if typeof(origin) == _V[1]({209,238,250,25,34,51,2},109,14) then
                local delta = aimPos - origin
                if delta.Magnitude > 0.001 then
                    if typeof(bullet.Direction) == _V[1]({144,170,179,207,213,227,175},47,11) then
                        remember(bullet, _V[1]({195,71,175,1,94,206,34,135,229},32,95), bullet.Direction)
                        local magnitude = bullet.Direction.Magnitude
                        bullet.Direction = delta.Unit * (magnitude > 0.001 and magnitude or 1)
                    end
                    if typeof(bullet.Ray) == _V[1]({211,127,52},228,157) then
                        remember(bullet, _V[1]({11,52,102},159,26), bullet.Ray)
                        bullet.Ray = Ray.new(bullet.Ray.Origin, delta.Unit * bullet.Ray.Direction.Magnitude)
                    end
                end
            end

            if type(bullet.Hits) == _V[1]({195,43,167,44,160},212,123) then
                for _, hitData in pairs(bullet.Hits) do
                    if type(hitData) == _V[1]({234,230,246,15,23},103,15) then
                        remember(hitData, _V[1]({103,17,155,33,147,37,159,38},153,133), hitData.Instance)
                        remember(hitData, _V[1]({34,185,53,163,38,147,17,136},90,120), hitData.Position)
                        hitData.Instance = targetPart
                        hitData.Position = targetPart.Position
                    end
                end
            end
        end
    end

    if #undo == 0 then return nil end
    if context then context.PayloadUsed = true end
    silentAimResolved = targetPart
    if registerXCLocalHitCandidate then registerXCLocalHitCandidate(targetPart) end

    return function()
        for index = #undo, 1, -1 do
            local item = undo[index]
            item.Table[item.Key] = item.Value
        end
    end
end

if sharedXCEnv then sharedXCEnv.XCBeginSilentPayloadTransactionV31 = beginXCSilentPayloadTransactionV31 end

function setupXCSilentSendHook()
    if xcSilentSendHooked then return end

    if bloxStrikeShootHooked and not UserInputService.TouchEnabled then return end
    if type(getgc) ~= _V[1]({34,210,108,2,180,74,241,145},27,161) or type(hookfunction) ~= _V[1]({149,94,17,192,139,58,250,179},117,186) then return end

    local sendFunc = nil
    local shootContainer = nil
    pcall(function()
        for _, obj in next, getgc(true) do
            if type(obj) == _V[1]({89,187,49,176,30},112,117) and rawget(obj, _V[1]({218,237,18,48,83},73,30)) and typeof(obj.shoot) == _V[1]({216,210,182,150,146,114,99,77},135,235) then
                for _, uv in pairs(debug.getupvalues(obj.shoot)) do
                    if type(uv) == _V[1]({147,130,133,145,140},29,2) then
                        local inventory = rawget(uv, _V[1]({18,80,113,121,155,186,206,234,10},176,25))
                        local shootWeapon = inventory and rawget(inventory, _V[1]({25,216,137,51,226,111,39,205,134,47,216},28,170))
                        if type(shootWeapon) == _V[1]({191,110,49,253,184},137,194) and typeof(shootWeapon.Send) == _V[1]({98,187,254,61,152,215,39,112},178,74) then
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

    if type(sendFunc) ~= _V[1]({134,111,66,17,252,203,171,132},70,218) then return end
    if shootContainer and rawget(shootContainer, _V[1]({89,62,28,236,225,220,196,162,144,123,63,54,36,255,200,212,185,154,106,44,15},21,229)) then
        xcSilentSendHooked = true
        return
    end

    local oldSend
    oldSend = hookfunction(sendFunc, function(...)
        local args = {...}
        local restorePayload = nil
        if UserInputService.TouchEnabled and type(args[1]) == _V[1]({20,227,198,178,141},190,226) then
            local beginTransaction = sharedXCEnv and sharedXCEnv.XCBeginSilentPayloadTransactionV31
                or beginXCSilentPayloadTransactionV31
            local okTransaction, restore = pcall(beginTransaction, args[1])
            if okTransaction and type(restore) == _V[1]({53,247,163,75,15,183,112,34},28,179) then restorePayload = restore end
        elseif type(args[1]) == _V[1]({45,185,89,2,154},26,159) then
            local prepare = sharedXCEnv and sharedXCEnv.XCPrepareSilentSendPayloadV28
            local okPrepare, prepared = pcall(function()
                if type(prepare) == _V[1]({195,58,155,248,113,206,60,163},245,104) then return prepare(args[1]) end
                return prepareXCSilentShotPayload(args[1], true)
            end)
            if okPrepare and type(prepared) == _V[1]({86,195,68,206,71},98,128) then args[1] = prepared end
        end

        local silentWasEnabled = XCConfig.silentAimEnabled
        XCConfig.silentAimEnabled = false
        local results = table.pack(pcall(oldSend, unpack(args)))
        XCConfig.silentAimEnabled = silentWasEnabled
        if restorePayload then pcall(restorePayload) end
        if not results[1] then error(results[2], 0) end
        return table.unpack(results, 2, results.n)
    end)

    if shootContainer then rawset(shootContainer, _V[1]({254,21,37,39,78,123,149,165,197,226,216,1,33,46,41,103,126,145,162,184},136,23), true) end
    if shootContainer then rawset(shootContainer, _V[1]({230,236,235,220,242,14,23,22,37,49,22,46,61,57,35,80,86,88,73,43,50},129,6), true) end
    if shootContainer then rawset(shootContainer, _V[1]({203,122,34,188,123,64,242,154,82,7,149,86,14,179,70,28,203,118,16,155,80},189,175), true) end
    if shootContainer then rawset(shootContainer, _V[1]({109,133,150,153,193,239,10,27,60,90,81,123,156,170,166,229,253,17,20,9,31},246,24), true) end
    xcSilentSendHooked = true
end

pcall(setupXCNativeSilentHook)
pcall(setupBloxStrikeShootHook)
pcall(setupXCCharacterInputHook)
pcall(setupXCCustomHandsHook)
task.spawn(function()
    while xcSessionActive() do
        if not xcCharacterInputHook.Ready and (XCConfig.antiAimEnabled or XCConfig.bunnyHopEnabled) then
            setupXCCharacterInputHook()
            task.wait(1.5)
        else
            task.wait(0.5)
        end
    end
end)
task.spawn(function()
    while xcSessionActive() and not xcNativeSilentHooked do
        if XCConfig.silentAimEnabled then
            setupXCNativeSilentHook()
            if not xcNativeSilentHooked then task.wait(1.0) end
        else
            task.wait(0.5)
        end
    end
end)
XCFeatureState.uiBuildOK, XCFeatureState.uiBuildError = pcall(buildXCUI)
if not XCFeatureState.uiBuildOK then
    warn(_V[1]({243,207,153,146,52,72,27,209,3,227,175,159,128,96,58,201,238,200,175,145,105,71,252,193},185,223) .. tostring(XCFeatureState.uiBuildError))
    pcall(function()
        if targetGui:FindFirstChild(_V[1]({41,34,64,94,123,124,138,161,136,196,198},195,14)) then targetGui.XCScreenGui:Destroy() end
        if targetGui:FindFirstChild(_V[1]({164,14,158,56,175,46,178,42,139,56,171},205,127)) then targetGui.XCToggleGui:Destroy() end
        XCFeatureState.fallbackGui = Instance.new(_V[1]({123,148,172,168,177,195,165,220,217},31,9))
        XCFeatureState.fallbackGui.Name = _V[1]({144,26,188,118,32,191,84,242,147,58,181,130,21},153,159)
        XCFeatureState.fallbackGui.ResetOnSpawn = false
        XCFeatureState.fallbackGui.IgnoreGuiInset = true
        XCFeatureState.fallbackGui.DisplayOrder = 999
        XCFeatureState.fallbackGui.Parent = targetGui
        XCFeatureState.fallbackCard = Instance.new(_V[1]({245,155,67,212,65,235,129,25,181},12,149))
        XCFeatureState.fallbackCard.Size = UDim2.fromOffset(340, 82)
        XCFeatureState.fallbackCard.Position = UDim2.new(0.5, -170, 0, 22)
        XCFeatureState.fallbackCard.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        XCFeatureState.fallbackCard.BorderColor3 = Color3.fromRGB(152, 204, 0)
        XCFeatureState.fallbackCard.BorderSizePixel = 1
        XCFeatureState.fallbackCard.TextColor3 = Color3.fromRGB(235, 235, 235)
        XCFeatureState.fallbackCard.Font = Enum.Font.Code
        XCFeatureState.fallbackCard.TextSize = 12
        XCFeatureState.fallbackCard.TextWrapped = true
        XCFeatureState.fallbackCard.Text = _V[1]({91,82,59,122,135,128,157,171,184,191,155,204,229,241,250,9,205},247,12) .. tostring(XCFeatureState.uiBuildError):sub(1, 220)
        XCFeatureState.fallbackCard.Parent = XCFeatureState.fallbackGui
    end)
end

function XCApplyXCTabAccent(button, active)
    pcall(function()
        local accent = button:FindFirstChild(_V[1]({226,64,177,70,202,50,178,20,99,248,107,224,92,213},23,115))
        if active then
            if not accent then
                accent = Instance.new(_V[1]({231,191,90,18,182},245,172))
                accent.Name = _V[1]({166,31,171,91,250,125,24,149,255,175,61,205,100,248},192,142)
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

local XCConfigSystem = {}
XCConfigSystem.Folder = _V[1]({218,4,67,174,236,35,101,162,237},67,63)
XCConfigSystem.ActiveName = _V[1]({60,41,246,189,157,96,52},44,204)

function cfgFileAPI()
    return type(isfile)==_V[1]({223,190,135,76,45,242,200,151},169,208) and type(readfile)==_V[1]({184,67,184,41,182,39,169,36},214,124) and type(writefile)==_V[1]({50,12,208,144,108,44,253,199},1,203)
end

function cfgSafeName(name)
    name=tostring(name or _V[1]({89,135,149,157,190,194,215},8,13)):gsub(_V[1]({201,80,155,113,163,47,171,105,174,111},234,132),_V[1]({},41,216)):sub(1,48)
    return name~=_V[1]({},153,133) and name or _V[1]({253,0,227,192,182,143,121},215,226)
end

function cfgPath(name)
    return XCConfigSystem.Folder.._V[1]({32},82,159)..cfgSafeName(name).._V[1]({207,117,232,78,183},55,106)
end

function cfgJSONEncode(v)
    local ok,res=pcall(function() return game:GetService(_V[1]({241,241,197,149,76,50,19,235,178,128,86},213,212)):JSONEncode(v) end)
    return ok and res or nil
end

function cfgJSONDecode(v)
    local ok,res=pcall(function() return game:GetService(_V[1]({37,190,43,148,228,99,221,78,174,21,132},112,109)):JSONDecode(v) end)
    return ok and res or nil
end

function cfgEnsureFolder()
    if type(makefolder)==_V[1]({184,19,88,153,246,55,137,212},6,76) and type(isfolder)==_V[1]({179,251,45,91,165,211,18,74},20,57) then
        pcall(function() if not isfolder(XCConfigSystem.Folder) then makefolder(XCConfigSystem.Folder) end end)
    end
end

function cfgSerialize()
    local out={}
    for k,v in pairs(XCConfig) do
        local t=typeof(v)
        if t==_V[1]({105,111,104,94,80,69,75},14,249) or t==_V[1]({111,254,126,251,134,27},121,136) or t==_V[1]({213,123,30,186,100,2},189,165) then
            out[k]=v
        elseif t==_V[1]({255,238,174,116,58,190},249,195) then
            out[k]={__type=_V[1]({240,39,47,61,75,23},162,11),r=v.R,g=v.G,b=v.B}
        elseif t==_V[1]({86,134,236,49,55},192,65) then
            out[k]={__type=_V[1]({252,57,172,254,17},89,78),xs=v.X.Scale,xo=v.X.Offset,ys=v.Y.Scale,yo=v.Y.Offset}
        end
    end
    if XCFeatureState.streamerSnapshot then
        for key,value in pairs(XCFeatureState.streamerSnapshot) do out[key]=value end
        out.streamerModeEnabled=false
    end
    return out
end

function cfgApply(data)
    if type(data)~=_V[1]({191,80,245,163,64},167,164) then return false end
    setXCStreamerMode(false)
    local requestedStreamerMode=data.streamerModeEnabled==true
    for k,v in pairs(data) do
        if XCConfig[k]~=nil then
            pcall(function()
                if type(v)==_V[1]({4,48,112,185,241},81,63) and v.__type==_V[1]({125,252,76,162,248,12},231,83) then
                    XCConfig[k]=Color3.new(tonumber(v.r) or 1,tonumber(v.g) or 1,tonumber(v.b) or 1)
                elseif type(v)==_V[1]({57,234,175,125,58},1,196) and v.__type==_V[1]({253,240,25,33,234},164,4) then
                    XCConfig[k]=UDim2.new(tonumber(v.xs) or 0,tonumber(v.xo) or 0,tonumber(v.ys) or 0,tonumber(v.yo) or 0)
                else XCConfig[k]=v end
            end)
        end
    end
    setXCStreamerMode(requestedStreamerMode)
    return true
end

function XCConfigSystem.Save(name)
    if not cfgFileAPI() then return false,_V[1]({77,216,67,164,199,80,199,40,103,36,133,224,93,176,32,139,232,81,195,36},159,104) end
    name=cfgSafeName(name or XCConfigSystem.ActiveName)
    cfgEnsureFolder()
    local raw=cfgJSONEncode({schema=2,product=_V[1]({181,181},72,21),name=name,savedAt=os.time(),settings=cfgSerialize()})
    if not raw then return false,_V[1]({2,110,205,47,100,12,120,208,63,151,251,25,194,32,139,241,77,175},85,99) end
    local ok,err=pcall(function() writefile(cfgPath(name),raw) end)
    if ok then XCConfigSystem.ActiveName=name end
    return ok,ok and _V[1]({212,40,131,184,253},59,70) or tostring(err)
end

function XCConfigSystem.Load(name)
    if not cfgFileAPI() then return false,_V[1]({2,140,246,86,120,0,118,214,20,208,48,138,6,88,199,49,141,245,102,198},85,103) end
    name=cfgSafeName(name or XCConfigSystem.ActiveName)
    local path=cfgPath(name)
    if not isfile(path) then return false,_V[1]({104,135,121,100,90,75,247,56,44,36,195,252,248,241,221,198},50,243) end
    local ok,raw=pcall(readfile,path)
    if not ok then return false,_V[1]({242,22,35,55,4,91,103,128,148,158,174},143,17) end
    local data=cfgJSONDecode(raw)
    if type(data)~=_V[1]({48,114,200,39,117},103,85) or type(data.settings)~=_V[1]({84,152,240,81,161},137,87) then return false,_V[1]({91,160,200,211,254,27,54,18,117,161,192,216,251,25},242,32) end
    cfgApply(data.settings)
    XCConfigSystem.ActiveName=name
    return true,_V[1]({20,103,137,188,237,28},152,48)
end

function XCConfigSystem.Delete(name)
    if type(delfile)~=_V[1]({2,9,250,231,240,221,219,210},164,248) then return false,_V[1]({224,164,78,234,156,48,142,82,4,160,26,18,174,68,252,138,53,219,115,23,196,96},249,163) end
    name=cfgSafeName(name or XCConfigSystem.ActiveName)
    local path=cfgPath(name)
    if not isfile(path) then return false,_V[1]({15,235,154,66,245,163,12,10,187,112,204,194,123,49,218,128},28,176) end
    local ok,err=pcall(delfile,path)
    return ok,ok and _V[1]({235,24,43,48,75,72,83},155,12) or tostring(err)
end

function XCConfigSystem.List()
    local out={}
    if type(listfiles)~=_V[1]({185,166,125,80,63,18,246,211},117,222) then return out end
    cfgEnsureFolder()
    local ok,files=pcall(listfiles,XCConfigSystem.Folder)
    if ok and type(files)==_V[1]({185,61,213,118,6},174,151) then
        for _,path in ipairs(files) do
            local n=tostring(path):match(_V[1]({229,163,49,141,69,209,42,179,58,206,149,41,176,58,123},50,139))
            if n then table.insert(out,n) end
        end
    end
    table.sort(out)
    return out
end

function XCConfigSystem.Reset()
    setXCStreamerMode(false)
    for k,v in pairs(XCConfigDefaults or {}) do pcall(function() XCConfig[k]=v end) end
    return true,_V[1]({200,183,161,111,90},154,220)
end

function XCConfigSystem.Export()
    return cfgJSONEncode({schema=2,product=_V[1]({145,140},41,16),name=XCConfigSystem.ActiveName,settings=cfgSerialize()})
end

function XCConfigSystem.Import(raw,name)
    local data=cfgJSONDecode(raw)
    if type(data)~=_V[1]({1,230,223,225,210},149,248) or type(data.settings)~=_V[1]({17,141,29,182,62},14,143) then return false,_V[1]({148,90,3,143,59,217,117,210,188,97,5,165,73,236},170,161) end
    cfgApply(data.settings)
    XCConfigSystem.ActiveName=cfgSafeName(name or data.name or _V[1]({74,244,125,2,139,19,138,15},123,134))
    return true,_V[1]({0,62,91,116,145,173,184,209},157,26)
end

if type(getgenv) == _V[1]({100,250,122,246,142,10,151,29},119,135) then
    pcall(function() getgenv().XCConfigSystem = XCConfigSystem end)
end
