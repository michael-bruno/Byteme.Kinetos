-- Modules
_Parent = script.Parent
_ExternalModules = _Parent._ExternalModules
Class = require(_ExternalModules.middleclass)

-- Classes
Model = Class("package.HumanModule.Model")
Model.Table = Class("package.HumanModule.Model.Table")
Model.Params = Class("package.HumanModule.Model.Params")
Model.Function = Class("package.HumanModule.Model.Function")

--[[
	"Model.Params" Usasge
		
		params = Utils.Params:new("States")
		params.Mapping = {
			["Shield"] 				= {Type="Number"; Default=50};
			["SpeedMultiplier"] 	= {Type="Number"; Default=1};
			["Stamina"] 			= {Type="Number"; Default=100};
			["Combo"] 				= {Type="Number"; Default=0};
		}
--]]

-- Model.Params
function Model.Params:initialize(name,map)
	self.Name = name
	self.Mapping = map
	
	self.UseParentFolder = nil
	self.ParentFolderName = nil
end

function Model:_CreateValueObject(str)
	return Instance.new(str.."Value")
end

-- Utils.Table.Meta
Model.Table._Meta = {
	[1] = "Character";
	[2] = "Humanoid";
}


-- Utils.Table
function Model.Table:initialize(player:Player, params:Model.Params)
	self.Character = player.Character
	self.Humanoid = self.Character:FindFirstChild("Humanoid")
	self:_Init(params)
end

function Model.Table:_Init(params:Utils.Params)

	if params.UseParentFolder then
		self._Folder = Instance.new("Folder", self.Humanoid:FindFirstChild(params.ParentFolderName,true))
	else
		self._Folder = Instance.new("Folder", self.Humanoid)
	end
	
	self._Folder.Name = params.Name
	
	self._Get = Instance.new("Folder", self._Folder)
	self._Get.Name = "Get"

	self._Set = Instance.new("Folder", self._Folder)
	self._Set.Name = "Set"

	self._Var = Instance.new("Folder", self._Folder)
	self._Var.Name = "Var"

	self._Bindings = {}
	self._MetaTable = {
		__call = function(t, key, value)
			local _var_key = "Var_"..key
			if key and value then
				self._Bindings[_var_key].Value = value
			elseif key then
				return self._Bindings[_var_key].Value
			end
		end
	}

	setmetatable(self,self._MetaTable)

	for key, param in params.Mapping do
		if not table.find(Model.Table._Meta, key) then
			self[key] = param.Default

			local _var_key = "Var_"..key
			self._Bindings[_var_key] = Model:_CreateValueObject(param.Type)
			self._Bindings[_var_key].Parent = self._Var
			self._Bindings[_var_key].Name = key
			self._Bindings[_var_key].Value = param.Default

			local _get_key = "Get_"..key
			self._Bindings[_get_key] = Instance.new("BindableFunction", self._Get)
			self._Bindings[_get_key].Name = key
			self._Bindings[_get_key].OnInvoke = function()
				return self(key)
			end

			local _set_key = "Set_"..key
			self._Bindings[_set_key] = Instance.new("BindableFunction", self._Set)
			self._Bindings[_set_key].Name = key
			self._Bindings[_set_key].OnInvoke = function(value)
				self(key,value)
			end
		end
	end
end

function Model.Function:initialize(player)
	self.Character = player.Character
	self.Humanoid = self.Character:FindFirstChild("Humanoid")
	
	self._Folder = Instance.new("Folder", self.Humanoid)
	self._Folder.Name = "Functions"
	self._Bindings = {}
end

function Model.Function:AddFunction(name, func)
	self._Bindings[name] = Instance.new("BindableFunction", self._Folder)
	self._Bindings[name].OnInvoke = func
	self._Bindings[name].Name = name
end

return Model
