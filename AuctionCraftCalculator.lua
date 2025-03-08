local AuctionCraftCalculator = LibStub("AceAddon-3.0"):NewAddon("AuctionCraftCalculator", "AceEvent-3.0")

-- Table of craftable items organized by category.
-- Each recipe now includes a resultItemID (as a string) for the finished product.
local craftableItems = {
  ["Best in Slot"] = {
      ["Lionheart Helm"] = {
          resultItemID = "12640",  -- Example finished product ID (update as needed)
          materials = {
              { name = "Thorium Bar",          quantity = 80,  itemString = "12359" },
              { name = "Arcanite Bar",         quantity = 12,  itemString = "12360" },
              { name = "Wicked Claw",          quantity = 40,  itemString = "8146"  },
              { name = "Blue Sapphire",        quantity = 10,  itemString = "12361" },
              { name = "Azerothian Diamond",   quantity = 4,   itemString = "12800" },
          },
      },
      ["Robe of the Archmage"] = {
          resultItemID = "0",  -- No finished product item ID; leave as "0" to skip finished price lookup.
          materials = {
              { name = "Bolt of Runecloth",    quantity = 12,  itemString = "14048" },
              { name = "Essence of Fire",      quantity = 10,  itemString = "7078" },
              { name = "Essence of Air",       quantity = 10,  itemString = "7082" },
              { name = "Essence of Earth",     quantity = 10,  itemString = "7076" },
              { name = "Essence of Water",     quantity = 10,  itemString = "7080" },
          },
      },
      ["Hide of the Wild"] = {
          resultItemID = "18510",  -- Example finished product ID
          materials = {
              { name = "Rugged Leather",       quantity = 30,  itemString = "8170" },
              { name = "Living Essence",       quantity = 12,  itemString = "12803" },
              { name = "Essence of Water",     quantity = 10,  itemString = "7080" },
              { name = "Larval Acid",          quantity = 8,   itemString = "18512" },
              { name = "Cured Rugged Hide",    quantity = 3,   itemString = "15407" },
          },
      },
  },
  ["Enchanting"] = {
      ["Enchant Weapon - Crusader"] = {
          resultItemID = "0",  -- No finished product item ID; leave as "0" to skip finished price lookup.
          materials = {
              { name = "Large Brilliant Shard", quantity = 4, itemString = "14344" },
              { name = "Righteous Orb",         quantity = 2, itemString = "12811" },
          },
      },
      ["Enchant Weapon - Fiery Weapon"] = {
          resultItemID = "0",
          materials = {
              { name = "Small Radiant Shard",   quantity = 4, itemString = "11177" },
              { name = "Essence of Fire",       quantity = 1, itemString = "7078" },
          },
      },
      ["Enchant Weapon - Spell Power"] = {
          resultItemID = "0",
          materials = {
              { name = "Large Brilliant Shard",  quantity = 4, itemString = "14344" },
              { name = "Righteous Orb",          quantity = 2, itemString = "12811" },
              { name = "Greater Eternal Essence",quantity = 12,itemString = "16203" },
              { name = "Essence of Fire",        quantity = 4,  itemString = "7078" },
              { name = "Essence of Air",         quantity = 4,  itemString = "7082" },
              { name = "Essence of Water",       quantity = 4,  itemString = "7080" },
          },
      },
      ["Enchant Weapon - Healing Power"] = {
          resultItemID = "0",
          materials = {
              { name = "Large Brilliant Shard",  quantity = 4, itemString = "14344" },
              { name = "Righteous Orb",          quantity = 1, itemString = "12811" },
              { name = "Greater Eternal Essence",quantity = 8, itemString = "16203" },
              { name = "Living Essence",         quantity = 6, itemString = "12803" },
              { name = "Essence of Water",       quantity = 6, itemString = "7080" },
          },
      },
      ["Enchant Chest - Greater Stats"] = {
          resultItemID = "0",
          materials = {
              { name = "Large Brilliant Shard", quantity = 4, itemString = "14344" },
              { name = "Illusion Dust",         quantity = 15,itemString = "16204" },
              { name = "Greater Eternal Essence",quantity = 10,itemString = "16203" },
          },
      },
      ["Enchant Bracer - Superior Strength"] = {
          resultItemID = "0",
          materials = {
              { name = "Illusion Dust",         quantity = 6,itemString = "16204" },
              { name = "Greater Eternal Essence",quantity = 6,itemString = "16203" },
          },
      },
      ["Enchant Boots - Minor Speed"] = {
          resultItemID = "0",
          materials = {
              { name = "Small Radiant Shard",   quantity = 1, itemString = "11177" },
              { name = "Aquamarine",            quantity = 1, itemString = "7909" },
          },
      },
      ["Enchant Boots - Greater Agility"] = {
          resultItemID = "0",
          materials = {
              { name = "Greater Eternal Essence",quantity = 8,itemString = "16203" },
          },
      },
  },
  ["Alchemy"] = {
      ["Elixir of the Mongoose"] = {
          resultItemID = "13452",
          materials = {
              { name = "Mountain Silversage",   quantity = 2, itemString = "13465" },
              { name = "Plaguebloom",           quantity = 2, itemString = "13466" },
          },
      },
      ["Elixir of Giants"] = {
          resultItemID = "9206",
          materials = {
              { name = "Gromsblood",            quantity = 1, itemString = "8846" },
              { name = "Sungrass",              quantity = 1, itemString = "8838" },
          },
      },
      ["Swiftness Potion"] = {
          resultItemID = "2459",
          materials = {
              { name = "Swiftthistle",          quantity = 1, itemString = "2452" },
              { name = "Briarthorn",            quantity = 1, itemString = "2450" },
          },
      },
      ["Greater Arcane Elixir"] = {
          resultItemID = "13454",
          materials = {
              { name = "Mountain Silversage",   quantity = 1, itemString = "13465" },
              { name = "Dreamfoil",             quantity = 3, itemString = "13463" },
          },
      },
      ["Elixir of Shadow Power"] = {
          resultItemID = "9264",
          materials = {
              { name = "Ghost Mushroom",        quantity = 3, itemString = "8845" },
          },
      },
      ["Elixir of the Sages"] = {
          resultItemID = "13447",
          materials = {
              { name = "Dreamfoil",             quantity = 1, itemString = "13463" },
              { name = "Plaguebloom",           quantity = 2, itemString = "13466" },
          },
      },
      ["Mageblood Potion"] = {
          resultItemID = "20007",
          materials = {
              { name = "Plaguebloom",           quantity = 2, itemString = "13466" },
              { name = "Dreamfoil",             quantity = 1, itemString = "13463" },
          },
      },
      ["Major Mana Potion"] = {
          resultItemID = "13444",
          materials = {
              { name = "Icecap",                quantity = 2, itemString = "13467" },
              { name = "Dreamfoil",             quantity = 3, itemString = "13463" },
          },
      },
      ["Greater Fire Protection Potion"] = {
          resultItemID = "13457",
          materials = {
              { name = "Elemental Fire",        quantity = 1, itemString = "7068" },
              { name = "Dreamfoil",             quantity = 1, itemString = "13463" },
          },
      },
      ["Greater Nature Protection Potion"] = {
          resultItemID = "13458",
          materials = {
              { name = "Elemental Earth",       quantity = 1, itemString = "7067" },
              { name = "Dreamfoil",             quantity = 1, itemString = "13463" },
          },
      },
      ["Greater Shadow Protection Potion"] = {
          resultItemID = "13459",
          materials = {
              { name = "Shadow Oil",            quantity = 1, itemString = "3824" },
              { name = "Dreamfoil",             quantity = 1, itemString = "13463" },
          },
      },
      ["Greater Frost Protection Potion"] = {
          resultItemID = "13456",
          materials = {
              { name = "Elemental Water",       quantity = 1, itemString = "7070" },
              { name = "Dreamfoil",             quantity = 1, itemString = "13463" },
          },
      },
      ["Greater Arcane Protection Potion"] = {
          resultItemID = "13461",
          materials = {
              { name = "Dream Dust",            quantity = 1, itemString = "11176" },
              { name = "Dreamfoil",             quantity = 1, itemString = "13463" },
          },
      },
      ["Flask of Supreme Power"] = {
          resultItemID = "13512",
          materials = {
              { name = "Mountain Silversage",   quantity = 10, itemString = "13465" },
              { name = "Dreamfoil",             quantity = 30, itemString = "13463" },
              { name = "Black Lotus",           quantity = 1,  itemString = "13468" },
          },
      },
      ["Flask of Distilled Wisdom"] = {
          resultItemID = "13511",
          materials = {
              { name = "Icecap",                quantity = 10, itemString = "13467" },
              { name = "Dreamfoil",             quantity = 30, itemString = "13463" },
              { name = "Black Lotus",           quantity = 1,  itemString = "13468" },
          },
      },
  },
}

-- Default selected recipe (category and recipe).
AuctionCraftCalculator.selectedRecipeCategory = "Best in Slot"
AuctionCraftCalculator.selectedRecipeName = "Lionheart Helm"

------------------------------------------------------------
-- Utility: Convert Auctionator price value to copper.
------------------------------------------------------------
local function ConvertAuctionPrice(priceVal)
  if type(priceVal) == "number" then
    return priceVal
  elseif type(priceVal) == "string" then
    local len = string.len(priceVal)
    if len < 5 then
      print("Invalid price string: " .. priceVal)
      return nil
    end
    local copper = tonumber(priceVal:sub(len-1, len))
    local silver = tonumber(priceVal:sub(len-3, len-2))
    local gold = tonumber(priceVal:sub(1, len-4))
    if not (gold and silver and copper) then
      print("Failed to parse price string: " .. priceVal)
      return nil
    end
    return (gold * 10000) + (silver * 100) + copper
  else
    print("Unexpected auction price type: " .. type(priceVal))
    return nil
  end
end

------------------------------------------------------------
-- Helper: Get the Auctionator price for an item.
------------------------------------------------------------
local function GetAuctionatorPrice(itemName, itemID)
  if Auctionator and Auctionator.API and Auctionator.API.v1 and Auctionator.API.v1.GetAuctionPriceByItemID then
    local priceVal = Auctionator.API.v1.GetAuctionPriceByItemID(itemName, itemID)
    if priceVal then
      return ConvertAuctionPrice(priceVal)
    end
  end
  return nil
end

------------------------------------------------------------
-- Calculation: Compute material cost and compare to finished product AH price.
------------------------------------------------------------
function AuctionCraftCalculator:CalculateCost()
  local category = self.selectedRecipeCategory
  local recipeName = self.selectedRecipeName
  local recipeData = craftableItems[category] and craftableItems[category][recipeName]
  if not recipeData then
    print("No recipe selected!")
    return
  end

  local materials = recipeData.materials
  local totalCost = 0
  local missingPrice = false

  print("|cffffff00[Cost Calc] Calculating material cost for " .. category .. " - " .. recipeName .. "...|r")
  for _, item in ipairs(materials) do
    local itemID = tonumber(item.itemString)
    local priceCopper = GetAuctionatorPrice(item.name, itemID)
    if priceCopper then
      local cost = priceCopper * item.quantity
      totalCost = totalCost + cost
      print(string.format("%s: %d x %.2fg = %.2fg", item.name, item.quantity, priceCopper/10000, cost/10000))
    else
      print(string.format("|cffff0000Price for %s not found.|r", item.name))
      missingPrice = true
    end
  end

  if missingPrice then
    print("|cffff0000Unable to calculate total material cost due to missing prices.|r")
    return
  else
    print(string.format("|cffffff00Total material cost for %s - %s: %.2fg|r", category, recipeName, totalCost/10000))
  end

  -- Look up the finished product's current AH price if a valid resultItemID is provided.
  local resultItemID = recipeData.resultItemID
  if resultItemID and resultItemID ~= "0" then
    local resultPriceCopper = GetAuctionatorPrice(recipeName, tonumber(resultItemID))
    if resultPriceCopper then
      print(string.format("|cffffff00Current AH price for %s: %.2fg|r", recipeName, resultPriceCopper/10000))
      local diff = resultPriceCopper - totalCost
      if diff >= 0 then
        print(string.format("|cffffff00You save: %.2fg|r", diff/10000))
      else
        print(string.format("|cffff0000It's overpriced by: %.2fg|r", -diff/10000))
      end
    else
      print("|cffff0000Finished product price not found.|r")
    end
  else
    print("|cffff0000No finished product price available for " .. recipeName .. ".|r")
  end
end

------------------------------------------------------------
-- UI: Create a dropdown menu attached to AuctionFrame.
------------------------------------------------------------
function AuctionCraftCalculator:CreateDropdown()
  if not AuctionFrame then return end
  if self.dropdown then return end  -- Already created

  local dd = CreateFrame("Frame", "AuctionCraftCalculatorDropdown", AuctionFrame, "UIDropDownMenuTemplate")
  dd:SetPoint("TOPRIGHT", AuctionFrame, "TOPRIGHT", 23, -60)  -- Adjust position as needed

  UIDropDownMenu_Initialize(dd, function(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()
    -- Iterate over each category.
    for category, recipes in pairs(craftableItems) do
      info.text = category
      info.isTitle = true
      info.notCheckable = true
      UIDropDownMenu_AddButton(info)
      for recName, _ in pairs(recipes) do
        info = UIDropDownMenu_CreateInfo() -- refresh info for each recipe
        info.text = recName
        info.value = category .. "|" .. recName
        info.func = function(self)
          local cat, rec = strsplit("|", self.value)
          AuctionCraftCalculator.selectedRecipeCategory = cat
          AuctionCraftCalculator.selectedRecipeName = rec
          UIDropDownMenu_SetSelectedValue(dd, self.value)
          print("Selected recipe: " .. cat .. " - " .. rec)
        end
        info.checked = false
        info.isTitle = false
        info.notCheckable = false
        UIDropDownMenu_AddButton(info)
      end
    end
  end)

  local defaultValue = AuctionCraftCalculator.selectedRecipeCategory .. "|" .. AuctionCraftCalculator.selectedRecipeName
  UIDropDownMenu_SetSelectedValue(dd, defaultValue)
  self.dropdown = dd
end

------------------------------------------------------------
-- UI: Create a calculation button attached to AuctionFrame.
------------------------------------------------------------
function AuctionCraftCalculator:CreateCalcButton()
  if not AuctionFrame then return end
  if self.calcButton then return end  -- Button already exists

  local btn = CreateFrame("Button", "AuctionCraftCalculatorCalcButton", AuctionFrame, "UIPanelButtonTemplate")
  btn:SetSize(100, 22)
  btn:SetText("Calc Cost")
  btn:SetPoint("TOPRIGHT", AuctionFrame, "TOPRIGHT", 100, -30) -- Adjust so it doesn’t overlap the dropdown
  btn:SetScript("OnClick", function()
    AuctionCraftCalculator:CalculateCost()
  end)
  self.calcButton = btn
end

------------------------------------------------------------
-- Remove the UI elements when the Auction House closes.
------------------------------------------------------------
function AuctionCraftCalculator:RemoveCalcUI()
  if self.calcButton then
    self.calcButton:Hide()
    self.calcButton = nil
  end
  if self.dropdown then
    self.dropdown:Hide()
    self.dropdown = nil
  end
end

------------------------------------------------------------
-- Event Handler: Create or remove UI elements based on Auction House events.
------------------------------------------------------------
function AuctionCraftCalculator:OnEvent(event, ...)
  if event == "AUCTION_HOUSE_SHOW" then
    self:CreateDropdown()
    self:CreateCalcButton()
  elseif event == "AUCTION_HOUSE_CLOSED" then
    self:RemoveCalcUI()
  end
end

------------------------------------------------------------
-- OnEnable: Register Auction House open/close events.
------------------------------------------------------------
function AuctionCraftCalculator:OnEnable()
  self:RegisterEvent("AUCTION_HOUSE_SHOW", "OnEvent")
  self:RegisterEvent("AUCTION_HOUSE_CLOSED", "OnEvent")
end
