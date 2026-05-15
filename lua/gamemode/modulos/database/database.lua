local db_name = "database/nexorix.db"
local db = nil

local function EscapeString(str)
    if not str then return "" end
    str = tostring(str)
    str = str:gsub("'", "''")
    str = str:gsub("\\", "\\\\")
    return str
end

_G.EscapeString = EscapeString

function DB_Init()
    os.execute("mkdir database 2>nul")

    db = nx_db_open(db_name)
    if not db then
        nx_print("!! SQLite: Erro ao abrir banco de dados.")
        return
    end

    nx_print(">> SQLite: Conectado ao " .. db_name)

    nx_db_exec(db, [[
        CREATE TABLE IF NOT EXISTS contas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT UNIQUE NOT NULL,
            senha TEXT NOT NULL,
            sexo TEXT DEFAULT 'Masculino',
            idade INTEGER DEFAULT 18,
            cidade TEXT DEFAULT 'Los Santos',
            skin INTEGER DEFAULT 0,
            dinheiro INTEGER DEFAULT 5000,
            banco INTEGER DEFAULT 0,
            nivel INTEGER DEFAULT 1,
            admin INTEGER DEFAULT 0,
            org INTEGER DEFAULT 0,
            org_cargo INTEGER DEFAULT 0,
            kills INTEGER DEFAULT 0,
            mortes INTEGER DEFAULT 0,
            pos_x REAL DEFAULT 1481.1,
            pos_y REAL DEFAULT -1750.1,
            pos_z REAL DEFAULT 15.5,
            pos_a REAL DEFAULT 0.0,
            vida REAL DEFAULT 100.0,
            colete REAL DEFAULT 0.0,
            data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
            ultimo_login DATETIME DEFAULT CURRENT_TIMESTAMP,
            ip TEXT DEFAULT '',
            banido INTEGER DEFAULT 0,
            motivo_ban TEXT DEFAULT ''
        )
    ]])

    pcall(nx_db_exec, db, "ALTER TABLE contas ADD COLUMN sexo TEXT DEFAULT 'Masculino'")
    pcall(nx_db_exec, db, "ALTER TABLE contas ADD COLUMN idade INTEGER DEFAULT 18")
    pcall(nx_db_exec, db, "ALTER TABLE contas ADD COLUMN cidade TEXT DEFAULT 'Los Santos'")
    pcall(nx_db_exec, db, "ALTER TABLE contas ADD COLUMN org INTEGER DEFAULT 0")
    pcall(nx_db_exec, db, "ALTER TABLE contas ADD COLUMN org_cargo INTEGER DEFAULT 0")

    nx_db_exec(db, [[
        CREATE TABLE IF NOT EXISTS logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tipo TEXT NOT NULL,
            jogador TEXT,
            mensagem TEXT,
            data DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ]])

    nx_print(">> Database: Tabelas criadas/verificadas.")
end

function DB_Query(query)
    if not db then return nil end
    return nx_db_query(db, query)
end

function DB_Execute(query)
    if not db then return false end
    nx_db_exec(db, query)
    return true
end

function DB_ContaExiste(nome)
    if not db then return false end
    local result = nx_db_query(db, "SELECT id FROM contas WHERE nome = '" .. EscapeString(nome) .. "'")
    return result and #result > 0
end

function DB_CriarConta(nome, senha, sexo, idade, cidade, ip, skin)
    if not db then return false end
    local query = string.format(
        "INSERT INTO contas (nome, senha, sexo, idade, cidade, ip, skin) VALUES ('%s', '%s', '%s', %d, '%s', '%s', %d)",
        EscapeString(nome),
        EscapeString(senha),
        EscapeString(sexo),
        idade,
        EscapeString(cidade),
        EscapeString(ip or ""),
        skin or 0
    )
    nx_db_query(db, query)
    DB_Log("REGISTRO", nome, "Nova conta criada")
    return true
end

function DB_VerificarSenha(nome, senha)
    if not db then return false end
    local result = nx_db_query(db, string.format(
        "SELECT id FROM contas WHERE nome = '%s' AND senha = '%s'",
        EscapeString(nome), EscapeString(senha)
    ))
    return result and #result > 0
end

function DB_CarregarConta(playerid)
    if not db then return false end
    local nome = nx_GetPlayerName(playerid)
    local result = nx_db_query(db, "SELECT * FROM contas WHERE nome = '" .. EscapeString(nome) .. "'")
    if not result or #result == 0 then return false end

    local data = result[1]

    PlayerData[playerid] = {
        id = data.id,
        nome = data.nome,
        sexo = data.sexo or "Masculino",
        idade = data.idade or 18,
        cidade = data.cidade or "Los Santos",
        dinheiro = data.dinheiro or 5000,
        banco = data.banco or 0,
        nivel = data.nivel or 1,
        admin = data.admin or 0,
        org = data.org or 0,
        org_cargo = data.org_cargo or 0,
        kills = data.kills or 0,
        mortes = data.mortes or 0,
        skin = data.skin or 0,
        ultimo_login = data.ultimo_login or "",
        logado = true
    }

    nx_SetPlayerSkin(playerid, data.skin or 0)
    nx_GivePlayerMoney(playerid, data.dinheiro or 5000)

    if data.pos_x and data.pos_x ~= 0 then
        nx_SetPlayerPos(playerid, data.pos_x, data.pos_y, data.pos_z)
        nx_SetPlayerFacingAngle(playerid, data.pos_a or 0)
    end

    nx_SetPlayerHealth(playerid, data.vida or 100)
    nx_SetPlayerArmour(playerid, data.colete or 0)

    nx_db_query(db, string.format(
        "UPDATE contas SET ultimo_login = CURRENT_TIMESTAMP, ip = '%s' WHERE nome = '%s'",
        EscapeString((nx_GetPlayerIp and nx_GetPlayerIp(playerid) or "0.0.0.0") or ""),
        EscapeString(nome)
    ))

    return true
end

function DB_SalvarConta(playerid)
    if not db then return end
    local pd = PlayerData[playerid]
    if not pd or not pd.logado then return end

    local x, y, z = nx_GetPlayerPos(playerid)
    local a = nx_GetPlayerFacingAngle(playerid)
    local hp = nx_GetPlayerHealth(playerid)
    local arm = nx_GetPlayerArmour(playerid)
    local skin = nx_GetPlayerSkin(playerid)
    local money = nx_GetPlayerMoney(playerid)

    local query = string.format([[
        UPDATE contas SET
            skin = %d, dinheiro = %d, banco = %d,
            nivel = %d, admin = %d, org = %d, org_cargo = %d,
            kills = %d, mortes = %d,
            pos_x = %.4f, pos_y = %.4f, pos_z = %.4f, pos_a = %.4f,
            vida = %.1f, colete = %.1f,
            ultimo_login = CURRENT_TIMESTAMP
        WHERE nome = '%s'
    ]],
        skin or 0, money or pd.dinheiro, pd.banco,
        pd.nivel, pd.admin, pd.org, pd.org_cargo,
        pd.kills, pd.mortes,
        x or 0, y or 0, z or 0, a or 0,
        hp or 100, arm or 0,
        EscapeString(pd.nome)
    )

    nx_db_query(db, query)
end

function DB_Log(tipo, jogador, mensagem)
    if not db then return end
    nx_db_query(db, string.format(
        "INSERT INTO logs (tipo, jogador, mensagem) VALUES ('%s', '%s', '%s')",
        EscapeString(tipo),
        EscapeString(jogador or "Sistema"),
        EscapeString(mensagem or "")
    ))
end

DB_Init()
