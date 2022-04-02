local shades = Item("Stylish Shades")
shades.sprite=Sprite.load("Resources/Sprites/shades.png",1,16,8)
shades.pickupText="Gain armor when hit for a percentage of max HP."
shades:setLog{
	group="common",
	description="Gain 10 (+10) temporary armor when hit for >3% of max hp."
}
shades:setTier("common")
callback.register("preHit",function(damager,hit)
    if isa(hit,"PlayerInstance") then --i dont really enjoy making player-exclusive items,,,,,
		--hi past ash ! yeah why would you do that 
        if damager:get("damage")>hit:get("maxhp_base")*0.03 then
           
            local count = hit:countItem(shades)
            if count>0 then
                local amount = 10 * count
				hit:set("armor", hit:get("armor") + amount)
				if not hit:getData().removeArmor then hit:getData().removeArmor = {} end
				table.insert(hit:getData().removeArmor, {amount = amount, time = 5*60})
                --misc.shakeScreen(5)
            end
        end
    end
end,-9999)

callback.register("onPlayerStep", function(player)
	if player and player:isValid() then
		local playerData = player:getData()
		if playerData.removeArmor then
			for i = #playerData.removeArmor, 1, -1 do
				--print(playerData.removeArmor[i])
				playerData.removeArmor[i].time = math.approach(playerData.removeArmor[i].time, 0, 1)
				if playerData.removeArmor[i].time == 0 then
					player:set("armor", player:get("armor") - playerData.removeArmor[i].amount)
					table.remove(playerData.removeArmor, i)
				end
			end
		end
	end
end)