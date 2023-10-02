local QBCore = exports['qb-core']:GetCoreObject()
local ShopZones = {}
local TargetZones = {}
local DutyZones = {}
local Machines = {}
local PlayerJob = {}
local PlayerGang = {}
local onDuty = false

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = QBCore.Functions.GetPlayerData().job
        PlayerGang = QBCore.Functions.GetPlayerData().gang
        onDuty = PlayerJob.onduty
        InitiateZones()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerGang = QBCore.Functions.GetPlayerData().gang
    PlayerJob = QBCore.Functions.GetPlayerData().job
    onDuty = PlayerJob.onduty
    SetTimeout(3000, function()
        InitiateZones()
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = JobInfo.onduty
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(InfoGang)
    PlayerGang = InfoGang
end)

function InitiateZones()
    for k, v in pairs(Config.Shops) do
        if v.isjob.name ~= false and v.isjob.dutyloc ~= nil then
            local dloc = vec3(v.isjob.dutyloc.x, v.isjob.dutyloc.y, v.isjob.dutyloc.z)
            DutyZones[#DutyZones..k] = BoxZone:Create(dloc, 1.0, 1.0, {
                name = v.shopname..k..'dutyloc',
                useZ = true,
                heading = v.isjob.dutyloc.w,
                debugPoly = Config.Debug
            })
        
            DutyZones[#DutyZones..k]:onPlayerInOut(function(isPointInside, point)
                isInEnterZone = isPointInside
                if isPointInside then
                    exports['qb-core']:DrawText('[E] - '..Lang:t("info.dutychange"), 'left')
                    CreateThread(function()
                        while isInEnterZone do
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)
                            if IsControlJustReleased(0, 38) then
                                QBCore.Functions.TriggerCallback('flex-ownedshop:server:isowner', function(owner)
                                    if (owner == 2) or (v.isjob.name ~= false and PlayerJob.name == v.isjob.name and v.isjob.everyone) 
                                    or (v.isjob.name ~= false and PlayerJob.name == v.isjob.name and PlayerJob.isboss) 
                                    or (v.isgang.name ~= false and PlayerGang.name == v.isgang.name and not v.isgang.everyone and PlayerGang.isboss) 
                                    or (v.isgang.name ~= false and PlayerGang.name == v.isgang.name and v.isgang.everyone) then
                                        exports['qb-core']:KeyPressed()
                                        exports['qb-core']:HideText()
                                        local PlayData = QBCore.Functions.GetPlayerData()
                                        onDuty = not PlayData.job.onduty
                                        TriggerServerEvent('flex-ownedshops:server:changeDuty', not PlayData.job.onduty)
                                    end
                                end, v.shopname)
                            end
                            Wait(0)
                        end
                    end)
                else
                    exports['qb-core']:HideText()
                end
            end)
        end

        local mloc = vec3(v.manageloc.x, v.manageloc.y, v.manageloc.z)
        ShopZones[#ShopZones..k] = BoxZone:Create(mloc, v.boxzone.depth, v.boxzone.width, {
            name = v.shopname..k..'manageloc',
            useZ = true,
            heading = v.manageloc.w,
            debugPoly = Config.Debug
        })
    
        ShopZones[#ShopZones..k]:onPlayerInOut(function(isPointInside, point)
            isInEnterZone = isPointInside
            if isPointInside then
                exports['qb-core']:DrawText('[E] - '..Lang:t("info.manageshop"), 'left')
                CreateThread(function()
                    while isInEnterZone do
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        if IsControlJustReleased(0, 38) then
                            exports['qb-core']:KeyPressed()
                            exports['qb-core']:HideText()
                            QBCore.Functions.TriggerCallback('flex-ownedshop:server:isowner', function(owner)
                                print(owner)
                                if (owner == 2) or (v.isjob.name ~= false and PlayerJob.name == v.isjob.name and v.isjob.everyone) 
                                or (v.isjob.name ~= false and PlayerJob.name == v.isjob.name and PlayerJob.isboss) 
                                or (v.isgang.name ~= false and PlayerGang.name == v.isgang.name and not v.isgang.everyone and PlayerGang.isboss) 
                                or (v.isgang.name ~= false and PlayerGang.name == v.isgang.name and v.isgang.everyone) then
                                    if onDuty or v.isgang.name ~= false or owner then
                                        if v.isjob.everyone or v.isgang.everyone or owner then
                                            TriggerEvent('flex-ownedshops:client:manageshop', v.shopname)
                                        else
                                            if PlayerJob.isboss or PlayerGang.isboss then
                                                TriggerEvent('flex-ownedshops:client:manageshop', v.shopname)
                                            else
                                                QBCore.Functions.Notify(Lang:t("error.notboss"), "error", 4500)
                                            end
                                        end
                                    else
                                        QBCore.Functions.Notify(Lang:t("error.notonduty"), "error", 4500)
                                    end
                                elseif (owner == 0) and v.isjob.name == false and v.isgang.name == false then
                                    print(v.shopprice)
                                    TriggerEvent('flex-ownedshops:client:buyshop', v.shopname, v.shopprice)
                                else
                                    QBCore.Functions.Notify(Lang:t("error.notworkinghere"), "error", 4500)
                                end
                            end, v.shopname)
                        end
                        Wait(0)
                    end
                end)
            else
                exports['qb-core']:HideText()
            end
        end)

        if v.machine.model ~= nil then
            Machines[k] = CreateObject(v.machine.model, v.buyloc.x + v.machine.offset.x, v.buyloc.y+ v.machine.offset.y, v.buyloc.z+ v.machine.offset.z, true, true, true)
            PlaceObjectOnGroundProperly(Machines[k])
            SetEntityHeading(Machines[k], v.buyloc.w)
        end

        if v.target then
            local v3 = vec3(v.buyloc.x, v.buyloc.y, v.buyloc.z)
            TargetZones[#TargetZones..k] = exports['qb-target']:AddBoxZone(v.shopname..k..'buyloc', v3, v.boxzone.depth, v.boxzone.width, {
                name = v.shopname..k..'buyloc',
                heading = v.buyloc.w,
                debugPoly = Config.Debug,
                minZ = v.boxzone.minZ,
                maxZ = v.boxzone.maxZ,
            }, {
                options = {
                    {
                        type = "client",
                        icon = "fas fa-sign-in-alt",
                        label = Lang:t("info.openshop"),
                        action = function()
                            OpenShop(v.shopname, v.isjob.name, v.isgang.name)
                        end,
                    },
                },
                distance = 2.5
            })
        else
            local v3 = vec3(v.buyloc.x, v.buyloc.y, v.buyloc.z)
            ShopZones[#ShopZones..k] = BoxZone:Create(v3, v.boxzone.depth, v.boxzone.width, {
                name = v.shopname..k..'buyloc',
                useZ = true,
                heading = v.buyloc.w,
                debugPoly = Config.Debug
            })
        
            ShopZones[#ShopZones..k]:onPlayerInOut(function(isPointInside, point)
                isInEnterZone = isPointInside
                if isPointInside then
                    exports['qb-core']:DrawText('[E] - '..Lang:t("info.openshop"), 'left')
                    CreateThread(function()
                        while isInEnterZone do
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)
                            if IsControlJustReleased(0, 38) then
                                exports['qb-core']:KeyPressed()
                                exports['qb-core']:HideText()
                                OpenShop(v.shopname, v.isjob.name, v.isgang.name)
                            end
                            Wait(0)
                        end
                    end)
                else
                    exports['qb-core']:HideText()
                end
            end)
        end
    end
end

RegisterNetEvent('flex-ownedshops:client:buyshop', function(shopid, price)
    local BuyShop = {
        {
            header = Lang:t("managemenu.buyheader"),
            icon = "fa-solid fa-circle-info",
            isMenuHeader = true,
        },
        {
            header = Lang:t("managemenu.buyshop", {value = price}),
            icon = "fa-solid fa-list",
            params = {
                isServer = true,
                event = "flex-ownedshops:server:buyshop",
                args = {
                    shopname = shopid,
                    shopprice = price
                },
            }
        },
        {
            header = Lang:t("managemenu.close"),
            icon = "fa-solid fa-angle-left",
            params = {
                event = "qb-menu:closeMenu",
            }
        },
    }
    exports['qb-menu']:openMenu(BuyShop)
end)

RegisterNetEvent('flex-ownedshops:client:manageshop', function(shopid)
    local ManagementMenu = {
        {
            header = Lang:t("managemenu.header"),
            icon = "fa-solid fa-circle-info",
            isMenuHeader = true,
        },
        {
            header = Lang:t("managemenu.checkstock"),
            icon = "fa-solid fa-list",
            params = {
                event = "flex-ownedshops:client:checkstock",
                args = {
                    shopname = shopid
                },
            }
        },
        {
            header = Lang:t("managemenu.restock"),
            icon = "fa-solid fa-list",
            params = {
                event = "flex-ownedshops:client:checkinv",
                args = {
                    shopname = shopid
                },
            }
        },
        {
            header = Lang:t("managemenu.close"),
            icon = "fa-solid fa-angle-left",
            params = {
                event = "qb-menu:closeMenu",
            }
        },
    }
    exports['qb-menu']:openMenu(ManagementMenu)
end)

RegisterNetEvent('flex-ownedshops:client:checkstock', function(data)
    QBCore.Functions.TriggerCallback('flex-ownedshop:server:loadshop', function(items)
        if items then
            local inventory = {
                {
                    header = Lang:t("managemenu.instock"),
                    isMenuHeader = true,
                },
            }
            local itemlist = {}
            for k, v in pairs(json.decode(items)) do
                if itemlist[v['name']] then
                    itemlist[v['name']].amount = itemlist[v['name']].amount + tonumber(v['amount'])
                else
                    itemlist[v['name']] = {
                        amount = tonumber(v['amount']),
                        price = tonumber(v['price']),
                    }
                end
            end
            for k, v in pairs(itemlist) do
                local item = {}
                item.header = "<img src=nui://"..Config.inventorylink..QBCore.Shared.Items[k].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[k].label
                local text = Lang:t("managemenu.amount")..v.amount..' </br> '..Lang:t("managemenu.price",{value = v.price})
                item.text = text
                item.params = {
                    event = 'flex-ownedshops:client:setprice',
                    args = {
                        item = k,
                        shopname = data.shopname,
                    }
                }
                table.insert(inventory, item)
            end
            local goback = {
                header = Lang:t("managemenu.goback"),
                icon = "fa-solid fa-angle-left",
                params = {
                    event = 'flex-ownedshops:client:manageshop',
                    args = data.shopname
                }
            }
            table.insert(inventory, goback)
            exports['qb-menu']:openMenu(inventory)
        else
            QBCore.Functions.Notify(Lang:t("info.emptyshop"), "info", 4500)
        end
    end, data.shopname)
end)

RegisterNetEvent('flex-ownedshops:client:checkinv', function(data)
    QBCore.Functions.TriggerCallback('flex-ownedshop:server:loadinv', function(items)
        if items then
            local inventory = {
                {
                    header = Lang:t("managemenu.inventory"),
                    isMenuHeader = true,
                },
            }
            local itemlist = {}
            for k, v in pairs(items) do
                if itemlist[v['name']] then
                    itemlist[v['name']].amount = itemlist[v['name']].amount + tonumber(v['amount'])
                else
                    itemlist[v['name']] = {
                        amount = tonumber(v['amount']),
                    }
                end
            end
            for k, v in pairs(itemlist) do
                local item = {}
                item.header = "<img src=nui://"..Config.inventorylink..QBCore.Shared.Items[k].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[k].label
                local text = Lang:t("managemenu.amount")..v.amount
                item.text = text
                item.params = {
                    event = 'flex-ownedshops:client:restock',
                    args = {
                        item = k,
                        amount = v.amount,
                        label = QBCore.Shared.Items[k].label,
                        shopname = data.shopname,
                    }
                }
                table.insert(inventory, item)
            end
            exports['qb-menu']:openMenu(inventory)
        else
            QBCore.Functions.Notify(Lang:t("info.emptyshop"), "info", 4500)
        end
    end)
end)

RegisterNetEvent('flex-ownedshops:client:restock', function(data)
    local restock = exports['qb-input']:ShowInput({
        header = Lang:t('managemenu.stockamount', {value = data.label, value2 = data.amount}),
        submitText = Lang:t('managemenu.confirm'),
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = Lang:t('managemenu.amountstock')
            }
        }
    })
    if restock then
        if tonumber(data.amount) >= tonumber(restock.amount) then
            TriggerServerEvent('flex-ownedshops:server:restock', data.item, restock.amount, data.shopname)
            QBCore.Functions.Notify(Lang:t("success.refillstock",{value = restock.amount, value2 = data.label}), "success", 4500)
        else
            QBCore.Functions.Notify(Lang:t("error.notenooughinv"), "error", 4500)
        end
    end
end)

function OpenShop(shopid, job, gang)
    QBCore.Functions.TriggerCallback('flex-ownedshop:server:loadshop', function(items)
        if items then
            local store = {
                {
                    header = Lang:t("managemenu.buyheader"),
                    isMenuHeader = true,
                },
            }
            local itemlist = {}
            for k, v in pairs(json.decode(items)) do
                if itemlist[v['name']] then
                    itemlist[v['name']].amount = itemlist[v['name']].amount + tonumber(v['amount'])
                else
                    itemlist[v['name']] = {
                        amount = tonumber(v['amount']),
                        price = tonumber(v['price'])
                    }
                end
            end
            for k, v in pairs(itemlist) do
                local item = {}
                item.header = "<img src=nui://"..Config.inventorylink..QBCore.Shared.Items[k].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[k].label
                local text = Lang:t("managemenu.amount")..v.amount..' </br> '..Lang:t("managemenu.price",{value = v.price})
                item.text = text
                item.params = {
                    event = 'flex-ownedshops:client:buy',
                    args = {
                        item = k,
                        amount = v.amount,
                        label = QBCore.Shared.Items[k].label,
                        price = v.price,
                        shopname = shopid,
                        jobname = job,
                        gangname = gang,
                    }
                }
                table.insert(store, item)
            end
            exports['qb-menu']:openMenu(store)
        else
            QBCore.Functions.Notify(Lang:t("info.emptyshop"), "info", 4500)
        end
    end, shopid)
end

RegisterNetEvent('flex-ownedshops:client:buy', function(data)
    local buying = exports['qb-input']:ShowInput({
        header = Lang:t('managemenu.buyamount', {value = data.label, value2 = (data.price * data.amount), value3 = data.amount}),
        submitText = Lang:t('managemenu.buy'),
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = Lang:t('managemenu.amountstock')
            }
        }
    })
    if buying then
        if tonumber(data.amount) >= tonumber(buying.amount) then
            if tonumber(buying.amount) > 0 then
                TriggerServerEvent('flex-ownedshops:server:buy', data.item, buying.amount, data.price, data.label, data.shopname, data.jobname, data.gangname)
            else
                QBCore.Functions.Notify(Lang:t("error.buycantbezero"), "error", 4500)
            end
        else
            QBCore.Functions.Notify(Lang:t("error.notenooughstock"), "error", 4500)
        end
    end
end)

RegisterNetEvent('flex-ownedshops:client:setprice', function(data)
    local price = exports['qb-input']:ShowInput({
        header = Lang:t('managemenu.whatprice', {value =  QBCore.Shared.Items[data.item].label}),
        submitText = Lang:t('managemenu.setprice'),
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = Lang:t('managemenu.howmuch')
            }
        }
    })
    if price then
        if tonumber(price.amount) >= 0 then
            TriggerServerEvent('flex-ownedshops:server:setprice', data.item, price.amount, data.shopname)
            QBCore.Functions.Notify(Lang:t("success.setprice",{value =  QBCore.Shared.Items[data.item].label, value2 = price.amount}), "success", 4500)
        else
            QBCore.Functions.Notify(Lang:t("error.nonegativeprice"), "error", 4500)
        end
        TriggerEvent('flex-ownedshops:client:manageshop', data.shopname)
    end
end)

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
    for k, v in pairs(ShopZones) do ShopZones[k]:destroy() end
    for k, v in pairs(DutyZones) do DutyZones[k]:destroy() end
    for k, v in pairs(Machines) do DeleteEntity(Machines[k]) end
    for t in pairs(TargetZones) do exports['qb-target']:RemoveZone(t) end
end)