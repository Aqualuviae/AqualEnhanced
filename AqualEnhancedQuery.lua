-- AqualEnhancedQuery.lua

local Hekili = _G.Hekili or {}

-- Color mapping (directly copy from ColorMapping.csv)
local ColorMappingContent = [[
Bind,Hex,R,G,B
Q,00FF00,0,255,0
E,02FD33,2,253,51
R,04FB66,4,251,102
T,06F999,6,249,153
F,08F7CC,8,247,204
G,0AF5FF,10,245,255
Z,0CF300,12,243,0
X,0EF133,14,241,51
C,10EF66,16,239,102
V,12ED99,18,237,153
B,14EBCC,20,235,204
H,16E9FF,22,233,255
N,18E700,24,231,0
CQ,1AE533,26,229,51
CE,1CE366,28,227,102
CR,1EE199,30,225,153
CT,20DFCC,32,223,204
CF,22DDFF,34,221,255
CG,24DB00,36,219,0
CZ,26D933,38,217,51
CX,28D766,40,215,102
CC,2AD599,42,213,153
CV,2CD3CC,44,211,204
CB,2ED1FF,46,209,255
CH,30CF00,48,207,0
CN,32CD33,50,205,51
1,34CB66,52,203,102
2,36C999,54,201,153
3,38C7CC,56,199,204
4,3AC5FF,58,197,255
5,3CC300,60,195,0
6,3EC133,62,193,51
7,40BF66,64,191,102
8,42BD99,66,189,153
9,44BBCC,68,187,204
0,46B9FF,70,185,255
C1,48B700,72,183,0
C2,4AB533,74,181,51
C3,4CB366,76,179,102
C4,4EB199,78,177,153
C5,50AFCC,80,175,204
C6,52ADFF,82,173,255
C7,54AB00,84,171,0
C8,56A933,86,169,51
C9,58A766,88,167,102
C0,5AA599,90,165,153
N1,5CA3CC,92,163,204
N2,5EA1FF,94,161,255
N3,609F00,96,159,0
N4,629D33,98,157,51
N5,649B66,100,155,102
N6,669999,102,153,153
N7,6897CC,104,151,204
N8,6A95FF,106,149,255
N9,6C9300,108,147,0
N0,6E9133,110,145,51
CN1,708F66,112,143,102
CN2,728D99,114,141,153
CN3,748BCC,116,139,204
CN4,7689FF,118,137,255
CN5,788700,120,135,0
CN6,7A8533,122,133,51
CN7,7C8366,124,131,102
CN8,7E8199,126,129,153
CN9,807FCC,128,127,204
CN0,827DFF,130,125,255
UP,847B00,132,123,0
DN,867933,134,121,51
LEFT,887766,136,119,102
RIGHT,8A7599,138,117,153
CUp,8C73CC,140,115,204
CDn,8E71FF,142,113,255
CLEFT,906F00,144,111,0
CRIGHT,926D33,146,109,51
MwD,946B66,148,107,102
M3,966999,150,105,153
MwU,9867CC,152,103,204
CMwD,9A65FF,154,101,255
CM3,9C6300,156,99,0
CMwU,9E6133,158,97,51
U,A05F66,160,95,102
I,A25D99,162,93,153
O,A45BCC,164,91,204
P,A659FF,166,89,255
CU,A85700,168,87,0
CI,AA5533,170,85,51
CO,AC5366,172,83,102
CP,AE5199,174,81,153
[,B04FCC,176,79,204
],B24DFF,178,77,255
J,B44B00,180,75,0
CJ,B64933,182,73,51
K,B84766,184,71,102
CK,BA4599,186,69,153
]]

local ColorMapping = {}

local function LoadColorMapping()
    for line in ColorMappingContent:gmatch("[^\r\n]+") do
        local cols = { strsplit(",", line) }
        if #cols >= 5 and cols[1] ~= "Bind" then
            local bind = cols[1]
            local hex = cols[2]
            local r = tonumber(cols[3]) / 255
            local g = tonumber(cols[4]) / 255
            local b = tonumber(cols[5]) / 255

            ColorMapping[bind] = {
                hex = hex,
                rgb = { r, g, b }
            }
        end
    end
end

LoadColorMapping()

AqualEnhancedQuery = AqualEnhancedQuery or {}

function AqualEnhancedQuery:GetColorForKey(key)
    -- Normalize key to ensure consistency
    key = key:upper()

    -- Handle ALT + NUMPAD combinations
    if key:match("^CN%d$") then
        key = "CN" .. key:sub(3)

    -- Handle ALT + letter or number key
    elseif key:sub(1, 1) == "C" and #key == 2 then
        key = "C" .. key:sub(2)

    -- Handle ALT + arrow keys and other special keys
    elseif key == "CUP" then
        key = "CUp"
    elseif key == "CDN" then
        key = "CDn"
    elseif key == "CLEFT" then
        key = "CLEFT"
    elseif key == "CRIGHT" then
        key = "CRIGHT"
    elseif key == "CMWD" then
        key = "CMwD"
    elseif key == "CMWU" then
        key = "CMwU"
    elseif key == "CM3" then
        key = "CM3"

    -- Handle number pad keys (N prefix)
    elseif key:match("^N%d$") then
        key = "N" .. key:sub(2)

    -- Handle arrow keys and mouse wheel keys
    elseif key == "UP" then
        key = "UP"
    elseif key == "DN" then
        key = "DN"
    elseif key == "LEFT" then
        key = "LEFT"
    elseif key == "RIGHT" then
        key = "RIGHT"
    elseif key == "MWD" then
        key = "MwD"
    elseif key == "MWU" then
        key = "MwU"
    end

    -- Direct lookup for the processed key
    local color = ColorMapping[key]

    -- Debugging: print the key and color mapping result
    if not color then
        print("Key not found in colorMapping: " .. key)
    end

    return color
end
