NX.RegisterCommand("ajuda", function(pid)
    local DIALOG_AJUDA = 9000
    local texto = table.concat({
        "Comandos Gerais:\n",
        "/rg - Ver seu documento\n",
        "/ajuda - Este menu\n",
        "/admins - Admins online\n",
        "/gps - Locais do mapa\n",
        "/orgs - Lista de organizacoes\n",
        "/skin [id] - Mudar skin (0-311)\n",
        "/car [id] - Criar veiculo (400-611)\n",
        "\n",
        "Comandos da Organizacao:\n",
        "/org - Info da sua org\n",
        "/membros - Membros online\n",
        "/r [msg] - Chat da org\n",
        "/equipar - Skin da org\n",
    })
    nx_ShowPlayerDialog(pid, DIALOG_AJUDA, 0, "{9B59B6}Ajuda", texto, "Fechar", "")
end)

NX.RegisterCommand("rg", function(pid)
    local pd = PlayerData[pid]
    if not pd then return end

    local org_nome = "Nenhuma"
    if pd.org > 0 then
        local org = SERVER_CONFIG.Orgs[pd.org]
        if org then
            org_nome = org.nome .. " (" .. ORGS.GetCargoNome(pd.org_cargo) .. ")"
        end
    end

    local ultimo = pd.ultimo_login or "Desconhecido"

    local texto = table.concat({
        "Nome: " .. pd.nome .. "\n",
        "RG (IDF): " .. (pd.id or 0) .. "\n",
        "Level: " .. (pd.nivel or 1) .. "\n",
        "Org/Corp: " .. org_nome .. "\n",
        "Ultimo Login: " .. ultimo .. "\n",
    })

    nx_ShowPlayerDialog(pid, 9001, 0, "{9B59B6}Documento de Identidade", texto, "Fechar", "")
end)

NX.RegisterCommand("gps", function(pid)
    local DIALOG_GPS = 9002
    local texto = table.concat({
        "Prefeitura\n",
        "Hospital\n",
        "Banco\n",
        "Autoescola\n",
        "Aeroporto\n",
    })
    nx_ShowPlayerDialog(pid, DIALOG_GPS, 2, "{9B59B6}GPS", texto, "Ir", "Fechar")
end)

NX.Hook("OnDialogResponse", function(playerid, dialogid, response, listitem, inputtext)
    if dialogid == 9002 then
        if response == 0 then return true end
        local locais = {
            {x = 1481.1, y = -1750.1, z = 15.5},
            {x = 1172.0, y = -1323.0, z = 15.4},
            {x = 1460.0, y = -1530.0, z = 15.5},
            {x = 1385.0, y = -1279.0, z = 13.5},
            {x = 1685.0, y = -2335.0, z = 13.5},
        }
        local local_sel = locais[listitem + 1]
        if local_sel then
            nx_SetPlayerPos(playerid, local_sel.x, local_sel.y, local_sel.z)
            nx_SendClientMessage(playerid, NX.COLOR.GREEN, ">> GPS: Teleportado!")
        end
        return true
    end
    return false
end)

NX.RegisterCommand("skin", function(pid, params)
    local skin = tonumber(params)
    if not skin or skin < 0 or skin > 311 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /skin [0-311]")
    end
    nx_SetPlayerSkin(pid, skin)
    PlayerData[pid].skin = skin
    nx_SendClientMessage(pid, NX.COLOR.GREEN, ">> Skin alterada para " .. skin)
end)

NX.RegisterCommand("car", function(pid, params)
    local model = tonumber(params)
    if not model or model < 400 or model > 611 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /car [400-611]")
    end
    local x, y, z = nx_GetPlayerPos(pid)
    local a = nx_GetPlayerFacingAngle(pid)
    local veh = nx_CreateVehicle(model, x + 3, y, z, a, -1, -1, -1)
    nx_PutPlayerInVehicle(pid, veh, 0)
    nx_SendClientMessage(pid, NX.COLOR.GREEN, ">> Veiculo " .. model .. " criado!")
end)

nx_print("[NX] Modulo Commands carregado.")
