dofile('data/lib/quiz.lua')

function onSay(cid, words, param)
    if param ~= "" then
        quiz.checkAnswer(cid, param)
        return true
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Uso: !responder <sua resposta>")
        return true
    end
end
