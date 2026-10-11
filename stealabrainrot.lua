local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Workspace         = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS               = game:GetService("UserInputService")
local LUSOR             = Players.LocalPlayer


local LOCUS = getgenv()


local SAVE_FILE = "mrs_sab_config.txt"


local PRAEFINITA = {
    furtum_automaticum  = false,
    prae_teleporta      = true,
    furti_radius        = 300,
    furti_mora          = 0.25,
    emptio_automatica   = false,
    collocatio_automatica = false,
    sera_automatica     = false,
    celeritas           = false,
    vis_celeritatis     = 80,
    volatus             = false,
    vis_volatus         = 120,
    pervium             = false,
    visio               = false,
    contra_otium        = true,
    redi_in_ludum       = true,
}


local function confer_praecepta()

    local forma = {}

    for clavis, valor in pairs(PRAEFINITA) do
        forma[clavis] = valor
    end

    pcall(function()

        if isfile and isfile(SAVE_FILE) then

            local data = readfile(SAVE_FILE)

            if data and #data > 0 then

                for linea in data:gmatch("[^\n]+") do

                    local clavis, valor = linea:match("^([%w_]+)=(.+)$")

                    if clavis and valor then

                        local numerus = tonumber(valor)

                        if numerus then
                            forma[clavis] = numerus
                        elseif valor == "true" then
                            forma[clavis] = true
                        elseif valor == "false" then
                            forma[clavis] = false
                        else
                            forma[clavis] = valor
                        end

                    end

                end

            end

        end

    end)

    return forma

end


local function serva_praecepta()

    pcall(function()

        if writefile then

            local lineae = {}

            for clavis, valor in pairs(LOCUS.forma) do
                lineae[#lineae + 1] = clavis .. "=" .. tostring(valor)
            end

            writefile(SAVE_FILE, table.concat(lineae, "\n"))

        end

    end)

end


LOCUS.forma = confer_praecepta()


LOCUS.status = {
    nexus_pervii   = nil,
    nexus_volatus  = {},
    volans         = false,
    ultimum_furtum = 0,
    ultima_emptio  = 0,
    ultima_collocatio = 0,
    ultima_sera    = 0,
    natatorium_visio = {},
    conatus_redi   = 0,
    vivus          = true,
    nexus_antikick = {},
    infans_contra_otium = false,
}


local function pone_formam(clavis, valor)

    LOCUS.forma[clavis] = valor
    serva_praecepta()

end


local function radix_mea()

    local c = LUSOR.Character
    return c and c:FindFirstChild("HumanoidRootPart")

end


local function capias_humanoidem()

    local c = LUSOR.Character
    return c and c:FindFirstChildOfClass("Humanoid")

end


local function nuntia(titulus, corpus)

    pcall(function()

        Rayfield:Notify({Title = titulus, Content = corpus, Duration = 3})

    end)

end


local function frange_vinculum_antikick()

    local hook_mt = getrawmetatable(game)
    if not hook_mt then return end

    setreadonly(hook_mt, false)

    local vetus_nc = hook_mt.__namecall

    hook_mt.__namecall = newcclosure(function(self, ...)

        local methodus = getnamecallmethod()

        if methodus == "Kick" and self == LUSOR then
            return
        end

        return vetus_nc(self, ...)

    end)

    setreadonly(hook_mt, true)

end


local function frange_vinculum_index()

    local hook_mt = getrawmetatable(game)
    if not hook_mt then return end

    setreadonly(hook_mt, false)

    local vetus_idx = hook_mt.__index

    hook_mt.__index = newcclosure(function(self, clavis)

        if clavis == "Kick" and self == LUSOR then
            return function() return end
        end

        return vetus_idx(self, clavis)

    end)

    setreadonly(hook_mt, true)

end


local function sectator_gc()

    pcall(function()

        for _, v in pairs(getgc(true)) do

            if type(v) == "table" then

                local ok, idx = pcall(function()
                    return rawget(v, "indexInstance")
                end)

                if ok and type(idx) == "table" and idx[1] == "kick" then

                    v.tvk = {"kick", function()
                        return Workspace:WaitForChild("")
                    end}

                end

            end

        end

    end)

end


local function confirma_vincula_antikick()

    if LOCUS.status.nexus_antikick and #LOCUS.status.nexus_antikick > 0 then
        return
    end

    LOCUS.status.nexus_antikick = {}

    local nexus_heartbeat = RunService.Heartbeat:Connect(function()

        if not LOCUS.forma.redi_in_ludum then return end

        pcall(sectator_gc)

    end)

    table.insert(LOCUS.status.nexus_antikick, nexus_heartbeat)

    local nexus_character = LUSOR.CharacterAdded:Connect(function()

        task.wait(2)

        pcall(frange_vinculum_antikick)
        pcall(frange_vinculum_index)
        pcall(sectator_gc)

    end)

    table.insert(LOCUS.status.nexus_antikick, nexus_character)

end


local function redi_in_ludum()

    if not LOCUS.forma.redi_in_ludum then return end

    if tick() - LOCUS.status.conatus_redi < 10 then return end

    LOCUS.status.conatus_redi = tick()

    nuntia("Rejoin", "Attempting rejoin")

    task.wait(1)

    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LUSOR)
    end)

end


frange_vinculum_antikick()
frange_vinculum_index()
sectator_gc()
confirma_vincula_antikick()


pcall(function()

    local vetus_kick = LUSOR.Kick

    LUSOR.Kick = function(self, ...)

        if LOCUS.forma.redi_in_ludum then
            task.spawn(redi_in_ludum)
            task.wait(10)
        end

        return vetus_kick(self, ...)

    end

end)


local nomen_meae_basis = LUSOR.Name
local fundi_basis = {}
local tempus_fundorum = 0


local function renova_fundos()

    local nunc = tick()

    if nunc - tempus_fundorum < 3 then return end

    tempus_fundorum = nunc
    fundi_basis = {}

    pcall(function()

        for _, obiectum in ipairs(Workspace:GetChildren()) do

            if obiectum:IsA("Model") or obiectum:IsA("Folder") then

                local n = obiectum.Name:lower()

                if n:find("plot", 1, true) or n:find("base", 1, true) then
                    fundi_basis[#fundi_basis + 1] = obiectum
                end

            end

        end

    end)

end


local function mea_basis()

    for _, p in ipairs(fundi_basis) do

        if p.Name:lower():find(nomen_meae_basis:lower(), 1, true) then
            return p
        end

    end

    return nil

end


local function in_basi_mea(obiectum)

    if not obiectum or not obiectum.Parent then return false end

    local basis = mea_basis()

    if not basis then return false end

    local cur = obiectum

    for _ = 1, 8 do

        if cur == basis then return true end

        cur = cur.Parent

        if not cur then break end

    end

    return false

end


local myrmeciae_caput = {}
local tempus_myrmeciae = 0
local SPATIUM_SCANNI = 1


local function est_candidatus_myrmecia(obiectum)

    if not obiectum or not obiectum.Parent then return false end
    if not obiectum:IsA("Model") then return false end

    return obiectum:FindFirstChildOfClass("Humanoid") ~= nil
        or obiectum:FindFirstChildOfClass("ProximityPrompt") ~= nil

end


local function renova_myrmeciae()

    local nunc = tick()

    if nunc - tempus_myrmeciae < SPATIUM_SCANNI then return end

    tempus_myrmeciae = nunc

    local index, n = {}, 0

    pcall(function()

        local radices_scan = {}

        for _, b in ipairs(fundi_basis) do
            radices_scan[#radices_scan + 1] = b
        end

        if #radices_scan == 0 then
            radices_scan = {Workspace}
        end

        for _, radix in ipairs(radices_scan) do

            for _, obiectum in ipairs(radix:GetChildren()) do

                if est_candidatus_myrmecia(obiectum) then

                    local stimulum = obiectum:FindFirstChildOfClass("ProximityPrompt")

                    if not stimulum then
                        stimulum = obiectum:FindFirstChildWhichIsA("ProximityPrompt", true)
                    end

                    local prim = obiectum.PrimaryPart
                        or obiectum:FindFirstChild("HumanoidRootPart")
                        or obiectum:FindFirstChildWhichIsA("BasePart")

                    local positio = prim and prim.Position

                    if positio then

                        n = n + 1

                        index[n] = {
                            obiectum    = obiectum,
                            positio     = positio,
                            stimulum    = stimulum,
                            in_basi     = in_basi_mea(obiectum),
                            nomen       = obiectum.Name,
                        }

                        if n >= 60 then break end

                    end

                end

            end

            if n >= 60 then break end

        end

    end)

    myrmeciae_caput = index

end


local function elige_furtum()

    local radix = radix_mea()

    if not radix then return nil end

    local mea_positio = radix.Position
    local optimum, optima_distantia = nil, math.huge

    for _, e in ipairs(myrmeciae_caput) do

        if not e.in_basi and e.stimulum and e.stimulum.Enabled ~= false then

            local d = (e.positio - mea_positio).Magnitude

            if d <= LOCUS.forma.furti_radius and d < optima_distantia then
                optimum = e
                optima_distantia = d
            end

        end

    end

    return optimum

end


local function elige_emptionem()

    local radix = radix_mea()

    if not radix then return nil end

    local mea_positio = radix.Position
    local optimum, optima_distantia = nil, math.huge

    for _, e in ipairs(myrmeciae_caput) do

        if not e.in_basi then

            local d = (e.positio - mea_positio).Magnitude

            if d <= 40 and d < optima_distantia then
                optimum = e
                optima_distantia = d
            end

        end

    end

    return optimum

end


local function fac_furtum(scopus)

    if not scopus or not scopus.stimulum then return false end
    if not fireproximityprompt then return false end

    if LOCUS.forma.prae_teleporta then

        local radix = radix_mea()

        if radix then

            pcall(function()
                radix.CFrame = CFrame.new(scopus.positio + Vector3.new(0, 2.5, 0))
            end)

            RunService.RenderStepped:Wait()

        end

    end

    pcall(function() fireproximityprompt(scopus.stimulum) end)

    return true

end


local function cyclus_furti()

    if not LOCUS.forma.furtum_automaticum then return end

    local nunc = tick()

    if nunc - LOCUS.status.ultimum_furtum < LOCUS.forma.furti_mora then return end

    local scopus = elige_furtum()

    if not scopus then return end

    LOCUS.status.ultimum_furtum = nunc
    fac_furtum(scopus)

end


local function cyclus_emptionis()

    if not LOCUS.forma.emptio_automatica then return end

    local nunc = tick()

    if nunc - LOCUS.status.ultima_emptio < 0.3 then return end

    local scopus = elige_emptionem()

    if not scopus or not scopus.stimulum then return end

    LOCUS.status.ultima_emptio = nunc

    pcall(function() fireproximityprompt(scopus.stimulum) end)

end


local function cyclus_collocationis()

    if not LOCUS.forma.collocatio_automatica then return end

    local nunc = tick()

    if nunc - LOCUS.status.ultima_collocatio < 0.5 then return end

    LOCUS.status.ultima_collocatio = nunc

    local radix = radix_mea()
    if not radix then return end

    local basis = mea_basis()
    if not basis then return end

    local basis_positio

    pcall(function()
        basis_positio = basis:GetPivot().Position
    end)

    if not basis_positio then return end

    if (basis_positio - radix.Position).Magnitude > 30 then
        pcall(function()
            radix.CFrame = CFrame.new(basis_positio + Vector3.new(0, 5, 0))
        end)
    end

    pcall(function()

        for _, obiectum in ipairs(Workspace:GetChildren()) do

            if obiectum:IsA("BasePart") then

                local stimulum = obiectum:FindFirstChildOfClass("ProximityPrompt")

                if stimulum then

                    local actio = (stimulum.ActionText or ""):lower()

                    if actio:find("place", 1, true) or actio:find("deposit", 1, true)
                    or actio:find("put", 1, true) or actio:find("drop", 1, true) then

                        if (obiectum.Position - radix.Position).Magnitude < 25 then
                            fireproximityprompt(stimulum)
                        end

                    end

                end

            end

        end

    end)

end


local function cyclus_serae()

    if not LOCUS.forma.sera_automatica then return end

    local nunc = tick()

    if nunc - LOCUS.status.ultima_sera < 3 then return end

    LOCUS.status.ultima_sera = nunc

    local radix = radix_mea()
    if not radix then return end

    pcall(function()

        for _, obiectum in ipairs(Workspace:GetChildren()) do

            if obiectum:IsA("BasePart") then

                local stimulum = obiectum:FindFirstChildOfClass("ProximityPrompt")

                if stimulum then

                    local actio = (stimulum.ActionText or ""):lower()

                    if actio:find("lock", 1, true) or actio:find("secure", 1, true) then

                        if (obiectum.Position - radix.Position).Magnitude < 25 then
                            fireproximityprompt(stimulum)
                        end

                    end

                end

            end

        end

    end)

end


local function cyclus_celeritatis()

    if not LOCUS.forma.celeritas then return end

    local h = capias_humanoidem()

    if not h then return end
    if LOCUS.status.volans then return end

    h.WalkSpeed = LOCUS.forma.vis_celeritatis

end


local function incipe_pervium()

    if LOCUS.status.nexus_pervii then return end

    LOCUS.status.nexus_pervii = RunService.Stepped:Connect(function()

        if not LOCUS.forma.pervium then return end

        local c = LUSOR.Character

        if not c then return end

        for _, p in ipairs(c:GetDescendants()) do

            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end

        end

    end)

end


local function finge_nomen()

    local litterae = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local textus   = ""

    for _ = 1, 12 do

        local i = math.random(1, #litterae)
        textus  = textus .. litterae:sub(i, i)

    end

    return textus

end


local NOMEN_VELOCITATIS = "MRS_Vel_" .. finge_nomen()
local NOMEN_GYRI        = "MRS_Gyro_" .. finge_nomen()
local infinitas         = Vector3.new(9e9, 9e9, 9e9)
local nihil             = Vector3.new(0, 0, 0)


local function siste_volatum()

    LOCUS.status.volans = false

    local radix = radix_mea()

    if radix then

        local v = radix:FindFirstChild(NOMEN_VELOCITATIS)
        if v then v:Destroy() end

        local g = radix:FindFirstChild(NOMEN_GYRI)
        if g then g:Destroy() end

    end

    local h = capias_humanoidem()
    if h then h.PlatformStand = false end

    for _, nexus in ipairs(LOCUS.status.nexus_volatus) do

        pcall(function() nexus:Disconnect() end)

    end

    LOCUS.status.nexus_volatus = {}

end


local function incipe_volatum()

    siste_volatum()
    LOCUS.status.volans = true

    local radix = radix_mea()
    if not radix then return end

    local cm = nil

    pcall(function()
        cm = require(LUSOR.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    end)

    local bv          = Instance.new("BodyVelocity")

    bv.Name           = NOMEN_VELOCITATIS
    bv.Parent         = radix
    bv.MaxForce       = nihil
    bv.Velocity       = nihil

    local bg          = Instance.new("BodyGyro")

    bg.Name           = NOMEN_GYRI
    bg.Parent         = radix
    bg.MaxTorque      = infinitas
    bg.P              = 1000
    bg.D              = 50

    local nexus_cyclicus = RunService.RenderStepped:Connect(function()

        if not LOCUS.status.volans then return end

        local r = radix_mea()
        local cam = Workspace.CurrentCamera

        if not r or not cam then return end

        local h  = capias_humanoidem()
        local vh = r:FindFirstChild(NOMEN_VELOCITATIS)
        local gh = r:FindFirstChild(NOMEN_GYRI)

        if not vh or not gh or not h then return end

        vh.MaxForce     = infinitas
        gh.MaxTorque    = infinitas
        h.PlatformStand = true

        gh.CFrame   = cam.CFrame
        vh.Velocity = nihil

        local celeritas = LOCUS.forma.vis_volatus or 120
        local directio  = cm and cm:GetMoveVector() or UIS:GetMoveVector()

        if directio.X > 0 then
            vh.Velocity = vh.Velocity + cam.CFrame.RightVector * (directio.X * celeritas)
        end

        if directio.X < 0 then
            vh.Velocity = vh.Velocity + cam.CFrame.RightVector * (directio.X * celeritas)
        end

        if directio.Z > 0 then
            vh.Velocity = vh.Velocity - cam.CFrame.LookVector * (directio.Z * celeritas)
        end

        if directio.Z < 0 then
            vh.Velocity = vh.Velocity - cam.CFrame.LookVector * (directio.Z * celeritas)
        end

        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            vh.Velocity = vh.Velocity + Vector3.new(0, celeritas, 0)
        end

    end)

    table.insert(LOCUS.status.nexus_volatus, nexus_cyclicus)

end


local ESPScreen          = Instance.new("ScreenGui")

ESPScreen.Name           = "MRS_SAB_ESP"
ESPScreen.ResetOnSpawn   = false
ESPScreen.IgnoreGuiInset = true
ESPScreen.DisplayOrder   = 998
ESPScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ESPScreen.Parent = game:GetService("CoreGui") end)

if not ESPScreen.Parent then
    ESPScreen.Parent = LUSOR:WaitForChild("PlayerGui")
end


local MAX_VISIO = 40


local function finge_visum()

    local box          = Instance.new("Frame")

    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible         = false
    box.Active          = false
    box.ZIndex          = 2
    box.Parent          = ESPScreen

    local function angulus(pos, magnitudo)

        local f               = Instance.new("Frame")

        f.BackgroundColor3    = Color3.fromRGB(255, 60, 60)
        f.BorderSizePixel     = 0
        f.Position            = pos
        f.Size                = magnitudo
        f.ZIndex              = 3
        f.Active              = false
        f.Parent              = box

        return f

    end

    local TH = 2
    local o  = {box = box}

    o.c1 = angulus(UDim2.new(0, 0, 0, 0),       UDim2.new(0, 10, 0, TH))
    o.c2 = angulus(UDim2.new(0, 0, 0, 0),       UDim2.new(0, TH, 0, 10))
    o.c3 = angulus(UDim2.new(1, -10, 0, 0),     UDim2.new(0, 10, 0, TH))
    o.c4 = angulus(UDim2.new(1, -TH, 0, 0),     UDim2.new(0, TH, 0, 10))
    o.c5 = angulus(UDim2.new(0, 0, 1, -TH),     UDim2.new(0, 10, 0, TH))
    o.c6 = angulus(UDim2.new(0, 0, 1, -10),     UDim2.new(0, TH, 0, 10))
    o.c7 = angulus(UDim2.new(1, -10, 1, -TH),   UDim2.new(0, 10, 0, TH))
    o.c8 = angulus(UDim2.new(1, -TH, 1, -10),   UDim2.new(0, TH, 0, 10))

    o.anguli = {o.c1, o.c2, o.c3, o.c4, o.c5, o.c6, o.c7, o.c8}

    local nomen                  = Instance.new("TextLabel")

    nomen.BackgroundTransparency = 1
    nomen.TextColor3             = Color3.fromRGB(255, 255, 255)
    nomen.TextStrokeTransparency = 0
    nomen.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    nomen.Font                   = Enum.Font.Code
    nomen.TextSize               = 12
    nomen.TextXAlignment         = Enum.TextXAlignment.Center
    nomen.Visible                = false
    nomen.ZIndex                 = 4
    nomen.Parent                 = ESPScreen

    o.nomen = nomen

    return o

end


task.defer(function()

    for i = 1, MAX_VISIO do
        LOCUS.status.natatorium_visio[i] = finge_visum()
    end

end)


local function cyclus_visionis()

    local visio = LOCUS.status.natatorium_visio

    if not LOCUS.forma.visio then

        for i = 1, #visio do
            visio[i].box.Visible  = false
            visio[i].nomen.Visible = false
        end

        return

    end

    local cam = Workspace.CurrentCamera
    if not cam then return end

    local mea_radix = radix_mea()

    local index = 0

    for _, e in ipairs(myrmeciae_caput) do

        if index >= MAX_VISIO then break end

        local obiectum = e.obiectum

        if obiectum and obiectum.Parent then

            local sp, in_visu = cam:WorldToViewportPoint(e.positio)

            if in_visu then

                index = index + 1
                local o = visio[index]

                if o then

                    local d = mea_radix and (e.positio - mea_radix.Position).Magnitude or 0
                    local altitudo = math.clamp(2500 / math.max(d, 1), 20, 150)
                    local latitudo = altitudo * 0.6
                    local laevus   = sp.X - latitudo / 2
                    local summus   = sp.Y - altitudo / 2

                    o.box.Position = UDim2.new(0, laevus, 0, summus)
                    o.box.Size     = UDim2.new(0, latitudo, 0, altitudo)
                    o.box.Visible  = true

                    local color = e.in_basi
                        and Color3.fromRGB(0, 200, 255)
                        or  Color3.fromRGB(255, 60, 60)

                    for i = 1, 8 do
                        o.anguli[i].BackgroundColor3 = color
                    end

                    o.nomen.Visible  = true
                    o.nomen.Position = UDim2.new(0, laevus - 40, 0, summus - 16)
                    o.nomen.Size     = UDim2.new(0, latitudo + 80, 0, 14)
                    o.nomen.Text     = e.nomen .. " [" .. math.floor(d) .. "m]"

                end

            end

        end

    end

    for i = index + 1, #visio do
        visio[i].box.Visible   = false
        visio[i].nomen.Visible = false
    end

end


local function incipe_contra_otium()

    if LOCUS.status.infans_contra_otium then return end

    LOCUS.status.infans_contra_otium = true

    task.spawn(function()

        while true do

            task.wait(20)

            if LOCUS.forma.contra_otium then

                pcall(function()

                    local vu = game:GetService("VirtualUser")
                    vu:CaptureController()
                    vu:ClickButton1(Vector2.new(0, 0))

                end)

            end

        end

    end)

end


incipe_contra_otium()


LUSOR.CharacterAdded:Connect(function()

    task.wait(1)

    LOCUS.status.vivus = true

    if LOCUS.forma.pervium then

        pcall(function()

            local c = LUSOR.Character

            if c then

                for _, p in ipairs(c:GetDescendants()) do

                    if p:IsA("BasePart") then p.CanCollide = false end

                end

            end

        end)

    end

    if LOCUS.forma.volatus then

        task.wait(0.5)
        incipe_volatum()

    end

    if LOCUS.forma.celeritas then

        local h = capias_humanoidem()

        if h then h.WalkSpeed = LOCUS.forma.vis_celeritatis end

    end

    task.wait(2)

    pcall(frange_vinculum_antikick)
    pcall(frange_vinculum_index)
    pcall(sectator_gc)
    pcall(confirma_vincula_antikick)

    nuntia("Respawned", "features re-applied")

end)


local FRAME = 0


RunService.Heartbeat:Connect(function()

    FRAME = FRAME + 1

    if FRAME % 20 == 0 then pcall(renova_fundos) end
    if FRAME % 30 == 0 then pcall(renova_myrmeciae) end
    if FRAME % 6 == 0 then pcall(cyclus_furti) end
    if FRAME % 8 == 0 then pcall(cyclus_emptionis) end
    if FRAME % 15 == 0 then pcall(cyclus_collocationis) end
    if FRAME % 30 == 0 then pcall(cyclus_serae) end
    if FRAME % 10 == 0 then pcall(cyclus_celeritatis) end
    if FRAME % 6 == 0 then pcall(cyclus_visionis) end

end)


task.spawn(function()

    while true do

        task.wait(60)

        if LOCUS.forma.redi_in_ludum then
            pcall(sectator_gc)
            pcall(confirma_vincula_antikick)
        end

    end

end)


incipe_pervium()


local Fenestra = Rayfield:CreateWindow({
    Name             = "MRS Hub · Steal a Brainrot",
    LoadingTitle     = "Loading MRS Hub",
    LoadingSubtitle  = "persistent · by t.me/mrrobloxscripts",
    ConfigurationSaving = {
        Enabled    = true,
        FolderName = "MRS_SAB",
        FileName   = "config",
    },
    KeySystem = false,
})


local Tabula_Principalis = Fenestra:CreateTab("Main", 4483362458)
local Tabula_Visio       = Fenestra:CreateTab("Visual", 4483362458)
local Tabula_Varia       = Fenestra:CreateTab("Misc", 4483362458)


Tabula_Principalis:CreateSection("Auto Steal")


Tabula_Principalis:CreateToggle({
    Name         = "Auto Steal",
    CurrentValue = LOCUS.forma.furtum_automaticum,
    Flag         = "AutoSteal",
    Callback     = function(valor)
        pone_formam("furtum_automaticum", valor)
        nuntia("Auto Steal", valor and "ON" or "OFF")
    end,
})


Tabula_Principalis:CreateToggle({
    Name         = "Teleport Before Steal",
    CurrentValue = LOCUS.forma.prae_teleporta,
    Flag         = "TeleportFirst",
    Callback     = function(valor) pone_formam("prae_teleporta", valor) end,
})


Tabula_Principalis:CreateSlider({
    Name         = "Steal Range",
    Range        = {30, 500},
    Increment    = 10,
    Suffix       = "studs",
    CurrentValue = LOCUS.forma.furti_radius,
    Flag         = "StealRange",
    Callback     = function(valor) pone_formam("furti_radius", valor) end,
})


Tabula_Principalis:CreateSlider({
    Name         = "Steal Delay",
    Range        = {50, 1000},
    Increment    = 25,
    Suffix       = "ms",
    CurrentValue = math.floor(LOCUS.forma.furti_mora * 1000),
    Flag         = "StealDelay",
    Callback     = function(valor) pone_formam("furti_mora", valor / 1000) end,
})


Tabula_Principalis:CreateSection("Auto Buy / Place")


Tabula_Principalis:CreateToggle({
    Name         = "Auto Buy (Conveyor)",
    CurrentValue = LOCUS.forma.emptio_automatica,
    Flag         = "AutoBuy",
    Callback     = function(valor)
        pone_formam("emptio_automatica", valor)
        nuntia("Auto Buy", valor and "ON" or "OFF")
    end,
})


Tabula_Principalis:CreateToggle({
    Name         = "Auto Place",
    CurrentValue = LOCUS.forma.collocatio_automatica,
    Flag         = "AutoPlace",
    Callback     = function(valor)
        pone_formam("collocatio_automatica", valor)
        nuntia("Auto Place", valor and "ON" or "OFF")
    end,
})


Tabula_Principalis:CreateToggle({
    Name         = "Auto Lock Base",
    CurrentValue = LOCUS.forma.sera_automatica,
    Flag         = "AutoLock",
    Callback     = function(valor)
        pone_formam("sera_automatica", valor)
        nuntia("Auto Lock", valor and "ON" or "OFF")
    end,
})


Tabula_Visio:CreateSection("ESP")


Tabula_Visio:CreateToggle({
    Name         = "Brainrot ESP",
    CurrentValue = LOCUS.forma.visio,
    Flag         = "ESP",
    Callback     = function(valor)
        pone_formam("visio", valor)
        nuntia("ESP", valor and "ON" or "OFF")
    end,
})


Tabula_Varia:CreateSection("Movement")


Tabula_Varia:CreateToggle({
    Name         = "Speed",
    CurrentValue = LOCUS.forma.celeritas,
    Flag         = "Speed",
    Callback     = function(valor)
        pone_formam("celeritas", valor)
        if not valor then
            local h = capias_humanoidem()
            if h then h.WalkSpeed = 16 end
        end
        nuntia("Speed", valor and "ON" or "OFF")
    end,
})


Tabula_Varia:CreateSlider({
    Name         = "Speed Value",
    Range        = {16, 300},
    Increment    = 1,
    Suffix       = "ws",
    CurrentValue = LOCUS.forma.vis_celeritatis,
    Flag         = "SpeedVal",
    Callback     = function(valor) pone_formam("vis_celeritatis", valor) end,
})


Tabula_Varia:CreateToggle({
    Name         = "Fly",
    CurrentValue = LOCUS.forma.volatus,
    Flag         = "Fly",
    Callback     = function(valor)
        pone_formam("volatus", valor)
        if valor then incipe_volatum() else siste_volatum() end
        nuntia("Fly", valor and "ON" or "OFF")
    end,
})


Tabula_Varia:CreateSlider({
    Name         = "Fly Speed",
    Range        = {20, 500},
    Increment    = 5,
    Suffix       = "fs",
    CurrentValue = LOCUS.forma.vis_volatus,
    Flag         = "FlySpeed",
    Callback     = function(valor) pone_formam("vis_volatus", valor) end,
})


Tabula_Varia:CreateToggle({
    Name         = "Noclip",
    CurrentValue = LOCUS.forma.pervium,
    Flag         = "Noclip",
    Callback     = function(valor)
        pone_formam("pervium", valor)
        nuntia("Noclip", valor and "ON" or "OFF")
    end,
})


Tabula_Varia:CreateSection("Persistence")


Tabula_Varia:CreateToggle({
    Name         = "Auto Rejoin on Kick",
    CurrentValue = LOCUS.forma.redi_in_ludum,
    Flag         = "AutoRejoin",
    Callback     = function(valor)
        pone_formam("redi_in_ludum", valor)
        nuntia("Auto Rejoin", valor and "ON" or "OFF")
    end,
})


Tabula_Varia:CreateToggle({
    Name         = "Anti AFK",
    CurrentValue = LOCUS.forma.contra_otium,
    Flag         = "AntiAfk",
    Callback     = function(valor)
        pone_formam("contra_otium", valor)
        nuntia("Anti AFK", valor and "ON" or "OFF")
    end,
})


Tabula_Varia:CreateButton({
    Name     = "Save Config Now",
    Callback = function()
        serva_praecepta()
        nuntia("Config", "saved")
    end,
})


Tabula_Varia:CreateButton({
    Name     = "Reset Config",
    Callback = function()
        for clavis, valor in pairs(PRAEFINITA) do
            LOCUS.forma[clavis] = valor
        end
        serva_praecepta()
        nuntia("Config", "reset — re-execute to apply")
    end,
})


Tabula_Varia:CreateButton({
    Name     = "Force Refresh Scan",
    Callback = function()
        tempus_fundorum  = 0
        tempus_myrmeciae = 0
        renova_fundos()
        renova_myrmeciae()
        nuntia("Scan", #myrmeciae_caput .. " brainrots found")
    end,
})


Tabula_Varia:CreateSection("Info")


Tabula_Varia:CreateParagraph({
    Title   = "MRS Hub",
    Content = "Steal a Brainrot · persistent\nChannel: t.me/mrrobloxscripts",
})


task.defer(function()

    task.wait(2)

    if LOCUS.forma.volatus then pcall(incipe_volatum) end

    if LOCUS.forma.celeritas then

        local h = capias_humanoidem()

        if h then h.WalkSpeed = LOCUS.forma.vis_celeritatis end

    end

end)


nuntia("MRS Hub", "Loaded · persistent")

warn("[MRS] Steal a Brainrot loaded · persistent  |  t.me/mrrobloxscripts")