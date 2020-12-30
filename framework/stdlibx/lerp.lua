local timer = require(game.ReplicatedFirst.framework.stdlibx.timer);
local mathx = require(game.ReplicatedFirst.framework.stdlibx.mathx);

local internal_timer = timer.new(1/60);


local auto_vector2 = {};
auto_vector2.__index = auto_vector2;

function auto_vector2.new() : typedef
    local self: typedef = setmetatable({}, auto_vector2)

    self.aggression = 1;
    self.goal = Vector2.new(0,0);
    self.current = Vector2.new(0,0);

    self.timer = internal_timer:Connect(function(dt) self:update(dt) end);

    return self;
end

function auto_vector2:update(delta : number)
    self.current = mathx.lerpv2(self.current, self.goal, self.aggression);
end

function auto_vector2:set_goal(goal : Vector2)
    self.goal = goal;
end

function auto_vector2:move(goalshift: Vector2)
    self.goal += goalshift;
end

function auto_vector2:get_current() : Vector2
    return self.current;
end

function auto_vector2:force_to_goal()
    self.current = self.goal;
end



return {
    auto_vector2 = auto_vector2,
};