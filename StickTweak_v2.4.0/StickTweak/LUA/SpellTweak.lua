

--[[
+----------+
| 法术调整 |
+----------+
--]]

--[[
+----------+
| 火焰护盾 |
+----------+
--]]
local counterSpellResList = {
    SPCL237D = true,
    SPWI418D = true,
    SPWI403D = true,
    SPPR730D = true,
}

ST_AddHitRollListener(function(sourceSprite, targetSprite, hitRoll)
	local matchedEffects = ST_FindEffectsAll(targetSprite, {m_effectId = 177}, false)
	
	for i = 1, #matchedEffects do
		local res = matchedEffects[i].m_res:get()
		if counterSpellResList[res] then
			EEex_GameObject_ApplyEffect(sourceSprite,{
				["effectID"] = 146,
				["effectList"] = 1,
				["effectAmount"] = 1,
				["dwFlags"] = 1,
				["durationType"] = 0,
				["res"] = res,
				["sourceID"] = targetSprite.m_id
				})
		end
	end
end)
