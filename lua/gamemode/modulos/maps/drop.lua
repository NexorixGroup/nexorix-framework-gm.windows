local REMOVE_BUILDINGS = {
    {13759, 1413.414, -804.742, 83.437, 0.250},
    {13722, 1413.414, -804.742, 83.437, 0.250},
    {13831, 1413.414, -804.742, 83.437, 0.250},
}

local OBJECTS = {
    {13759, 1405.040, -812.929, 75.930, 90.000, 0.000, 1.139, 0, "{800080}N", 130, "Ariel", 100},
    {13759, 1415.026, -812.730, 75.930, 90.000, 0.000, 1.139, 0, "{800080}E", 130, "Ariel", 100},
    {13759, 1427.236, -812.487, 75.930, 90.000, 0.000, 1.139, 0, "{800080}XO", 130, "Ariel", 100},
    {13759, 1450.932, -812.015, 75.930, 90.000, 0.000, 1.139, 0, "{800080}RI", 130, "Ariel", 100},
    {13759, 1473.079, -811.604, 75.710, 90.000, 0.000, 1.139, 0, "{800080}X", 130, "Ariel", 100},
    {13722, 1437.550, -813.001, 76.270, 0.000, 0.000, 1.062, -1, nil, nil, nil, nil},
}

NX.Hook("OnPlayerConnect", function(playerid)
    for _, b in ipairs(REMOVE_BUILDINGS) do
        nx_RemoveBuildingForPlayer(playerid, b[1], b[2], b[3], b[4], b[5])
    end
end, NX.HOOK_PRIORITY.HIGH)

NX.Hook("OnGameModeInit", function()
    for _, obj in ipairs(OBJECTS) do
        local o = nx_CreateDynamicObject(obj[1], obj[2], obj[3], obj[4], obj[5], obj[6], obj[7], -1, -1, -1, 300.0, 300.0)
        if obj[8] ~= -1 and obj[9] then
            nx_SetDynamicObjectMaterialText(o, obj[8], obj[9], obj[10], obj[11], obj[12], true, 0x00000000, 0x00000000, 1)
        end
    end
end, NX.HOOK_PRIORITY.LOW)

nx_print("[NX] Mapa Drop carregado.")
