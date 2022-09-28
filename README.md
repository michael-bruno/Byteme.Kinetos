# Byteme.Kinetos Combat Engine

## Example Usage

Configure RaycastHitbox Part and Invoke *Attack* Method on _Humanoid_
```lua
local RaycastHitbox = require(ReplicatedStorage.RaycastHitboxV4)

local NewHitbox = RaycastHitbox.new(part)
NewHitbox.OnHit:Connect(function(hit, human)
	if human then
		human.Functions["Attack"]:Invoke("Architect",10,0)
	end	
end)
```

## Structure
- ReplicatedStorage
  - [RaycastHitboxV4](https://github.com/Swordphin/raycastHitboxRbxl)
  - HumanModuleV1
    - Model:  _ModuleScript_
    - Utils:  _ModuleScript_
    - _ExternalModules
      - [middleclass](https://github.com/kikito/middleclass): _ModuleScript_
