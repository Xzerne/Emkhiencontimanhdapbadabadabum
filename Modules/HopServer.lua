local ServerIDs = {} 
local Cursor = ""
local CurrentHour = os.date("!*t").hour

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local success, data = pcall(function()
    return readfile("server_hop_data.json")
end)

if success and data then
    ServerIDs = HttpService:JSONDecode(data)
else
    ServerIDs = {CurrentHour}
    pcall(function()
        writefile("server_hop_data.json", HttpService:JSONEncode(ServerIDs))
    end)
end

if ServerIDs[1] ~= CurrentHour then
    ServerIDs = {CurrentHour}
    pcall(function()
        writefile("server_hop_data.json", HttpService:JSONEncode(ServerIDs))
    end)
end

local function FindAndTeleport(placeId, region)
    local url = 'https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'
    if Cursor ~= "" then
        url = url .. "&cursor=" .. Cursor
    end
    if region then
        url = url .. "&region=" .. region
    end

    local success, ServerList = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if not success or not ServerList or not ServerList.data then
        return
    end

    Cursor = ServerList.nextPageCursor or ""

    for _, server in pairs(ServerList.data) do
        if tonumber(server.playing) < tonumber(server.maxPlayers) then
            local ServerID = tostring(server.id)
            local isNewServer = not table.find(ServerIDs, ServerID)

            if isNewServer then
                table.insert(ServerIDs, ServerID)
                pcall(function()
                    writefile("server_hop_data.json", HttpService:JSONEncode(ServerIDs))
                end)

                local teleportSuccess = pcall(function()
                    TeleportService:TeleportToPlaceInstance(placeId, ServerID, game.Players.LocalPlayer)
                end)

                if teleportSuccess then
                    return
                end

                task.wait(2)
            end
        end
    end
end

local ServerHopAPI = {}

function ServerHopAPI:Teleport(placeId, region)
    while task.wait(1) do
        local success = pcall(function()
            FindAndTeleport(placeId, region)
        end)

        if not success then
            warn("Failed to find or teleport to a server. Retrying...")
        end

        if Cursor == "" then
            break
        end
    end
end

return ServerHopAPI
