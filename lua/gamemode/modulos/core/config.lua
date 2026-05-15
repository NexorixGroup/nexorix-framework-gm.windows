SERVER_CONFIG = {
    Name = "Nexorix",
    Version = "1.0",
    MaxPlayers = 100,
    SpawnPos = {x = 1481.1, y = -1750.1, z = 15.5, a = 0.0},

    Orgs = {
        [1] = {nome = "Franca", tipo = "org", cor = "{4488FF}", hex = 0x4488FFFF, skin = 285, membros_max = 15},
        [2] = {nome = "Turquia", tipo = "org", cor = "{FF4444}", hex = 0xFF4444FF, skin = 287, membros_max = 15},
        [3] = {nome = "Policia de Nexorix", tipo = "pm", cor = "{0000FF}", hex = 0x0000FFFF, skin = 280, membros_max = 20},
        [4] = {nome = "COT", tipo = "pm", cor = "{006400}", hex = 0x006400FF, skin = 285, membros_max = 15},
    },

    Bot = {
        canais = {
            logs = "",
            system = "",
            servidor = "",
        },
        sistemas = {
            servidor_onoff = true,
            entrada_saida = true,
            logs_chat = true,
        }
    }
}
