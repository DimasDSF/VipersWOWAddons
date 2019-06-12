--[[
Copyright 2011 João Cardoso
Bagnon Scrap is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Bagnon Scrap.

Bagnon Scrap is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Bagnon Scrap is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Bagnon Scrap. If not, see <http://www.gnu.org/licenses/>.
--]]

local ItemSlot = Bagnon.ItemSlot
local SetQuality = ItemSlot.SetBorderQuality
local r, g, b = GetItemQualityColor(0)

function ItemSlot:SetBorderQuality(...)
	local link = select(7, self:GetItemSlotInfo())
	local stack = select(2, self:GetItemSlotInfo())
	local function CreateIcon(slot)
		local icon = slot:CreateTexture(nil, 'OVERLAY')
		icon:SetTexture('Interface\\MONEYFRAME\\UI-CopperIcon')
		icon:SetPoint('TOPLEFT', 2, -2)
		icon:SetSize(15, 15)

		slot.scrapIcon = icon
		return icon
	end
	local function CreateAucIcon(slot)
		local icon = slot:CreateTexture(nil, 'OVERLAY')
		icon:SetTexture('Interface\\MONEYFRAME\\UI-GoldIcon')
		icon:SetPoint('TOPLEFT', 2, -2)
		icon:SetSize(15, 15)
		
		slot.scrapAucIcon = icon
		return icon
	end
	local function CreateStackIcon(slot)
		local icon = slot:CreateTexture(nil, 'OVERLAY')
		icon:SetTexture('Interface\\Buttons\\UI-SortArrow')
		icon:SetPoint('BOTTOMLEFT', 2, 2)
		icon:SetSize(20, 10)
		
		slot.scrapStackIcon = icon
		return icon
	end
	local function SetShown(element, shown)
		if shown then
			element:Show()
		else
			element:Hide()
		end
	end
	local icon = self.scrapIcon or CreateIcon(self)
	local aucIcon = self.scrapAucIcon or CreateAucIcon(self)
	local stackIcon = self.scrapStackIcon or CreateStackIcon(self)
	if link then
		local id = tonumber(strmatch(link, 'item:(%d+)'))
		SetShown(icon, Scrap:IsJunk(id))
		SetShown(aucIcon, Scrap:IsAuctionableJunk(id))
		SetShown(stackIcon, Scrap:IsCompactable(id, stack))
		if Scrap:IsJunk(id) then
			self.questBorder:Hide()
			self.border:SetVertexColor(20, 20, 20, self:GetHighlightAlpha())
			self.border:Show()
			return
		end
	else
		SetShown(icon, false)
		SetShown(aucIcon, false)
		SetShown(stackIcon, false)
	end
	
	SetQuality(self, ...)
end

local function UpdateBags()
	for _,frame in pairs(Bagnon.frames) do
		frame.itemFrame:UpdateEverything()
	end
end

hooksecurefunc(Scrap, 'ToggleJunk', UpdateBags)
hooksecurefunc(Scrap, 'ReloadList', UpdateBags)
hooksecurefunc(Scrap, 'EquipmentChangedEvent', UpdateBags)
