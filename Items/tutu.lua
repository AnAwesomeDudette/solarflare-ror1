local tutu = Item("Purification Beads")
tutu.sprite=Sprite.load("Resources/Sprites/beads.png",1,10,11)
tutu.pickupText="Applying bleed gives you a critical hit chance increase."
tutu:setTier("uncommon")
tutu:setLog{
    group="uncommon",
    description="Stacking Bleed gives you a 7% stacking crit chance increase.",
    story="\"...kill me. Kill me, and let my misery end.\"\n\nThe daughter could not fathom doing such a thing, but the child was taught to respect her elders at all costs. She was told to do what they said. Before the mother could stop her, the man was lifeless, a blade by his bed plunged straight into him.\n\nThe pair were deemed traitors for sabotaging a life-saving effort, with the mother being given the death penalty.\n\nThe daughter, however, was found to also be clean of the disease, and was chosen as a new source of blood.\nHer tutu is all that was able to be found in one piece."
}
tutu:addCallback("pickup",function(player)
    player:set("bleed",player:get("bleed")+0.3)
end)

callback.register("preHit", function(damager,hit)
    local parent = damager:getParent()
    if parent and parent:isValid() then
        if isa(parent,"PlayerInstance") then
            if damager:get("bleed")>0 then
                local count = parent:countItem(tutu)
                parent:set("critical_chance",parent:get("critical_chance")+7)
                local handler = graphics.bindDepth(0,critThing)
                handler:getData().duration = 120+120*(count-1)
                handler:getData().player=parent
            end
        end
    end
	
end,-300)

function critThing(handler,frame)
    if frame > handler:getData().duration then
        handler:getData().player:set("critical_chance",handler:getData().player:get("critical_chance")-7)
       
        handler:destroy()
    end

end