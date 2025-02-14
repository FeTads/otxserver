function postostring(pos)
  return pos.x .. " " .. pos.y .. " " .. pos.z
end

function dirtostring(dir)
  for k,v in pairs(Directions) do
    if v == dir then
      return k
    end
  end
end

function getNewHighlightedText(text, color, highlightColor)
	local tmpData = {}
  
	local t = string.gsub(text, "(.-){([^}]+)}", function(a, b)
	  local s = b:find("#")
	  local hexColor = highlightColor
	  if s then
		hexColor = b:sub(s, s+8)
		b = b:sub(1, s - 1)
	  end
  
	  table.insert(tmpData, a)
	  table.insert(tmpData, color)
  
	  table.insert(tmpData, b)
	  table.insert(tmpData, hexColor)
	  return ""
	end)
  
	table.insert(tmpData, t)
	table.insert(tmpData, color)
  
	return tmpData
end


function getVocationNameById(vocation)
  if (vocation >= 10 and vocation <= 15) then
    return "blaze"
  elseif (vocation >= 20 and vocation <= 25) then
    return "hurricane"
  elseif (vocation >= 30 and vocation <= 35) then
    return "voltagic"
  elseif (vocation >= 40 and vocation <= 45) then
    return "spectrum"
  elseif (vocation >= 50 and vocation <= 55) then
    return "vital"
  elseif (vocation >= 60 and vocation <= 65) then
    return "gaia"
  elseif (vocation >= 70 and vocation <= 75) then
    return "avalanche"
  elseif (vocation >= 80 and vocation <= 85) then
    return "heremit"
  elseif (vocation >= 90 and vocation <= 95) then
    return "zen"
  end

  return "trainer"
end

function getRankLightColor(colorID)
  if (colorID == 1) then
    return "#efc796"
  elseif (colorID == 2) then
    return "#9facaf"
  elseif (colorID == 3) then
    return "#f3ce38"
  elseif (colorID == 4) then
    return "#8deeff"
  end

  return "#ffffff"
end

function getPlayersCountDG(quantID)
	if (quantID == 1) then
		return "Jogador"
	elseif (quantID >= 2) then
		return "Jogadores"
	end
  return ""
end