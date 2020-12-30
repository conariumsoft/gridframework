local framework = game.ReplicatedFirst:WaitForChild("framework")

local stdlibx = require(game.ReplicatedFirst.framework.stdlibx);
local formal = stdlibx.formal;
local tablex = stdlibx.tablex;
local functional = stdlibx.functional;
local networking = require(framework.networking);

local core = require(game.ReplicatedFirst.framework.core);


local wall_remover = {}
wall_remover.__index = wall_remover

function wall_remover:get_selection_box()
    if self._selbox == nil then
        local box = Instance.new("SelectionBox");
        box.Color3 = Color3.new(1, 0, 0);
        box.Parent = game.Workspace;
        self._selbox = box;
    end
    return self._selbox;
end


function wall_remover.new(client)
    local self = setmetatable({}, wall_remover);
    self.client = client;

    --self.selectionbox = ;
    return self;
end

function wall_remover:create_highlight(walltype)
    local f_part = game.ReplicatedStorage.Floors[walltype]:Clone();
    f_part.Transparency = 0.5;
    return f_part;
end

function wall_remover:get_nearest_wall(): Part
    local coords = self.client:mouse().Hit.Position;

    local closest = nil;
    tablex.foreach(self.client:getcurrentlayer().WallNodes:GetChildren(), function(_, node) 
        if closest == nil then closest = node end

        if (node.Position - coords).magnitude < (closest.Position - coords).magnitude then
            closest = node;
        end
    end)
    return closest;
end

function wall_remover:get_highlighted_wall() : Part
    local part = self.client:mouse().Target;

    if part.Parent == self.client.map.FloorModels then
        return part;
    end
end

function wall_remover:set_type(floortype)
    self.floor_type = floortype
    if self.phantom_floor then
        self.phantom_floor:Destroy();
    end
    self.phantom_floor = self:create_phantom(floortype);
    self:deactivate();
    self:activate();
end

function wall_remover:activate()
   --self.phantom_floor.Parent = game.Workspace;
end
function wall_remover:deactivate()
    --self.phantom_floor.Parent = game.Lighting;
end

function wall_remover:update(delta)
    local node = self:get_nearest_floor_node();

    self:get_selection_box().Adornee = self:get_highlighted_floor();
end

function wall_remover:input_begins(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        self.client:request_s(networking.request_type.REMOVE_WALL, {
            node = self:get_nearest_floor_node(),
        });
    end
end
function wall_remover:input_ends(input)

end




return wall_remover;