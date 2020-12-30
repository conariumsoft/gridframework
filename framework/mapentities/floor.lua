--!strict

local formal = require(game.ReplicatedFirst.framework.stdlibx.formal);

type FloorType = {
	Price : number,
	DisplayName : string,
	Material : Enum.Material,
	Color : Color3,

};


local FloorDatabase : formal.list<FloorType> = {
	Concrete = {
		Price = 100,
		DisplayName = "",
		Material = Enum.Material.Concrete,
		Color = Color3.new(0.6, 0.6, 0.6),
	},
	Marble = {
		Price = 250,
		DisplayName = "Marble",
		Material = Enum.Material.Marble,
		Color = Color3.new(.8, .4, .4),	
	},
	Hardwood = {
		Price = 50,
		DisplayName = "",
		Material = Enum.Material.WoodPlanks,
		Color = Color3.new(0.7, 0.75, .25),	
	},
};


local function get_template(definition : FloorType) : Part 
	local part = Instance.new("Part");
	part.Material = definition.Material;
	part.Color = definition.Color;
	part.Parent = script;
	return part;
end


local floor_instance = {}
floor_instance.__index = floor_instance


function floor_instance:_construct_model()
	self.model = get_template(self.floor_type);
end


function floor_instance.new(sqr_size : number, floor_type : FloorType)  : typedef
	local self : typedef = setmetatable({}, floor_instance)
	
	
	self.square_size = sqr_size
	self.floor_type = floor_type
	--self.

	return self
end

function floor_instance:test()

end

export type typedef = typeof(floor_instance.new(0, FloorDatabase.Concrete)); -- Type Export Hax

return floor_instance


