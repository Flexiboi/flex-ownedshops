Config = {}
Config.Debug = true
Config.inventorylink = 'qs-inventory/html/images/' --Path of your inventory images

Config.Banking = 'fd' -- fd for fd_banking / qb for qb-management
Config.Shops = {
    [1] = {
        shopname = 'test', -- Name of shop
        shopprice = 1000, -- Price of this shop. When it is gang or job owned no need for price
        manageloc = vector4(-212.09, -623.44, 48.24, 235.23), -- Place where you manage the shop
        buyloc = vector4(-212.52, -629.48, 48.23, 249.01), -- Location to buy from shop
        target = false, -- If true it will spawn a vendingmachine at buyloc to target on
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
            model = 'sf_prop_sf_vend_drink_01a', -- Modelname or nil
            offset = { -- Ofset to the zone
                x = 1.0,
                y = 0.0,
                z = 0.0,
            }
        },
        boxzone = {
            width = 2.0, -- Width of the target / box zone
            depth = 2.0, -- Depth of the target / box zone
            minZ = -0.5, -- Minz of the target zone (No need if not target)
            maxZ = 1.0, -- Maxz of the target zone (No need if not target)
        },
    },
    [2] = {
        shopname = 'test2', -- Name of shop
        shopprice = 1000, -- Price of this shop. When it is gang or job owned no need for price
        manageloc = vector4(-186.26, -630.6, 48.67, 238.95), -- Place where you manage the shop
        buyloc = vector4(-184.05, -626.64, 48.67, 235.48), -- Location to buy from shop
        target = false, -- If true it will spawn a vendingmachine at buyloc to target on
        isjob = {
            name = false, -- false to disable job
            everyone = true, -- true if all ranks can access
            dutyloc = vector4(-205.95, -627.39, 48.22, 248.61), -- nil to disable
        },
        isgang = {
            name = false, -- false to disable gang
            everyone = false, -- true if all ranks can access
        },
        machine = {
            model = 'sf_prop_sf_vend_drink_01a', -- Modelname or nil
            offset = { -- Ofset to the zone
                x = 1.0,
                y = 0.0,
                z = 0.0,
            }
        },
        boxzone = {
            width = 2.0, -- Width of the target / box zone
            depth = 2.0, -- Depth of the target / box zone
            minZ = -0.5, -- Minz of the target zone (No need if not target)
            maxZ = 1.0, -- Maxz of the target zone (No need if not target)
        },
    }
}