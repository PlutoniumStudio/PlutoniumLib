local PartPool = {}
PartPool.__index = PartPool

local util = script.Parent.Util

local TypeLib = require(util.PlutoniumTypeLibrary)

type InstancePool = TypeLib.InstancePool

function PartPool.new(template : Instance, precreatedParts : number, container : Instance) : InstancePool
	local Pool = {
		Template = template;
		InUse = {};
		Available = {};
		Container = container or game.Workspace;
		ExpansionSize = 10
	}

	for i = 1, precreatedParts do
		local Duplicate = template:Clone()
		Duplicate.CFrame = CFrame.new(0, 1*10^8, 0)
		Duplicate.Parent = Pool.Container
		table.insert(Pool.Available, Duplicate)
	end

	return setmetatable(Pool, PartPool)
end

function PartPool:GetPart(index : number)
	if #self.Available < 1 then
		for i = 1, self.ExpansionSize do
			local Duplicate = self.Template:Clone()
			Duplicate.CFrame = CFrame.new(0, 1*10^8, 0)
			Duplicate.Parent = self.Container
			table.insert(self.Available, Duplicate)
		end
		warn(("Not enough parts available in pool. Expanding pool by %s instances"):format(tostring(self.ExpansionSize)))
	end

	local Part = self.Available[index or #self.Available]
	table.remove(self.Available, index or #self.Available)
		table.insert(self.InUse, Part)
return Part
end

function PartPool:ReturnPart(part : Instance)
	part.CFrame = CFrame.new(0, 1*10^8, 0)
	table.remove(self.InUse, table.find(self.InUse, part))
	table.insert(self.Available, part)
end

function PartPool:Clear()
	for i, v in pairs(self.InUse) do
		v.CFrame = CFrame.new(0, 1*10^8, 0)
		table.insert(self.Available, v)
	end

	self.InUse = {}
end

function PartPool:Remove()
	for i, v in pairs(self.InUse) do
		v:Destroy()
	end

	for i, v in pairs(self.Available) do
		v:Destroy()
	end

	self.Template:Destroy()
	self = nil
end

return PartPool
