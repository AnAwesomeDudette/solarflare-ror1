local nut=Item("Walnut")
nut.pickupText="nut"
nut.sprite=Sprite.load("Resources/Sprites/walnut.png",2,12,12)
nut.isUseItem=true
nut.useCooldown=35
nut:setTier("use")
nut:setLog{
    group="use",
    description="Create an interesting explosion that takes 70% of your health away.",
    story="The Nut Song\nNut Nut Nut / Nut Nut Nuuut / Nut Nut Nut \n\n Nut Nuuuuut / Nuuut Nuuut / Nuuut Nuuut Nuuut / Nuuut Nut / Nuuut Nuuut Nut\n\nNut Nut Nuuut / Nut Nut Nut\n\nThe author was lost to time."
}
walnutExplosion = Sprite.load("Resources/Sprites/boom.png",17,71,100)
boom = Sound.load("BOOMN", "Resources/Sounds/boom.wav") --can't you only load .ogg files ???
--.. huh . i am mistaken . go off queen , i am thoroughly impressed
nut:addCallback("use", function(player, embryo)
    local ac =player:getAccessor()
    local handler=graphics.bindDepth(-100,walnutBoom)
    handler:getData().sprite=walnutExplosion
    handler:getData().subimage=1
    handler:getData().x,handler:getData().y=player.x,player.y
    local damage = ac.maxhp_base*0.7
    ac.hp=math.clamp(ac.hp-damage,1,10000000000)
    damage=damage+ac.damage*7
    if embryo then
        damage=ac.damage*2
    end
    misc.shakeScreen(20)
    boom:play(1,1)
    ac.pVspeed=-4
    for __,enemy in pairs(pobj.enemies:findAllEllipse(player.x-150,player.y-150,player.x+150,player.y+150)) do
        enemy:set("hp",enemy:get("hp")-damage)
        misc.damage(damage,enemy.x+math.random(-15,15),enemy.y-20+math.random(-15,15),false,Color.RED)
    end
end)
function walnutBoom(handler,frame)
    if frame%2==0 then
        handler:getData().subimage=handler:getData().subimage+1
        if handler:getData().subimage==18 then
            handler:destroy()
        end
    end
    graphics.drawImage{
        x=handler:getData().x,
        y=handler:getData().y,
        image=handler:getData().sprite,
        subimage=handler:getData().subimage
    }
end