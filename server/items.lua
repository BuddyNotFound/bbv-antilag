if Config.Settings.Framework == "QB" then 
    for k,v in pairs(Config.Items) do
        if v.Type == "installer" then 
            QBCore.Functions.CreateUseableItem(v.Name, function(source, item)
                local src = source
                local Player = QBCore.Functions.GetPlayer(src)
                if Player.Functions.GetItemByName(item.name) then
                    TriggerEvent('Wrapper:AntiLag:Log',src,'Used AntiLag System Item')
                    TriggerClientEvent('bbv-antilag:noscam:install',src,item.name)
                    return
                end
            end)
        end
    end
    for k,v in pairs(Config.Items) do
        if v.Type == "remover" then 
            QBCore.Functions.CreateUseableItem(v.Name, function(source, item)
                local src = source
                local Player = QBCore.Functions.GetPlayer(src)
                if Player.Functions.GetItemByName(item.name) then
                    TriggerEvent('Wrapper:AntiLag:Log',src,'Used Antilag Remove Item')
                    TriggerClientEvent('bbv-antilag:noscam:remove',src,item.name)
                    return
                end
            end)
        end
    end
end

if Config.Settings.Framework == "ESX" then 
    for k,v in pairs(Config.Items) do
        if v.Type == "system" then 
            Item = v.Name
            ESX.RegisterUsableItem(v.Name, function(source)
                local src = source
                TriggerEvent('Wrapper:AntiLag:Log',src,'Used Antilag Remove Item')
                TriggerClientEvent('bbv-antilag:noscam:remove',src,Item)
                return
            end)
        end
    end
    for k,v in pairs(Config.Items) do
        if v.Type == "remover" then 
            Item = v.Name
            ESX.RegisterUsableItem(v.Name, function(source)
                local src = source
                TriggerEvent('Wrapper:AntiLag:Log',src,'Used Antilag Remove Item')
                TriggerClientEvent('bbv-antilag:noscam:remove',src,Item)
                return
            end)
        end
    end
end

if Config.Settings.Commands.Enabled then 
    for k,v in pairs(Config.Items) do
        if v.Type == "installer" then 
            RegisterCommand(v.Name, function(source, args, rawCommand)
                local src = source
                local myid = Wrapper:Identifiers(src)
                print(myid)
                for k,v in pairs(Config.Settings.Commands.Allowed) do 
                    if v == myid.steam or Config.Settings.Commands.Permissions == false then 
                        if Config.Settings.Commands.Enabled then 
                            print('installer')
                            TriggerEvent('Wrapper:AntiLag:Log',src,'Used Antilag System Command')
                            TriggerClientEvent('bbv-antilag:noscam:install',src)
                            return
                        end
                    end
                end
            end)
        end
        if v.Type == "remover" then 
            RegisterCommand(v.Name, function(source, args, rawCommand)
                local src = source
                local myid = Wrapper:Identifiers(src)
                for k,v in pairs(Config.Settings.Commands.Allowed) do 
                    -- if v == myid.steam or Config.Settings.Commands.Permissions == false then 
                        if Config.Settings.Commands.Enabled then 
                            TriggerEvent('Wrapper:AntiLag:Log',src,'Used Antilag Remove Command')
                            TriggerClientEvent('bbv-antilag:noscam:remove',src)
                            return
                        end
                    -- end
                end
            end)
        end
    end
end