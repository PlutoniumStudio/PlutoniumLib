local ActiveCast = {}
ActiveCast.__index = ActiveCast

local util = script.Parent.Parent.Util

local TypeLib = require(util.PlutoniumTypeLibrary)
type InstancePool = TypeLib.InstancePool
type Caster = TypeLib.Caster
type PrimerData = TypeLib.PrimerData
type CastInstance = TypeLib.CastInstance

local CASTS = {}

local copyTable = require(util.CopyTable)

function ActiveCast.new(caster : Caster, origin, direction, velocity, primerDataPacket : PrimerData) : CastInstance
	local newCast = {
		Caster = caster;
		SimulationSpeed = primerDataPacket.SimulationSpeed;

		Position = origin;
		Velocity = direction.Unit*velocity;
		CastId = math.random(0, 999)..math.random(0, 999)..math.random(0, 999);
		MaxDistance = primerDataPacket.MaxDistance;
		Distance = 0;

		Trajectories = {
			{
				Origin = origin;
				InitialVelocity = direction.Unit*velocity;
				StartTick = tick();
				LastTick = tick();
				Acceleration = primerDataPacket.Acceleration;
			}
		};

		Tracer = nil;
		PartPool = primerDataPacket.TracerPool;
		RaycastParams = primerDataPacket.RaycastParams;
		Visualize = primerDataPacket.VisualizeCasts;
		PierceFunction = primerDataPacket.PierceFunction;
		

		UserData = copyTable(primerDataPacket.UserData);

		Active = true
	}

	if newCast.PartPool ~= nil then
		newCast.Tracer = newCast.PartPool:GetPart()
	end

	table.insert(CASTS, newCast)

	return newCast
end

local function GetPositionAtTime(time : number, origin : Vector3, initialVelocity : Vector3, acceleration : Vector3)
	local force = Vector3.new(acceleration.X*time^2, acceleration.Y*time^2, acceleration.Z*time^2)
	return origin + initialVelocity * time + force
end

local function GetVelocityAtTime(time : number, initialVelocity : Vector3, acceleration : Vector3)
	return initialVelocity + acceleration * time
end

local function VisualizeSegment(segmentCFrame : CFrame, segmentLength : number)
	local adornment = Instance.new("LineHandleAdornment")
	adornment.Adornee = workspace.Terrain
	adornment.CFrame = segmentCFrame
	adornment.Length = segmentLength
	adornment.Color3 = Color3.new(1)
	adornment.Thickness = 5
	adornment.Parent = game.Workspace
	
	game.Debris:AddItem(adornment, 60)
end

local function VisualizeHit(position : Vector3, pierced : boolean)
	local adornment = Instance.new("SphereHandleAdornment")
	adornment.Adornee = workspace.Terrain
	adornment.CFrame = CFrame.new(position)
	adornment.Radius = 0.5
	adornment.Color3 = (pierced == false) and Color3.new(0, 0.333333, 1) or Color3.new(0, 1, 0)
	adornment.Parent = game.Workspace

	game.Debris:AddItem(adornment, 60)
end

function ActiveCast:EditTrajectory(position, velocity, acceleration)
	self.Position = position or self.Position
	self.Velocity = velocity or self.Velocity

	self.Trajectories(#self.Trajectories).LastTick = tick()
	local oldTrajectory = self.Trajectories(#self.Trajectories)
	self.Trajectories[#self.Trajectories+1] = {
		Origin = position or self.Position;
		InitialVelocity = velocity or self.Velocity;
		StartTick = tick();
		LastTick = tick();
		Acceleration = acceleration;
	}
end

function ActiveCast:Terminate()
	self.Active = false
end

local RunService = game:GetService("RunService")

if RunService:IsClient() then
	RunService:BindToRenderStep("CAST_UPDATE", Enum.RenderPriority.Last.Value, function()
		for i, castObject in pairs(CASTS) do
			if castObject.Active then
				local currentTrajectory = castObject.Trajectories[#castObject.Trajectories]
				local currentTick = (tick()-currentTrajectory.StartTick) * castObject.SimulationSpeed

				local P = GetPositionAtTime(
					currentTick,
					currentTrajectory.Origin,
					currentTrajectory.InitialVelocity,
					currentTrajectory.Acceleration
				)

				local V = GetVelocityAtTime(
					currentTick,
					currentTrajectory.InitialVelocity,
					currentTrajectory.Acceleration
				)
				
				local result = game.Workspace:Raycast(castObject.Position, P-castObject.Position, castObject.RaycastParams)

				if result then
					local pierced = castObject.PierceFunction(castObject, result, P, V)
					P = result.Position

					if pierced then
						castObject.Caster.RayPierced:Fire(castObject, result)
					else
						castObject.Caster.RayHit:Fire(castObject, result)
						castObject.Active = false
					end
					
					if castObject.Visualize then
						VisualizeHit(P, pierced)
					end
				end
				
				castObject.Distance += (P-castObject.Position).Magnitude
				if castObject.Distance >= castObject.MaxDistance then
					castObject.Active = false
				end
				
				if castObject.Visualize then
					VisualizeSegment(CFrame.new(castObject.Position, P), (P-castObject.Position).Magnitude)
				end
				
				castObject.Caster.CastUpdated:Fire(castObject, castObject.Position, (P-castObject.Position).Unit, (P-castObject.Position).Magnitude, V, castObject.Tracer)

				castObject.Position = P
				castObject.Velocity = V
			else
				castObject.Caster.CastStopping:Fire(castObject)

				if castObject.PartPool ~= nil and castObject.Tracer ~= nil then
					castObject.PartPool:ReturnPart(castObject.Tracer)
					castObject.Tracer = nil
				end

				table.remove(CASTS, i)
			end
		end
	end)
else
	RunService.Heartbeat:Connect(function()
		for i, castObject in pairs(CASTS) do
			if castObject.Active then
				local currentTrajectory = castObject.Trajectories[#castObject.Trajectories]
				local currentTick = (tick()-currentTrajectory.StartTick) * castObject.SimulationSpeed
				
				local P = GetPositionAtTime(
					currentTick,
					currentTrajectory.Origin,
					currentTrajectory.InitialVelocity,
					currentTrajectory.Acceleration
				)
				
				local V = GetVelocityAtTime(
					currentTick,
					currentTrajectory.InitialVelocity,
					currentTrajectory.Acceleration
				)
				
				local result = game.Workspace:Raycast(castObject.Position, P-castObject.Position, castObject.RaycastParams)
				
				if result then
					local pierced = castObject.PierceFunction(castObject, result, P, V)
					P = result.Position
					
					if pierced then
						castObject.Caster.RayPierced:Fire(castObject, result)
					else
						castObject.Caster.RayHit:Fire(castObject, result)
						castObject.Active = false
					end

					if castObject.Visualize then
						VisualizeHit(P, pierced)
					end
				end
				
				castObject.Distance += (P-castObject.Position).Magnitude
				if castObject.Distance >= castObject.MaxDistance then
					castObject.Active = false
				end

				if castObject.Visualize then
					VisualizeSegment(CFrame.new(castObject.Position, P), (P-castObject.Position).Magnitude)
				end
				
				castObject.Caster.CastUpdated:Fire(castObject, castObject.Position, (P-castObject.Position).Unit, (P-castObject.Position).Magnitude, V, castObject.Tracer)
				
				castObject.Position = P
				castObject.Velocity = V
			else
				castObject.Caster.CastStopping:Fire(castObject)
				
				if castObject.PartPool ~= nil and castObject.Tracer ~= nil then
					castObject.PartPool:ReturnPart(castObject.Tracer)
					castObject.Tracer = nil
				end
				
				table.remove(CASTS, i)
			end
		end
	end)
end

return ActiveCast
