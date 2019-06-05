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
local STR_SUBCLASS_FOODDRINK, STR_SUBCLASS_POTIONS, STR_SUBCLASS_ELIXIRS, STR_SUBCLASS_BREWS, STR_SUBCLASS_BANDAGES, STR_SUBCLASS_UPGRADES, STR_SUBCLASS_SCROLLS, STR_SUBCLASS_OTHER = GetAuctionItemSubClasses(4)
local STR_SUBCLASS_JUNK, STR_SUBCLASS_REAGENTS, STR_SUBCLASS_PETS, STR_SUBCLASS_HOLIDAY, STR_SUBCLASS_MISCOTHER, STR_SUBCLASS_MOUNTS = GetAuctionItemSubClasses(11)
local STR_SUBCLASS_FISHINGPOLES = select(17, GetAuctionItemSubClasses(1))

local MatchClass, Class = ITEM_CLASSES_ALLOWED:format(''), UnitClass('player')
local MatchTrade = BIND_TRADE_TIME_REMAINING:format('.*')
local Unusable, List = Scrap_Unusable
local MSG_ADDED = 'Added to junk list: %s'
local MSG_REMOVED = 'Removed from junk list: %s'


--[[ Events ]]--

function Scrap:Startup()
	self:SetScript('OnReceiveDrag', function() self:OnReceiveDrag() end) -- for the plugins to hook
	self:SetScript('OnEvent', function() self[event](self) end)
	self:RegisterEvent('VARIABLES_LOADED')
	self:RegisterEvent('MERCHANT_SHOW')
end

function Scrap:VARIABLES_LOADED()
	self:ReloadList(false)
end

function Scrap:MERCHANT_SHOW()
	if not LoadAddOn('Scrap_Merchant') then
		self:UnregisterEvent('MERCHANT_SHOW')
	else
		self:MERCHANT_SHOW()
	end
end

--[[ Item API ]]--

function Scrap:ReloadList(reset)
	Scrap_List = Scrap_List or {}
	if reset then
		Scrap_List = {}
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
		local _, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemSlot, _, itemValue = GetItemInfo(itemID)
		--strName, itemLink, itemQuality, itemLevel, itemReqLevel, itemClass, itemSubClass, itemMaxStack, itemEquipSlot(or ""), itemIconPath, itemPrice
		local valuable = itemQuality ~= ITEM_QUALITY_POOR or itemValue == 0
		local customfilter = self:CustomFilter(itemID)
		
		if itemID and List[itemID] ~= false then
			return List[itemID] or customfilter
		end
	end
end

function Scrap:CustomFilter(itemID)
	local _, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemSlot, _, itemValue = GetItemInfo(itemID)
	--strName, itemLink, itemQuality, itemLevel, itemReqLevel, itemType, itemSubType, itemMaxStack, itemEquipSlot(or ""), itemIconPath, itemValue
	local equipment = itemType == STR_CLASS_ARMOR or itemType == STR_CLASS_WEAPON
	local value = itemValue and itemValue > 0
	local normalizedLevel = max(itemReqLevel or 0, itemLevel or 0)
	
	if value then
		if not self:BetterQuality(itemID, 'gray') then
			return not equipment or self:HighLevelItem(itemReqLevel)
			
		elseif equipment then
			if (itemQuality >= 2 and itemQuality <= 4) and itemSubType ~= STR_SUBCLASS_FISHINGPOLES then
				return self:IsLowEquip(itemSlot, itemLevel, itemQuality)
			end
		
		elseif itemType == STR_CLASS_CONSUMABLE then
			if itemSubType == STR_SUBCLASS_POTIONS then
				return self:LowLevel(itemReqLevel, 20)
			elseif itemSubType == STR_SUBCLASS_FOODDRINK then
				return self:LowLevel(normalizedLevel, 10)
			elseif itemSubType == STR_SUBCLASS_SCROLLS then
				return self:LowLevel(itemReqLevel, 10)
			elseif itemSubType == STR_SUBCLASS_BANDAGES then
				return self:LowLevel(normalizedLevel, 10)
			end
		elseif itemType == STR_CLASS_MISC then
			if itemSubType == STR_SUBCLASS_JUNK then
				return self:LowLevel(normalizedLevel, 10)
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

		return self:IsBetterEquip(slot1, value) and (not slot2 or self:IsBetterEquip(slot2, value, double))
	end
end

function Scrap:IsBetterEquip(slot, value, empty)
	local item = GetInventoryItemID('player', slot)
	if item then
		local _,_, quality, level = GetItemInfo(item)
		return GetValue(level or 0, quality) / value > 1.1
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