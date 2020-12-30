--!strict
-- functional programming faculties

local tablex = require(game.ReplicatedFirst.framework.stdlibx.tablex);
local functional = setmetatable({}, {__index = tablex})

type prefunc = {} | nil;
export type functional_instance = typeof(functional.new());

function functional.new(tobj : prefunc) : functional_instance
	tobj = tobj or {}
	return setmetatable(tobj, {__index = functional});
end

function functional.identity(v) return v end
function functional.foreach(t : table, f : ()->nil)
    for i, v in pairs(t) do f(i, v) end
end
function functional.foreachi(t : table, f : ()->nil)
    for i, v in ipairs(t) do f(i, v) end
end
function functional.map(t, f)
	local result = {}
	for i = 1, #t do
		local v = f(t[i], i)
		if v ~= nil then
			table.insert(result, v)
		end
	end
	return result
end
--filters a sequence
-- returns a table containing items where f(v, i) returns truthy
function functional.filteri(t, f)
	local result = {}
	for i = 1, #t do
		local v = t[i]
		if f(v, i) then
			table.insert(result, v)
		end
	end
	return result
end
function functional.filter(t, f)
	local result = {}
	for i, v in pairs(t) do
		if f(i, v) then
			table.insert(result, v)
		end
	end
	return result
end
-- returns a table containing items where f(v) returns falsey
-- nil results are included so that this is an exact complement of filter; consider using partition if you need both!
function functional.remove_if(t, f)
	local result = {}
	for i = 1, #t do
		local v = t[i]
		if not f(v, i) then
			table.insert(result, v)
		end
	end
	return result
end

functional.where = functional.filter;

--true if any element of the table matches f
function functional.any(t, f)
	for i = 1, #t do
		if f(t[i], i) then
			return true
		end
	end
	return false
end
--true if no element of the table matches f
function functional.none(t, f)
	for i = 1, #t do
		if f(t[i], i) then
			return false
		end
	end
	return true
end

--true if all elements of the table match f
function functional.all(t, f)
	for i = 1, #t do
		if not f(t[i], i) then
			return false
		end
	end
	return true
end

--counts the elements of t that match f
function functional.count(t, f)
	local c = 0
	for i = 1, #t do
		if f(t[i], i) then
			c = c + 1
		end
	end
	return c
end

--return the numeric sum of all elements of t
function functional.sum(t)
	local c = 0
	for i = 1, #t do
		c = c + t[i]
	end
	return c
end

--return the numeric mean of all elements of t
function functional.mean(t)
	local len = #t
	if len == 0 then
		return 0
	end
	return functional.sum(t) / len
end
--return the maximum element of t or zero if t is empty
function functional.max(t)
	local min, max = functional.minmax(t)
	return max
end

--return the minimum element of t or zero if t is empty
function functional.min(t)
	local min, max = functional.minmax(t)
	return min
end

return functional