-- Quiz By matheus
quiz = {}

quiz.questions = {
    [1] = {question = "Qual � o nome do planeta natal de Goku?", answer = "Planeta Vegeta"},
    [2] = {question = "Quem foi o mestre de artes marciais de Goku?", answer = "Mestre Kame"},
    [3] = {question = "Qual � o nome verdadeiro de Piccolo?", answer = "Piccolo Daimaoh"},
    [4] = {question = "Quantas Esferas do Drag�o existem?", answer = "7"},
    [5] = {question = "Qual � a transforma��o mais poderosa de Goku?", answer = "Ultra Instinct"},
    [6] = {question = "Quem criou os Androides 17 e 18?", answer = "Dr. Gero"},
    [7] = {question = "Qual � o nome do filho mais velho de Goku?", answer = "Gohan"},
    [8] = {question = "Qual � o nome da t�cnica de fus�o usada por Goku e Vegeta?", answer = "Fus�o Metamoru"},
    [9] = {question = "Quem derrotou Cell?", answer = "Gohan"},
    [10] = {question = "Qual � o nome da nave que Goku usa para viajar para Namekusei?", answer = "Nave da C�psula Corp"},
    [11] = {question = "Quem � o irm�o de Vegeta?", answer = "Tarble"},
    [12] = {question = "Qual � o nome do andr�ide que se torna amigo de Goku?", answer = "Andr�ide 8"},
    [13] = {question = "Qual � o nome do Deus da Destrui��o do Universo 7?", answer = "Beerus"},
    [14] = {question = "Quem treina Goku e Vegeta no planeta de Whis?", answer = "Whis"},
    [15] = {question = "Qual � a transforma��o de Trunks do Futuro quando luta contra Zamasu?", answer = "Super Saiyajin Rage"},
    [16] = {question = "Quem foi o primeiro vil�o de Dragon Ball Z?", answer = "Raditz"},
    [17] = {question = "Qual � a t�cnica de teletransporte usada por Goku?", answer = "Teletransporte Instant�neo"},
    [18] = {question = "Qual � o nome do torneio onde Goku enfrenta Jiren?", answer = "Torneio do Poder"},
    [19] = {question = "Quem revive Freeza antes do Torneio do Poder?", answer = "Goku"},
    [20] = {question = "Qual � o nome da esposa de Vegeta?", answer = "Bulma"},
    [21] = {question = "Qual � o nome do andr�ide que se torna amigo de Kuririn?", answer = "Andr�ide 18"},
    [22] = {question = "Quem � o Kaioshin do Leste?", answer = "Shin"},
    [23] = {question = "Qual � o nome da t�cnica de absor��o de energia usada por Cell?", answer = "Absor��o de Energia"},
    [24] = {question = "Quem ajuda Goku a treinar na Sala do Tempo?", answer = "Gohan"},
    [25] = {question = "Qual � o nome do planeta onde Goku treina com o Sr. Kaioh?", answer = "Planeta do Sr. Kaioh"},
    [26] = {question = "Quem � o l�der da For�a Ginyu?", answer = "Capit�o Ginyu"},
    [27] = {question = "Qual � o nome da t�cnica usada por Vegeta para destruir o planeta?", answer = "Final Flash"},
    [28] = {question = "Quem � o guardi�o da Terra em Dragon Ball Z?", answer = "Kami-Sama"},
    [29] = {question = "Quem destr�i o Planeta Vegeta?", answer = "Freeza"},
    [30] = {question = "Qual � o nome do filho mais novo de Goku?", answer = "Goten"},
    [31] = {question = "Quem ressuscita Goku ap�s sua morte na Saga dos Saiyajins?", answer = "Porunga"},
    [32] = {question = "Qual � o nome do lend�rio Super Saiyajin?", answer = "Broly"},
    [33] = {question = "Quem � o rival de Vegeta?", answer = "Goku"},
    [34] = {question = "Qual � o nome do mestre de Kuririn?", answer = "Mestre Kame"},
    [35] = {question = "Qual � o nome do planeta dos Namekuseijins?", answer = "Namekusei"},
    [36] = {question = "Quem � o anjo do Universo 7?", answer = "Whis"},
    [37] = {question = "Quem foi o primeiro a se transformar em Super Saiyajin?", answer = "Bardock"},
    [38] = {question = "Qual � a t�cnica de fus�o usada por Goten e Trunks?", answer = "Fus�o Metamoru"},
    [39] = {question = "Quem � o mestre do Sr. Kaioh?", answer = "Grande Kaioh"},
    [40] = {question = "Qual � o nome do vil�o principal da Saga Majin Buu?", answer = "Majin Buu"},
    [41] = {question = "Quem s�o os filhos de Vegeta?", answer = "Trunks e Bra"},
    [42] = {question = "Qual � a transforma��o de Goku na Saga Majin Buu?", answer = "Super Saiyajin 3"},
    [43] = {question = "Quem � o Deus da Destrui��o do Universo 6?", answer = "Champa"},
    [44] = {question = "Quem treina Gohan antes do Torneio do Poder?", answer = "Piccolo"},
    [45] = {question = "Qual � o nome da t�cnica de assinatura de Goku?", answer = "Kamehameha"},
    [46] = {question = "Quem � o fundador da Red Ribbon Army?", answer = "Comandante Red"},
    [47] = {question = "Quem derrotou Freeza na Saga de Namekusei?", answer = "Goku"},
    [48] = {question = "Quem � o dublador original de Goku no Jap�o?", answer = "Masako Nozawa"},
    [49] = {question = "Quem criou a Dragon Ball?", answer = "Akira Toriyama"},
    [50] = {question = "Qual � o nome do �ltimo vil�o enfrentado por Goku em Dragon Ball GT?", answer = "Omega Shenron"}
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
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Voc� deve esperar " .. waitTime .. " segundos antes de responder novamente.")
        return
    end


    quiz.exhaustion[cid] = now + exhaustTime

    local questionId = getGlobalStorageValue(19000)
    if questionId == -1 then
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "N�o h� nenhuma pergunta ativa no momento. Aguarde a pr�xima rodada.")
        return
    end

    local correctAnswer = quiz.questions[questionId].answer
    if answer:lower() == correctAnswer:lower() then
        local reward = quiz.rewards[math.random(1, #quiz.rewards)]
        doPlayerAddItem(cid, reward.itemid, reward.count)
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parab�ns! Voc� acertou e ganhou sua recompensa.")
        broadcastMessage(getCreatureName(cid) .. " respondeu corretamente � pergunta do quiz!", MESSAGE_EVENT_ADVANCE)
        
        quiz.questionAnswered = true -- Marcar a pergunta como respondida
        setGlobalStorageValue(19000, -1) -- Resetar a pergunta ativa
    else
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Resposta errada! Tente novamente na pr�xima pergunta.")
    end
end


function quiz.broadcastQuestion()
    quiz.questionAnswered = false 
    local questionId = math.random(1, #quiz.questions)
    local question = quiz.questions[questionId].question

    broadcastMessage("[QUIZ] " .. question .. " | Use o comando !responder <sua resposta> para participar!", MESSAGE_EVENT_ADVANCE)
    
    setGlobalStorageValue(19000, questionId) -- Armazena o ID da pergunta atual
end
