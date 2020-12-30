--!strict
local stdlibx = require(game.ReplicatedFirst.framework.stdlibx);
local formal = stdlibx.formal;


export type net_message = {

}

export type net_request = {
    
}



export type load_request = {
	slot : string,
	asset_kit : coregame.asset_kit_enum
}
export type save_request = {

}
export type load_reply = {

}
export type save_reply = {

}
export type setup_request = {
	
}


export type setup_reply = {
	config : map_config,
	assigned_map: Model,
}


export type map_config = {
	cell_size: number,
	map_width: number,
	map_length: number,
	layer_height: number,
}

-- player request handlers

export type place_floor_request = {

}
export type place_wall_request = {
    node : Part,
    wall_type : string
}
export type remove_floor_request = {
    
}

export type purchase_cell_request = {

}
export type request_response = {
	granted : bool,
	reason : string,
}

type map_config = {
	cell_size: number,
	map_width: number,
	map_length: number,
	layer_height: number,
}

export type sessiondata = {
    granted : bool,
    map : Folder,
    config: map_config,
}

export type session_request = {

}

export type asset_kit = Folder;



export type wall_orientation_enum = number;
local wall_orientation : formal.enum<wall_orientation_enum> = {
    NorthSouth = 1,
    EastWest = 2,

}


local core = {}
core.wall_orientation = wall_orientation;

return core;
