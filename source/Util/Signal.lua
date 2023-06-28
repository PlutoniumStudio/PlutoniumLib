local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable(
		{Connections = {}},
		Signal
	)
end

function Signal:Connect(Listener)
	table.insert(self.Connections, Listener)
	return Listener
end

function Signal:Fire(...)
	if self.Connections[1] then  
		for i = #self.Connections, 1, -1 do
			local newThread = coroutine.create(self.Connections[i])
			coroutine.resume(newThread, ...)
		end
	end 
end

function Signal:Disconnect(Listener)
	table.remove(self.Connections, table.find(self.Connections, Listener))
end

return Signal
