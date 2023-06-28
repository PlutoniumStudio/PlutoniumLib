export type InstancePool = {
	Template: Instance,
	InUse: any,
	Available: any,
	Container: Instance,
	ExpansionSize: number;
}

export type Caster = {
	CastUpdated: RBXScriptSignal,
	RayHit: RBXScriptSignal,
	RayPierced: RBXScriptSignal,
	CastStopping: RBXScriptSignal,
	Fire: (Vector3, Vector3, number, KwikData) -> CastInstance
}

export type PrimerData = {
	RaycastParams: RaycastParams,
	Acceleration: Vector3,
	SimulationSpeed: number,
	TracerPool: InstancePool?,
	MaxDistance: number,
	UserData: {any},
	VisualizeCasts: boolean,
	PierceFunction: any,
}

export type CastInstance = {
	Caster: Caster;
	SimulationSpeed: number;
	
	Position: Vector3,
	Velocity: Vector3,
	CastId: number,
	MaxDistance: number,
	Distance: number,
	
	Trajectories: {PrimerTrajectory},
	
	Tracer: nil;
	PartPool: InstancePool,
	RaycastParams: RaycastParams,
	VisualizeCasts: boolean,
	PierceFunction: (CastInstance, RaycastResult, Vector3, Vector3) -> boolean,
	
	UserData: {any},
	
	Active: boolean,
	
	EditTrajectory: (Vector3, Vector3, Vector3) -> nil
}

export type PrimerTrajectory = {
	Origin: Vector3,
	InitialVelocity: Vector3,
	StartTick: number,
	LastTick: number,
	Acceleration: Vector3
}

export type LoomInstance = {
	Name: string,
	Object: DataStore,
	Type: string,
	Save: (any, {any}) -> nil,
	Export: (any) -> {any},
}

return {}
