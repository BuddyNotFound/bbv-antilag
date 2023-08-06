Config = {}

QBCore = exports['qb-core']:GetCoreObject()  -- uncomment if you use QBCore
-- ESX = exports["es_extended"]:getSharedObject() -- uncomment if you use ESX

Config.Settings = {
    Framework = "QB", -- QB/ESX/ST (ST - Standalone) used for the notify
    ParticleUsed = 'veh_xs_vehicle_mods', -- Particle used (if you are using colors from : https://forum.cfx.re/t/paid-nitro-system-changeable-colors-much-more-qb-esx-standalone/5156013)
    RPM = 0.65, -- the RPM when the pop/antilag gets triggered
    InstallDist = 2.5,
    WebHook = "",
    Commands = {
        Enabled = true, -- if set to true all 'Config.Items' will also be created as commands (used when framework is Standalone) can also be used with frameworks like admin commands
        Permissions = false, -- if set to true only "allowed" user will be ablo to use them
        Allowed = { -- users allowed to use commands
            'steam:11000013b******', -- Buddy 
            'steam:steamid',
        },
    },
}

Config.Items = {
    AntiLag = {
        Name = "antilag_installer", -- the name of the item used to install the nitro system on a vehicle, if framework is "ST" it will create a command with that name
        Type = "installer",  -- don't change
    },
    AntiLagRemove = {
        Name = "antilag_remover", -- Name of the Item / Command if enabled
        Type = 'remover', -- don't change
    },
}