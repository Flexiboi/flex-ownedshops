local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("flex-ownedshop:server:loadshop", function(source, cb, name)
    local result = MySQL.Sync.fetchAll('SELECT * FROM ownedshops WHERE shopname = ?', { name })
    if result[1] then
        cb(result[1].stock)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback("flex-ownedshop:server:loadinv", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.items then
        cb(Player.PlayerData.items)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback("flex-ownedshop:server:isowner", function(source, cb, shop)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT owner FROM ownedshops WHERE shopname = ?', { shop })
    if result[1] then
        if result[1].owner == Player.PlayerData.citizenid then
            cb(2)
        elseif result[1].owner ~= nil then
            cb(1)
        else
            cb(0)
        end
    else
        cb(0)
    end
end)

RegisterNetEvent('flex-ownedshops:server:buyshop', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local BankMoney = Player.PlayerData.money['bank']
    local CashMoneyMoney = Player.PlayerData.money['cash']
    if src == nil or Player == nil then return end
    local HasMoney = false
    if BankMoney >= data.shopprice and not HasMoney then
        HasMoney = true
        Player.Functions.RemoveMoney("bank", data.shopprice, data.shopname)
    elseif CashMoneyMoney >= data.shopprice and not HasMoney then
        HasMoney = true
        Player.Functions.RemoveMoney("cash", data.shopprice, data.shopname)
    end
    if HasMoney then
        TriggerClientEvent('QBCore:Notify', src, Lang:t("success.boughtshop", {value = data.shopprice}), 'success', 5000)
        MySQL.Async.insert('INSERT INTO ownedshops (shopname, owner) VALUES (:shopname, :owner)', { ['shopname'] = data.shopname, ['owner'] = Player.PlayerData.citizenid})
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.broke"), 'error', 5000)
    end
end)

RegisterNetEvent('flex-ownedshops:server:restock', function(itemname, amount, shopname)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(itemname, amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemname], "remove", amount)
        local shop = MySQL.prepare.await('SELECT stock FROM ownedshops WHERE shopname = ?', { shopname })
        local NewStock = {}
        local alreadyadded = false
        if table.type(inventory) ~= "empty" and shop then
            local items = json.decode(shop)
            if shop ~= '[]' then
                for slot, item in pairs(items) do
                    if items[slot] then
                        if item.name == itemname then
                            NewStock[#NewStock+1] = {
                                name = itemname,
                                amount = tonumber(item.amount) + amount,
                                price = item.price or 0,
                            }
                            alreadyadded = true
                        else
                            NewStock[#NewStock+1] = {
                                name = item.name or itemname,
                                amount = tonumber(item.amount) or amount,
                                price = item.price or 0,
                            }
                            if #items == slot then
                                if not alreadyadded then
                                    NewStock[#NewStock+1] = {
                                        name = itemname,
                                        amount = amount,
                                        price = item.price or 0,
                                    }
                                end
                            end
                        end
                    else
                        NewStock[#NewStock+1] = {
                            name = itemname,
                            amount = amount,
                            price = item.price or 0,
                        }
                    end
                end
            else
                NewStock[#NewStock+1] = {
                    name = itemname,
                    amount = amount,
                    price = item.price or 0,
                }
            end
        else
            NewStock[#NewStock+1] = {
                name = itemname,
                amount = amount,
                price = 0,
            }
        end
        alreadyadded = false
        local owner = MySQL.prepare.await('SELECT owner FROM ownedshops WHERE shopname = ?', { shopname })
        if not owner then
            MySQL.Async.insert('INSERT INTO ownedshops (shopname, stock) VALUES (:shopname, :stock) ON DUPLICATE KEY UPDATE stock = :stock', { ['shopname'] = shopname, ['stock'] = json.encode(NewStock) })
        else
            MySQL.update.await("UPDATE ownedshops SET stock=? WHERE shopname=?", {json.encode(NewStock), shopname})
        end
        TriggerClientEvent('QBCore:Notify', src, Lang:t("success.stockrefilled"), 'success', 5000)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.error404item"), 'error', 5000)
    end
end)

RegisterNetEvent('flex-ownedshops:server:buy', function(itemname, itemamount, price, label, shopname, jobname, gangname)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local BankMoney = Player.PlayerData.money['bank']
    local CashMoneyMoney = Player.PlayerData.money['cash']
    local shop = MySQL.prepare.await('SELECT stock FROM ownedshops WHERE shopname = ?', { shopname })
    local owner = MySQL.prepare.await('SELECT owner FROM ownedshops WHERE shopname = ?', { shopname })
    local target = nil
    if owner then
        Target = QBCore.Functions.GetOfflinePlayerByCitizenId(owner)
    end
    local NewStock = {}
    local HasMoney = false
    local canbuy = false
    if BankMoney >= price*itemamount and not HasMoney then
        HasMoney = true
        Player.Functions.RemoveMoney("bank", price*itemamount, itemname)
    elseif CashMoneyMoney >= price*itemamount and not HasMoney then
        HasMoney = true
        Player.Functions.RemoveMoney("cash", price*itemamount, itemname)
    end
    if HasMoney then
        if Config.Banking == 'fd' then
            if jobname then
                exports.fd_banking:AddMoney(jobname, price*itemamount, itemname)
            elseif gangname then
                exports.fd_banking:AddMoney(gangname, price*itemamount, itemname)
            else
                Target.Functions.AddMoney("bank", price*itemamount, itemname)
            end
        elseif Config.Banking == 'qb' then
            if jobname then
                exports['qb-management']:AddMoney(jobname, price*itemamount)
            elseif gangname then
                exports['qb-management']:AddMoney(gangname, price*itemamount)
            else
                Target.Functions.AddMoney("bank", price*itemamount, itemname)
            end
        else
            Target.Functions.AddMoney("bank", price*itemamount, itemname)
        end
        if table.type(inventory) ~= "empty" and shop then
            local items = json.decode(shop)
            if shop ~= '[]' then
                for slot, item in pairs(items) do
                    if items[slot] then
                        if item.name == itemname then
                            if tonumber(item.amount) - itemamount > 0 then
                                NewStock[#NewStock+1] = {
                                    name = itemname,
                                    amount = tonumber(item.amount) - itemamount,
                                    price = item.price
                                }
                            end
                            canbuy = true
                        else
                            if tonumber(item.amount) > 0 then
                                NewStock[#NewStock+1] = {
                                    name = item.name,
                                    amount = tonumber(item.amount),
                                    price = item.price,
                                }
                            end
                        end
                    end
                end
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.error404item"), 'error', 5000)
        end
        if canbuy then
            if rawequal(next(NewStock), nil) then
               MySQL.update.await("UPDATE ownedshops SET stock=? WHERE shopname=?", {'[{}]', shopname})
            else
                MySQL.update.await("UPDATE ownedshops SET stock=? WHERE shopname=?", {json.encode(NewStock), shopname})
            end
            if Player.Functions.AddItem(itemname, itemamount) then
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemname], "add", itemamount)
                canbuy = false
                TriggerClientEvent('QBCore:Notify', src, Lang:t("success.successbuy",{value = itemamount, value2 = label, value3 = (price * itemamount)}))
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.error404item"), 'error', 5000)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.broke"), 'error', 5000)
    end
end)

RegisterNetEvent('flex-ownedshops:server:setprice', function(itemname, price, shopname)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local shop = MySQL.prepare.await('SELECT stock FROM ownedshops WHERE shopname = ?', { shopname })
    local NewStock = {}
    if table.type(inventory) ~= "empty" and shop then
        local items = json.decode(shop)
        if shop ~= '[]' then
            for slot, item in pairs(items) do
                if items[slot] then
                    if item.name == itemname then
                        NewStock[#NewStock+1] = {
                            name = itemname,
                            amount = tonumber(item.amount),
                            price = price,
                        }
                    else
                        NewStock[#NewStock+1] = {
                            name = item.name,
                            amount = tonumber(item.amount),
                            price = item.price,
                        }
                    end
                end
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.error404item"), 'error', 5000)
    end
    MySQL.update.await("UPDATE ownedshops SET stock=? WHERE shopname=?", {json.encode(NewStock), shopname})
end)

RegisterNetEvent('flex-ownedshops:server:changeDuty', function(duty)
    local Player = QBCore.Functions.GetPlayer(source)
    local Job = Player.PlayerData.job

    if Job and Job.onduty and not duty then
        Player.Functions.SetJobDuty(false)
        QBCore.Functions.Notify(source, Lang:t("info.offduty"), 'primary')
        TriggerClientEvent('QBCore:Client:SetDuty', source, false)
    elseif Job and not Job.onduty and duty then
        Player.Functions.SetJobDuty(true)
        QBCore.Functions.Notify(source, Lang:t("info.onduty"), 'primary')
        TriggerClientEvent('QBCore:Client:SetDuty', source, true)
    end
end)
