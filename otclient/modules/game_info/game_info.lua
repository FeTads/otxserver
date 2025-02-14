--Lista de offsets para cada Outfit.


if not modules.gamelib.luizprotecaohealthbars then
    g_logger.fatal("Sistema de protecao\n\n           @Luiz")
end

local OutfitOffsets = {
    [1813] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [2677] = {
        [North] = { x = 3, y = -40 },
        [East] = { x = 3, y = -40 },
        [South] = { x = 3, y = -40 },
        [West] = { x = 3, y = -40 },
    },
    [2110] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [497] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [184] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [1441] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [1655] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [150] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [2231] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [2157] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [2187] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [884] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [2199] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [2232] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [1023] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [141] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [1590] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [366] = {
        [North] = { x = 2, y = -25 },
        [East] = { x = 2, y = -25 },
        [South] = { x = 2, y = -25 },
        [West] = { x = 2, y = -25 },
    },
    [399] = {
        [North] = { x = -60, y = -55 },
        [East] = { x = -60, y = -55 },
        [South] = { x = -60, y = -55 },
        [West] = { x = -60, y = -55 },
    }
}


local function translateDir(dir)
    if dir == NorthEast or dir == SouthEast then
        return East
    elseif dir == NorthWest or dir == SouthWest then
        return West
    end
    return dir
end

local function getOutfitInformationOffset(outfit, dir)
    if OutfitOffsets[outfit] then
        return OutfitOffsets[outfit][translateDir(dir)]
    end
    return { x = -2, y = -10 } -- x = esquerda ou direita | y = Up/Down
end

local function onCreatureAppear(creature)
    local Offset = getOutfitInformationOffset(creature:getOutfit().type, creature:getDirection())
    creature:setInformationOffset(Offset.x, Offset.y)
end

local function onCreatureDirectionChange(creature, oldDirection, newDirection)
    local Offset = getOutfitInformationOffset(creature:getOutfit().type, newDirection)
    creature:setInformationOffset(Offset.x, Offset.y)
end

local function onCreatureOutfitChange(creature, newOutfit, oldOutfit)
    local Offset = getOutfitInformationOffset(newOutfit.type, creature:getDirection())
    creature:setInformationOffset(Offset.x, Offset.y)
end

function init()
    connect(LocalPlayer, { onOutfitChange = onCreatureOutfitChange })
    connect(Creature, {
        onAppear = onCreatureAppear,
        onDirectionChange = onCreatureDirectionChange,
        onOutfitChange = onCreatureOutfitChange
    })
end

function terminate()
    disconnect(LocalPlayer, { onOutfitChange = onCreatureOutfitChange })
    disconnect(Creature, {
        onAppear = onCreatureAppear,
        onDirectionChange = onCreatureDirectionChange,
        onOutfitChange = onCreatureOutfitChange
    })
end
