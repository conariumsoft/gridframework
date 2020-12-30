local framework = game.ReplicatedFirst:WaitForChild("framework")

local stdlibx = require(game.ReplicatedFirst.framework.stdlibx);
local formal = stdlibx.formal;




local network_module = {}

network_module.request_type = {
    SAVE = "SAVE",
    LOAD = "LOAD",
    PLACE_WALL = "PLACE_WALL",
    PURCHASE_CELL = "PURCHASE_CELL",
    REMOVE_WALL = "REMOVE_WALL",
    PLACE_FLOOR = "PLACE_FLOOR",
    REMOVE_FLOOR = "REMOVE_FLOOR",
    GET_SESSION_DATA = "GET_SESSION_DATA",
};


return network_module;