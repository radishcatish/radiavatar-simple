


local survivalplate =
    models:newText("health"):setScale(.25):setPos(0, 42, 0):alignment("center"):setSeeThrough(true)
function events.tick()
      survivalplate:setVisible(client:getViewer():getTargetedEntity() == player or host:isHost() and not renderer:isFirstPerson())

    local hp = math.floor(player:getHealth())
    local absorption = player:getAbsorptionAmount()
    local food = player:getFood()
    local sat = math.floor(player:getSaturation())
    local armor = player:getArmor()

    survivalplate:setText(toJson({
        { text = "❤ ", color = "#ff4444" },
        { text = hp .. " ", color = "white" },
        { text = absorption > 0 and ("+" .. absorption .. " ") or "", color = "#ffaa00" },
        { text = "🍖 ", color = "#c8a96e" },
        { text = food .. " ", color = "white" },
        { text = sat > 0 and ("(+" .. sat .. ") ") or "", color = "#44ff88" },
        { text = "🛡 ", color = "#aaaaaa" },
        { text = armor .. "", color = "white" },

    }))

end


function events.render()
    local r = client.getCameraRot()
    survivalplate:setRot(r.x, r.y * -1 - (player:getBodyYaw(delta) - 180 )* -1, 0)
end