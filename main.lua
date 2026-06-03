-- THE MAIN CONTROLLER THAT RUNS EVERYTHING
print("Loading Script Framework...")

-- 1. Linking your folder's modules together
local SaveModule = require(script.Parent.datastore)
local TrackModule = require(script.Parent.tracker)

-- 2. Setting up baseline variables
local myUserId = 123456
local autoFarmActive = true

-- Save our startup setting using our datastore file
SaveModule.Save(myUserId, "AutoFarm", autoFarmActive)

-- 3. A loop simulating checking the game environment
task.spawn(function()
    while true do
        task.wait(2.0) -- Wait 2 seconds before checking again
        
        if autoFarmActive then
            -- Pretend these are live coordinates in the game world
            local playerPosition = 0 
            local enemyPosition = 12 -- The enemy is 12 studs away
            
            -- Use our tracker file to see if the enemy is close enough to hit
            local isClose = TrackModule.CheckDistance(playerPosition, enemyPosition)
            
            if isClose then
                print("Action: Automatically interacting with target!")
            end
        end
    end
end)
