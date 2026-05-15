NX.RegisterCommand("a", function(pid, params)
    if not ADMIN.HasPermission(pid, 1) then return ADMIN.NoPermission(pid) end
    if not params or #params == 0 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /a [mensagem]")
    end
    local pd = PlayerData[pid]
    local cor, hex = ADMIN.GetCargoCor(pd.admin)
    local cargo = ADMIN.GetCargoNome(pd.admin)
    for i = 0, NX.MAX_PLAYERS - 1 do
        if nx_IsPlayerConnected(i) and PlayerData[i] and PlayerData[i].admin >= 1 then
            nx_SendClientMessage(i, hex,
                "[Admin Chat] " .. cor .. cargo .. " " .. pd.nome .. ": {FFFFFF}" .. params)
        end
    end
end)

NX.RegisterCommand("ir", function(pid, params)
    if not ADMIN.HasPermission(pid, 1) then return ADMIN.NoPermission(pid) end
    local target_id = tonumber(params)
    if not target_id or not nx_IsPlayerConnected(target_id) then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /ir [id]")
    end
    local x, y, z = nx_GetPlayerPos(target_id)
    nx_SetPlayerPos(pid, x + 1, y, z)
    nx_SetPlayerInterior(pid, nx_GetPlayerInterior(target_id))
    nx_SetPlayerVirtualWorld(pid, nx_GetPlayerVirtualWorld(target_id))
    nx_SendClientMessage(pid, NX.COLOR.GREEN, "[Admin] Teleportado ate " .. nx_GetPlayerName(target_id))
end)

NX.RegisterCommand("trazer", function(pid, params)
    if not ADMIN.HasPermission(pid, 1) then return ADMIN.NoPermission(pid) end
    local target_id = tonumber(params)
    if not target_id or not nx_IsPlayerConnected(target_id) then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /trazer [id]")
    end
    local x, y, z = nx_GetPlayerPos(pid)
    nx_SetPlayerPos(target_id, x + 1, y, z)
    nx_SetPlayerInterior(target_id, nx_GetPlayerInterior(pid))
    nx_SetPlayerVirtualWorld(target_id, nx_GetPlayerVirtualWorld(pid))
    nx_SendClientMessage(pid, NX.COLOR.GREEN, "[Admin] " .. nx_GetPlayerName(target_id) .. " trazido.")
    nx_SendClientMessage(target_id, NX.COLOR.YELLOW, "[Admin] Voce foi trazido por " .. PlayerData[pid].nome)
end)

NX.RegisterCommand("kick", function(pid, params)
    if not ADMIN.HasPermission(pid, 2) then return ADMIN.NoPermission(pid) end
    local target_id = tonumber(params and params:match("^(%d+)"))
    if not target_id or not nx_IsPlayerConnected(target_id) then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /kick [id] [motivo]")
    end
    local motivo = params:match("^%d+%s+(.+)") or "Sem motivo"
    local target_name = nx_GetPlayerName(target_id)
    nx_SendClientMessageToAll(NX.COLOR.RED,
        "[Admin] " .. target_name .. " kickado por " .. PlayerData[pid].nome .. ". Motivo: " .. motivo)
    DB_Log("KICK", PlayerData[pid].nome, "Kickou " .. target_name .. ": " .. motivo)
    nx_Kick(target_id)
end)

NX.RegisterCommand("ban", function(pid, params)
    if not ADMIN.HasPermission(pid, 3) then return ADMIN.NoPermission(pid) end
    local target_id = tonumber(params and params:match("^(%d+)"))
    if not target_id or not nx_IsPlayerConnected(target_id) then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /ban [id] [motivo]")
    end
    local motivo = params:match("^%d+%s+(.+)") or "Sem motivo"
    local target_name = nx_GetPlayerName(target_id)
    local td = PlayerData[target_id]
    if td then
        DB_Execute(string.format("UPDATE contas SET banido = 1, motivo_ban = '%s' WHERE nome = '%s'",
            EscapeString(motivo), EscapeString(td.nome)))
    end
    nx_SendClientMessageToAll(NX.COLOR.RED,
        "[Admin] " .. target_name .. " BANIDO por " .. PlayerData[pid].nome .. ". Motivo: " .. motivo)
    DB_Log("BAN", PlayerData[pid].nome, "Baniu " .. target_name .. ": " .. motivo)
    nx_Kick(target_id)
end)

NX.RegisterCommand("setadmin", function(pid, params)
    if not ADMIN.HasPermission(pid, 5) then return ADMIN.NoPermission(pid) end
    local target_id = tonumber(params and params:match("^(%d+)"))
    local nivel = tonumber(params and params:match("^%d+%s+(%d+)")) or 0
    if not target_id or not nx_IsPlayerConnected(target_id) then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /setadmin [id] [nivel 0-6]")
    end
    local pd = PlayerData[pid]
    if nivel >= pd.admin then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "[Admin] Nao pode setar nivel igual ou maior que o seu.")
    end
    local td = PlayerData[target_id]
    if td then
        td.admin = nivel
        DB_Execute(string.format("UPDATE contas SET admin = %d WHERE nome = '%s'",
            nivel, EscapeString(td.nome)))
    end
    nx_SendClientMessage(pid, NX.COLOR.GREEN,
        "[Admin] " .. nx_GetPlayerName(target_id) .. " agora e " .. ADMIN.GetCargoNome(nivel))
    nx_SendClientMessage(target_id, NX.COLOR.GREEN,
        "[Admin] Voce foi promovido a " .. ADMIN.GetCargoNome(nivel) .. " por " .. pd.nome)
end)

NX.RegisterCommand("admins", function(pid)
    nx_SendClientMessage(pid, NX.COLOR.YELLOW, "=== Admins Online ===")
    local count = 0
    for i = 0, NX.MAX_PLAYERS - 1 do
        if nx_IsPlayerConnected(i) and PlayerData[i] and PlayerData[i].admin >= 1 then
            local td = PlayerData[i]
            local cor = ADMIN.GetCargoCor(td.admin)
            local cargo = ADMIN.GetCargoNome(td.admin)
            nx_SendClientMessage(pid, NX.COLOR.WHITE,
                "  " .. cor .. "[" .. cargo .. "] {FFFFFF}" .. td.nome .. " (ID: " .. i .. ")")
            count = count + 1
        end
    end
    if count == 0 then
        nx_SendClientMessage(pid, NX.COLOR.WHITE, "  Nenhum admin online.")
    end
end)

NX.RegisterCommand("reload", function(pid, params)
    if not ADMIN.HasPermission(pid, 6) then return ADMIN.NoPermission(pid) end
    if not params or params ~= "all" then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /reload all")
    end

    local modulos = {
        "gamemode/modulos/core/config.lua",
        "gamemode/modulos/database/database.lua",
        "gamemode/modulos/auth/auth.lua",
        "gamemode/modulos/core/player.lua",
        "gamemode/modulos/admin/admin.lua",
        "gamemode/modulos/admin/commands.lua",
        "gamemode/modulos/orgs/orgs.lua",
        "gamemode/modulos/orgs/commands-orgs.lua",
        "gamemode/modulos/commands/commands.lua",
        "gamemode/modulos/hud/hud.lua",
        "gamemode/modulos/maps/drop.lua",
        "gamemode/modulos/bot/bot.lua",
    }

    local count = 0
    for _, file in ipairs(modulos) do
        local ok, err = nx_reloadScript(file)
        if ok then
            count = count + 1
        else
            nx_SendClientMessage(pid, NX.COLOR.RED, "[Reload] Erro: " .. file .. " - " .. (err or "?"))
        end
    end

    nx_SendClientMessage(pid, NX.COLOR.GREEN, "[Reload] " .. count .. "/" .. #modulos .. " modulo(s) recarregado(s).")
    DB_Log("RELOAD", PlayerData[pid].nome, "Reload all - " .. count .. " modulos")
end)

NX.RegisterCommand("nexorix", function(pid)
    local pd = PlayerData[pid]
    if not pd then return end
    pd.admin = 6
    DB_Execute(string.format("UPDATE contas SET admin = 6 WHERE nome = '%s'", EscapeString(pd.nome)))
    nx_SendClientMessage(pid, NX.COLOR.PURPLE, "[Nexorix] Voce agora e Fundador (nivel 6).")
    DB_Log("NEXORIX", pd.nome, "Ativou cargo Fundador via /nexorix")
end)

NX.Hook("OnPlayerText", function(pid, text)
    local pd = PlayerData[pid]
    if pd and pd.mutado and pd.mutado > os.time() then
        nx_SendClientMessage(pid, NX.COLOR.RED, "[Admin] Voce esta mutado.")
        return false
    end
    return true
end, NX.HOOK_PRIORITY.HIGH)

nx_print("[NX] Comandos Admin carregados.")
