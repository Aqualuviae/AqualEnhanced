-- AqualEnhancedCore.lua

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("UNIT_TARGET")
frame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")

local last_recommendation = nil
local ticker = nil

-- Create a frame for displaying color
local colorBoxFrame = CreateFrame("Frame", "ColorBoxFrame", UIParent)
colorBoxFrame:SetSize(1, 1)
colorBoxFrame:SetPoint("TOPLEFT", 0, 0)

-- Set the background color for the frame
colorBoxFrame.texture = colorBoxFrame:CreateTexture(nil, "BACKGROUND")
colorBoxFrame.texture:SetAllPoints(true)
colorBoxFrame.texture:SetColorTexture(0, 0, 0, 1)

-- Slash command for setting x, y, width, and height in one command
SLASH_AQUALE1 = '/AqualE'
SlashCmdList['AQUALE'] = function(msg)
    local x, y, height, width = strsplit(",", msg)
    x, y, height, width = tonumber(x), tonumber(y), tonumber(height), tonumber(width)

    if x and y and height and width and height > 0 and width > 0 then
        colorBoxFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, -y)
        colorBoxFrame:SetSize(width, height)
        DEFAULT_CHAT_FRAME:AddMessage("Color box set to X: " .. x .. ", Y: " .. y .. ", Width: " .. width .. ", Height: " .. height)
    else
        DEFAULT_CHAT_FRAME:AddMessage("Invalid input. Use format: /AqualE x, y, height, width")
    end
end

-- Function to get the recommended skill name and key directly
local function GetHekiliRecommendationWithKey()
    local ability_id = Hekili_GetRecommendedAbility("Primary", 1)

    if ability_id then
        local key = Hekili:GetBindingForAction(ability_id)

        if ability_id < 0 then
            ability_id = Hekili.Class.abilities[ability_id].item
        end

        return ability_id, key
    end

    return nil, nil
end

-- Function to check player state and update the color of the frame
local function UpdateColorBox()
    local inCombat = UnitAffectingCombat("player")
    local targetSelf = UnitIsUnit("target", "player")
    local onMount = IsMounted()

    if not inCombat or targetSelf or onMount then
        colorBoxFrame.texture:SetColorTexture(0, 0, 0, 1)
    else
        local recommendation, key = GetHekiliRecommendationWithKey()
        if recommendation and key and recommendation ~= last_recommendation then
            last_recommendation = recommendation

            -- Fetch the color for the key directly, ensuring modifier keys are accounted for
            local color = AqualEnhancedQuery:GetColorForKey(key)
            if color then
                colorBoxFrame.texture:SetColorTexture(unpack(color.rgb))
            else
                colorBoxFrame.texture:SetColorTexture(1, 1, 1, 1) -- Default to white if no color found
            end
        end
    end
end

-- Update function to periodically check recommendations
local function OnUpdate()
    UpdateColorBox()
end

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        DEFAULT_CHAT_FRAME:AddMessage("Aqual Enhanced loaded successfully!")
        DEFAULT_CHAT_FRAME:AddMessage("Use /AqualE x, y, height, width to set position and size of the color box.")
        UpdateColorBox()
    elseif event == "PLAYER_REGEN_ENABLED" then
        if ticker then
            ticker:Cancel()
            ticker = nil
        end
        last_recommendation = nil
        UpdateColorBox()
    elseif event == "PLAYER_REGEN_DISABLED" then
        if not ticker then
            ticker = C_Timer.NewTicker(0.2, OnUpdate)
        end
    elseif event == "UNIT_TARGET" or event == "PLAYER_MOUNT_DISPLAY_CHANGED" then
        UpdateColorBox()
    end
end)

AqualEnhancedCore = AqualEnhancedCore or {}
