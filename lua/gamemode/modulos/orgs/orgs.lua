ORGS = ORGS or {}

ORGS.CARGOS = {
    [0] = "Membro",
    [1] = "Sub-Lider",
    [2] = "Lider",
}

function ORGS.GetNome(org_id)
    local org = SERVER_CONFIG.Orgs[org_id]
    return org and org.nome or "Nenhuma"
end

function ORGS.GetCor(org_id)
    local org = SERVER_CONFIG.Orgs[org_id]
    if org then return org.cor, org.hex end
    return "{FFFFFF}", 0xFFFFFFFF
end

function ORGS.GetTipo(org_id)
    local org = SERVER_CONFIG.Orgs[org_id]
    return org and org.tipo or "nenhum"
end

function ORGS.GetCargoNome(cargo)
    return ORGS.CARGOS[cargo] or "Membro"
end

function ORGS.IsMembro(pid)
    local pd = PlayerData[pid]
    return pd and pd.org > 0
end

function ORGS.IsLider(pid)
    local pd = PlayerData[pid]
    return pd and pd.org_cargo >= 2
end

function ORGS.MembrosOnline(org_id)
    local lista = {}
    for i = 0, NX.MAX_PLAYERS - 1 do
        if nx_IsPlayerConnected(i) and PlayerData[i] and PlayerData[i].org == org_id then
            table.insert(lista, {id = i, nome = PlayerData[i].nome, cargo = PlayerData[i].org_cargo})
        end
    end
    return lista
end

nx_print("[NX] Sistema de Orgs carregado.")
