local formal = require(game.ReplicatedFirst.framework.stdlibx).formal;
local core = require(game.ReplicatedFirst.framework.core);
local adornments = require(game.ReplicatedFirst.framework.adornments);


export type wall_node_def = {
    orientation : wall_orientation_enum,
    position : Vector2,
    part : BasePart
}



local wall_node = {}
wall_node.__index = wall_node

function wall_node:get_rot_cframe() : CFrame
    if self.orientation == core.wall_orientation.EastWest then
        return CFrame.new(Vector3.new(0,0,0), Vector3.fromAxis(Enum.Axis.Z))
    end
    if self.orientation == core.wall_orientation.NorthSouth then
        return CFrame.new(Vector3.new(0,0,0), Vector3.fromAxis(Enum.Axis.X))
    end
end

function wall_node:build()
    local part = Instance.new("Part");
    part.Anchored = true;
    part.CanCollide = false;
    part.Size = Vector3.new(.2,.2,.2);
    part.Color = Color3.new(.5, .5, .5);
    part.CFrame = CFrame.new(self.position) * self:get_rot_cframe();
    local adornment = adornments.line(part, {
        color = Color3.new(1, 0, 0),
        radius = 0.05,
        length = 3,
        always_on_top = false,
        transparency = 0.5,
    });
    adornment.CFrame = CFrame.Angles(0, math.rad(90), 0)
    return part;
end

function wall_node.new(orient : wall_orientation_enum, pos : Vector3)  : typedef
	local self : typedef = setmetatable({}, wall_node)
    -- properties

    self.orientation = orient;
    self.position = pos;


    self.part = self:build();

	return self
end


export type typedef = typeof(wall_node.new()); -- Type Export Hax



local bob : typedef = {};

return wall_node;