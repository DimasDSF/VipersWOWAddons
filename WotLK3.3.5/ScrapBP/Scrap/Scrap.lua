--[[
Copyright 2008, 2009, 2010 João Cardoso
Scrap is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Scrap.

Scrap is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Scrap is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Scrap. If not, see <http://www.gnu.org/licenses/>.
--]]

local Tooltip = CreateFrame('GameTooltip', 'ScrapTooltip', nil, 'GameTooltipTemplate')
local Scrap = CreateFrame('Button', 'Scrap')
local STR_CLASS_WEAPON, STR_CLASS_ARMOR, STR_CLASS_BAG, STR_CLASS_CONSUMABLE, STR_CLASS_SYMBOLS, STR_CLASS_TRADEGOODS, STR_CLASS_AMMO, STR_CLASS_AMMUNITION, STR_CLASS_RECIPES, STR_CLASS_GEMS, STR_CLASS_MISC, STR_CLASS_QUEST = GetAuctionItemClasses()
local STR_SC_WEAPON_AXE1H, STR_SC_WEAPON_AXE2H, STR_SC_WEAPON_BOW, STR_SC_WEAPON_GUN, STR_SC_WEAPON_MACE1H, STR_SC_WEAPON_MACE2H, STR_SC_WEAPON_POLEARM, STR_SC_WEAPON_SWORD1H, STR_SC_WEAPON_SWORD2H, STR_SC_WEAPON_STAFF, STR_SC_WEAPON_WARGLAIVE, STR_SC_WEAPON_MISC, STR_SC_WEAPON_DAGGER, STR_SC_WEAPON_THROWN, STR_SC_WEAPON_CROSSBOW, STR_SC_WEAPON_WAND, STR_SC_WEAPON_FISHINGPOLES = GetAuctionItemSubClasses(1)
local STR_SC_ARMOR_OTHER, STR_SC_ARMOR_CLOTH, STR_SC_ARMOR_LEATHER, STR_SC_ARMOR_MAIL, STR_SC_ARMOR_PLATE, STR_SC_ARMOR_SHIELD, STR_SC_ARMOR_LIBRAM, STR_SC_ARMOR_IDOL, STR_SC_ARMOR_TOTEM, STR_SC_ARMOR_SIGIL = GetAuctionItemSubClasses(2)
local STR_SC_BAG_DEFAULT, STR_SC_BAG_SOUL, STR_SC_BAG_HERB, STR_SC_BAG_ENCHANT, STR_SC_BAG_ENGINEER, STR_SC_BAG_JEWELERY, STR_SC_BAG_MINING, STR_SC_BAG_LEATHER, STR_SC_BAG_INSCIPTION = GetAuctionItemSubClasses(3)
local STR_SC_CONSUMABLE_FOODDRINK, STR_SC_CONSUMABLE_POTIONS, STR_SC_CONSUMABLE_ELIXIRS, STR_SC_CONSUMABLE_BREWS, STR_SC_CONSUMABLE_BANDAGES, STR_SC_CONSUMABLE_UPGRADES, STR_SC_CONSUMABLE_SCROLLS, STR_SC_CONSUMABLE_OTHER = GetAuctionItemSubClasses(4)
local STR_SC_SYMBOLS_WARRIOR, STR_SC_SYMBOLS_PALADIN, STR_SC_SYMBOLS_HUNTER, STR_SC_SYMBOLS_ROGUE, STR_SC_SYMBOLS_PRIEST, STR_SC_SYMBOLS_DEATHKNIGHT, STR_SC_SYMBOLS_SHAMAN, STR_SC_SYMBOLS_MAGE, STR_SC_SYMBOLS_WARLOCK, STR_SC_SYMBOLS_DRUID = GetAuctionItemSubClasses(5)
local STR_SC_TRADEGOODS_ELEMENTAL, STR_SC_TRADEGOODS_CLOTH, STR_SC_TRADEGOODS_LEATHER, STR_SC_TRADEGOODS_METALSTONE, STR_SC_TRADEGOODS_MEAT, STR_SC_TRADEGOODS_HERB, STR_SC_TRADEGOODS_ENCHANTING, STR_SC_TRADEGOODS_JEWEL, STR_SC_TRADEGOODS_PARTS, STR_SC_TRADEGOODS_DEVICE, STR_SC_TRADEGOODS_EXPLOSIVE, STR_SC_TRADEGOODS_MATERIAL, STR_SC_TRADEGOODS_OTHER, STR_SC_TRADEGOODS_ARMORENCHANT, STR_SC_TRADEGOODS_WEAPONENCHANT = GetAuctionItemSubClasses(6)
local STR_SC_AMMO_ARROW, STR_SC_AMMO_BULLET = GetAuctionItemSubClasses(7)
local STR_SC_AMMUNITION_QUIVER, STR_SC_AMMUNITION_UNDERBAG = GetAuctionItemSubClasses(8)
local STR_SC_RECIPES_BOOK, STR_SC_RECIPES_LEATHERWORKING, STR_SC_RECIPES_CLOTHWORKING, STR_SC_RECIPES_ENGINEERING, STR_SC_RECIPES_BLACKSMITHING, STR_SC_RECIPES_COOKING, STR_SC_RECIPES_ALCHEMY, STR_SC_RECIPES_FIRSTAID, STR_SC_RECIPES_ENCHANTING, STR_SC_RECIPES_FISHING, STR_SC_RECIPES_JEWELCRAFTING, STR_SC_RECIPES_INSCRIPTION = GetAuctionItemSubClasses(9)
local STR_SC_GEMS_RED, STR_SC_GEMS_BLUE, STR_SC_GEMS_YELLOW, STR_SC_GEMS_VIOLET, STR_SC_GEMS_GREEN, STR_SC_GEMS_ORANGE, STR_SC_GEMS_SPECIAL, STR_SC_GEMS_SIMPLE, STR_SC_GEMS_PRISMATIC = GetAuctionItemSubClasses(10)
local STR_SC_MISC_JUNK, STR_SC_MISC_REAGENTS, STR_SC_MISC_PETS, STR_SC_MISC_HOLIDAY, STR_SC_MISC_OTHER, STR_SC_MISC_MOUNTS = GetAuctionItemSubClasses(11)
local STR_TS_MINING, STR_TS_HERBALISM, STR_TS_SKINNING, STR_TS_LEATHERWORKING, STR_TS_CLOTHWORKING, STR_TS_ENGINEERING, STR_TS_BLACKSMITHING, STR_TS_ALCHEMY, STR_TS_ENCHANTING, STR_TS_FISHING, STR_TS_JEWELCRAFTING, STR_TS_INSCRIPTION, STR_TS_COOKING, STR_TS_FIRSTAID
local tradeskillIDs = {nil, nil}
local sectradeskillIDs = {}

function Scrap:BuildLocalizedTradeskills()
	STR_TS_MINING = select(1, GetSpellInfo(32606))
	STR_TS_HERBALISM = select(1, GetSpellInfo(9134))
	STR_TS_SKINNING = select(1,GetSpellInfo(8613))
	STR_TS_LEATHERWORKING = STR_SC_RECIPES_LEATHERWORKING
	STR_TS_CLOTHWORKING = STR_SC_RECIPES_CLOTHWORKING
	STR_TS_ENGINEERING = STR_SC_RECIPES_ENGINEERING
	STR_TS_BLACKSMITHING = STR_SC_RECIPES_BLACKSMITHING
	STR_TS_ALCHEMY = STR_SC_RECIPES_ALCHEMY
	STR_TS_ENCHANTING = STR_SC_RECIPES_ENCHANTING
	STR_TS_FISHING = STR_SC_RECIPES_FISHING
	STR_TS_JEWELCRAFTING = STR_SC_RECIPES_JEWELCRAFTING
	STR_TS_INSCRIPTION = STR_SC_RECIPES_INSCRIPTION
	STR_TS_COOKING = STR_SC_RECIPES_COOKING
	STR_TS_FIRSTAID = STR_SC_RECIPES_FIRSTAID
	--self:DevFindProfessionSkill("Травничество")
	self:UpdateProfessionData()
end

function Scrap:DevFindProfessionSkill(prof)
	for i=1, 200000 do
		if select(1, GetSpellInfo(i)) == prof then
			ChatFrame1:AddMessage(i..": "..GetSpellInfo(i))
			break
		end
	end
end

function Scrap:UpdateProfessionData()
	for i=1, 22 do
		local sli = GetSkillLineInfo(i)
		local profs = {[STR_TS_MINING] = true, [STR_TS_HERBALISM] = true, [STR_TS_SKINNING] = true, [STR_TS_LEATHERWORKING] = true, [STR_TS_CLOTHWORKING] = true, [STR_TS_ENGINEERING] = true, 
		[STR_TS_BLACKSMITHING] = true, [STR_TS_ALCHEMY] = true, [STR_TS_ENCHANTING] = true, [STR_TS_JEWELCRAFTING] = true, [STR_TS_INSCRIPTION] = true}
		local secondaryprofs = {[STR_TS_FIRSTAID] = true, [STR_TS_COOKING] = true, [STR_TS_FISHING] = true}
		if profs[select(1,sli)] then
			if tradeskillIDs[1] == nil then
				tradeskillIDs[1] = {
					id = i,
					name = select(1, sli)
				}
				ChatFrame1:AddMessage("id: "..i..":1 : "..select(1,sli))
			else
				tradeskillIDs[2] = {
					id = i,
					name = select(1, sli)
				}
				ChatFrame1:AddMessage("id: "..i..":2 : "..select(1,sli))
			end
		end
		if secondaryprofs[select(1,sli)] then
			sectradeskillIDs[select(1,sli)] = {
				id = i,
				name = select(1, sli)
			}
			ChatFrame1:AddMessage("id: "..i..":secondary : "..select(1,sli))
		end
	end
	ChatFrame1:AddMessage("|cffffd200[Scrap]:|rInitialized Localized TradeSkill Names.")
end

function Scrap:DebugPrint(...)
	ChatFrame1:AddMessage(...)
end

function Scrap:HasProfession(prof)
	if tradeskillIDs[1] == nil and tradeskillIDs[2] == nil then
		self:UpdateProfessionData()
	end
	return tradeskillIDs[1] and self:GetTradeSkillLevelInfo(1).name == prof or tradeskillIDs[2] and self:GetTradeSkillLevelInfo(2).name == prof or sectradeskillIDs[prof] and select(1, GetSkillLineInfo(sectradeskillIDs[prof].id)) == prof
end

function Scrap:GetProfessionLevels(prof)
	local tradeskills = {self:GetTradeSkillLevelInfo(1), self:GetTradeSkillLevelInfo(2)}
	if tradeskills[1] and tradeskills[1].name == prof then
		return {current = tradeskills[1].level, max = tradeskills[1].maxlevel}
	elseif tradeskillIDs[2] and tradeskills[2].name == prof then
		return {current = tradeskills[2].level, max = tradeskills[2].maxlevel}
	elseif sectradeskillIDs[prof] ~= nil then
		return {name = select(1, GetSkillLineInfo(sectradeskillIDs[prof].id)), level = select(4, GetSkillLineInfo(sectradeskillIDs[prof].id)), maxlevel = select(7, GetSkillLineInfo(sectradeskillIDs[prof].id))}
	end
	return {current = 0, max = 0}
end

function Scrap:GetTradeSkillLevelInfo(num)
	if tradeskillIDs[num] ~= nil then
		return {name = select(1, GetSkillLineInfo(tradeskillIDs[num].id)), level = select(4, GetSkillLineInfo(tradeskillIDs[num].id)), maxlevel = select(7, GetSkillLineInfo(tradeskillIDs[num].id))}
	end
	return nil
end

local Unusable_Equipment = {
	['DEATHKNIGHT'] = {
		[STR_SC_ARMOR_OTHER] = false,
		[STR_SC_ARMOR_CLOTH] = false,
		[STR_SC_ARMOR_LEATHER] = false,
		[STR_SC_ARMOR_MAIL] = false,
		[STR_SC_ARMOR_PLATE] = false,
		[STR_SC_ARMOR_SHIELD] = true,
		[STR_SC_ARMOR_LIBRAM] = true,
		[STR_SC_ARMOR_IDOL] = true,
		[STR_SC_ARMOR_TOTEM] = true,
		[STR_SC_ARMOR_SIGIL] = false,
		[STR_SC_WEAPON_AXE1H] = false,
		[STR_SC_WEAPON_AXE2H] = false,
		[STR_SC_WEAPON_BOW] = true,
		[STR_SC_WEAPON_GUN] = true,
		[STR_SC_WEAPON_MACE1H] = false,
		[STR_SC_WEAPON_MACE2H] = false,
		[STR_SC_WEAPON_POLEARM] = false,
		[STR_SC_WEAPON_SWORD1H] = false,
		[STR_SC_WEAPON_SWORD2H] = false,
		[STR_SC_WEAPON_STAFF] = true,
		[STR_SC_WEAPON_WARGLAIVE] = true,
		[STR_SC_WEAPON_MISC] = false,
		[STR_SC_WEAPON_DAGGER] = true,
		[STR_SC_WEAPON_THROWN] = true,
		[STR_SC_WEAPON_CROSSBOW] = true,
		[STR_SC_WEAPON_WAND] = true,
		[STR_SC_WEAPON_FISHINGPOLES] = false,
	},
	['DRUID'] = {
		[STR_SC_ARMOR_OTHER] = false,
		[STR_SC_ARMOR_CLOTH] = false,
		[STR_SC_ARMOR_LEATHER] = false,
		[STR_SC_ARMOR_MAIL] = true,
		[STR_SC_ARMOR_PLATE] = true,
		[STR_SC_ARMOR_SHIELD] = true,
		[STR_SC_ARMOR_LIBRAM] = true,
		[STR_SC_ARMOR_IDOL] = false,
		[STR_SC_ARMOR_TOTEM] = true,
		[STR_SC_ARMOR_SIGIL] = true,
		[STR_SC_WEAPON_AXE1H] = true,
		[STR_SC_WEAPON_AXE2H] = true,
		[STR_SC_WEAPON_BOW] = true,
		[STR_SC_WEAPON_GUN] = true,
		[STR_SC_WEAPON_MACE1H] = false,
		[STR_SC_WEAPON_MACE2H] = false,
		[STR_SC_WEAPON_POLEARM] = false,
		[STR_SC_WEAPON_SWORD1H] = true,
		[STR_SC_WEAPON_SWORD2H] = true,
		[STR_SC_WEAPON_STAFF] = false,
		[STR_SC_WEAPON_WARGLAIVE] = false,
		[STR_SC_WEAPON_MISC] = false,
		[STR_SC_WEAPON_DAGGER] = false,
		[STR_SC_WEAPON_THROWN] = true,
		[STR_SC_WEAPON_CROSSBOW] = true,
		[STR_SC_WEAPON_WAND] = true,
		[STR_SC_WEAPON_FISHINGPOLES] = false
	},
	['HUNTER'] = {
		[STR_SC_ARMOR_OTHER] = false,
		[STR_SC_ARMOR_CLOTH] = false,
		[STR_SC_ARMOR_LEATHER] = false,
		[STR_SC_ARMOR_MAIL] = false,
		[STR_SC_ARMOR_PLATE] = true,
		[STR_SC_ARMOR_SHIELD] = true,
		[STR_SC_ARMOR_LIBRAM] = true,
		[STR_SC_ARMOR_IDOL] = true,
		[STR_SC_ARMOR_TOTEM] = true,
		[STR_SC_ARMOR_SIGIL] = true,
		[STR_SC_WEAPON_AXE1H] = false,
		[STR_SC_WEAPON_AXE2H] = false,
		[STR_SC_WEAPON_BOW] = false,
		[STR_SC_WEAPON_GUN] = false,
		[STR_SC_WEAPON_MACE1H] = true,
		[STR_SC_WEAPON_MACE2H] = true,
		[STR_SC_WEAPON_POLEARM] = false,
		[STR_SC_WEAPON_SWORD1H] = false,
		[STR_SC_WEAPON_SWORD2H] = false,
		[STR_SC_WEAPON_STAFF] = false,
		[STR_SC_WEAPON_WARGLAIVE] = false,
		[STR_SC_WEAPON_MISC] = false,
		[STR_SC_WEAPON_DAGGER] = false,
		[STR_SC_WEAPON_THROWN] = false,
		[STR_SC_WEAPON_CROSSBOW] = false,
		[STR_SC_WEAPON_WAND] = true,
		[STR_SC_WEAPON_FISHINGPOLES] = false
	},
	['MAGE'] = {
		[STR_SC_ARMOR_OTHER] = false,
		[STR_SC_ARMOR_CLOTH] = false,
		[STR_SC_ARMOR_LEATHER] = true,
		[STR_SC_ARMOR_MAIL] = true,
		[STR_SC_ARMOR_PLATE] = true,
		[STR_SC_ARMOR_SHIELD] = true,
		[STR_SC_ARMOR_LIBRAM] = true,
		[STR_SC_ARMOR_IDOL] = true,
		[STR_SC_ARMOR_TOTEM] = true,
		[STR_SC_ARMOR_SIGIL] = true,
		[STR_SC_WEAPON_AXE1H] = true,
		[STR_SC_WEAPON_AXE2H] = true,
		[STR_SC_WEAPON_BOW] = true,
		[STR_SC_WEAPON_GUN] = true,
		[STR_SC_WEAPON_MACE1H] = true,
		[STR_SC_WEAPON_MACE2H] = true,
		[STR_SC_WEAPON_POLEARM] = true,
		[STR_SC_WEAPON_SWORD1H] = false,
		[STR_SC_WEAPON_SWORD2H] = true,
		[STR_SC_WEAPON_STAFF] = false,
		[STR_SC_WEAPON_WARGLAIVE] = true,
		[STR_SC_WEAPON_MISC] = false,
		[STR_SC_WEAPON_DAGGER] = false,
		[STR_SC_WEAPON_THROWN] = true,
		[STR_SC_WEAPON_CROSSBOW] = true,
		[STR_SC_WEAPON_WAND] = false,
		[STR_SC_WEAPON_FISHINGPOLES] = false
	},
	['PALADIN'] = {
		[STR_SC_ARMOR_OTHER] = false,
		[STR_SC_ARMOR_CLOTH] = false,
		[STR_SC_ARMOR_LEATHER] = false,
		[STR_SC_ARMOR_MAIL] = false,
		[STR_SC_ARMOR_PLATE] = false,
		[STR_SC_ARMOR_SHIELD] = false,
		[STR_SC_ARMOR_LIBRAM] = false,
		[STR_SC_ARMOR_IDOL] = true,
		[STR_SC_ARMOR_TOTEM] = true,
		[STR_SC_ARMOR_SIGIL] = true,
		[STR_SC_WEAPON_AXE1H] = false,
		[STR_SC_WEAPON_AXE2H] = false,
		[STR_SC_WEAPON_BOW] = true,
		[STR_SC_WEAPON_GUN] = true,
		[STR_SC_WEAPON_MACE1H] = false,
		[STR_SC_WEAPON_MACE2H] = false,
		[STR_SC_WEAPON_POLEARM] = false,
		[STR_SC_WEAPON_SWORD1H] = false,
		[STR_SC_WEAPON_SWORD2H] = false,
		[STR_SC_WEAPON_STAFF] = true,
		[STR_SC_WEAPON_WARGLAIVE] = true,
		[STR_SC_WEAPON_MISC] = false,
		[STR_SC_WEAPON_DAGGER] = true,
		[STR_SC_WEAPON_THROWN] = true,
		[STR_SC_WEAPON_CROSSBOW] = true,
		[STR_SC_WEAPON_WAND] = true,
		[STR_SC_WEAPON_FISHINGPOLES] = false
	},
	['PRIEST'] = {
		[STR_SC_ARMOR_OTHER] = false,
		[STR_SC_ARMOR_CLOTH] = false,
		[STR_SC_ARMOR_LEATHER] = true,
		[STR_SC_ARMOR_MAIL] = true,
		[STR_SC_ARMOR_PLATE] = true,
		[STR_SC_ARMOR_SHIELD] = true,
		[STR_SC_ARMOR_LIBRAM] = true,
		[STR_SC_ARMOR_IDOL] = true,
		[STR_SC_ARMOR_TOTEM] = true,
		[STR_SC_ARMOR_SIGIL] = true,
		[STR_SC_WEAPON_AXE1H] = true,
		[STR_SC_WEAPON_AXE2H] = true,
		[STR_SC_WEAPON_BOW] = true,
		[STR_SC_WEAPON_GUN] = true,
		[STR_SC_WEAPON_MACE1H] = false,
		[STR_SC_WEAPON_MACE2H] = true,
		[STR_SC_WEAPON_POLEARM] = true,
		[STR_SC_WEAPON_SWORD1H] = true,
		[STR_SC_WEAPON_SWORD2H] = true,
		[STR_SC_WEAPON_STAFF] = false,
		[STR_SC_WEAPON_WARGLAIVE] = true,
		[STR_SC_WEAPON_MISC] = false,
		[STR_SC_WEAPON_DAGGER] = false,
		[STR_SC_WEAPON_THROWN] = true,
		[STR_SC_WEAPON_CROSSBOW] = true,
		[STR_SC_WEAPON_WAND] = false,
		[STR_SC_WEAPON_FISHINGPOLES] = false
	},
	['ROGUE'] = {
		[STR_SC_ARMOR_OTHER] = false,
		[STR_SC_ARMOR_CLOTH] = false,
		[STR_SC_ARMOR_LEATHER] = false,
		[STR_SC_ARMOR_MAIL] = true,
		[STR_SC_ARMOR_PLATE] = true,
		[STR_SC_ARMOR_SHIELD] = true,
		[STR_SC_ARMOR_LIBRAM] = true,
		[STR_SC_ARMOR_IDOL] = true,
		[STR_SC_ARMOR_TOTEM] = true,
		[STR_SC_ARMOR_SIGIL] = true,
		[STR_SC_WEAPON_AXE1H] = false,
		[STR_SC_WEAPON_AXE2H] = true,
		[STR_SC_WEAPON_BOW] = false,
		[STR_SC_WEAPON_GUN] = false,
		[STR_SC_WEAPON_MACE1H] = false,
		[STR_SC_WEAPON_MACE2H] = true,
		[STR_SC_WEAPON_POLEARM] = true,
		[STR_SC_WEAPON_SWORD1H] = false,
		[STR_SC_WEAPON_SWORD2H] = true,
		[STR_SC_WEAPON_STAFF] = true,
		[STR_SC_WEAPON_WARGLAIVE] = false,
		[STR_SC_WEAPON_MISC] = false,
		[STR_SC_WEAPON_DAGGER] = false,
		[STR_SC_WEAPON_THROWN] = false,
		[STR_SC_WEAPON_CROSSBOW] = false,
		[STR_SC_WEAPON_WAND] = true,
		[STR_SC_WEAPON_FISHINGPOLES] = false
	},
	['SHAMAN'] = {
		[STR_SC_ARMOR_OTHER] = false,
		[STR_SC_ARMOR_CLOTH] = false,
		[STR_SC_ARMOR_LEATHER] = false,
		[STR_SC_ARMOR_MAIL] = false,
		[STR_SC_ARMOR_PLATE] = true,
		[STR_SC_ARMOR_SHIELD] = false,
		[STR_SC_ARMOR_LIBRAM] = true,
		[STR_SC_ARMOR_IDOL] = true,
		[STR_SC_ARMOR_TOTEM] = true,
		[STR_SC_ARMOR_SIGIL] = true,
		[STR_SC_WEAPON_AXE1H] = false,
		[STR_SC_WEAPON_AXE2H] = false,
		[STR_SC_WEAPON_BOW] = true,
		[STR_SC_WEAPON_GUN] = true,
		[STR_SC_WEAPON_MACE1H] = false,
		[STR_SC_WEAPON_MACE2H] = false,
		[STR_SC_WEAPON_POLEARM] = true,
		[STR_SC_WEAPON_SWORD1H] = true,
		[STR_SC_WEAPON_SWORD2H] = true,
		[STR_SC_WEAPON_STAFF] = false,
		[STR_SC_WEAPON_WARGLAIVE] = false,
		[STR_SC_WEAPON_MISC] = false,
		[STR_SC_WEAPON_DAGGER] = false,
		[STR_SC_WEAPON_THROWN] = true,
		[STR_SC_WEAPON_CROSSBOW] = true,
		[STR_SC_WEAPON_WAND] = true,
		[STR_SC_WEAPON_FISHINGPOLES] = false
	},
	['WARLOCK'] = {
		[STR_SC_ARMOR_OTHER] = false,
		[STR_SC_ARMOR_CLOTH] = false,
		[STR_SC_ARMOR_LEATHER] = true,
		[STR_SC_ARMOR_MAIL] = true,
		[STR_SC_ARMOR_PLATE] = true,
		[STR_SC_ARMOR_SHIELD] = true,
		[STR_SC_ARMOR_LIBRAM] = true,
		[STR_SC_ARMOR_IDOL] = true,
		[STR_SC_ARMOR_TOTEM] = true,
		[STR_SC_ARMOR_SIGIL] = true,
		[STR_SC_WEAPON_AXE1H] = true,
		[STR_SC_WEAPON_AXE2H] = true,
		[STR_SC_WEAPON_BOW] = true,
		[STR_SC_WEAPON_GUN] = true,
		[STR_SC_WEAPON_MACE1H] = true,
		[STR_SC_WEAPON_MACE2H] = true,
		[STR_SC_WEAPON_POLEARM] = true,
		[STR_SC_WEAPON_SWORD1H] = false,
		[STR_SC_WEAPON_SWORD2H] = true,
		[STR_SC_WEAPON_STAFF] = false,
		[STR_SC_WEAPON_WARGLAIVE] = true,
		[STR_SC_WEAPON_MISC] = false,
		[STR_SC_WEAPON_DAGGER] = false,
		[STR_SC_WEAPON_THROWN] = true,
		[STR_SC_WEAPON_CROSSBOW] = true,
		[STR_SC_WEAPON_WAND] = false,
		[STR_SC_WEAPON_FISHINGPOLES] = false
	},
	['WARRIOR'] = {
		[STR_SC_ARMOR_OTHER] = false,
		[STR_SC_ARMOR_CLOTH] = false,
		[STR_SC_ARMOR_LEATHER] = false,
		[STR_SC_ARMOR_MAIL] = false,
		[STR_SC_ARMOR_PLATE] = false,
		[STR_SC_ARMOR_SHIELD] = false,
		[STR_SC_ARMOR_LIBRAM] = true,
		[STR_SC_ARMOR_IDOL] = true,
		[STR_SC_ARMOR_TOTEM] = true,
		[STR_SC_ARMOR_SIGIL] = true,
		[STR_SC_WEAPON_AXE1H] = false,
		[STR_SC_WEAPON_AXE2H] = false,
		[STR_SC_WEAPON_BOW] = false,
		[STR_SC_WEAPON_GUN] = false,
		[STR_SC_WEAPON_MACE1H] = false,
		[STR_SC_WEAPON_MACE2H] = false,
		[STR_SC_WEAPON_POLEARM] = false,
		[STR_SC_WEAPON_SWORD1H] = false,
		[STR_SC_WEAPON_SWORD2H] = false,
		[STR_SC_WEAPON_STAFF] = false,
		[STR_SC_WEAPON_WARGLAIVE] = false,
		[STR_SC_WEAPON_MISC] = false,
		[STR_SC_WEAPON_DAGGER] = false,
		[STR_SC_WEAPON_THROWN] = false,
		[STR_SC_WEAPON_CROSSBOW] = false,
		[STR_SC_WEAPON_WAND] = true,
		[STR_SC_WEAPON_FISHINGPOLES] = false
	}
}

local SlotIdToNumber = {
	['INVTYPE_AMMO'] = 0,
	['INVTYPE_HEAD'] = 1,
	['INVTYPE_NECK'] = 2,
	['INVTYPE_SHOULDER'] = 3,
	['INVTYPE_BODY'] = 4,
	['INVTYPE_CHEST'] = 5,
	['INVTYPE_WAIST'] = 6,
	['INVTYPE_LEGS'] = 7,
	['INVTYPE_FEET'] = 8,
	['INVTYPE_WRIST'] = 9,
	['INVTYPE_HAND'] = 10,
	['INVTYPE_FINGER1'] = 11,
	['INVTYPE_FINGER2'] = 12,
	['INVTYPE_TRINKET1'] = 13,
	['INVTYPE_TRINKET2'] = 14,
	['INVTYPE_BACK'] = 15,
	['INVTYPE_MAINHAND'] = 16,
	['INVTYPE_OFFHAND'] = 17,
	['INVTYPE_RANGED'] = 18,
	['INVTYPE_TABARD'] = 19
}

function Scrap:TransformSlotIDToNumber(ID)
	if ID then
		if SlotIdToNumber[ID] then
			return SlotIdToNumber[ID]
		end
	end
	return -1
end

function Scrap:IsItemUnusable(itemID)
	if itemID then
		local _, playerClass = UnitClass('player')
		local unusableToPlayerClass = Unusable_Equipment[playerClass]
		local itemSubType = select(7, GetItemInfo(itemID))

		if unusableToPlayerClass[itemSubType] then
			return true
		end
	end
	return false
end

local MatchClass, Class = ITEM_CLASSES_ALLOWED:format(''), UnitClass('player')
local MatchTrade = BIND_TRADE_TIME_REMAINING:format('.*')
local List = {}
local MSG_ADDED = 'Added to junk list: %s'
local MSG_REMOVED = 'Removed from junk list: %s'


--[[ Events ]]--

function Scrap:Startup()
	self:SetScript('OnReceiveDrag', function() self:OnReceiveDrag() end) -- for the plugins to hook
	self:SetScript('OnEvent', function() self[event](self) end)
	self:RegisterEvent('VARIABLES_LOADED')
	self:RegisterEvent('MERCHANT_SHOW')
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
end

function Scrap:PLAYER_EQUIPMENT_CHANGED()
	self:EquipmentChangedEvent()
end

function Scrap:EquipmentChangedEvent()
	return
end

function Scrap:PLAYER_ENTERING_WORLD()
	self:BuildLocalizedTradeskills()
end

function Scrap:VARIABLES_LOADED()
	self:ReloadList(false, false)
end

function Scrap:MERCHANT_SHOW()
	if not LoadAddOn('Scrap_Merchant') then
		self:UnregisterEvent('MERCHANT_SHOW')
	else
		self:MERCHANT_SHOW()
	end
end

--[[ Item API ]]--

function Scrap:ReloadList(reset, dropfalse)
	Scrap_List = Scrap_List or {}
	if reset then
		Scrap_List = {}
	elseif dropfalse then
		for i, v in pairs(Scrap_List) do
			if v == false then
				Scrap_List[i] = nil
			end
		end
	end
	List = Scrap_List
end

function Scrap:ToggleJunk(id)
	local message

	if self:IsJunk(id) then
	   	List[id] = false
		message = MSG_REMOVED
	else
	   	List[id] = true
		message = MSG_ADDED
  	end

	self:Print(message, select(2, GetItemInfo(id)), 'LOOT')
end

function Scrap:IsJunk(itemID)
	if itemID then
		local customfilter = self:CustomFilter(itemID)
		
		if List[itemID] ~= false then
			return List[itemID] or customfilter
		end
	end
end

--REQUIRES Auctionator Addon to fetch AuctionPrices
function Scrap:IsAuctionableJunk(itemID)
	if itemID and IsAddOnLoaded("Auctionator") then
		local filter = self:AuctionJunkFilter(itemID)
		
		if self:IsJunk(itemID) then
			return false
		end
		
		return filter
	end
end

function Scrap:AuctionJunkFilter(itemID)
	local _, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemSlot, _, itemValue = GetItemInfo(itemID)
	--strName, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemEquipSlot(or ""), itemIconPath, itemValue
	local equipment = itemType == STR_CLASS_ARMOR or itemType == STR_CLASS_WEAPON
	local auctionValue = Atr_GetAuctionBuyout(itemID)
	local value = (auctionValue and auctionValue > 0)
	local vendorValue = itemValue or 0
	local normalizedLevel = max(itemReqLevel or 0, itemLevel or 0)
	local auctionItemLevelCap = 2
	
	--Check that there is an auction price, auction price minus deposit fee is greater than vendor price, and auction price is not a "kiddie-price(TM)(lul-lol9999goldforagraywoodenmacelevel1lul-lil)"
	if value and auctionValue - (vendorValue * 0.15) > vendorValue and (auctionValue / vendorValue) < 100 then
		if itemType == STR_CLASS_TRADEGOODS then
			if itemSubType == STR_SC_TRADEGOODS_HERB then
				if self:HasProfession(STR_TS_HERBALISM) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_HERBALISM, auctionItemLevelCap) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_ALCHEMY,STR_TS_INSCRIPTION}, auctionItemLevelCap)
				end
			elseif itemSubType == STR_SC_TRADEGOODS_METALSTONE then
				if self:HasProfession(STR_TS_MINING) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_MINING, auctionItemLevelCap) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_BLACKSMITHING,STR_TS_JEWELCRAFTING}, auctionItemLevelCap)
				end
			elseif itemSubType == STR_SC_TRADEGOODS_LEATHER then
				if self:HasProfession(STR_TS_SKINNING) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_SKINNING, auctionItemLevelCap) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_LEATHERWORKING}, auctionItemLevelCap)
				end
			elseif itemSubType == STR_SC_TRADEGOODS_CLOTH then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_CLOTHWORKING}, auctionItemLevelCap)
			elseif itemSubType == STR_SC_TRADEGOODS_JEWEL then
				if self:HasProfession(STR_TS_MINING) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_MINING, auctionItemLevelCap) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_JEWELCRAFTING}, auctionItemLevelCap)
				end
			elseif itemSubType == STR_SC_TRADEGOODS_MEAT then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_COOKING}, auctionItemLevelCap)
			end
		elseif itemType == STR_CLASS_RECIPES then
			if itemSubType ~= STR_SC_RECIPES_BOOK then
				return self:NoProfessionsOrLowLevel(itemLevel, {itemSubType}, auctionItemLevelCap)
			else
				--Book of Glyph Mastery
				if itemID == 45912 then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_INSCRIPTION}, 1)
				end
			end
		end
	end
	
	return false
end

function math_clamp(min, value, max)
	if (value < min) then return min end
	if (value > max) then return max end
	return value
end

function math_map(value, explow, exphigh, outlow, outhigh)
	if outlow > outhigh then
		return math_clamp(outhigh, outlow + (value - explow) * (outhigh - outlow) / (exphigh - explow), outlow)
	else
		return math_clamp(outlow, outlow + (value - explow) * (outhigh - outlow) / (exphigh - explow), outhigh)
	end
end

function Scrap:MapTradeSkillLevelToTradeSkillItemLevel(tsl)
	return math_map(tsl, 0, 450, 10, 80)
end

function Scrap:IsLowLevelTradeSkillItem(level, tradeskillname, diff)
	return level + diff < self:MapTradeSkillLevelToTradeSkillItemLevel(self:GetProfessionLevels(tradeskillname).current)
end

function Scrap:NoProfessionsOrLowLevel(level, profs, diff)
	local noprofs = true
	for _, prof in ipairs(profs) do
		if self:HasProfession(prof) then
			noprofs = false
			break
		end
	end
	if noprofs == false then
		for _, prof in ipairs(profs) do
			print("self:IsLowLevelTradeSkillItem(level, prof, diff) :"..tostring(self:IsLowLevelTradeSkillItem(level, prof, diff)))
			if self:HasProfession(prof) and not self:IsLowLevelTradeSkillItem(level, prof, diff) then
				return true
			end
		end
		return false
	end
	return true
end

function Scrap:CustomFilter(itemID)
	local _, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemSlot, _, itemValue = GetItemInfo(itemID)
	--strName, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemEquipSlot(or ""), itemIconPath, itemValue
	local equipment = itemType == STR_CLASS_ARMOR or itemType == STR_CLASS_WEAPON
	local value = itemValue and itemValue > 0
	local normalizedLevel = max(itemReqLevel or 0, itemLevel or 0)
	
	--Level Diff Cap for Vendor Sell
	local tradegoodstradercap = 15
	
	if value then
		if not self:BetterQuality(itemID, 'gray') then
			return not equipment or self:HighLevelItem(itemReqLevel)
			
		elseif equipment then
			if (itemQuality >= 1 and itemQuality <= 4) and itemSubType ~= STR_SC_WEAPON_FISHINGPOLES and itemSubType ~= STR_SC_WEAPON_MISC then
				return self:IsItemUnusable(itemID) or self:IsLowEquip(itemSlot, itemLevel, itemQuality)
			end
		
		elseif itemType == STR_CLASS_CONSUMABLE then
			if itemSubType == STR_SC_CONSUMABLE_POTIONS then
				return self:LowLevel(itemReqLevel, 20)
			elseif itemSubType == STR_SC_CONSUMABLE_FOODDRINK then
				return self:LowLevel(normalizedLevel, 10)
			elseif itemSubType == STR_SC_CONSUMABLE_SCROLLS then
				return self:LowLevel(itemReqLevel, 10)
			elseif itemSubType == STR_SC_CONSUMABLE_BANDAGES then
				return self:LowLevel(normalizedLevel, 10)
			end
		elseif itemType == STR_CLASS_MISC then
			if itemSubType == STR_SC_MISC_JUNK then
				return self:LowLevel(normalizedLevel, 10)
			end
		--TODO:Cache Profession Levels once and reuse through out the function
		elseif itemType == STR_CLASS_TRADEGOODS then
			if itemSubType == STR_SC_TRADEGOODS_HERB then
				if self:HasProfession(STR_TS_HERBALISM) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_HERBALISM, tradegoodstradercap) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_ALCHEMY,STR_TS_INSCRIPTION}, tradegoodstradercap)
				end
			elseif itemSubType == STR_SC_TRADEGOODS_METALSTONE then
				if self:HasProfession(STR_TS_MINING) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_MINING, tradegoodstradercap) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_BLACKSMITHING,STR_TS_JEWELCRAFTING}, tradegoodstradercap)
				end
			elseif itemSubType == STR_SC_TRADEGOODS_LEATHER then
				if self:HasProfession(STR_TS_SKINNING) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_SKINNING, tradegoodstradercap) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_LEATHERWORKING}, tradegoodstradercap)
				end
			elseif itemSubType == STR_SC_TRADEGOODS_CLOTH then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_CLOTHWORKING}, tradegoodstradercap)
			elseif itemSubType == STR_SC_TRADEGOODS_JEWEL then
				if self:HasProfession(STR_TS_MINING) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_MINING, tradegoodstradercap) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_JEWELCRAFTING}, tradegoodstradercap)
				end
			elseif itemSubType == STR_SC_TRADEGOODS_MEAT then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_COOKING}, tradegoodstradercap)
			end
		elseif itemType == STR_CLASS_RECIPES then
			if itemSubType ~= STR_SC_RECIPES_BOOK then
				return self:NoProfessionsOrLowLevel(itemLevel, {itemSubType}, tradegoodstradercap)
			end
		end
	end
	
	return false
end

local ACTUAL_SLOTS = {
	INVTYPE_ROBE = 'INVTYPE_CHEST',
	INVTYPE_CLOAK = 'INVTYPE_BACK',
	INVTYPE_RANGEDRIGHT = 'INVTYPE_RANGED',
	INVTYPE_THROWN = 'INVTYPE_RANGED',
	INVTYPE_WEAPONMAINHAND = 'INVTYPE_MAINHAND',
	INVTYPE_WEAPONOFFHAND = 'INVTYPE_OFFHAND',
	INVTYPE_HOLDABLE = 'INVTYPE_OFFHAND',
	INVTYPE_SHIELD = 'INVTYPE_OFFHAND',
}

local function GetValue(level, quality)
	if quality == 4 then
		return (level + 344.36) / 106.29
	elseif quality == 3 then
		return (level + 287.14) / 97.632
	else
		return (level + 292.23) / 101.18
	end
end

function Scrap:IsLowEquip(slot, level, quality)
	if slot ~= '' then
		local slot1, slot2 = ACTUAL_SLOTS[slot] or slot
		local value = GetValue(level or 0, quality)
		local double

		if slot1 == 'INVTYPE_WEAPON' or slot1 == 'INVTYPE_2HWEAPON' then
			if slot1 == 'INVTYPE_2HWEAPON' then
				double = true
			end

			slot1, slot2 = 'INVTYPE_MAINHAND', 'INVTYPE_OFFHAND'
		elseif slot1 == 'INVTYPE_FINGER' then
			slot1, slot2 = 'INVTYPE_FINGER1', 'INVTYPE_FINGER2'
		end

		slot1 = self:TransformSlotIDToNumber(slot1)
		slot2 = self:TransformSlotIDToNumber(slot2)

		return self:IsBetterEquip(slot1, value) and (not slot2 ~= -1 or self:IsBetterEquip(slot2, value, double))
	end
end

function Scrap:IsBetterEquip(slot, value, empty)
	local item = GetInventoryItemID('player', slot)
	if item then
		local _, itemLink, quality, level, _, class, subclass = GetItemInfo(item)
		--No a fishing pole or a pickaxe is not better than a green level 75 sword
		if subclass == STR_SC_WEAPON_FISHINGPOLES or itemSubType == STR_SC_WEAPON_MISC then
			return false
		else
			return GetValue(level or 0, quality) / value > 1.1
		end
	elseif empty then
		return true
	end
end

function Scrap:BetterQuality(itemID, qual)
	local itemQual = select(3, GetItemInfo(itemID))
	local qtable = {
		['gray'] = 0,
		['poor'] = 0,
		['white'] = 1,
		['green'] = 2,
		['uncommon'] = 2,
		['blue'] = 3,
		['rare'] = 3,
		['purple'] = 4,
		['epic'] = 4,
		['orange'] = 5,
		['legendary'] = 5,
		['artifact'] = 6,
		['cyan'] = 7
	}
	if type(qual) == 'number' then
		return itemQual > qual
	elseif qtable[qual] ~= nil then
		return itemQual > qtable[qual]
	end
	return true
end

function Scrap:HighLevelItem(level)
	return level > 10 or UnitLevel('player') > 8
end

function Scrap:LowLevel(level, diff)
	return level ~= 0 and level < (UnitLevel('player') - diff)
end

function Scrap:IsLocked(bag, slot)
	return select(3, GetContainerItemInfo(bag, slot))
end

function Scrap:IterateJunk()
	local bagNumSlots, bag, slot = GetContainerNumSlots(BACKPACK_CONTAINER), BACKPACK_CONTAINER, 0
	local match, itemID
	
	return function()
		match = nil
		
		while not match do
			if slot < bagNumSlots then
				slot = slot + 1
			elseif bag < NUM_BAG_FRAMES then
				bag = bag + 1
				bagNumSlots = GetContainerNumSlots(bag)
				slot = 1
			else
				bag, slot = nil
				break
			end
			
			itemID = GetContainerItemID(bag, slot)
			match = self:IsJunk(itemID) and not self:IsLocked(bag, slot)
		end
		
		return bag, slot, itemID
	end
end

function Scrap:GetJunkValue()
    local value = 0
    for bag, slot, id in self:IterateJunk() do
    	local itemValue = select(11, GetItemInfo(id))
    	local stack = select(2, GetContainerItemInfo(bag, slot))
    	
		value = value + itemValue * stack
	end
	return value
end


--[[ Call Addon ]]--

Scrap:Startup()