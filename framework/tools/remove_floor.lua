local framework = game.ReplicatedFirst:WaitForChild("framework")

local stdlibx = require(game.ReplicatedFirst.framework.stdlibx);
local formal = stdlibx.formal;
local tablex = stdlibx.tablex;
local functional = stdlibx.functional;
local networking = require(framework.networking);

local core = require(game.ReplicatedFirst.framework.core);


local floor_remover = {}
floor_remover.__index = floor_remover

function floor_remover:get_selection_box()
    if self._selbox == nil then
        local box = Instance.new("SelectionBox");
        box.Color3 = Color3.new(1, 0, 0);
        box.Parent = game.Workspace;
        self._selbox = box;
    end
    return self._selbox
end


function floor_remover.new(client)
    local self = setmetatable({}, floor_remover);
    self.client = client;


   -- self.selectionbox = ;


    return self;
end

function floor_remover:create_highlight(walltype)
    local f_part = game.ReplicatedStorage.Floors[walltype]:Clone();
    f_part.Transparency = 0.5;
    return f_part;
end

function floor_remover:get_nearest_floor_node(): Part
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

function floor_remover:get_highlighted_floor() : Part
    local part = self.client:mouse().Target;

    if part.Parent == self.client:getcurrentlayer().FloorModels then
        return part;
    end
end

function floor_remover:set_type(floortype)
    self.floor_type = floortype
    if self.phantom_floor then
        self.phantom_floor:Destroy();
    end
    self.phantom_floor = self:create_phantom(floortype)
    self:deactivate()
    self:activate()
end

function floor_remover:activate()
   --self.phantom_floor.Parent = game.Workspace;
end
function floor_remover:deactivate()
    --self.phantom_floor.Parent = game.Lighting;
end

function floor_remover:update(delta)
    local node = self:get_nearest_floor_node();

    self:get_selection_box().Adornee = self:get_highlighted_floor();
end

function floor_remover:input_begins(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        self.client:request_s(networking.request_type.REMOVE_FLOOR, {
            node = self:get_nearest_floor_node(),
            layer = self.client.layer,
        });
    end
end
function floor_remover:input_ends(input)

end




return floor_remover;