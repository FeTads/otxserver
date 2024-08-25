-- Sistema de SHOP --
SHOP_OPCODE_WINDOW = 156 -- opcode para enviar a janela (mostrar os items)
SHOP_OPCODE_DESTROYINFOS = 157 -- destruir as informacoes antigas da janela
SHOP_OPCODECATEGORY = 158 -- opcode para enviar as opcoes que tem do shop
SHOP_MONEYID = 2145 -- id da moeda

SHOP_CATEGORIES = {"Promotions", "Market", "Outfits", "Addons", "Decorations", "Clans"}
SHOP_ITEMS = { 
    ["Promotions"] = -- aqui geralmente fica outfit ou outra coisa, apesar de la embaixo ja ter outfits
    {
        [1] =
        {
            name = "Hashirama",
            price = 30,
            count = 1,
            itemId = 11150,
            image = 'images/promotions/hashirama.png',
            style = "item",
			description = "Personagem Hashirama",
        },
        [2] =
        {
            name = "Minato",
            price = 30,
            count = 1,
            itemId = 11149,
            image = 'images/promotions/minato.png',
            style = "item",
			description = "Personagem minato",
        }, 
		[3] =
        {
            name = "Madara",
            price = 30,
            count = 1,
            itemId = 11151,
            image = 'images/promotions/madara.png',
            style = "item",
			description = "Personagem madara",
        },
		[4] =
        {
            name = "Tobirama",
            price = 30,
            count = 1,
            itemId = 11205,
            image = 'images/promotions/11205.png',
            style = "item",
			description = "Personagem Tobirama",
        },
		[5] =
        {
            name = "Obito",
            price = 30,
            count = 1,
            itemId = 11133,
            image = 'images/promotions/11133.png',
            style = "item",
			description = "Personagem Obito",
        },
		[6] =
        {
            name = "Raikage",
            price = 30,
            count = 1,
            itemId = 11684,
            image = 'images/promotions/11684.png',
            style = "item",
			description = "Personagem Raikage",
        },
		[7] =
        {
            name = "Itachi",
            price = 30,
            count = 1,
            itemId = 14300,
            image = 'images/promotions/14300.png',
            style = "item",
			description = "Personagem Itachi",
        },
		[8] =
        {
            name = "Tsunade	",
            price = 30,
            count = 1,
            itemId = 14301,
            image = 'images/promotions/14301.png',
            style = "item",
			description = "Personagem Tsunade",
        },
		[9] =
        {
            name = "Guy	",
            price = 30,
            count = 1,
            itemId = 14302,
            image = 'images/promotions/14302.png',
            style = "item",
			description = "Personagem Guy",
        },
		[10] =
        {
            name = "Shisui",
            price = 30,
            count = 1,
            itemId = 11672,
            image = 'images/promotions/11672.png',
            style = "item",
			description = "Personagem Shisui",
        },
		-- [11] =
        -- {
            -- name = "Kaguya",
            -- price = 30,
            -- count = 1,
            -- itemId = 16367,
            -- image = 'images/promotions/16367.png',
            -- style = "item",
			-- description = "Personagem Kaguya",
        -- },
		-- [12] =
        -- {
            -- name = "Hiruzen",
            -- price = 30,
            -- count = 1,
            -- itemId = 12068,
            -- image = 'images/promotions/12068.png',
            -- style = "item",
			-- description = "Personagem Hiruzen",
        -- },
		-- [13] =
        -- {
            -- name = "Mifune",
            -- price = 30,
            -- count = 1,
            -- itemId = 19266,
            -- image = 'images/promotions/19266.png',
            -- style = "item",
			-- description = "Personagem Mifune",
        -- },
		-- [14] =
        -- {
            -- name = "Danzou",
            -- price = 30,
            -- count = 1,
            -- itemId = 11127,
            -- image = 'images/promotions/11127.png',
            -- style = "item",
			-- description = "Personagem Danzou",
        -- },
    },

    ["Market"] = -- aqui ficam coisas mais gerais, como troca de nick, de sexo, items, etc.
    {
        [1] =
        {
            name = "30 dias vip",
            price = 15,
            itemId = 9992,
            count = 1,
            image = 'images/market/stamina.png',
            style = "item",
			description = "você recebe 30 dias vips.",
        },
		[2] =
        {
            name = "Crystal",
            price = 5,
            itemId = 5921,
            count = 1,
            image = 'images/market/5921.png',
            style = "item",
			description = "Item utilizado em armas e escudos.",
        }, 
		[3] =
        {
            name = "Ryo",
            price = 1,
            itemId = 18149,
            count = 1,
            image = 'images/market/18149.png',
            style = "item",
			description = "1 Ryo(100 Jp Ienes).",
        },
		[4] =
        {
            name = "Divine health",
            price = 5,
            itemId = 14258,
            count = 100,
            image = 'images/market/14258.png',
            style = "item",
			description = "Potion superior ao Great Potion(somente nivel 450+ pode usar).",
        },
	[5] =
        {
            name = "Divine Chakra",
            price = 3,
            itemId = 14259,
            count = 100,
            image = 'images/market/14259.png',
            style = "item",
			description = "Potion superior ao Great Potion(somente nivel 450+ pode usar).",
        },
		[6] =
        {
            name = "Ticket",
            price = 25,
            itemId = 18487,
            count = 1,
            image = 'images/market/18487.png',
            style = "item",
			description = "Este item e ultilizado para a roleta de items localizado na area de cassino[2 giros]..",
        },
		[7] =
        {
            name = "Mystery",
            price = 20,
            itemId = 16641,
            count = 1,
            image = 'images/market/16641.png',
            style = "item",
			description = "Este item e ultilizado para a roleta de items..",
        },
		[8] =
        {
            name = "Golden key",
            price = 5,
            itemId = 17202,
            count = 1,
            image = 'images/market/17202.png',
            style = "item",
			description = "Este item e ultilizado entrar na dungeon solo..",
        },	
		[9] =
        {
            name = "Stell Key",
            price = 5,
            itemId = 17203,
            count = 1,
            image = 'images/market/17203.png',
            style = "item",
			description = "Este item e ultilizado entrar na dungeon dupla/trio..",
        },
    },
    ["Outfits"] = -- outfits
    {
        [1] =
        {
            name = "Naruto",
            price = 20,
            count = 1,
            image = 'images/outfits/naruto.png',
            outfitStorage = 8000,
            style = "outfit",
			description = "Skin para o naruto",
        },
        [2] =
        {
            name = "Sasuke",
            price = 20,
            count = 1,
            image = 'images/outfits/sasuke.png',
            outfitStorage = 8013,
            style = "outfit",
			description = "Skin para o sasuke",
        },
        [3] =
        {
            name = "itachi",
            price = 20,
            count = 1,
            image = 'images/outfits/itachi.png',
            outfitStorage = 8002,
            style = "outfit",
			description = "Skin para o itachi",
        },
        [4] =
        {
            name = "Lee",
            price = 20,
            count = 1,
            image = 'images/outfits/lee.png',
            outfitStorage = 8024,
            style = "outfit",
			description = "Skin para o rock lee",
        },
        [5] =
        {
            name = "kakashi",
            price = 20,
            count = 1,
            image = 'images/outfits/kakashi.png',
            outfitStorage = 8017,
            style = "outfit",
			description = "Skin para o kakashi",
        },
        [6] =
        {
            name = "hinata",
            price = 20,
            count = 1,
            image = 'images/outfits/hinata.png',
            outfitStorage = 8014,
            style = "outfit",
			description = "Skin para a hinata",
        },
        [7] =
        {
            name = "hinata",
            price = 20,
            count = 1,
            image = 'images/outfits/hinata2.png',
            outfitStorage = 8019,
            style = "outfit",
			description = "Skin para a hinata",
        },
        [8] =
        {
            name = "hinata",
            price = 20,
            count = 1,
            image = 'images/outfits/hinata3.png',
            outfitStorage = 8022,
            style = "outfit",
			description = "Skin para a hinata",
        },
        [9] =
        {
            name = "hinata",
            price = 20,
            count = 1,
            image = 'images/outfits/hinata4.png',
            outfitStorage = 8025,
            style = "outfit",
			description = "Skin para a hinata",
        },
        [10] =
        {
            name = "obito",
            price = 20,
            count = 1,
            image = 'images/outfits/obito.png',
            outfitStorage = 8015,
            style = "outfit",
			description = "Skin para o obito",
        }, 
		[11] =
        {
            name = "madara",
            price = 20,
            count = 1,
            image = 'images/outfits/madara.png',
            outfitStorage = 8001,
            style = "outfit",
			description = "Skin para o madara",
        },
		[12] =
        {
            name = "madara",
            price = 20,
            count = 1,
            image = 'images/outfits/madara2.png',
            outfitStorage = 8003,
            style = "outfit",
			description = "Skin para o madara",
        },		
		[13] =
        {
            name = "madara",
            price = 20,
            count = 1,
            image = 'images/outfits/madara3.png',
            outfitStorage = 8009,
            style = "outfit",
			description = "Skin para o madara",
        },
		[14] =
        {
            name = "jiraya",
            price = 20,
            count = 1,
            image = 'images/outfits/jiraya.png',
            outfitStorage = 8026,
            style = "outfit",
			description = "Skin para o jiraya",
        },
		[15] =
        {
            name = "tsunade",
            price = 20,
            count = 1,
            image = 'images/outfits/tsunade.png',
            outfitStorage = 8016,
            style = "outfit",
			description = "Skin para a tsunade",
        },
		[16] =
        {
            name = "tsunade",
            price = 20,
            count = 1,
            image = 'images/outfits/tsunade2.png',
            outfitStorage = 8021,
            style = "outfit",
			description = "Skin para a tsunade",
        },
		[17] =
        {
            name = "tsunade",
            price = 20,
            count = 1,
            image = 'images/outfits/tsunade3.png',
            outfitStorage = 8022,
            style = "outfit",
			description = "Skin para a tsunade",
        },	
		[18] =
        {
            name = "gaara",
            price = 20,
            count = 1,
            image = 'images/outfits/gaara.png',
            outfitStorage = 8007,
            style = "outfit",
			description = "Skin para o gaara",
        },
		[19] =
        {
            name = "ino",
            price = 20,
            count = 1,
            image = 'images/outfits/ino.png',
            outfitStorage = 8018,
            style = "outfit",
			description = "Skin para a ino",
        },
		[20] =
        {
            name = "hidan",
            price = 20,
            count = 1,
            image = 'images/outfits/hidan.png',
            outfitStorage = 8011,
            style = "outfit",
			description = "Skin para o hidan",
        },
		[21] =
        {
            name = "hidan",
            price = 20,
            count = 1,
            image = 'images/outfits/hidan2.png',
            outfitStorage = 8012,
            style = "outfit",
			description = "Skin para o hidan",
        },
        [22] =
        {
            name = "Guy",
            price = 20,
            count = 1,
            image = 'images/outfits/cadeirante.png',
            outfitStorage = 8005,
            style = "outfit",
			description = "Skin para o guy",
        },
        [23] =
        {
            name = "raikage",
            price = 20,
            count = 1,
            image = 'images/outfits/raikage.png',
            outfitStorage = 8010,
            style = "outfit",
			description = "Skin para o railkage",
        },
        [24] =
        {
            name = "shikamaru",
            price = 20,
            count = 1,
            image = 'images/outfits/shikamaru.png',
            outfitStorage = 8027,
            style = "outfit",
			description = "Skin para o shikamaru",
        },
        [25] =
        {
            name = "sakura",
            price = 20,
            count = 1,
            image = 'images/outfits/sakura.png',
            outfitStorage = 8008,
            style = "outfit",
			description = "Skin para o sakura",
        },
        [26] =
        {
            name = "sakura",
            price = 20,
            count = 1,
            image = 'images/outfits/sakura2.png',
            outfitStorage = 8028,
            style = "outfit",
			description = "Skin para o sakura",
        },        
		[27] =
        {
            name = "tenten",
            price = 20,
            count = 1,
            image = 'images/outfits/tenten.png',
            outfitStorage = 8029,
            style = "outfit",
			description = "Skin para o tenten",
        },
		[28] =
        {
            name = "hiruzen",
            price = 20,
            count = 1,
            image = 'images/outfits/hiruzen.png',
            outfitStorage = 8012,
            style = "outfit",
			description = "Skin para o hiruzen",
        },
    },

    ["Addons"] = -- aqui geralmente como Ã© pra server de poketibia fica addons, mas vc pode colocar algo no lugar tipo montaria algo do genero
    {
        [1] =
        {
            name = "Fogos",
            price = 30,
            count = 1,
            image = 'images/addons/fogo.png',
            outfitStorage = 7128140,
            style = "outfit",
			description = "utilize (/bar) para ver suas bars disponivel",
        },
        [2] =
        {
            name = "Escuro",
            outfitStorage = 7128141, -- id do item so para testa, ai se ja tiver feito vc reinicia o sv/client blz
            price = 30,
            count = 1,
            image = 'images/addons/escuro.png',
            style = "outfit",
			description = "utilize (/bar) para ver suas bars disponivel",
        }, 
		[3] =
        {
            name = "Rainbow",
            outfitStorage = 7128142, -- id do item so para testa, ai se ja tiver feito vc reinicia o sv/client blz
            price = 30,
            count = 1,
            image = 'images/addons/rainbow.png',
            style = "outfit",
			description = "utilize (/bar) para ver suas bars disponivel",
        },
		[4] =
        {
            name = "Ghost",
            outfitStorage = 7128143, -- id do item so para testa, ai se ja tiver feito vc reinicia o sv/client blz
            price = 30,
            count = 1,
            image = 'images/addons/ghost.png',
            style = "outfit",
			description = "utilize (/bar) para ver suas bars disponivel",
        },
		[5] =
        {
            name = "Bow",
            outfitStorage = 7128144, -- id do item so para testa, ai se ja tiver feito vc reinicia o sv/client blz
            price = 30,
            count = 1,
            image = 'images/addons/bow.png',
            style = "outfit",
			description = "utilize (/bar) para ver suas bars disponivel",
        }, 
		[6] =
        {
            name = "Hokage",
            price = 20,
            count = 1,
            image = 'images/addons/Effect1.png',
            outfitStorage = 7128145,
            style = "outfit",
			description = "utilize (/bar) para ver suas bars disponivel",
        },
        [7] =
        {
            name = "Raikage",
            outfitStorage = 7128146, -- id do item so para testa, ai se ja tiver feito vc reinicia o sv/client blz
            price = 20,
            count = 1,
            image = 'images/addons/Effect2.png',
            style = "outfit",
			description = "utilize (/bar) para ver suas bars disponivel",
        }, 
		[8] =
        {
            name = "Mizukage",
            outfitStorage = 7128147, -- id do item so para testa, ai se ja tiver feito vc reinicia o sv/client blz
            price = 20,
            count = 1,
            image = 'images/addons/Effect3.png',
            style = "outfit",
			description = "utilize (/bar) para ver suas bars disponivel",
        },
		[9] =
        {
            name = "Kazekage",
            outfitStorage = 7128148, -- id do item so para testa, ai se ja tiver feito vc reinicia o sv/client blz
            price = 20,
            count = 1,
            image = 'images/addons/Effect4.png',
            style = "outfit",
			description = "utilize (/bar) para ver suas bars disponivel",
        },
		[10] =
        {
            name = "Tsukage",
            outfitStorage = 7128149, -- id do item so para testa, ai se ja tiver feito vc reinicia o sv/client blz
            price = 20,
            count = 1,
            image = 'images/addons/Effect5.png',
            style = "outfit",
			description = "utilize (/bar) para ver suas bars disponivel",
        },
     },
 ["Decorations"] =
    {
        [1] =
        {
            name = "Shukaku",
            itemId = 11171,
            price = 20,
            count = 1,
            image = 'images/market/11171.png',
            style = "item",
			description = "Ultilizando este item voce ira se tornar um jinchuuriki do 1 cauda por 20 dias.",
        },
        [2] =
        {
            name = "Kokuou",
            itemId = 11176,
            price = 20,
            count = 1,
            image = 'images/market/11176.png',
            style = "item",
			description = "Ultilizando este item voce ira se tornar um jinchuuriki do 1 cauda por 20 dias.",
        },
        [3] =
        {
            name = "Goku",
            itemId = 11175,
            price = 20,
            count = 1,
            image = 'images/market/11175.png',
            style = "item",
			description = "Ultilizando este item voce ira se tornar um jinchuuriki do 1 cauda por 20 dias.",
        }, 
		[4] =
        {
            name = "Saiken",
            itemId = 11174,
            price = 20,
            count = 1,
            image = 'images/market/11174.png',
            style = "item",
			description = "Ultilizando este item voce ira se tornar um jinchuuriki do 1 cauda por 20 dias.",
        },
		[5] =
        {
            name = "Isobu",
            itemId = 11173,
            price = 20,
            count = 1,
            image = 'images/market/11173.png',
            style = "item",
			description = "Ultilizando este item voce ira se tornar um jinchuuriki do 1 cauda por 20 dias.",
        },
		[6] =
        {
            name = "Matatabi",
            itemId = 11172,
            price = 20,
            count = 1,
            image = 'images/market/11172.png',
            style = "item",
			description = "Ultilizando este item voce ira se tornar um jinchuuriki do 1 cauda por 20 dias.",
        },
		[7] =
        {
            name = "Choumei",
            itemId = 11177,
            price = 20,
            count = 1,
            image = 'images/market/11177.png',
            style = "item",
			description = "Ultilizando este item voce ira se tornar um jinchuuriki do 1 cauda por 20 dias.",
        },	
		[8] =
        {
            name = "Kyuubi",
            itemId = 11179,
            price = 20,
            count = 1,
            image = 'images/market/11179.png',
            style = "item",
			description = "Ultilizando este item voce ira se tornar um jinchuuriki do 1 cauda por 20 dias.",
        },
		-- [9] =
        -- {
            -- name = "Juubi",
            -- itemId = 11180,
            -- price = 20,
            -- count = 1,
            -- image = 'images/market/11180.png',
            -- style = "item",
			-- description = "Ultilizando este item voce ira se tornar um jinchuuriki do 1 cauda por 20 dias.",
        -- },
    },

    ["Clans"] =
    {
        [1] =
        {
            name = "Myoboku",
            itemId = 18558,
            price = 25,
            count = 1,
            image = 'images/market/18558.png',
            style = "item",
			description = "+5 de Ninjutus.",
        },
        [2] =
        {
            name = "Tsukage",
            itemId = 17457,
            price = 25,
            count = 1,
            image = 'images/market/17457.png',
            style = "item",
			description = "+5 de Ninjutus.",
        },
        [3] =
        {
            name = "Tobirama",
            itemId = 18559,
            price = 25,
            count = 1,
            image = 'images/market/18559.png',
            style = "item",
			description = "+5 de Ninjutus.",
        },
		[4] =
        {
            name = "Kazekage",
            itemId = 11045,
            price = 25,
            count = 1,
            image = 'images/market/11045.png',
            style = "item",
			description = "+5 de Ninjutus.",
        },

		[5] =
        {
            name = "Kurama",
            itemId = 17454,
            price = 25,
            count = 1,
            image = 'images/market/17454.png',
            style = "item",
			description = "+5 de Ninjutus.",
        },
    },
}

function sendShopWindow(cid, category)
    if not isPlayer(cid) then
        return true
    end

    local tabela = SHOP_ITEMS[category]
    if not tabela then print("Categoria: " .. category .. " nao existe.") return true end

    doSendPlayerExtendedOpcode(cid, SHOP_OPCODE_DESTROYINFOS, "destroyProducts".."@")
    doSendPlayerExtendedOpcode(cid, SHOP_OPCODE_DESTROYINFOS, "destroyCategories".."@")

    for i = 1, #SHOP_CATEGORIES do
        doSendPlayerExtendedOpcode(cid, SHOP_OPCODECATEGORY, SHOP_CATEGORIES[i].."@")
    end

    for i = 1, #tabela do
        doSendPlayerExtendedOpcode(cid, SHOP_OPCODE_WINDOW, tabela[i].name.."@"..tabela[i].image.."@"..tabela[i].price.."@"..tabela[i].count.."@"..i.."@"..category.."@"..getZnotePoints(cid, SHOP_MONEYID).."@"..tabela[i].description.."@")
    end
    return true
end

function sendBuyProduct(cid, category, index)
    if not isPlayer(cid) then
        return true
    end

    local tabela = SHOP_ITEMS[category]
    if not tabela then print("Categoria: " .. category .. " nao existe.") return true end

    tabela = tabela[index]
    if not tabela then print("Index: " .. index .. " nao encontrado.") return true end

    if getZnotePoints(cid, SHOP_MONEYID, -1) < tabela.price then
        doPlayerPopupFYI(cid, "Você não possui dinheiro suficiente para essa transação.")
        return true
    end

    if tabela.style == "item" and isInArray({9992}, tabela.itemId) then
        local tabelaVip = {
            [9992] = {vipDays = 30},
        }

        removeZnotePoints(cid, tabela.price)
        sendShopWindow(cid, category)

        doPlayerAddPremiumDays(cid, tabelaVip[tabela.itemId].vipDays)
		doPlayerSendTextMessage(cid, 25, "ADICIONADO 30 DIAS VIP NA SUA CONTA! OBRIGADO :)")
        return true
    end
	
    if tabela.style == "item" then
        doPlayerSendTextMessage(cid, 25, "Sucesso!")
		doPlayerAddItem(cid, tabela.itemId, tabela.count)
    elseif tabela.style == "outfit" then
        doPlayerSendTextMessage(cid, 25, "Você desbloqueou uma outfit.")
        setPlayerStorageValue(cid, tabela.outfitStorage, 1)
    elseif tabela.style == "service" then
        if tabela.name == "Troca de Sexo" then
            doPlayerSendTextMessage(cid, 25, "Você trocou de sexo.")
            if getPlayerSex(cid) == 1 then
                doPlayerSetSex(cid, 0)
            else
                doPlayerSetSex(cid, 1)
            end
        end

        if tabela.name == "Troca de Nome" then
            doPlayerSendTextMessage(cid, 25, "Sucesso! Digite: !changename NOME DESEJADO para trocar o nome.")
            setPlayerStorageValue(cid, 9492, 1) -- ganhar storage que pode trocar de nome
        end
    elseif tabela.style == "pokemon" then
        local item = doPlayerAddItem(cid, 11826, 1)
        doItemSetAttribute(item, "poke", tabela.name)
        doItemSetAttribute(item, "boost", tabela.boost)
        doItemSetAttribute(item, "level", tabela.level)
    end

    removeZnotePoints(cid, tabela.price)
    sendShopWindow(cid, category)
    return true
end