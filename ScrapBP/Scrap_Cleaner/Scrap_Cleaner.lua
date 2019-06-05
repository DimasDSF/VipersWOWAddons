--[[
Copyright 2010, 2011 João Cardoso
Scrap Cleaner is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Scrap Cleaner.

Scrap Cleaner is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Scrap Cleaner is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Scrap Cleaner. If not, see <http://www.gnu.org/licenses/>.
--]]

local TimerFrame = CreateFrame('Frame')
local NextTime = 0

local function CleanTrash()
	local time = GetTime()

	if GetNetStats() ~= nil and (NextTime < time) and NextTime ~= 0 then	
		if MainMenuBarBackpackButton.freeSlots == 0 then
			local bestValue, bestBag, bestSlot = 1/0
			local itemLink, itemLink2
			
			for bag, slot, id in Scrap:IterateJunk() do
				local bagType = select(2, GetContainerNumFreeSlots(bag))
				if not bagType then
					return
				end
				
				if bagType == 0 then
					local stack = select(2, GetContainerItemInfo(bag, slot))
					if not stack then
						return
					end
					
					--local value = select(11, GetItemInfo(id)) * (stack + maxStack) * .5 -- Lets bet 50% on not full stacks
					--Lets not
					local value = select(11, GetItemInfo(id)) * stack
					if value < bestValue then
						bestBag, bestSlot = bag, slot
						bestValue = value
						if itemLink ~= nil then
							itemLink2 = {itemLink[1], itemLink[2], itemLink[3]}
						end
						itemLink = {select(2, GetItemInfo(id)), stack, value}
					end
				end
			end
			
			if bestBag and bestSlot then
				PickupContainerItem(bestBag, bestSlot)
				if Scrap_DelNotify then
					ChatFrame1:AddMessage("|cffffd200[Scrap]:|rDeleted: "..itemLink[1].."x"..itemLink[2]..". Value: "..GetCoinTextureString(itemLink[3])..".")
					if itemLink2 ~= nil then
						ChatFrame1:AddMessage("|cffffd200[Scrap]:|rNext Lowest Price Item: "..itemLink2[1].."x"..itemLink2[2]..". Value: "..GetCoinTextureString(itemLink2[3])..".")
					end
				end
				DeleteCursorItem()
				
				NextTime = time + (select(3, GetNetStats()) * 0.01)
				TimerFrame:SetScript('OnUpdate', nil)
			end
		end
	else
		TimerFrame:SetScript('OnUpdate', CleanTrash)
	end
end

--Preventing a Bug that happens when first loading into world due to backpack button still thinking it has 0 slots left.
TimerFrame:SetScript("OnEvent", function(self,event)
	if(event == "PLAYER_ENTERING_WORLD") then
		if GetNetStats()~=nil then
			NextTime = GetTime() + select(3, GetNetStats())*0.05
		end
	end
end)

TimerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

hooksecurefunc('MainMenuBarBackpackButton_UpdateFreeSlots', CleanTrash)