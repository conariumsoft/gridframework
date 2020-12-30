--!strict
-- extra table functions

local formal = require(game.ReplicatedFirst.framework.stdlibx.formal);

local tablex = setmetatable({}, {__index = table})

type pretable = {} | nil;
export type tablex_instance = typeof(tablex.new());

function tablex.new(tobj : pretable) : tablex_instance
	tobj = tobj or {}
	return setmetatable(tobj, {__index = tablex});
end

function tablex.pop(t) return table.remove(t) end
function tablex.push(t, v) table.insert(t, v) return t end
function tablex.shift(t) return table.remove(t, 1) end
function tablex.unshift(t, v) table.insert(t, 1, v) return t end
function tablex.index_of(t, a)
    if a == nil then return nil end
    for i, b in ipairs(t) do
        if a == b then return i end
    end
    return nil
end
function tablex.key_of(t, a)
	if a == nil then return nil end
	for k, v in pairs(t) do
		if a == v then return k end
	end
	return nil
end

function tablex.contains(t, e)
	for i = 1, #t do
		if t[i] == e then
			return true
		end
	end
	return false
end

-- add to table if not already included
function tablex.add(t, a)
    if tablex.index_of(t, a) then return false end -- already in table
    table.insert(t, a);
    return t;
end

-- remove from table if containing
function tablex.remove(t, a) -- ! could be confused with table.remove()??
    local index = tablex.index_of(t, a);
    if index then
        t[index] = nil;
        return t
    end -- none found in table?

    return false;
end
tablex.dispose = tablex.remove;

function tablex.remove_all_occurances(t, a)
    --local found = tablex.index_of(t, a);
    while tablex.remove(t, a) do
        -- keep removing indices
    end
end

function tablex.pick_random(t, r)
    if #t == 0 then return nil end
    return t[math.random(1, math.max(#t, r))]
end
function tablex.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
function tablex.copyinto(orig, dest)
    local orig_type = type(orig)
    if orig_type == 'table' then
        --dest = {}
        for orig_key, orig_value in next, orig, nil do
            dest[table.copy(orig_key)] = table.copy(orig_value)
        end
        --setmetatable(dest, table.copy(getmetatable(orig)))
    end
end
local function cycle_aware_compare(t1,t2,ignore_mt,eps,cache)
    if cache[t1] and cache[t1][t2] then return true end
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' then
        if ty1 == 'number' and eps then return math.abs(t1-t2) < eps end
        return t1 == t2
    end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1 in pairs(t1) do
        if t2[k1]==nil then return false end
    end
    for k2 in pairs(t2) do
        if t1[k2]==nil then return false end
    end
    cache[t1] = cache[t1] or {}
    cache[t1][t2] = true
    for k1,v1 in pairs(t1) do
        local v2 = t2[k1]
        if not cycle_aware_compare(v1,v2,ignore_mt,eps,cache) then return false end
    end
    return true
end
function tablex.deepcompare(t1,t2,ignore_mt,eps)
    return cycle_aware_compare(t1,t2,ignore_mt,eps,{})
end
tablex.identical = tablex.deepcompare

return tablex