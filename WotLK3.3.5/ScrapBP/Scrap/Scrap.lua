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
local LTSNInitialized = false

SLASH_SCRAP1 = "/togglejunk"
function SlashCmdList.SCRAP(arg)
	local itmid = select(3, strfind(arg, "item:(%d+)"))
	if itmid and GetItemInfo(arg) then
		Scrap:ToggleJunk(tonumber(itmid))
	else
		print("No Item Selected. To select an item pass an item link by holding shift and clicking on it.")
	end
end

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
	ChatFrame1:AddMessage("|cffffd200[Scrap]:|rInitializing Localized TradeSkill Names.")
	self:UpdateProfessionData()
	ChatFrame1:AddMessage("|cffffd200[Scrap]:|rInitialized Localized TradeSkill Names.")
	LTSNInitialized = true
end

function Scrap:DevFindItemByName(itemname)
	for i=1, 3000000 do
		if select(1, GetItemInfo(i)) == itemname then
			ChatFrame1:AddMessage(i..": "..GetItemInfo(i))
			return i
		end
	end
	ChatFrame1:AddMessage(itemname, " Not Found.")
	return nil
end

function Scrap:DevFindProfessionSkill(prof)
	for i=1, 300000 do
		if select(1, GetSpellInfo(i)) == prof then
			ChatFrame1:AddMessage(i..": "..GetSpellInfo(i))
			return i
		end
	end
	ChatFrame1:AddMessage(prof, " Not Found.")
	return nil
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
end

function Scrap:DebugPrint(...)
	ChatFrame1:AddMessage(...)
end

local OutputChats = {
	1,
	3
}

function Scrap:PrintMessage(...)
	for _, i in pairs(OutputChats) do
		_G['ChatFrame'..i]:AddMessage(...)
	end
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

local stone_ids = {
	[2835] = true,
	[2836] = true,
	[2838] = true,
	[7912] = true,
	[12365] = true
}
local ingot_ids = {
	[2840] = true,
	[2841] = true,
	[2842] = true,
	[3575] = true,
	[3576] = true,
	[3577] = true,
	[3859] = true,
	[3860] = true,
	[6037] = true,
	[11371] = true,
	[12359] = true,
	[12360] = true,
	[12655] = true,
	[17771] = true,
	[18562] = true,
	[23445] = true,
	[23446] = true,
	[23447] = true,
	[23448] = true,
	[23449] = true,
	[23573] = true,
	[35128] = true,
	[36913] = true,
	[36916] = true,
	[37663] = true,
	[41163] = true
}
local ore_ids = {
	[2770] = true,
	[2771] = true,
	[2772] = true,
	[2775] = true,
	[2776] = true,
	[3858] = true,
	[7911] = true,
	[10620] = true,
	[11370] = true,
	[23424] = true,
	[23425] = true,
	[23426] = true,
	[23427] = true,
	[36909] = true,
	[36910] = true,
	[36912] = true
}

function Scrap:ListTest()
	for i, id in ipairs(stone_ids) do
		res = GetItemInfo(id)
		if res == nil then
			print("Stone ID ", id, "is not recognized")
		end
	end
	for i, id in ipairs(ingot_ids) do
		res = GetItemInfo(id)
		if res == nil then
			print("Ingot ID ", id, "is not recognized")
		end
	end
	for i, id in ipairs(ore_ids) do
		res = GetItemInfo(id)
		if res == nil then
			print("Ore ID ", id, "is not recognized")
		end
	end
end

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
	if not LTSNInitialized then
		self:BuildLocalizedTradeskills()
	end
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

	if List[id] ~= nil then
		if List[id] == true then
			List[id] = false
			message = MSG_REMOVED
		else
			List[id] = true
			message = MSG_ADDED
		end
	else
		if Scrap:IsJunk(id) then
			List[id] = false
			message = MSG_REMOVED
		else
			List[id] = true
			message = MSG_ADDED
		end
	end

	self:PrintMessage(message:format(select(2, GetItemInfo(id))))
end

function Scrap:IsJunk(itemID, ...)
	if itemID then
		local customfilter = self:CustomFilter(itemID, 10)
		
		if List[itemID] ~= false then
			return (List[itemID] or customfilter) and not self:IsAuctionableJunk(itemID, ...) and not self:IsExpensiveJunk(itemID, ...)
		end
	end
end

function Scrap:IsExpensiveJunk(id, ...)
	if id and List[id] ~= false then
		local itemcount = 1
		local arg = {...}
		if arg ~= nil then
			if #arg == 1 then
				itemcount = arg[1]
			elseif #arg == 2 then
				if type(arg[1]) == 'number' and type(arg[2]) == 'number' then
					itemcount = select(2, GetContainerItemInfo(arg[1], arg[2]))
				end
			end
		end
		local itemvalue = select(11, GetItemInfo(id)) * itemcount
		local expensive = itemvalue and itemvalue >= GetMoney() * 0.05
		if List[id] ~= false then
			return (List[id] or self:CustomFilter(id, 10)) and not self:IsAuctionableJunk(id, ...) and expensive
		end
	end
end

--REQUIRES Auctionator Addon to fetch AuctionPrices
function Scrap:IsAuctionableJunk(itemID, ...)
	if itemID and IsAddOnLoaded("Auctionator") then
		local filter = self:AuctionJunkFilter(itemID, ...)
		
		--[[if self:IsJunk(itemID) then
			return false
		end--]]
		
		return filter
	end
end

--Auction Suggestion Filter
function Scrap:AuctionJunkFilter(itemID, ...)
	local arg = {...}
	local itemcount = 1
	if arg ~= nil then
		if #arg == 1 then
			itemcount = arg[1]
		elseif #arg == 2 then
			if type(arg[1]) == 'number' and type(arg[2]) == 'number' then
				itemcount = select(2, GetContainerItemInfo(arg[1], arg[2]))
			end
		end
	end
	local _, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemSlot, _, itemValue = GetItemInfo(itemID)
	--strName, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemEquipSlot(or ""), itemIconPath, itemValue
	local equipment = itemType == STR_CLASS_ARMOR or itemType == STR_CLASS_WEAPON
	local auctionValue = Atr_GetAuctionBuyout(itemID) or 0
	local value = (auctionValue and auctionValue > 0)
	local vendorValue = itemValue or 0
	local normalizedLevel = max(itemReqLevel or 0, itemLevel or 0)
	local normalizedLevelMin = (itemReqLevel and itemLevel and min(itemReqLevel, itemLevel)) or normalizedLevel
	local auctionItemLevelCap = -5
	local vendorauctionpricemultcap = 200
	local maxauctionprice = {50, 0, 0}
	local stackauctionvalue = auctionValue * itemcount
	
	--[[if itemID == 3355 then
		print("Has Value:",value)
		print("AuctionValue > VendorValue + Fee",auctionValue - (vendorValue * 0.15) > vendorValue)
		print("Stack Count", itemcount, "<-", #arg, "args")
		print("Auction Value", auctionValue)
		print("Stack Auction Value - Fee > 1g",stackauctionvalue - (vendorValue * itemcount * 0.15) > 10000)
		print("Stack Auction Value", stackauctionvalue)
		print("Fee",vendorValue * itemcount * 0.15)
		print("Auc/Ven < cap",(auctionValue / vendorValue) < vendorauctionpricemultcap)
		print("Auc < ", (maxauctionprice[1]*10000+maxauctionprice[2]*100+maxauctionprice[3]), " ",auctionValue < (maxauctionprice[1]*10000+maxauctionprice[2]*100+maxauctionprice[3]))
	end--]]
	--Check that there is an auction price, auction price minus deposit fee is greater than vendor price, and auction price is not a "kiddie-price(TM)(lul-lol9999goldforagraywoodenmacelevel1lul-lil)"
	if value and auctionValue - (vendorValue * 0.15) > vendorValue and stackauctionvalue - (vendorValue * itemcount * 0.15) > 10000 and ((auctionValue / vendorValue) < vendorauctionpricemultcap or auctionValue < (maxauctionprice[1]*10000+maxauctionprice[2]*100+maxauctionprice[3])) then
		--[[if itemType == STR_CLASS_TRADEGOODS then
			if itemSubType == STR_SC_TRADEGOODS_HERB then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_ALCHEMY,STR_TS_INSCRIPTION}, auctionItemLevelCap)
			elseif itemSubType == STR_SC_TRADEGOODS_METALSTONE then
				if self:ItemIsOre(itemID) then
					return self:HasProfession(STR_TS_MINING) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_MINING, auctionItemLevelCap)
				end
				if self:ItemIsStone(itemID) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_JEWELCRAFTING}, auctionItemLevelCap)
				end
				if self:ItemIsIngot(itemID) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_BLACKSMITHING,STR_TS_JEWELCRAFTING}, auctionItemLevelCap)
				end
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_BLACKSMITHING,STR_TS_JEWELCRAFTING}, auctionItemLevelCap)
			elseif itemSubType == STR_SC_TRADEGOODS_LEATHER then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_LEATHERWORKING}, auctionItemLevelCap)
			elseif itemSubType == STR_SC_TRADEGOODS_CLOTH then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_CLOTHWORKING}, auctionItemLevelCap)
			elseif itemSubType == STR_SC_TRADEGOODS_JEWEL then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_JEWELCRAFTING}, auctionItemLevelCap)
			elseif itemSubType == STR_SC_TRADEGOODS_MEAT then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_COOKING}, auctionItemLevelCap)
			elseif itemSubType == STR_SC_TRADEGOODS_ENCHANTING then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_ENCHANTING}, auctionItemLevelCap)
			elseif itemSubType == STR_SC_TRADEGOODS_PARTS then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_ENGINEERING}, auctionItemLevelCap)
			elseif itemSubType == STR_SC_TRADEGOODS_OTHER then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_ALCHEMY, STR_TS_BLACKSMITHING, STR_TS_LEATHERWORKING, STR_TS_ENCHANTING}, auctionItemLevelCap)
			end
		elseif itemType == STR_CLASS_RECIPES then
			if itemSubType ~= STR_SC_RECIPES_BOOK then
				return self:NoProfessionsOrLowLevel(itemLevel, {itemSubType}, auctionItemLevelCap)
			else
				--Book of Glyph Mastery
				if itemID == 45912 then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_INSCRIPTION}, 0)
				end
			end
		elseif itemType == STR_CLASS_GEMS then
			return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_JEWELCRAFTING}, auctionItemLevelCap) and self:LowLevel(itemLevel, 3)
		elseif itemType == STR_CLASS_QUEST then
			if itemID == 43297 then
				return not self:HasProfession(STR_TS_JEWELCRAFTING)
			end
		end--]]
		if itemType == STR_CLASS_TRADEGOODS or itemType == STR_CLASS_RECIPES or itemType == STR_CLASS_GEMS or itemType == STR_CLASS_QUEST then
			return self:CustomFilter(itemID, auctionItemLevelCap)
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
	return math_map(tsl, 0, 450, 1, 80)
end

function Scrap:IsLowLevelTradeSkillItem(level, tradeskillname, diff)
	return level + diff <= self:MapTradeSkillLevelToTradeSkillItemLevel(self:GetProfessionLevels(tradeskillname).current)
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
			--print("self:IsLowLevelTradeSkillItem(level, prof, diff) :"..tostring(self:IsLowLevelTradeSkillItem(level, prof, diff)))
			if self:HasProfession(prof) and not self:IsLowLevelTradeSkillItem(level, prof, diff) then
				return false
			end
		end
	end
	return true
end

function Scrap:ItemIsIngot(id)
	return ingot_ids[id] or false
end

function Scrap:ItemIsStone(id)
	return stone_ids[id] or false
end

function Scrap:ItemIsOre(id)
	return ore_ids[id] or false
end

--Junk Filter
function Scrap:CustomFilter(itemID, tradegoodstradercap)
	local _, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemSlot, _, itemValue = GetItemInfo(itemID)
	--strName, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemEquipSlot(or ""), itemIconPath, itemValue
	local equipment = itemType == STR_CLASS_ARMOR or itemType == STR_CLASS_WEAPON
	local value = itemValue and itemValue > 0
	local normalizedLevel = max(itemReqLevel or 0, itemLevel or 0)
	local normalizedLevelMin = (itemReqLevel and itemLevel and min(itemReqLevel, itemLevel)) or normalizedLevel
	
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
				return self:LowLevel(normalizedLevelMin, math_map(UnitLevel('player'), 5, 80, 5, 18))
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
			--Wool, Runecloth, Mageweave Quest Items if at appr level
			if itemID == 2592 then
				if UnitLevel('player') <= 25 then
					return false
				end
			elseif itemID == 4306 then
				if UnitLevel('player') <= 39 then
					return false
				end
			elseif itemID == 4338 then
				if UnitLevel('player') <= 49 then
					return false
				end
			elseif itemID == 14047 then
				if UnitLevel('player') <= 59 then
					return false
				end
			end
			if itemSubType == STR_SC_TRADEGOODS_HERB then
				if self:HasProfession(STR_TS_HERBALISM) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_HERBALISM, tradegoodstradercap) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_ALCHEMY,STR_TS_INSCRIPTION}, tradegoodstradercap)
				end
			elseif itemSubType == STR_SC_TRADEGOODS_METALSTONE then
				if self:ItemIsOre(itemID) then
					return self:HasProfession(STR_TS_MINING) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_MINING, tradegoodstradercap)
				end
				if self:ItemIsStone(itemID) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_JEWELCRAFTING}, tradegoodstradercap)
				end
				if self:ItemIsIngot(itemID) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_BLACKSMITHING,STR_TS_JEWELCRAFTING}, tradegoodstradercap)
				end
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_MINING}, tradegoodstradercap)
			elseif itemSubType == STR_SC_TRADEGOODS_LEATHER then
				if self:HasProfession(STR_TS_SKINNING) and self:IsLowLevelTradeSkillItem(itemLevel,STR_TS_SKINNING, tradegoodstradercap) then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_LEATHERWORKING}, tradegoodstradercap)
				else
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_SKINNING}, tradegoodstradercap)
				end
			elseif itemSubType == STR_SC_TRADEGOODS_CLOTH then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_CLOTHWORKING}, tradegoodstradercap)
			elseif itemSubType == STR_SC_TRADEGOODS_JEWEL then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_JEWELCRAFTING}, tradegoodstradercap)
			elseif itemSubType == STR_SC_TRADEGOODS_ENCHANTING then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_ENCHANTING}, tradegoodstradercap)
			elseif itemSubType == STR_SC_TRADEGOODS_MEAT then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_COOKING}, tradegoodstradercap)
			elseif itemSubType == STR_SC_TRADEGOODS_PARTS then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_ENGINEERING}, tradegoodstradercap)
			elseif itemSubType == STR_SC_TRADEGOODS_OTHER then
				return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_ALCHEMY, STR_TS_BLACKSMITHING, STR_TS_LEATHERWORKING, STR_TS_ENCHANTING}, tradegoodstradercap)
			end
		elseif itemType == STR_CLASS_RECIPES then
			if itemSubType ~= STR_SC_RECIPES_BOOK then
				return self:NoProfessionsOrLowLevel(itemLevel, {itemSubType}, tradegoodstradercap)
			else
				--Book of Glyph Mastery
				if itemID == 45912 then
					return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_INSCRIPTION}, 0)
				end
			end
		elseif itemType == STR_CLASS_GEMS then
			return self:NoProfessionsOrLowLevel(itemLevel, {STR_TS_JEWELCRAFTING}, tradegoodstradercap) and self:LowLevel(itemLevel, 15)
		elseif itemType == STR_CLASS_QUEST then
			if itemID == 43297 then
				return not self:HasProfession(STR_TS_JEWELCRAFTING)
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

local CompactibleItemList = {
	[37700] = {endItem = {id = 35623}, fullstackcompact = true, compactItemCount = 10},
	[37701] = {endItem = {id = 35624}, fullstackcompact = true, compactItemCount = 10},
	[37702] = {endItem = {id = 36860}, fullstackcompact = true, compactItemCount = 10},
	[37703] = {endItem = {id = 35627}, fullstackcompact = true, compactItemCount = 10},
	[37704] = {endItem = {id = 35625}, fullstackcompact = true, compactItemCount = 10},
	[37705] = {endItem = {id = 35622}, fullstackcompact = true, compactItemCount = 10},
	[22573] = {endItem = {id = 22452}, fullstackcompact = false, compactItemCount = 10},
	[22575] = {endItem = {id = 21886}, fullstackcompact = false, compactItemCount = 10},
	[22574] = {endItem = {id = 21884}, fullstackcompact = false, compactItemCount = 10},
	[22577] = {endItem = {id = 22456}, fullstackcompact = false, compactItemCount = 10},
	[22572] = {endItem = {id = 22451}, fullstackcompact = false, compactItemCount = 10},
	[22578] = {endItem = {id = 21885}, fullstackcompact = false, compactItemCount = 10},
	[22576] = {endItem = {id = 22457}, fullstackcompact = false, compactItemCount = 10}
}

--Unreliable method to find an item in inventory by ID
--Finds the first stack and returns it/cannot be used to find a specific item stack
function Scrap:FindItemInInventory(itemID)
	local bagNumSlots, bag, slot = GetContainerNumSlots(BACKPACK_CONTAINER), BACKPACK_CONTAINER, 0
	local iterItemID
	
	while true do
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
		
		iterItemID = GetContainerItemID(bag, slot)
		if itemID == iterItemID then
			return {bag, slot}
		end
	end
	return {nil, nil}
end

function Scrap:IsCompactable(itemID, stack)
	local _, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemSlot, _, itemValue = GetItemInfo(itemID)
	--strName, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemEquipSlot(or ""), itemIconPath, itemValue
	if itemID and stack then
		if CompactibleItemList[itemID] then
			local compItem = CompactibleItemList[itemID]
			--local endItemID = compItem.endItem.id
			--local _, _, _, _, _, _, _, endItemMaxStack = GetItemInfo(endItemID)
			return (compItem.fullstackcompact and stack >= itemMaxStack) or stack >= compItem.compactItemCount
		end
	end
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
			match = self:IsJunk(itemID, bag, slot) and not self:IsLocked(bag, slot)
		end
		
		return bag, slot, itemID
	end
end

function Scrap:IterateAllJunk()
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
			match = (self:IsJunk(itemID, bag, slot) or self:IsExpensiveJunk(id, bag, slot)) and not self:IsLocked(bag, slot)
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