function init()
	g_shaders.createOutfitShader("Epico", "/shaders/map_default_vertex", "/shaders/epico")
	g_shaders.createOutfitShader("Lendario", "/shaders/map_default_vertex", "/shaders/lendario")
	g_shaders.createOutfitShader("Mitico", "/shaders/map_default_vertex", "/shaders/mitico")
	g_shaders.createOutfitShader("Especial", "/shaders/map_default_vertex", "/shaders/especial")
	g_shaders.createOutfitShader("Upgrade", "/shaders/map_default_vertex", "/shaders/upgrade")
	g_shaders.createOutfitShader("auraget", "/shaders/aura_get", "/shaders/aura_get_fragment")

	-- outs
	g_shaders.createOutfitShader("ShaderOutBlue", "/shaders/padrao", "/shaders/ShaderOutBlue")
	g_shaders.createOutfitShader("ShaderOutRed", "/shaders/padrao", "/shaders/ShaderOutRed")
	g_shaders.createOutfitShader("ShaderOutPurple", "/shaders/padrao", "/shaders/ShaderOutPurple")
	g_shaders.createOutfitShader("ShaderOutBlack", "/shaders/padrao", "/shaders/ShaderOutBlack")
	g_shaders.createOutfitShader("ShaderOutMultiColors", "/shaders/padrao", "/shaders/ShaderOutMultiColors")
	-------

	-- charge
	g_shaders.createOutfitShader("ShaderChargeBlue", "/shaders/padrao", "/shaders/ShaderChargeBlue")
	g_shaders.createOutfitShader("ShaderChargeLightPink", "/shaders/padrao", "/shaders/ShaderChargeLightPink")
	g_shaders.createOutfitShader("ShaderChargeGreen", "/shaders/padrao", "/shaders/ShaderChargeGreen")
	g_shaders.createOutfitShader("ShaderChargeYellow", "/shaders/padrao", "/shaders/ShaderChargeYellow")
	g_shaders.createOutfitShader("ShaderChargeMultiColors", "/shaders/padrao", "/shaders/ShaderChargeMultiColors")

	-- estatic
	g_shaders.createOutfitShader("ShaderEstaticYellow", "/shaders/padrao", "/shaders/ShaderEstaticYellow")
	-------

	g_shaders.createShader("map_default", "/shaders/map_default_vertex", "/shaders/map_default_fragment") 
end

function terminate()
end