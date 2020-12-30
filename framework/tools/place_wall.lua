local UserInputService = game:GetService("UserInputService");
local framework = game.ReplicatedFirst:WaitForChild("framework")

local stdlibx = require(game.ReplicatedFirst.framework.stdlibx);
local formal = stdlibx.formal;
local tablex = stdlibx.tablex;
local functional = stdlibx.functional;
local networking = require(framework.networking);

local core = require(game.ReplicatedFirst.framework.core);


local wall_placer = {}
wall_placer.__index = wall_placer
function wall_placer.new(client)
    local self = setmetatable({}, wall_placer);
    self.client = client;

    self.wall_type = "WallSegment"
    self.phantom_wall = self:create_phantom("WallSegment");
    
    self.phantom_cframe = CFrame.new(0,0,0);

    return self;
end

function wall_placer:create_phantom(walltype)
    local w_model = game.ReplicatedStorage.Walls[walltype]:Clone();
    tablex.foreach(w_model.Model:GetChildren(), function(_, part)
        part.Transparency = 0.5
    end)
    return w_model;
end

local raycast_config = RaycastParams.new();
raycast_config.FilterType = Enum.RaycastFilterType.Whitelist;
raycast_config.IgnoreWater = true--?


function wall_placer:get_nearest_wall_node(): Part
    local coords = self.client:mouse().Hit.Position;

    local mouse_pos = UserInputService:GetMouseLocation();
    local cam = self.client.camera.camera;
    local mouse_ray = cam:ViewportPointToRay(mouse_pos.X, mouse_pos.Y);
    raycast_config.FilterDescendantsInstances = {self.client:getcurrentlayer()}
    local result = workspace:Raycast(mouse_ray.Origin, mouse_ray.Direction*500, raycast_config);
    if result then
        coords = result.Position;
    end

    local closest = nil;
    tablex.foreach(self.client:getcurrentlayer().WallNodes:GetChildren(), function(_, node) 
        if closest == nil then closest = node end

        if (node.Position - coords).magnitude < (closest.Position - coords).magnitude then
            closest = node;
        end
    end)
    return closest;
end

function wall_placer:set_type(walltype)
    self.wall_type = walltype
    if self.phantom_wall then
        self.phantom_wall:Destroy();
    end
    self.phantom_wall = self:create_phantom(walltype)
    self:deactivate()
    self:activate()
end

function wall_placer:activate()
    self.phantom_wall.Parent = game.Workspace;
end
function wall_placer:deactivate()
    self.phantom_wall.Parent = game.Lighting;
end

function wall_placer:update(delta)
    local node = self:get_nearest_wall_node();

    self.phantom_cframe = self.phantom_cframe:Lerp(node.CFrame, 0.8);

    self.phantom_wall.Model:SetPrimaryPartCFrame(self.phantom_cframe);
end

function wall_placer:input_begins(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        self.client:request_s(networking.request_type.PLACE_WALL, {
            wall_type = self.wall_type,
            node = self:get_nearest_wall_node(),
            layer = self.client.layer
        });
    end

    if input.KeyCode == Enum.KeyCode.One then
        self:set_type("WallSegment")
    end
    if input.KeyCode == Enum.KeyCode.Two then
        self:set_type("Door")
    end
    if input.KeyCode == Enum.KeyCode.Three then
        self:set_type("Window")
    end
end
function wall_placer:input_ends(input)

end




return wall_placer;