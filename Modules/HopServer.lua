local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ServerIDs = {}
local Cursor = ""

local function LoadServerIDs()
    local success, data = pcall(function()
        return readfile("server_hop_data.json")
    end)
    if success and data then
        ServerIDs = HttpService:JSONDecode(data)
    else
        ServerIDs = {}
        pcall(function()
            writefile("server_hop_data.json", HttpService:JSONEncode(ServerIDs))
        end)
    end
end

local function SaveServerID(id)
    table.insert(ServerIDs, id)
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
        warn("Failed to fetch server list. Retrying...")
        task.wait(2)
        return FindAndTeleport(placeId, region)
    end

    Cursor = ServerList.nextPageCursor or ""

    for _, server in pairs(ServerList.data) do
        if tonumber(server.playing) < tonumber(server.maxPlayers) then
            local serverID = tostring(server.id)
            if not table.find(ServerIDs, serverID) then
                SaveServerID(serverID)
                local teleportSuccess, errorMsg = pcall(function()
                    TeleportService:TeleportToPlaceInstance(placeId, serverID, LocalPlayer)
                end)
                if teleportSuccess then
                    return
                else
                    warn("Teleport failed: " .. tostring(errorMsg))
                    task.wait(2)
                end
            end
        end
    end

    if Cursor ~= "" then
        FindAndTeleport(placeId, region)
    else
        warn("No available servers found. Retrying in 3 seconds...")
        task.wait(3)
        Cursor = ""
        FindAndTeleport(placeId, region)
    end
end

local ServerHopAPI = {}

function ServerHopAPI:Teleport(placeId, region)
    LoadServerIDs()
    FindAndTeleport(placeId, region)
    print('Bada Badabum Hop')
end

return ServerHopAPI
