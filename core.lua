local ADDON, Addon = ...

function ItemTooltipHook(tooltip)
	local itemName, itemLink = tooltip:GetItem()
	if not itemLink then
		return
	end

    local _, itemId, _, _, _, _, _, _, uniqueId, linkLevel, _, _, _, _ = strsplit(":", itemLink)

    local itemPrice = Addon.itemPrices[tonumber(itemId)]
    if not itemPrice then
        return
    end

    PriceHook(tooltip, itemPrice["min"], itemPrice["mode"])--, itemId)
end

function PetTooltipHook(speciesId, level, quality, health, power, speed, customName)
    local itemPrice = Addon.itemPrices[speciesId]
    if not itemPrice then
        return
    end

    PriceHook(BattlePetTooltip, itemPrice["min"], itemPrice["mode"])--, speciesId)
end

function PriceHook(tooltip, min, mode, id)
    local extra = ""
    if id then
        extra = " [" .. id .. "]"
    end

    tooltip:AddLine("AH Price:    " .. GetCoinTextureStringExt(min) .. " (" .. GetCoinTextureStringExt(mode) .. ")" .. extra, 1, 1, 1, false)
end

function AddCommas(pre, post)
    return pre..post:reverse():gsub("(%d%d%d)","%1"..LARGE_NUMBER_SEPERATOR):reverse()
end
function SplitDecimal(str)
    return str:gsub("^(%d)(%d+)", AddCommas)
end
function ReformatNumberString(str)
    return str:gsub("[%d%.]+", SplitDecimal)
end
function GetCoinTextureStringExt(money)
    if not money then
        return "n/a"
    end

    if money >= 0 then
        return ReformatNumberString(GetCoinTextureString(money))
    else
        return "-"..ReformatNumberString(GetCoinTextureString(money * -1))
    end
end


GameTooltip:HookScript("OnTooltipSetItem", ItemTooltipHook)
ItemRefTooltip:HookScript("OnTooltipSetItem", ItemTooltipHook)
hooksecurefunc("BattlePetToolTip_Show", PetTooltipHook)