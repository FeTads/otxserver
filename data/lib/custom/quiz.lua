-- Quiz By matheus
quiz = {}

quiz.questions = {
    [1] = {question = "Qual é o nome do planeta natal de Goku?", answer = "Planeta Vegeta"},
    [2] = {question = "Quem foi o mestre de artes marciais de Goku?", answer = "Mestre Kame"},
    [3] = {question = "Qual é o nome verdadeiro de Piccolo?", answer = "Piccolo Daimaoh"},
    [4] = {question = "Quantas Esferas do Dragão existem?", answer = "7"},
    [5] = {question = "Qual é a transformação mais poderosa de Goku?", answer = "Ultra Instinct"},
    [6] = {question = "Quem criou os Androides 17 e 18?", answer = "Dr. Gero"},
    [7] = {question = "Qual é o nome do filho mais velho de Goku?", answer = "Gohan"},
    [8] = {question = "Qual é o nome da técnica de fusão usada por Goku e Vegeta?", answer = "Fusão Metamoru"},
    [9] = {question = "Quem derrotou Cell?", answer = "Gohan"},
    [10] = {question = "Qual é o nome da nave que Goku usa para viajar para Namekusei?", answer = "Nave da Cápsula Corp"},
    [11] = {question = "Quem é o irmão de Vegeta?", answer = "Tarble"},
    [12] = {question = "Qual é o nome do andróide que se torna amigo de Goku?", answer = "Andróide 8"},
    [13] = {question = "Qual é o nome do Deus da Destruição do Universo 7?", answer = "Beerus"},
    [14] = {question = "Quem treina Goku e Vegeta no planeta de Whis?", answer = "Whis"},
    [15] = {question = "Qual é a transformação de Trunks do Futuro quando luta contra Zamasu?", answer = "Super Saiyajin Rage"},
    [16] = {question = "Quem foi o primeiro vilão de Dragon Ball Z?", answer = "Raditz"},
    [17] = {question = "Qual é a técnica de teletransporte usada por Goku?", answer = "Teletransporte Instantâneo"},
    [18] = {question = "Qual é o nome do torneio onde Goku enfrenta Jiren?", answer = "Torneio do Poder"},
    [19] = {question = "Quem revive Freeza antes do Torneio do Poder?", answer = "Goku"},
    [20] = {question = "Qual é o nome da esposa de Vegeta?", answer = "Bulma"},
    [21] = {question = "Qual é o nome do andróide que se torna amigo de Kuririn?", answer = "Andróide 18"},
    [22] = {question = "Quem é o Kaioshin do Leste?", answer = "Shin"},
    [23] = {question = "Qual é o nome da técnica de absorção de energia usada por Cell?", answer = "Absorção de Energia"},
    [24] = {question = "Quem ajuda Goku a treinar na Sala do Tempo?", answer = "Gohan"},
    [25] = {question = "Qual é o nome do planeta onde Goku treina com o Sr. Kaioh?", answer = "Planeta do Sr. Kaioh"},
    [26] = {question = "Quem é o líder da Força Ginyu?", answer = "Capitão Ginyu"},
    [27] = {question = "Qual é o nome da técnica usada por Vegeta para destruir o planeta?", answer = "Final Flash"},
    [28] = {question = "Quem é o guardião da Terra em Dragon Ball Z?", answer = "Kami-Sama"},
    [29] = {question = "Quem destrói o Planeta Vegeta?", answer = "Freeza"},
    [30] = {question = "Qual é o nome do filho mais novo de Goku?", answer = "Goten"},
    [31] = {question = "Quem ressuscita Goku após sua morte na Saga dos Saiyajins?", answer = "Porunga"},
    [32] = {question = "Qual é o nome do lendário Super Saiyajin?", answer = "Broly"},
    [33] = {question = "Quem é o rival de Vegeta?", answer = "Goku"},
    [34] = {question = "Qual é o nome do mestre de Kuririn?", answer = "Mestre Kame"},
    [35] = {question = "Qual é o nome do planeta dos Namekuseijins?", answer = "Namekusei"},
    [36] = {question = "Quem é o anjo do Universo 7?", answer = "Whis"},
    [37] = {question = "Quem foi o primeiro a se transformar em Super Saiyajin?", answer = "Bardock"},
    [38] = {question = "Qual é a técnica de fusão usada por Goten e Trunks?", answer = "Fusão Metamoru"},
    [39] = {question = "Quem é o mestre do Sr. Kaioh?", answer = "Grande Kaioh"},
    [40] = {question = "Qual é o nome do vilão principal da Saga Majin Buu?", answer = "Majin Buu"},
    [41] = {question = "Quem são os filhos de Vegeta?", answer = "Trunks e Bra"},
    [42] = {question = "Qual é a transformação de Goku na Saga Majin Buu?", answer = "Super Saiyajin 3"},
    [43] = {question = "Quem é o Deus da Destruição do Universo 6?", answer = "Champa"},
    [44] = {question = "Quem treina Gohan antes do Torneio do Poder?", answer = "Piccolo"},
    [45] = {question = "Qual é o nome da técnica de assinatura de Goku?", answer = "Kamehameha"},
    [46] = {question = "Quem é o fundador da Red Ribbon Army?", answer = "Comandante Red"},
    [47] = {question = "Quem derrotou Freeza na Saga de Namekusei?", answer = "Goku"},
    [48] = {question = "Quem é o dublador original de Goku no Japão?", answer = "Masako Nozawa"},
    [49] = {question = "Quem criou a Dragon Ball?", answer = "Akira Toriyama"},
    [50] = {question = "Qual é o nome do último vilão enfrentado por Goku em Dragon Ball GT?", answer = "Omega Shenron"}
}

quiz.rewards = {
    [1] = {itemid = 2160, count = 10}, -- Exemplo de recompensa: 10 Crystal Coins
    [2] = {itemid = 2152, count = 100} -- Exemplo de recompensa: 100 Platinum Coins
}

quiz.exhaustion = {}

quiz.questionAnswered = false 

function quiz.checkAnswer(cid, answer)
    local now = os.time()
    local exhaustTime = 5 -- Tempo de cooldown

    if quiz.exhaustion[cid] and quiz.exhaustion[cid] > now then
        local waitTime = quiz.exhaustion[cid] - now
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você deve esperar " .. waitTime .. " segundos antes de responder novamente.")
        return
    end


    quiz.exhaustion[cid] = now + exhaustTime

    local questionId = getGlobalStorageValue(19000)
    if questionId == -1 then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Não há nenhuma pergunta ativa no momento. Aguarde a próxima rodada.")
        return
    end

    local correctAnswer = quiz.questions[questionId].answer
    if answer:lower() == correctAnswer:lower() then
        local reward = quiz.rewards[math.random(1, #quiz.rewards)]
        doPlayerAddItem(cid, reward.itemid, reward.count)
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns! Você acertou e ganhou sua recompensa.")
        broadcastMessage(getCreatureName(cid) .. " respondeu corretamente à pergunta do quiz!", MESSAGE_EVENT_ADVANCE)
        
        quiz.questionAnswered = true -- Marcar a pergunta como respondida
        setGlobalStorageValue(19000, -1) -- Resetar a pergunta ativa
    else
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Resposta errada! Tente novamente na próxima pergunta.")
    end
end


function quiz.broadcastQuestion()
    quiz.questionAnswered = false 
    local questionId = math.random(1, #quiz.questions)
    local question = quiz.questions[questionId].question

    broadcastMessage("[QUIZ] " .. question .. " | Use o comando !responder <sua resposta> para participar!", MESSAGE_EVENT_ADVANCE)
    
    setGlobalStorageValue(19000, questionId) -- Armazena o ID da pergunta atual
end
