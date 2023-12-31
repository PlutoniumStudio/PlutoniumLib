local Primer = {}
Primer.__index = Primer

local util = script.Parent.Util

local TypeLib = require(util.PlutoniumTypeLibrary)
type InstancePool = TypeLib.InstancePool
type Caster = TypeLib.Caster
type PrimerData = TypeLib.PrimerData
type CastInstance = TypeLib.CastInstance

local Signal = require(util.Signal)
local ActiveCast = require(script.ActiveCast)

function Primer.new() : Caster
	local newCaster = {
		CastUpdated = Signal.new();
		RayHit = Signal.new();
		RayPierced = Signal.new();
		CastStopping = Signal.new()
	}

	return setmetatable(newCaster, Primer)
end

function Primer.newDataPacket() : PrimerData
	return {
		RaycastParams = RaycastParams.new();
		Acceleration = Vector3.new();
		SimulationSpeed = 1;
		TracerPool = nil;
		MaxDistance = 300;
		UserData = {};
		VisualizeCasts = false;
		IgnorePiercedParts = true;
		Substeps = 1;
		PierceFunction = function() return false end;
	}
end

function Primer:Fire(origin : Vector3, direction : Vector3, velocity : number, dataPacket : PrimerData) : CastInstance
	local newCast = ActiveCast.new(self, origin, direction, velocity, dataPacket)
	return newCast
end

return Primer
