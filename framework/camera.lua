local lerp = require(game.ReplicatedFirst.framework.stdlibx.lerp);
local mathx = require(game.ReplicatedFirst.framework.stdlibx.mathx);

local camera = {}
camera.__index = camera
function camera.new(client)  : typedef
	local self : typedef = setmetatable({}, camera)
    -- properties

    self.client = client;
    self.camera = game.Workspace.CurrentCamera;
    self.camera.CameraType = Enum.CameraType.Scriptable;
    self.baseplate = nil;

    self.position = Vector2.new();
    self.velocity = Vector2.new();
    
    self.layer = 1;
    self.lerp_base_pos = Vector3.new();

	return self
end

function camera:update(delta: number)
    self.velocity *= (80/100);
    self.position+=(self.velocity*(10/100));

    if self.baseplate then
        local pos = self.position;

        self.lerp_base_pos = self.lerp_base_pos:Lerp(self.client:getcurrentlayer().RootNode.Position, 0.1)

        local c_lookat = Vector3.new(0, 1, 0);
        local c_root_pos = self.lerp_base_pos-Vector3.new(self.baseplate.Size.X/2, 0, self.baseplate.Size.Z/2);
        
        local c_moved_pos = Vector3.new(pos.X, 35, pos.Y);

        local pos_root = c_root_pos+c_moved_pos;

        self.camera.CFrame = CFrame.new(pos_root, pos_root-c_lookat);
    end

end

function camera:move(vel: Vector2)
    self.velocity += vel;
end


export type typedef = typeof(camera.new()); -- Type Export Hax
return camera;