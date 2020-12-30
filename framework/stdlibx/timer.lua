--!strict
local timer = {}
local connection = {}
local active = setmetatable({},{__mode = "k"})
local runservice = game:GetService("RunService")

timer.__index = timer
connection.__index = connection
connection.__mode = "k"

function timer.new(rate : number)
	if rate < 1/60 then
		rate = 1/60
	end
	local obj = {
		rate = rate,
		bindable = Instance.new("BindableEvent"),
		dt = 0,
		connections = {}
	}
	setmetatable(obj, timer)
	active[#active+1] = obj
	return obj
end

function timer:Connect(callback)
	local obj = {
		Connection = self.bindable.Event:Connect(callback),
		Timer = self
	}
	setmetatable(obj, connection)
	self.connections[obj] = obj
	return obj
end

function connection:Disconnect()
	self.Connection:Disconnect()
	self.Timer.connections[self] = nil
end

function timer:Wait()
	return self.bindable.Event:Wait()
end

runservice.Heartbeat:Connect(function(dt)
	for k,v in pairs(active) do
		v.dt += dt
		if v.dt >= v.rate then
			v.bindable:Fire(v.dt)
			v.dt = 0
		end
	end
end)

return timer
