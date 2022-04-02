local sunkissed = EliteType("Sunkissed")
sunkissed.displayName="Sunkissed"
sunkissed.palette=Sprite.load("Resources/Sprites/sunkissed.png",1,0,0)
callback.register("onEliteInit",function(actor)
    local actorAc = actor:getAccessor()
	if actorAc.prefix_type == 1 then
		local elite = actor:getElite()
        if elite==sunkissed then
            local h = graphics.bindDepth(6,sunkissedBalls)
            local data=h:getData()
            data.player=actor
            data.scale=0
            data.rotator=0
        end
    end
end)
--[[callback.register("onActorInit",function(actor)
    actor:makeElite(sunkissed)
end)]]
function LoadElitesForMods(enemies, namespace,elite,deload)
	for k, v in ipairs(enemies) do
		local monsterCard = MonsterCard.find(v,namespace)
		if monsterCard then
			if deload then
				monsterCard.eliteTypes:remove(elite)
			else
				monsterCard.eliteTypes:add(elite)
			end
			--monsterCard.eliteTypes:add(eltGelatinous)
		end
		--eltCryptic.registerPalette(eltCryptic.palette,monsterCard:getObject())
	end

end
function sunkissedBalls(handler,frame)
    local data=handler:getData()
    if data.player==nil or not data.player:isValid() then
        handler:destroy()
    end
    local ballCount=3
    data.scale=lerp(data.scale,1,5/60)
    data.rotator=data.rotator+0.5
    for i=1,ballCount do
        local ballPosX,ballPosY=getAngleCoord(data.rotator+(i-1)*(360/ballCount),100*data.scale)
        graphics.color(Color(0xFEFFD1))
        graphics.line(data.player.x,data.player.y,data.player.x+ballPosX,data.player.y+ballPosY,3*data.scale)
        local scale=data.scale*math.abs(math.sin(frame/20))
        graphics.circle(data.player.x+ballPosX,data.player.y+ballPosY,50*data.scale,true)
        graphics.color(Color(0xFFD507))
        graphics.circle(data.player.x+ballPosX,data.player.y+ballPosY,50*scale)
        if frame%20==0 then
            data.player:fireExplosion(data.player.x+ballPosX,data.player.y+ballPosY,50/19*data.scale,50/4*data.scale,3,nil,nil)
        end 
    end
end


function loadElite(bool)

	local enemyArray = {"Lemurian", "Wisp", "Stone Golem","Archer Bug","Child","Evolved Lemurian"}
	LoadElitesForMods(enemyArray,"vanilla",sunkissed,bool)

	local enemyArray = {"Exploder", "Squall Elver"}
	LoadElitesForMods(enemyArray,"Starstorm",sunkissed,bool)

end

--loadElite(false)
