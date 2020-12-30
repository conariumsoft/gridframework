local class_def = {}
class_def.__index = class_def
function class_def.new()  : typedef
	local self : typedef = setmetatable({}, class_def)
    -- properties
	return self
end


export type typedef = typeof(class_def.new()); -- Type Export Hax
return class_def;