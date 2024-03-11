Config = {}
Config.Debug = true
Config.inventorylink = 'qb-inventory/html/images/' --Path of your inventory images

Config.Banking = 'qb' -- fd for fd_banking / qb for qb-management
Config.Shops = {
    [1] = {
        shopname = '247shop1', -- Name of shop
        shopprice = 1000, -- Price of this shop. When it is gang or job owned no need for price
        manageloc = vector4(-212.09, -623.44, 48.24, 235.23), -- Place where you manage the shop
        buyloc = vector4(-211.51, -628.22, 48.23, 185.6), -- Location to buy from shop
        target = true, -- If true it will spawn a vendingmachine at buyloc to target on
        isjob = {
            name = 'police', -- false to disable job
            everyone = true, -- true if all ranks can access
            dutyloc = vector4(-205.95, -627.39, 48.22, 248.61), -- nil to disable
        },
        isgang = {
            name = false, -- false to disable gang
            everyone = false, -- true if all ranks can access
        },
        machine = {
            model = nil, -- Modelname or nil
            offset = { -- Ofset to the zone
                x = 0.0,
                y = 0.0,
                z = 0.0,
            }
        },
        ped = {
            model = 'ig_mp_agent14', -- Name of the ped or nil to disable
            scenario = 'WORLD_HUMAN_CLIPBOARD', -- Scenario the ped will be dpoing
        },
        boxzone = {
            width = 2.0, -- Width of the target / box zone
            depth = 2.0, -- Depth of the target / box zone
            minZ = 2.0, -- Minz of the target zone (No need if not target)
            maxZ = 1.0, -- Maxz of the target zone (No need if not target)
        },
    },
    [2] = {
        shopname = '247shop2', -- Name of shop
        shopprice = 1000, -- Price of this shop. When it is gang or job owned no need for price
        manageloc = vector4(-183.15, -629.38, 48.67, 232.06), -- Place where you manage the shop
        buyloc = vector4(-186.72, -627.37, 48.67, 290.47), -- Location to buy from shop
        target = true, -- If true it will spawn a vendingmachine at buyloc to target on
        isjob = {
            name = 'police', -- false to disable job
            everyone = true, -- true if all ranks can access
            dutyloc = vector4(-192.87, -628.66, 48.67, 238.64), -- nil to disable
        },
        isgang = {
            name = false, -- false to disable gang
            everyone = false, -- true if all ranks can access
        },
        machine = {
            model = nil, -- Modelname or nil
            offset = { -- Ofset to the zone
                x = 0.0,
                y = 0.0,
                z = 0.0,
            }
        },
        ped = {
            model = 'ig_mp_agent14', -- Name of the ped or nil to disable
            scenario = 'WORLD_HUMAN_CLIPBOARD', -- Scenario the ped will be dpoing
        },
        boxzone = {
            width = 2.0, -- Width of the target / box zone
            depth = 2.0, -- Depth of the target / box zone
            minZ = 2.0, -- Minz of the target zone (No need if not target)
            maxZ = 1.0, -- Maxz of the target zone (No need if not target)
        },
    },
}