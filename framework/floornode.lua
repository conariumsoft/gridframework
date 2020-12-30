local formal = require(game.ReplicatedFirst.framework.stdlibx).formal;
local core = require(game.ReplicatedFirst.framework.core);
local adornments = require(game.ReplicatedFirst.framework.adornments);



local floor_node = {}
floor_node.__index = floor_node


function floor_node:build()
    local part = Instance.new("Part");
    part.Anchored = true;
    part.CanCollide = false;
    part.Size = Vector3.new(.2,.2,.2);
    part.Color = Color3.new(1,1,1);
    part.CFrame = CFrame.new(self.position)
    return part;
end

function floor_node.new(pos : Vector3)  : typedef
	local self : typedef = setmetatable({}, floor_node)
    -- properties

    self.position = pos;


    self.part = self:build();

	return self
end


export type typedef = typeof(floor_node.new()); -- Type Export Hax


return floor_node;