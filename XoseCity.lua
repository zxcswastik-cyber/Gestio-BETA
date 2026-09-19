-- ==========================================
-- XC / Panda Auth (PUSL-V4)
-- ==========================================
do
    local pandaOk, PUSL = pcall(function()
        local source = game:HttpGet("https://secure.pandauth.com/pv4/lib")
        local loader = loadstring(source)
        assert(type(loader) == "function", "invalid Panda library response")
        return loader()
    end)
    if not pandaOk or not PUSL or type(PUSL.configure) ~= "function" then
        return warn("[XC/Panda] Library failed to initialize: " .. tostring(PUSL))
    end

    local configured, configureError = pcall(PUSL.configure, {
        serviceId = "xosecity",
    })
    if not configured then
        return warn("[XC/Panda] Configuration failed: " .. tostring(configureError))
    end

    local authResult
    local pandaKeyFile = "XC_xosecity.key"
    local pandaDiskCacheAvailable = type(readfile) == "function" and type(writefile) == "function"

    local function readSavedPandaKey()
        if not pandaDiskCacheAvailable then return nil end
        local ok, value = pcall(function()
            if type(isfile) == "function" and not isfile(pandaKeyFile) then return nil end
            return readfile(pandaKeyFile)
        end)
        value = ok and type(value) == "string" and value:match("^%s*(.-)%s*$") or nil
        return value ~= "" and value or nil
    end

    local function savePandaKey(key)
        if not pandaDiskCacheAvailable then return false end
        local ok = pcall(function()
            writefile(pandaKeyFile, key)
        end)
        return ok
    end

    local function clearSavedPandaKey()
        if not pandaDiskCacheAvailable then return end
        pcall(function()
            if type(delfile) == "function" and (type(isfile) ~= "function" or isfile(pandaKeyFile)) then
                delfile(pandaKeyFile)
            else
                writefile(pandaKeyFile, "")
            end
        end)
    end

    local function getPandaKeyUrl()
        if type(PUSL.getKeyUrl) ~= "function" then return nil end
        local ok, url = pcall(PUSL.getKeyUrl)
        return ok and type(url) == "string" and url or nil
    end

    local function validatePandaKey(key)
        key = tostring(key or ""):match("^%s*(.-)%s*$")
        if key == "" then return false, "Введите ключ", false end
        local ok, result = pcall(PUSL.validate, key)
        if not ok then return false, "Ошибка проверки: " .. tostring(result), false end
        if type(result) ~= "table" then return false, "Panda вернула неверный ответ", false end
        if result.success then
            authResult = result
            if type(getgenv) == "function" then
                getgenv().XC_PANDA_KEY = key
            end
            savePandaKey(key)
            return true, nil, true
        end
        return false, tostring(result.message or result.error or "Ключ недействителен"), true
    end

    local presetKey
    if type(getgenv) == "function" then
        presetKey = getgenv().XC_PANDA_KEY
    end
    presetKey = type(presetKey) == "string" and presetKey ~= "" and presetKey or readSavedPandaKey()
    local authenticated = false
    if type(presetKey) == "string" and presetKey ~= "" then
        local cacheValid, _, definitive = validatePandaKey(presetKey)
        authenticated = cacheValid
        if not authenticated and definitive then clearSavedPandaKey() end
    end

    if not authenticated then
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
        local resolved = false

        local authGui = Instance.new("ScreenGui")
        authGui.Name = "XC_PandaAuth"
        authGui.ResetOnSpawn = false
        authGui.IgnoreGuiInset = true
        authGui.DisplayOrder = 100000
        authGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local parented = pcall(function()
            local guiParent = type(gethui) == "function" and gethui() or game:GetService("CoreGui")
            authGui.Parent = guiParent
        end)
        if not parented or not authGui.Parent then
            authGui.Parent = localPlayer:WaitForChild("PlayerGui")
        end

        local shade = Instance.new("Frame")
        shade.Size = UDim2.fromScale(1, 1)
        shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shade.BackgroundTransparency = 0.35
        shade.BorderSizePixel = 0
        shade.Parent = authGui

        local panel = Instance.new("Frame")
        panel.Name = "Panel"
        panel.AnchorPoint = Vector2.new(0.5, 0.5)
        panel.Position = UDim2.fromScale(0.5, 0.5)
        panel.Size = UDim2.fromOffset(UserInputService.TouchEnabled and 310 or 360, 228)
        panel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        panel.BorderColor3 = Color3.fromRGB(135, 190, 0)
        panel.BorderSizePixel = 1
        panel.Parent = shade

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = panel

        local accent = Instance.new("Frame")
        accent.Size = UDim2.new(1, 0, 0, 3)
        accent.BackgroundColor3 = Color3.fromRGB(152, 204, 0)
        accent.BorderSizePixel = 0
        accent.Parent = panel

        local title = Instance.new("TextLabel")
        title.Position = UDim2.fromOffset(18, 17)
        title.Size = UDim2.new(1, -36, 0, 28)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = "XC  |  KEY SYSTEM"
        title.TextColor3 = Color3.fromRGB(235, 235, 235)
        title.TextSize = 18
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = panel

        local subtitle = Instance.new("TextLabel")
        subtitle.Position = UDim2.fromOffset(18, 47)
        subtitle.Size = UDim2.new(1, -36, 0, 20)
        subtitle.BackgroundTransparency = 1
        subtitle.Font = Enum.Font.Gotham
        subtitle.Text = "Введите ключ Panda Auth для запуска XC"
        subtitle.TextColor3 = Color3.fromRGB(145, 145, 145)
        subtitle.TextSize = 12
        subtitle.TextXAlignment = Enum.TextXAlignment.Left
        subtitle.Parent = panel

        local keyBox = Instance.new("TextBox")
        keyBox.Position = UDim2.fromOffset(18, 78)
        keyBox.Size = UDim2.new(1, -36, 0, 40)
        keyBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        keyBox.BorderColor3 = Color3.fromRGB(52, 52, 52)
        keyBox.ClearTextOnFocus = false
        keyBox.Font = Enum.Font.Code
        keyBox.PlaceholderText = "Panda key..."
        keyBox.PlaceholderColor3 = Color3.fromRGB(95, 95, 95)
        keyBox.Text = ""
        keyBox.TextColor3 = Color3.fromRGB(235, 235, 235)
        keyBox.TextSize = 13
        keyBox.TextXAlignment = Enum.TextXAlignment.Left
        keyBox.Parent = panel
        local keyPadding = Instance.new("UIPadding")
        keyPadding.PaddingLeft = UDim.new(0, 10)
        keyPadding.PaddingRight = UDim.new(0, 10)
        keyPadding.Parent = keyBox

        local function makeButton(text, xScale, xOffset, widthScale, widthOffset)
            local button = Instance.new("TextButton")
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

        local getKeyButton = makeButton("GET KEY", 0, 18, 0.5, -23)
        local verifyButton = makeButton("VERIFY", 0.5, 5, 0.5, -23)
        verifyButton.BackgroundColor3 = Color3.fromRGB(112, 154, 0)
        verifyButton.BorderColor3 = Color3.fromRGB(152, 204, 0)

        local status = Instance.new("TextLabel")
        status.Position = UDim2.fromOffset(18, 178)
        status.Size = UDim2.new(1, -36, 0, 31)
        status.BackgroundTransparency = 1
        status.Font = Enum.Font.Gotham
        status.Text = pandaDiskCacheAvailable
            and "После проверки ключ сохранится на этом устройстве"
            or "Сохранение недоступно в этом инжекторе"
        status.TextColor3 = Color3.fromRGB(125, 125, 125)
        status.TextSize = 11
        status.TextWrapped = true
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.Parent = panel

        getKeyButton.Activated:Connect(function()
            local url = getPandaKeyUrl()
            if not url then
                status.Text = "Не удалось получить ссылку"
                status.TextColor3 = Color3.fromRGB(220, 75, 75)
                return
            end
            if type(setclipboard) == "function" then
                pcall(setclipboard, url)
                status.Text = "Ссылка скопирована в буфер обмена"
            else
                keyBox.Text = url
                keyBox:CaptureFocus()
                status.Text = "Скопируйте ссылку из поля"
            end
            status.TextColor3 = Color3.fromRGB(152, 204, 0)
        end)

        local checking = false
        local function submitKey()
            if checking then return end
            checking = true
            verifyButton.Text = "CHECKING..."
            status.Text = "Проверка ключа..."
            status.TextColor3 = Color3.fromRGB(180, 180, 180)
            task.spawn(function()
                local success, message = validatePandaKey(keyBox.Text)
                checking = false
                if success then
                    authenticated = true
                    resolved = true
                    status.Text = "Ключ принят. Запуск XC..."
                    status.TextColor3 = Color3.fromRGB(152, 204, 0)
                else
                    verifyButton.Text = "VERIFY"
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

    if not authenticated or type(authResult) ~= "table" or not authResult.success then
        return warn("[XC/Panda] Authentication cancelled or failed. Get a key: "
            .. tostring(getPandaKeyUrl() or "unavailable"))
    end
    print("[XC/Panda] Authenticated. Premium:", authResult.isPremium == true)
end

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

function XCIcon(parent, glyph, size, color)
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
    menuThemePreset = "XC Lime",
    menuTransparency = 0,
    menuAccentR = 152, menuAccentG = 204, menuAccentB = 0,
    menuBackgroundR = 17, menuBackgroundG = 17, menuBackgroundB = 17,
    menuPanelR = 12, menuPanelG = 12, menuPanelB = 12,
    menuTextR = 235, menuTextG = 235, menuTextB = 235,
    linkMenuAndEspColor = false,
    espVisibleR = 152, espVisibleG = 204, espVisibleB = 0,
    espHiddenR = 112, espHiddenG = 116, espHiddenB = 122,
    espHealthHighR = 152, espHealthHighG = 204, espHealthHighB = 0,
    espHealthMidR = 205, espHealthMidG = 170, espHealthMidB = 42,
    espHealthLowR = 205, espHealthLowG = 72, espHealthLowB = 72,
    grenadeHER = 255, grenadeHEG = 45, grenadeHEB = 55,
    grenadeSmokeR = 180, grenadeSmokeG = 185, grenadeSmokeB = 195,
    grenadeMolotovR = 255, grenadeMolotovG = 95, grenadeMolotovB = 35,
    advancedCategory = "Combat",
    advancedSettingKey = "aimFov",
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
    hitSoundEnabled = false,
    thirdPersonEnabled = false,
    skinChangerEnabled = false,
    triggerbotEnabled = false,
    antiAimEnabled = false,
    antiAimMode = "Spin",
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
    settingsAutoSave = false,
    menuKey = "RightShift",

    -- Sliders & Values
    rageFov = 360,
    rageTargetMode = "Distance",
    priorityPlayerName = "None",
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
    hitSoundPreset = "Skeet",
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
    bhopMode = "Hold",
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
    jumpCircleStyle = "GradientWave",

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

    nightPreset = "Midnight",
    nightBrightness = 0.2,
    nightClockTime = 0.0,
    worldSkyboxPreset = "Night",
    worldSkyRotation = 0,
    worldSkyStars = 0,
    worldSkyCelestial = false,
    worldFogStart = 0,
    worldFogEnd = 100000,
    worldExposure = 0,
    worldSaturation = 0,
    worldContrast = 0,
    worldTonePreset = "Neutral",
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
    bulletTracerStyle = "Beam",
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
    skinEditorWeapon = "AK-47",
    skinEditorFinish = "Default",
    skinGalleryMode = "Weapon",
    skinWear = 0,
    knifeWear = 0,
    weaponSkinSelections = {},
    weaponSkinWear = {}
}

-- Immutable startup snapshot used by Settings > Config Manager > RESET.
function deepCopyConfigValue(v)
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
-- Keep legacy values valid while the v20 renderer uses perspective scale.
if tonumber(XCConfig.espFixedBoxHeight) == 64 or tonumber(XCConfig.espFixedBoxHeight) == 42 then
    XCConfig.espFixedBoxHeight = 36
end
XCConfig.espPerspectiveScale = math.clamp(tonumber(XCConfig.espPerspectiveScale) or 1, 0.65, 1.5)
XCConfig.uiScale = math.clamp(tonumber(XCConfig.uiScale) or 1, 0.65, 1.25)
XCConfig.menuTransparency = math.clamp(tonumber(XCConfig.menuTransparency) or 0, 0, 0.45)
for _, colorKey in ipairs({
    "menuAccentR", "menuAccentG", "menuAccentB", "menuBackgroundR", "menuBackgroundG", "menuBackgroundB",
    "menuPanelR", "menuPanelG", "menuPanelB", "menuTextR", "menuTextG", "menuTextB",
    "espVisibleR", "espVisibleG", "espVisibleB", "espHiddenR", "espHiddenG", "espHiddenB",
    "espHealthHighR", "espHealthHighG", "espHealthHighB", "espHealthMidR", "espHealthMidG", "espHealthMidB",
    "espHealthLowR", "espHealthLowG", "espHealthLowB",
    "grenadeHER", "grenadeHEG", "grenadeHEB", "grenadeSmokeR", "grenadeSmokeG", "grenadeSmokeB",
    "grenadeMolotovR", "grenadeMolotovG", "grenadeMolotovB"
}) do
    XCConfig[colorKey] = math.clamp(math.floor((tonumber(XCConfig[colorKey]) or 0) + 0.5), 0, 255)
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
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local VirtualInputManager = nil
-- A synthetic mouse event changes Roblox's preferred input to desktop and
-- makes Blox Strike remove its mobile buttons. Never create that path on a
-- touch device; mobile combat uses native weapon methods instead.
if not UserInputService.TouchEnabled then
    pcall(function()
        VirtualInputManager = game:GetService("VirtualInputManager")
    end)
end

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
        -- Unified XC palette: lime means line-of-sight, neutral grey means
        -- occluded. This mapping is shared by every player ESP component.
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

local currentTheme = themeLibrary["XC Lime"]

local function xcConfigColor(prefix, fallback)
    local r = tonumber(XCConfig[prefix .. "R"])
    local g = tonumber(XCConfig[prefix .. "G"])
    local b = tonumber(XCConfig[prefix .. "B"])
    if not r or not g or not b then return fallback end
    return Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
end

function syncXCUserTheme()
    local menuAccent = xcConfigColor("menuAccent", currentTheme.Accent)
    local menuBackground = xcConfigColor("menuBackground", currentTheme.Background)
    local menuPanel = xcConfigColor("menuPanel", currentTheme.CardBg)
    local menuText = xcConfigColor("menuText", currentTheme.TextPrimary)
    local visible = XCConfig.linkMenuAndEspColor and menuAccent
        or xcConfigColor("espVisible", currentTheme.Enemy_Accent)
    currentTheme.Background = menuBackground
    currentTheme.Sidebar = menuBackground:Lerp(Color3.new(0, 0, 0), 0.24)
    currentTheme.CardBg = menuPanel
    currentTheme.Border = menuPanel:Lerp(menuText, 0.17)
    currentTheme.TextPrimary = menuText
    currentTheme.TextSecondary = menuText:Lerp(menuBackground, 0.48)
    currentTheme.Accent = menuAccent
    currentTheme.AccentHover = menuAccent:Lerp(Color3.new(1, 1, 1), 0.18)
    currentTheme.Enemy_Accent = visible
    currentTheme.Enemy_Fill = visible:Lerp(Color3.new(0, 0, 0), 0.24)
    currentTheme.Enemy_Hidden = xcConfigColor("espHidden", currentTheme.Enemy_Hidden)
    currentTheme.NametagTextColor = visible
    currentTheme.HealthHigh = xcConfigColor("espHealthHigh", visible)
    currentTheme.HealthMid = xcConfigColor("espHealthMid", currentTheme.HealthMid)
    currentTheme.HealthLow = xcConfigColor("espHealthLow", currentTheme.HealthLow)
    currentTheme.HEColor = xcConfigColor("grenadeHE", currentTheme.HEColor)
    currentTheme.SmokeColor = xcConfigColor("grenadeSmoke", currentTheme.SmokeColor)
    currentTheme.MolotovColor = xcConfigColor("grenadeMolotov", currentTheme.MolotovColor)
end
syncXCUserTheme()

-- ==========================================
-- XC NOTIFICATION CENTER
-- ==========================================
local XCNotificationGui = nil
local XCNotificationHolder = nil
local XCNotificationSerial = 0

function ensureXCNotifications()
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

function rgb(r,g,b)
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

-- The InventoryController hook can survive reinjection. Keep its callback in
-- getgenv so a persistent wrapper always forwards shots to the current XC
-- session instead of retaining a stale pending-hit table.
local function recordXCLocalHitPayload(data)
    if not registerXCLocalHitCandidate or type(data) ~= "table" or type(data.Bullets) ~= "table" then
        return
    end
    for _, bullet in pairs(data.Bullets) do
        if type(bullet) == "table" and type(bullet.Hits) == "table" then
            for _, hitData in pairs(bullet.Hits) do
                if type(hitData) == "table" then
                    local hitInstance = hitData.Instance or hitData.instance
                    if typeof(hitInstance) == "Instance" then
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
    if type(recorder) == "function" then recorder(data) end
end

-- Build a per-shot payload for Silent Aim. InventoryController reuses parts of
-- its shot table for automatic fire, so editing Bullets/Hits in place poisons
-- the following rounds and can make the weapon stop after a short burst.
-- XC therefore copies only the mutable path and leaves the game's source table
-- completely untouched.
local function prepareXCSilentShotPayload(data, forceSendStage)
    -- When the native bullet ray hook is available, the shot has already been
    -- redirected before Fire Rate / InventoryController serialize it. Do not
    -- perform a second target roll or payload rewrite here.
    if not forceSendStage and (xcNativeSilentHooked or UserInputService.TouchEnabled) then
        return data, false
    end
    local silentEnabled = forceSendStage and isXCSilentAimRequested() or XCConfig.silentAimEnabled
    if not silentEnabled
        or type(data) ~= "table"
        or type(data.Bullets) ~= "table" then
        return data, false
    end

    local targetPart = getSilentAimTarget and getSilentAimTarget() or silentAimResolved
    if not targetPart or not targetPart.Parent then return data, false end

    local chance = math.clamp(tonumber(XCConfig.silentAimHitChance) or 100, 0, 100)
    if chance < 100 and math.random(1, 100) > chance then return data, false end

    local camPos, aimPos = nil, nil
    if silentAimCamPosAim then
        camPos, aimPos = silentAimCamPosAim(targetPart)
    elseif forceSendStage then
        local activeCamera = Workspace.CurrentCamera or camera
        if activeCamera then
            camPos = activeCamera.CFrame.Position
            aimPos = getKinematicAimPosition(targetPart)
        end
    end
    if not camPos or not aimPos then return data, false end

    local shotData = {}
    for key, value in pairs(data) do shotData[key] = value end
    local shotBullets = {}
    shotData.Bullets = shotBullets

    for key, bullet in pairs(data.Bullets) do
        if type(bullet) ~= "table" then
            shotBullets[key] = bullet
        else
            local shotBullet = {}
            for bulletKey, value in pairs(bullet) do shotBullet[bulletKey] = value end
            shotBullets[key] = shotBullet

            local origin = bullet.Origin or bullet.StartingPoint or bullet.Position or camPos
            if typeof(origin) == "CFrame" then origin = origin.Position end
            if typeof(origin) ~= "Vector3" then origin = camPos end

            local delta = aimPos - origin
            if delta.Magnitude > 0.001 then
                -- Preserve the direction magnitude expected by the weapon. Some
                -- guns use a unit vector while others store ray distance here.
                if typeof(bullet.Direction) == "Vector3" then
                    local magnitude = bullet.Direction.Magnitude
                    shotBullet.Direction = delta.Unit * (magnitude > 0.001 and magnitude or 1)
                end
                if typeof(bullet.Ray) == "Ray" then
                    local magnitude = bullet.Ray.Direction.Magnitude
                    shotBullet.Ray = Ray.new(bullet.Ray.Origin, delta.Unit * magnitude)
                end
            end

            if type(bullet.Hits) == "table" then
                local shotHits = {}
                shotBullet.Hits = shotHits
                for hitKey, hitData in pairs(bullet.Hits) do
                    if type(hitData) == "table" then
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
    -- v35: persistent legacy wrappers may survive reinjection. Keep their
    -- callbacks inert so Silent Aim is driven only by Bullet._performRaycast.
    sharedXCEnv.XCPrepareSilentShotPayloadV23 = function(data) return data, false end
    sharedXCEnv.XCPrepareSilentSendPayloadV28 = function(data)
        return data, false
    end
end

local function dispatchXCPrepareSilentShotPayload(data)
    return data, false
end

-- Legacy XC hooks remain alive after reinjection. Disable their old in-place
-- rewriter only for the synchronous original call, then restore the UI toggle.
local function callXCShotWithoutLegacyRewrite(callback, self, data, ...)
    local silentWasEnabled = XCConfig.silentAimEnabled
    XCConfig.silentAimEnabled = false
    local results = table.pack(pcall(callback, self, data, ...))
    XCConfig.silentAimEnabled = silentWasEnabled
    if not results[1] then error(results[2], 0) end
    return table.unpack(results, 2, results.n)
end

-- Bullet visuals are driven by the game's completed local shot, not by mouse
-- or touch input. This keeps automatic/burst weapons, mobile controls, Silent
-- Aim and third person on the same authoritative origin and impact point.
local bulletEffectFolder = nil
local activeBulletEffectGroups = {}

local function getXCBulletEffectFolder()
    if bulletEffectFolder and bulletEffectFolder.Parent then return bulletEffectFolder end
    local old = Workspace:FindFirstChild("XC_BulletEffects")
    if old then pcall(function() old:Destroy() end) end
    bulletEffectFolder = Instance.new("Folder")
    bulletEffectFolder.Name = "XC_BulletEffects"
    bulletEffectFolder.Parent = Workspace
    return bulletEffectFolder
end

local function trackXCBulletEffect(group, lifetime)
    for index = #activeBulletEffectGroups, 1, -1 do
        if not activeBulletEffectGroups[index].Parent then
            table.remove(activeBulletEffectGroups, index)
        end
    end
    activeBulletEffectGroups[#activeBulletEffectGroups + 1] = group
    while #activeBulletEffectGroups > 24 do
        local oldest = table.remove(activeBulletEffectGroups, 1)
        if oldest and oldest.Parent then pcall(function() oldest:Destroy() end) end
    end
    task.delay(lifetime + 0.12, function()
        if group and group.Parent then pcall(function() group:Destroy() end) end
    end)
end

local function newXCEffectPart(parent, color)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Parent = parent
    return part
end

local function placeXCLinePart(part, from, to, width, cylinder)
    local distance = (to - from).Magnitude
    if distance <= 0.001 then return false end
    if cylinder then
        part.Shape = Enum.PartType.Cylinder
        part.Size = Vector3.new(distance, width, width)
        part.CFrame = CFrame.lookAt(from, to) * CFrame.Angles(0, math.rad(90), 0)
            * CFrame.new(-distance * 0.5, 0, 0)
    else
        part.Size = Vector3.new(width, width, distance)
        part.CFrame = CFrame.lookAt(from, to) * CFrame.new(0, 0, -distance * 0.5)
    end
    return true
end

local function resolveXCBulletVisualLine(shot, bullet)
    if type(shot) ~= "table" or typeof(shot.Origin) ~= "Vector3" then return nil end
    local direction = shot.Direction
    if typeof(direction) ~= "Vector3" or direction.Magnitude <= 0.001 then return nil end
    direction = direction.Unit
    local properties = type(bullet) == "table" and bullet.Properties or nil
    local distance = math.max(0.1, tonumber(shot.Distance)
        or tonumber(properties and properties.Range) or 500)
    local destination = shot.Origin + direction * distance

    -- For a penetrated shot, keep the visual path through the last real entry
    -- impact. Exit records are ignored so the trail never overshoots wildly.
    if XCConfig.wallbangEnabled and type(shot.Hits) == "table" then
        local farthest = distance
        for _, impact in ipairs(shot.Hits) do
            local position = type(impact) == "table" and (impact.Position or impact.position) or nil
            if not impact.Exit and typeof(position) == "Vector3" then
                local along = (position - shot.Origin):Dot(direction)
                if along > farthest and along <= (tonumber(properties and properties.Range) or 500) + 0.1 then
                    farthest = along
                    destination = position
                end
            end
        end
    end
    return shot.Origin, destination
end

local function renderXCBeam(group, origin, destination, width, color, duration)
    local startNode = newXCEffectPart(group, color)
    local endNode = newXCEffectPart(group, color)
    startNode.Size = Vector3.new(0.05, 0.05, 0.05)
    endNode.Size = startNode.Size
    startNode.Transparency = 1
    endNode.Transparency = 1
    startNode.Position = origin
    endNode.Position = destination

    local startAttachment = Instance.new("Attachment")
    startAttachment.Parent = startNode
    local endAttachment = Instance.new("Attachment")
    endAttachment.Parent = endNode
    local beam = Instance.new("Beam")
    beam.Attachment0 = startAttachment
    beam.Attachment1 = endAttachment
    beam.FaceCamera = true
    beam.LightEmission = 1
    beam.Width0 = width * 1.25
    beam.Width1 = width * 0.35
    beam.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.55, color:Lerp(Color3.new(1, 1, 1), 0.5)),
        ColorSequenceKeypoint.new(1, color),
    })
    beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.05),
        NumberSequenceKeypoint.new(0.8, 0.15),
        NumberSequenceKeypoint.new(1, 0.75),
    })
    beam.Parent = startNode
    TweenService:Create(beam, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Width0 = 0,
        Width1 = 0,
    }):Play()
end

local function renderXCLightning(group, origin, destination, width, color, duration)
    local delta = destination - origin
    local distance = delta.Magnitude
    if distance <= 0.001 then return end
    local forward = delta.Unit
    local reference = math.abs(forward:Dot(Vector3.yAxis)) > 0.9 and Vector3.xAxis or Vector3.yAxis
    local right = forward:Cross(reference).Unit
    local up = forward:Cross(right).Unit
    local segments = math.clamp(math.floor(distance / 7), 7, 16)
    local amplitude = math.clamp(distance * 0.018, width * 2.5, 1.6)
    local randomizer = Random.new()
    local previous = origin
    for index = 1, segments do
        local alpha = index / segments
        local point = origin:Lerp(destination, alpha)
        if index < segments then
            point += right * randomizer:NextNumber(-amplitude, amplitude)
                + up * randomizer:NextNumber(-amplitude, amplitude)
        end
        local segment = newXCEffectPart(group, color)
        if placeXCLinePart(segment, previous, point, width * randomizer:NextNumber(0.7, 1.25), false) then
            segment.Transparency = randomizer:NextNumber(0, 0.18)
            TweenService:Create(segment, TweenInfo.new(duration * randomizer:NextNumber(0.7, 1),
                Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1}):Play()
        else
            segment:Destroy()
        end
        previous = point
    end
end

local function renderXCComet(group, origin, destination, width, color, duration)
    local comet = newXCEffectPart(group, color)
    comet.Shape = Enum.PartType.Ball
    comet.Size = Vector3.new(width * 2.8, width * 2.8, width * 2.8)
    comet.Position = origin
    local upper = Instance.new("Attachment")
    upper.Position = Vector3.new(0, width * 0.6, 0)
    upper.Parent = comet
    local lower = Instance.new("Attachment")
    lower.Position = Vector3.new(0, -width * 0.6, 0)
    lower.Parent = comet
    local trail = Instance.new("Trail")
    trail.Attachment0 = upper
    trail.Attachment1 = lower
    trail.FaceCamera = true
    trail.LightEmission = 1
    trail.Lifetime = math.max(0.08, duration * 0.65)
    trail.MinLength = 0.03
    trail.Color = ColorSequence.new(color, color:Lerp(Color3.new(1, 1, 1), 0.55))
    trail.Transparency = NumberSequence.new(0.05, 1)
    trail.WidthScale = NumberSequence.new(1, 0)
    trail.Parent = comet
    local travelTime = math.clamp(duration * 0.55, 0.08, 0.4)
    local movement = TweenService:Create(comet, TweenInfo.new(travelTime, Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out), {Position = destination})
    movement:Play()
    task.delay(travelTime, function()
        if comet.Parent then
            TweenService:Create(comet, TweenInfo.new(math.max(0.05, duration - travelTime),
                Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1, Size = Vector3.zero}):Play()
        end
    end)
end

local function renderXCPartTrail(group, origin, destination, width, color, duration, style)
    local trail = newXCEffectPart(group, color)
    local cylinder = style == "Cylinder" or style == "Pulse"
    if not placeXCLinePart(trail, origin, destination, width, cylinder) then trail:Destroy() return end
    if style == "Pulse" then
        local distance = (destination - origin).Magnitude
        local targetSize = cylinder and Vector3.new(distance, width * 3.2, width * 3.2)
            or Vector3.new(width * 3.2, width * 3.2, distance)
        TweenService:Create(trail, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = targetSize,
            Transparency = 1,
        }):Play()
    else
        TweenService:Create(trail, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
        }):Play()
    end
end

local function renderXCBulletEffects(shot, bullet)
    if not (XCConfig.bulletTrailEnabled or XCConfig.bulletFlashEnabled or XCConfig.bulletImpactEnabled) then return end
    local weapon = type(bullet) == "table" and bullet.Weapon or nil
    if weapon and weapon.Player and weapon.Player ~= player then return end
    local origin, destination = resolveXCBulletVisualLine(shot, bullet)
    if not origin or not destination or (destination - origin).Magnitude <= 0.05 then return end

    local duration = math.clamp(tonumber(XCConfig.bulletTracerDuration) or 0.65, 0.05, 3)
    local width = math.clamp(tonumber(XCConfig.bulletTracerWidth) or 0.08, 0.02, 0.5)
    local color = XCConfig.bulletTracerRainbow and Color3.fromHSV((os.clock() * 0.35) % 1, 0.9, 1)
        or rgb(XCConfig.bulletTracerColorR, XCConfig.bulletTracerColorG, XCConfig.bulletTracerColorB)
    local group = Instance.new("Folder")
    group.Name = "Shot"
    group.Parent = getXCBulletEffectFolder()

    if XCConfig.bulletTrailEnabled then
        local style = tostring(XCConfig.bulletTracerStyle or "Beam")
        if style == "Lightning" then
            renderXCLightning(group, origin, destination, width, color, duration)
        elseif style == "Comet" then
            renderXCComet(group, origin, destination, width, color, duration)
        elseif style == "Beam" then
            renderXCBeam(group, origin, destination, width, color, duration)
        else
            renderXCPartTrail(group, origin, destination, width, color, duration, style)
        end
    end

    if XCConfig.bulletImpactEnabled then
        local impact = newXCEffectPart(group, color)
        impact.Shape = Enum.PartType.Ball
        local size = math.clamp(tonumber(XCConfig.bulletImpactSize) or 0.35, 0.05, 2)
        impact.Size = Vector3.new(size, size, size)
        impact.Position = destination
        TweenService:Create(impact, TweenInfo.new(math.min(duration, 0.4), Enum.EasingStyle.Back,
            Enum.EasingDirection.Out), {Size = Vector3.zero, Transparency = 1}):Play()
    end

    if XCConfig.bulletFlashEnabled then
        local flash = newXCEffectPart(group, color:Lerp(Color3.new(1, 1, 1), 0.35))
        flash.Shape = Enum.PartType.Ball
        flash.Size = Vector3.new(width * 5, width * 5, width * 5)
        flash.Position = origin
        TweenService:Create(flash, TweenInfo.new(0.12, Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out), {Size = Vector3.zero, Transparency = 1}):Play()
    end

    trackXCBulletEffect(group, duration + (XCConfig.bulletTracerStyle == "Comet" and duration * 0.65 or 0))
end

function setupBloxStrikeShootHook()
    if bloxStrikeShootHooked then return end
    
    pcall(function()
        local visualInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                local char = player.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                
                -- Compatibility fallback only. Blox Strike visuals are emitted
                -- from Bullet._performRaycast so touch/mouse input cannot create
                -- fake or duplicate trails.
                if not xcNativeSilentHooked
                    and (XCConfig.bulletTrailEnabled or XCConfig.bulletFlashEnabled) and tool then
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
                    
                    local direction = cam.CFrame.LookVector
                    local hit = Workspace:Raycast(origin, direction * 500, rayParams)
                    local distance = hit and (hit.Position - origin).Magnitude or 500
                    renderXCBulletEffects({
                        Origin = origin,
                        Direction = direction,
                        Distance = distance,
                        Hits = hit and {{Position = hit.Position, Instance = hit.Instance, Exit = false}} or {},
                    }, nil)
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
        if rawget(inventoryController, "__XCSilentAimSafeHookV25") then
            bloxStrikeShootHooked = true
            return
        end

        -- This also upgrades a persistent pre-v23 wrapper. The old wrapper is
        -- called with Silent Aim temporarily disabled, so it cannot mutate the
        -- fresh payload a second time.
        local originalShootWeapon = inventoryController.ShootWeapon
        inventoryController.ShootWeapon = function(self, data, ...)
            -- Capture the user's real toggle before a persistent inner wrapper
            -- masks XCConfig to suppress its obsolete payload mutation.
            setXCSilentAimRequested(XCConfig.silentAimEnabled)
            local shotData = dispatchXCPrepareSilentShotPayload(data)

            -- The payload belongs to the local InventoryController. Record only
            -- enemy parts predicted by this exact shot; health changes from other
            -- players are ignored by the hit feedback system below.
            dispatchXCLocalHitPayload(shotData)

            return callXCShotWithoutLegacyRewrite(originalShootWeapon, self, shotData, ...)
        end

        rawset(inventoryController, "__XCShootHooked", true)
        rawset(inventoryController, "__XCHitConfirmHookV18", true)
        rawset(inventoryController, "__XCSilentAimSafeHookV23", true)
        rawset(inventoryController, "__XCSilentAimSafeHookV25", true)
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
    -- Every mobile control is a Touch. Do not flag movement/menu touches as fire.
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

function getXCHealth(char, plr, hum)
    local health, maximum
    if char then
        health = char:GetAttribute("Health")
        maximum = char:GetAttribute("MaxHealth")
    end
    if type(health) ~= "number" and plr then health = plr:GetAttribute("Health") end
    if type(maximum) ~= "number" and plr then maximum = plr:GetAttribute("MaxHealth") end
    if type(health) ~= "number" then health = tonumber(health) end
    if type(maximum) ~= "number" then maximum = tonumber(maximum) end
    if type(health) ~= "number" and hum then health = hum.Health end
    if type(maximum) ~= "number" and hum then maximum = hum.MaxHealth end
    if type(health) ~= "number" or health ~= health then return nil, nil end
    if type(maximum) ~= "number" or maximum ~= maximum or maximum <= 0 then maximum = 100 end
    return math.clamp(health, 0, maximum), maximum
end

registerXCLocalHitCandidate = function(hitInstance)
    local cursor = hitInstance
    local targetPlayer, targetCharacter
    while cursor and cursor ~= Workspace do
        if cursor:IsA("Model") then
            local candidate = Players:GetPlayerFromCharacter(cursor)
            if candidate then
                targetPlayer, targetCharacter = candidate, cursor
                break
            end
        end
        cursor = cursor.Parent
    end
    if not targetPlayer or not isTargetEnemy(targetPlayer, targetCharacter) then return end
    local hum = targetCharacter:FindFirstChildOfClass("Humanoid")
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
    if not camera or not targetPart or not targetChar then return false end
    local myChar = player.Character
    wallRayParams.FilterDescendantsInstances = {myChar, camera}
    local origin = camera.CFrame.Position
    local dir = targetPart.Position - origin
    
    local hit = Workspace:Raycast(origin, dir, wallRayParams)
    if not hit then return true end
    return hit.Instance == targetPart or hit.Instance:IsDescendantOf(targetChar)
end

-- ==========================================
-- ZERO-LAG SILENT AIM -+WORK
-- ==========================================
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
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not isEntityAlive(char, hum) then continue end
        local part = char:FindFirstChild(XCConfig.silentAimAimHead and "Head" or "HumanoidRootPart")
            or char:FindFirstChild("Torso")
        if not part or not part:IsA("BasePart") then continue end
        -- Visibility and wall penetration are independent controls. Turning
        -- Visible check off must never grant wallbang by itself.
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

local function getXCSilentShotOrigin(activeCamera)
    activeCamera = activeCamera or Workspace.CurrentCamera or camera
    if XCConfig.thirdPersonEnabled then
        local character = player.Character
        local originPart = character and (character:FindFirstChild("CameraPart")
            or character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart"))
        if originPart and originPart:IsA("BasePart") then return originPart.Position end
    end
    return activeCamera and activeCamera.CFrame.Position or nil
end

silentAimCamPosAim = function(targetPart)
    targetPart = targetPart or silentAimResolved
    if not (XCConfig.silentAimEnabled and targetPart) then return nil end
    local cam = Workspace.CurrentCamera or camera
    if not cam then return nil end
    local camPos = getXCSilentShotOrigin(cam)
    local aimPos = getKinematicAimPosition(targetPart)
    if not camPos then return nil end

    -- getKinematicAimPosition() is the single source of prediction.
    -- Do not apply a second lateral lead here.
    return camPos, aimPos
end

-- v31: a mobile touch is not necessarily a shot (movement, jump, reload and
-- menu buttons are touches too). Gate Silent Aim with the equipped weapon's
-- real shoot() call instead of the global Touch input state.
local xcSilentShotContextV31 = nil
local xcSilentShootWrappedV31 = sharedXCEnv and sharedXCEnv.XCSilentShootWrappedV31
if type(xcSilentShootWrappedV31) ~= "table" then
    xcSilentShootWrappedV31 = setmetatable({}, {__mode = "k"})
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
    local controllers = ReplicatedStorage:FindFirstChild("Controllers")
    local moduleScript = controllers and controllers:FindFirstChild("InventoryController")
    local inventory = moduleScript and require(moduleScript)
    local getter = inventory and inventory.peekCurrentEquippedForMovement
    local weapon = type(getter) == "function" and getter() or nil
    if type(weapon) ~= "table" or type(weapon.shoot) ~= "function" or weapon.IsDestroyed then
        return false
    end

    local record = xcSilentShootWrappedV31[weapon]
    if record and weapon.shoot == record.Wrapper then return true end

    local originalShoot = weapon.shoot
    local wrapper
    wrapper = function(self, ...)
        local enter = sharedXCEnv and sharedXCEnv.XCEnterSilentShotV31 or enterXCSilentShotV31
        local leave = sharedXCEnv and sharedXCEnv.XCLeaveSilentShotV31 or leaveXCSilentShotV31
        if type(enter) == "function" then enter(self) end
        local results = table.pack(pcall(originalShoot, self, ...))
        if type(leave) == "function" then leave() end
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
        -- Native bullet redirection is used on mobile. Do not create/access a
        -- Mouse object because some mobile executors report it as desktop input.
        silentAimHooked = true
    elseif not silentAimHooked and hookmetamethod then
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

    if UserInputService.TouchEnabled and xcNativeSilentHooked then
        silentAimCamHooked = true
    end

    if not silentAimCamHooked and hookmetamethod and getnamecallmethod then
        local cameraHookInstalled = pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args = {...}

                local activeCamera = Workspace.CurrentCamera or camera
                if self == activeCamera
                    and (method == "ViewportPointToRay" or method == "ScreenPointToRay") then
                    if UserInputService.TouchEnabled then
                        local context = getXCSilentShotContextV31(true)

                        -- A v30 namecall hook can survive reinjection. Mask the
                        -- request while obtaining the untouched game ray so the
                        -- obsolete broad touch gate cannot run underneath v31.
                        local requested = sharedXCEnv and sharedXCEnv.XCSilentAimRequestedV25
                        if sharedXCEnv then sharedXCEnv.XCSilentAimRequestedV25 = false end
                        local originalRay = oldNamecall(self, ...)
                        if sharedXCEnv then sharedXCEnv.XCSilentAimRequestedV25 = requested end

                        if context and typeof(originalRay) == "Ray" then
                            context.CameraUsed = true
                            local aimPos = getKinematicAimPosition(context.Target)
                            local rayOrigin = getXCSilentShotOrigin(activeCamera) or originalRay.Origin
                            local delta = aimPos - rayOrigin
                            if delta.Magnitude > 0.001 then
                                local magnitude = originalRay.Direction.Magnitude
                                return Ray.new(rayOrigin, delta.Unit * (magnitude > 0.001 and magnitude or 1))
                            end
                        end
                        return originalRay
                    elseif isXCSilentAimRequested() and noRecoil.isShooting then
                        local targetPart = silentAimResolved
                        if targetPart and targetPart.Parent then
                            local originalRay = oldNamecall(self, ...)
                            if typeof(originalRay) == "Ray" then
                                local aimPos = getKinematicAimPosition(targetPart)
                                local rayOrigin = getXCSilentShotOrigin(activeCamera) or originalRay.Origin
                                local delta = aimPos - rayOrigin
                                if delta.Magnitude > 0.001 then
                                    local magnitude = originalRay.Direction.Magnitude
                                    return Ray.new(rayOrigin, delta.Unit * (magnitude > 0.001 and magnitude or 1))
                                end
                            end
                        end
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
        silentAimCamHooked = cameraHookInstalled
        if UserInputService.TouchEnabled and cameraHookInstalled then
            xcMobileCameraSilentHooked = true
        end
    end
end

-- Native Blox Strike Silent Aim path. Redirecting Bullet._performRaycast keeps
-- Silent Aim independent from character LookYaw (Spin/Jitter anti-aim) and
-- from the weapon's FireRate. No Camera, Mouse or Send payload fallback is
-- allowed: if this native module is unavailable, Silent Aim stays in WAIT.
local xcNativeRaycast = nil
local xcNativeGetRayIgnore = nil

local function castXCNativeSilentShot(origin, direction, properties)
    if not xcNativeRaycast or type(xcNativeRaycast.cast) ~= "function"
        or type(xcNativeRaycast.castThrough) ~= "function"
        or type(xcNativeGetRayIgnore) ~= "function" then
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
    if type(first) ~= "table" or not first.instance then return result end
    if typeof(first.position) == "Vector3" then
        result.Distance = (first.position - origin).Magnitude
    end

    local throughDistance = math.max(penetration, 0.001)
    local hits = xcNativeRaycast.castThrough(
        first.position - direction * 0.001,
        direction * (throughDistance + 0.001),
        penetration,
        ignore
    )
    if type(hits) ~= "table" then return result end
    for index, hit in ipairs(hits) do
        if index > maxSurfaces * 2 then break end
        if type(hit) == "table" and hit.instance and hit.material and typeof(hit.position) == "Vector3" then
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

-- ScriptAdap target pass, executed only from the real Bullet raycast. The
-- native ray module is also used for visibility so target selection and the
-- weapon's collision rules cannot disagree.
local function selectXCNativeSilentTarget(origin, properties)
    local cam = Workspace.CurrentCamera or camera
    if not cam or typeof(origin) ~= "Vector3" or not xcNativeRaycast
        or type(xcNativeRaycast.cast) ~= "function" or type(xcNativeGetRayIgnore) ~= "function" then
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
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not isEntityAlive(character, humanoid) then continue end
        local part = character:FindFirstChild(XCConfig.silentAimAimHead and "Head" or "HumanoidRootPart")
            or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
        if not part or not part:IsA("BasePart") then continue end

        -- ScriptAdap aims at the live part position. Applying prediction before
        -- the visibility cast can move the point outside the character and make
        -- every valid target look obstructed.
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
        local firstInstance = type(first) == "table" and (first.instance or first.Instance) or nil
        local visible = not firstInstance or (typeof(firstInstance) == "Instance"
            and (firstInstance == candidate.Part or firstInstance:IsDescendantOf(candidate.Character)))

        if visible then return candidate end
        if XCConfig.wallbangEnabled and not XCConfig.silentAimVisibleCheck then
            local penetrated = castXCNativeSilentShot(origin, offset.Unit, properties or {})
            if penetrated and type(penetrated.Hits) == "table" then
                for _, impact in ipairs(penetrated.Hits) do
                    local instance = impact.Instance or impact.instance
                    if typeof(instance) == "Instance" and not impact.Exit
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
    if not isXCSilentAimRequested() or type(shot) ~= "table"
        or typeof(shot.Origin) ~= "Vector3" then return shot end
    if type(bullet) ~= "table" or bullet.IsDestroyed or not bullet.IsActive then return shot end
    local weapon = bullet.Weapon
    if not weapon or weapon.Player ~= player then return shot end

    local chance = math.clamp(tonumber(XCConfig.silentAimHitChance) or 100, 0, 100)
    if chance < 100 and math.random(1, 100) > chance then return shot end

    -- In native third person the camera sits behind the avatar, while bullets
    -- must originate at the character/weapon side. Using the camera-built
    -- origin makes visibility and the redirected ray disagree near cover.
    local shotOrigin = XCConfig.thirdPersonEnabled and getXCSilentShotOrigin() or shot.Origin
    local target = selectXCNativeSilentTarget(shotOrigin, bullet.Properties or {})
    local targetPart = target and target.Part
    if not targetPart or not targetPart.Parent then return shot end

    local aimPosition = target.Position
    local offset = aimPosition - shotOrigin
    if offset.Magnitude < 0.05 then return shot end

    local redirected = castXCNativeSilentShot(shotOrigin, offset.Unit, bullet.Properties or {})
    if not redirected then return shot end
    silentAimResolved = targetPart
    if registerXCLocalHitCandidate then registerXCLocalHitCandidate(targetPart) end
    return redirected
end

local function processXCNativeLocalShot(bullet, shot)
    local finalShot = redirectXCNativeSilentShot(bullet, shot)
    local weapon = type(bullet) == "table" and bullet.Weapon or nil
    if weapon and weapon.Player == player then
        pcall(renderXCBulletEffects, finalShot, bullet)
    end
    return finalShot
end

if sharedXCEnv then
    -- Disable persistent pre-v36 redirectors; the new wrapper below owns the
    -- only per-bullet redirect and performs Hit Chance exactly once.
    sharedXCEnv.XCNativeSilentRedirectV24 = function(_, shot) return shot end
    -- Existing v36 wrappers survive reinjection and fetch this callback on
    -- every shot, so upgrading it also fixes trails without stacking hooks.
    sharedXCEnv.XCNativeSilentRedirectV36 = processXCNativeLocalShot
end

function setupXCNativeSilentHook()
    if xcNativeSilentHooked then return true end
    -- ScriptAdap-compatible path: hook the weapon's real raycast on every
    -- platform. It runs once per actual local shot and cannot consume mobile
    -- UI touches or block automatic/burst fire.
    local installed = false
    pcall(function()
        local components = ReplicatedStorage:FindFirstChild("Components")
        local weaponFolder = components and components:FindFirstChild("Weapon")
        local classes = weaponFolder and weaponFolder:FindFirstChild("Classes")
        local bulletScript = classes and classes:FindFirstChild("Bullet")
        local common = components and components:FindFirstChild("Common")
        local ignoreScript = common and common:FindFirstChild("GetRayIgnore")
        local sharedFolder = ReplicatedStorage:FindFirstChild("Shared")
        local raycastScript = sharedFolder and sharedFolder:FindFirstChild("Raycast")
        if not bulletScript or not ignoreScript or not raycastScript then return end

        local bulletModule = require(bulletScript)
        local raycastModule = require(raycastScript)
        local getRayIgnore = require(ignoreScript)
        if type(bulletModule) ~= "table" or type(bulletModule._performRaycast) ~= "function"
            or type(raycastModule) ~= "table" or type(raycastModule.cast) ~= "function"
            or type(raycastModule.castThrough) ~= "function" or type(getRayIgnore) ~= "function" then return end

        xcNativeRaycast = raycastModule
        xcNativeGetRayIgnore = getRayIgnore
        if rawget(bulletModule, "__XCSilentRayHookV36") then
            installed = true
            return
        end

        local originalRaycast = bulletModule._performRaycast
        bulletModule._performRaycast = function(self, spread, ...)
            local shot = originalRaycast(self, spread, ...)
            local redirect = sharedXCEnv and sharedXCEnv.XCNativeSilentRedirectV36 or processXCNativeLocalShot
            if type(redirect) ~= "function" then return shot end
            local ok, redirected = pcall(redirect, self, shot)
            return ok and redirected or shot
        end
        rawset(bulletModule, "__XCSilentRayHookV36", true)
        installed = bulletModule._performRaycast ~= originalRaycast
    end)
    xcNativeSilentHooked = installed
    return installed
end

-- Mobile bullet interception v29. The game still executes its original
-- Bullet._performRaycast and builds the canonical shot/Hits payload. XC only
-- redirects the ray arguments while that exact local bullet is being cast.
local function beginXCBulletInterceptV29(bullet)
    if xcMobileCameraSilentHooked then return nil end
    if not isXCSilentAimRequested() or type(bullet) ~= "table"
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
    if not context or typeof(origin) ~= "Vector3" or typeof(direction) ~= "Vector3"
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
    if not UserInputService.TouchEnabled or type(hookfunction) ~= "function" then return false end
    local installed = false
    pcall(function()
        local components = ReplicatedStorage:FindFirstChild("Components")
        local weaponFolder = components and components:FindFirstChild("Weapon")
        local classes = weaponFolder and weaponFolder:FindFirstChild("Classes")
        local bulletScript = classes and classes:FindFirstChild("Bullet")
        local sharedFolder = ReplicatedStorage:FindFirstChild("Shared")
        local raycastScript = sharedFolder and sharedFolder:FindFirstChild("Raycast")
        if not bulletScript or not raycastScript then return end

        local bulletModule = require(bulletScript)
        local raycastModule = require(raycastScript)
        if type(bulletModule) ~= "table" or type(bulletModule._performRaycast) ~= "function"
            or type(raycastModule) ~= "table" or type(raycastModule.cast) ~= "function"
            or type(raycastModule.castThrough) ~= "function" then return end

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

        if rawget(bulletModule, "__XCBulletInterceptV29") then
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
            if context and context.Used and context.Direction and type(shot) == "table" then
                local redirectedShot = table.clone(shot)
                redirectedShot.Direction = context.Direction
                results[2] = redirectedShot
                silentAimResolved = context.Target
                if registerXCLocalHitCandidate then registerXCLocalHitCandidate(context.Target) end
            end
            return table.unpack(results, 2, results.n)
        end
        rawset(bulletModule, "__XCBulletInterceptV29", true)
        installed = true
    end)
    xcBulletInterceptHooked = installed
    return installed
end

-- ==========================================
-- XC SKINCHANGER
-- ==========================================
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
    AppliedWeapons = setmetatable({}, {__mode = "k"}),
    Ready = false,
    LastRefresh = 0,
    LastError = nil
}

function refreshXCSkinData()
    if skinData.Ready and skinData.SkinsRoot and skinData.SkinsRoot.Parent and skinData.GetWeapon then return true end
    if skinData.LastRefresh > 0 and os.clock() - skinData.LastRefresh < 1 then return skinData.Ready end
    skinData.LastRefresh = os.clock()

    local assets = ReplicatedStorage:FindFirstChild("Assets")
    skinData.SkinsRoot = assets and assets:FindFirstChild("Skins")
    skinData.WeaponAssets = assets and assets:FindFirstChild("Weapons")
    if not skinData.SkinsRoot then return false end

    pcall(function()
        local database = ReplicatedStorage:FindFirstChild("Database")
        local components = database and database:FindFirstChild("Components")
        local libraries = components and components:FindFirstChild("Libraries")
        local module = libraries and libraries:FindFirstChild("Skins")
        if module then skinData.SkinLibrary = require(module) end
    end)
    pcall(function()
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        local module = controllers and controllers:FindFirstChild("InventoryController")
        local inventory = module and require(module)
        if inventory and type(inventory.peekCurrentEquippedForMovement) == "function" then
            skinData.GetWeapon = inventory.peekCurrentEquippedForMovement
        end
    end)

    skinData.SkinSelections = {}
    skinData.GloveSelections = {}
    skinData.GloveFolders = {}
    skinData.KnifeSet = {
        ["CT Knife"] = true,
        ["T Knife"] = true,
        ["Knife"] = true
    }

    for _, weaponFolder in ipairs(skinData.SkinsRoot:GetChildren()) do
        local skins = {}
        for _, skin in ipairs(weaponFolder:GetChildren()) do
            skins[#skins + 1] = skin.Name
        end
        table.sort(skins)
        skinData.SkinSelections[weaponFolder.Name] = skins

        local lowerName = weaponFolder.Name:lower()
        if lowerName:find("knife", 1, true) or lowerName:find("karambit", 1, true)
            or lowerName:find("bayonet", 1, true) or lowerName:find("butterfly", 1, true) then
            skinData.KnifeSet[weaponFolder.Name] = true
        end

        if skinData.SkinLibrary and type(skinData.SkinLibrary.GetAllSkinsForWeapon) == "function" then
            pcall(function()
                local entries = skinData.SkinLibrary.GetAllSkinsForWeapon(weaponFolder.Name)
                local sample = type(entries) == "table" and entries[1]
                if type(sample) == "table" and sample.type == "Melee" then
                    skinData.KnifeSet[weaponFolder.Name] = true
                end
            end)
        end

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
            XCConfig.weaponSkinSelections[weaponName] = "Default"
        end
    end

    skinData.KnifeChoices = {}
    for knifeName in pairs(skinData.KnifeSet) do
        local baseKnife = knifeName == "CT Knife" or knifeName == "T Knife" or knifeName == "Knife"
        if not baseKnife then
            if not skinData.WeaponAssets or skinData.WeaponAssets:FindFirstChild(knifeName) then
                skinData.KnifeChoices[#skinData.KnifeChoices + 1] = knifeName
            end
        end
    end
    table.sort(skinData.KnifeChoices)
    if XCConfig.selectedKnifeType ~= "Default" and skinData.WeaponAssets
        and not skinData.WeaponAssets:FindFirstChild(XCConfig.selectedKnifeType)
        and skinData.KnifeChoices[1] then
        XCConfig.selectedKnifeType = skinData.KnifeChoices[1]
    end

    skinData.Ready = skinData.GetWeapon ~= nil
    return skinData.Ready
end

refreshXCSkinData()

function isBaseKnife(name)
    return name == "CT Knife" or name == "T Knife" or name == "Knife"
end

function getXCKnifeChoices()
    refreshXCSkinData()
    local choices = {}
    for _, name in ipairs(skinData.KnifeChoices or {}) do choices[#choices + 1] = name end
    if #choices == 0 then
        choices = {"Butterfly Knife", "Karambit", "Bayonet"}
    end
    choices[#choices + 1] = "Default"
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
    if #choices == 0 then choices = {"AK-47", "M4A1", "AWP", "Desert Eagle"} end
    if not table.find(choices, XCConfig.skinEditorWeapon) then XCConfig.skinEditorWeapon = choices[1] end
    return choices
end

function getXCAllFinishChoices()
    refreshXCSkinData()
    local set, choices = {Default = true}, {"Default"}
    for _, skins in pairs(skinData.SkinSelections or {}) do
        for _, skinName in ipairs(skins) do
            if not set[skinName] then
                set[skinName] = true
                choices[#choices + 1] = skinName
            end
        end
    end
    table.sort(choices, function(a, b)
        if a == "Default" then return true end
        if b == "Default" then return false end
        return a:lower() < b:lower()
    end)
    return choices
end

function getXCSkinChoicesForWeapon(weaponName)
    refreshXCSkinData()
    local choices = {"Default"}
    for _, skinName in ipairs(skinData.SkinSelections[weaponName] or {}) do choices[#choices + 1] = skinName end
    return choices
end

function getXCGloveSkinChoices(modelName)
    refreshXCSkinData()
    local choices = {"Default"}
    for _, skinName in ipairs(skinData.GloveSelections[modelName] or {}) do
        if skinName ~= "Default" then choices[#choices + 1] = skinName end
    end
    return choices
end

function getXCGloveModelChoices()
    refreshXCSkinData()
    local choices = {"Default"}
    for _, folder in ipairs(skinData.GloveFolders or {}) do choices[#choices + 1] = folder.Name end
    if #choices == 1 then choices = {"Default", "Sports Gloves", "Driver Gloves"} end
    return choices
end

function getXCAllGloveSkinChoices()
    refreshXCSkinData()
    local set, choices = {Default = true}, {"Default"}
    for _, skins in pairs(skinData.GloveSelections or {}) do
        for _, skinName in ipairs(skins) do
            if not set[skinName] then
                set[skinName] = true
                choices[#choices + 1] = skinName
            end
        end
    end
    table.sort(choices, function(a, b)
        if a == "Default" then return true end
        if b == "Default" then return false end
        return a:lower() < b:lower()
    end)
    return choices
end

function constructXCKnifeView(view, character, weapon)
    if not view or type(view.construct) ~= "function" or not character or not character.Parent then return false end
    local readIdentity = getthreadidentity or getidentity
    local writeIdentity = setthreadidentity or setidentity
    local identity = readIdentity and writeIdentity and readIdentity()
    local success, failure = pcall(function()
        if identity then writeIdentity(2) end
        local components = ReplicatedStorage:FindFirstChild("Components")
        local common = components and components:FindFirstChild("Common")
        local module = common and common:FindFirstChild("GetWeaponProperties")
        if module then
            local getProperties = require(module)
            assert(getProperties(view.CameraModelWeapon or view.Weapon or weapon.Name), "knife properties unavailable")
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
    -- A knife view may survive briefly after switching to a firearm. Never
    -- reconstruct that stale view: doing so can replace the newly equipped
    -- gun's model/controller. The game already disposes an unequipped knife.
    if type(skinData.GetWeapon) == "function" then
        local ok, equipped = pcall(skinData.GetWeapon)
        if not ok or not equipped or equipped.Viewmodel ~= view then return end
    end
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
    if not refreshXCSkinData() or type(skinData.GetWeapon) ~= "function" then return false end

    local ok, weapon = pcall(skinData.GetWeapon)
    if not ok or not weapon or weapon.IsDestroyed then return false end
    local view = weapon.Viewmodel
    local properties = weapon.Properties
    local melee = skinData.KnifeSet[weapon.Name]
        or (type(properties) == "table" and properties.Class == "Melee")
    if not view or not melee then
        restoreXCKnifeModel()
        return false
    end

    local selectedKnife = XCConfig.selectedKnifeType
    if not selectedKnife or selectedKnife == "Default" then
        restoreXCKnifeModel()
        return true
    end
    if skinData.WeaponAssets and not skinData.WeaponAssets:FindFirstChild(selectedKnife) then
        skinData.LastError = "knife asset unavailable: " .. tostring(selectedKnife)
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

    local selectedSkin = XCConfig.selectedSkin or "Default"
    local availableSkins = skinData.SkinSelections[selectedKnife]
    if selectedSkin ~= "Default" and type(availableSkins) == "table"
        and not table.find(availableSkins, selectedSkin) then
        selectedSkin = "Default"
    end
    local modelChanged = view.CameraModelWeapon ~= selectedKnife
    view.CameraModelWeapon = selectedKnife
    view.Skin = selectedSkin ~= "Default" and selectedSkin or nil
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
        if child:IsA("Model") and child.Name ~= "Viewmodel" and not child.Name:lower():find("light") then
            return child
        end
    end
    return nil
end

function applySurfaceAppearanceSkin(model, weaponName, skinName, wear)
    if not model or not skinData.SkinsRoot then return end
    if not weaponName or not skinName or skinName == "Default" then return end

    local weaponFolder = skinData.SkinsRoot:FindFirstChild(weaponName)
    local skinFolder = weaponFolder and weaponFolder:FindFirstChild(skinName)
    local cameraFolder = skinFolder and skinFolder:FindFirstChild("Camera")
    if not cameraFolder then return end
    local textureFolder = nil
    if skinData.SkinLibrary and type(skinData.SkinLibrary.GetAllSkinsForWeapon) == "function"
        and type(skinData.SkinLibrary.GetWearNameForFloat) == "function" then
        pcall(function()
            for _, info in ipairs(skinData.SkinLibrary.GetAllSkinsForWeapon(weaponName) or {}) do
                if type(info) == "table" and info.skin == skinName then
                    local wearName = skinData.SkinLibrary.GetWearNameForFloat(info, math.clamp(tonumber(wear) or 0, 0, 1))
                    textureFolder = cameraFolder:FindFirstChild(wearName)
                    break
                end
            end
        end)
    end
    textureFolder = textureFolder or cameraFolder:FindFirstChild("Factory New") or cameraFolder:GetChildren()[1]
    if not textureFolder then return end

    for _, appearance in ipairs(textureFolder:GetChildren()) do
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

function captureXCWeaponSkinState(view, model, weaponName)
    local existing = skinData.AppliedWeapons[view]
    if existing and existing.Model == model and existing.WeaponName == weaponName then return existing end
    local record = {
        WeaponName = weaponName,
        Model = model,
        Skin = view.Skin,
        Float = view.Float,
        Surfaces = setmetatable({}, {__mode = "k"})
    }
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            local appearances = {}
            for _, child in ipairs(part:GetChildren()) do
                if child:IsA("SurfaceAppearance") then
                    local ok, clone = pcall(function() return child:Clone() end)
                    if ok and clone then appearances[#appearances + 1] = clone end
                end
            end
            record.Surfaces[part] = appearances
        end
    end
    skinData.AppliedWeapons[view] = record
    return record
end

function applyXCSelectedWeaponSkin()
    if not XCConfig.skinChangerEnabled or not refreshXCSkinData() or type(skinData.GetWeapon) ~= "function" then return false end
    local ok, weapon = pcall(skinData.GetWeapon)
    if not ok or type(weapon) ~= "table" or weapon.IsDestroyed
        or (weapon.Player ~= nil and weapon.Player ~= player) then return false end
    local view = weapon.Viewmodel
    local model = view and view.Model
    if not view or not model or not model.Parent then return false end
    local melee = skinData.KnifeSet[weapon.Name] or (type(weapon.Properties) == "table" and weapon.Properties.Class == "Melee")
    if melee then return applyXCKnifeChanger() end

    local weaponName = view.CameraModelWeapon or view.Weapon or weapon.Name
    local skinName = XCConfig.weaponSkinSelections[weaponName]
    if skinName == nil then return restoreXCSelectedWeaponSkin(weaponName) end
    if type(skinName) ~= "string" or skinName == "" or skinName == "Default" then
        return restoreXCSelectedWeaponSkin(weaponName)
    end
    local wear = math.clamp(tonumber(XCConfig.weaponSkinWear[weaponName]) or 0, 0, 1)
    local record = captureXCWeaponSkinState(view, model, weaponName)
    if record.AppliedSkin == skinName and record.AppliedWear == wear then return true end
    view.Skin = skinName
    view.Float = wear
    applySurfaceAppearanceSkin(model, weaponName, skinName, wear)
    record.AppliedSkin = skinName
    record.AppliedWear = wear
    return true
end

function restoreXCSelectedWeaponSkin(weaponName)
    if type(skinData.GetWeapon) ~= "function" then return false end
    local ok, weapon = pcall(skinData.GetWeapon)
    if not ok or type(weapon) ~= "table" or weapon.IsDestroyed then return false end
    local view = weapon.Viewmodel
    local currentName = view and (view.CameraModelWeapon or view.Weapon or weapon.Name)
    if not view or (weaponName and currentName ~= weaponName) then return false end
    local record = skinData.AppliedWeapons[view]
    -- Default/unconfigured firearms must remain completely untouched. The old
    -- implementation reconstructed every viewmodel here with the knife path,
    -- which could remove the gun model and invalidate its firing controller.
    if not record then return true end
    skinData.AppliedWeapons[view] = nil
    if record.WeaponName ~= currentName then return true end
    view.Skin = record.Skin
    view.Float = record.Float
    if record.Model and record.Model.Parent then
        for part, appearances in pairs(record.Surfaces) do
            if part and part.Parent then
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("SurfaceAppearance") then child:Destroy() end
                end
                for _, appearance in ipairs(appearances) do
                    local ok, clone = pcall(function() return appearance:Clone() end)
                    if ok and clone then clone.Parent = part end
                end
            end
        end
    end
    return true
end

local lastBloxModuleScan = 0
function hookBloxStrikeModules(forceScan)
    local now = os.clock()
    if not forceScan and lastBloxModuleScan > 0 and (now - lastBloxModuleScan) < 5 then return end
    lastBloxModuleScan = now
    refreshXCSkinData()
    pcall(function()
        if type(getgc) ~= "function" then return end
        for _, obj in ipairs(getgc(true)) do
            if type(obj) == "table" then
                if rawget(obj, "EquippedMelee") ~= nil and XCConfig.skinChangerEnabled
                    and XCConfig.selectedKnifeType ~= "Default" then
                    obj.EquippedMelee = XCConfig.selectedKnifeType
                end
                if rawget(obj, "MeleeSkin") ~= nil and XCConfig.skinChangerEnabled
                    and XCConfig.selectedKnifeType ~= "Default" then
                    obj.MeleeSkin = XCConfig.selectedSkin
                end
                if rawget(obj, "Knife") ~= nil and type(obj.Knife) == "table" and XCConfig.skinChangerEnabled
                    and XCConfig.selectedKnifeType ~= "Default" then
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
            or "Default"
        applySurfaceAppearanceSkin(
            weaponModel,
            selectedWeapon,
            selectedSkin,
            XCConfig.weaponSkinWear[selectedWeapon] or (selectedWeapon == XCConfig.selectedKnifeType and XCConfig.knifeWear) or 0
        )
    end
end

function applyXCGloves()
    if not XCConfig.skinChangerEnabled or XCConfig.selectedGloveModel == "Default" then return end
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
        task.wait(0.25)
        pcall(function()
            if XCConfig.skinChangerEnabled then
                applyXCKnifeChanger()
                applyXCSelectedWeaponSkin()
            end
            if XCConfig.skinChangerEnabled and XCConfig.selectedGloveModel ~= "Default" then
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
local handsNativeHooked = false

function setNoFallDamage(enabled)
    if not enabled then return end
    local char = player and player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
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
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local controller = char and char:FindFirstChildWhichIsA("AnimationController", true)
    local animationHost = controller or hum
    if not char or not animationHost then return end
    local animator = animationHost:FindFirstChildOfClass("Animator")
        or char:FindFirstChildWhichIsA("Animator", true)
    if not animator and hum then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
    if not animator then return end
    local id = tostring(XCConfig.animationId or ""):match("%d+")
    if not id then return end
    animationObject = Instance.new("Animation")
    animationObject.Name = "XCAnimation"
    animationObject.AnimationId = "rbxassetid://" .. id
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
        if plr ~= player and plr:GetAttribute("IsSpectating") == true then
            names[#names + 1] = plr
        end
    end
    table.sort(names, function(a,b) return a.Name:lower() < b.Name:lower() end)
    return names
end

function buildSpectatorGui()
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

function updateSpectatorGui()
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

function applyXCHandsOffset(view)
    if not XCConfig.customHandsEnabled then
        handsLastModel = nil
        handsLastPivot = nil
        return
    end
    local cam = Workspace.CurrentCamera or camera
    if not cam then return end
    local model = type(view) == "table" and view.Model or getCurrentWeaponModel()
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
        if type(view) == "table" and view.LargeWeaponModel and view.SmallWeaponModel then
            view.LargeWeaponModel:PivotTo(view.SmallWeaponModel:GetPivot())
        end
    end)
end

-- Apply the offset immediately after the native viewmodel render. This keeps
-- the native pose as the baseline and prevents a RenderStepped offset from
-- accumulating/drifting each frame.
function setupXCCustomHandsHook()
    pcall(function()
        local classes = ReplicatedStorage:FindFirstChild("Classes")
        local weaponComponent = classes and classes:FindFirstChild("WeaponComponent")
        local viewClasses = weaponComponent and weaponComponent:FindFirstChild("Classes")
        local viewScript = viewClasses and viewClasses:FindFirstChild("Viewmodel")
        local viewmodel = viewScript and require(viewScript)
        if type(viewmodel) ~= "table" or type(viewmodel.render) ~= "function" then return end
        if sharedXCEnv then sharedXCEnv.XCApplyHandsV33 = applyXCHandsOffset end
        if rawget(viewmodel, "__XCCustomHandsHookV33") then
            handsNativeHooked = true
            return
        end
        local originalRender = viewmodel.render
        viewmodel.render = function(view, ...)
            local results = table.pack(originalRender(view, ...))
            local callback = sharedXCEnv and sharedXCEnv.XCApplyHandsV33 or applyXCHandsOffset
            if type(callback) == "function" then pcall(callback, view) end
            return table.unpack(results, 1, results.n)
        end
        rawset(viewmodel, "__XCCustomHandsHookV33", true)
        handsNativeHooked = true
    end)
    return handsNativeHooked
end

-- Lightweight background update for the extra modules.
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

-- ==========================================
-- TRIGGERBOT NO WORK & MOVEMENT STATE NO WORK
-- ==========================================
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
    ExposureCompensation = Lighting.ExposureCompensation,
    FogStart = Lighting.FogStart,
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
local grenadeDangerPool = setmetatable({}, {__mode = "k"})
local grenadeDangerScanStarted = false
local soundEspTracked = setmetatable({}, {__mode = "k"})
local soundEspPulses = {}
local mobileSlideBtn = nil

-- ==========================================
-- HITMARKER & DAMAGE FEEDBACK
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

local hitmarkerDamage = Instance.new("TextLabel")
hitmarkerDamage.Name = "Damage"
hitmarkerDamage.AnchorPoint = Vector2.new(0.5, 0)
hitmarkerDamage.Position = UDim2.fromOffset(0, XCConfig.hitmarkerSize + 7)
hitmarkerDamage.Size = UDim2.fromOffset(92, 18)
hitmarkerDamage.BackgroundTransparency = 1
hitmarkerDamage.Text = ""
hitmarkerDamage.TextColor3 = currentTheme.Enemy_Accent
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
        local glow = line:FindFirstChild("NeonGlow")
        if glow then
            glow.Color = currentTheme.Accent
            glow.Thickness = XCConfig.hitmarkerGlow and 2.5 or 0
        end
    end
end

function showHitmarker(damage)
    if type(playXCHitSound) == "function" then playXCHitSound() end
    if not XCConfig.hitmarkerEnabled then return end

    hitmarkerSerial += 1
    local serial = hitmarkerSerial
    hitmarkerCenter.Visible = true

    local size = math.clamp(tonumber(XCConfig.hitmarkerSize) or 13, 5, 30)
    local thickness = math.clamp(tonumber(XCConfig.hitmarkerThickness) or 2, 1, 6)

    for _, line in ipairs(hitmarkerLines) do
        line.Size = UDim2.fromOffset(thickness, size)
        line.BackgroundTransparency = 0
        local glow = line:FindFirstChild("NeonGlow")
        if glow then glow.Transparency = 0.05 end
    end

    local shownDamage = tonumber(damage)
    if shownDamage and shownDamage > 0 then
        hitmarkerDamage.Position = UDim2.fromOffset(0, size + 7)
        hitmarkerDamage.Text = string.format("-%d HP", math.max(1, math.floor(shownDamage + 0.5)))
        hitmarkerDamage.TextColor3 = currentTheme.Enemy_Accent
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

        local glow = line:FindFirstChild("NeonGlow")
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

-- ==========================================
-- THIRD PERSON WORK
-- ==========================================
local isThirdPersonActive = false
local thirdPersonSaved = nil

function getThirdPersonTarget()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum or hum.Health <= 0 then return nil, nil end
    return char, hum
end

function restoreThirdPerson()
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
        Lighting.ExposureCompensation = defaultLighting.ExposureCompensation or 0
        restoreWorldSkybox()
        local fx = Lighting:FindFirstChild("XCWorldColorFX")
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

-- ==========================================
--  WORLD VISUALS
-- ==========================================
local worldSkyboxData = {
    ["Night"] = {"rbxassetid://1514717643","rbxassetid://1514716936","rbxassetid://1514715910","rbxassetid://1514714945","rbxassetid://1514714011","rbxassetid://1514713374"},
    ["Ocean Sunset"] = {"rbxassetid://17525686840","rbxassetid://17525678473","rbxassetid://17525684686","rbxassetid://17525680663","rbxassetid://17525682665","rbxassetid://17525674545"},
    ["My Summer Car"] = {"rbxassetid://16648590964","rbxassetid://16648617436","rbxassetid://16648595424","rbxassetid://16648566370","rbxassetid://16648577071","rbxassetid://16648598180"},
    ["Standard"] = {"rbxassetid://91458024","rbxassetid://91457980","rbxassetid://91458024","rbxassetid://91458024","rbxassetid://91458024","rbxassetid://91458002"},
    ["Minecraft"] = {"http://www.roblox.com/asset/?id=8735166756","http://www.roblox.com/asset/?id=8735166707","http://www.roblox.com/asset/?id=8735231668","http://www.roblox.com/asset/?id=8735166755","http://www.roblox.com/asset/?id=8735166751","http://www.roblox.com/asset/?id=8735166729"},
    ["Spongebob"] = {"rbxassetid://277099484","rbxassetid://277099500","rbxassetid://277099554","rbxassetid://277099531","rbxassetid://277099589","rbxassetid://277101591"},
    ["Deep Space"] = {"http://www.roblox.com/asset/?id=159248188","http://www.roblox.com/asset/?id=159248183","http://www.roblox.com/asset/?id=159248187","http://www.roblox.com/asset/?id=159248173","http://www.roblox.com/asset/?id=159248192","http://www.roblox.com/asset/?id=159248176"},
    ["Clouded Sky"] = {"http://www.roblox.com/asset/?id=252760981","http://www.roblox.com/asset/?id=252763035","http://www.roblox.com/asset/?id=252761439","http://www.roblox.com/asset/?id=252760980","http://www.roblox.com/asset/?id=252760986","http://www.roblox.com/asset/?id=252762652"},
    ["Retro"] = {"rbxasset://sky/null_plainsky512_bk.jpg","rbxasset://sky/null_plainsky512_dn.jpg","rbxasset://sky/null_plainsky512_ft.jpg","rbxasset://sky/null_plainsky512_lf.jpg","rbxasset://sky/null_plainsky512_rt.jpg","rbxasset://sky/null_plainsky512_up.jpg"},
    ["City"] = {"http://www.roblox.com/asset/?id=9134792889","http://www.roblox.com/asset/?id=9134791975","http://www.roblox.com/asset/?id=9134793457","http://www.roblox.com/asset/?id=9134791234","http://www.roblox.com/asset/?id=9134790419","http://www.roblox.com/asset/?id=9134791633"},
    ["Purple Nebula"] = {"rbxassetid://15983968922","rbxassetid://15983966825","rbxassetid://15983965025","rbxassetid://15983967420","rbxassetid://15983966246","rbxassetid://15983964246"},
    ["Pink Sky"] = {"rbxassetid://7890140060","rbxassetid://7890140060","rbxassetid://7890140060","rbxassetid://7890140060","rbxassetid://7890140060","rbxassetid://7890140060"}
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

function resolveWeaponModel()
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

function saveWeaponPartState(part)
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
            if child:IsA("SurfaceAppearance") or child:IsA("Texture") or child:IsA("Decal") then
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

function applyWorldSkybox()
    local data = worldSkyboxData[XCConfig.worldSkyboxPreset]
    if not data or not XCConfig.worldSkyboxEnabled then return end
    pcall(function()
        -- Blox Strike can recreate its native Sky during a round change. Keep
        -- exactly one active Sky, as in the reference implementation.
        for _, existing in ipairs(Lighting:GetChildren()) do
            if existing:IsA("Sky") and existing.Name ~= "XCWorldSky" then
                if not originalSkybox then originalSkybox = existing:Clone() end
                existing:Destroy()
            end
        end
        local sky = Lighting:FindFirstChild("XCWorldSky")
        if not sky then
            sky = Instance.new("Sky")
            sky.Name = "XCWorldSky"
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
        local sky = Lighting:FindFirstChild("XCWorldSky")
        if sky then sky:Destroy() end
        if originalSkybox then
            originalSkybox.Parent = Lighting
            originalSkybox = nil
        end
    end)
end

function updateWorldPostFX()
    if not XCConfig.worldPostFXEnabled then
        local fx = Lighting:FindFirstChild("XCWorldColorFX")
        if fx then fx:Destroy() end
        Lighting.ExposureCompensation = defaultLighting.ExposureCompensation or 0
        return
    end
    local fx = Lighting:FindFirstChild("XCWorldColorFX")
    if not fx then
        fx = Instance.new("ColorCorrectionEffect")
        fx.Name = "XCWorldColorFX"
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
    local weatherOwnsFog = XCConfig.weatherEnabled and XCConfig.weatherMode == "Fog"
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
                if object:IsA("Atmosphere") and object.Name ~= "XCWeatherAtmosphere" then
                    XCFeatureState.worldOriginalAtmosphere = object:Clone()
                    object:Destroy()
                    break
                end
            end
        end
        XCFeatureState.worldAtmosphere = Instance.new("Atmosphere")
        XCFeatureState.worldAtmosphere.Name = "XCWorldAtmosphere"
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
        XCFeatureState.worldBloom = Instance.new("BloomEffect")
        XCFeatureState.worldBloom.Name = "XCWorldBloom"
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

-- ==========================================================================
-- [ CUBE CHECKER ]
-- Crosshair penetration probe: lime = the equipped weapon can exit the hit
-- surface, red = the surface is not penetrable with its native properties.
-- ==========================================================================
do
    local CAN_PENETRATE = Color3.fromRGB(152, 204, 0)
    local BLOCKED = Color3.fromRGB(220, 55, 62)
    local cubePart = Instance.new("Part")
    cubePart.Name = "XC_CubeChecker"
    cubePart.Anchored = true
    cubePart.CanCollide = false
    cubePart.CanTouch = false
    cubePart.CanQuery = false
    cubePart.CastShadow = false
    cubePart.Material = Enum.Material.Neon
    cubePart.Transparency = 0.82
    cubePart.Size = Vector3.new(1.5, 1.5, 0.01)

    local cubeOutline = Instance.new("SelectionBox")
    cubeOutline.Name = "CubeCheckerOutline"
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
        if type(cubeGetWeapon) == "function" then
            local ok, weapon = pcall(cubeGetWeapon)
            if ok and type(weapon) == "table" then return weapon end
        end
        if os.clock() < cubeNextResolve then return nil end
        cubeNextResolve = os.clock() + 1
        pcall(function()
            local controllers = ReplicatedStorage:FindFirstChild("Controllers")
            local inventoryScript = controllers and controllers:FindFirstChild("InventoryController")
            local inventory = inventoryScript and require(inventoryScript)
            if type(inventory) == "table" and type(inventory.peekCurrentEquippedForMovement) == "function" then
                cubeGetWeapon = inventory.peekCurrentEquippedForMovement
            end
        end)
        if type(cubeGetWeapon) == "function" then
            local ok, weapon = pcall(cubeGetWeapon)
            if ok then return weapon end
        end
        return nil
    end

    local function ensureCubeRaycast()
        if xcNativeRaycast and type(xcNativeRaycast.cast) == "function"
            and type(xcNativeRaycast.castThrough) == "function" and type(xcNativeGetRayIgnore) == "function" then
            return true
        end
        pcall(function()
            local sharedFolder = ReplicatedStorage:FindFirstChild("Shared")
            local components = ReplicatedStorage:FindFirstChild("Components")
            local common = components and components:FindFirstChild("Common")
            local raycastScript = sharedFolder and sharedFolder:FindFirstChild("Raycast")
            local ignoreScript = common and common:FindFirstChild("GetRayIgnore")
            if raycastScript and ignoreScript then
                xcNativeRaycast = require(raycastScript)
                xcNativeGetRayIgnore = require(ignoreScript)
            end
        end)
        return xcNativeRaycast and type(xcNativeRaycast.cast) == "function"
            and type(xcNativeRaycast.castThrough) == "function" and type(xcNativeGetRayIgnore) == "function"
    end

    local function probeCubePenetration(origin, direction, distance)
        if not ensureCubeRaycast() then return nil, BLOCKED end
        local ignore = xcNativeGetRayIgnore()
        local first = xcNativeRaycast.cast(origin, direction * distance, nil, ignore)
        if type(first) ~= "table" or not first.instance or typeof(first.position) ~= "Vector3" then
            return nil, BLOCKED
        end

        local normal = typeof(first.normal) == "Vector3" and first.normal or -direction
        local hitCharacter = first.instance:FindFirstAncestorOfClass("Model")
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
        if type(hits) == "table" then
            for index, hit in ipairs(hits) do
                if index % 2 == 0 and type(hit) == "table" and hit.instance then
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

-- Scope overlay adapted from XC: FOV override, removable scope and configurable crosshair.
function findSniperScope()
    local pg = player and player:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end
    local main = pg:FindFirstChild("MainGui")
    local gameplay = main and main:FindFirstChild("Gameplay")
    local middle = gameplay and gameplay:FindFirstChild("Middle")
    return middle and middle:FindFirstChild("SniperScope") or nil
end

function ensureScopeGui()
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

function updateCustomScope()
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
        -- XC Custom FOV: apply the camera FOV every render frame while enabled.
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

-- ==========================================
-- JUMP CIRCLE NO WORK BLOXSTRIKE
-- ==========================================
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
    noSmokeRecords = setmetatable({}, {__mode = "k"}),
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
        ["XC Lime"] = Color3.fromRGB(225, 242, 185),
        Cold = Color3.fromRGB(205, 225, 255),
        Warm = Color3.fromRGB(255, 224, 190),
        Purple = Color3.fromRGB(225, 200, 255),
    },
    hitSounds = {
        Skeet = "rbxassetid://83717596220569",
        Neverlose = "rbxassetid://139452805868562",
        Bell = "rbxassetid://96481309571950",
        Bell2 = "rbxassetid://124010691633262",
        Bubble = "rbxassetid://104824514322839",
        Rust = "rbxassetid://1255040462",
        Coins = "rbxassetid://5613553529",
        Agro1 = "rbxassetid://132463144859699",
        Agro2 = "rbxassetid://102651850556408",
        Schaater = "rbxassetid://17405655409",
        Pick = "rbxassetid://8616930816",
    },
    skeletonEdges = {
        {"Head", "Neck"}, {"Neck", "Waist"},
        {"Neck", "LeftShoulder"}, {"LeftShoulder", "LeftHand"},
        {"Neck", "RightShoulder"}, {"RightShoulder", "RightHand"},
        {"Waist", "LeftHip"}, {"LeftHip", "LeftFoot"},
        {"Waist", "RightHip"}, {"RightHip", "RightFoot"},
    },
    streamerHiddenKeys = {
        "watermarkEnabled", "spectatorListEnabled", "nametagsEnabled", "boxEspEnabled",
        "cornerBoxEnabled", "healthBarEnabled", "headDotEnabled", "tracersEnabled",
        "grenadeEspEnabled", "grenadeDangerZonesEnabled", "soundPositionEspEnabled", "weaponEspEnabled",
        "jumpCircleEnabled", "hitmarkerEnabled", "chamsEnabled", "skeletonEspEnabled",
        "showFovCircle", "showSilentFovCircle",
    },
}

function isXCSmokeObject(object)
    if not object or not (object:IsA("ParticleEmitter") or object:IsA("Smoke")) then return false end
    local cursor = object
    for _ = 1, 6 do
        if not cursor then break end
        local name = cursor.Name:lower()
        if name:find("smoke", 1, true) or name:find("voxel", 1, true) then return true end
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
        for _, rootName in ipairs({"Debris", "Effects"}) do
            local root = Workspace:FindFirstChild(rootName)
            if root then
                for _, object in ipairs(root:GetDescendants()) do
                    if not XCConfig.noSmokeEnabled then return end
                    if object:IsA("ParticleEmitter") or object:IsA("Smoke") then trackXCSmokeObject(object) end
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
            local sound = Instance.new("Sound")
            sound.Name = "XCHitSound"
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
            game:GetService("Debris"):AddItem(sound, 5)
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
        XCFeatureState.weatherRig = Instance.new("Part")
        XCFeatureState.weatherRig.Name = "XCWeatherEmitter"
        XCFeatureState.weatherRig.Size = Vector3.new(1, 1, 1)
        XCFeatureState.weatherRig.Transparency = 1
        XCFeatureState.weatherRig.Anchored = true
        XCFeatureState.weatherRig.CanCollide = false
        pcall(function() XCFeatureState.weatherRig.CanQuery = false; XCFeatureState.weatherRig.CanTouch = false end)
        XCFeatureState.weatherRig.Parent = Workspace

        XCFeatureState.weatherEmitter = Instance.new("ParticleEmitter")
        XCFeatureState.weatherEmitter.Name = "XCWeatherParticles"
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
    local mode = tostring(XCConfig.weatherMode or "Rain")
    local intensity = math.clamp(tonumber(XCConfig.weatherIntensity) or 45, 1, 100)
    local wind = math.clamp(tonumber(XCConfig.weatherWind) or 0, -40, 40)
    local signature = mode .. ":" .. tostring(intensity) .. ":" .. tostring(wind)
    if XCFeatureState.weatherSignature == signature and XCFeatureState.weatherEmitter and XCFeatureState.weatherEmitter.Parent then return end
    XCFeatureState.weatherSignature = signature
    XCFeatureState.weatherEmitter.Enabled = mode ~= "Fog"

    if XCFeatureState.weatherAtmosphere then
        XCFeatureState.weatherAtmosphere.Density = mode == "Fog" and (0.18 + intensity * 0.0045) or 0
        XCFeatureState.weatherAtmosphere.Haze = mode == "Fog" and (1 + intensity * 0.045) or 0
    elseif mode == "Fog" then
        XCFeatureState.weatherAtmosphere = Instance.new("Atmosphere")
        XCFeatureState.weatherAtmosphere.Name = "XCWeatherAtmosphere"
        XCFeatureState.weatherAtmosphere.Color = Color3.fromRGB(190, 198, 205)
        XCFeatureState.weatherAtmosphere.Decay = Color3.fromRGB(90, 96, 105)
        XCFeatureState.weatherAtmosphere.Density = 0.18 + intensity * 0.0045
        XCFeatureState.weatherAtmosphere.Haze = 1 + intensity * 0.045
        XCFeatureState.weatherAtmosphere.Glare = 0
        XCFeatureState.weatherAtmosphere.Parent = Lighting
    end

    if mode == "Rain" then
        XCFeatureState.weatherRig.Size = Vector3.new(90, 1, 90)
        XCFeatureState.weatherEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
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
    elseif mode == "Snow" then
        XCFeatureState.weatherRig.Size = Vector3.new(100, 1, 100)
        XCFeatureState.weatherEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
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
    elseif mode == "Ash" then
        XCFeatureState.weatherRig.Size = Vector3.new(85, 1, 85)
        XCFeatureState.weatherEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
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
    elseif mode == "Hell Fire" then
        XCFeatureState.weatherRig.Size = Vector3.new(90, 1, 90)
        XCFeatureState.weatherEmitter.Texture = "rbxassetid://242205518"
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
    refreshXCToggle("streamerModeEnabled")
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
    refreshXCToggle("freecamEnabled")
    refreshXCToggle("freelookEnabled")
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
    XCConfig.freecamEnabled = mode == "Freecam"
    XCConfig.freelookEnabled = mode == "Freelook"
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
    refreshXCToggle("freecamEnabled")
    refreshXCToggle("freelookEnabled")
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
    if (XCFeatureState.cameraMode == "Freecam" and not XCConfig.freecamEnabled)
        or (XCFeatureState.cameraMode == "Freelook" and not XCConfig.freelookEnabled) then
        stopXCCameraMode()
        return
    end

    cam.CameraType = Enum.CameraType.Scriptable
    local delta = UserInputService:GetMouseDelta() + XCFeatureState.cameraTouchDelta * 0.55
    XCFeatureState.cameraTouchDelta = Vector2.zero
    local sensitivity = XCFeatureState.cameraMode == "Freecam"
        and (tonumber(XCConfig.freecamSensitivity) or 0.18)
        or (tonumber(XCConfig.freelookSensitivity) or 0.16)
    XCFeatureState.cameraYaw -= math.rad(delta.X * sensitivity)
    XCFeatureState.cameraPitch = math.clamp(XCFeatureState.cameraPitch - math.rad(delta.Y * sensitivity), math.rad(-85), math.rad(85))
    local rotation = CFrame.Angles(0, XCFeatureState.cameraYaw, 0) * CFrame.Angles(XCFeatureState.cameraPitch, 0, 0)

    if XCFeatureState.cameraMode == "Freecam" then
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
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.MoveDirection.Magnitude > 0.05 then
                XCFeatureState.cameraPosition += humanoid.MoveDirection.Unit * speed * dt
            end
        end
    end

    XCFeatureState.cameraFrame = CFrame.new(XCFeatureState.cameraPosition) * rotation
    cam.CFrame = XCFeatureState.cameraFrame
end))

-- ==========================================
-- CLEANUP ROUTINES
-- ==========================================
function cleanup()
    XCConfig.silentAimEnabled = false
    setXCSilentAimRequested(false)
    pcall(restoreXCKnifeModel)
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
    grenadeDangerPool = setmetatable({}, {__mode = "k"})
    grenadeDangerScanStarted = false
    soundEspTracked = setmetatable({}, {__mode = "k"})
    soundEspPulses = {}
    
    restoreLightingState()
    restoreXCSmoke()
    if genv and type(genv.XCRestoreWeaponState) == "function" then
        pcall(genv.XCRestoreWeaponState)
        genv.XCRestoreWeaponState = nil
    end
    if sharedXCEnv then
        sharedXCEnv.XCSilentAimRequestedV25 = false
        sharedXCEnv.XCBulletInterceptContextV29 = nil
    end

    pcall(function() if targetGui:FindFirstChild("XCScreenGui") then targetGui.XCScreenGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("XCToggleGui") then targetGui.XCToggleGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("XCFovGui") then targetGui.XCFovGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("XCWatermarkGui") then targetGui.XCWatermarkGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("XCNotificationsGui") then targetGui.XCNotificationsGui:Destroy() end end)
    pcall(function() if targetGui:FindFirstChild("XCFallbackGui") then targetGui.XCFallbackGui:Destroy() end end)
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

    local tag = Instance.new("Frame", grenadeContainer)
    tag.Size = UDim2.new(0, 0, 0, 20)
    tag.AutomaticSize = Enum.AutomaticSize.X
    tag.AnchorPoint = Vector2.new(0.5, 1)
    tag.BackgroundColor3 = Color3.fromRGB(8, 10, 12)
    tag.BackgroundTransparency = 0.12
    tag.BorderSizePixel = 0
    tag.Visible = false
    tag.ZIndex = 12
    Instance.new("UICorner", tag).CornerRadius = UDim.new(0, 4)
    local tagStroke = Instance.new("UIStroke", tag)
    tagStroke.Thickness = 1
    tagStroke.Transparency = 0.22

    local pad = Instance.new("UIPadding", tag)
    pad.PaddingLeft = UDim.new(0, 9)
    pad.PaddingRight = UDim.new(0, 7)

    local accent = Instance.new("Frame", tag)
    accent.Name = "Accent"
    accent.AnchorPoint = Vector2.new(0, 0.5)
    accent.Position = UDim2.new(0, -7, 0.5, 0)
    accent.Size = UDim2.fromOffset(2, 12)
    accent.BorderSizePixel = 0
    accent.ZIndex = 13
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel", tag)
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextSize = 9.5
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.ZIndex = 13

    local radiusCircle = Instance.new("Frame", grenadeContainer)
    radiusCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    radiusCircle.BackgroundTransparency = 1
    radiusCircle.BorderSizePixel = 0
    radiusCircle.Visible = false
    Instance.new("UICorner", radiusCircle).CornerRadius = UDim.new(1, 0)
    local radStroke = Instance.new("UIStroke", radiusCircle)
    radStroke.Thickness = 1.5

    local landingGlow = Instance.new("Frame", grenadeContainer)
    landingGlow.Name = "GrenadeLandingGlow"
    landingGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    landingGlow.Size = UDim2.fromOffset(15, 15)
    landingGlow.BorderSizePixel = 0
    landingGlow.Rotation = 45
    landingGlow.BackgroundTransparency = 0.72
    landingGlow.Visible = false
    landingGlow.ZIndex = 9
    Instance.new("UICorner", landingGlow).CornerRadius = UDim.new(0, 3)

    local landing = Instance.new("Frame", grenadeContainer)
    landing.Name = "GrenadeLanding"
    landing.AnchorPoint = Vector2.new(0.5, 0.5)
    landing.Size = UDim2.fromOffset(8, 8)
    landing.BorderSizePixel = 0
    landing.Rotation = 45
    landing.Visible = false
    landing.ZIndex = 11
    Instance.new("UICorner", landing).CornerRadius = UDim.new(0, 2)
    local landingStroke = Instance.new("UIStroke", landing)
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
        local glow = Instance.new("Frame", grenadeContainer)
        glow.Name = "TrajectoryGlow_" .. j
        glow.BorderSizePixel = 0
        glow.AnchorPoint = Vector2.new(0.5, 0.5)
        glow.Visible = false
        glow.ZIndex = 8
        local core = Instance.new("Frame", grenadeContainer)
        core.Name = "TrajectoryCore_" .. j
        core.BorderSizePixel = 0
        core.AnchorPoint = Vector2.new(0.5, 0.5)
        core.Visible = false
        core.ZIndex = 10
        table.insert(data.Lines, {Glow = glow, Core = core})
    end

    for j = 1, 24 do
        local seg = Instance.new("Frame", grenadeContainer)
        seg.Name = "GrenadeRadius_" .. j
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

            -- Specific types must be checked before generic "grenade" names.
            if nName:find("molotov", 1, true) or nName:find("incendiary", 1, true)
                or nName:find("fire", 1, true) then
                nadeType, nadeColor, effectRadiusStuds = "MOLOTOV", currentTheme.MolotovColor, 17
            elseif nName:find("smoke", 1, true) then
                nadeType, nadeColor, effectRadiusStuds = "SMOKE", currentTheme.SmokeColor, 20
            elseif nName:find("flash", 1, true) then
                nadeType, nadeColor, effectRadiusStuds = "FLASH", Color3.fromRGB(245, 235, 120), 10
            elseif nName:find("hegrenade", 1, true) or nName:find("frag", 1, true)
                or nName:find("grenade", 1, true) then
                nadeType, nadeColor, effectRadiusStuds = "HE", currentTheme.HEColor, 15
            end

            if nadeType then
                local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
                if part and part.Parent and part:IsDescendantOf(Workspace) then
                    local dist = (part.Position - camPos).Magnitude
                    if dist <= XCConfig.grenadeMaxDist then
                        activeGrenades[item] = true
                        local ui = getOrCreateGrenadeUI(item)
                        local screen, onScreen = camera:WorldToViewportPoint(part.Position)
                        ui.Accent.BackgroundColor3 = nadeColor
                        ui.TagStroke.Color = nadeColor
                        ui.Label.TextColor3 = nadeColor
                        ui.Label.Text = string.format("%s  ·  %dm", nadeType, math.floor(dist + 0.5))
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

                        local shouldShowRadius = (nadeType == "MOLOTOV" and XCConfig.showMolotovRadius)
                            or (nadeType == "SMOKE" and XCConfig.showSmokeRadius)
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

-- ==========================================
-- GRENADE DANGER ZONES
-- ==========================================
function classifyXCGrenadeDanger(object)
    if not object or not object.Parent or isEntityCharacter(object) then return nil end
    local name = object.Name:lower()
    local grenadeAttribute = object:GetAttribute("GrenadeName")
    if type(grenadeAttribute) == "string" then name ..= " " .. grenadeAttribute:lower() end
    if name:find("smokezone", 1, true) or name:find("smoke_zone", 1, true)
        or name:find("voxelsmoke", 1, true) or name:find("smokearea", 1, true)
        or name:find("gaszone", 1, true) then
        return "SMOKE", currentTheme.SmokeColor, 20, true
    end
    if name:find("firezone", 1, true) or name:find("fire_zone", 1, true)
        or name:find("voxelfire", 1, true) or name:find("molotov", 1, true)
        or name:find("incendiary", 1, true) or name:find("ignite", 1, true)
        or name:find("flamezone", 1, true) or name:find("burnzone", 1, true) then
        return "FIRE", currentTheme.MolotovColor, 17, name:find("zone", 1, true) ~= nil or name:find("voxel", 1, true) ~= nil
    end
    if name:find("flashbang", 1, true) or name:find("flash_grenade", 1, true) or name:find("flash grenade", 1, true) then
        return "FLASH", Color3.fromRGB(245, 235, 120), 10, false
    end
    if name:find("smokegrenade", 1, true) or name:find("smoke_grenade", 1, true) or name:find("smoke grenade", 1, true) then
        return "SMOKE", currentTheme.SmokeColor, 20, false
    end
    if name:find("hegrenade", 1, true) or name:find("he_grenade", 1, true) or name:find("he grenade", 1, true)
        or name:find("frag", 1, true) or name == "grenade" or name:find("grenadeprojectile", 1, true) then
        return "HE", currentTheme.HEColor, 15, false
    end
    return nil
end

function getXCDangerPart(object)
    if object:IsA("BasePart") then return object end
    if object:IsA("Model") and object.PrimaryPart then return object.PrimaryPart end
    return object:FindFirstChildWhichIsA("BasePart", true)
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
        local line = Instance.new("Frame", grenadeContainer)
        line.Name = "Danger_" .. kind .. "_" .. index
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BorderSizePixel = 0
        line.BackgroundColor3 = color
        line.Visible = false
        line.ZIndex = 5
        data.Segments[index] = line
    end

    local label = Instance.new("TextLabel", grenadeContainer)
    label.Name = "DangerLabel_" .. kind
    label.AnchorPoint = Vector2.new(0.5, 1)
    label.Size = UDim2.fromOffset(90, 20)
    label.BackgroundColor3 = Color3.fromRGB(8, 10, 12)
    label.BackgroundTransparency = 0.12
    label.BorderSizePixel = 0
    label.Text = "! " .. kind
    label.TextColor3 = color
    label.TextSize = 9.5
    label.Font = Enum.Font.GothamBold
    label.Visible = false
    label.ZIndex = 6
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 4)
    local labelStroke = Instance.new("UIStroke", label)
    labelStroke.Color = color
    labelStroke.Thickness = 1
    labelStroke.Transparency = 0.25
    local centerGlow = Instance.new("Frame", grenadeContainer)
    centerGlow.Name = "DangerCenterGlow_" .. kind
    centerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    centerGlow.Size = UDim2.fromOffset(18, 18)
    centerGlow.BackgroundColor3 = color
    centerGlow.BackgroundTransparency = 0.76
    centerGlow.BorderSizePixel = 0
    centerGlow.Rotation = 45
    centerGlow.Visible = false
    centerGlow.ZIndex = 4
    Instance.new("UICorner", centerGlow).CornerRadius = UDim.new(0, 4)
    local centerDot = Instance.new("Frame", grenadeContainer)
    centerDot.Name = "DangerCenter_" .. kind
    centerDot.AnchorPoint = Vector2.new(0.5, 0.5)
    centerDot.Size = UDim2.fromOffset(7, 7)
    centerDot.BackgroundColor3 = color
    centerDot.BorderSizePixel = 0
    centerDot.Rotation = 45
    centerDot.Visible = false
    centerDot.ZIndex = 7
    Instance.new("UICorner", centerDot).CornerRadius = UDim.new(0, 2)
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
    if object:IsA("BasePart") then table.insert(parts, object) end
    for _, descendant in ipairs(object:GetDescendants()) do
        if descendant:IsA("BasePart") then table.insert(parts, descendant) end
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
                    if child:IsA("Folder") or child:IsA("Model") then table.insert(queue, child) end
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
            data.Label.Text = string.format("!  %s  ·  %dm", data.Kind,
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

-- ==========================================
-- ENEMY SOUND POSITION ESP
-- ==========================================
function getXCSoundSource(sound)
    local cursor = sound.Parent
    local sourcePart
    while cursor and cursor ~= Workspace do
        if not sourcePart then
            if cursor:IsA("Attachment") then
                sourcePart = cursor
            elseif cursor:IsA("BasePart") then
                sourcePart = cursor
            end
        end
        if cursor:IsA("Model") then
            local owner = Players:GetPlayerFromCharacter(cursor)
            if owner then
                local position
                if sourcePart and sourcePart:IsA("Attachment") then position = sourcePart.WorldPosition
                elseif sourcePart and sourcePart:IsA("BasePart") then position = sourcePart.Position end
                local root = cursor:FindFirstChild("HumanoidRootPart") or cursor:FindFirstChild("Torso") or cursor:FindFirstChild("UpperTorso")
                return owner, position or (root and root.Position), cursor
            end
        end
        for _, attributeName in ipairs({"Player", "Owner", "UserId", "CreatorId"}) do
            local ownerValue = cursor:GetAttribute(attributeName)
            local owner
            if typeof(ownerValue) == "Instance" and ownerValue:IsA("Player") then owner = ownerValue
            elseif type(ownerValue) == "number" then owner = Players:GetPlayerByUserId(ownerValue) end
            if not owner and type(ownerValue) == "string" then
                owner = Players:FindFirstChild(ownerValue)
                if not owner then
                    local numericId = tonumber(ownerValue)
                    if numericId then owner = Players:GetPlayerByUserId(numericId) end
                end
            end
            if owner then
                local character = owner.Character
                local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
                local position = sourcePart and (sourcePart:IsA("Attachment") and sourcePart.WorldPosition or sourcePart.Position)
                return owner, position or (root and root.Position), character
            end
        end
        cursor = cursor.Parent
    end

    local position = sourcePart and (sourcePart:IsA("Attachment") and sourcePart.WorldPosition or sourcePart.Position)
    if position and classifyXCSound(sound) ~= "SOUND" then
        local closestPlayer, closestCharacter, closestDistance = nil, nil, 5
        for _, candidate in ipairs(Players:GetPlayers()) do
            local character = candidate.Character
            local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
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
    if name:find("foot", 1, true) or name:find("step", 1, true)
        or name:find("walk", 1, true) or name:find("run", 1, true) then return "STEP" end
    if name:find("shoot", 1, true) or name:find("shot", 1, true)
        or name:find("fire", 1, true) or name:find("gun", 1, true) then return "SHOT" end
    if name:find("reload", 1, true) or name:find("mag", 1, true) then return "RELOAD" end
    if name:find("jump", 1, true) or name:find("land", 1, true) then return "MOVE" end
    return "SOUND"
end

function destroyXCSoundPulse(pulse)
    pcall(function() pulse.Root:Destroy() end)
end

function createXCSoundPulse(position, category)
    if #soundEspPulses >= 24 then
        destroyXCSoundPulse(table.remove(soundEspPulses, 1))
    end

    local root = Instance.new("Frame", overlayContainer)
    root.Name = "SoundESP_" .. category
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.Size = UDim2.fromOffset(1, 1)
    root.BackgroundTransparency = 1
    root.Visible = false
    root.ZIndex = 20

    local ring = Instance.new("Frame", root)
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.Position = UDim2.fromScale(0.5, 0.5)
    ring.BackgroundTransparency = 1
    ring.BorderSizePixel = 0
    ring.ZIndex = 20
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", ring)
    stroke.Color = currentTheme.Accent
    stroke.Thickness = 2
    stroke.Transparency = 0

    local dot = Instance.new("Frame", root)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.5, 0.5)
    dot.Size = UDim2.fromOffset(5, 5)
    dot.BackgroundColor3 = currentTheme.Accent
    dot.BorderSizePixel = 0
    dot.ZIndex = 21
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local label = Instance.new("TextLabel", root)
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
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 3)

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
    if not sound:IsA("Sound") then return end
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
    table.insert(connections, sound:GetPropertyChangedSignal("Playing"):Connect(function()
        if sound.Playing then triggerXCSoundPosition(sound) end
    end))
end

function hookXCSoundCharacter(plr, character)
    if plr == player or not character then return end
    for _, object in ipairs(character:GetDescendants()) do
        if object:IsA("Sound") then trackXCSound(object) end
    end
    table.insert(connections, character.DescendantAdded:Connect(function(object)
        if object:IsA("Sound") then trackXCSound(object) end
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
    if object:IsA("Sound") then trackXCSound(object) end
end))

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

function getPingLatency()
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

function triggerbotFire(vp)
    pcall(function()
        local myChar = player.Character
        local equippedTool = myChar and myChar:FindFirstChildOfClass("Tool")
        if equippedTool then
            equippedTool:Activate()
            return
        end

        -- Blox Strike keeps weapons outside Roblox Tool instances. Invoke its
        -- native shoot method so mobile input mode is not changed to Mouse.
        local nativeFired = false
        pcall(function()
            local controllers = ReplicatedStorage:FindFirstChild("Controllers")
            local scriptObject = controllers and controllers:FindFirstChild("InventoryController")
            local inventory = scriptObject and require(scriptObject)
            local getter = inventory and inventory.peekCurrentEquippedForMovement
            local weapon = type(getter) == "function" and getter() or nil
            if weapon and type(weapon.shoot) == "function" then
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
        if XCConfig.triggerbotHeadOnly and first.Instance.Name ~= "Head" then return end

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
                    if not XCConfig.triggerbotHeadOnly or targetPart.Name == "Head" then
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
    local head = char:FindFirstChild("Head")
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local waistPart = char:FindFirstChild("LowerTorso") or torso
    if not head or not torso or not waistPart then hideXCSkeleton(esp) return end

    local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
    local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
    local leftHand = char:FindFirstChild("LeftHand") or char:FindFirstChild("LeftLowerArm") or leftArm
    local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("RightLowerArm") or rightArm
    local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
    local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
    local leftFoot = char:FindFirstChild("LeftFoot") or char:FindFirstChild("LeftLowerLeg") or leftLeg
    local rightFoot = char:FindFirstChild("RightFoot") or char:FindFirstChild("RightLowerLeg") or rightLeg

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

    local box = Instance.new("Frame", overlayContainer)
    box.Name = "Box_" .. plr.Name
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 7

    local boxOutline = Instance.new("Frame", overlayContainer)
    boxOutline.Name = "BoxOutline_" .. plr.Name
    boxOutline.BackgroundTransparency = 1
    boxOutline.BorderSizePixel = 0
    boxOutline.Visible = false
    boxOutline.ZIndex = 6

    local outlineStroke = Instance.new("UIStroke", boxOutline)
    outlineStroke.Color = Color3.fromRGB(5, 7, 9)
    outlineStroke.Thickness = XCConfig.boxThickness + 2
    outlineStroke.Transparency = 0.12
    outlineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

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
    local healthGradient = Instance.new("UIGradient", healthBarFill)
    healthGradient.Name = "HealthGradient"
    healthGradient.Rotation = 90
    healthGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(152, 204, 0)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(210, 196, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 65, 55)),
    })

    local weaponCard = Instance.new("Frame", overlayContainer)
    weaponCard.Name = "WeaponIcon_" .. plr.Name
    weaponCard.AnchorPoint = Vector2.new(0.5, 0)
    weaponCard.Size = UDim2.fromOffset(36, 15)
    weaponCard.BackgroundColor3 = Color3.fromRGB(5, 6, 7)
    weaponCard.BackgroundTransparency = 1
    weaponCard.BorderSizePixel = 0
    weaponCard.ClipsDescendants = true
    weaponCard.Visible = false
    weaponCard.ZIndex = 8
    Instance.new("UICorner", weaponCard).CornerRadius = UDim.new(0, 3)
    local weaponCardStroke = Instance.new("UIStroke", weaponCard)
    weaponCardStroke.Color = currentTheme.Enemy_Accent
    weaponCardStroke.Thickness = 1
    weaponCardStroke.Transparency = 1
    weaponCardStroke.Enabled = false

    local weaponImageShadow = Instance.new("ImageLabel", weaponCard)
    weaponImageShadow.Name = "ImageShadow"
    weaponImageShadow.Size = UDim2.new(1, -4, 1, -4)
    weaponImageShadow.Position = UDim2.fromOffset(3, 3)
    weaponImageShadow.BackgroundTransparency = 1
    weaponImageShadow.ScaleType = Enum.ScaleType.Fit
    weaponImageShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    weaponImageShadow.ImageTransparency = 0.28
    weaponImageShadow.Visible = false
    weaponImageShadow.ZIndex = 8

    local weaponImage = Instance.new("ImageLabel", weaponCard)
    weaponImage.Name = "Image"
    weaponImage.Size = UDim2.new(1, -4, 1, -4)
    weaponImage.Position = UDim2.fromOffset(2, 1)
    weaponImage.BackgroundTransparency = 1
    weaponImage.ScaleType = Enum.ScaleType.Fit
    weaponImage.ImageColor3 = currentTheme.Enemy_Accent
    weaponImage.Visible = false
    weaponImage.ZIndex = 10

    local weaponViewport = Instance.new("ViewportFrame", weaponCard)
    weaponViewport.Name = "Viewport"
    weaponViewport.Size = UDim2.new(1, -4, 1, -4)
    weaponViewport.Position = UDim2.fromOffset(2, 1)
    weaponViewport.BackgroundTransparency = 1
    weaponViewport.Ambient = Color3.fromRGB(72, 96, 0)
    weaponViewport.LightColor = currentTheme.Enemy_Accent
    weaponViewport.LightDirection = Vector3.new(-1, -0.45, -1)
    weaponViewport.Visible = false
    weaponViewport.ZIndex = 10
    local weaponWorld = Instance.new("WorldModel", weaponViewport)
    local weaponCamera = Instance.new("Camera", weaponViewport)
    weaponViewport.CurrentCamera = weaponCamera

    local corners = {}
    for i = 1, 4 do
        local hLine = Instance.new("Frame", overlayContainer)
        hLine.Name = "CornerH_" .. plr.Name .. "_" .. i
        hLine.BackgroundColor3 = currentTheme.Enemy_Accent
        hLine.BorderSizePixel = 0
        hLine.Visible = false
        hLine.ZIndex = 7
        local hOutline = Instance.new("UIStroke", hLine)
        hOutline.Color = Color3.fromRGB(5, 7, 9)
        hOutline.Thickness = 1
        hOutline.Transparency = 0.1

        local vLine = Instance.new("Frame", overlayContainer)
        vLine.Name = "CornerV_" .. plr.Name .. "_" .. i
        vLine.BackgroundColor3 = currentTheme.Enemy_Accent
        vLine.BorderSizePixel = 0
        vLine.Visible = false
        vLine.ZIndex = 7
        local vOutline = Instance.new("UIStroke", vLine)
        vOutline.Color = Color3.fromRGB(5, 7, 9)
        vOutline.Thickness = 1
        vOutline.Transparency = 0.1

        table.insert(corners, {H = hLine, V = vLine, HOutline = hOutline, VOutline = vOutline})
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
    cardStroke.Enabled = false

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

    local skeletonLines = {}
    for index = 1, #XCFeatureState.skeletonEdges do
        local line = Instance.new("Frame", overlayContainer)
        line.Name = "Skeleton_" .. plr.Name .. "_" .. index
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
        LastText = "",
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
    local raw = plr:GetAttribute("CurrentEquipped")
    local weaponName
    if type(raw) == "string" and raw ~= "" then
        pcall(function()
            local decoded = HttpService:JSONDecode(raw)
            if type(decoded) == "table" then
                weaponName = decoded.Name or decoded.Weapon or decoded.ItemName
            end
        end)
    end
    local tool = char and char:FindFirstChildOfClass("Tool")
    if type(weaponName) ~= "string" or weaponName == "" then
        weaponName = tool and tool.Name or nil
    end
    return weaponName, tool, raw
end

function clearXCWeaponPreview(esp)
    esp.WeaponImage.Image = ""
    esp.WeaponImage.Visible = false
    esp.WeaponImageShadow.Image = ""
    esp.WeaponImageShadow.Visible = false
    esp.WeaponViewport.Visible = false
    esp.WeaponWorld:ClearAllChildren()
    esp.WeaponReady = false
end

function findXCWeaponAsset(weaponName)
    if type(weaponName) ~= "string" or weaponName == "" then return nil end
    local assets = ReplicatedStorage:FindFirstChild("Assets")
    local weapons = assets and assets:FindFirstChild("Weapons")
    if not weapons then return nil end
    local direct = weapons:FindFirstChild(weaponName)
    if direct then return direct end
    local normalized = weaponName:lower():gsub("[^%w]", "")
    for _, candidate in ipairs(weapons:GetChildren()) do
        if candidate.Name:lower():gsub("[^%w]", "") == normalized then return candidate end
    end
    return nil
end

function findXCCharacterWeaponVisual(character, weaponName)
    if not character or type(weaponName) ~= "string" then return nil end
    local direct = character:FindFirstChild(weaponName, true)
    if direct and (direct:IsA("Model") or direct:IsA("Tool") or direct:IsA("BasePart")) then return direct end
    local normalized = weaponName:lower():gsub("[^%w]", "")
    for _, candidate in ipairs(character:GetDescendants()) do
        if (candidate:IsA("Model") or candidate:IsA("Tool"))
            and candidate.Name:lower():gsub("[^%w]", "") == normalized then
            return candidate
        end
    end
    return nil
end

function buildXCWeaponViewport(esp, weaponName, tool, character)
    clearXCWeaponPreview(esp)

    if tool and type(tool.TextureId) == "string" and tool.TextureId ~= "" then
        esp.WeaponImage.Image = tool.TextureId
        esp.WeaponImageShadow.Image = tool.TextureId
        esp.WeaponImage.Visible = true
        esp.WeaponImageShadow.Visible = true
        esp.WeaponReady = true
        return true
    end
    if tool then
        local embedded = tool:FindFirstChildWhichIsA("ImageLabel", true)
        if embedded and embedded.Image ~= "" then
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
        asset:FindFirstChild("World")
        or asset:FindFirstChild("Dropped")
        or asset:FindFirstChild("ThirdPerson")
        or asset:FindFirstChild("Camera")
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
        if object:IsA("LuaSourceContainer") then
            object:Destroy()
        elseif object:IsA("BasePart") then
            local lower = object.Name:lower()
            if lower:find("arm", 1, true) or lower:find("hand", 1, true)
                or lower:find("glove", 1, true) or lower:find("sleeve", 1, true)
                or lower == "root" or lower:find("camera", 1, true)
                or lower:find("reference", 1, true) or lower:find("pivot", 1, true) then
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
                if object:IsA("MeshPart") then object.TextureID = "" end
                if object.Transparency < 0.98 then table.insert(visibleParts, object) end
            end
        elseif object:IsA("SurfaceAppearance") or object:IsA("Decal") or object:IsA("Texture") then
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
    local key = tostring(raw or "") .. "|" .. tostring(weaponName or "") .. "|" .. tostring(tool)
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
    local oldHum = oldChar and oldChar:FindFirstChildOfClass("Humanoid")
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

-- ==========================================
-- TACTICAL ESP
-- ==========================================
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

-- Produces one stable rectangle shared by Box ESP, Corner Box and Health Bar.
-- Screen position always uses the current camera frame (no positional lerp),
-- while size follows true camera-to-target distance and is independent of FOV.
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

    -- Project a fixed six-stud body against a virtual 70-degree camera. The
    -- position follows the live camera, while box size uses radial distance
    -- only—not camera yaw, Custom FOV, or render order.
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
        -- Only dimensions are smoothed. Smoothing X/Y makes ESP visibly trail
        -- behind targets whenever the player rotates the camera at high FOV.
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
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local rootPart = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        local head = char and char:FindFirstChild("Head")

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
                        local healthGradient = esp.HealthBarFill:FindFirstChild("HealthGradient")
                        local healthHigh = isVisible and currentTheme.HealthHigh or currentTheme.Enemy_Hidden
                        local healthMid = isVisible and currentTheme.HealthMid or currentTheme.Enemy_Hidden
                        local healthLow = isVisible and currentTheme.HealthLow or currentTheme.Enemy_Hidden
                        if healthGradient and (esp.HealthGradientHigh ~= healthHigh
                            or esp.HealthGradientMid ~= healthMid or esp.HealthGradientLow ~= healthLow) then
                            healthGradient.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, healthHigh),
                                ColorSequenceKeypoint.new(0.55, healthMid),
                                ColorSequenceKeypoint.new(1, healthLow),
                            })
                            esp.HealthGradientHigh, esp.HealthGradientMid, esp.HealthGradientLow = healthHigh, healthMid, healthLow
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
                            infoText = string.format("%s [%dm]", infoText, math.floor(dist))
                        end
                        if XCConfig.espShowHealth and health then
                            infoText = string.format("%s [%dHP]", infoText, math.floor(health + 0.5))
                        end
                        if XCConfig.tagShowWeapon and not XCConfig.weaponEspEnabled then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then
                                infoText = string.format("%s {%s}", infoText, tool.Name)
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
    hl.FillColor = currentTheme.Enemy_Accent
    hl.OutlineColor = currentTheme.TextPrimary
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
        setXCSilentAimRequested(true)
        -- Cache only the current target for legacy camera/mouse hooks.
        -- The native bullet ray hook resolves again at fire time and performs
        -- Hit Chance exactly once for each real shot.
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

    -- RAGEBOT & AIMBOT EXECUTION
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
                    if ally then
                        data.Highlight.FillColor = currentTheme.Enemy_Accent:Lerp(currentTheme.TextPrimary, 0.45)
                        data.Highlight.OutlineColor = currentTheme.TextPrimary
                    else
                        local chamsAccent = isVisible and currentTheme.Enemy_Accent or currentTheme.Enemy_Hidden
                        data.Highlight.FillColor = XCConfig.chamsOcclusion and chamsAccent or currentTheme.Enemy_Accent
                        data.Highlight.OutlineColor = XCConfig.chamsOcclusion and chamsAccent or currentTheme.Enemy_Accent
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
function resetXCCharacterInputState()
    xcCharacterInputHook.Character = nil
    xcCharacterInputHook.GroundSince = nil
    xcCharacterInputHook.LastJumpDown = false
    xcCharacterInputHook.AntiCharacter = nil
    xcCharacterInputHook.AntiStarted = nil
    xcCharacterInputHook.AntiLastStep = nil
    xcCharacterInputHook.RandomYaw = nil
    xcCharacterInputHook.AntiComputedStep = nil
    xcCharacterInputHook.AntiComputedRandomYaw = nil
    xcCharacterInputHook.AntiFireUntil = 0
end

function restoreXCCharacterInputHook()
    local state = xcCharacterInputHook
    if state.Module and state.Wrapper and state.Module.SampleInput == state.Wrapper and state.Original then
        pcall(function() state.Module.SampleInput = state.Original end)
    end
    if state.Module and rawget(state.Module, "__XCInputOwner") == xcSessionToken then
        pcall(function() rawset(state.Module, "__XCInputOwner", nil) end)
    end
    state.Ready = false
    resetXCCharacterInputState()
end

-- One resolver is shared by the native input hook and the compatibility
-- fallback. This keeps every preset visually identical on both paths and
-- avoids running a second anti-aim engine.
local function resolveXCAntiAimYaw(mode, originalYaw, elapsed, step, state, rootPart)
    local baseDegrees = tonumber(XCConfig.antiAimYaw) or 180
    local jitterDegrees = math.clamp(tonumber(XCConfig.antiAimJitter) or 60, 0, 180)
    local spinDegrees = (elapsed * math.max(10, tonumber(XCConfig.spinSpeed) or 50) * 6) % 360
    local side = step % 2 == 0 and -1 or 1
    local baseYaw = originalYaw + math.rad(baseDegrees)

    if mode == "Backwards" then
        return originalYaw + math.pi
    elseif mode == "Jitter" then
        return baseYaw + math.rad(jitterDegrees * side)
    elseif mode == "Spin" then
        return baseYaw + math.rad(spinDegrees)
    elseif mode == "Random" then
        if state.AntiComputedStep ~= step or state.AntiComputedRandomYaw == nil then
            state.AntiComputedStep = step
            state.AntiComputedRandomYaw = math.random(-180, 180)
        end
        return baseYaw + math.rad(state.AntiComputedRandomYaw)
    elseif mode == "Gamesense Center Jitter" then
        return baseYaw + math.rad(jitterDegrees * 0.5 * side)
    elseif mode == "Gamesense 3-Way" then
        local phase = step % 3
        local offset = phase == 0 and -jitterDegrees or (phase == 1 and 0 or jitterDegrees)
        return baseYaw + math.rad(offset)
    elseif mode == "Gamesense Sway" then
        local interval = math.max(0.04, tonumber(XCConfig.antiAimInterval) or 0.15)
        return baseYaw + math.rad(math.sin(elapsed * math.pi / interval) * jitterDegrees)
    elseif mode == "NeverLose Adaptive" then
        local velocity = rootPart and rootPart:IsA("BasePart") and rootPart.AssemblyLinearVelocity or Vector3.zero
        local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
        local scale = horizontalSpeed > 3 and 1 or 0.35
        return baseYaw + math.rad(jitterDegrees * scale * side)
    elseif mode == "NeverLose Defensive" then
        local flick = step % 4 == 0 and math.min(110, math.max(45, jitterDegrees)) * side or 0
        return baseYaw + math.rad(flick)
    elseif mode == "NixWare Sideways" then
        return baseYaw + math.rad(90 * side)
    elseif mode == "NixWare Spin Jitter" then
        return baseYaw + math.rad(spinDegrees + jitterDegrees * 0.5 * side)
    elseif mode == "Memesense Legit" then
        local subtleBase = math.clamp(baseDegrees, -35, 35)
        return originalYaw + math.rad(subtleBase + math.min(jitterDegrees, 12) * side)
    elseif mode == "Memesense Low Delta" then
        return originalYaw + math.pi + math.rad(math.min(jitterDegrees, 35) * side)
    end
    return baseYaw
end

function setupXCCharacterInputHook()
    if xcCharacterInputHook.Ready then return true end
    local ok, failure = pcall(function()
        local classes = ReplicatedStorage:FindFirstChild("Classes")
        local movement = ReplicatedStorage:FindFirstChild("MovementV2")
        local characterModule = classes and classes:FindFirstChild("Character")
        local buttonsModule = movement and movement:FindFirstChild("Buttons")
        assert(characterModule and buttonsModule, "Blox Strike movement modules are unavailable")
        local module = require(characterModule)
        local buttons = require(buttonsModule)
        assert(type(module) == "table" and type(module.SampleInput) == "function", "SampleInput is unavailable")
        assert(type(buttons) == "table" and type(buttons.has) == "function" and type(buttons.with) == "function", "Button helpers are unavailable")
        if table.isfrozen and table.isfrozen(module) then error("Character module is frozen", 0) end

        local original = module.SampleInput
        xcCharacterInputHook.Module = module
        xcCharacterInputHook.Original = original
        xcCharacterInputHook.Buttons = buttons

        xcCharacterInputHook.Wrapper = function(character, context, ...)
            local input = original(character, context, ...)
            xcCharacterInputHook.Calls = (xcCharacterInputHook.Calls or 0) + 1
            xcCharacterInputHook.LastCall = os.clock()
            if type(input) ~= "table" or not xcSessionActive() then return input end
            local success, modified = pcall(function()
                local model = player.Character
                if not model or character.IsDestroyed or character.Character ~= model
                    or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox()
                    or player:GetAttribute("IsPlayerChatting") == true then
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
                    local requested = XCConfig.bhopMode == "Automatic" or character.JumpInputDown
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

                -- Pause anti-aim only for the tiny server-input window of a
                -- local shot. The visual spin resumes immediately afterwards,
                -- while bullet ray calculation remains camera-based.
                local weaponIsFiring = false
                if skinData and type(skinData.GetWeapon) == "function" then
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
                    local originalYaw = tonumber(result.LookYaw) or 0
                    local mode = tostring(XCConfig.antiAimMode or "Static")
                    local rootPart = model:FindFirstChild("HumanoidRootPart")
                    local yaw = resolveXCAntiAimYaw(
                        mode, originalYaw, elapsed, step, xcCharacterInputHook, rootPart
                    )
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
        rawset(module, "__XCInputOwner", xcSessionToken)
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
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not XCConfig.antiAimEnabled then
        XCFeatureState.antiAimStarted = nil
        XCFeatureState.AntiComputedStep = nil
        XCFeatureState.AntiComputedRandomYaw = nil
        if hum and savedAutoRotate ~= nil then
            hum.AutoRotate = savedAutoRotate
            savedAutoRotate = nil
        end
        return
    end

    -- The native Blox Strike input hook is authoritative. The HRP rotation
    -- below remains only as a compatibility fallback for other experiences.
    -- Some executors allow replacing SampleInput but the game continues to
    -- call a cached closure. Treat the hook as authoritative only when it was
    -- actually invoked recently; otherwise use the compatible HRP fallback.
    if xcCharacterInputHook.Ready
        and os.clock() - (xcCharacterInputHook.LastCall or 0) < 0.5 then return end

    if not hrp or not hum or hum.Health <= 0 then return end

    if savedAutoRotate == nil then
        savedAutoRotate = hum.AutoRotate
        hum.AutoRotate = false
    end

    local activeCamera = Workspace.CurrentCamera or camera
    if not activeCamera then return end
    local _, cameraYaw = activeCamera.CFrame:ToOrientation()
    local now = os.clock()
    XCFeatureState.antiAimStarted = XCFeatureState.antiAimStarted or now
    local elapsed = now - XCFeatureState.antiAimStarted
    local interval = math.max(0.04, tonumber(XCConfig.antiAimInterval) or 0.15)
    local step = math.floor(elapsed / interval)
    local mode = tostring(XCConfig.antiAimMode or "Spin")
    local targetYaw = resolveXCAntiAimYaw(mode, cameraYaw, elapsed, step, XCFeatureState, hrp)
    targetYaw = (targetYaw + math.pi) % (math.pi * 2) - math.pi
    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, targetYaw, 0)
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
    XCFeatureState.bhopGroundSince = nil
    XCFeatureState.bhopLastJump = 0
    local hum = char:WaitForChild("Humanoid", 5)
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
-- LOCAL-SHOT HIT CONFIRMATION & PHYSICS LOOP
-- ==========================================
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
            local hum = char:FindFirstChildOfClass("Humanoid")
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

    -- Keep the reference Humanoid/velocity path active even when the native
    -- SampleInput hook exists. The hook requests a server-valid jump; this
    -- path supplies the configured speed/air-strafe and is also a fallback on
    -- executors where SampleInput assignment succeeds but is not consumed.
    if activeMode == "Normal" and XCConfig.bunnyHopEnabled then
        local paused = not XCFeatureState.bhopWindowFocused
            or UserInputService:GetFocusedTextBox() ~= nil
            or GuiService.MenuIsOpen
            or player:GetAttribute("IsPlayerChatting") == true
            or (XCConfig.bhopPauseWithMenu and XCFeatureState.menuOpen)
        if paused then
            XCFeatureState.bhopGroundSince = nil
        else
            local now = os.clock()
            local grounded = isPlayerGrounded(char, hrp) or hum.FloorMaterial ~= Enum.Material.Air
            local isSpacePressed = UserInputService:IsKeyDown(Enum.KeyCode.Space)
            local automatic = XCConfig.bhopMode == "Automatic" or XCConfig.bhopAutoJump
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
                activeMode = "Bhop"
                XCFeatureState.bhopLastJump = now
                XCFeatureState.bhopGroundSince = nil
                hum.Jump = true
                finalVelocity = Vector3.new(currentVel.X, math.clamp(tonumber(XCConfig.bhopJumpPower) or 52, 30, 100), currentVel.Z)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            end

            if moving and (grounded or XCConfig.bhopAirStrafe) then
                activeMode = canJump and "Bhop" or (grounded and "Bhop accelerate" or "AutoStrafe")
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

    local function configColor(prefix, fallback) return xcConfigColor(prefix, fallback) end
    local initialMain = configColor("menuBackground", Color3.fromRGB(17, 17, 17))
    local initialPanel = configColor("menuPanel", Color3.fromRGB(12, 12, 12))
    local initialText = configColor("menuText", Color3.fromRGB(235, 235, 235))
    local C = {
        Main = initialMain,
        Sidebar = initialMain:Lerp(Color3.new(0, 0, 0), 0.24),
        Panel = initialPanel,
        Control = initialPanel:Lerp(initialText, 0.06),
        Control2 = initialPanel:Lerp(initialText, 0.11),
        Border = initialPanel:Lerp(initialText, 0.17),
        Black = Color3.fromRGB(0, 0, 0),
        Lime = configColor("menuAccent", Color3.fromRGB(152, 204, 0)),
        White = initialText,
        Text = initialText:Lerp(initialMain, 0.14),
        Muted = initialText:Lerp(initialMain, 0.53),
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

    local function getViewportSize()
        local activeCamera = Workspace.CurrentCamera or camera
        return (activeCamera and activeCamera.ViewportSize) or Vector2.new(1280, 720)
    end

    local main = Instance.new("Frame")
    main.Name = "SkeetMain"
    main.Size = UDim2.fromOffset(680, 450)
    main.Position = UDim2.new(0.5, -340, 0.5, -225)
    main.BackgroundColor3 = C.Main
    main.BackgroundTransparency = XCConfig.menuTransparency
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
        local viewport = getViewportSize()
        if viewport.X <= 0 or viewport.Y <= 0 then return end
        local preferred = (UserInputService.TouchEnabled and 0.82 or 1)
            * math.clamp(tonumber(XCConfig.uiScale) or 1, 0.65, 1.25)
        if XCConfig.settingsCompactMode then preferred *= 0.88 end
        scale.Scale = math.min(preferred, (viewport.X - 20) / 680, (viewport.Y - 20) / 450)
        main.Position = UDim2.new(0.5, -340 * scale.Scale, 0.5, -225 * scale.Scale)
    end
    updateScale()
    task.defer(updateScale)
    if Workspace.CurrentCamera then
        table.insert(connections, Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale))
    end

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
    sidebar.BackgroundTransparency = math.clamp(XCConfig.menuTransparency * 0.7, 0, 0.4)
    sidebar.BorderColor3 = C.Border
    sidebar.BorderSizePixel = 1
    sidebar.Parent = main

    -- Filled after the floating XC button is created. Keeping this callback
    -- here lets live theme changes recolor both letters without rebuilding UI.
    local openButtonThemeRefresh = function() end
    local refreshESPPreview = function() end
    local refreshSkinGallery = function() end

    local function applyMenuTheme()
        local old = {Main=C.Main, Sidebar=C.Sidebar, Panel=C.Panel, Control=C.Control,
            Control2=C.Control2, Border=C.Border, Lime=C.Lime, White=C.White, Text=C.Text, Muted=C.Muted}
        local newMain = configColor("menuBackground", old.Main)
        local newPanel = configColor("menuPanel", old.Panel)
        local newText = configColor("menuText", old.White)
        local nextColors = {
            Main=newMain, Sidebar=newMain:Lerp(Color3.new(0,0,0),0.24), Panel=newPanel,
            Control=newPanel:Lerp(newText,0.06), Control2=newPanel:Lerp(newText,0.11),
            Border=newPanel:Lerp(newText,0.17), Lime=configColor("menuAccent",old.Lime),
            White=newText, Text=newText:Lerp(newMain,0.14), Muted=newText:Lerp(newMain,0.53),
        }
        local function replaceColor(value)
            for role, previous in pairs(old) do if value == previous then return nextColors[role] end end
            return value
        end
        for _, root in ipairs({screenGui, toggleGui}) do
            local objects = {root}
            for _, object in ipairs(root:GetDescendants()) do objects[#objects+1] = object end
            for _, object in ipairs(objects) do pcall(function()
                if object:IsA("GuiObject") then
                    object.BackgroundColor3 = replaceColor(object.BackgroundColor3)
                    object.BorderColor3 = replaceColor(object.BorderColor3)
                end
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                    object.TextColor3 = replaceColor(object.TextColor3)
                end
                if object:IsA("TextBox") then object.PlaceholderColor3 = replaceColor(object.PlaceholderColor3) end
                if object:IsA("ImageLabel") or object:IsA("ImageButton") then object.ImageColor3 = replaceColor(object.ImageColor3) end
                if object:IsA("UIStroke") then object.Color = replaceColor(object.Color) end
                if object:IsA("ScrollingFrame") then object.ScrollBarImageColor3 = replaceColor(object.ScrollBarImageColor3) end
            end) end
        end
        for role, value in pairs(nextColors) do C[role] = value end
        main.BackgroundColor3 = C.Main
        main.BackgroundTransparency = math.clamp(tonumber(XCConfig.menuTransparency) or 0, 0, 0.45)
        sidebar.BackgroundColor3 = C.Sidebar
        sidebar.BackgroundTransparency = math.clamp(main.BackgroundTransparency * 0.7, 0, 0.4)
        topLine.BackgroundColor3 = C.Lime
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,C.Lime:Lerp(Color3.fromRGB(0,170,255),0.45)),
            ColorSequenceKeypoint.new(0.48,C.Lime:Lerp(C.White,0.2)),
            ColorSequenceKeypoint.new(1,C.Lime),
        })
        syncXCUserTheme()
        refreshESPPreview()
        openButtonThemeRefresh()
        updateScale()
    end

    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 1)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = sidebar

    local content = Instance.new("Frame")
    content.Name = "Content"
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

    local searchBar = Instance.new("Frame")
    searchBar.Name = "QuickSearch"
    searchBar.Size = UDim2.new(1, -64, 0, 24)
    searchBar.Position = UDim2.fromOffset(56, 10)
    searchBar.BackgroundColor3 = C.Panel
    searchBar.BorderColor3 = C.Border
    searchBar.BorderSizePixel = 1
    searchBar.Parent = main
    local searchIcon = Instance.new("TextLabel")
    searchIcon.Size = UDim2.fromOffset(24, 22)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = ">"
    searchIcon.TextColor3 = C.Lime
    searchIcon.Font = Enum.Font.Code
    searchIcon.TextSize = 13
    searchIcon.Parent = searchBar
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -50, 1, 0)
    searchBox.Position = UDim2.fromOffset(23, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.ClearTextOnFocus = false
    searchBox.PlaceholderText = "Search modules in this tab..."
    searchBox.PlaceholderColor3 = C.Muted
    searchBox.Text = ""
    searchBox.TextColor3 = C.Text
    searchBox.Font = Enum.Font.Code
    searchBox.TextSize = 10
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchBar
    local clearSearch = Instance.new("TextButton")
    clearSearch.Size = UDim2.fromOffset(24, 22)
    clearSearch.Position = UDim2.new(1, -25, 0, 0)
    clearSearch.BackgroundTransparency = 1
    clearSearch.Text = "x"
    clearSearch.TextColor3 = C.Muted
    clearSearch.Font = Enum.Font.Code
    clearSearch.TextSize = 12
    clearSearch.Parent = searchBar
    clearSearch.Activated:Connect(function() searchBox.Text = "" end)

    local CONTROL_HELP = {
        aimbotEnabled = "Tracks a valid target inside the configured field of view.",
        silentAimEnabled = "Redirects supported shot data without visibly snapping the camera.",
        triggerbotEnabled = "Fires when a valid target is under the crosshair.",
        triggerbotDelay = "Minimum delay between automatic trigger shots.",
        triggerbotScopedOnly = "Allows Triggerbot to fire only while a native scope is active.",
        triggerbotHeadOnly = "Triggerbot fires only when the detected hit part is the head.",
        rageBotEnabled = "Aggressive target selection using the Rage FOV and priority settings.",
        noRecoilEnabled = "Suppresses supported weapon and camera recoil callbacks.",
        noSpreadEnabled = "Requests zero spread from supported weapon calculations.",
        wallbangEnabled = "Allows Silent Aim to select targets through surfaces; without it hidden targets are always rejected.",
        thirdPersonEnabled = "Moves the native camera behind the character.",
        bunnyHopEnabled = "Smooth XC Bhop with grounded timing and optional air control.",
        bhopMode = "Hold requires jump input; Automatic keeps hopping while movement is active.",
        bhopMovingOnly = "Prevents automatic jumps while no movement direction is pressed.",
        bhopPauseWithMenu = "Pauses Bhop while the XC menu or a text box is open.",
        bhopGroundDelay = "Delay after touching the ground before the next jump.",
        bhopAcceleration = "How quickly horizontal velocity approaches the configured Bhop speed.",
        flightEnabled = "Moves the character along the camera direction.",
        chamsEnabled = "Adds a local highlight to valid player models.",
        skeletonEspEnabled = "Draws a lightweight R6/R15 skeleton at 30 updates per second.",
        skeletonDistanceFade = "Gradually fades skeleton lines at long distances.",
        noSmokeEnabled = "Disables detected BloxStrike smoke emitters and restores them when turned off.",
        hitSoundEnabled = "Plays the selected local sound when enemy health decreases.",
        antiAimMode = "Static, jitter, spin and XC adaptations of Gamesense, NeverLose, NixWare or Memesense anti-aim styles.",
        nightModeEnabled = "Applies the selected lighting preset locally.",
        worldSkyboxEnabled = "Applies the selected custom skybox locally.",
        worldPostFXEnabled = "Enables local color correction and post-processing.",
        worldSkyboxPreset = "Selects a local sky preset from the supplied World visual scripts.",
        worldTonePreset = "Applies a coordinated tint preset to Post FX and atmosphere.",
        worldAtmosphereEnabled = "Adds a configurable local Atmosphere without deleting the game's original one.",
        worldBloomEnabled = "Adds a lightweight local Bloom effect with configurable intensity.",
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
        grenadeEspEnabled = "Shows styled grenade labels, bounce trajectory and landing marker.",
        showGrenadePath = "Predicts the grenade arc with surface bounces and a landing marker.",
        grenadeDangerZonesEnabled = "Draws perspective-correct smoke, fire and grenade danger rings.",
        showMolotovRadius = "Shows the projected fire effect radius on the ground.",
        showSmokeRadius = "Shows the projected smoke effect radius on the ground.",
        grenadeDangerOpacity = "Controls danger-ring visibility without changing trajectory brightness.",
        weaponEspEnabled = "Shows a compact lime weapon silhouette below the player box.",
        spectatorListEnabled = "Shows players currently observing the local player when detectable.",
        settingsAutoSave = "Saves the current profile shortly after a UI setting changes.",
        menuKey = "Keyboard shortcut used to show or hide XC.",
        tab_Rage = "Combat: aim assistants, targeting and weapon mechanics.",
        tab_AntiAim = "Movement: anti-aim, third person, bhop, slide and flight.",
        tab_Visuals = "Visuals: ESP, chams and on-screen combat feedback.",
        tab_World = "World: lighting, weather, scope and camera tools.",
        tab_Misc = "Utilities: session helpers, animations and viewmodel controls.",
        tab_Skins = "Inventory changer: weapon finishes, wear, knives and gloves.",
        tab_Players = "Players: target rules, priority player and ESP details.",
        tab_Configs = "Settings: interface, quick actions and configuration profiles.",
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
            local viewport = getViewportSize()
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
                    target:SetAttribute("XCLongPressUntil", os.clock() + 0.4)
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
        local outer = Instance.new("Frame")
        outer.Name = "Section_" .. text:gsub("%W", "_")
        outer.Size = UDim2.new(1, 0, 0, 0)
        outer.AutomaticSize = Enum.AutomaticSize.Y
        outer.BackgroundTransparency = 1
        outer.Parent = parent
        local outerLayout = Instance.new("UIListLayout")
        outerLayout.Padding = UDim.new(0, 5)
        outerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        outerLayout.Parent = outer

        local header = Instance.new("TextButton")
        header.Size = UDim2.new(1, 0, 0, 24)
        header.LayoutOrder = 1
        header.BackgroundTransparency = 1
        header.BorderSizePixel = 0
        header.Text = ""
        header.AutoButtonColor = false
        header.Parent = outer

        local title = Instance.new("TextLabel")
        title.Name = "SectionTitle"
        title.Size = UDim2.new(1, -26, 0, 18)
        title.Position = UDim2.fromOffset(1, 0)
        title.BackgroundTransparency = 1
        title.Text = text:upper()
        title.TextColor3 = C.White
        title.Font = Enum.Font.Code
        title.TextSize = 11
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = header

        local collapseIcon = Instance.new("TextLabel")
        collapseIcon.Name = "CollapseIcon"
        collapseIcon.Size = UDim2.fromOffset(20, 18)
        collapseIcon.Position = UDim2.new(1, -20, 0, 0)
        collapseIcon.BackgroundTransparency = 1
        collapseIcon.Text = "v"
        collapseIcon.TextColor3 = C.Lime
        collapseIcon.Font = Enum.Font.Code
        collapseIcon.TextSize = 11
        collapseIcon.Parent = header

        local accentLine = Instance.new("Frame")
        accentLine.Name = "LimeDivider"
        accentLine.Size = UDim2.new(1, 0, 0, 1)
        accentLine.Position = UDim2.new(0, 0, 1, -2)
        accentLine.BackgroundColor3 = C.Lime
        accentLine.BackgroundTransparency = 0.08
        accentLine.BorderSizePixel = 0
        accentLine.Parent = header

        local lineFade = Instance.new("UIGradient")
        lineFade.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.72, 0.28),
            NumberSequenceKeypoint.new(1, 1),
        })
        lineFade.Parent = accentLine

        local body = Instance.new("Frame")
        body.Name = "Body"
        body.Size = UDim2.new(1, 0, 0, 0)
        body.LayoutOrder = 2
        body.AutomaticSize = Enum.AutomaticSize.Y
        body.BackgroundTransparency = 1
        body.Parent = outer
        local bodyLayout = Instance.new("UIListLayout")
        bodyLayout.Padding = UDim.new(0, 4)
        bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
        bodyLayout.Parent = body

        local group = {outer = outer, body = body, header = header, collapsed = false}
        table.insert(sectionGroups, group)
        activeSectionByParent[parent] = body
        header.Activated:Connect(function()
            group.collapsed = not group.collapsed
            body.Visible = not group.collapsed
            collapseIcon.Text = group.collapsed and ">" or "v"
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
        if XCConfig[key] ~= true then return "OFF", C.Muted end
        if key == "skinChangerEnabled" then
            if skinData.LastError then return "ERR", Color3.fromRGB(218, 82, 82) end
            if not skinData.Ready then return "WAIT", Color3.fromRGB(220, 170, 72) end
        elseif key == "antiAimEnabled" or key == "bunnyHopEnabled" then
            if not xcCharacterInputHook.Ready and xcCharacterInputHook.LastError then
                return "FALL", Color3.fromRGB(220, 170, 72)
            end
            if not xcCharacterInputHook.Ready then return "WAIT", Color3.fromRGB(220, 170, 72) end
        elseif key == "silentAimEnabled" and not xcNativeSilentHooked then
            return "WAIT", Color3.fromRGB(220, 170, 72)
        end
        return "ON", C.Lime
    end

    local function addToggle(parent, label, key, onChanged)
        parent = activeSectionByParent[parent] or parent
        local row = Instance.new("TextButton")
        row.Name = key
        row.Size = UDim2.new(1, 0, 0, UserInputService.TouchEnabled and 28 or 22)
        row.BackgroundTransparency = 1
        row.Text = ""
        row.AutoButtonColor = false
        row.Parent = parent
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, -76, 1, 0)
        text.Position = UDim2.fromOffset(0, 0)
        text.BackgroundTransparency = 1
        text.Text = label
        text.TextColor3 = C.Text
        text.Font = Enum.Font.Code
        text.TextSize = 11
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Parent = row

        local statusText = Instance.new("TextLabel")
        statusText.Name = "RuntimeStatus"
        statusText.Size = UDim2.fromOffset(34, 14)
        statusText.Position = UDim2.new(1, -67, 0.5, -7)
        statusText.BackgroundColor3 = C.Control
        statusText.BackgroundTransparency = 0.15
        statusText.BorderSizePixel = 0
        statusText.Font = Enum.Font.Code
        statusText.TextSize = 8
        statusText.TextXAlignment = Enum.TextXAlignment.Center
        statusText.Parent = row
        local statusCorner = Instance.new("UICorner")
        statusCorner.CornerRadius = UDim.new(0, 3)
        statusCorner.Parent = statusText

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

        local function refreshStatus()
            local state, color = getModuleRuntimeStatus(key)
            local background = state == "ERR" and Color3.fromRGB(45, 18, 18)
                or (state == "WAIT" or state == "FALL") and Color3.fromRGB(43, 34, 17) or C.Control
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
            if os.clock() < (row:GetAttribute("XCLongPressUntil") or 0) then return end
            XCConfig[key] = not XCConfig[key]
            refreshConfigControls(key, XCConfig[key])
            if onChanged then onChanged(XCConfig[key]) end
            scheduleConfigAutoSave()
            if key ~= "settingsShowNotifications" then
                XCNotify(label, XCConfig[key] and "Enabled" or "Disabled", XCConfig[key] and "success" or "warning", 1.5)
            end
        end)
        attachHelp(row, key)
        registerSearch(row, label .. " " .. key)
        return row
    end

    local function addSlider(parent, label, key, minValue, maxValue, step, suffix, onChanged)
        parent = activeSectionByParent[parent] or parent
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
            local shown = step < 0.01 and string.format("%.3f", value)
                or step < 1 and string.format("%.2f", value)
                or tostring(math.floor(value + 0.5))
            valueLabel.Text = shown .. (suffix or "")
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
        registerSearch(holder, label .. " " .. key)
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
        local viewport = getViewportSize()
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
            optionButton.Text = ""
            optionButton.Font = Enum.Font.Code
            optionButton.TextSize = UserInputService.TouchEnabled and 11 or 10
            optionButton.AutoButtonColor = false
            optionButton.ZIndex = 201
            optionButton.Parent = popup

            local optionText = Instance.new("TextLabel")
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

        local function resolvedValues()
            local list = type(values) == "function" and values() or values
            return type(list) == "table" and #list > 0 and list or {"Default"}
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
        registerSearch(holder, label .. " " .. key)
    end

    local function addButton(parent, label, callback)
        parent = activeSectionByParent[parent] or parent
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
        registerSearch(button, label)
        return button
    end

    local function addNote(parent, message)
        parent = activeSectionByParent[parent] or parent
        local note = Instance.new("TextLabel")
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
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 6)
        padding.PaddingRight = UDim.new(0, 6)
        padding.Parent = note
        registerSearch(note, message)
        return note
    end

    local activeColorPopup
    local activeColorConnections = {}
    local function closeColorPopup()
        for _, connection in ipairs(activeColorConnections) do pcall(function() connection:Disconnect() end) end
        table.clear(activeColorConnections)
        if activeColorPopup then activeColorPopup:Destroy(); activeColorPopup = nil end
    end

    local function addColorPicker(parent, label, prefix, onChanged)
        parent = activeSectionByParent[parent] or parent
        local holder = Instance.new("Frame")
        holder.Name = prefix .. "ColorPicker"
        holder.Size = UDim2.new(1, 0, 0, UserInputService.TouchEnabled and 32 or 26)
        holder.BackgroundTransparency = 1
        holder.Parent = parent
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -94, 1, 0)
        title.BackgroundTransparency = 1
        title.Text = label
        title.TextColor3 = C.Text
        title.Font = Enum.Font.Code
        title.TextSize = 10
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = holder
        local hexLabel = Instance.new("TextLabel")
        hexLabel.Size = UDim2.fromOffset(58, 18)
        hexLabel.Position = UDim2.new(1, -88, 0.5, -9)
        hexLabel.BackgroundTransparency = 1
        hexLabel.TextColor3 = C.Muted
        hexLabel.Font = Enum.Font.Code
        hexLabel.TextSize = 9
        hexLabel.TextXAlignment = Enum.TextXAlignment.Right
        hexLabel.Parent = holder
        local swatch = Instance.new("TextButton")
        swatch.Size = UDim2.fromOffset(UserInputService.TouchEnabled and 27 or 23, UserInputService.TouchEnabled and 27 or 19)
        swatch.Position = UDim2.new(1, -(UserInputService.TouchEnabled and 27 or 23), 0.5, -(UserInputService.TouchEnabled and 13 or 9))
        swatch.BorderColor3 = C.Black
        swatch.BorderSizePixel = 1
        swatch.Text = ""
        swatch.AutoButtonColor = false
        swatch.Parent = holder
        Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 3)

        local function readColor()
            return configColor(prefix, Color3.fromRGB(255, 255, 255))
        end
        local function refresh()
            local color = readColor()
            swatch.BackgroundColor3 = color
            hexLabel.Text = string.format("#%02X%02X%02X",
                math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
        end
        refresh()
        for _, suffix in ipairs({"R", "G", "B"}) do
            local key = prefix .. suffix
            refreshers[key] = refreshers[key] or {}
            table.insert(refreshers[key], refresh)
        end

        swatch.Activated:Connect(function()
            closeColorPopup()
            local popup = Instance.new("Frame")
            activeColorPopup = popup
            popup.Name = "Palette_" .. prefix
            popup.Size = UDim2.fromOffset(238, 180)
            local absolute = swatch.AbsolutePosition
            local viewport = getViewportSize()
            popup.Position = UDim2.fromOffset(
                math.clamp(absolute.X - 205, 6, math.max(6, viewport.X - 244)),
                math.clamp(absolute.Y + swatch.AbsoluteSize.Y + 4, 6, math.max(6, viewport.Y - 186)))
            popup.BackgroundColor3 = C.Panel
            popup.BorderColor3 = C.Border
            popup.BorderSizePixel = 1
            popup.ZIndex = 300
            popup.Parent = screenGui
            local popupStroke = Instance.new("UIStroke", popup)
            popupStroke.Color = C.Black
            popupStroke.Thickness = 1
            local popupTitle = Instance.new("TextLabel", popup)
            popupTitle.Position = UDim2.fromOffset(8, 3)
            popupTitle.Size = UDim2.new(1, -34, 0, 20)
            popupTitle.BackgroundTransparency = 1
            popupTitle.Text = label:upper()
            popupTitle.TextColor3 = C.Text
            popupTitle.Font = Enum.Font.Code
            popupTitle.TextSize = 9
            popupTitle.TextXAlignment = Enum.TextXAlignment.Left
            popupTitle.ZIndex = 301
            local close = Instance.new("TextButton", popup)
            close.Size = UDim2.fromOffset(22, 20)
            close.Position = UDim2.new(1, -25, 0, 2)
            close.BackgroundTransparency = 1
            close.Text = "×"
            close.TextColor3 = C.Muted
            close.Font = Enum.Font.Code
            close.TextSize = 16
            close.ZIndex = 302
            close.Activated:Connect(closeColorPopup)

            local selected = readColor()
            local hue, saturation, value = selected:ToHSV()
            local sv = Instance.new("Frame", popup)
            sv.Position = UDim2.fromOffset(8, 25)
            sv.Size = UDim2.fromOffset(170, 108)
            sv.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            sv.BorderSizePixel = 0
            sv.Active = true
            sv.ZIndex = 301
            local white = Instance.new("Frame", sv)
            white.Size = UDim2.fromScale(1, 1); white.BorderSizePixel = 0; white.BackgroundColor3 = Color3.new(1,1,1); white.ZIndex = 302
            local whiteGradient = Instance.new("UIGradient", white)
            whiteGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
            local black = Instance.new("Frame", sv)
            black.Size = UDim2.fromScale(1, 1); black.BorderSizePixel = 0; black.BackgroundColor3 = Color3.new(0,0,0); black.ZIndex = 303
            local blackGradient = Instance.new("UIGradient", black)
            blackGradient.Rotation = 90
            blackGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
            local cursor = Instance.new("Frame", sv)
            cursor.AnchorPoint = Vector2.new(0.5,0.5); cursor.Size = UDim2.fromOffset(8,8); cursor.BackgroundTransparency = 1
            cursor.BorderColor3 = Color3.new(1,1,1); cursor.BorderSizePixel = 1; cursor.ZIndex = 305

            local hueBar = Instance.new("Frame", popup)
            hueBar.Position = UDim2.fromOffset(8, 141); hueBar.Size = UDim2.fromOffset(170, 14)
            hueBar.BorderSizePixel = 0; hueBar.Active = true; hueBar.ZIndex = 301
            local hueGradient = Instance.new("UIGradient", hueBar)
            hueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)), ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),
                ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)), ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
                ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)), ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),
                ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))})
            local hueCursor = Instance.new("Frame", hueBar)
            hueCursor.AnchorPoint = Vector2.new(0.5,0.5); hueCursor.Size = UDim2.fromOffset(3,18)
            hueCursor.Position = UDim2.new(hue,0,0.5,0); hueCursor.BackgroundColor3 = Color3.new(1,1,1)
            hueCursor.BorderColor3 = Color3.new(0,0,0); hueCursor.BorderSizePixel = 1; hueCursor.ZIndex = 304

            local preview = Instance.new("Frame", popup)
            preview.Position = UDim2.fromOffset(187, 26); preview.Size = UDim2.fromOffset(42,42)
            preview.BorderColor3 = C.Black; preview.BorderSizePixel = 1; preview.ZIndex = 301
            Instance.new("UICorner", preview).CornerRadius = UDim.new(0,4)
            local hex = Instance.new("TextBox", popup)
            hex.Position = UDim2.fromOffset(184, 78); hex.Size = UDim2.fromOffset(47,24)
            hex.BackgroundColor3 = C.Control; hex.BorderColor3 = C.Black; hex.BorderSizePixel = 1
            hex.ClearTextOnFocus = false; hex.TextColor3 = C.Text; hex.Font = Enum.Font.Code; hex.TextSize = 9; hex.ZIndex = 301

            local function commitColor(color)
                XCConfig[prefix.."R"] = math.floor(color.R*255+0.5)
                XCConfig[prefix.."G"] = math.floor(color.G*255+0.5)
                XCConfig[prefix.."B"] = math.floor(color.B*255+0.5)
                preview.BackgroundColor3 = color
                hex.Text = string.format("%02X%02X%02X",XCConfig[prefix.."R"],XCConfig[prefix.."G"],XCConfig[prefix.."B"])
                cursor.Position = UDim2.fromScale(saturation,1-value)
                hueCursor.Position = UDim2.new(hue,0,0.5,0)
                refresh()
                if onChanged then onChanged(color) end
                scheduleConfigAutoSave()
            end
            local function updateSV(position)
                saturation = math.clamp((position.X-sv.AbsolutePosition.X)/math.max(1,sv.AbsoluteSize.X),0,1)
                value = 1-math.clamp((position.Y-sv.AbsolutePosition.Y)/math.max(1,sv.AbsoluteSize.Y),0,1)
                commitColor(Color3.fromHSV(hue,saturation,value))
            end
            local function updateHue(position)
                hue = math.clamp((position.X-hueBar.AbsolutePosition.X)/math.max(1,hueBar.AbsoluteSize.X),0,1)
                sv.BackgroundColor3 = Color3.fromHSV(hue,1,1)
                commitColor(Color3.fromHSV(hue,saturation,value))
            end
            local draggingSV, draggingHue = false, false
            sv.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then draggingSV=true; updateSV(input.Position) end end)
            hueBar.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then draggingHue=true; updateHue(input.Position) end end)
            local paletteMoveConnection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
                    if draggingSV then updateSV(input.Position) elseif draggingHue then updateHue(input.Position) end
                end
            end)
            table.insert(activeColorConnections,paletteMoveConnection)
            table.insert(connections,paletteMoveConnection)
            local paletteEndConnection = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then draggingSV=false; draggingHue=false end
            end)
            table.insert(activeColorConnections,paletteEndConnection)
            table.insert(connections,paletteEndConnection)
            hex.FocusLost:Connect(function(enterPressed)
                local valueText = hex.Text:gsub("#","")
                if enterPressed and valueText:match("^[%x][%x][%x][%x][%x][%x]$") then
                    local color = Color3.fromRGB(tonumber(valueText:sub(1,2),16),tonumber(valueText:sub(3,4),16),tonumber(valueText:sub(5,6),16))
                    hue,saturation,value = color:ToHSV(); sv.BackgroundColor3 = Color3.fromHSV(hue,1,1); commitColor(color)
                end
            end)
            commitColor(selected)
        end)
        registerSearch(holder,label.." color palette "..prefix)
        return holder
    end

    local function addESPPreview(parent)
        parent = activeSectionByParent[parent] or parent
        local card = Instance.new("Frame")
        card.Name = "ESPPreview"
        card.Size = UDim2.new(1, 0, 0, 190)
        card.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        card.BorderColor3 = C.Border
        card.BorderSizePixel = 1
        card.ClipsDescendants = true
        card.Parent = parent

        local title = Instance.new("TextLabel", card)
        title.Size = UDim2.new(1, -76, 0, 20)
        title.Position = UDim2.fromOffset(7, 3)
        title.BackgroundTransparency = 1
        title.Text = "PLAYER ESP PREVIEW"
        title.TextColor3 = C.Text
        title.Font = Enum.Font.Code
        title.TextSize = 9
        title.TextXAlignment = Enum.TextXAlignment.Left

        local previewVisible = true
        local mode = Instance.new("TextButton", card)
        mode.Size = UDim2.fromOffset(67, 18)
        mode.Position = UDim2.new(1, -72, 0, 4)
        mode.BackgroundColor3 = C.Control
        mode.BorderColor3 = C.Border
        mode.BorderSizePixel = 1
        mode.Font = Enum.Font.Code
        mode.TextSize = 8
        mode.AutoButtonColor = false

        local canvas = Instance.new("Frame", card)
        canvas.Size = UDim2.new(1, -12, 1, -31)
        canvas.Position = UDim2.fromOffset(6, 26)
        canvas.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        canvas.BorderSizePixel = 0
        canvas.ClipsDescendants = true

        -- All preview objects share one fixed local coordinate space. This
        -- avoids mixing AbsolutePosition with local offsets when the menu is
        -- scaled, scrolled or opened on a phone.
        local root = Instance.new("Frame", canvas)
        root.Name = "PreviewSpace"
        root.AnchorPoint = Vector2.new(0.5, 0.5)
        root.Position = UDim2.fromScale(0.5, 0.54)
        root.Size = UDim2.fromOffset(126, 142)
        root.BackgroundTransparency = 1

        local body = Instance.new("Frame", root)
        body.AnchorPoint = Vector2.new(0.5, 0.5)
        body.Position = UDim2.fromOffset(63, 75)
        body.Size = UDim2.fromOffset(18, 56)
        body.BackgroundTransparency = 0.72
        body.BorderSizePixel = 0
        local head = Instance.new("Frame", root)
        head.AnchorPoint = Vector2.new(0.5, 0.5)
        head.Position = UDim2.fromOffset(63, 37)
        head.Size = UDim2.fromOffset(17, 17)
        head.BackgroundTransparency = 0.72
        head.BorderSizePixel = 0
        Instance.new("UICorner", head).CornerRadius = UDim.new(1, 0)

        local boxOutlineFrame = Instance.new("Frame", root)
        boxOutlineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        boxOutlineFrame.Position = UDim2.fromOffset(63, 70)
        boxOutlineFrame.BackgroundTransparency = 1
        local boxOutline = Instance.new("UIStroke", boxOutlineFrame)
        boxOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        boxOutline.Color = Color3.fromRGB(3, 3, 3)
        local box = Instance.new("Frame", root)
        box.AnchorPoint = Vector2.new(0.5, 0.5)
        box.Position = UDim2.fromOffset(63, 70)
        box.BackgroundTransparency = 1
        local boxStroke = Instance.new("UIStroke", box)
        boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local cornerLines = {}
        for index = 1, 8 do
            local line = Instance.new("Frame", root)
            line.BorderSizePixel = 0
            cornerLines[index] = line
        end

        local healthBack = Instance.new("Frame", root)
        healthBack.AnchorPoint = Vector2.new(1, 0)
        healthBack.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
        healthBack.BorderSizePixel = 0
        local healthFill = Instance.new("Frame", healthBack)
        healthFill.AnchorPoint = Vector2.new(0, 1)
        healthFill.Position = UDim2.new(0, 1, 1, -1)
        healthFill.Size = UDim2.new(1, -2, 0.72, -1)
        healthFill.BorderSizePixel = 0
        local healthGradient = Instance.new("UIGradient", healthFill)
        healthGradient.Rotation = 90

        local tag = Instance.new("TextLabel", root)
        tag.AnchorPoint = Vector2.new(0.5, 1)
        tag.Position = UDim2.fromOffset(63, 23)
        tag.Size = UDim2.fromOffset(124, 16)
        tag.BackgroundTransparency = 1
        tag.Text = "enemy [42m] [72HP]"
        tag.Font = Enum.Font.Code
        tag.TextSize = 9

        local function makeLine(a, b, thickness)
            local delta, middle = b - a, (a + b) * 0.5
            local line = Instance.new("Frame", root)
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.Position = UDim2.fromOffset(middle.X, middle.Y)
            line.Size = UDim2.fromOffset(delta.Magnitude, thickness or 1)
            line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
            line.BorderSizePixel = 0
            return line
        end
        local skeletonLines = {
            makeLine(Vector2.new(63,45),Vector2.new(63,70),1),
            makeLine(Vector2.new(63,53),Vector2.new(48,68),1),
            makeLine(Vector2.new(63,53),Vector2.new(78,68),1),
            makeLine(Vector2.new(63,70),Vector2.new(51,99),1),
            makeLine(Vector2.new(63,70),Vector2.new(75,99),1),
        }
        local tracer = makeLine(Vector2.new(7,137),Vector2.new(63,37),1)
        local headDot = Instance.new("Frame", root)
        headDot.AnchorPoint = Vector2.new(0.5,0.5)
        headDot.Position = UDim2.fromOffset(63,37)
        headDot.Size = UDim2.fromOffset(5,5)
        headDot.BorderSizePixel = 0
        Instance.new("UICorner",headDot).CornerRadius = UDim.new(1,0)

        local weaponIcon = Instance.new("Frame", root)
        weaponIcon.AnchorPoint = Vector2.new(0.5,0)
        weaponIcon.Position = UDim2.fromOffset(63,111)
        weaponIcon.Size = UDim2.fromOffset(38,12)
        weaponIcon.BackgroundTransparency = 1
        local weaponBody = Instance.new("Frame",weaponIcon)
        weaponBody.Position = UDim2.fromOffset(3,2);weaponBody.Size=UDim2.fromOffset(25,4);weaponBody.BorderSizePixel=0
        local weaponBarrel = Instance.new("Frame",weaponIcon)
        weaponBarrel.Position = UDim2.fromOffset(27,3);weaponBarrel.Size=UDim2.fromOffset(9,2);weaponBarrel.BorderSizePixel=0
        local weaponGrip = Instance.new("Frame",weaponIcon)
        weaponGrip.Position = UDim2.fromOffset(17,5);weaponGrip.Size=UDim2.fromOffset(4,7);weaponGrip.Rotation=18;weaponGrip.BorderSizePixel=0

        local function refreshPreview()
            local color = previewVisible and currentTheme.Enemy_Accent or currentTheme.Enemy_Hidden
            local height = math.clamp(76 * (tonumber(XCConfig.espPerspectiveScale) or 1), 58, 94)
            local width = math.clamp(height * (tonumber(XCConfig.espBoxAspect) or 0.52), 27, 57)
            local left, top = 63-width*0.5, 70-height*0.5
            local thick = math.clamp(tonumber(XCConfig.boxThickness) or 1,1,3)
            mode.Text = previewVisible and "VISIBLE" or "HIDDEN"
            mode.TextColor3 = color
            box.Size = UDim2.fromOffset(width,height)
            boxOutlineFrame.Size = UDim2.fromOffset(width,height)
            boxStroke.Color = color;boxStroke.Thickness = thick
            boxOutline.Thickness = thick+2;boxOutline.Transparency = 0.1
            box.Visible = XCConfig.boxEspEnabled and not XCConfig.cornerBoxEnabled
            boxOutlineFrame.Visible = box.Visible and XCConfig.espBoxOutline
            body.BackgroundColor3=color;head.BackgroundColor3=color
            body.Visible=XCConfig.chamsEnabled;head.Visible=XCConfig.chamsEnabled
            healthBack.Position=UDim2.fromOffset(left-3,top);healthBack.Size=UDim2.fromOffset(4,height)
            healthBack.Visible=XCConfig.healthBarEnabled
            local hpHigh=previewVisible and currentTheme.HealthHigh or currentTheme.Enemy_Hidden
            local hpMid=previewVisible and currentTheme.HealthMid or currentTheme.Enemy_Hidden
            local hpLow=previewVisible and currentTheme.HealthLow or currentTheme.Enemy_Hidden
            healthFill.BackgroundColor3=Color3.new(1,1,1)
            healthGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,hpHigh),ColorSequenceKeypoint.new(0.55,hpMid),ColorSequenceKeypoint.new(1,hpLow)})
            local tagText="enemy"
            if XCConfig.espShowDistance then tagText..=" [42m]" end
            if XCConfig.espShowHealth then tagText..=" [72HP]" end
            if XCConfig.tagShowWeapon and not XCConfig.weaponEspEnabled then tagText..=" [AK-47]" end
            tag.Text=tagText;tag.TextColor3=color;tag.TextSize=XCConfig.espTextSize;tag.Visible=XCConfig.nametagsEnabled
            local length=math.clamp(math.floor(width*0.32+0.5),6,16)
            local specs={{left,top,length,thick},{left,top,thick,length},{left+width-length,top,length,thick},{left+width-thick,top,thick,length},
                {left,top+height-thick,length,thick},{left,top+height-length,thick,length},{left+width-length,top+height-thick,length,thick},{left+width-thick,top+height-length,thick,length}}
            for index,line in ipairs(cornerLines) do local spec=specs[index]
                line.Position=UDim2.fromOffset(spec[1],spec[2]);line.Size=UDim2.fromOffset(spec[3],spec[4]);line.BackgroundColor3=color
                line.Visible=XCConfig.cornerBoxEnabled
            end
            for _,line in ipairs(skeletonLines) do line.BackgroundColor3=color;line.Visible=XCConfig.skeletonEspEnabled end
            tracer.BackgroundColor3=color;tracer.Visible=XCConfig.tracersEnabled
            headDot.BackgroundColor3=color;headDot.Visible=XCConfig.headDotEnabled
            weaponBody.BackgroundColor3=color;weaponBarrel.BackgroundColor3=color;weaponGrip.BackgroundColor3=color
            weaponIcon.Visible=XCConfig.weaponEspEnabled
        end
        refreshESPPreview = refreshPreview
        mode.Activated:Connect(function() previewVisible=not previewVisible;refreshPreview() end)
        for _,key in ipairs({"boxEspEnabled","cornerBoxEnabled","healthBarEnabled","nametagsEnabled","chamsEnabled","skeletonEspEnabled",
            "tracersEnabled","headDotEnabled","weaponEspEnabled","espPerspectiveScale","espBoxAspect","boxThickness","espBoxOutline",
            "espTextSize","espShowDistance","espShowHealth","tagShowWeapon",
            "espVisibleR","espVisibleG","espVisibleB","espHiddenR","espHiddenG","espHiddenB","espHealthHighR","espHealthHighG","espHealthHighB",
            "espHealthMidR","espHealthMidG","espHealthMidB","espHealthLowR","espHealthLowG","espHealthLowB"}) do
            refreshers[key]=refreshers[key] or {};table.insert(refreshers[key],refreshPreview)
        end
        task.defer(refreshPreview)
        registerSearch(card,"player esp preview box corner health nametag chams skeleton tracer head dot weapon")
        return card
    end

    local function addSkinGallery(parent)
        parent = activeSectionByParent[parent] or parent
        local holder = Instance.new("Frame", parent)
        holder.Name = "SkinImageGallery"
        holder.Size = UDim2.new(1, 0, 0, 388)
        holder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        holder.BorderColor3 = C.Border
        holder.BorderSizePixel = 1

        local categoryButtons = {}
        local categoryBar = Instance.new("Frame", holder)
        categoryBar.Position = UDim2.fromOffset(6, 5)
        categoryBar.Size = UDim2.new(1, -12, 0, 25)
        categoryBar.BackgroundTransparency = 1
        for index, modeName in ipairs({"Weapon", "Knife", "Gloves"}) do
            local button = Instance.new("TextButton", categoryBar)
            button.Position = UDim2.new((index-1)/3, index==1 and 0 or 2, 0, 0)
            button.Size = UDim2.new(1/3, -3, 1, 0)
            button.BackgroundColor3 = C.Control
            button.BorderColor3 = C.Border
            button.BorderSizePixel = 1
            button.Text = ({Weapon="WEAPONS",Knife="KNIVES",Gloves="GLOVES"})[modeName]
            button.TextColor3 = C.Muted
            button.Font = Enum.Font.Code
            button.TextSize = 9
            button.AutoButtonColor = false
            categoryButtons[modeName] = button
            button.Activated:Connect(function()
                XCConfig.skinGalleryMode = modeName
                refreshSkinGallery()
                scheduleConfigAutoSave()
            end)
        end

        local itemBar = Instance.new("ScrollingFrame", holder)
        itemBar.Position = UDim2.fromOffset(6, 35)
        itemBar.Size = UDim2.new(1, -12, 0, UserInputService.TouchEnabled and 36 or 31)
        itemBar.BackgroundColor3 = C.Panel
        itemBar.BorderColor3 = C.Border
        itemBar.BorderSizePixel = 1
        itemBar.ScrollBarThickness = 2
        itemBar.ScrollBarImageColor3 = C.Lime
        itemBar.ScrollingDirection = Enum.ScrollingDirection.X
        itemBar.CanvasSize = UDim2.new()
        local itemLayout = Instance.new("UIListLayout", itemBar)
        itemLayout.FillDirection = Enum.FillDirection.Horizontal
        itemLayout.Padding = UDim.new(0, 4)
        itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
        local itemPadding = Instance.new("UIPadding", itemBar)
        itemPadding.PaddingLeft = UDim.new(0, 4)
        itemPadding.PaddingRight = UDim.new(0, 4)
        itemPadding.PaddingTop = UDim.new(0, 3)
        itemPadding.PaddingBottom = UDim.new(0, 3)

        local heading = Instance.new("TextLabel", holder)
        heading.Position = UDim2.fromOffset(7, UserInputService.TouchEnabled and 75 or 70)
        heading.Size = UDim2.new(1, -14, 0, 20)
        heading.BackgroundTransparency = 1
        heading.TextColor3 = C.Text
        heading.Font = Enum.Font.Code
        heading.TextSize = 9
        heading.TextXAlignment = Enum.TextXAlignment.Left

        local grid = Instance.new("ScrollingFrame", holder)
        grid.Position = UDim2.fromOffset(6, UserInputService.TouchEnabled and 96 or 91)
        grid.Size = UDim2.new(1, -12, 1, UserInputService.TouchEnabled and -102 or -97)
        grid.BackgroundTransparency = 1
        grid.BorderSizePixel = 0
        grid.ScrollBarThickness = 2
        grid.ScrollBarImageColor3 = C.Lime
        grid.AutomaticCanvasSize = Enum.AutomaticSize.Y
        grid.CanvasSize = UDim2.new()
        local layout = Instance.new("UIGridLayout", grid)
        layout.CellSize = UDim2.new(0.25, -5, 0, UserInputService.TouchEnabled and 102 or 88)
        layout.CellPadding = UDim2.fromOffset(5, 5)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        local padding = Instance.new("UIPadding", grid)
        padding.PaddingRight = UDim.new(0, 2)
        padding.PaddingBottom = UDim.new(0, 4)

        local function normalizeImage(value)
            if type(value)=="number" and value>0 then return "rbxassetid://"..math.floor(value) end
            if type(value)~="string" or value=="" then return nil end
            if value:match("^%d+$") then return "rbxassetid://"..value end
            if value:find("rbxasset",1,true) or value:find("http",1,true) then return value end
            return nil
        end
        local function findPreviewImage(itemName, skinName)
            local folder=skinData.SkinsRoot and skinData.SkinsRoot:FindFirstChild(itemName)
            local skinFolder=folder and folder:FindFirstChild(skinName)
            if skinFolder then
                for _,key in ipairs({"Image","Icon","Thumbnail","Preview","ImageId","IconId","ThumbnailId"}) do
                    local image=normalizeImage(skinFolder:GetAttribute(key));if image then return image end
                end
                for _,object in ipairs(skinFolder:GetDescendants()) do
                    local lower=object.Name:lower()
                    if lower:find("image",1,true) or lower:find("icon",1,true) or lower:find("thumbnail",1,true) or lower:find("preview",1,true) then
                        if object:IsA("StringValue") or object:IsA("IntValue") or object:IsA("NumberValue") then
                            local image=normalizeImage(object.Value);if image then return image end
                        elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
                            local image=normalizeImage(object.Image);if image then return image end
                        end
                    end
                end
            end
            if skinData.SkinLibrary and type(skinData.SkinLibrary.GetAllSkinsForWeapon)=="function" then
                local ok,entries=pcall(skinData.SkinLibrary.GetAllSkinsForWeapon,itemName)
                if ok and type(entries)=="table" then for _,info in ipairs(entries) do
                    if type(info)=="table" and (info.skin==skinName or info.name==skinName) then
                        for _,key in ipairs({"image","Image","icon","Icon","thumbnail","Thumbnail","preview","Preview"}) do
                            local image=normalizeImage(info[key]);if image then return image end
                        end
                    end
                end end
            end
            return nil
        end
        local function addModelPreview(viewport,itemName,skinName)
            local asset=skinData.WeaponAssets and skinData.WeaponAssets:FindFirstChild(itemName)
            if not asset then
                local assets=ReplicatedStorage:FindFirstChild("Assets")
                for _,rootName in ipairs({"Gloves","Viewmodels","Models","Characters"}) do
                    local rootFolder=assets and assets:FindFirstChild(rootName)
                    asset=rootFolder and rootFolder:FindFirstChild(itemName,true)
                    if asset then break end
                end
            end
            if not asset then return false end
            local source=asset:IsA("Model") and asset or asset:FindFirstChildWhichIsA("Model",true)
            if not source or not source:FindFirstChildWhichIsA("BasePart",true) then return false end
            local ok,model=pcall(function() source.Archivable=true;return source:Clone() end)
            if not ok or not model then return false end
            for _,object in ipairs(model:GetDescendants()) do
                if object:IsA("Script") or object:IsA("LocalScript") or object:IsA("ModuleScript")
                    or object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam") then object:Destroy()
                elseif object:IsA("BasePart") then object.Anchored=true;object.CanCollide=false;object.CastShadow=false end
            end
            pcall(applySurfaceAppearanceSkin,model,itemName,skinName,0)
            local world=Instance.new("WorldModel",viewport);model.Parent=world
            local cam=Instance.new("Camera",viewport);cam.FieldOfView=34;viewport.CurrentCamera=cam
            local boundsOk,bounds,size=pcall(function() local cf,sz=model:GetBoundingBox();return cf,sz end)
            if not boundsOk then model:Destroy();return false end
            local radius=math.max(size.X,size.Y,size.Z,1)
            cam.CFrame=CFrame.lookAt(bounds.Position+Vector3.new(radius*1.35,radius*0.45,radius*1.55),bounds.Position)
            return true
        end

        local gallerySerial=0
        local cards={}
        local function currentItem()
            if XCConfig.skinGalleryMode=="Knife" then return XCConfig.selectedKnifeType
            elseif XCConfig.skinGalleryMode=="Gloves" then return XCConfig.selectedGloveModel end
            return XCConfig.skinEditorWeapon
        end
        local function currentSelection(itemName)
            if XCConfig.skinGalleryMode=="Knife" then return XCConfig.selectedSkin
            elseif XCConfig.skinGalleryMode=="Gloves" then return XCConfig.selectedGloveSkin end
            return XCConfig.weaponSkinSelections[itemName] or "Default"
        end
        local function categoryItems()
            if XCConfig.skinGalleryMode=="Knife" then return getXCKnifeChoices()
            elseif XCConfig.skinGalleryMode=="Gloves" then return getXCGloveModelChoices() end
            return getXCWeaponSkinChoices()
        end
        local function selectItem(itemName, resetFinish)
            if XCConfig.skinGalleryMode=="Knife" then
                XCConfig.selectedKnifeType=itemName
                if resetFinish then XCConfig.selectedSkin="Default" end
                applyXCKnifeChanger()
            elseif XCConfig.skinGalleryMode=="Gloves" then
                XCConfig.selectedGloveModel=itemName
                if resetFinish then XCConfig.selectedGloveSkin="Default" end
                applyXCGloves()
            else
                XCConfig.skinEditorWeapon=itemName
                XCConfig.skinEditorFinish=XCConfig.weaponSkinSelections[itemName] or "Default"
                XCConfig.skinWear=XCConfig.weaponSkinWear[itemName] or 0
                refreshConfigControls("skinWear",XCConfig.skinWear)
            end
        end
        local function updateCardSelection(itemName)
            local selected=currentSelection(itemName)
            for skinName,card in pairs(cards) do
                local active=skinName==selected
                card.BorderColor3=active and C.Lime or C.Border
                card.BorderSizePixel=active and 2 or 1
                local check=card:FindFirstChild("Selected")
                if check then check.Visible=active;check.TextColor3=C.Lime end
            end
        end
        refreshSkinGallery=function()
            gallerySerial+=1;local serial=gallerySerial
            refreshXCSkinData();table.clear(cards)
            for _,child in ipairs(grid:GetChildren()) do if child~=layout and child~=padding then child:Destroy() end end
            for _,child in ipairs(itemBar:GetChildren()) do if child~=itemLayout and child~=itemPadding then child:Destroy() end end
            for modeName,button in pairs(categoryButtons) do
                local active=modeName==XCConfig.skinGalleryMode
                button.BackgroundColor3=active and C.Lime:Lerp(C.Panel,0.72) or C.Control
                button.BorderColor3=active and C.Lime or C.Border
                button.TextColor3=active and C.White or C.Muted
            end
            local items=categoryItems()
            local itemName=currentItem()
            if not table.find(items,itemName) then itemName=items[1] or "Default";selectItem(itemName,false) end
            local itemWidthTotal=8
            for index,name in ipairs(items) do
                local width=math.clamp(#tostring(name)*7+20,68,132)
                local itemButton=Instance.new("TextButton",itemBar)
                itemButton.Name="Item_"..tostring(name);itemButton.LayoutOrder=index
                itemButton.Size=UDim2.fromOffset(width,UserInputService.TouchEnabled and 28 or 23)
                itemButton.BackgroundColor3=name==itemName and C.Lime:Lerp(C.Panel,0.72) or C.Control
                itemButton.BorderColor3=name==itemName and C.Lime or C.Border;itemButton.BorderSizePixel=1
                itemButton.Text=tostring(name);itemButton.TextColor3=name==itemName and C.White or C.Text
                itemButton.Font=Enum.Font.Code;itemButton.TextSize=9;itemButton.AutoButtonColor=false
                itemButton.Activated:Connect(function()
                    if name==currentItem() then return end
                    selectItem(name,true);refreshSkinGallery();scheduleConfigAutoSave()
                end)
                itemWidthTotal+=width+4
            end
            itemBar.CanvasSize=UDim2.fromOffset(itemWidthTotal,0)
            local choices
            if XCConfig.skinGalleryMode=="Gloves" then choices=getXCGloveSkinChoices(itemName)
            else choices=getXCSkinChoicesForWeapon(itemName) end
            local previewJobs={}
            heading.Text=string.format("%s  >  SKINS  (%d)",tostring(itemName):upper(),#choices)
            for index,skinName in ipairs(choices) do
                local card=Instance.new("TextButton",grid)
                card.Name="Skin_"..skinName;card.LayoutOrder=index;card.BackgroundColor3=C.Panel
                card.BorderColor3=C.Border;card.BorderSizePixel=1;card.Text="";card.AutoButtonColor=false;cards[skinName]=card
                local visual=Instance.new("ViewportFrame",card)
                visual.Name="Preview";visual.Position=UDim2.fromOffset(3,3);visual.Size=UDim2.new(1,-6,1,-25)
                visual.BackgroundColor3=C.Control;visual.BorderSizePixel=0;visual.Ambient=Color3.fromRGB(190,190,190)
                visual.LightColor=Color3.fromRGB(255,255,255);visual.LightDirection=Vector3.new(-1,-0.5,-1)
                local label=Instance.new("TextLabel",card)
                label.Position=UDim2.new(0,4,1,-21);label.Size=UDim2.new(1,-8,0,18);label.BackgroundTransparency=1
                label.Text=skinName;label.TextColor3=C.Text;label.Font=Enum.Font.Code;label.TextSize=8;label.TextTruncate=Enum.TextTruncate.AtEnd
                local selected=Instance.new("TextLabel",card)
                selected.Name="Selected";selected.Position=UDim2.fromOffset(5,4);selected.Size=UDim2.fromOffset(13,13)
                selected.BackgroundColor3=Color3.fromRGB(4,4,4);selected.BackgroundTransparency=0.2;selected.Text="✓"
                selected.Font=Enum.Font.Code;selected.TextSize=10;selected.Visible=false;selected.ZIndex=5
                local imageId=findPreviewImage(itemName,skinName)
                if imageId then
                    local image=Instance.new("ImageLabel",visual);image.Size=UDim2.fromScale(1,1);image.BackgroundTransparency=1
                    image.Image=imageId;image.ScaleType=Enum.ScaleType.Fit
                else
                    previewJobs[#previewJobs+1]=function()
                        if serial~=gallerySerial or not visual.Parent then return end
                        if not addModelPreview(visual,itemName,skinName) then
                            local fallback=Instance.new("TextLabel",visual);fallback.Size=UDim2.fromScale(1,1);fallback.BackgroundTransparency=1
                            fallback.Text=skinName=="Default" and "DEFAULT" or itemName;fallback.TextColor3=C.Muted
                            fallback.Font=Enum.Font.Code;fallback.TextSize=8;fallback.TextWrapped=true
                        end
                    end
                end
                card.Activated:Connect(function()
                    if XCConfig.skinGalleryMode=="Knife" then XCConfig.selectedSkin=skinName;refreshConfigControls("selectedSkin",skinName);applyXCKnifeChanger()
                    elseif XCConfig.skinGalleryMode=="Gloves" then XCConfig.selectedGloveSkin=skinName;XCConfig.gloveChangerEnabled=true;refreshConfigControls("selectedGloveSkin",skinName);applyXCGloves()
                    else XCConfig.skinEditorFinish=skinName;XCConfig.weaponSkinSelections[itemName]=skinName
                        XCConfig.weaponSkinWear[itemName]=XCConfig.skinWear;refreshConfigControls("skinEditorFinish",skinName);applyXCSelectedWeaponSkin() end
                    updateCardSelection(itemName);scheduleConfigAutoSave()
                end)
            end
            updateCardSelection(itemName)
            task.spawn(function()
                for _,job in ipairs(previewJobs) do
                    RunService.Heartbeat:Wait()
                    if serial~=gallerySerial then return end
                    job()
                end
            end)
        end
        task.defer(refreshSkinGallery)
        registerSearch(holder,"skin changer image gallery weapon knife glove previews")
        return holder
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
        elseif key == "skinChangerEnabled" then
            XCConfig.gloveChangerEnabled = value
            if value then
                hookBloxStrikeModules(true)
                applyXCKnifeChanger()
                applyXCSelectedWeaponSkin()
                applyXCGloves()
            else
                restoreXCKnifeModel()
                restoreXCSelectedWeaponSkin()
            end
        elseif key == "gloveChangerEnabled" and value then applyXCGloves()
        elseif key == "nightModeEnabled" then
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
        elseif key == "fullBrightEnabled" and not value and not XCConfig.nightModeEnabled then
            Lighting.Brightness = defaultLighting.Brightness
            Lighting.ClockTime = defaultLighting.ClockTime
            Lighting.GlobalShadows = defaultLighting.GlobalShadows
            Lighting.Ambient = defaultLighting.Ambient
            Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
            updateWorldChanger()
        elseif key == "removeFogEnabled" and not value then
            Lighting.FogStart = defaultLighting.FogStart or 0
            Lighting.FogEnd = defaultLighting.FogEnd
            Lighting.FogColor = defaultLighting.FogColor
            updateWorldChanger()
        elseif key == "thirdPersonEnabled" then setThirdPersonEnabled(value)
        elseif key == "antiAfkEnabled" then setAntiAfkEnabled(value)
        elseif key == "spectatorListEnabled" and value then buildSpectatorGui()
        elseif key == "animationsEnabled" then if value then playXCAnimation() else stopXCAnimation() end
        elseif key == "customHandsEnabled" then
            handsLastModel = nil
            handsLastPivot = nil
            if value then setupXCCustomHandsHook() end
        elseif key == "weaponChamsEnabled" then setWeaponVisuals()
        elseif key == "customScopeEnabled" then updateCustomScope()
        elseif key == "customFovEnabled" and not value then
            local cam = Workspace.CurrentCamera or camera
            if cam then cam.FieldOfView = 70 end
        elseif key == "weatherEnabled" then applyXCWeather(); updateWorldChanger()
        elseif key == "noSmokeEnabled" then applyXCSmokeState()
        elseif key == "worldSkyboxEnabled" or key == "worldSkyCelestial" or key == "worldPostFXEnabled"
            or key == "worldAtmosphereEnabled" or key == "worldBloomEnabled" then updateWorldChanger()
        elseif key == "freecamEnabled" then setXCCameraMode("Freecam", value)
        elseif key == "freelookEnabled" then setXCCameraMode("Freelook", value)
        elseif key == "streamerModeEnabled" then setXCStreamerMode(value)
        elseif key == "settingsCompactMode" then updateScale()
        end
        if value and (key == "antiAimEnabled" or key == "bunnyHopEnabled") then
            setupXCCharacterInputHook()
        end
    end
    local function toggle(parent, label, key)
        return addToggle(parent, label, key, function(v) specialToggle(key, v) end)
    end

    local advancedCategories = {"Combat","Visuals","Movement","World & Camera","Skins","Interface","Misc"}
    local function advancedCategoryForKey(key)
        local lower=tostring(key):lower()
        if lower:find("skin",1,true) or lower:find("knife",1,true) or lower:find("glove",1,true) then return "Skins" end
        if lower:find("menu",1,true) or lower:find("uiscale",1,true) or lower:find("settings",1,true)
            or lower:find("watermark",1,true) or lower:find("advanced",1,true) or lower:find("linkmenu",1,true) then return "Interface" end
        if lower:find("antiaim",1,true) or lower:find("bhop",1,true) or lower:find("bunny",1,true)
            or lower:find("slide",1,true) or lower:find("flight",1,true) or lower:find("walk",1,true)
            or lower:find("speed",1,true) or lower:find("thirdperson",1,true) then return "Movement" end
        if lower:find("world",1,true) or lower:find("night",1,true) or lower:find("weather",1,true)
            or lower:find("fog",1,true) or lower:find("smoke",1,true) or lower:find("flash",1,true)
            or lower:find("scope",1,true) or lower:find("fov",1,true) or lower:find("freecam",1,true)
            or lower:find("freelook",1,true) or lower:find("customhands",1,true) or lower:find("fullbright",1,true) then return "World & Camera" end
        if lower:find("aim",1,true) or lower:find("trigger",1,true) or lower:find("rage",1,true)
            or lower:find("recoil",1,true) or lower:find("spread",1,true) or lower:find("firerate",1,true)
            or lower:find("rcs",1,true) or lower:find("wallbang",1,true) or lower:find("prediction",1,true) then return "Combat" end
        if lower:find("esp",1,true) or lower:find("chams",1,true) or lower:find("box",1,true)
            or lower:find("tag",1,true) or lower:find("skeleton",1,true) or lower:find("tracer",1,true)
            or lower:find("grenade",1,true) or lower:find("sound",1,true) or lower:find("hit",1,true)
            or lower:find("bullet",1,true) or lower:find("cube",1,true) or lower:find("head",1,true) then return "Visuals" end
        return "Misc"
    end
    local function getAdvancedSettingKeys(category)
        local keys={}
        for key,value in pairs(XCConfig) do local t=type(value)
            if (t=="boolean" or t=="number" or t=="string") and key~="advancedCategory" and key~="advancedSettingKey"
                and advancedCategoryForKey(key)==category then keys[#keys+1]=key end
        end
        table.sort(keys,function(a,b)return a:lower()<b:lower() end)
        return #keys>0 and keys or {"menuKey"}
    end
    local function applyXCSettingRuntime(key,value)
        if XCConfig[key]==nil then return false end
        local previousType=type(XCConfig[key]); local lower=key:lower()
        if previousType=="number" then
            value=tonumber(value); if not value or value~=value or math.abs(value)>1000000 then return false end
            if (lower:find("color",1,true) or lower:find("accent",1,true) or lower:find("background",1,true)
                or lower:find("panel",1,true) or lower:find("text",1,true) or lower:find("visible",1,true)
                or lower:find("hidden",1,true) or lower:find("grenade",1,true)) and lower:match("[rgb]$") then
                value=math.clamp(math.floor(value+0.5),0,255)
            elseif lower:find("transparency",1,true) or lower:find("opacity",1,true) then value=math.clamp(value,0,1)
            elseif key=="uiScale" then value=math.clamp(value,0.65,1.25)
            elseif lower:find("hitchance",1,true) then value=math.clamp(value,0,100) end
        end
        XCConfig[key]=value; refreshConfigControls(key,value)
        if previousType=="boolean" then specialToggle(key,value==true) end
        if lower:find("menu",1,true) or key=="uiScale" or key=="linkMenuAndEspColor"
            or lower:find("espvisible",1,true) or lower:find("esphidden",1,true) or lower:find("grenade",1,true) then applyMenuTheme()
        elseif lower:find("world",1,true) or lower:find("night",1,true) or lower:find("fog",1,true) then updateWorldChanger();updateWorldPostFX()
        elseif lower:find("weather",1,true) then applyXCWeather();updateWorldChanger()
        elseif lower:find("scope",1,true) then updateCustomScope()
        elseif lower:find("weaponchams",1,true) then setWeaponVisuals()
        elseif lower:find("knife",1,true) or lower:find("skin",1,true) then applyXCKnifeChanger();applyXCSelectedWeaponSkin()
        elseif lower:find("glove",1,true) then applyXCGloves() end
        scheduleConfigAutoSave(); return true
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
        if applySearch then applySearch() end
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
        attachHelp(button, "tab_" .. info[1])
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

    local L, R = columns("Rage", "Aim assistance", "Combat mechanics")
    section(L, "Aimbot")
    toggle(L, "Tracking", "aimbotEnabled")
    addSlider(L, "Aim FOV", "aimFov", 10, 360, 1, "°")
    addSlider(L, "Aim speed", "aimbotSpeed", 1, 100, 1, "%")
    addSlider(L, "Smoothness", "aimbotSmoothness", 0.01, 1, 0.01, "")
    toggle(L, "Visible check", "visibleCheck")

    section(L, "Silent aim")
    toggle(L, "Silent aim", "silentAimEnabled")
    addSlider(L, "Silent FOV", "silentAimFov", 10, 360, 1, "px")
    addSlider(L, "Hit chance", "silentAimHitChance", 1, 100, 1, "%")
    toggle(L, "Team check", "silentAimTeamCheck")
    toggle(L, "Visible check", "silentAimVisibleCheck")
    toggle(L, "Aim at head", "silentAimAimHead")
    toggle(L, "Perfect silent", "pSilentEnabled")
    toggle(L, "Wallbang", "wallbangEnabled")

    section(L, "Triggerbot")
    toggle(L, "Triggerbot", "triggerbotEnabled")
    addSlider(L, "Trigger delay", "triggerbotDelay", 0.01, 0.5, 0.005, "s")
    addSlider(L, "Trigger FOV", "triggerbotFov", 10, 360, 1, "px")
    toggle(L, "Scoped only", "triggerbotScopedOnly")
    toggle(L, "Head only", "triggerbotHeadOnly")

    section(R, "Weapon")
    toggle(R, "Recoil control", "rcsEnabled")
    toggle(R, "No recoil", "noRecoilEnabled")
    toggle(R, "No spread", "noSpreadEnabled")
    toggle(R, "Fire rate", "fireRateEnabled")
    addSlider(R, "Fire interval", "fireRate", 0.01, 0.2, 0.01, "s")
    addSlider(R, "RCS strength", "rcsStrength", 10, 100, 1, "%")
    addSlider(R, "RCS pitch", "rcsPitchFactor", 0.1, 2, 0.1, "x")
    addSlider(R, "RCS yaw", "rcsYawFactor", 0.1, 2, 0.1, "x")
    section(R, "Ragebot")
    toggle(R, "Ragebot", "rageBotEnabled")
    addSlider(R, "Rage FOV", "rageFov", 30, 360, 1, "°")
    toggle(R, "Rage auto fire", "rageAutoFire")
    addChoice(R, "Target priority", "rageTargetMode", {"Distance", "Health", "FOV", "Priority"})

    task.wait()
    L, R = columns("AntiAim", "Anti-aim", "Movement")
    section(L, "Anti-aim")
    toggle(L, "Anti-aim", "antiAimEnabled")
    addChoice(L, "Anti-aim mode", "antiAimMode", {
        "Static", "Backwards", "Jitter", "Spin", "Random",
        "Gamesense Center Jitter", "Gamesense 3-Way", "Gamesense Sway",
        "NeverLose Adaptive", "NeverLose Defensive",
        "NixWare Sideways", "NixWare Spin Jitter",
        "Memesense Legit", "Memesense Low Delta"
    })
    addSlider(L, "Spin speed", "spinSpeed", 10, 150, 1, "")
    addSlider(L, "Base yaw", "antiAimYaw", -180, 180, 1, "°")
    addSlider(L, "Jitter range", "antiAimJitter", 0, 180, 1, "°")
    addSlider(L, "Switch interval", "antiAimInterval", 0.04, 0.5, 0.01, "s")
    section(L, "Third person")
    toggle(L, "Third person", "thirdPersonEnabled")
    addSlider(L, "Third person distance", "thirdPersonDistance", 5, 25, 1, "")
    addSlider(L, "Third person height", "thirdPersonHeight", -3, 6, 0.5, "")
    section(R, "Bunny hop")
    toggle(R, "Bhop engine", "bunnyHopEnabled")
    addChoice(R, "Bhop mode", "bhopMode", {"Hold", "Automatic"})
    toggle(R, "Moving only", "bhopMovingOnly")
    toggle(R, "Pause with menu", "bhopPauseWithMenu")
    addSlider(R, "Bhop power", "bhopJumpPower", 30, 100, 1, "")
    addSlider(R, "Bhop speed", "bhopSpeedBoost", 1, 3, 0.1, "x")
    addSlider(R, "Ground delay", "bhopGroundDelay", 0, 0.25, 0.01, "s")
    addSlider(R, "Acceleration", "bhopAcceleration", 2, 30, 1, "")
    toggle(R, "Air strafe", "bhopAirStrafe")
    section(R, "Movement")
    toggle(R, "Slide", "slideEnabled")
    toggle(R, "Flight", "flightEnabled")
    toggle(R, "Speed boost", "speedEnabled")
    toggle(R, "No fall damage", "noFallDamageEnabled")
    addSlider(R, "Slide boost", "slideSpeedBoost", 1.2, 3, 0.1, "x")
    addSlider(R, "Flight speed", "flightSpeed", 10, 150, 1, "")
    addSlider(R, "Walk multiplier", "walkMultiplier", 1, 5, 0.1, "x")

    task.wait()
    L, R = columns("Visuals", "Player ESP", "Indicators")
    section(L, "Chams")
    toggle(L, "Chams", "chamsEnabled")
    section(L, "Box ESP")
    toggle(L, "Box overlay", "boxEspEnabled")
    toggle(L, "Corner box", "cornerBoxEnabled")
    toggle(L, "Health bar", "healthBarEnabled")
    toggle(L, "Dark ESP outline", "espBoxOutline")
    addSlider(L, "ESP distance", "espMaxDist", 100, 5000, 50, "")
    addSlider(L, "Box stability", "espBoxSmoothing", 0, 0.9, 0.05, "")
    addSlider(L, "ESP scale", "espPerspectiveScale", 0.65, 1.5, 0.05, "x")
    addSlider(L, "Box width ratio", "espBoxAspect", 0.42, 0.68, 0.02, "x")
    section(L, "Weapon ESP")
    toggle(L, "Weapon image", "weaponEspEnabled")
    section(L, "Skeleton")
    toggle(L, "Skeleton ESP", "skeletonEspEnabled")
    toggle(L, "Distance fade", "skeletonDistanceFade")
    addSlider(L, "Skeleton thickness", "skeletonThickness", 1, 4, 0.5, "px")
    section(L, "Nametags")
    toggle(L, "Nametags", "nametagsEnabled")
    addSlider(L, "Text size", "espTextSize", 8, 20, 1, "")
    toggle(L, "Show distance", "espShowDistance")
    toggle(L, "Show health", "espShowHealth")
    toggle(L, "Show weapon", "tagShowWeapon")
    section(R, "ESP preview")
    addESPPreview(R)
    section(R, "ESP indicators")
    toggle(R, "Grenade ESP", "grenadeEspEnabled")
    toggle(R, "Trajectory prediction", "showGrenadePath")
    toggle(R, "Grenade danger zones", "grenadeDangerZonesEnabled")
    toggle(R, "Molotov radius", "showMolotovRadius")
    toggle(R, "Smoke radius", "showSmokeRadius")
    addSlider(R, "Danger opacity", "grenadeDangerOpacity", 0.1, 1, 0.05, "")
    toggle(R, "Sound position ESP", "soundPositionEspEnabled")
    addSlider(R, "Sound marker duration", "soundEspDuration", 0.4, 2.5, 0.05, "s")
    toggle(R, "Tracers", "tracersEnabled")
    toggle(R, "Head dot", "headDotEnabled")
    section(R, "Hit feedback")
    toggle(R, "Hitmarker", "hitmarkerEnabled")
    toggle(R, "Hit sound", "hitSoundEnabled")
    addChoice(R, "Hit sound preset", "hitSoundPreset", {"Skeet", "Neverlose", "Bell", "Bell2", "Bubble", "Rust", "Agro1", "Agro2", "Coins", "Schaater", "Pick"}, function()
        playXCHitSound(true)
    end)
    addSlider(R, "Hit sound volume", "hitSoundVolume", 0.1, 3, 0.1, "x")
    addButton(R, "TEST HIT SOUND", function() playXCHitSound(true) end)
    addSlider(R, "Hitmarker size", "hitmarkerSize", 5, 30, 1, "")
    addSlider(R, "Hitmarker duration", "hitmarkerDuration", 0.05, 1, 0.05, "s")
    section(R, "Jump circle")
    toggle(R, "Jump circle", "jumpCircleEnabled")
    addSlider(R, "Jump radius", "jumpCircleRadius", 1.5, 8, 0.5, "")
    addChoice(R, "Jump style", "jumpCircleStyle", {"GradientWave", "ChromaPulse", "StaticNeon"})

    task.wait()
    L, R = columns("World", "Environment", "Scope & camera")
    section(L, "lighting")
    toggle(L, "World changer", "nightModeEnabled")
    toggle(L, "Fullbright", "fullBrightEnabled")
    toggle(L, "Remove fog", "removeFogEnabled")
    toggle(L, "Anti flash", "antiFlashEnabled")
    toggle(L, "No smoke", "noSmokeEnabled")
    addChoice(L, "Night preset", "nightPreset", {"Midnight", "Nebula", "DeepBlood", "CyberPurple", "EmeraldNight", "PitchBlack"}, function(v) if XCConfig.nightModeEnabled then applyNightPreset(v) end end)
    addSlider(L, "Brightness", "nightBrightness", 0, 5, 0.1, "")
    addSlider(L, "Clock time", "nightClockTime", 0, 24, 0.5, "h")
    section(L, "sky & tone")
    toggle(L, "Custom skybox", "worldSkyboxEnabled")
    addChoice(L, "Skybox preset", "worldSkyboxPreset", {"Night", "Ocean Sunset", "My Summer Car", "Standard", "Minecraft", "Spongebob", "Deep Space", "Clouded Sky", "Retro", "City", "Purple Nebula", "Pink Sky"}, function() updateWorldChanger() end)
    addSlider(L, "Sky rotation", "worldSkyRotation", -180, 180, 1, "°", function() updateWorldChanger() end)
    addSlider(L, "Stars", "worldSkyStars", 0, 5000, 100, "", function() updateWorldChanger() end)
    toggle(L, "Sun & moon", "worldSkyCelestial")
    toggle(L, "Post FX", "worldPostFXEnabled")
    addChoice(L, "Tone preset", "worldTonePreset", {"Neutral", "XC Lime", "Cold", "Warm", "Purple", "Custom"}, function() updateWorldChanger() end)
    addColorPicker(L, "Custom world tint", "worldColor", function()
        XCConfig.worldTonePreset = "Custom"
        refreshConfigControls("worldTonePreset", "Custom")
        updateWorldPostFX()
    end)
    addSlider(L, "Exposure", "worldExposure", -3, 3, 0.1, "", function() updateWorldChanger() end)
    addSlider(L, "Saturation", "worldSaturation", -1, 1, 0.05, "", function() updateWorldChanger() end)
    addSlider(L, "Contrast", "worldContrast", -1, 1, 0.05, "", function() updateWorldChanger() end)
    section(L, "atmosphere & bloom")
    toggle(L, "Atmosphere", "worldAtmosphereEnabled")
    addSlider(L, "Atmosphere density", "worldAtmosphereDensity", 0, 1, 0.05, "", function() updateWorldChanger() end)
    addSlider(L, "Atmosphere haze", "worldAtmosphereHaze", 0, 10, 0.1, "", function() updateWorldChanger() end)
    addSlider(L, "Atmosphere glare", "worldAtmosphereGlare", 0, 10, 0.1, "", function() updateWorldChanger() end)
    toggle(L, "Bloom", "worldBloomEnabled")
    addSlider(L, "Bloom intensity", "worldBloomIntensity", 0, 3, 0.05, "", function() updateWorldChanger() end)
    addSlider(L, "Bloom size", "worldBloomSize", 0, 56, 1, "", function() updateWorldChanger() end)
    addSlider(L, "Bloom threshold", "worldBloomThreshold", 0, 5, 0.1, "", function() updateWorldChanger() end)
    section(L, "weather")
    toggle(L, "Weather effects", "weatherEnabled")
    addChoice(L, "Weather type", "weatherMode", {"Rain", "Snow", "Fog", "Ash", "Hell Fire"}, function() applyXCWeather(); updateWorldChanger() end)
    addSlider(L, "Weather intensity", "weatherIntensity", 1, 100, 1, "%", function() applyXCWeather() end)
    addSlider(L, "Wind", "weatherWind", -40, 40, 1, "", function() applyXCWeather() end)
    section(R, "scope")
    toggle(R, "Custom scope", "customScopeEnabled")
    toggle(R, "Custom FOV", "customFovEnabled")
    addSlider(R, "Camera FOV", "customFov", 70, 120, 1, "°")
    toggle(R, "Remove original scope", "scopeRemoveOriginal")
    toggle(R, "Scope crosshair", "scopeCrosshairEnabled")
    addChoice(R, "Crosshair style", "scopeCrosshairStyle", {"Cross", "T", "X", "Dot"})
    addColorPicker(R, "Crosshair color", "scopeCrosshairColor")
    addColorPicker(R, "Crosshair outline", "scopeCrosshairOutline")
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
    local S = createPanel(pages["Skins"], "Skin changer", 0, 1)
    section(S, "Weapons and skins")
    addSkinGallery(S)
    section(S, "Skin changer")
    toggle(S, "Skin changer", "skinChangerEnabled")
    addSlider(S, "Weapon wear", "skinWear", 0, 1, 0.01, "", function(value)
        local weaponName = XCConfig.skinEditorWeapon
        XCConfig.weaponSkinWear[weaponName] = value
        applyXCSelectedWeaponSkin()
    end)
    addSlider(S, "Knife wear", "knifeWear", 0, 1, 0.01, "", function() applyXCKnifeChanger() end)
    addButton(S, "OPEN HELD WEAPON", function()
        refreshXCSkinData()
        local ok, weapon = type(skinData.GetWeapon) == "function" and pcall(skinData.GetWeapon)
        local view = ok and weapon and weapon.Viewmodel
        local weaponName = view and (view.CameraModelWeapon or view.Weapon) or (weapon and weapon.Name)
        if weaponName and skinData.SkinSelections[weaponName] then
            XCConfig.skinGalleryMode = "Weapon"
            XCConfig.skinEditorWeapon = weaponName
            XCConfig.skinEditorFinish = XCConfig.weaponSkinSelections[weaponName] or "Default"
            XCConfig.skinWear = XCConfig.weaponSkinWear[weaponName] or 0
            refreshConfigControls("skinWear", XCConfig.skinWear)
            refreshSkinGallery()
        end
    end)
    addButton(S, "RESET CURRENT SKIN", function()
        if XCConfig.skinGalleryMode=="Knife" then
            XCConfig.selectedSkin="Default";applyXCKnifeChanger()
        elseif XCConfig.skinGalleryMode=="Gloves" then
            XCConfig.selectedGloveSkin="Default";applyXCGloves()
        else
            local weaponName=XCConfig.skinEditorWeapon
            XCConfig.weaponSkinSelections[weaponName]="Default";XCConfig.weaponSkinWear[weaponName]=0
            XCConfig.skinEditorFinish="Default";XCConfig.skinWear=0;refreshConfigControls("skinWear",0)
            restoreXCSelectedWeaponSkin(weaponName)
        end
        refreshSkinGallery()
    end)
    addButton(S, "APPLY ALL SKINS", function()
        applyXCSelectedWeaponSkin()
        applyXCKnifeChanger()
        applyXCGloves()
    end)
    addButton(S, "RESET ALL SKINS", function()
        table.clear(XCConfig.weaponSkinSelections)
        table.clear(XCConfig.weaponSkinWear)
        XCConfig.skinEditorFinish = "Default"
        XCConfig.skinWear = 0
        XCConfig.selectedKnifeType = "Default"
        XCConfig.selectedSkin = "Default"
        XCConfig.selectedGloveModel = "Default"
        XCConfig.selectedGloveSkin = "Default"
        restoreXCKnifeModel()
        restoreXCSelectedWeaponSkin()
        refreshConfigControls("skinWear", 0)
        refreshSkinGallery()
    end)
    task.wait()
    L, R = columns("Misc", "Utilities", "Viewmodel")
    section(L, "Session")
    toggle(L, "Anti AFK", "antiAfkEnabled")
    toggle(L, "Spectator list", "spectatorListEnabled")
    section(L, "Animations")
    toggle(L, "Animations", "animationsEnabled")
    addSlider(L, "Animation speed", "animationSpeed", 0.1, 3, 0.1, "x")
    toggle(L, "Animation loop", "animationLoop")
    addButton(L, "RESTART ANIMATION", playXCAnimation)
    section(L, "Privacy")
    toggle(L, "Streamer mode", "streamerModeEnabled")
    addChoice(L, "Streamer bind", "streamerKey", {"F6", "F7", "F8", "F9", "F10"})
    section(R, "Viewmodel")
    toggle(R, "Custom hands", "customHandsEnabled")
    addSlider(R, "Hands X", "customHandsX", -2, 2, 0.1, "")
    addSlider(R, "Hands Y", "customHandsY", -2, 2, 0.1, "")
    addSlider(R, "Hands Z", "customHandsZ", -2, 2, 0.1, "")
    addSlider(R, "Hands pitch", "customHandsPitch", -45, 45, 1, "°")
    addSlider(R, "Hands yaw", "customHandsYaw", -45, 45, 1, "°")
    addSlider(R, "Hands roll", "customHandsRoll", -90, 90, 1, "°")
    section(R, "Weapon visuals")
    toggle(R, "Weapon chams", "weaponChamsEnabled")
    addChoice(R, "Weapon material", "weaponChamsMode", {"Glass", "ForceField", "Metal", "Highlight", "Neon"})
    addColorPicker(R, "Weapon color", "weaponChamsColor", function() setWeaponVisuals() end)
    section(R, "Bullet effects")
    toggle(R, "Bullet trail", "bulletTrailEnabled")
    toggle(R, "Bullet flash", "bulletFlashEnabled")
    toggle(R, "Bullet impacts", "bulletImpactEnabled")
    toggle(R, "Rainbow trail", "bulletTracerRainbow")
    addColorPicker(R, "Trail color", "bulletTracerColor")
    addChoice(R, "Trail style", "bulletTracerStyle", {"Beam", "Lightning", "Comet", "Pulse", "Block", "Cylinder"})
    addSlider(R, "Trail duration", "bulletTracerDuration", 0.05, 3, 0.05, "s")
    addSlider(R, "Trail width", "bulletTracerWidth", 0.02, 0.5, 0.01, "")
    section(R, "Penetration checker")
    toggle(R, "Cube checker", "cubeCheckerEnabled")
    addSlider(R, "Cube distance", "cubeCheckerDistance", 1, 100, 1, "")

    task.wait()
    L, R = columns("Players", "Target filtering", "Overlay options")
    section(L, "Target rules")
    toggle(L, "Ignore teammates", "silentAimTeamCheck")
    toggle(L, "Visible targets only", "silentAimVisibleCheck")
    addChoice(L, "Priority player", "priorityPlayerName", currentPlayerChoices())
    section(L, "Chams rules")
    toggle(L, "Show teammates", "chamsShowTeammates")
    toggle(L, "Chams team check", "chamsTeamCheck")
    toggle(L, "Chams occlusion", "chamsOcclusion")
    addSlider(L, "Chams fill", "chamsFillTransparency", 0, 1, 0.05, "")
    addSlider(L, "Chams outline", "chamsOutlineTransparency", 0, 1, 0.05, "")
    section(R, "Nametag details")
    toggle(R, "Nametag distance", "espShowDistance")
    toggle(R, "Nametag health", "espShowHealth")
    toggle(R, "Nametag weapon", "tagShowWeapon")
    addSlider(R, "Tag transparency", "tagTransparency", 0, 0.9, 0.05, "")
    section(R, "ESP tuning")
    addSlider(R, "Box thickness", "boxThickness", 1, 3, 0.1, "")
    addSlider(R, "Grenade distance", "grenadeMaxDist", 200, 3000, 50, "")

    task.wait()
    L, R = columns("Configs", "Interface", "Config manager")
    local menuPresets={
        ["XC Lime"]={17,17,17,12,12,12,152,204,0,235,235,235},
        ["Midnight"]={10,13,20,8,10,17,65,142,255,232,238,248},
        ["Violet"]={16,12,21,12,9,17,166,92,255,239,232,248},
        ["Crimson"]={19,11,13,14,8,10,232,58,78,245,232,235},
        ["Ice"]={9,17,19,7,13,15,0,205,220,230,245,247},
    }
    local function applyMenuPreset(name)
        local values=menuPresets[name]; if not values then return end
        local keys={"menuBackgroundR","menuBackgroundG","menuBackgroundB","menuPanelR","menuPanelG","menuPanelB",
            "menuAccentR","menuAccentG","menuAccentB","menuTextR","menuTextG","menuTextB"}
        for index,key in ipairs(keys) do XCConfig[key]=values[index];refreshConfigControls(key,values[index]) end
        applyMenuTheme();scheduleConfigAutoSave()
    end
    section(L,"menu appearance")
    addChoice(L,"Theme preset","menuThemePreset",{"XC Lime","Midnight","Violet","Crimson","Ice"},applyMenuPreset)
    addSlider(L,"Interface scale","uiScale",0.65,1.25,0.05,"x",applyMenuTheme)
    addSlider(L,"Menu transparency","menuTransparency",0,0.45,0.05,"",applyMenuTheme)
    addToggle(L,"Link menu and ESP color","linkMenuAndEspColor",function() applyMenuTheme() end)
    addColorPicker(L,"Menu accent","menuAccent",applyMenuTheme)
    addColorPicker(L,"Menu background","menuBackground",applyMenuTheme)
    addColorPicker(L,"Panel surface","menuPanel",applyMenuTheme)
    addColorPicker(L,"Primary text","menuText",applyMenuTheme)
    section(L,"ESP palette")
    addColorPicker(L,"Visible enemy","espVisible",function() syncXCUserTheme();refreshESPPreview() end)
    addColorPicker(L,"Hidden enemy","espHidden",function() syncXCUserTheme();refreshESPPreview() end)
    addColorPicker(L,"Health high","espHealthHigh",function() syncXCUserTheme();refreshESPPreview() end)
    addColorPicker(L,"Health medium","espHealthMid",function() syncXCUserTheme();refreshESPPreview() end)
    addColorPicker(L,"Health low","espHealthLow",function() syncXCUserTheme();refreshESPPreview() end)
    section(L,"grenade palette")
    addColorPicker(L,"HE grenade","grenadeHE",function() syncXCUserTheme() end)
    addColorPicker(L,"Smoke","grenadeSmoke",function() syncXCUserTheme() end)
    addColorPicker(L,"Molotov / fire","grenadeMolotov",function() syncXCUserTheme() end)
    section(L, "menu & hud")
    toggle(L, "Notifications", "settingsShowNotifications")
    toggle(L, "Compact mode", "settingsCompactMode")
    toggle(L, "Autosave config", "settingsAutoSave")
    toggle(L, "Watermark", "watermarkEnabled")
    toggle(L, "Show FPS", "watermarkShowFPS")
    toggle(L, "Show ping", "watermarkShowPing")
    toggle(L, "Show name", "watermarkShowName")
    addChoice(L, "Menu key", "menuKey", {"RightShift", "LeftControl", "RightControl", "F6", "F7", "F8", "F9", "F10"})
    addNote(L, "STATUS: ON active  |  WAIT loading  |  FALL fallback  |  ERR failed")

    section(R,"advanced module editor")
    local refreshAdvancedEditor=function() end
    addChoice(R,"Module category","advancedCategory",advancedCategories,function(category)
        local keys=getAdvancedSettingKeys(category);XCConfig.advancedSettingKey=keys[1]
        refreshConfigControls("advancedSettingKey",keys[1]);task.defer(refreshAdvancedEditor)
    end)
    addChoice(R,"Setting","advancedSettingKey",function() return getAdvancedSettingKeys(XCConfig.advancedCategory) end,
        function() task.defer(refreshAdvancedEditor) end)
    local editorParent=activeSectionByParent[R] or R
    local editorType=Instance.new("TextLabel",editorParent)
    editorType.Size=UDim2.new(1,0,0,17);editorType.BackgroundTransparency=1;editorType.TextColor3=C.Muted
    editorType.Font=Enum.Font.Code;editorType.TextSize=9;editorType.TextXAlignment=Enum.TextXAlignment.Left
    local editorValue=Instance.new("TextBox",editorParent)
    editorValue.Size=UDim2.new(1,0,0,UserInputService.TouchEnabled and 30 or 24);editorValue.BackgroundColor3=C.Control
    editorValue.BorderColor3=C.Black;editorValue.BorderSizePixel=1;editorValue.ClearTextOnFocus=false
    editorValue.PlaceholderText="Value";editorValue.TextColor3=C.White;editorValue.PlaceholderColor3=C.Muted
    editorValue.Font=Enum.Font.Code;editorValue.TextSize=10
    local editorPadding=Instance.new("UIPadding",editorValue);editorPadding.PaddingLeft=UDim.new(0,7);editorPadding.PaddingRight=UDim.new(0,7)
    refreshAdvancedEditor=function()
        local key=XCConfig.advancedSettingKey;local value=XCConfig[key]
        editorType.Text=string.format("%s  •  %s",tostring(key),type(value):upper());editorValue.Text=tostring(value)
    end
    refreshers.advancedCategory=refreshers.advancedCategory or {};refreshers.advancedSettingKey=refreshers.advancedSettingKey or {}
    table.insert(refreshers.advancedCategory,refreshAdvancedEditor);table.insert(refreshers.advancedSettingKey,refreshAdvancedEditor)
    local function commitAdvancedEditor()
        local key=XCConfig.advancedSettingKey;local current=XCConfig[key];local valueType=type(current)
        local raw=editorValue.Text:match("^%s*(.-)%s*$");local parsed
        if valueType=="number" then parsed=tonumber(raw);if not parsed then editorType.Text=key.."  •  INVALID NUMBER";return end
        elseif valueType=="boolean" then local lower=raw:lower()
            if lower=="true" or lower=="1" or lower=="on" then parsed=true
            elseif lower=="false" or lower=="0" or lower=="off" then parsed=false
            else editorType.Text=key.."  •  USE TRUE / FALSE";return end
        else parsed=raw end
        if applyXCSettingRuntime(key,parsed) then refreshAdvancedEditor();XCNotify("Setting updated",key.." = "..tostring(XCConfig[key]),"success",1.4) end
    end
    editorValue.FocusLost:Connect(function(enterPressed) if enterPressed then commitAdvancedEditor() end end)
    addButton(R,"APPLY SELECTED VALUE",commitAdvancedEditor)
    addButton(R,"RESET SELECTED VALUE",function()
        local key=XCConfig.advancedSettingKey;local default=XCConfigDefaults[key]
        if default~=nil and type(default)~="table" then applyXCSettingRuntime(key,deepCopyConfigValue(default));refreshAdvancedEditor() end
    end)
    addNote(R,"Exact value editor: numbers, text and true/false. Palette colors are saved inside every profile.")
    task.defer(refreshAdvancedEditor)
    section(R, "profiles")

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
    nameBox.Parent = activeSectionByParent[R] or R
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.BackgroundTransparency = 1
    status.Text = "XCConfigs/Default.json"
    status.TextColor3 = C.Muted
    status.Font = Enum.Font.Code
    status.TextSize = 9
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = activeSectionByParent[R] or R
    local function configPath() return "XCConfigs/" .. safeName(nameBox.Text) .. ".json" end
    local autoSaveSerial = 0
    local function saveCurrentConfig(prefix)
        local ok = pcall(function()
            if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("XCConfigs") then makefolder("XCConfigs") end
            assert(type(writefile) == "function", "File API unavailable")
            local saveData = {}
            for key, value in pairs(XCConfig) do saveData[key] = value end
            if XCFeatureState.streamerSnapshot then
                for key, value in pairs(XCFeatureState.streamerSnapshot) do saveData[key] = value end
                saveData.streamerModeEnabled = false
            end
            writefile(configPath(), HttpService:JSONEncode(saveData))
        end)
        status.Text = ok and ((prefix or "saved") .. ": " .. safeName(nameBox.Text)) or "save unavailable"
        status.TextColor3 = ok and C.Lime or Color3.fromRGB(218, 82, 82)
        return ok
    end
    scheduleConfigAutoSave = function()
        if not XCConfig.settingsAutoSave then return end
        autoSaveSerial += 1
        local serial = autoSaveSerial
        task.delay(0.8, function()
            if serial == autoSaveSerial and XCConfig.settingsAutoSave and screenGui.Parent then
                saveCurrentConfig("autosaved")
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
        applyMenuTheme()
        refreshSkinGallery()
    end

    section(L, "quick actions")
    addButton(L, "PANIC: DISABLE ACTIVE MODULES", function()
        for _, key in ipairs({
            "aimbotEnabled", "silentAimEnabled", "triggerbotEnabled", "rageBotEnabled",
            "flightEnabled", "speedEnabled", "antiAimEnabled", "chamsEnabled",
            "grenadeEspEnabled", "freecamEnabled", "freelookEnabled", "thirdPersonEnabled"
        }) do
            if XCConfig[key] then
                XCConfig[key] = false
                if UI_Bind_Registry[key] then UI_Bind_Registry[key](false) end
                pcall(specialToggle, key, false)
            end
        end
        XCNotify("Panic", "Active combat and camera modules disabled", "warning", 2)
    end)
    addButton(L, "RESET CAMERA", function()
        for _, key in ipairs({"freecamEnabled", "freelookEnabled", "thirdPersonEnabled", "customFovEnabled"}) do
            XCConfig[key] = false
            if UI_Bind_Registry[key] then UI_Bind_Registry[key](false) end
        end
        stopXCCameraMode()
        setThirdPersonEnabled(false)
        if camera then camera.FieldOfView = 70 end
        XCNotify("Camera", "Camera state restored", "success", 1.5)
    end)
    addButton(R, "SAVE CONFIG", function()
        saveCurrentConfig("saved")
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
            applyXCSmokeState()
            if XCConfig.freecamEnabled then setXCCameraMode("Freecam", true)
            elseif XCConfig.freelookEnabled then setXCCameraMode("Freelook", true)
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
        status.Text = ok and ("loaded: " .. safeName(nameBox.Text)) or "load failed"
    end)
    addButton(R, "RESET DEFAULTS", function()
        setXCStreamerMode(false)
        for key, value in pairs(XCConfigDefaults) do XCConfig[key] = deepCopyConfigValue(value) end
        lazyFeatureRequests.fireRate = false
        lazyFeatureRequests.recoilSpread = false
        lazyFeatureRequests.silentFallback = false
        refreshAll(); updateMobileSlideVisibility(); refreshThirdPerson(); setWeaponVisuals(); updateCustomScope(); updateWorldPostFX()
        stopXCCameraMode(); destroyXCWeather(); restoreXCSmoke(); restoreLightingState()
        setAntiAfkEnabled(XCConfig.antiAfkEnabled)
        status.Text = "defaults restored"
    end)
    addButton(R, "DELETE CONFIG", function()
        local ok = pcall(function() assert(type(delfile) == "function"); delfile(configPath()) end)
        status.Text = ok and "config deleted" or "delete failed"
    end)

    applySearch = function()
        local query = searchBox.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
        local page = pages[currentPage]
        for _, entry in ipairs(searchableControls) do
            if page and entry.gui:IsDescendantOf(page) then
                entry.gui.Visible = query == "" or entry.label:find(query, 1, true) ~= nil
            else
                entry.gui.Visible = true
            end
        end
        for _, group in ipairs(sectionGroups) do
            if page and group.outer:IsDescendantOf(page) then
                local anyVisible = false
                for _, child in ipairs(group.body:GetChildren()) do
                    if child:IsA("GuiObject") and child.Visible then anyVisible = true break end
                end
                group.outer.Visible = query == "" or anyVisible
                if query ~= "" then
                    group.body.Visible = anyVisible
                else
                    group.body.Visible = not group.collapsed
                end
            else
                group.outer.Visible = true
                group.body.Visible = not group.collapsed
            end
        end
        clearSearch.TextColor3 = query ~= "" and C.Lime or C.Muted
    end
    table.insert(connections, searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch))
    task.spawn(function()
        while xcSessionActive() and screenGui.Parent do
            task.wait(0.75)
            for _, refreshStatus in ipairs(moduleStatusRefreshers) do pcall(refreshStatus) end
        end
    end)
    switchPage("Rage")

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
    openButtonThemeRefresh = function()
        local accent, textColor = C.Lime, C.White
        openBtn.BackgroundColor3 = C.Panel
        openBtn.BorderColor3 = C.Lime
        openBtn.Text = string.format(
            '<font color="rgb(%d,%d,%d)">X</font><font color="rgb(%d,%d,%d)">C</font>',
            math.floor(accent.R*255+0.5), math.floor(accent.G*255+0.5), math.floor(accent.B*255+0.5),
            math.floor(textColor.R*255+0.5), math.floor(textColor.G*255+0.5), math.floor(textColor.B*255+0.5)
        )
    end
    openButtonThemeRefresh()
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

function installThirdPersonProtection()
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

function reconnectThirdPersonCamera()
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
local xcFireRateReadonly = {}
local xcFireRateScanDone = false
local xcRecoilSpreadRetrying = false
local xcFireRateGetWeapon = nil
local xcFireRateWeaponRecords = setmetatable({}, {__mode = "k"})

local function resolveXCFireRateGetWeapon()
    if type(xcFireRateGetWeapon) == "function" then return true end
    pcall(function()
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        local scriptObject = controllers and controllers:FindFirstChild("InventoryController")
        local inventory = scriptObject and require(scriptObject)
        if type(inventory) == "table" and type(inventory.peekCurrentEquippedForMovement) == "function" then
            xcFireRateGetWeapon = inventory.peekCurrentEquippedForMovement
        end
    end)
    return type(xcFireRateGetWeapon) == "function"
end

local function restoreXCNativeFireRate(exceptWeapon)
    for weapon, record in pairs(xcFireRateWeaponRecords) do
        if weapon ~= exceptWeapon then
            pcall(function()
                local properties = record.Properties
                if type(properties) == "table" then
                    if type(setreadonly) == "function" then setreadonly(properties, false) end
                    rawset(properties, "FireRate", record.OriginalFireRate)
                    if type(setreadonly) == "function" and record.Readonly ~= nil then
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
    if not okWeapon or type(weapon) ~= "table" or weapon.IsDestroyed
        or type(weapon.Properties) ~= "table" then return false end

    restoreXCNativeFireRate(weapon)
    local record = xcFireRateWeaponRecords[weapon]
    if record and weapon.Properties ~= record.Properties then
        restoreXCNativeFireRate(nil)
        record = nil
    end
    if not record then
        local readonly = nil
        if type(isreadonly) == "function" then
            local okReadonly, value = pcall(isreadonly, weapon.Properties)
            if okReadonly then readonly = value == true end
        end
        record = {
            Properties = weapon.Properties,
            OriginalFireRate = rawget(weapon.Properties, "FireRate"),
            OriginalAutomatic = rawget(weapon.Properties, "Automatic"),
            Readonly = readonly,
        }
        xcFireRateWeaponRecords[weapon] = record
    end

    local requested = math.max(tonumber(XCConfig.fireRate) or 0.03, 0.01)
    local originalRate = tonumber(record.OriginalFireRate) or requested
    local stableRate = math.max(requested, 0.03, originalRate * 0.40)
    if UserInputService.TouchEnabled then
        -- Mobile uses the native hold-to-fire loop below. Leave every weapon
        -- property byte-for-byte unchanged so the game's touch HUD never
        -- rebuilds itself as a desktop control scheme.
        record.Rate = stableRate
        return true
    end
    if record.Rate == stableRate
        and rawget(record.Properties, "FireRate") == stableRate then
        return true
    end

    -- Change only cooldown. Do not change Automatic: Blox Strike rebuilds its
    -- control scheme when this property changes and can select the desktop HUD.
    local properties = record.Properties
    if type(setreadonly) == "function" then setreadonly(properties, false) end
    rawset(properties, "FireRate", stableRate)
    if type(setreadonly) == "function" and record.Readonly ~= nil then
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
                        if type(isreadonly) == "function" then
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
            if type(setreadonly) == "function" then setreadonly(obj, false) end
            local original = xcFireRateOriginal[obj]
            if type(original) == "number" then
                rawset(obj, "FireRate", original)
            end
            -- Restore the table exactly as it was. Forcing every weapon table
            -- readonly prevents the game from advancing its firing state.
            if type(setreadonly) == "function" and xcFireRateReadonly[obj] ~= nil then
                setreadonly(obj, xcFireRateReadonly[obj])
            end
        end)
    end
end

function applyXCFireRate()
    local requested = math.max(tonumber(XCConfig.fireRate) or 0.03, 0.01)
    for _, obj in ipairs(xcFireRateObjects) do
        pcall(function()
            if type(setreadonly) == "function" then setreadonly(obj, false) end
            local original = tonumber(xcFireRateOriginal[obj]) or requested
            -- Limit acceleration to a stable interval. Extremely small values
            -- flood ShootWeapon and are rejected after the first few rounds.
            local stableMinimum = math.max(0.03, original * 0.40)
            rawset(obj, "FireRate", math.max(requested, stableMinimum))
            if type(setreadonly) == "function" and xcFireRateReadonly[obj] ~= nil then
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
                    -- Undo the broad legacy getgc writer once the equipped
                    -- weapon can be modified through its native Properties.
                    if #xcFireRateObjects > 0 then restoreXCFireRates() end
                elseif not UserInputService.TouchEnabled then
                    if not xcFireRateScanDone then scanXCFireRateObjects() end
                    if #xcFireRateObjects == 0 then
                        -- The game can create weapon data after injection/respawn.
                        xcFireRateScanDone = false
                        scanXCFireRateObjects()
                    end
                    applyXCFireRate()
                else
                    -- Never use broad getgc property writes on mobile.
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

-- Native hold-to-fire for semi-automatic weapons. This replaces the old
-- Automatic property mutation without generating mouse input on phones.
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
        if now >= nextShot and type(weapon.shoot) == "function"
            and not weapon.IsShooting and not weapon.IsBurstShooting then
            nextShot = now + math.max(tonumber(record.Rate) or 0.08, 0.03)
            pcall(function() weapon:shoot() end)
        end
    end
end)

function installXCRecoilSpread()
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

-- Shotguns and some burst weapons do not obtain their direction from a Camera
-- ray. Adjust their already game-built payload only while Send() serializes it,
-- then restore every field so automatic fire never inherits a modified shot.
local function beginXCSilentPayloadTransactionV31(data)
    if xcNativeSilentHooked or not UserInputService.TouchEnabled or not isXCSilentAimRequested()
        or type(data) ~= "table" or type(data.Bullets) ~= "table" then return nil end

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
        if type(bullet) == "table" then
            local origin = bullet.Origin or bullet.StartingPoint or bullet.Position or fallbackOrigin
            if typeof(origin) == "CFrame" then origin = origin.Position end
            if typeof(origin) == "Vector3" then
                local delta = aimPos - origin
                if delta.Magnitude > 0.001 then
                    if typeof(bullet.Direction) == "Vector3" then
                        remember(bullet, "Direction", bullet.Direction)
                        local magnitude = bullet.Direction.Magnitude
                        bullet.Direction = delta.Unit * (magnitude > 0.001 and magnitude or 1)
                    end
                    if typeof(bullet.Ray) == "Ray" then
                        remember(bullet, "Ray", bullet.Ray)
                        bullet.Ray = Ray.new(bullet.Ray.Origin, delta.Unit * bullet.Ray.Direction.Magnitude)
                    end
                end
            end

            if type(bullet.Hits) == "table" then
                for _, hitData in pairs(bullet.Hits) do
                    if type(hitData) == "table" then
                        remember(hitData, "Instance", hitData.Instance)
                        remember(hitData, "Position", hitData.Position)
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
    -- InventoryController is the authoritative and safer interception point.
    -- Never install a second random/changing pass for the same shot.
    if bloxStrikeShootHooked and not UserInputService.TouchEnabled then return end
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
    if shootContainer and rawget(shootContainer, "__XCSilentSendHookV31") then
        xcSilentSendHooked = true
        return
    end

    local oldSend
    oldSend = hookfunction(sendFunc, function(...)
        local args = {...}
        local restorePayload = nil
        if UserInputService.TouchEnabled and type(args[1]) == "table" then
            local beginTransaction = sharedXCEnv and sharedXCEnv.XCBeginSilentPayloadTransactionV31
                or beginXCSilentPayloadTransactionV31
            local okTransaction, restore = pcall(beginTransaction, args[1])
            if okTransaction and type(restore) == "function" then restorePayload = restore end
        elseif type(args[1]) == "table" then
            local prepare = sharedXCEnv and sharedXCEnv.XCPrepareSilentSendPayloadV28
            local okPrepare, prepared = pcall(function()
                if type(prepare) == "function" then return prepare(args[1]) end
                return prepareXCSilentShotPayload(args[1], true)
            end)
            if okPrepare and type(prepared) == "table" then args[1] = prepared end
        end

        -- Suppress a persistent pre-v23 Send hook while it forwards our copied
        -- payload. This prevents double hit-chance rolls and in-place rewrites.
        local silentWasEnabled = XCConfig.silentAimEnabled
        XCConfig.silentAimEnabled = false
        local results = table.pack(pcall(oldSend, unpack(args)))
        XCConfig.silentAimEnabled = silentWasEnabled
        if restorePayload then pcall(restorePayload) end
        if not results[1] then error(results[2], 0) end
        return table.unpack(results, 2, results.n)
    end)

    if shootContainer then rawset(shootContainer, "__XCSilentSendHooked", true) end
    if shootContainer then rawset(shootContainer, "__XCSilentSendHookV23", true) end
    if shootContainer then rawset(shootContainer, "__XCSilentSendHookV28", true) end
    if shootContainer then rawset(shootContainer, "__XCSilentSendHookV31", true) end
    xcSilentSendHooked = true
end

-- ==========================================
-- ENGINE LAUNCH / XC VISUAL EXTENSION
-- ==========================================
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
    warn("[XC] UI startup failed: " .. tostring(XCFeatureState.uiBuildError))
    pcall(function()
        if targetGui:FindFirstChild("XCScreenGui") then targetGui.XCScreenGui:Destroy() end
        if targetGui:FindFirstChild("XCToggleGui") then targetGui.XCToggleGui:Destroy() end
        XCFeatureState.fallbackGui = Instance.new("ScreenGui")
        XCFeatureState.fallbackGui.Name = "XCFallbackGui"
        XCFeatureState.fallbackGui.ResetOnSpawn = false
        XCFeatureState.fallbackGui.IgnoreGuiInset = true
        XCFeatureState.fallbackGui.DisplayOrder = 999
        XCFeatureState.fallbackGui.Parent = targetGui
        XCFeatureState.fallbackCard = Instance.new("TextLabel")
        XCFeatureState.fallbackCard.Size = UDim2.fromOffset(340, 82)
        XCFeatureState.fallbackCard.Position = UDim2.new(0.5, -170, 0, 22)
        XCFeatureState.fallbackCard.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        XCFeatureState.fallbackCard.BorderColor3 = Color3.fromRGB(152, 204, 0)
        XCFeatureState.fallbackCard.BorderSizePixel = 1
        XCFeatureState.fallbackCard.TextColor3 = Color3.fromRGB(235, 235, 235)
        XCFeatureState.fallbackCard.Font = Enum.Font.Code
        XCFeatureState.fallbackCard.TextSize = 12
        XCFeatureState.fallbackCard.TextWrapped = true
        XCFeatureState.fallbackCard.Text = "XC STARTUP ERROR\n" .. tostring(XCFeatureState.uiBuildError):sub(1, 220)
        XCFeatureState.fallbackCard.Parent = XCFeatureState.fallbackGui
    end)
end

-- XC-style active navigation accent.
function XCApplyXCTabAccent(button, active)
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

function cfgFileAPI()
    return type(isfile)=="function" and type(readfile)=="function" and type(writefile)=="function"
end

function cfgSafeName(name)
    name=tostring(name or "Default"):gsub("[^%w%-%_ ]",""):sub(1,48)
    return name~="" and name or "Default"
end

function cfgPath(name)
    return XCConfigSystem.Folder.."/"..cfgSafeName(name)..".json"
end

function cfgJSONEncode(v)
    local ok,res=pcall(function() return game:GetService("HttpService"):JSONEncode(v) end)
    return ok and res or nil
end

function cfgJSONDecode(v)
    local ok,res=pcall(function() return game:GetService("HttpService"):JSONDecode(v) end)
    return ok and res or nil
end

function cfgEnsureFolder()
    if type(makefolder)=="function" and type(isfolder)=="function" then
        pcall(function() if not isfolder(XCConfigSystem.Folder) then makefolder(XCConfigSystem.Folder) end end)
    end
end

function cfgSerialize()
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
    if XCFeatureState.streamerSnapshot then
        for key,value in pairs(XCFeatureState.streamerSnapshot) do out[key]=value end
        out.streamerModeEnabled=false
    end
    return out
end

function cfgApply(data)
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
