dofile('data/lib/quiz.lua')

function onThink(interval)
    quiz.broadcastQuestion()
    return true
end
