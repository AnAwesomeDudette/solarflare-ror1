local pump = Item("Overclocked Infusion Pump")
pump.sprite=Sprite.load("Resources/Sprites/pump.png",1,16,16)
pump.pickupText="Doubles bleed damage."
pump:setTier("rare")
pump:setLog{
    group="rare",
    description="Bleed damage is doubled.",
    story="A disease was running rampant. Each day, the number infected seemed to double.\n\nCommonly, when someone was infected with similar diseases, an IV bag with a previously infected person's blood would help them recover.\n\nHowever, it was discovered too late that in this case uninfected blood was the required substance. It was estimed 99.9996% of the population had been infected, so supplies of this precious blood were low.\n\nUntil the man was found.\n\nImmediately deemed a fit candidate to supply clean blood, he was coerced into giving the rights to his physical body away to his government. Finally, after months of waiting..."
}
pump:addCallback("pickup",function(player)
    player:set("bleed",player:get("bleed")+0.3)
end)

callback.register("preHit", function(damager,hit)
    local parent = damager:getParent()
    if parent and parent:isValid() then
        if isa(parent,"PlayerInstance") then
            if damager:get("bleed")>0 then
                damager:set("bleed",damager:get("bleed")+3*parent:countItem(pump))
            end
        end
    end
	
end,-3000)