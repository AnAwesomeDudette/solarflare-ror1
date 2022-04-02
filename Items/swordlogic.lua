local swordlogic = Item("Sword Logic")

swordlogic.sprite=Sprite.load("Resources/Sprites/swordlogic.png",1,16,9)
swordlogic.pickupText="Using non-primary skills unleashes a blade of Logic."
swordlogic:setTier("rare")

swordlogic:setLog{
    group="rare",
    description="&y&Attack for 60% damage&!& when &y&using skills.&!& &b&Consecutive hits&!& &r&increase damage by 6%,&!& &y&up to 180%&!&&lt&(+180%).&!& &lt&Doesn't activate on Primary.&!&",
    story="You are no longer bound by causal closure. Your will defeats law. Kill a hundred of your children with a long blade, &dk&survivor,&!& and observe the change in the blade. Observe how the universe shrinks from you in terror.",
	priority = "N/A",
	desination = "N/A",
	date = "N/A"
}

local sprSword = Sprite.load("Resources/Sprites/swordlogic_idle", 1, 4, 7)
local sprSwing = Sprite.load("Resources/Sprites/swordlogic_swing", 5, 24, 35)

objSwordLogic = Object.new("Sword Logic")
objSwordLogic.sprite = sprSword
objSwordLogic:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local parent = self:getData().parent
	self.spriteSpeed = 0.25
	self.subimage = 1
	self:getData().state = "idle"
	self:getData().xOffset = 0
	self:getData().yOffset = 0
	self:getData().yTrueOffset = 0
end)

objSwordLogic:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	if selfData.parent and selfData.parent:isValid() --[[and selfData.parent:get("dead") == 0]] then

		--[[CUSTOM SUBIMAGE HANDLER]]
		
		local function setCustomAnim(sprite, speed, scale)
			selfData.doCustomSubimage = true
			selfData.currentSprite = sprite
			selfData.spriteSpeed = speed*scale
			if not selfData.subimage then selfData.subimage = 1 end
		end
		
		local function doIdle(reset)
			selfData.state = "idle"
			selfData.doCustomSubimage = false
			self.sprite = sprSword
			self.subimage = 1
			self.spriteSpeed = 0
			if reset then
				selfData.xOffset = 0
			end
		end
		
		local relevantFrame = 0
		
		if selfData.doCustomSubimage then
			selfData.subimage = math.approach(selfData.subimage, selfData.currentSprite.frames, selfData.spriteSpeed)
			if not selfData.subhandler then selfData.subhandler = 0 end
			if selfData.subhandler ~= math.floor(selfData.subimage) then
				selfData.subhandler = math.floor(selfData.subimage)
				relevantFrame = math.floor(selfData.subimage)
			end
			--print(relevantFrame)
			--print(selfData.subimage)
			self.sprite = selfData.currentSprite
			self.subimage = selfData.subimage
		else
			selfData.subimage = nil
			selfData.subhandler = nil
			selfData.currentSprite = nil
			selfData.spriteSpeed = nil
		end
		selfData.doCustomSubimage = false
		
		if selfData.subimage == self.sprite.frames then
			selfData.subimage = 0
		end
		--[[END CUSTOM SUBIMAGE HANDLER]]
		
		local function movement(noTrack, perfect)
			local dir = -1
			
			local offset = math.sin(selfData.yOffset) * 2
			
			local truexscale = selfData.parent.xscale
			if noTrack then
				truexscale = self.xscale
			end
			
			local x = selfData.parent.x + (12*dir*truexscale) + selfData.xOffset
			local y = selfData.parent.y - 7
			local xx = math.max(math.abs(x - self.x), 2)
			local yy = math.max(math.abs(y - self.y), 1)
			xx = xx*math.sqrt(math.sqrt(math.abs(distance(self.x, self.y, selfData.parent.x, selfData.parent.y))))
			if not perfect then
				self.x = math.approach(self.x, x, xx*0.1)
				self.y = math.approach(self.y, y + offset, yy*0.1)
			else
				self.x = math.approach(self.x, x, xx*0.3)
				self.y = math.approach(self.y, y + selfData.yTrueOffset, yy*0.3)
			end
		end
		
		selfData.yOffset = selfData.yOffset + 1/60
		if selfData.yOffset > math.pi then
			selfData.yOffset = -math.pi
		end
		
		if selfData.state == "idle" then
			if selfData.parent:get("activity") >= 2 and selfData.parent:get("activity") <= 5 then
				selfData.state = "primary"
			else
				self.xscale = selfData.parent.xscale
				movement(false)
			end
		end
		if selfData.state == "primary" then
			local sprite = sprSwing
			setCustomAnim(sprite, 0.25, 1--[[selfData.parent:get("attack_speed")]])
			movement(true, true)
			
			if relevantFrame == 1 then
				self.xscale = selfData.parent.xscale
				selfData.xOffset = 17*self.xscale
				selfData.yTrueOffset = 8
			end
			
			if relevantFrame == 3 then
				local bullet = selfData.parent:fireExplosion(self.x+15*self.xscale, self.y-10*self.yscale, 30/19, 20/4, 0.6, nil, nil, DAMAGER_NO_PROC)
				--bullet:set("knockback", 4)
				--bullet:set("knockup", 3)
				--bullet:set("knockback_direction", self.xscale)
				bullet:getData().logic = true
				--addHitSFX(bullet, nil, sHit, 1 + (math.random(1, 4)/10), 0.8)
				
				--local sound = sSlash["1"]
				--sPlay(sound, self, 1.2, 0.9)
			end
			
			if selfData.subimage == 0 and (selfData.parent:get("activity") <= 2 or selfData.parent:get("activity") >= 5) then
				doIdle(true)
				selfData.xOffset = 0
				selfData.yTrueOffset = 0
			end
		end
	else
		self:destroy()
	end
end)

callback.register("preHit", function(damager, hit) 
	local parent = damager:getParent()
	if parent and parent:isValid() and hit and hit:isValid() then
		if damager:getData().logic then
			local mult 
			if not hit:getData().logic then
				mult = 1
				hit:getData().logic = 1
			else
				mult = 1 + (hit:getData().logic/10)
				hit:getData().logic = math.min(hit:getData().logic + 1, 30 * parent:getData().swordLogic)
			end
			damager:set("damage", damager:get("damage") * mult)
			damager:set("damage_fake", damager:get("damage"))
		end
	end
end)

local function spawnBlade(player)
	local blade = objSwordLogic:create(player.x, player.y)
	blade:getData().parent = player
	blade.depth = player.depth + 1; 
	player:getData().theBlade = blade
end

callback.register("onStageEntry", function()
	for _, actor in ipairs(ParentObject.find("actors"):findAll()) do
		if isa(actor, "PlayerInstance") then
			if actor:getData().swordLogic and actor:getData().swordLogic > 0 then
				spawnBlade(actor)
			end
		end
	end
end)

swordlogic:addCallback("pickup", function(player)
	player:getData().swordLogic = (player:getData().swordLogic or 0) + 1
	if not player:getData().theBlade then
		spawnBlade(player)
	end
end)

--needs drop code...

--debug spawner
archDebug = true
if archDebug then
callback.register("onPlayerInit", function(player)
	
	player:getData().timeBeforeSkatebordPogger = 1*60
	player:getData().GaveUASkatebordPoggersPoggers = false
	
end)

callback.register("onPlayerStep", function(player)
	
	player:getData().timeBeforeSkatebordPogger = math.approach(player:getData().timeBeforeSkatebordPogger, 0, 1)
	
	if player:getData().timeBeforeSkatebordPogger == 0
	and player:getData().GaveUASkatebordPoggersPoggers == false then
		swordlogic:create(player.x, player.y)
		player:getData().GaveUASkatebordPoggersPoggers = true
	end
	
end)
end