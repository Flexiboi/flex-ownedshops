Config = {}
Config.Debug = true
Config.inventorylink = 'qs-inventory/html/images/' --Path of your inventory images

Config.Banking = 'fd' -- fd for fd_banking / qb for qb-management
Config.Shops = {
    [1] = {
        shopname = 'test', -- Name of shop
        shopprice = 1000, -- Price of this shop. When it is gang or job owned no need for price
        manageloc = vector4(-212.09, -623.44, 48.24, 235.23), -- Place where you manage the shop
        buyloc = vector4(-334.16, -830.49, 31.56, 173.08), -- Location to buy from shop
        target = true, -- If true it will spawn a vendingmachine at buyloc to target on
        isjob = {
            name = 'galaxy', -- false to disable job
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
            model = 'a_f_m_ktown_02', -- Name of the ped or nil to disable
            scenario = 'WORLD_HUMAN_BINOCULARS', -- Scenario the ped will be dpoing
        },
        boxzone = {
            width = 2.0, -- Width of the target / box zone
            depth = 2.0, -- Depth of the target / box zone
            minZ = 2.0, -- Minz of the target zone (No need if not target)
            maxZ = 1.0, -- Maxz of the target zone (No need if not target)
        },
    },
}