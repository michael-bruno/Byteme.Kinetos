# Byteme.Kinetos Combat Engine
Creates a custom Humanoid wrapper and allows users to create custom attributes, properties, and functions.
Exposes properties and methods as _Variable_ objects and _BindableFunctions_ found on the Humanoid object.

![fsm drawio (1)](https://user-images.githubusercontent.com/25409074/194193950-81c1f565-9c82-4e91-83af-67ad786764c6.png)

## Example Usage

Connect to _CharacterAdded_ Event and create _HumanModule_ instance
```lua
local HumanModule = require(ReplicatedStorage.HumanModuleV1)

Players.PlayerAdded:connect(function(player)
	player.CharacterAdded:Connect(LoadCharacter)
end)

function LoadCharacter(character)
	local player = Players:GetPlayerFromCharacter(character)

	local params = HumanModule.Params:new()
	local Human = HumanModule:new(player,params)
end
```

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

## Modules
- [RaycastHitboxV4](https://github.com/Swordphin/raycastHitboxRbxl)
- [middleclass](https://github.com/kikito/middleclass)
- [Knit](https://github.com/Sleitnick/Knit)
- [CameraShake](https://github.com/Sleitnick/RbxCameraShaker)
