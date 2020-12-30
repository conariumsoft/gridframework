--!strict
local UserInputService = game:GetService("UserInputService");

local framework = game.ReplicatedFirst:WaitForChild("framework")

local stdlibx = require(game.ReplicatedFirst.framework.stdlibx);
local formal = stdlibx.formal;
local tablex = stdlibx.tablex;
local functional = stdlibx.functional;

local core = require(game.ReplicatedFirst.framework.core);

type request_type = string;
type send_type = string;

local networking = require(framework.networking);

local tools = require(game.ReplicatedFirst.framework.tools)

local tool_btn_bindings = {}

local gameclient = {}
gameclient.__index = gameclient
function gameclient.new()  : typedef
	local self : typedef = setmetatable({}, gameclient)
    -- properties

    self.game_clock = stdlibx.timer.new(1/60)
    self.map = nil;
    self.config = nil;

    self.layer = 1;
    self.camera = require(game.ReplicatedFirst.framework.camera).new(self);
    self.player = game.Players.LocalPlayer;
    self.ui = self.player:WaitForChild("PlayerGui"):WaitForChild("ToolUI");
    self:init_ui();
    

    self.camera_panning = false;

    self.active_tool = nil

	return self
end

local function btn_set_dormant(_, button)

end

local function btn_set_active(_, button)

end

function gameclient:init_ui()

    local buttons = functional.where(
        self.ui.Tools:GetChildren(), 
        function(_,b)
            if b:IsA("TextButton")then return true end
        end
    );
    tablex.foreach(buttons, function(_,b)
        b.MouseButton1Down:Connect(function()
            tablex.foreach(buttons, btn_set_dormant);
            btn_set_active(nil, b);
            if self.active_tool then
                self.active_tool:deactivate();
            end
            self.active_tool = self.tools[b.Name];
            if self.active_tool then
                self.active_tool:activate();
            end
        end);
    end);
end

function gameclient:set_tool(tool)
    if tool == nil then
        warn("Tool unimplemented!!")
    end
end

function gameclient:getcurrentlayer()
    return self.map.Layers[tostring(self.layer)]
end

function gameclient:go_above_layer()
    self.layer+=1;

    if self.layer > #self.map.Layers:GetChildren() then
        self.layer = #self.map.Layers:GetChildren();
    end
end

function gameclient:go_below_layer()
    self.layer-=1;


    if self.layer < 1 then self.layer = 1 end
end


function gameclient:mouse() return self.player:GetMouse() end


function gameclient:request_s(request: request_type, data)
    return game.ReplicatedStorage.request:InvokeServer(request, data);
end

function gameclient:send_s(message : message_type, data)
    game.ReplicatedStorage.send:FireServer(message, data);
end

function gameclient:login() : boolean
    local login_request : core.session_request = {};

    local session: core.sessiondata = self:request_s(networking.request_type.GET_SESSION_DATA, login_request);
    if session.granted then
        self.map = session.map;
        self.config = session.config;
        self.camera.baseplate = session.map.Baseplate;
        self.camera.map = session.map;
        self.tools = {
            place_wall = tools.place_wall.new(self),
            place_floor = tools.place_floor.new(self),
            remove_floor = tools.remove_floor.new(self),
        }
        self.active_tool = self.tools.place_wall
        -- where we connect to loop:
        self.game_clock:Connect(function(delta) self:update(delta); end)

    end
    return session.granted
end

function gameclient:update(delta : number)
    
    for _, obj in pairs(self.map.Layers:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.LocalTransparencyModifier = 0.9
        end
    end
    for _, obj in pairs(self:getcurrentlayer():GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.LocalTransparencyModifier = 0
        end
    end

    if self.active_tool then self.active_tool:update(delta); end

    self.camera:update(delta);

    local move_x, move_y = 0, 0;

    if UserInputService:IsKeyDown(Enum.KeyCode.Up) then move_y += 1; end
    if UserInputService:IsKeyDown(Enum.KeyCode.Down) then move_y -= 1; end
    if UserInputService:IsKeyDown(Enum.KeyCode.Left) then move_x -= 1; end
    if UserInputService:IsKeyDown(Enum.KeyCode.Right) then move_x += 1; end
    self.camera:move(Vector2.new(move_y, move_x));



    if self.panning then
        local mouse_delta = UserInputService:GetMouseDelta();
        self.camera:move(Vector2.new(-mouse_delta.Y, mouse_delta.X));
    end

    
end

function gameclient:on_input_begins(input_data)
    if input_data.UserInputType == Enum.UserInputType.MouseButton2 then
        self.panning = true;
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition;
        return;
    end

    if input_data.KeyCode == Enum.KeyCode.U then
        self:go_above_layer()
    end
    if input_data.KeyCode == Enum.KeyCode.L then
        self:go_below_layer()
    end

    if self.active_tool then self.active_tool:input_begins(input_data); end
end

function gameclient:on_input_ends(input_data)
    if input_data.UserInputType == Enum.UserInputType.MouseButton2 then
        self.panning = false;
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        return;
    end

    if self.active_tool then self.active_tool:input_ends(input_data); end
end


local client = gameclient.new();

client:login();

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    client:on_input_begins(input);
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    client:on_input_ends(input);
end)
