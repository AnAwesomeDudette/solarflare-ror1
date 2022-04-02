local gland = Item("Fracturegland")
gland.sprite=Sprite.load("Resources/Sprites/gland.png",1,16,16)
gland.pickupText="Crits apply Hemophilia, dealing damage when enemies get Bleeding."
gland.color = "y"
gland:setLog{
    group="boss",
    description="Crits apply Hemophilia, which deals 5 (+5) damage per stack when enemies Bleed.",
    story="The Hopoo looked curiously at this gland.\n\nThe Hopoo wondered if the Hopoo should touch it.\n\nThe hopoo said no, and went back to what it was doing."
}
gland:addCallback("pickup",function(player)
    player:set("critical_chance",player:get("critical_chance")+5)
end)

callback.register("onHit",function(damager,hit)
    local parent=damager:getParent()
    if parent and parent:isValid() and isa(parent,"PlayerInstance") then
        if parent:countItem(gland)>0 and damager:get("critical")==1 then
            if not hit:getData().hemophilia then
                hit:getData().hemophilia=0
            end
            hit:getData().hemophilia=hit:getData().hemophilia+1
            if hit:getData().hemophilia>50 then
                hit:getData().hemophilia=50
            end
        end
    end
end,-25)

local bleed = Object.find("DOT")
bleed:addCallback("create",function(self)
    self:getData().hasHemo=false
    local totalNeedles=0
    for __,player in pairs(misc.players) do
        totalNeedles = totalNeedles+player:countItem(gland)
    end
    self:getData().stacks=totalNeedles
end)

callback.register("postStep", function()
	for _, dot in ipairs(Object.find("DOT"):findAll()) do
		if not dot:getData().hasHemo then
            --dot:dumpVariables(true)
            dot:getData().hasHemo =true
            local dotAc=dot:getAccessor()
            if dotAc.ticks==3 then
                local dotObj = Object.findInstance(dot:get("parent"))
                if dotObj ~= nil and dotObj:get("invincible")<1 then
                    if dotObj:getData().hemophilia and dotObj:getData().hemophilia>0 then
                        local dmg = 5*dotObj:getData().hemophilia*dot:getData().stacks
                        dotObj:set("hp",dotObj:get("hp")-math.ceil(dmg*(100/(100+dotObj:get("armor")))))
                        misc.damage(math.ceil(dmg*(100/(100+dotObj:get("armor")))),dotObj.x+math.random(-15,15),dotObj.y+math.random(-15,15),false,Color.RED)
                    end
                end
            end
            --log("Reduced armor by "..5*totalNeedles)
        end
	end
end,-290)