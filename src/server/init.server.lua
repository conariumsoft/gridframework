--!strict

local MAP_WIDTH = 16;
local MAP_LENGTH = 16;
local CELL_SIZE = 8;
local LAYER_HEIGHT = 16;



local framework = game.ReplicatedFirst:WaitForChild("framework")
local core = require(game.ReplicatedFirst.framework.core);
local stdlibx = require(game.ReplicatedFirst.framework.stdlibx);
local session = require(game.ReplicatedFirst.framework.gamesession);
local formal = require(game.ReplicatedFirst.framework.stdlibx.formal);


local sessions: formal.dictionary<Player, session.typedef> = stdlibx.tablex.new();

local function get_session(player : Player) : session.typedef
    return sessions[player];
end
local networking = require(framework.networking);

game.Players.PlayerAdded:Connect(function(player : Player)
    sessions[player] = session.new(player);
end)

game.Players.PlayerRemoving:Connect(function(player : Player)
    get_session(player):save_before_exit();
    get_session(player):exit();
    sessions[player] = nil;
end)



local function on_client_request(player, msg_type, msg_data)
    if msg_type == networking.request_type.GET_SESSION_DATA then
        return get_session(player):on_request_setup(msg_data, 
        {
            map_width = MAP_WIDTH,
            map_length = MAP_LENGTH,
            cell_size = CELL_SIZE,
            layer_height = LAYER_HEIGHT
        });
    end


    if msg_type == networking.request_type.PLACE_WALL then
        return get_session(player):on_place_wall_request(msg_data);
    end
    if msg_type == networking.request_type.REMOVE_WALL then
        return get_session(player):on_remove_wall_request(msg_data);
    end
    if msg_type == networking.request_type.PLACE_FLOOR then
        return get_session(player):on_place_floor_request(msg_data);
    end
    if msg_type == networking.request_type.REMOVE_FLOOR then
        return get_session(player):on_remove_floor_request(msg_data);
    end
    if msg_type == networking.request_type.SAVE then
        return get_session(player):on_request_save(msg_data);
    end
    if msg_type == networking.request_type.LOAD then
        return get_session(player):on_request_load(msg_data);
    end
    if msg_type == networking.request_type.PURCHASE_CELL then
        return get_session(player):on_purchase_cell_request(msg_data);
    end
end

local function on_client_message(player, msg_type, msg_data)

end

game.ReplicatedStorage.request.OnServerInvoke = on_client_request;
game.ReplicatedStorage.send.OnServerEvent:Connect(on_client_message);