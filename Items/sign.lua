local sign = Item("Neon Sign")
sign.sprite=Sprite.load("Resources/Sprites/sign.png",1,14,14)
sign.pickupText="Apply a Shocked effect onto enemies on hit."
sign:setTier("uncommon")
sign:setLog{
    group="uncommon",
    description="12% chance (+8% stacking) chance to Shock enemies onhit.",
    story="Given the success of the original Muc-Mart, we’ve decided to expand and open a new location on Venus! This here beaut has been shining her neons for decades now in the Earth location, thought we’d ship it off to the fresh lot to bring about a bit of luck. Lord knows we’ll need it. Maybe someday I’ll finally get around to finding someone to translate it."
}
callback.register("preHit",function(damager,hit)
    local parent = damager:getParent()
    if parent and parent:isValid() then
        if isa(parent,"PlayerInstance") and parent:countItem(sign)>0 then
            if math.chance(4+8*parent:countItem(sign))then
                hit:applyBuff(shocked,240)
                hit:getData().shockDamage=parent:get("damage")*0.4
            end
        end
    end
end)


shocked = Buff("Shocked")
shocked.sprite=Sprite.load("Resources/Sprites/shockBuff.png",1,3,8)
shocked:addCallback("step",function(actor,step)
    if step%10==0 then
        for __,object in pairs(pobj.Enemies:findAll()) do
            if object:collidesWith(actor,object.x,object.y) then
                --object:setAlarm(7,60)
                object:applyBuff(stunned,80)
            end
        end
    end
    if step%20==0 then
        actor:set("hp",actor:get("hp")-actor:getData().shockDamage)
        misc.damage(actor:getData().shockDamage,actor.x+math.random(-15,15),actor.y-20+math.random(-15,15),false,Color.BLUE)
    end
end)


stunned = Buff("Stunned")
stunned.sprite = Sprite.load("Resources/Sprites/stunBuff.png",7,3,8)
stunned.frameSpeed=0.5
stunned:addCallback("start",function(actor)
    actor:getData().pastSpeed=actor:get("pHmax") --that's scawy --yeah it also works.
    actor:set("pHmax",0) --fear ???
    actor:set("stunned",1)
end)
stunned:addCallback("end",function(actor)
    actor:set("pHmax",actor:getData().pastSpeed)
    actor:set("stunned",0)
end)