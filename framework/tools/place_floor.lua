local framework = game.ReplicatedFirst:WaitForChild("framework")

local stdlibx = require(game.ReplicatedFirst.framework.stdlibx);
local formal = stdlibx.formal;
local tablex = stdlibx.tablex;
local functional = stdlibx.functional;
local networking = require(framework.networking);

local core = require(game.ReplicatedFirst.framework.core);


local floor_placer = {}
floor_placer.__index = floor_placer
function floor_placer.new(client)
    local self = setmetatable({}, floor_placer);
    self.client = client;

    self.floor_type = "Hardwood"
    self.phantom_floor = self:create_phantom("Hardwood");
    
    self.phantom_cframe = CFrame.new(0,0,0);

    return self;
end

function floor_placer:create_phantom(walltype)
    local f_part = game.ReplicatedStorage.Floors[walltype]:Clone();
    f_part.Transparency = 0.5;
    return f_part;
end

function floor_placer:get_nearest_floor_node(): Part
    local coords = self.client:mouse().Hit.Position;

    local closest = nil;
    tablex.foreach(self.client:getcurrentlayer().FloorNodes:GetChildren(), function(_, node) 
        if closest == nil then closest = node end

        if (node.Position - coords).magnitude < (closest.Position - coords).magnitude then
            closest = node;
        end
    end)
    return closest;
end

function floor_placer:set_type(floortype)
    self.floor_type = floortype
    if self.phantom_floor then
        self.phantom_floor:Destroy();
    end
    self.phantom_floor = self:create_phantom(floortype)
    self:deactivate()
    self:activate()
end

function floor_placer:activate()
    self.phantom_floor.Parent = game.Workspace;
end
function floor_placer:deactivate()
    self.phantom_floor.Parent = game.Lighting;
end

function floor_placer:update(delta)
    local node = self:get_nearest_floor_node();

    self.phantom_cframe = self.phantom_cframe:Lerp(node.CFrame, 0.8);

    self.phantom_floor.CFrame = self.phantom_cframe;
end

function floor_placer:input_begins(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        self.client:request_s(networking.request_type.PLACE_FLOOR, {
            floor_type = self.floor_type,
            node = self:get_nearest_floor_node(),
            layer = self.client.layer,
        });
    end

    if input.KeyCode == Enum.KeyCode.One then
        self:set_type("Gravel");
    end
    if input.KeyCode == Enum.KeyCode.Two then
        self:set_type("Hardwood");
    end
    if input.KeyCode == Enum.KeyCode.Three then
        self:set_type("Marble");
    end
    if input.KeyCode == Enum.KeyCode.Four then
        self:set_type("Metal");
    end
end
function floor_placer:input_ends(input)

end




return floor_placer;