local DIALOG = {
    LOGIN      = 1000,
    REG_SENHA  = 1001,
    REG_SEXO   = 1002,
    REG_IDADE  = 1003,
    REG_CIDADE = 1004,
}

local login_tentativas = {}
local MAX_TENTATIVAS = 3
local reg_temp = {}

local function MostrarLogin(playerid)
    local nome = nx_GetPlayerName(playerid)
    nx_ShowPlayerDialog(playerid, DIALOG.LOGIN, 3,
        "{9B59B6}Login",
        "Bem-vindo de volta, " .. nome .. "!\n\nDigite sua senha para entrar:",
        "Entrar", "Sair"
    )
end

local function MostrarRegSenha(playerid)
    local nome = nx_GetPlayerName(playerid)
    nx_ShowPlayerDialog(playerid, DIALOG.REG_SENHA, 3,
        "{9B59B6}Registro - Senha",
        "Ola, " .. nome .. "!\n\nConta nao registrada.\nDigite uma senha:\n\n(Minimo 4 caracteres)",
        "Proximo", "Sair"
    )
end

local function MostrarRegSexo(playerid)
    nx_ShowPlayerDialog(playerid, DIALOG.REG_SEXO, 4,
        "{9B59B6}Registro - Sexo",
        "Masculino\nFeminino",
        "Proximo", ""
    )
end

local function MostrarRegIdade(playerid)
    nx_ShowPlayerDialog(playerid, DIALOG.REG_IDADE, 1,
        "{9B59B6}Registro - Idade",
        "Digite sua idade:\n\n(Entre 16 e 60)",
        "Proximo", "Voltar"
    )
end

local function MostrarRegCidade(playerid)
    nx_ShowPlayerDialog(playerid, DIALOG.REG_CIDADE, 4,
        "{9B59B6}Registro - Cidade",
        "Los Santos\nSan Fierro\nLas Venturas",
        "Finalizar", "Voltar"
    )
end

NX.Hook("OnPlayerConnect", function(playerid)
    PlayerData[playerid] = {logado = false, nome = nx_GetPlayerName(playerid)}
    login_tentativas[playerid] = 0
    reg_temp[playerid] = {}

    nx_TogglePlayerSpectating(playerid, true)

    if DB_ContaExiste(nx_GetPlayerName(playerid)) then
        MostrarLogin(playerid)
    else
        MostrarRegSenha(playerid)
    end
end, NX.HOOK_PRIORITY.HIGH)

NX.Hook("OnPlayerDisconnect", function(playerid, reason)
    if PlayerData[playerid] and PlayerData[playerid].logado then
        DB_SalvarConta(playerid)
    end
    PlayerData[playerid] = nil
    login_tentativas[playerid] = nil
    reg_temp[playerid] = nil
end, NX.HOOK_PRIORITY.HIGH)

NX.Hook("OnDialogResponse", function(playerid, dialogid, response, listitem, inputtext)
    if dialogid == DIALOG.LOGIN then
        if response == 0 then
            nx_Kick(playerid)
            return true
        end
        local nome = nx_GetPlayerName(playerid)
        if DB_VerificarSenha(nome, inputtext or "") then
            DB_CarregarConta(playerid)
            nx_SendClientMessage(playerid, NX.COLOR.GREEN, ">> Login realizado com sucesso!")
            nx_TogglePlayerSpectating(playerid, false)
            nx_SpawnPlayer(playerid)
        else
            login_tentativas[playerid] = (login_tentativas[playerid] or 0) + 1
            if login_tentativas[playerid] >= MAX_TENTATIVAS then
                nx_SendClientMessage(playerid, NX.COLOR.RED, ">> Muitas tentativas. Desconectado.")
                nx_Kick(playerid)
            else
                nx_SendClientMessage(playerid, NX.COLOR.RED,
                    ">> Senha incorreta! Restam: " .. (MAX_TENTATIVAS - login_tentativas[playerid]))
                MostrarLogin(playerid)
            end
        end
        return true
    end

    if dialogid == DIALOG.REG_SENHA then
        if response == 0 then nx_Kick(playerid); return true end
        local senha = inputtext or ""
        if #senha < 4 then
            nx_SendClientMessage(playerid, NX.COLOR.RED, ">> Senha deve ter no minimo 4 caracteres!")
            MostrarRegSenha(playerid)
            return true
        end
        reg_temp[playerid].senha = senha
        MostrarRegSexo(playerid)
        return true
    end

    if dialogid == DIALOG.REG_SEXO then
        local sexos = {"Masculino", "Feminino"}
        reg_temp[playerid].sexo = sexos[listitem + 1] or "Masculino"
        MostrarRegIdade(playerid)
        return true
    end

    if dialogid == DIALOG.REG_IDADE then
        if response == 0 then MostrarRegSexo(playerid); return true end
        local idade = tonumber(inputtext)
        if not idade or idade < 16 or idade > 60 then
            nx_SendClientMessage(playerid, NX.COLOR.RED, ">> Idade invalida! (16-60)")
            MostrarRegIdade(playerid)
            return true
        end
        reg_temp[playerid].idade = idade
        MostrarRegCidade(playerid)
        return true
    end

    if dialogid == DIALOG.REG_CIDADE then
        if response == 0 then MostrarRegIdade(playerid); return true end
        local cidades = {"Los Santos", "San Fierro", "Las Venturas"}
        reg_temp[playerid].cidade = cidades[listitem + 1] or "Los Santos"

        local nome = nx_GetPlayerName(playerid)
        local ip = (nx_GetPlayerIp and nx_GetPlayerIp(playerid)) or "0.0.0.0"
        local rt = reg_temp[playerid]

        local skin_padrao = rt.sexo == "Feminino" and 12 or 26

        if DB_CriarConta(nome, rt.senha, rt.sexo, rt.idade, rt.cidade, ip, skin_padrao) then
            DB_CarregarConta(playerid)
            nx_SetPlayerSkin(playerid, skin_padrao)
            nx_SendClientMessage(playerid, NX.COLOR.GREEN, ">> Conta criada com sucesso!")
            nx_TogglePlayerSpectating(playerid, false)
            nx_SpawnPlayer(playerid)
        else
            nx_SendClientMessage(playerid, NX.COLOR.RED, ">> Erro ao criar conta.")
            MostrarRegSenha(playerid)
        end
        reg_temp[playerid] = nil
        return true
    end

    return false
end, NX.HOOK_PRIORITY.HIGHEST)

NX.Hook("OnPlayerSpawn", function(playerid)
    if not PlayerData[playerid] or not PlayerData[playerid].logado then
        return false
    end
end, NX.HOOK_PRIORITY.HIGHEST)

NX.Hook("OnPlayerCommand", function(playerid, cmdtext)
    if not PlayerData[playerid] or not PlayerData[playerid].logado then
        nx_SendClientMessage(playerid, NX.COLOR.RED, ">> Faca login primeiro!")
        return true
    end
    return false
end, NX.HOOK_PRIORITY.HIGHEST)

nx_print("[NX] Sistema Auth carregado.")
