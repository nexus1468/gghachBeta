local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "GGHack" .. Fluent.Version,
    SubTitle = "by nexus",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Visual = Window:AddTab({ Title = "Visual", Icon = "" }),
        combat = Window:AddTab({ Title = "Combat", Icon = "" }),
    others = Window:AddTab({ Title = "Others", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })

}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent", 
        Duration = 5 
    })



    Tabs.Visual:AddButton({
        Title = "BOX ESP",
        Description = "Player box ESP",
        Callback = function()
           -- settings
local settings = {
   defaultcolor = Color3.fromRGB(255,0,0),
   teamcheck = false,
   teamcolor = true
};

-- services
local runService = game:GetService("RunService");
local players = game:GetService("Players");

-- variables
local localPlayer = players.LocalPlayer;
local camera = workspace.CurrentCamera;

-- functions
local newVector2, newColor3, newDrawing = Vector2.new, Color3.new, Drawing.new;
local tan, rad = math.tan, math.rad;
local round = function(...) local a = {}; for i,v in next, table.pack(...) do a[i] = math.round(v); end return unpack(a); end;
local wtvp = function(...) local a, b = camera.WorldToViewportPoint(camera, ...) return newVector2(a.X, a.Y), b, a.Z end;

local espCache = {};
local function createEsp(player)
   local drawings = {};
   
   drawings.box = newDrawing("Square");
   drawings.box.Thickness = 1;
   drawings.box.Filled = false;
   drawings.box.Color = settings.defaultcolor;
   drawings.box.Visible = false;
   drawings.box.ZIndex = 2;

   drawings.boxoutline = newDrawing("Square");
   drawings.boxoutline.Thickness = 3;
   drawings.boxoutline.Filled = false;
   drawings.boxoutline.Color = newColor3();
   drawings.boxoutline.Visible = false;
   drawings.boxoutline.ZIndex = 1;

   espCache[player] = drawings;
end

local function removeEsp(player)
   if rawget(espCache, player) then
       for _, drawing in next, espCache[player] do
           drawing:Remove();
       end
       espCache[player] = nil;
   end
end

local function updateEsp(player, esp)
   local character = player and player.Character;
   if character then
       local cframe = character:GetModelCFrame();
       local position, visible, depth = wtvp(cframe.Position);
       esp.box.Visible = visible;
       esp.boxoutline.Visible = visible;

       if cframe and visible then
           local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000;
           local width, height = round(4 * scaleFactor, 5 * scaleFactor);
           local x, y = round(position.X, position.Y);

           esp.box.Size = newVector2(width, height);
           esp.box.Position = newVector2(round(x - width / 2, y - height / 2));
           esp.box.Color = settings.teamcolor and player.TeamColor.Color or settings.defaultcolor;

           esp.boxoutline.Size = esp.box.Size;
           esp.boxoutline.Position = esp.box.Position;
       end
   else
       esp.box.Visible = false;
       esp.boxoutline.Visible = false;
   end
end

-- main
for _, player in next, players:GetPlayers() do
   if player ~= localPlayer then
       createEsp(player);
   end
end

players.PlayerAdded:Connect(function(player)
   createEsp(player);
end);

players.PlayerRemoving:Connect(function(player)
   removeEsp(player);
end)

runService:BindToRenderStep("esp", Enum.RenderPriority.Camera.Value, function()
   for player, drawings in next, espCache do
       if settings.teamcheck and player.Team == localPlayer.Team then
           continue;
       end

       if drawings and player ~= localPlayer then
           updateEsp(player, drawings);
       end
   end
end)           
        end
    })

    Tabs.Visual:AddButton({
        Title = "Name Esp",
        Description = "Player name ESP",
        Callback = function()
            local c = workspace.CurrentCamera
local ps = game:GetService("Players")
local lp = ps.LocalPlayer
local rs = game:GetService("RunService")

local function esp(p,cr)
	local h = cr:WaitForChild("Humanoid")
	local hrp = cr:WaitForChild("Head")

	local text = Drawing.new("Text")
	text.Visible = false
	text.Center = true
	text.Outline = false 
	text.Font = 3
	text.Size = 16.16
	text.Color = Color3.new(170,170,170)

	local conection
	local conection2
	local conection3

	local function dc()
		text.Visible = false
		text:Remove()
		if conection then
			conection:Disconnect()
			conection = nil 
		end
		if conection2 then
			conection2:Disconnect()
			conection2 = nil 
		end
		if conection3 then
			conection3:Disconnect()
			conection3 = nil 
		end
	end

	conection2 = cr.AncestryChanged:Connect(function(_,parent)
		if not parent then
			dc()
		end
	end)

	conection3 = h.HealthChanged:Connect(function(v)
		if (v<=0) or (h:GetState() == Enum.HumanoidStateType.Dead) then
			dc()
		end
	end)

	conection = rs.RenderStepped:Connect(function()
		local hrp_pos,hrp_onscreen = c:WorldToViewportPoint(hrp.Position)
		if hrp_onscreen then
			text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y - 27)
			text.Text = "[ "..p.Name.." ]"
			text.Visible = true
		else
			text.Visible = false
		end
	end)
end

local function p_added(p)
	if p.Character then
		esp(p,p.Character)
	end
	p.CharacterAdded:Connect(function(cr)
		esp(p,cr)
	end)
end

for i,p in next, ps:GetPlayers() do 
	if p ~= lp then
		p_added(p)
	end
end

ps.PlayerAdded:Connect(p_added)
        end
    })

        Tabs.Visual:AddButton({
        Title = "Skeleton Esp",
        Description = "Player Skeleton ESP",
        Callback = function()
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()


local Skeletons = {}
for _, Player in next, game.Players:GetChildren() do
 table.insert(Skeletons, Library:NewSkeleton(Player, true));
end
game.Players.PlayerAdded:Connect(function(Player)
 table.insert(Skeletons, Library:NewSkeleton(Player, true));
end) 
        end
    })


        Tabs.Visual:AddButton({
        Title = "Chams",
        Description = "Player Chams ESP",
        Callback = function()
        local client = game.Players.LocalPlayer
local players = game:GetService("Players")
local rs = game:GetService("RunService")

local function clonePart(part, model, character)
   if part:IsA("BasePart") then
local head = character:WaitForChild("Head")
local clone = part:Clone()
for i, v in ipairs(clone:GetChildren()) do
if not v:IsA("SpecialMesh") then
v:Destroy()
continue
end
v.TextureId = ""
end
clone.Color = Color3.fromRGB(0, 255, 0)
pcall(function()clone.Size = clone.Size * 0.7 clone.CanCollide = false end)
clone.Parent = model
rs.RenderStepped:connect(function()
if head:IsDescendantOf(workspace) then
clone.CFrame = part.CFrame
clone.Size = part.Size
else
model:Destroy()
return
end
end)
end
end
local function chams(character)
   local model = Instance.new("Model")
   model.Name = character.Name
   model.Parent = workspace
   local cham = Instance.new("Highlight",model)
   cham.Name = "cham"
   cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop  
   cham.OutlineColor = Color3.fromRGB(0,0,0)
   cham.FillColor = Color3.fromRGB(40,119,208)
   cham.FillTransparency = 0.1
   cham.OutlineTransparency = 0.2
   local new = cham:Clone()
   new.Parent = character
   new.FillColor = Color3.fromRGB(176,221,22)
   new.DepthMode = Enum.HighlightDepthMode.Occluded  
   for i,v in ipairs(character:GetChildren()) do
--head
       if character:FindFirstChild("Head") then
           clonePart(v, model, character)
       end
   end
end
for i,v in ipairs(players:GetPlayers()) do
   if v~= client then
       if v.Character then
           chams(v.Character)
       end
   end
   v.CharacterAdded:connect(function()wait(0.1)chams(v.Character)end)
end
players.PlayerAdded:connect(function()
   if v~= client then
       if v.Character then
           chams(v.Character)
       end
   end
   v.CharacterAdded:connect(function()wait(0.1)chams(v.Character)end)
end)
        end
    })

        Tabs.combat:AddButton({
        Title = "aimbot",
        Description = "",
        Callback = function()
        --aimbot
           -- Configuration
local config = {
    TeamCheck = true,
    FOV = 150,
    Smoothing = 1,
    KeyToToggle = Enum.KeyCode.F, 
}

-- Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- GUI
local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 1.5
FOVring.Radius = config.FOV
FOVring.Transparency = 1
FOVring.Color = Color3.fromRGB(255, 128, 128)
FOVring.Position = workspace.CurrentCamera.ViewportSize / 2

local function getClosestVisiblePlayer(camera)
    local ray = Ray.new(camera.CFrame.Position, camera.CFrame.LookVector)
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("Head") then
                local headPosition = character.Head.Position
                local targetPosition = ray:ClosestPoint(headPosition)
                local distance = (targetPosition - headPosition).Magnitude
                
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- Function to toggle the aimbot
local aimbotEnabled = false

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    FOVring.Visible = aimbotEnabled
end

-- Function to update the aimbot
local function updateAimbot()
    if aimbotEnabled then
        local currentCamera = workspace.CurrentCamera
        local crosshairPosition = currentCamera.ViewportSize / 2
        local closestPlayer = getClosestVisiblePlayer(currentCamera)
        
        if closestPlayer then
            local headPosition = closestPlayer.Character.Head.Position
            local headScreenPosition = currentCamera:WorldToScreenPoint(headPosition)
            local distanceToCrosshair = (Vector2.new(headScreenPosition.X, headScreenPosition.Y) - crosshairPosition).Magnitude
            
            if distanceToCrosshair < config.FOV then
                currentCamera.CFrame = currentCamera.CFrame:Lerp(CFrame.new(currentCamera.CFrame.Position, headPosition), config.Smoothing)
            end
        end
    end
end

-- Connect the toggleAimbot function to the toggle key
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == config.KeyToToggle then
        toggleAimbot()
    end
end)

-- Connect the updateAimbot function to the RenderStepped event
local aimbotConnection

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == config.KeyToToggle then
        if aimbotEnabled then
            FOVring:Remove()
            aimbotConnection:Disconnect()
        else
            FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
            FOVring.Radius = config.FOV
            aimbotConnection = RunService.RenderStepped:Connect(updateAimbot)
        end
    end
end)
        end
    })

        Tabs.others:AddButton({
        Title = "bhop",
        Description = "",
        Callback = function()
        local plrs = game:GetService("Players")
	local plr = plrs.LocalPlayer
	local UserInputService = game:GetService("UserInputService")
	local space = UserInputService:IsKeyDown(Enum.KeyCode.Space)
	local Client = getsenv(game.Players.LocalPlayer.PlayerGui.Client)
	local backup = {}
	backup.speed = Client.speedupdate
	local j = 0

while wait() do
space = UserInputService:IsKeyDown(Enum.KeyCode.Space)
	if space==true then
	if workspace:FindFirstChild(plr.Name) then
	if plr.Character:FindFirstChild("Humanoid") then
	j = 1
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 40
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 22
	Client.speedupdate = function()
	end
	end
	end
	else
	if j == 1 then
	j = 0
	wait(0.5)
	Client.speedupdate = backup.speed
	wait()
	end
	end
	end
        end
    })



       
end





SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("GGhackScriptHub")
SaveManager:SetFolder("GGhackScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "GGhack",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
