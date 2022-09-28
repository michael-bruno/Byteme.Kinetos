--[[
	Name:	HumanModuleV1
	Author:	stratus797
	System: Byteme.Kinetos
	Github:	https://github.com/michael-bruno/Byteme.Kinetos
	
	This purpose of this module is to subclass the default `Humanoid` object to add custom functionality.
	It also serves as a middleware in player-to-player interactions for use in the Byteme.Kinetos combat system.
--]]

-- MODULES
_ExternalModules = script._ExternalModules
Class = require(_ExternalModules.middleclass)

--Model = require(script.Model)
Utils = require(script.Utils)
Model = require(script.Model)


-- SERVICES
TweenService = game:GetService("TweenService")


-- HumanModule Definition
HumanModule = Class("package.HumanoidModule")


-- HumanModule.Params
HumanModule.Params = Class("package.HumanModule.Params")
function HumanModule.Params:initialize()
	self.MaxHealth = 100
	self.MagicResistance = 0
	self.Armor = 0
	self.MaxSpeed = 16
end


-- HumanModule.Mapping Definitions
HumanModule.States = {
	["IsAttacking"] 		= {Type="Bool"; Default=false};
	["IsBlocking"]			= {Type="Bool"; Default=false};
	["IsChanneling"] 		= {Type="Bool"; Default=false};
	["IsDodging"] 			= {Type="Bool"; Default=false};
	["IsMeleeEquipped"] 		= {Type="Bool"; Default=false};
	["IsSprinting"] 		= {Type="Bool"; Default=false};
}

HumanModule.Attributes = {
	["Shield"] 			= {Type="Number"; Default=50};
	["SpeedMultiplier"] 		= {Type="Number"; Default=1};
	["Stamina"] 			= {Type="Number"; Default=100};
	["Combo"] 			= {Type="Number"; Default=0};
}

HumanModule.Radiant = {
	["RadiantTimer"] 		= {Type="Number"; 	Default=0};
	["IsRadiant"] 			= {Type="Bool";		Default=false};
}

function HumanModule:initialize(player:Player,params:HumanModule.Params)
	self.Player = player
	self.Character = player.Character
	self.Humanoid = player.Character:FindFirstChild("Humanoid")
	print(self.Player,self.Character,self.Humanoid)

	self.States = Model.Table:new(player, Model.Params:new("States", HumanModule.States))
	self.Attributes = Model.Table:new(player, Model.Params:new("Attributes", HumanModule.Attributes))
	self.StatusEffects = Model.Table:new(player, Model.Params:new("StatusEffects", {}))
	
	local _BuffsParams = Model.Params:new("Buffs", {})
	_BuffsParams.ParentFolderName = "StatusEffects"
	_BuffsParams.UseParentFolder = true
	self.StatusEffects.Buffs = Model.Table:new(player, _BuffsParams)
	
	local _DebuffParams = Model.Params:new("Debuffs", {})
	_DebuffParams.ParentFolderName = "StatusEffects"
	_DebuffParams.UseParentFolder = true
	self.StatusEffects.Debuffs = Model.Table:new(player, _DebuffParams)
	
	-- StatusEffects.Buffs
	local _RadiantParams = Model.Params:new("Radiant", HumanModule.Radiant)
	_RadiantParams.ParentFolderName = "Buffs"
	_RadiantParams.UseParentFolder = true
	
	self.StatusEffects.Buffs.Radiant = Model.Table:new(player, _RadiantParams)
	
	self:_InitBindableFunctions()
end

function HumanModule:_InitBindableFunctions()
	self._Functions = Instance.new("Folder", self.Humanoid)
	self._Functions.Name = "Functions"
	self.Functions = {}
	
	self:_CreateFunction("Attack").OnInvoke = function(...)
		self:Attack(...)
	end
end


-- HumanModule Bindable Functions
function HumanModule:_CreateFunction(name)
	self.Functions[name] = Instance.new("BindableFunction", self._Functions)
	self.Functions[name].Name = name
	return self.Functions[name]
end


-- Humanoid.Functions Exposed BindableFunctions
function HumanModule:Attack(sender, damage, damage_type)
	print(self.Player,self.Character,self.Humanoid)

	print(sender, damage, damage_type)
	self.Humanoid:TakeDamage(damage)
end

return HumanModule
