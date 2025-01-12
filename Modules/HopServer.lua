local ServerIDs = {}
local Cursor = ""
local CurrentHour = os.date("!*t").hour
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local File = pcall(function()
    ServerIDs = HttpService:JSONDecode(readfile("server_hop_data.json"))
end)
if not File then
    table.insert(ServerIDs, CurrentHour)
    pcall(function()
        writefile("server_hop_data.json", HttpService:JSONEncode(ServerIDs))
    end)
end

local function FindAndTeleport(placeId, region)
    local ServerList
    if Cursor == "" then
        ServerList = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&region=' .. region))
    else
        ServerList = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. Cursor .. '&region=' .. region))
    end

    local ServerID = ""
    if ServerList.nextPageCursor then
        Cursor = ServerList.nextPageCursor
    end

    for _, server in pairs(ServerList.data) do
        local IsNewServer = true
        ServerID = tostring(server.id)
        if tonumber(server.maxPlayers) > tonumber(server.playing) then
            for _, existingID in pairs(ServerIDs) do
                if ServerID == tostring(existingID) then
                    IsNewServer = false
                    break
                end
            end
            if IsNewServer then
                table.insert(ServerIDs, ServerID)
                pcall(function()
                    writefile("server_hop_data.json", HttpService:JSONEncode(ServerIDs))
                end)
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(placeId, ServerID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

local ServerHopAPI = {}
function ServerHopAPI:Teleport(placeId, region)
    while wait() do
        pcall(function()
            FindAndTeleport(placeId, region)
            if Cursor ~= "" then
                FindAndTeleport(placeId, region)
            end
        end)
    end
end

return ServerHopAPI
