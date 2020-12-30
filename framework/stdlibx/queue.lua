local stdlibx = require(game.ReplicatedFirst.framework.stdlibx)

export type q<T> = {
    enqueue : (T) -> nil,
    dequeue : () -> T,
    count : () -> number,
}


local queue = {}
queue.__index = queue
function queue.new()  : typedef
	local self : typedef = setmetatable({}, queue)
    -- properties

    self._queue = stdlibx.functional.new()

	return self
end

function queue:count() return #self._queue end

function queue:enqueue(obj)
    table.insert(self._queue, self:count(), obj);
end

function queue:dequeue()
    return stdlibx.tablex.pop(self._queue)
end


export type typedef = typeof(class_def.new()); -- Type Export Hax
return queue;