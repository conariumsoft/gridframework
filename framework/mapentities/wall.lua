local formal = require(game.ReplicatedFirst.framework.stdlibx.formal);

type wall_type = {
	Price : number,
	DisplayName : string,
	Model : Folder,
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
