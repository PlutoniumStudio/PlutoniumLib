# PlutoniumLib
Main library for all Plutonium Studio projects


# Documentation

## <sup>module</sup> PartPool

**Functions**
- `PartPool.new(template : Instance, precreatedParts : number, container : Instance)` <sub>InstancePool</sub> - creates an *InstancePool* object

### <sup>class</sup> `InstancePool`

**Properties**
- <sup>Instance</sup> `Template` - part being replicated and used by *InstancePool*
- <sup>Instance</sup> `Container` - folder containing all parts used by *InstancePool*
- <sup>{Instance}</sup> `InUse` - parts currently being used by *InstancePool*
- <sup>{Instance}</sup> `Available` - parts not being used by *InstancePool*
- <sup>number</sup> `ExpansionSize` - amount of parts to add to  *InstancePool* upon depletion of available parts
  
**Functions**
- `GetPart()` <sub>Instance</sub> - summons a part from *InstancePool*
- `ReturnPart(part : Instance)` - returns a used part to *InstancePool*
- `Clear()` - returns all used parts to *InstancePool*
- `Remove()` - removes *InstancePool*

**Code Example**
```lua
local PartPool = require(PlutoniumLib.PartPool)

local part = Instance.new("Part")
part.Anchored = true

local container = Instance.new("Folder")
container.Parent = game.Workspace

local newPool = PartPool.new(part, 100, container)

while wait() do
  local newPart = newPool:GetPart()
  
  if #newPool.Available == 0 then
    newPool:ReturnPart(newPool.InUse[1])
  end
end
```



## <sup>module</sup> KwikKast

**Functions**
- `KwikKast.new` <sub>KwikKaster</sub> - creates a *KwikKaster* object
- `KwikKast.newDataPacket` <sub>KwikKaster</sub> - creates a *KwikData* object

### <sup>class</sup> `KwikKaster`

**Properties**
- <sup>RBXScriptSignal</sup> `KastUpdated` - called when *KastInstance* updates `(kast : KastInstance, lastPosition : Vector3, direction : Vector3, displacement : number, velocity : Vector3, tracer : Instance)`
- <sup>RBXScriptSignal</sup> `RayHit` - called when *KastInstance* hits a surface `(kast : KastInstance, result : RaycastResult, velocity : Vector3, tracer : Instance)`
- <sup>RBXScriptSignal</sup> `RayPierced` - called when *KastInstance* penetrates a surface `(kast : KastInstance, result : RaycastResult, velocity : Vector3, tracer : Instance)`
- <sup>RBXScriptSignal</sup> `KastStopping` - called when *KastInstance* prepares to be terminated `(kast : KastInstance, tracer : Instance)`

**Functions**
- `Fire(origin : Vector3, direction : Vector3, velocity : number, kwikDataPacket : kwikData)` <sub>KastInstance</sub> - creates and runs a new *KastInstance*

### <sup>class</sup> `KwikData`

**Properties**
- <sup>RaycastParams</sup> `RaycastParams` - RaycastParams carried to each *KastInstance*
- <sup>Vector3</sup> `Acceleration` - acceleration of each *KastInstance*
- <sup>number</sup> `SimulationSpeed` - how fast the game will simulate each *KastInstance* (1 being normal speed)
- <sup>InstancePool</sup> `TracerPool` - *InstancePool* of which will be used for each *KastInstance*'s tracer
- <sup>number</sup> `MaxDistance` - how far each *KastInstance* may go before it must be terminated
- <sup>{any}</sup> `UserData` - information passed by the user to every *KastInstance*

### <sup>class</sup> `KastInstance`

**Properties**
- <sup>KwikKaster</sup> `Kaster` - *KwikKaster* object that fired *KastInstance*
- <sup>number</sup> `SimulationSpeed` - how fast the game will simulate *KastInstance* (inherited from *KwikData*)
- <sup>Vector3</sup> `Position` - current position of *KastInstance*
- <sup>Vector3</sup> `Velocity` - current velocity of *KastInstance*
- <sup>number</sup> `KastId` - unique ID assigned to *KastInstance*
- <sup>number</sup> `MaxDistance` - how far *KastInstance* may go before it is terminated (inherited from *KwikData*)
- <sup>number</sup> `Distance` - how far *KastInstance* has already travelled
- <sup>{KwikTrajectory}</sup> `Trajectories` - table containing precalculated math for the motion paths of the *KastInstance*
- <sup>Instance</sup> `Tracer` - cosmetic bullet object for *KastInstance*
- <sup>InstancePool</sup> `TracerPool` - *InstancePool* being used by *KastInstance* (inherited from *KwikData*)
- <sup>RaycastParams</sup> `RaycastParams` - RaycastParams used by *KastInstance* (inherited from *KwikData*)
- <sup>function</sup> `PierceFunction` - function that returns a boolean value for whether or not *KastInstance* is able to pierce a surface
- <sup>{any}</sup> `UserData` - user-provided information contained in *KastInstance* that can be changed and read from at any moment (inherited from *KwikData*)
- <sup>boolean</sup> `Active` - *KastInstance*'s current state of activity; will read false momentarily before *KastInstance* is terminated

**Functions**
- `EditTrajectory(position : Vector3, velocity : Vector3, acceleration : Vector3)` - modifies the trajectory of *KastInstance*; nil accepted for all parameters
- `Terminate()` - sets `Active` property of *KastInstance* to false
