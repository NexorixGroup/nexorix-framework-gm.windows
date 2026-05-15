PlayerData = PlayerData or {}

NX.Hook("OnPlayerConnect", function(playerid)
    local name = nx_GetPlayerName(playerid)
    if nx_EnableStuntBonusForPlayer then
        nx_EnableStuntBonusForPlayer(playerid, false)
    end
    nx_SendClientMessageToAll(NX.COLOR.WHITE, "{00FF00}[+]{FFFFFF} " .. name .. " entrou no servidor.")
end)

NX.Hook("OnPlayerDisconnect", function(playerid, reason)
    local name = nx_GetPlayerName(playerid)
    local reasons = {[0] = "Timeout", [1] = "Saiu", [2] = "Kick/Ban"}
    nx_SendClientMessageToAll(NX.COLOR.WHITE,
        "{FF0000}[-]{FFFFFF} " .. name .. " saiu. (" .. (reasons[reason] or "?") .. ")")
end)

NX.Hook("OnPlayerSpawn", function(playerid)
    if not PlayerData[playerid] or not PlayerData[playerid].logado then return end
    local pd = PlayerData[playerid]
    nx_ClearAnimations(playerid, 1)
    nx_SetPlayerSkin(playerid, pd.skin or 0)
    if not pd.pos_loaded then
        local sp = SERVER_CONFIG.SpawnPos
        nx_SetPlayerPos(playerid, sp.x, sp.y, sp.z)
        nx_SetPlayerFacingAngle(playerid, sp.a or 0)
        pd.pos_loaded = true
    end
    nx_SetCameraBehindPlayer(playerid)
    return 1
end)

NX.Hook("OnPlayerDeath", function(playerid, killerid, reason)
    if PlayerData[playerid] then
        PlayerData[playerid].mortes = (PlayerData[playerid].mortes or 0) + 1
    end
    if killerid ~= NX.INVALID_PLAYER_ID and PlayerData[killerid] then
        PlayerData[killerid].kills = (PlayerData[killerid].kills or 0) + 1
    end
end)

nx_print("[NX] Modulo Player carregado.")
