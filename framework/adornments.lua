--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris            = game:GetService("Debris")

-- Templates
local adornment_part_parent: Part = Instance.new("Part");
adornment_part_parent.Anchored = true;
adornment_part_parent.CanCollide = false;
adornment_part_parent.Size = Vector3.new(1,1,1);
adornment_part_parent.Transparency = 1;
adornment_part_parent.Parent = game.Workspace;
adornment_part_parent.Name = "LocalAdornment";


type base_adornment = ConeHandleAdornment | SphereHandleAdornment | CylinderHandleAdornment

local function init_adornment(parent : BasePart, base : base_adornment)
    base.ZIndex = 2;
    base.Adornee = parent;
    base.Parent = parent;
end

--------------------------------------------------------------------
local adornments = {}

adornments.Local = adornment_part_parent;

export type obj_props = {
    color: Color3, 
    radius: number, 
    always_on_top: boolean,
    transparency: number,
    length: number|nil, 
}

function adornments.sphere(parent: BasePart, properties : obj_props): SphereHandleAdornment
	
    local sphere = Instance.new("SphereHandleAdornment");
    init_adornment(parent, sphere);
    sphere.Color3 = properties.sphere;
    sphere.Radius = properties.radius;
	sphere.AlwaysOnTop = properties.always_on_top;
	sphere.Transparency = properties.transparency;
	sphere.Visible = true;
	return sphere;
end

function adornments.cone(parent: BasePart, properties: obj_props): ConeHandleAdornment

    local cone = Instance.new("ConeHandleAdornment");
    init_adornment(parent, cone);
	cone.Color3 = properties.color;
	cone.Height = properties.length;
	cone.Radius = properties.radius;
	cone.AlwaysOnTop = properties.always_on_top;
	cone.Transparency = properties.transparency;
	return cone;
end


function adornments.line(parent: BasePart?, properties : obj_props): CylinderHandleAdornment

    local line = Instance.new("CylinderHandleAdornment");
    init_adornment(parent, line);
    line.Color3 = properties.color;
	line.Height = properties.length;
    line.Radius = properties.radius;
    line.AlwaysOnTop = properties.always_on_top;
	line.Transparency = properties.transparency;
	return line;
end



return adornments;