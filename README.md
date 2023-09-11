# PlutoniumLib
Main library for all Plutonium Studio roblox scripting projects.

ROBLOX PAGE [HERE](https://www.roblox.com/library/13882575468/PlutoniumLib)

## Version 1.2
### Primer
- Built in optional cast visualization added
- Pierce function to determine whether or not a *CastInstance* may penetrate a surface
### Composter
- Name changed from **PartPool** to **Composter**

# Documentation

## <sup>module</sup> Composter

Composter intends to minimize lag with large loads of parts by means of recycling them. Unused parts are not reparented or deleted, but instead repositioned far outside rendering view to be used again.

**Functions**
- `Composter.new(template : Instance, precreatedParts : number, container : Instance)` <sub>InstancePool</sub> - creates an *InstancePool* object

### <sup>class</sup> `InstancePool`

Object containing your parts and basic **Composter** functions

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
local Part = Instance.new("Part")
Part.Anchored = true

local Container = Instance.new("Folder")
Container.Parent = game.Workspace

local newPool = Composter.new(part, 100, container)

while wait() do
  local newPart = newPool:GetPart()
  
  if #newPool.Available == 0 then
    newPool:ReturnPart(newPool.InUse[1])
  end
end
```



## <sup>module</sup> Primer

Primer can create fast, realistic projectiles for your FPS game.

**Functions**
- `Primer.new()` <sub>Caster</sub> - creates a *Caster* object
- `Primer.newDataPacket()` <sub>PrimerData</sub> - creates a *PrimerData* object

### <sup>class</sup> `Caster`

Object used to cast projectiles and connect functions to cast signals

**Properties**
- <sup>RBXScriptSignal</sup> `CastUpdated` - called when *CastInstance* updates `(cast : CastInstance, lastPosition : Vector3, direction : Vector3, displacement : number, velocity : Vector3, tracer : Instance)`
- <sup>RBXScriptSignal</sup> `RayHit` - called when *CastInstance* hits a surface `(cast : CastInstance, result : RaycastResult, velocity : Vector3, tracer : Instance)`
- <sup>RBXScriptSignal</sup> `RayPierced` - called when *CastInstance* penetrates a surface `(cast : CastInstance, result : RaycastResult, velocity : Vector3, tracer : Instance)`
- <sup>RBXScriptSignal</sup> `CastStopping` - called when *CastInstance* prepares to be terminated `(cast : CastInstance)`

**Functions**
- `Fire(origin : Vector3, direction : Vector3, velocity : number, primerDataPacket : primerData)` <sub>CastInstance</sub> - creates and runs a new *CastInstance*

### <sup>class</sup> `PrimerData`

Table of data governing projectiles casted with **Primer**

**Properties**
- <sup>RaycastParams</sup> `RaycastParams` - RaycastParams carried to each *CastInstance*
- <sup>Vector3</sup> `Acceleration` - acceleration of each *CastInstance*
- <sup>number</sup> `SimulationSpeed` - how fast the game will simulate each *CastInstance* (1 being normal speed)
- <sup>InstancePool</sup> `TracerPool` - *InstancePool* of which will be used for each *CastInstance*'s tracer
- <sup>number</sup> `MaxDistance` - how far each *CastInstance* may go before it must be terminated
- <sup>boolean</sup> `VisualizeCasts` - visualize the trajectory of each *CastInstance*
- <sup>{any}</sup> `UserData` - information passed by the user to every *CastInstance*
- <sup>number</sup> `Substeps` - segments between each update point in a *CastInstance*
- <sup>function</sup> `PierceFunction` - function that returns a boolean value for whether or not *CastInstance* is able to pierce a surface

### <sup>class</sup> `CastInstance`

Object to represent a projectile.

**Properties**
- <sup>PrimerCaster</sup> `Caster` - *PrimerCaster* object that fired *CastInstance*
- <sup>number</sup> `SimulationSpeed` - how fast the game will simulate *CastInstance* (inherited from *PrimerData*)
- <sup>Vector3</sup> `Position` - current position of *CastInstance*
- <sup>Vector3</sup> `Velocity` - current velocity of *CastInstance*
- <sup>number</sup> `CastId` - unique ID assigned to *CastInstance*
- <sup>number</sup> `MaxDistance` - how far *CastInstance* may go before it is terminated (inherited from *PrimerData*)
- <sup>number</sup> `Distance` - how far *CastInstance* has already travelled
- <sup>{PrimerTrajectory}</sup> `Trajectories` - table containing precalculated math for the motion paths of the *CastInstance*
- <sup>Instance</sup> `Tracer` - cosmetic bullet object for *CastInstance*
- <sup>InstancePool</sup> `TracerPool` - *InstancePool* being used by *CastInstance* (inherited from *PrimerData*)
- <sup>RaycastParams</sup> `RaycastParams` - RaycastParams used by *CastInstance* (inherited from *PrimerData*)
- <sup>boolean</sup> `Visualize` - visualize the trajectory of *CastInstance* (inherited from *PrimerData*)
- <sup>number</sup> `Substeps` - segments between each update point in *CastInstance* (inherited from *PrimerData*)
- <sup>function</sup> `PierceFunction` - function that returns a boolean value for whether or not *CastInstance* is able to pierce a surface (inherited from *PrimerData*)
- <sup>{any}</sup> `UserData` - user-provided information contained in *CastInstance* that can be changed and read from at any moment (inherited from *PrimerData*)
- <sup>boolean</sup> `Active` - *CastInstance*'s current state of activity; will read false momentarily before *CastInstance* is terminated

**Functions**
- `EditTrajectory(position : Vector3, velocity : Vector3, acceleration : Vector3)` - modifies the trajectory of *CastInstance*; nil accepted for all parameters
- `Terminate()` - sets `Active` property of *CastInstance* to false

**Code Example**

```lua
local Tracer = Instance.new("Part")
Tracer.Color = Color3.new(1, 0.5, 0.3)
Tracer.Material = Enum.Material.Neon
Tracer.Anchored = true
Tracer.CanCollide = false
Tracer.Size = Vector3.new(0.1, 0.1, 0.1)
Instance.new("SpecialMesh").Parent = Tracer
Tracer.Mesh.MeshType = Enum.MeshType.Sphere

local Container = Instance.new("Folder")
Container.Parent = game.Workspace

local Caster = Primer.new()

local PrimerData = Primer.newDataPacket()
PrimerData.RaycastParams.FilterDescendantsInstances = {Container}
PrimerData.Acceleration = Vector3.new(0, -196.2)
PrimerData.TracerPool = Composter.new(Tracer, 100, Container)
PrimerData.SimulationSpeed = 1

local Camera = game.Workspace.CurrentCamera

Caster.CastUpdated:Connect(function(cast, point, direction, length, velocity, bullet)
	if cast.UserData.LCP == nil then
		cast.UserData.LCP = CFrame.new(
			Camera.CFrame.RightVector:Dot(point-Camera.CFrame.Position),
			Camera.CFrame.UpVector:Dot(point-Camera.CFrame.Position),
			-Camera.CFrame.LookVector:Dot(point-Camera.CFrame.Position)
		)
	end

	local p0 = (Camera.CFrame*cast.UserData.LCP).Position
	local p1 = point+direction*length

	local disp = (p1-p0)

	bullet.CFrame = CFrame.new(p0+disp/2, p1)
	bullet.Size = Vector3.new(0.1, 0.1, disp.Magnitude)
	cast.UserData.LCP = CFrame.new(
		Camera.CFrame.RightVector:Dot(p1-Camera.CFrame.Position),
		Camera.CFrame.UpVector:Dot(p1-Camera.CFrame.Position),
		-Camera.CFrame.LookVector:Dot(p1-Camera.CFrame.Position)
	)
end)

Caster.RayHit:Connect(function(cast, result)
	print(result.Instance.Name)
end)

Caster:Fire(Vector3.new(0, 5, 0), Vector3.new(0, math.random(), math.random()), 800, self.PrimerData)
```

## <sup>module</sup> Loom

A module designed to record tables and dictionaries inside Roblox Datastores by converting them to strings.

**Functions**
- `Loom.new(name : string, type : LoomType)`<sub>LoomInstance</sub> - creates a *LoomInstance*

### <sup>type</sup> `LoomType`

Value of either "REGULAR" or "DICTIONARY"

### <sup>class</sup> `LoomInstance`

Object carrying a DataStore and all **Loom** functions

**Properties**
- <sup>string</sup> `Name` - name of *LoomInstance*
- <sup>DataStore</sup> `Name` - DataStore attached to *LoomInstance*
- <sup>LoomType</sup> `Type` - type of table stored using *LoomInstance*

**Functions**
- `Save(key : any, data : {any})` - saves a table using *LoomInstance*
- `Export(key : any)` <sub>{any}</sub> - extracts data from *LoomInstance*

## NEW FEATURES

**- Substeps**

Property of `PrimerData` and `CastInstance`

Amount of approximated segments between each cast update. Estimated using tick, origin, and velocity; may not be accurate. Values of 3 or higher will start to look strange.

**2x simulation speed;**
**0 substeps**
![RobloxScreenShot20230910_220932511](https://github.com/PlutoniumStudio/PlutoniumLib/assets/127816226/98b6f3a3-d93d-46f9-8a94-aca52e8c35eb)

**2x simulation speed;**
**2 substeps**
![RobloxScreenShot20230910_220937895](https://github.com/PlutoniumStudio/PlutoniumLib/assets/127816226/7760d518-5072-40d7-bb4f-80f7bcc3c0f1)
