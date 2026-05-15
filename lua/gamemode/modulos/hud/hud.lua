local HudVC = {}
local HUD_COUNT = 77

local function td(index, x, y, text, opts)
    HudVC[index] = nx_TextDrawCreate(x, y, text)
    local id = HudVC[index]
    if opts.textSize then nx_TextDrawTextSize(id, opts.textSize[1], opts.textSize[2]) end
    if opts.letterSize then nx_TextDrawLetterSize(id, opts.letterSize[1], opts.letterSize[2]) end
    nx_TextDrawAlignment(id, opts.align or 1)
    nx_TextDrawColor(id, opts.color or -1)
    nx_TextDrawSetShadow(id, opts.shadow or 0)
    nx_TextDrawSetOutline(id, opts.outline or 0)
    nx_TextDrawBackgroundColor(id, opts.bgColor or 255)
    nx_TextDrawFont(id, opts.font or 4)
    nx_TextDrawSetProportional(id, 1)
end

function HUD_Create()
    local C_BG = 471604479
    local C_VIDA = 982761471
    local C_SEDE = -8371969
    local C_FOME = 2026390015
    local C_COLETE = -1411321601
    local C_ENERGIA = -79609345
    local C_WHITE = -1

    td(0, 607, 414, "LD_SPAC:white", {textSize={14,23}, color=C_BG, font=4})
    td(1, 604, 419, "LD_SPAC:white", {textSize={21,14}, color=C_BG, font=4})
    td(2, 602, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(3, 602, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(4, 616, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(5, 616, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})

    td(6, 607, 414, "LD_SPAC:white", {textSize={14,23}, color=C_VIDA, font=4})
    td(7, 604, 419, "LD_SPAC:white", {textSize={21,14}, color=C_VIDA, font=4})
    td(8, 602, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_VIDA, font=4})
    td(9, 602, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_VIDA, font=4})
    td(10, 616, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_VIDA, font=4})
    td(11, 616, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_VIDA, font=4})

    td(12, 581, 414, "LD_SPAC:white", {textSize={14,23}, color=C_BG, font=4})
    td(13, 578, 419, "LD_SPAC:white", {textSize={21,14}, color=C_BG, font=4})
    td(14, 576, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(15, 576, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(16, 590, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(17, 590, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})

    td(18, 581, 414, "LD_SPAC:white", {textSize={14,23}, color=C_SEDE, font=4})
    td(19, 578, 419, "LD_SPAC:white", {textSize={21,14}, color=C_SEDE, font=4})
    td(20, 576, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_SEDE, font=4})
    td(21, 576, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_SEDE, font=4})
    td(22, 590, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_SEDE, font=4})
    td(23, 590, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_SEDE, font=4})

    td(24, 555, 414, "LD_SPAC:white", {textSize={14,23}, color=C_BG, font=4})
    td(25, 552, 419, "LD_SPAC:white", {textSize={21,14}, color=C_BG, font=4})
    td(26, 550, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(27, 550, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(28, 564, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(29, 564, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})

    td(30, 555, 414, "LD_SPAC:white", {textSize={14,23}, color=C_FOME, font=4})
    td(31, 552, 419, "LD_SPAC:white", {textSize={21,14}, color=C_FOME, font=4})
    td(32, 550, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_FOME, font=4})
    td(33, 550, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_FOME, font=4})
    td(34, 564, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_FOME, font=4})
    td(35, 564, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_FOME, font=4})

    td(36, 529, 414, "LD_SPAC:white", {textSize={14,23}, color=C_BG, font=4})
    td(37, 526, 419, "LD_SPAC:white", {textSize={21,14}, color=C_BG, font=4})
    td(38, 524, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(39, 524, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(40, 538, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(41, 538, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})

    td(42, 529, 414, "LD_SPAC:white", {textSize={14,23}, color=C_COLETE, font=4})
    td(43, 526, 419, "LD_SPAC:white", {textSize={21,14}, color=C_COLETE, font=4})
    td(44, 524, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_COLETE, font=4})
    td(45, 524, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_COLETE, font=4})
    td(46, 538, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_COLETE, font=4})
    td(47, 538, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_COLETE, font=4})

    td(48, 503, 414, "LD_SPAC:white", {textSize={14,23}, color=C_BG, font=4})
    td(49, 500, 419, "LD_SPAC:white", {textSize={21,14}, color=C_BG, font=4})
    td(50, 498, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(51, 498, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(52, 512, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})
    td(53, 512, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_BG, font=4})

    td(54, 503, 414, "LD_SPAC:white", {textSize={14,23}, color=C_ENERGIA, font=4})
    td(55, 500, 419, "LD_SPAC:white", {textSize={21,14}, color=C_ENERGIA, font=4})
    td(56, 498, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_ENERGIA, font=4})
    td(57, 498, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_ENERGIA, font=4})
    td(58, 512, 412, "LD_BEAT:chit", {textSize={10,13}, color=C_ENERGIA, font=4})
    td(59, 512, 426, "LD_BEAT:chit", {textSize={10,13}, color=C_ENERGIA, font=4})

    td(60, 609, 421, "LD_BEAT:chit", {textSize={11,14}, color=C_WHITE, font=4})
    td(61, 610, 430, "V", {letterSize={0.369,-1.4}, color=C_WHITE, font=1, bgColor=150})
    td(62, 612, 420, "LD_BEAT:chit", {textSize={5,11}, color=C_WHITE, font=4})
    td(63, 615, 432, ")", {letterSize={0.21,-0.8}, color=C_VIDA, font=1, bgColor=150})

    td(64, 586, 418, "LD_BEAT:chit", {textSize={9,11}, color=C_WHITE, font=4})
    td(65, 584, 420, "LD_BEAT:chit", {textSize={9,11}, color=C_WHITE, font=4})
    td(66, 582, 431, "\\", {letterSize={0.549,-0.6}, color=C_WHITE, font=1, bgColor=150})
    td(67, 582, 427, "LD_BEAT:chit", {textSize={4,5}, color=C_WHITE, font=4})
    td(68, 588, 423, "LD_BEAT:chit", {textSize={8,8}, color=C_SEDE, font=4})

    td(69, 560, 433, "\\", {letterSize={0.459,-0.9}, color=C_WHITE, font=1, bgColor=150})
    td(70, 558, 428, "\\", {letterSize={0.469,-0.9}, color=C_WHITE, font=1, bgColor=150})
    td(71, 558, 432, "-", {letterSize={0.599,-1.1}, color=C_WHITE, font=1, bgColor=150})

    td(72, 530, 417, "LD_BEAT:chit", {textSize={13,18}, color=C_WHITE, font=4})
    td(73, 532, 420, "LD_SPAC:white", {textSize={9,4}, color=C_WHITE, font=4})

    td(74, 505, 422, "V", {letterSize={0.429,1.299}, color=C_WHITE, font=1, bgColor=150})
    td(75, 504, 417, "LD_BEAT:chit", {textSize={8,12}, color=C_WHITE, font=4})
    td(76, 508, 417, "LD_BEAT:chit", {textSize={8,12}, color=C_WHITE, font=4})
    td(77, 506, 420, "LD_BEAT:chit", {textSize={8,12}, color=C_WHITE, font=4})
end

function HUD_ShowForPlayer(playerid)
    for i = 0, HUD_COUNT do
        if HudVC[i] then
            nx_TextDrawShowForPlayer(playerid, HudVC[i])
        end
    end
end

function HUD_HideForPlayer(playerid)
    for i = 0, HUD_COUNT do
        if HudVC[i] then
            nx_TextDrawHideForPlayer(playerid, HudVC[i])
        end
    end
end

NX.Hook("OnGameModeInit", function()
    HUD_Create()
end, NX.HOOK_PRIORITY.HIGH)

NX.Hook("OnPlayerSpawn", function(playerid)
    if PlayerData[playerid] and PlayerData[playerid].logado then
        HUD_ShowForPlayer(playerid)
    end
end)

NX.Hook("OnPlayerDisconnect", function(playerid, reason)
    HUD_HideForPlayer(playerid)
end, NX.HOOK_PRIORITY.LOW)

nx_print("[NX] HUD VC carregado (78 textdraws).")
