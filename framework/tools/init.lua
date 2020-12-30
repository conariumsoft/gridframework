local framework = game.ReplicatedFirst:WaitForChild("framework")
local stdlibx = require(game.ReplicatedFirst.framework.stdlibx);
local formal = stdlibx.formal;

local tools = {
    place_wall = require(script.place_wall),
    place_floor = require(script.place_floor),
    remove_floor = require(script.remove_floor),
};



return tools;