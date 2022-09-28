-- Modules
_Parent = script.Parent
_ExternalModules = _Parent._ExternalModules
Class = require(_ExternalModules.middleclass)

-- Classes
Utils = Class("package.HumanModule.Utils")


function Utils:_MapTables(source:table,dest:table)
	if not dest then
		dest = {}
	end
	
	for key,item in pairs(source) do
		dest[key] = item
	end
	
	return dest
end


return Utils
