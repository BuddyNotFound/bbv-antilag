Config = {}

Config.Settings = {
    Framework = "QB", -- QB/ESX/ST (ST - Standalone) used for the notify
    ParticleUsed = 'veh_xs_vehicle_mods', -- Particle used (if you are using colors from : https://forum.cfx.re/t/paid-nitro-system-changeable-colors-much-more-qb-esx-standalone/5156013)
    EnableAll = false, -- if set to true it will work on all cars
    RPM = 0.65 -- the RPM when the pop/antilag gets triggered
}

Config.Cars = { -- cars that will have pop/antilag if EnableAll is set to false
    "elegy",
    "maj350z",
    "t20",
}