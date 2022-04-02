local pierce = Item("FTL Tenderizer")
pierce.sprite=Sprite.load("Resources/Sprites/pierce.png",2,17,17)
pierce:setTier("use")
pierce:setLog{
    group="use",
    description="Spawns a bubble where enemies that die inside explode into meat chunks."
}
pierce.pickupText="Spawns a bubble where enemies that die explode into meat chunks."
pierce.isUseItem=true
pierce.useCooldown=45

pierce:addCallback("use",function(player,embyro)
    local range = tern(embyro,300,150)
    local object=bubble:create(player.x,player.y)
    object:getData().color=tern(embryo,Color(255,153,153),Color(204,0,0))
end)

bubble = Object.new("Piercing Bubble")
bubble:addCallback("create",function(self)
    self:getData().color=Color.BLUE
    self:getData().rangeTarget=150
    self:getData().range=0
    self:getData().life=0
end)

bubble:addCallback("draw",function(self)
    self:getData().life=self:getData().life+1
    if self:getData().life>1200 then
        self:destroy()
    end
    self:getData().range=lerp(self:getData().range,self:getData().rangeTarget,10/60)
    graphics.color(self:getData().color)
    graphics.alpha(0.3)
    graphics.circle(self.x,self.y,self:getData().range,false)
    graphics.color(Color(255,0,0))
    graphics.alpha(1)
    graphics.circle(self.x,self.y,self:getData().range,true)

    if self:getData().life%20==0 then
        for __,enemy in pairs(pobj.enemies:findAllEllipse(self.x-self:getData().range,self.y-self:getData().range,self.x+self:getData().range,self.y+self:getData().range)) do
            par.Blood1:burst("above",enemy.x,enemy.y,10,nil)
        end
    end
end)

callback.register("onNPCDeath",function(npc)
    local x,y=npc.x,npc.y
    for __,object in pairs(bubble:findAll()) do
        if distance(object.x,object.y,x,y)<object:getData().range then
            for i=1,10 do
                local thing = obj.EfNugget:create(x,y-20)
              
            end
        end
    end
end)
--[[callback.register("onDamage",function(target,damage,source)
    if source and source:isValid() and isa(source,"DamagerInstance") then
        local parent=source:getParent()
        if parent and parent:isValid() and isa(parent,"PlayerInstance") then
            source:dumpVariables(true,true)

        end
    end
end)]]

--[[callback.register("onDamage",function(target,damage,source)
    if source and source:isValid() and isa(source,"DamagerInstance") then
        local parent=source:getParent()
        if parent and parent:isValid() and isa(parent,"PlayerInstance") then
            if source:get("damage_index")==528 then
                print("UWUUUU")
                local bullet = parent:fireBullet(parent.x,parent.y,source:get("direction"),source:get("bullet_speed"),source:get("damage")/parent:get("damage"),nil,DAMAGER_BULLET_PIERCE)
                print(bullet:get("damage_index"))
                return true
            end
        end
    end
end)]]

