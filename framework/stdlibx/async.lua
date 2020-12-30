type action = (nil) -> nil
type async_task = (nil) -> any
type async_callback = (typedef, any) -> any

local async = {}

function async:execute()
	
	local co = coroutine.create(function()
		local start_time = os.clock();
		self:callback(self.task());
		local stop_time = os.clock();
		self.completed = true;
		self.execution_time = start_time - stop_time;
	end);
	
	
	coroutine.resume(co);
end

function async.new(task: async_task, callback: async_callback) : typedef

	local self : typedef = setmetatable({}, async)
	-- properties
	self.task = task;
	self.callback = callback;
	return self;
end


function async.run(task: async_task, callback: async_callback)
	local inst = async.new(task, callback);
	inst:execute();
	return inst;
end


return async;