
--[[
+--------------+
| 武器风格平衡 |
+--------------+
--]]
-- 语言
local ST_Text = {
	en_us = {
		weaponStylePrefix = "Weapon style used with one-handed weapons: ",
	},
	zh_cn = {
		weaponStylePrefix = "装备单手武器时使用风格：",
	},
}

local ST_Language = uiTranslationFile or "en_us"
local ST_CurrentText = ST_Text[ST_Language] or ST_Text.en_us

-- 加载2da列表
local strMod_2DA = EEex_Resource_Load2DA('STRMOD')
local strModEx_2DA = EEex_Resource_Load2DA('STRMODEX')
local dexMod_2DA = EEex_Resource_Load2DA('DEXMOD')
local styleBonus_2DA = EEex_Resource_Load2DA('STYLBONU')
local classWeaponBonus_2DA = EEex_Resource_Load2DA('CLSWPBON')
local kitList_2DA = EEex_Resource_Load2DA('KITLIST')

-- 建立映射表
local ST_ClassIdToClassCode = {
	[1]  = "MAGE",
	[2]  = "FIGHTER",
	[3]  = "CLERIC",
	[4]  = "THIEF",
	[5]  = "BARD",
	[6]  = "PALADIN",
	[7]  = "FIGHTER_MAGE",
	[8]  = "FIGHTER_CLERIC",
	[9]  = "FIGHTER_THIEF",
	[10] = "FIGHTER_MAGE_THIEF",
	[11] = "DRUID",
	[12] = "RANGER",
	[13] = "MAGE_THIEF",
	[14] = "CLERIC_MAGE",
	[15] = "CLERIC_THIEF",
	[16] = "FIGHTER_DRUID",
	[17] = "FIGHTER_MAGE_CLERIC",
	[18] = "CLERIC_RANGER",
	[19] = "SORCERER",
	[20] = "MONK",
	[21] = "SHAMAN",
}

local kitIdToKitCode = {}	-- 映射到 kitCode 的表
for rowIndex = 1, kitList_2DA.m_nSizeY - 1 do
	local kitCode = EEex_Resource_GetAt2DAPoint(kitList_2DA, 0, rowIndex)	
	if kitId then
		kitIdToKitCode[kitId] = kitCode
	end
end
kitIdToKitCode[0x00004015] = "LATHANDER"	-- 手动修复 0x00004015 重名错误

-- 顺势斩
ST_AddMeleeAttackListener(function(sourceSprite, targetSprite, blocked)
	local proficiency2H = ST_GetWeaponProficiency(sourceSprite, 111)
	
	if proficiency2H > 0 then	
		local _, naturalStyle = ST_GetCurrentWeapon(sourceSprite, true)
		local customStyle = EEex_Sprite_GetLocalInt(sourceSprite, "ST_FightingStyle")
		
		local resolvedStyle = naturalStyle
		if naturalStyle == 1 then
			resolvedStyle = customStyle
		end
		
		if resolvedStyle == 2 then
			EEex_GameObject_ApplyEffect(sourceSprite,{
				["effectID"] = 232,
--				["effectList"] = 1,
				["effectAmount"] = 0,
				["dwFlags"] = 12,
				["durationType"] = 0,
				["res"] = "STCLEAV",	-- STCLEAV.spl 调用 STCLEAVE.spl，便于战斗记录显示
				["sourceID"] = sourceSprite.m_id
				})
		end
	end
end)

function STCLEAVE(effect, targetSprite)
	local sourceSprite = EEex_GameObject_Get(effect.m_sourceId)
	
	local weaponRes, _ = ST_GetCurrentWeapon(sourceSprite, true)
	local proficiency2H = ST_GetWeaponProficiency(sourceSprite, 111)
	
	if st_currentAttack.sourceTag ~= "STCLEAVE" or (proficiency2H > 1) then
		st_currentAttack.sourceTag = "STCLEAVE"
		ST_MockAttack(sourceSprite, targetSprite, weaponRes)
	end

end

-- 武器风格调整值
EEex_Sprite_AddLoadedListener(function(sprite)	-- 加载sprite时为其初始化风格加值effect，不会重复添加
	local hitBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 278, m_sourceRes = "STWSRMOD"}, true)
	local damBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 73, m_sourceRes = "STWSRMOD"}, true)
	local acBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 0, m_sourceRes = "STWSRMOD"}, true)
	local speedBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 190, m_sourceRes = "STWSRMOD"}, true)
	local criticalBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 301, m_sourceRes = "STWSRMOD"}, true)
	local leftHandHitBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 305, m_sourceRes = "STWSRMOD"}, true)
	
	local aprBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 1, m_sourceRes = "STWSRMOD"}, true)
	
	if #hitBonusEffects == 0 then
		EEex_GameObject_ApplyEffect(sprite,{
			["effectID"] = 278,	-- 命中修正
			["effectList"] = 1,
			["effectAmount"] = 0,
			["dwFlags"] = 0,
			["durationType"] = 9,
			["m_sourceRes"] = "STWSRMOD",
			})
	end
	if #damBonusEffects == 0 then
		EEex_GameObject_ApplyEffect(sprite,{
			["effectID"] = 73,	-- 伤害修正
			["effectList"] = 1,
			["effectAmount"] = 0,
			["dwFlags"] = 0,
			["durationType"] = 9,
			["m_sourceRes"] = "STWSRMOD",
			})
	end
	if #acBonusEffects == 0 then
		EEex_GameObject_ApplyEffect(sprite,{
			["effectID"] = 0,	-- 防御修正
			["effectList"] = 1,
			["effectAmount"] = 0,
			["dwFlags"] = 0,
			["durationType"] = 9,
			["m_sourceRes"] = "STWSRMOD",
			})
	end
	if #speedBonusEffects == 0 then
		EEex_GameObject_ApplyEffect(sprite,{
			["effectID"] = 190,	-- 出手速度修正
			["effectList"] = 1,
			["effectAmount"] = 0,
			["dwFlags"] = 0,
			["durationType"] = 9,
			["m_sourceRes"] = "STWSRMOD",
			})
	end
	if #criticalBonusEffects == 0 then
		EEex_GameObject_ApplyEffect(sprite,{
			["effectID"] = 301,	-- 致命一击修正
			["effectList"] = 1,
			["effectAmount"] = 0,
			["dwFlags"] = 0,
			["durationType"] = 9,
			["m_sourceRes"] = "STWSRMOD",
			})
	end
	if #leftHandHitBonusEffects == 0 then
		EEex_GameObject_ApplyEffect(sprite,{
			["effectID"] = 305,	-- 副手命中修正
			["effectList"] = 1,
			["effectAmount"] = 0,
			["dwFlags"] = 0,
			["durationType"] = 9,
			["m_sourceRes"] = "STWSRMOD",
			})
	end
	if #aprBonusEffects == 0 then
		EEex_GameObject_ApplyEffect(sprite,{
			["effectID"] = 1,	-- APR修正
			["effectList"] = 1,
			["effectAmount"] = 0,
			["dwFlags"] = 0,
			["durationType"] = 9,
			["m_sourceRes"] = "STWSRMOD",
			})
	end	
	
	if (#hitBonusEffects == 0 * #damBonusEffects * #acBonusEffects * #speedBonusEffects * #criticalBonusEffects) == 0 then
		EEex_Sprite_SetLocalInt(sprite, 'ST_FightingStyle', 1)	-- 1 指定单手，2 指定双手
		EEex_GameObject_ApplyEffect(sprite,{
			["effectID"] = 171,
			["effectList"] = 1,
			["effectAmount"] = 0,
			["dwFlags"] = 0,
			["durationType"] = 0,
			["res"] = "STSTYLE",	-- 切换风格的 spl
			["sourceID"] = sprite.m_id,
			})
	end
end)

local lightWeaponProficiencies = {
	-- [90] = true, -- LONGSWORD
	[91] = true, -- SHORTSWORD
	-- [94] = true, -- KATANA
	[95] = true, -- SCIMITARWAKISASHININJATO
	[96] = true, -- DAGGER
	[115] = true, -- CLUB
}

local leftAPRBonus = {}
EEex_Opcode_AddListsResolvedListener(function(sprite)
	local rightWeaponRes, leftWeaponRes, naturalStyle = ST_GetCurrentWeapon(sprite, false)
	local customStyle = EEex_Sprite_GetLocalInt(sprite, "ST_FightingStyle")
	
	local resolvedStyle = naturalStyle
	if naturalStyle == 1 then
		resolvedStyle = customStyle
	end
	
	-- 初始化加成系数
	local hitBonus = 0
	local damBonus = 0
	local acBonus = 0
	local speedBonus = 0
	local criticalBonus = 0
	
	-- 武器风格熟练度
	local proficiency1H = ST_GetWeaponProficiency(sprite, 113)
	local proficiency2H = ST_GetWeaponProficiency(sprite, 111)
	local proficiency2W = ST_GetWeaponProficiency(sprite, 114)
	
	-- 自然风格是单手而指定风格是双手时的加值修正
	local function ResolveStyleBonusChange(proficiency1H, proficiency2H, rowLabel)
		local columnLabel1 = 'SINGLEWEAPON-' .. tostring(proficiency1H)
		local columnLabel2 = 'TWOHANDED-' .. tostring(proficiency2H)
		local value = EEex_Resource_GetAt2DALabels(styleBonus_2DA, rowLabel, columnLabel2) - EEex_Resource_GetAt2DALabels(styleBonus_2DA, rowLabel, columnLabel1)
		
		return value
	end

	if naturalStyle == 1 and resolvedStyle == 2 then
		hitBonus = ResolveStyleBonusChange(proficiency1H, proficiency2H, 'THAC0_RIGHT')
		damBonus = ResolveStyleBonusChange(proficiency1H, proficiency2H, 'DAMAGE_RIGHT')
		acBonus = -ResolveStyleBonusChange(proficiency1H, proficiency2H, 'AC_BASE')
		speedBonus = ResolveStyleBonusChange(proficiency1H, proficiency2H, 'SPEED')
		criticalBonus = ResolveStyleBonusChange(proficiency1H, proficiency2H, 'CRITICALROLL')
	end
	
	-- 双手武器风格提供额外0.5倍力量修正值
	local applyStrMod = false
	local applyExtraStrMod = false
	if rightWeaponRes then
		local abilityFlags = rightWeaponRes.pAbilities.abilityFlags
		applyStrMod = bit32.extract(abilityFlags, 0) == 1
	end
	if resolvedStyle == 2 then
		applyExtraStrMod = proficiency2H > 0 and applyStrMod
	end	
	-- 计算基础力量修正值
	local strModToHit = 0
	local strModToDam = 0
	local str = EEex_Sprite_GetStat(sprite, 36)
	if applyStrMod then
		strModToHit = strModToHit + EEex_Resource_GetAt2DALabels(strMod_2DA, 'TO_HIT', tostring(str))
		strModToDam = strModToDam + EEex_Resource_GetAt2DALabels(strMod_2DA, 'DAMAGE', tostring(str))
		if str == 18 then
			local strExtra = EEex_Sprite_GetStat(sprite, 37)
			strModToHit = strModToHit + EEex_Resource_GetAt2DALabels(strModEx_2DA, 'TO_HIT', tostring(strExtra))
			strModToDam = strModToDam + EEex_Resource_GetAt2DALabels(strModEx_2DA, 'DAMAGE', tostring(strExtra))
		end
	end
	-- 额外力量修正值
	if applyExtraStrMod then
		hitBonus = hitBonus + math.floor(strModToHit / 2)
		damBonus = damBonus + math.floor(strModToDam / 2)
	end
	
	-- 使用轻型武器时，单手武器风格可以用敏捷修正值取代力量修正值
	local applyDexModToHit  = false
	local applyDexModToDam  = false
	if resolvedStyle == 1 then
		local weaponProficiencyIndex = rightWeaponRes.pHeader.proficiencyType
		if lightWeaponProficiencies[weaponProficiencyIndex] then
			local weaponProficiency = ST_GetWeaponProficiency(sprite, weaponProficiencyIndex)
			applyDexModToHit = true						-- 无条件对命中提供敏捷加值
			applyDexModToDam = weaponProficiency > 0	-- 拥有该武器熟练度时对伤害提供敏捷加值
		end
	end	
	-- 计算敏捷修正值
	local dexModToHit = 0
	local dexModToDam = 0
	local dex = EEex_Sprite_GetStat(sprite, 40)
	if applyDexModToHit then
		dexModToHit = dexModToHit + EEex_Resource_GetAt2DALabels(dexMod_2DA, 'MISSILE', tostring(dex))
		if dexModToHit > strModToHit then
			hitBonus = hitBonus + dexModToHit - strModToHit
		end
	end
	if applyDexModToDam then
		dexModToDam = dexModToDam + EEex_Resource_GetAt2DALabels(dexMod_2DA, 'MISSILE', tostring(dex))
		if dexModToDam > strModToDam then
			damBonus = damBonus + dexModToDam - strModToHit
		end
	end
	
	-- 使用轻型武器时，双武器命中惩罚降低
	local leftHandHitBonus = 0
	if resolvedStyle == 4 then
		local weaponProficiencyIndex = leftWeaponRes.pHeader.proficiencyType
		if lightWeaponProficiencies[weaponProficiencyIndex] then
			local prof = math.max(0, math.min(4, proficiency2W))
			local dexModToHit2W = tonumber(EEex_Resource_GetAt2DALabels(dexMod_2DA, "MISSILE", tostring(dex))) or 0
			local baseHit = prof >= 2 and 0 or 2
			local capHit = prof == 0 and 2 or 0
			local mainHandDynamic = math.min(capHit, dexModToHit2W)
			local sharedHitBonus = baseHit + mainHandDynamic
			hitBonus = hitBonus + sharedHitBonus
			local targetOffHandCap = 4 - prof * 2
			local totalOffHandDynamic = math.min(targetOffHandCap, dexModToHit2W)
			local targetOffHandHitBonus = math.min(4, 4 + totalOffHandDynamic)
			leftHandHitBonus = targetOffHandHitBonus - sharedHitBonus
		end
	end
	
	-- 读取 STWSRMOD 提供的修正值effects
	local hitBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 278, m_sourceRes = "STWSRMOD"}, true)
	local damBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 73, m_sourceRes = "STWSRMOD"}, true)
	local acBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 0, m_sourceRes = "STWSRMOD"}, true)
	local speedBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 190, m_sourceRes = "STWSRMOD"}, true)
	local criticalBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 301, m_sourceRes = "STWSRMOD"}, true)
	local leftHandHitBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 305, m_sourceRes = "STWSRMOD"}, true)
	
	-- 应用修正值
	if #hitBonusEffects ~= 0 then
		local effect = hitBonusEffects[1]
		if effect.m_effectAmount ~= hitBonus then
			effect.m_effectAmount = hitBonus
		end
	end
	if #damBonusEffects ~= 0 then
		local effect = damBonusEffects[1]
		if effect.m_effectAmount ~= damBonus then
			effect.m_effectAmount = damBonus
		end
	end
	if #acBonusEffects ~= 0 then
		local effect = acBonusEffects[1]
		if effect.m_effectAmount ~= acBonus then
			effect.m_effectAmount = acBonus
		end
	end
	if #speedBonusEffects ~= 0 then
		local effect = speedBonusEffects[1]
		if effect.m_effectAmount ~= speedBonus then
			effect.m_effectAmount = speedBonus
		end
	end
	if #criticalBonusEffects ~= 0 then
		local effect = criticalBonusEffects[1]
		if effect.m_effectAmount ~= criticalBonus then
			effect.m_effectAmount = criticalBonus
		end
	end
	if #leftHandHitBonusEffects ~= 0 then
		local effect = leftHandHitBonusEffects[1]
		if effect.m_effectAmount ~= leftHandHitBonus then
			effect.m_effectAmount = leftHandHitBonus
		end
	end
	
	-- 双武器风格提供额外副手攻击次数
	local aprBonus = 0
	if resolvedStyle == 4 and proficiency2W >= 3 then
		local classId = sprite.m_typeAI.m_Class
		local kitIds = ST_GetAllKitIds(sprite)
		local codes = {ST_ClassIdToClassCode[classId]}

		for i = 1, #kitIds do
			local kitCode = kitIdToKitCode[kitIds[i]]
			if kitCode then
				table.insert(codes, kitCode)
			end
		end
		
		local getsProfAPR = false
		for i = 1, #codes do
			if EEex_Resource_GetAt2DALabels(classWeaponBonus_2DA, "GETS_PROF_APR", codes[i]) == '1' then
				getsProfAPR = true
				break
			end
		end
		
		if getsProfAPR then
			local leftProf = ST_GetWeaponProficiency(sprite, leftWeaponRes.pHeader.proficiencyType)
			if leftProf >= 2 and leftProf < 5 then
				aprBonus = 6	-- 半次攻击
				aprBonus = 6	-- 半次攻击
			elseif leftProf == 5 then
				aprBonus = 1	-- 一次攻击
			end
		end
	end
	leftAPRBonus[sprite.m_id] = aprBonus
	
	local aprBonusEffects = ST_FindEffects(sprite.m_timedEffectList, {m_effectId = 1, m_sourceRes = "STWSRMOD"}, true)
	if #aprBonusEffects ~= 0 then
		local effect = aprBonusEffects[1]
		if effect.m_effectAmount ~= aprBonus then
			effect.m_effectAmount = aprBonus
		end
	end
end)

function STSTYLE(effect, targetSprite)
	local customFightingStyle = EEex_Sprite_GetLocalInt(targetSprite, "ST_FightingStyle")
	
	local function FetchFightingStyleString(fightingStyle)
		local stringIndexTable = {
			[1] = 31137,
			[2] = 31135,
			[3] = 31136,
			[4] = 31138,
		}
		local fightingStyleString = Infinity_FetchString(stringIndexTable[fightingStyle])
		return fightingStyleString
	end
	
	customFightingStyle = 3 - customFightingStyle
	EEex_Sprite_SetLocalInt(targetSprite, "ST_FightingStyle", customFightingStyle)
	Infinity_DisplayString(ST_CurrentText.weaponStylePrefix .. FetchFightingStyleString(customFightingStyle))
	
	local spellList = targetSprite.m_memorizedSpellsInnate:getReference(0)
	ST_SetMemorizedSpellNum(targetSprite, "STSTYLE", 1, 0)
end

ST_AddAttackIndexListener(function(sourceSprite, targetSprite, attackIndex)
	local proficiency2W = ST_GetWeaponProficiency(sourceSprite, 114)
	local _, _, fightingStyle = ST_GetCurrentWeapon(sourceSprite, false)
	
	if fightingStyle == 4 and proficiency2W >= 3 and attackIndex == 2 then
		local bonus = leftAPRBonus[id]
		if bonus == 1 or (bonus == 6 and sourceSprite.m_nHalfSwingCounter % 2 == 0) then
			sourceSprite.m_leftAttack = 1
		end
	end
end)
