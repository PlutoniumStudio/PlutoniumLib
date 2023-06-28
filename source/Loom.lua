local Loom = {}
Loom.__index = Loom

local util = script.Parent.Util

local TypeLib = require(util.PlutoniumTypeLibrary)
type LoomInstance = TypeLib.LoomInstance

local DataStoreService = game:GetService("DataStoreService")

local function correctType(VALUE, TYPE)
	if TYPE == "number" then
		return tonumber(VALUE)
	elseif TYPE == "string" then
		return VALUE
	elseif TYPE == "boolean" then
		return (VALUE == "true")
	elseif TYPE == "nil" then
		return nil
	end
end

function Loom.new(NAME : string, TYPE : string) : LoomInstance
	return setmetatable({
		Name = NAME;
		Object = DataStoreService:GetDataStore(NAME);
		Type = TYPE or "REGULAR";
	}, Loom)
end

function Loom:Save(KEY, DATA)
	local SAVE = ""
	local ITERATIONS = 0
	
	for i, v in DATA do
		ITERATIONS += 1
	end
	
	if self.Type == "DICTIONARY" then
		for i, v in pairs(DATA) do
			SAVE = SAVE..i.."="..tostring(tostring(v))
			
			SAVE = SAVE..":"..tostring(typeof(v))
			
			ITERATIONS -= 1
			if ITERATIONS > 0 then
				SAVE = SAVE..","
			end
		end
	else
		for i, v in ipairs(DATA) do
			SAVE = SAVE..tostring(v)
			
			SAVE = SAVE..":"..tostring(typeof(v))
			
			ITERATIONS -= 1
			if ITERATIONS > 0 then
				SAVE = SAVE..","
			end
		end
	end
	
	local SUCCESS, ERROR_MESSAGE = pcall(function()
		self.Object:SetAsync(KEY, SAVE)
	end)
	
	if not SUCCESS then
		error(ERROR_MESSAGE, 2)
	end
end

function Loom:Export(KEY)
	local SUCCESS, DATA = pcall(function()
		return self.Object:GetAsync(KEY)
	end)
	
	if SUCCESS then
		local SEPARATED = string.split(DATA, ",")
		local EXPORT = {}
		
		for i, v in SEPARATED do
			if string.match(v, "=") then
				local SEGMENTS1 = string.split(v, "=")
				local OBJ = SEGMENTS1[1]
				local SEGMENTS2 = string.split(SEGMENTS1[2], ":")
				local VALUE = SEGMENTS2[1]
				local TYPE = SEGMENTS2[2]
				
				EXPORT[OBJ] = correctType(VALUE, TYPE)
			else
				local SEGMENTS = string.split(v, ":")
				local VALUE = SEGMENTS[1]
				local TYPE = SEGMENTS[2]
				
				table.insert(EXPORT, correctType(VALUE, TYPE))
			end
		end
		
		return EXPORT
	end
	
	return nil
end

return Loom
