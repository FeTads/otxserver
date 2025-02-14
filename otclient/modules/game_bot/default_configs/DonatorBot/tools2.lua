-- tools tab
setDefaultTab("Hotkeys")

-- allows to test/edit bot lua scripts ingame, you can have multiple scripts like this, just change storage.ingame_lua
UI.Button("Hotkeys 2", function(newText)
  UI.MultilineEditorWindow(storage.ingame_hotkeys2 or "", {title="Hotkeys editor 2", description="Adicione suas scripts aqui!\nBy: @Donator"}, function(text)
    storage.ingame_hotkeys2 = text
    reload()
  end)
end)

UI.Separator()

for _, scripts in pairs({storage.ingame_hotkeys2}) do
  if type(scripts) == "string" and scripts:len() > 3 then
    local status, result = pcall(function()
      assert(load(scripts, "ingame_editor"))()
    end)
    if not status then 
      error("Ingame edior error:\n" .. result)
    end
  end
end  






 

UI.Separator() 
