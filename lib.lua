function getAngleCoord(angle, distance) 
	local radAngle = math.rad(angle)
	x = math.cos(radAngle) * distance
	y = math.sin(radAngle) * distance
	return x,y
end
-- Synced Object Spawn (with function!)
local funcs = {}
local syncInst = net.Packet.new("RPGInstSpawn", function(player, object, x, y, instid, funcid, other)
	local inst = object:create(x, y)
	if instid ~= false then
		inst:set("m_id", instid)
	end
	
	local arg
	if other then 
		if isa(other, "NetInstance") then
			arg = other:resolve()
		else
			arg = other
		end
	end
	if funcid then
		if funcs[funcid] then
			funcs[funcid](inst, arg)
		else
			error("Invalid ID: "..funcid, 2)
		end
	end
end)
function setFunc(func)
	table.insert(funcs, func)
	return #funcs
end
function createSynced(object, x, y, id, otherv)
	if net.host then
		local inst = object:create(x, y):set("sync", 0)
		if id then
			funcs[id](inst, otherv)
		end
		if net.online then
			local instid = setID(inst)
			local other = otherv
			if otherv and isa(otherv, "Instance") then
				if otherv.getNetIdentity then
					other = otherv:getNetIdentity()
				else
					other = nil
				end
			end
			syncInst:sendAsHost(net.ALL, nil, object, x, y, instid, id, other)
		end
	end
end

function contains(t, value)
	if t then
		for _, v in pairs(t) do
			if v == value then
				return true
			end
		end
		return false
	else
		return false
	end
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
function lerp(a,b,c)
    local diff = b-a
    return a + (diff*c)
end

ar = setmetatable({}, { __index = function(t, k)
	return Artifact.find(k)
end})
buff = setmetatable({}, { __index = function(t, k)
	return Buff.find(k)
end})
it = {}
for _, item in ipairs(Item.findAll("Vanilla")) do
	it[item:getName():gsub(" ", ""):gsub("'", "")] = item
end
par = setmetatable({}, { __index = function(t, k)
	return ParticleType.find(k)
end})

sfx = setmetatable({}, { __index = function(t, k)
	local sound = Sound.find(k)
	return sound:getRemap() or sound
end})
stg = {}
for _, stage in ipairs(Stage.findAll("Vanilla")) do
	stg[stage:getName():gsub(" ", "")] = stage
end
pobj = setmetatable({}, { __index = function(t, k)
	return ParentObject.find(k)
end})
obj = setmetatable({}, { __index = function(t, k)
	return Object.find(k)
end})
dif = setmetatable({}, { __index = function(t, k)
	return Difficulty.find(k)
end})
itp = setmetatable({}, { __index = function(t, k)
	return ItemPool.find(k)
end})


syncInteractableSpawn = net.Packet.new("SSInteractableSpawn", function(player, interactable, x, y)
	if interactable and x and y then
		local instance = interactable:create(x, y)
	end
end)

function getDirectionAxis(actor)
	if actor:getFacingDirection()==180 then
		return -1
	end
	return 1
end
function tern (bool,a,b)
	if bool then
		return a
	else
		return b
	end
end
function distance(x1, y1, x2, y2)
	local distance = math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
	return distance
end
function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function MakeOnGround(instance)
    for i=1,500 do
        if Stage.collidesPoint(instance.x,instance.y) then
            instance.y=  instance.y-1
        else
            break
        end
    end
end

function onScreen(instance)
	if instance and instance:isValid() then
		local camera = misc.camera
		local camerax = camera.x + (camera.width / 2)
		local cameray = camera.y + (camera.height / 2)
		
		if camera then
			local w, h = graphics.getHUDResolution()
			if camerax - (w / 2) - 20 < instance.x and camerax + (w / 2) + 20 > instance.x
			and cameray - (h / 2) - 20 < instance.y and cameray + (h / 2) + 20 > instance.y then
				return true
			end
		end
	end
end