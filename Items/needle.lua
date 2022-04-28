local needle = Item("Unsanitary Needle")
needle.sprite=Sprite.load("Resources/Sprites/needle.png",1,16,16)
needle.pickupText="Enemies lose armor when bleeding."
needle:setTier("common")
needle:addCallback("pickup",function(player)
    player:set("bleed",player:get("bleed")+0.3)
end)
needle:setLog{
    group="common",
    description="Bleeding enemies lose 5 armor per bleed stack.",
    story="...the man's daughter arrived, horrified at his condition. She could barely look at him.\n\nShe had told her own daughter to stay outside the room, a command that the innocent child did not obey.\n\nThe child walked into the room, a look of indescribable terror plastered on her face.\n\nSeeing his family together for the last time, he whispered to them..."
}


local bleed = Object.find("DOT")
bleed:addCallback("create",function(self)
    self:getData().hasReducedArmor=false
end)

bleed:addCallback("destroy",function(self)
    local totalNeedles=0
    local dotObj = Object.findInstance(self:get("parent"))
    for __,player in pairs(misc.players) do
        totalNeedles = totalNeedles+player:countItem(needle)
    end
    if dotObj~= nil then
        dotObj:set("armor",dotObj:get("armor")+5*totalNeedles)
    end
    --log("Increased armor by "..5*totalNeedles)
end)


bloodEffect = Sprite.load("Resources/Sprites/bloodbadeffect.png",6,12,12)

callback.register("postStep", function()
	for _, dot in ipairs(Object.find("DOT"):findAll()) do
		if not dot:getData().hasReducedArmor then
            --dot:dumpVariables(true)
            dot:getData().hasReducedArmor =true
            local dotAc=dot:getAccessor()
            if dotAc.ticks==3 then
                local totalNeedles=0
                for __,player in pairs(misc.players) do
                    totalNeedles = totalNeedles+player:countItem(needle)
                end
                local dotObj = Object.findInstance(dot:get("parent"))
                if dotObj ~= nil then
                    dotObj:set("armor",dotObj:get("armor")-5*totalNeedles)
                    local s = obj.EfSparks:create(self.x, self.y + 16)
		            s.sprite = bloodEffect
                end
            end
            --log("Reduced armor by "..5*totalNeedles)
        end
	end
end,-300)



