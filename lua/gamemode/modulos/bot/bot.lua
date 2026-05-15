local canais = SERVER_CONFIG.Bot.canais
local sistemas = SERVER_CONFIG.Bot.sistemas

local function SendToChannel(channel_id, msg)
    if discord_sendMessage then
        discord_sendMessage(channel_id, msg)
    end
end

local function SendEmbedToChannel(channel_id, title, description, color)
    if discord_sendEmbed then
        discord_sendEmbed(channel_id, {
            title = title,
            description = description,
            color = color or 3066993
        })
    end
end

function Discord_Log(msg)
    SendToChannel(canais.logs, msg)
end

function Discord_System(title, description, color)
    SendEmbedToChannel(canais.system, title, description, color)
end

function Discord_Servidor(title, description, color)
    SendEmbedToChannel(canais.servidor, title, description, color)
end

if sistemas.servidor_onoff then
    NX.Hook("OnGameModeInit", function()
        Discord_System(
            "Servidor Online",
            "**" .. SERVER_CONFIG.Name .. "** v" .. SERVER_CONFIG.Version .. " iniciado!",
            65280
        )
    end, NX.HOOK_PRIORITY.LOW)

    NX.Hook("OnGameModeExit", function()
        Discord_System("Servidor Offline", "O servidor foi desligado.", 16711680)
    end, NX.HOOK_PRIORITY.LOW)
end

if sistemas.entrada_saida then
    NX.Hook("OnPlayerConnect", function(playerid)
        local name = nx_GetPlayerName(playerid)
        Discord_Servidor("Jogador Conectou", "**" .. name .. "** entrou no servidor.", 3447003)
    end, NX.HOOK_PRIORITY.LOW)

    NX.Hook("OnPlayerDisconnect", function(playerid, reason)
        local name = nx_GetPlayerName(playerid)
        local reasons = {[0] = "Timeout", [1] = "Saiu", [2] = "Kick/Ban"}
        Discord_Servidor("Jogador Saiu",
            "**" .. name .. "** saiu. (" .. (reasons[reason] or "?") .. ")", 15105570)
    end, NX.HOOK_PRIORITY.LOW)
end

if sistemas.logs_chat then
    NX.Hook("OnPlayerText", function(playerid, text)
        local name = nx_GetPlayerName(playerid)
        Discord_Log("**" .. name .. ":** " .. text)
        return true
    end, NX.HOOK_PRIORITY.LOW)
end

if discord_registerCommand then
    discord_registerCommand("perfil", function(user, args, channel)
        local reply = channel or canais.servidor
        if not args or #args == 0 then
            return SendToChannel(reply, "Use: !perfil [nome]")
        end
        local nome = args:match("^(%S+)")
        if not nome then
            return SendToChannel(reply, "Use: !perfil [nome]")
        end
        local found = false
        for i = 0, NX.MAX_PLAYERS - 1 do
            if nx_IsPlayerConnected(i) and PlayerData[i] and PlayerData[i].nome == nome then
                local pd = PlayerData[i]
                local org_nome = "Nenhuma"
                if pd.org > 0 and SERVER_CONFIG.Orgs[pd.org] then
                    org_nome = SERVER_CONFIG.Orgs[pd.org].nome
                end
                SendEmbedToChannel(reply, "Perfil de " .. nome,
                    "**Level:** " .. (pd.nivel or 1) .. "\n" ..
                    "**Kills:** " .. (pd.kills or 0) .. " | **Mortes:** " .. (pd.mortes or 0) .. "\n" ..
                    "**Org:** " .. org_nome .. "\n" ..
                    "**Admin:** " .. ADMIN.GetCargoNome(pd.admin or 0),
                    3066993
                )
                found = true
                break
            end
        end
        if not found then
            SendToChannel(reply, "Jogador **" .. nome .. "** nao esta online.")
        end
    end)

    discord_registerCommand("players", function(user, args, channel)
        local reply = channel or canais.servidor
        local count = 0
        local names = {}
        for i = 0, NX.MAX_PLAYERS - 1 do
            if nx_IsPlayerConnected(i) then
                count = count + 1
                table.insert(names, nx_GetPlayerName(i))
            end
        end
        if count == 0 then
            SendToChannel(reply, "Nenhum jogador online.")
        else
            SendEmbedToChannel(reply, "Jogadores Online (" .. count .. ")",
                table.concat(names, ", "), 3066993)
        end
    end)

    discord_registerCommand("status", function(user, args, channel)
        local reply = channel or canais.servidor
        local count = 0
        for i = 0, NX.MAX_PLAYERS - 1 do
            if nx_IsPlayerConnected(i) then count = count + 1 end
        end
        SendEmbedToChannel(reply, "Status do Servidor",
            "**Nome:** " .. SERVER_CONFIG.Name .. "\n" ..
            "**Versao:** " .. SERVER_CONFIG.Version .. "\n" ..
            "**Jogadores:** " .. count .. "/" .. SERVER_CONFIG.MaxPlayers,
            3066993
        )
    end)
end

nx_print("[NX] Modulo Bot carregado.")
