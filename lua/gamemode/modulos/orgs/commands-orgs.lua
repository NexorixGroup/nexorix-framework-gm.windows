NX.RegisterCommand("org", function(pid)
    local pd = PlayerData[pid]
    if not pd then return end
    if pd.org == 0 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Voce nao pertence a nenhuma organizacao.")
    end
    local org = SERVER_CONFIG.Orgs[pd.org]
    nx_SendClientMessage(pid, NX.COLOR.YELLOW, "=== Sua Organizacao ===")
    nx_SendClientMessage(pid, NX.COLOR.WHITE, "Nome: " .. org.cor .. org.nome)
    nx_SendClientMessage(pid, NX.COLOR.WHITE, "Tipo: " .. (org.tipo == "pm" and "Policial" or "Organizacao"))
    nx_SendClientMessage(pid, NX.COLOR.WHITE, "Seu Cargo: " .. ORGS.GetCargoNome(pd.org_cargo))
    local membros = ORGS.MembrosOnline(pd.org)
    nx_SendClientMessage(pid, NX.COLOR.WHITE, "Membros Online: " .. #membros)
end)

NX.RegisterCommand("orgs", function(pid)
    nx_SendClientMessage(pid, NX.COLOR.YELLOW, "=== Organizacoes ===")
    for id, org in pairs(SERVER_CONFIG.Orgs) do
        local tipo_str = org.tipo == "pm" and "{0000FF}[PM]" or "{FF4444}[ORG]"
        local membros = ORGS.MembrosOnline(id)
        nx_SendClientMessage(pid, NX.COLOR.WHITE,
            "  " .. tipo_str .. " " .. org.cor .. org.nome .. " {FFFFFF}| Online: " .. #membros)
    end
end)

NX.RegisterCommand("convidar", function(pid, params)
    local pd = PlayerData[pid]
    if not pd or pd.org == 0 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Voce nao pertence a nenhuma org.")
    end
    if pd.org_cargo < 1 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Somente Sub-Lider+ pode convidar.")
    end
    local target_id = tonumber(params)
    if not target_id or not nx_IsPlayerConnected(target_id) then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /convidar [id]")
    end
    local td = PlayerData[target_id]
    if not td then return end
    if td.org > 0 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Jogador ja pertence a uma org.")
    end
    td.org = pd.org
    td.org_cargo = 0
    DB_Execute(string.format("UPDATE contas SET org = %d, org_cargo = 0 WHERE nome = '%s'",
        pd.org, EscapeString(td.nome)))
    local org_nome = ORGS.GetNome(pd.org)
    nx_SendClientMessage(pid, NX.COLOR.GREEN, ">> " .. td.nome .. " entrou na " .. org_nome)
    nx_SendClientMessage(target_id, NX.COLOR.GREEN, ">> Voce entrou na " .. org_nome)
end)

NX.RegisterCommand("expulsar", function(pid, params)
    local pd = PlayerData[pid]
    if not pd or pd.org == 0 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Voce nao pertence a nenhuma org.")
    end
    if pd.org_cargo < 2 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Somente Lider pode expulsar.")
    end
    local target_id = tonumber(params)
    if not target_id or not nx_IsPlayerConnected(target_id) then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /expulsar [id]")
    end
    local td = PlayerData[target_id]
    if not td or td.org ~= pd.org then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Jogador nao pertence a sua org.")
    end
    local org_nome = ORGS.GetNome(pd.org)
    td.org = 0
    td.org_cargo = 0
    DB_Execute(string.format("UPDATE contas SET org = 0, org_cargo = 0 WHERE nome = '%s'",
        EscapeString(td.nome)))
    nx_SendClientMessage(pid, NX.COLOR.GREEN, ">> " .. td.nome .. " foi expulso da " .. org_nome)
    nx_SendClientMessage(target_id, NX.COLOR.RED, ">> Voce foi expulso da " .. org_nome)
end)

NX.RegisterCommand("promover", function(pid, params)
    local pd = PlayerData[pid]
    if not pd or pd.org == 0 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Voce nao pertence a nenhuma org.")
    end
    if pd.org_cargo < 2 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Somente Lider pode promover.")
    end
    local target_id = tonumber(params)
    if not target_id or not nx_IsPlayerConnected(target_id) then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /promover [id]")
    end
    local td = PlayerData[target_id]
    if not td or td.org ~= pd.org then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Jogador nao pertence a sua org.")
    end
    if td.org_cargo >= 1 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Jogador ja e Sub-Lider.")
    end
    td.org_cargo = 1
    DB_Execute(string.format("UPDATE contas SET org_cargo = 1 WHERE nome = '%s'",
        EscapeString(td.nome)))
    nx_SendClientMessage(pid, NX.COLOR.GREEN, ">> " .. td.nome .. " promovido a Sub-Lider.")
    nx_SendClientMessage(target_id, NX.COLOR.GREEN, ">> Voce foi promovido a Sub-Lider!")
end)

NX.RegisterCommand("setarlider", function(pid, params)
    if not ADMIN.HasPermission(pid, 4) then return ADMIN.NoPermission(pid) end
    local target_id = tonumber(params and params:match("^(%d+)"))
    local org_id = tonumber(params and params:match("^%d+%s+(%d+)"))
    if not target_id or not org_id or not nx_IsPlayerConnected(target_id) then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /setarlider [id] [org_id 1-4]")
    end
    if not SERVER_CONFIG.Orgs[org_id] then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Org invalida. (1-4)")
    end
    local td = PlayerData[target_id]
    if not td then return end
    td.org = org_id
    td.org_cargo = 2
    DB_Execute(string.format("UPDATE contas SET org = %d, org_cargo = 2 WHERE nome = '%s'",
        org_id, EscapeString(td.nome)))
    local org_nome = ORGS.GetNome(org_id)
    nx_SendClientMessage(pid, NX.COLOR.GREEN, ">> " .. td.nome .. " agora e Lider da " .. org_nome)
    nx_SendClientMessage(target_id, NX.COLOR.GREEN, ">> Voce agora e Lider da " .. org_nome)
end)

NX.RegisterCommand("r", function(pid, params)
    local pd = PlayerData[pid]
    if not pd or pd.org == 0 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Voce nao pertence a nenhuma org.")
    end
    if not params or #params == 0 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, "Use: /r [mensagem]")
    end
    local org = SERVER_CONFIG.Orgs[pd.org]
    local cargo = ORGS.GetCargoNome(pd.org_cargo)
    for i = 0, NX.MAX_PLAYERS - 1 do
        if nx_IsPlayerConnected(i) and PlayerData[i] and PlayerData[i].org == pd.org then
            nx_SendClientMessage(i, org.hex,
                "[" .. org.nome .. "] " .. cargo .. " " .. pd.nome .. ": {FFFFFF}" .. params)
        end
    end
end)

NX.RegisterCommand("membros", function(pid)
    local pd = PlayerData[pid]
    if not pd or pd.org == 0 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Voce nao pertence a nenhuma org.")
    end
    local org = SERVER_CONFIG.Orgs[pd.org]
    local membros = ORGS.MembrosOnline(pd.org)
    nx_SendClientMessage(pid, NX.COLOR.YELLOW, "=== " .. org.nome .. " | Membros Online ===")
    for _, m in ipairs(membros) do
        nx_SendClientMessage(pid, NX.COLOR.WHITE,
            "  [" .. ORGS.GetCargoNome(m.cargo) .. "] " .. m.nome .. " (ID: " .. m.id .. ")")
    end
    if #membros == 0 then
        nx_SendClientMessage(pid, NX.COLOR.WHITE, "  Nenhum membro online.")
    end
end)

NX.RegisterCommand("equipar", function(pid)
    local pd = PlayerData[pid]
    if not pd or pd.org == 0 then
        return nx_SendClientMessage(pid, NX.COLOR.RED, ">> Voce nao pertence a nenhuma org.")
    end
    local org = SERVER_CONFIG.Orgs[pd.org]
    nx_SetPlayerSkin(pid, org.skin)
    nx_SendClientMessage(pid, NX.COLOR.GREEN, ">> Skin da org equipada.")
end)

nx_print("[NX] Comandos Orgs carregados.")
