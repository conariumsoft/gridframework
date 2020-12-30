--!strict
local framework = game.ReplicatedFirst:WaitForChild("framework")
local stdlibx = require(framework.stdlibx);
local wallnode = require(framework.wallnode);
local floornode = require(framework.floornode);
local core = require(framework.core);
local folder = stdlibx.folder;
local tablex = stdlibx.tablex;





local function get_root(parent, config)
    local node = Instance.new("Part")
    node.Anchored = true;
    node.Size = Vector3.new(config.map_width*config.cell_size,.2,config.map_length*config.cell_size);
    node.Position = Vector3.new(
        (config.map_width-1)*config.cell_size / 2,
        0,
        (config.map_length-1)*config.cell_size / 2
    );
    node.Parent = parent;
    node.Name = "RootNode"
    node.CanCollide = false;
    return node;
end

local layer = {}
layer.__index = layer


function layer.new(config, map, level)
    local self = setmetatable({}, layer);
    local width = config.map_width;
    local length = config.map_length;
    local cell_size = config.cell_size;

    self.container = Instance.new("Model");
    self.container.Name = tostring(level)
    self.container.Parent = map.model.Layers
    self.root = get_root(self.container, config);

    self.container.PrimaryPart = self.root;

    self.wall_node_folder = folder.new("WallNodes", self.container);
    self.floor_node_folder = folder.new("FloorNodes", self.container);
    self.wallmodels = folder.new("WallModels", self.container);
    self.floormodels = folder.new("FloorModels", self.container);

    self.wall_nodes = stdlibx.functional.new();
    self.floor_nodes = stdlibx.functional.new();

    self.wall_objects = stdlibx.functional.new();
    self.floor_objects = stdlibx.functional.new();

    local shifted_left = Vector3.new(cell_size/2, .2, 0);
    local shifted_down = Vector3.new(0, .2, cell_size/2);
    for x = 1, width do
        for y = 1, length do
            local cell_corner = Vector3.new(x*cell_size, .3, y*cell_size);


            -- top node, facing EastWest
            local top_node = wallnode.new(
                core.wall_orientation.EastWest,
                cell_corner + shifted_left
            );
            top_node.part.Parent = self.wall_node_folder;
            self.wall_nodes:insert(top_node);

            -- left node, facing NorthSouth
            local left_node = wallnode.new(
                core.wall_orientation.NorthSouth,
                cell_corner + shifted_down
            );
            left_node.part.Parent = self.wall_node_folder;
            self.wall_nodes:insert(left_node);
        end
    end

    for x = 1, width do
        for y = 1, length do
            local cell_center = Vector3.new(x*cell_size, 0.2, y*cell_size)+shifted_left+shifted_down;

            local floor_node = floornode.new(cell_center);
            floor_node.part.Parent = self.floor_node_folder;
            table.insert(self.floor_nodes, floor_node);
        end
    end
    return self;
end

local gridmap = {}
gridmap.__index = gridmap


function gridmap.new(config: map_config)
    local self = setmetatable({}, gridmap);
    self.model = folder.new("Map", game.Workspace);
    folder.new("Layers", self.model);
    self.config = config

    self.layers = {}

    local map_baseplate = Instance.new("Part");
    map_baseplate.Anchored = true;
    map_baseplate.CanCollide = false;
    map_baseplate.Color = Color3.new(0,0,0);
    map_baseplate.Size = Vector3.new(config.map_width*config.cell_size, 0.2, config.map_length*config.cell_size);
    map_baseplate.Position = Vector3.new(
        ((config.map_width+2)*config.cell_size)/2, 
        0, 
        ((config.map_length+2)*config.cell_size)/2
    )
    map_baseplate.Parent = self.model;
    map_baseplate.Name = "Baseplate";
    self.baseplate = map_baseplate;

    self:add_layer(1);
    self:add_layer(2);
    self:add_layer(3);

    return self;
end

function gridmap:add_layer(level)
    self.layers[level] = layer.new(self.config, self, level)
    self.layers[level].container:SetPrimaryPartCFrame(self.baseplate.CFrame * CFrame.new(0, (level-1)*8, 0))
end

function gridmap:ground_floor() 
    return self:layer(1);
end

function gridmap:layer(index)
    return self.layers[index];
end


local function build_map(config: map_config)
    local container = folder.new("Map", game.Workspace);

    local wall_model_folder = folder.new("WallModels", container);
    local floor_model_folder = folder.new("FloorModels", container);

    local wall_node_folder = folder.new("WallNodes", container);
    local floor_node_folder = folder.new("FloorNodes", container);
    local width = config.map_width;
    local length = config.map_length;
    local cell_size = config.cell_size;
    local layers = config.layer_height;

    

    local wall_nodes = stdlibx.functional.new();

    local shifted_left = Vector3.new(cell_size/2, .2, 0);
    local shifted_down = Vector3.new(0, .2, cell_size/2);
    for x = 1, width do
        for y = 1, length do
            local cell_corner = Vector3.new(x*cell_size, .3, y*cell_size);

            -- top node, facing EastWest
            local top_node = wallnode.new(
                core.wall_orientation.EastWest,
                cell_corner + shifted_left
            );
            top_node.part.Parent = wall_node_folder;
            wall_nodes:insert(top_node);

            -- left node, facing NorthSouth
            local left_node = wallnode.new(
                core.wall_orientation.NorthSouth,
                cell_corner + shifted_down
            );
            left_node.part.Parent = wall_node_folder;
            wall_nodes:insert(left_node);
        end
    end


    local floor_nodes = stdlibx.functional.new();
    for x = 1, width do
        for y = 1, length do
            local cell_center = Vector3.new(x*cell_size, 0.2, y*cell_size)+shifted_left+shifted_down;

            local floor_node = floornode.new(cell_center);
            floor_node.part.Parent = floor_node_folder;
            floor_nodes:insert(floor_node);
        end
    end
    return container;
end

local session = {}
session.__index = session

function session.new(owner : Player)  : typedef
	local self : typedef = setmetatable({}, session)
	-- properties
	
    self.player = owner;

	return self
end



function session:on_request_setup(request: setup_request, config : map_config): coregame.sessiondata

    self.map = gridmap.new(config);
    self.config = config;

	return {
		map = self.map.model,
		granted = true,
		config = config,
	};
end

function session:on_place_wall_request(request: core.place_wall_request) : core.request_response
    local focused_layer = self.map:layer(request.layer);
    if focused_layer.wall_objects[request.node] then
        return { granted = false, reason = "Wall already present at node."};
    end

    local w_model = game.ReplicatedStorage.Walls[request.wall_type]:Clone();
    w_model.Parent = focused_layer.wallmodels;
    tablex.foreach(w_model.Model:GetChildren(), function(_, part)
       -- part.Size = Vector3.new(self.config.cell_size, part.Size.Y, part.Size.Z)
    end)
    w_model.Model:SetPrimaryPartCFrame(request.node.CFrame);

    focused_layer.wall_objects[request.node] = w_model;

    return {granted = true, reason = ""};
end

function session:on_place_floor_request(request: core.place_floor_request): core.request_response
    local focused_layer = self.map:layer(request.layer);
    if focused_layer.floor_objects[request.node] then
        return { granted = false, reason = "Floor already present at node."};
    end

    local floor = game.ReplicatedStorage.Floors[request.floor_type]:Clone();
    floor.Parent = focused_layer.floormodels;
    
    floor.CFrame = request.node.CFrame;

    focused_layer.floor_objects[request.node] = floor;

    return {granted = true, reason = ""};
end


function session:on_remove_floor_request(request)
    local focused_layer = self.map:layer(request.layer);
    if focused_layer.floor_objects[request.node] then
        focused_layer.floormodels[request.node]:Destroy();
        focused_layer.floor_objects[request.node] = nil;
        return { granted = true, reason = ""};
    end
    return { granted = false, reason = ""};
end

function session:on_request_load(request: load_request): load_reply

end

function session:on_request_save(request: save_request): save_reply

end

function session:save_before_exit()

end

function session:exit()

end


export type typedef = typeof(session.new()); -- Type Export Hax


return session;