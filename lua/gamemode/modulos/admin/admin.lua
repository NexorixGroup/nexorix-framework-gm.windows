ADMIN = ADMIN or {}

ADMIN.CARGOS = {
    [1] = {nome = "Ajudante", cor = "{00BFFF}", hex = 0x00BFFFFF},
    [2] = {nome = "Moderador", cor = "{1E90FF}", hex = 0x1E90FFFF},
    [3] = {nome = "Administrador", cor = "{FF8C00}", hex = 0xFF8C00FF},
    [4] = {nome = "Gerente", cor = "{FF4500}", hex = 0xFF4500FF},
    [5] = {nome = "Sub Dono", cor = "{DC143C}", hex = 0xDC143CFF},
    [6] = {nome = "Fundador", cor = "{FF0000}", hex = 0xFF0000FF},
}

function ADMIN.GetCargoNome(level)
    local cargo = ADMIN.CARGOS[level]
    return cargo and cargo.nome or "Jogador"
end

function ADMIN.GetCargoCor(level)
    local cargo = ADMIN.CARGOS[level]
    if cargo then return cargo.cor, cargo.hex end
    return "{FFFFFF}", 0xFFFFFFFF
end

function ADMIN.HasPermission(pid, min_level)
    local pd = PlayerData[pid]
    if not pd then return false end
    return (pd.admin or 0) >= min_level
end

function ADMIN.NoPermission(pid)
    nx_SendClientMessage(pid, NX.COLOR.RED, "[Admin] Voce nao tem permissao.")
end

function ADMIN.Broadcast(pid, msg)
    local pd = PlayerData[pid]
    if not pd then return end
    local cor, hex = ADMIN.GetCargoCor(pd.admin)
    local cargo = ADMIN.GetCargoNome(pd.admin)
    nx_SendClientMessageToAll(hex, "[" .. cargo .. "] " .. pd.nome .. ": " .. msg)
end

nx_print("[NX] Sistema Admin carregado.")
