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
- <sup>table</sup> `InUse` - parts currently being used by *InstancePool*
- <sup>table</sup> `Available` - parts not being used by *InstancePool*
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

### <sup>class</sup> `KwikKaster`

**Properties**
- <sup>RBXScriptSignal</sup> `KastUpdated` - called when *KastInstance* updates
- <sup>RBXScriptSignal</sup> `RayHit` - called when *KastInstance* hits a surface
- <sup>RBXScriptSignal</sup> `RayPierced` - called when *KastInstance* penetrates a surface
- <sup>RBXScriptSignal</sup> `KastStops` - called when *KastInstance* prepares to be terminated

**Functions**
- `Fire(origin : Vector3, direction : Vector3, velocity : number, kwikDataPacket : kwikData)` <sub>KastInstance</sub> - creates a new *KastInstance*
