	ownerName = ""
	ownerEmail = ""
	url = ""
	site = ""
	host = ""
	location = "Brasil"
	advertisingBlock = "ba1ak;íp;ìp;142.;ip:;b4iak;b4i4k;abertura;142.;h0st;crle;c0nta;br;BR;ot.com;,com;20.;21.;SV;.DDNS;IP;INAUGUR;.COM;.ONLINE;-ONLINE;-WAR;BAIAK;192.;191.;sv;balan;sv-;sv.;.ga;macaco;preto;inaugur;b@i@k;.net;servegame;no-ip,.net;-war;,online;-net;.com.br;.ddns;.org;.pl;.online;.biz;.info;baiak;.tk;mapa;iiak;web;www;ip;35.;34."

	motd = "Bem vindo ao OTXSERVER!"
	serverName = "OTXSERVER"
	loginMessage = "Bem vindo ao OTXSERVER!"
	displayGamemastersWithOnlineCommand = false
	
	-- mw replace system !mw old/new
	useMwReplaceSystem = true
	mwSpriteId = 10181
	newSpriteIdMW = 3642
	-- use max connection in same IP
	UseMaxIpConnect = true
	MaxIpConnections = 10
	-- use autoloot system
	Autoloot_enabled = true
	AutoLoot_BlockIDs = "" 
	AutoLoot_MoneyIDs = "2148;2152;2160;9971" 
	AutoLoot_MaxItem = 5
	AutoLoot_MaxItemPremium = 10
	AutoLoot_MaxItemFree = 5
	-- add if enable cast without password 
	expInCast = true
	expPercentIncast = 5
	-- use life/mana in percentual 100/100
	lifeAndManaInPercentual = false
	-- add frag if player kill mc / same ip
	addFragToSameIp = false
	-- use reset system
	resetSystemEnable = true
	-- use max absorbAll (prevents absorb +100% / SSA + might ring)
	useMaxAbsorbAll = true
	maxAbsorbPercent = 80.0
	-- delete player with monster/forbidden name?
	deletePlayersWithMonsterName = true
	forbiddenNames = "gm;adm;cm;support;god;tutor;god ; god; adm;adm ; gm;gm ; cm;cm ;"
	-- display messages death channel on death
	displayDeathChannelMessages = true
	-- modify damage to K 219000 -> 219.0K
	modifyDamageInK = false
	-- modify exp to K/mi 2.000.000 exp -> 2.0 mi
	modifyExperienceInK= false
	-- display broadcast in distro
	displayBroadcastLog = true

	sqlType = "mysql"
	sqlHost = "localhost"
	sqlPort = 3306
	sqlUser = "root"
	sqlPass = ""
	sqlDatabase = "database"
	sqlFile = "schemas/otxserver.s3db"
	sqlKeepAlive = 0
	mysqlReadTimeout = 15000
	mysqlWriteTimeout = 15000
	mysqlReconnectionAttempts = 5
	encryptionType = "sha1"

	worldId = 0
	ip = "127.0.0.1"
	worldType = "open"
	bindOnlyGlobalAddress = false
	loginPort = 7171
	gamePort = "7172"
	statusPort = 7171
	loginOnlyWithLoginServer = false
	
	blockedVps = "google;amazon;amazon.com;oracle;azure;vultr;google.com"
	permitedVps = 0
	
	accountManager = false
	namelockManager = true
	newPlayerChooseVoc = true
	newPlayerSpawnPosX = 138
	newPlayerSpawnPosY = 144
	newPlayerSpawnPosZ = 7
	newPlayerTownId = 1
	newPlayerLevel = 50
	newPlayerMagicLevel = 0
	generateAccountNumber = false
	generateAccountSalt = false
	useFragHandler = true
	fragsLimit = 24 * 60 * 60
	fragsSecondLimit = 1 * 24 * 60 * 60
	fragsThirdLimit = 1 * 24 * 60 * 60
	
	fragsToRedSkull = 200
	fragsSecondToRedSkull = 999999
	fragsThirdToRedSkull = 999999
	redSkullLength = 1 * 24 * 60 * 60

	fragsToBlackSkull = 250
	fragsSecondToBlackSkull = 99999
	fragsThirdToBlackSkull = 99999
	blackSkulledDeathHealth = 40
	blackSkulledDeathMana = 0
	blackSkullLength = 1 * 24 * 60 * 60
	useBlackSkull = true

	notationsToBan = 3
	warningsToFinalBan = 4
	warningsToDeletion = 5
	banLength = 1 * 24 * 60 * 60
	killsBanLength = 7 * 24 * 60 * 60
	finalBanLength = 30 * 24 * 60 * 60
	ipBanLength = 1 * 24 * 60 * 60
	fragsToBanishment = 7
	fragsSecondToBanishment = 21
	fragsThirdToBanishment = 41
	
	protectionLevel = 100
	pvpTileIgnoreLevelAndVocationProtection = true
	pzLocked = 20 * 1000
	pzlockOnAttackSkulledPlayers = false
	huntingDuration = 20 * 1000
	criticalHitMultiplier = 1
	displayCriticalHitNotify = false
	removeWeaponAmmunition = false
	removeWeaponCharges = false
	removeRuneCharges = false
	whiteSkullTime = 60 * 1000
	advancedFragList = false
	useFragHandler = true
	noDamageToSameLookfeet = false
	showHealthChange = false		
	--mudados pra false ^
	showManaChange = false			
	--mudados pra false ^
	showHealthChangeForMonsters = false
	showManaChangeForMonsters = false
	fieldOwnershipDuration = 5 * 1000
	stopAttackingAtExit = false
	loginProtectionPeriod = 5000
	diagonalPush = true
	deathLostPercent = 10
	stairhopDelay = 0.3 * 1000
	pushCreatureDelay = 1 * 280
	deathContainerId = 1987
	gainExperienceColor = 210
	addManaSpentInPvPZone = true
	recoverManaAfterDeathInPvPZone = true
	squareColor = 0
	broadcastBanishments = false
	maxViolationCommentSize = 60
	violationNameReportActionType = 2
	
	-- Corpse Block
		-- If set to true, players won't be able to immediately throw fields on top of corpses after killing the monster
	allowCorpseBlock = false

	rsaPrime1 = "14299623962416399520070177382898895550795403345466153217470516082934737582776038882967213386204600674145392845853859217990626450972452084065728686565928113"
	rsaPrime2 = "7630979195970404721891201847792002125535401292779123937207447574596692788513647179235335529307251350570728407373705564708871762033017096809910315212884101"
	rsaPublic = "65537"
	rsaModulus = "109120132967399429278860960508995541528237502902798129123468757937266291492576446330739696001110603907230888610072655818825358503429057592827629436413108566029093628212635953836686562675849720620786279431090218017681061521755056710823876476444260558147179707119674283982419152118103759076030616683978566631413"
	rsaPrivate = "46730330223584118622160180015036832148732986808519344675210555262940258739805766860224610646919605860206328024326703361630109888417839241959507572247284807035235569619173792292786907845791904955103601652822519121908367187885509270025388641700821735345222087940578381210879116823013776808975766851829020659073"


		optionalWarAttackableAlly = true
		fistBaseAttack = 7
		criticalHitChance = 7
		noDamageToGuildMates = false
		noDamageToPartyMembers = true

		rookLevelTo = 5
		rookLevelToLeaveRook = 8
		rookTownId = 1
		useRookSystem = true

		paralyzeDelay = 1500

		premiumDaysToAddByGui = 0

		useCapacity = true
		defaultDepotSize = 400
		defaultDepotSizePremium = 400
		enableProtectionQuestForGM = false
		cleanItemsInMap = false
		playerFollowExhaust = 500

		monsterSpawnWalkback = false
		allowBlockSpawn = true
		
		classicEquipmentSlots = true

		NoShareExpSummonMonster = false

		enableLootBagDisplay = true
		highscoreDisplayPlayers = 10
		updateHighscoresAfterMinutes = 60
		attackImmediatelyAfterLoggingIn = false
		exhaustionNPC = true
		exhaustionInSecondsNPC = 0.5

		manualVersionConfig = true
		versionMin = 854
		versionMax = 861
		versionMsg = "Only clients with protocol 8.60 allowed!"

	loginTries = 20
	retryTimeout = 5 * 1000
	loginTimeout = 60 * 1000
	maxPlayers = 1200
	useFilaOnStartup = true
	displayOnOrOffAtCharlist = false
	onePlayerOnlinePerAccount = false
	allowClones = 0
	statusTimeout = 1000
	replaceKickOnLogin = true
	forceSlowConnectionsToDisconnect = false
	premiumPlayerSkipWaitList = false
	packetsPerSecond = 1000
	loginProtectionTime = 5
	tibiaClassicSlots = true

	deathListEnabled = true
	deathListRequiredTime = 1 * 60 * 1000
	deathAssistCount = 20
	maxDeathRecords = 5
	multipleNames = false

	externalGuildWarsManagement = false
	ingameGuildManagement = false
	levelToFormGuild = 4000
	premiumDaysToFormGuild = 0
	guildNameMinLength = 4
	guildNameMaxLength = 20

	buyableAndSellableHouses = true
	houseNeedPremium = false
	bedsRequirePremium = false
	levelToBuyHouse = 10000
	housesPerAccount = 1
	houseRentAsPrice = true
	housePriceAsRent = 100000
	housePriceEachSquare = 100000
	houseRentPeriod = "weekly"
	houseCleanOld = 7 * 24 * 60 * 60
	guildHalls = false
	houseSkipInitialRent = true
	houseProtection = false

	timeBetweenActions = 200
	timeBetweenExActions = 500
	timeBetweenCustomActions = 0
	checkCorpseOwner = true
	hotkeyAimbotEnabled = true
	maximumDoorLevel = 200000
	tradeLimit = 100
	canOnlyRopePlayers = true

	mapAuthor = "@eoluxX featured Alex and Flamearcixt"
	randomizeTiles = true
	houseDataStorage = "binary-tilebased"
	storeTrash = true
	cleanProtectedZones = true
	mapName = "forgotten.otbm"

	mailMaxAttempts = 5
	mailBlockPeriod = 30 * 60 * 1000
	mailAttemptsFadeTime = 5 * 60 * 1000
	mailboxDisabledTowns = ""

	daemonize = false
	defaultPriority = "higher"
	niceLevel = 5
	serviceThreads = 1
	coresUsed = "-1"
	startupDatabaseOptimization = true
	removePremiumOnInit = true
	confirmOutdatedVersion = false
	skipItemsVersionCheck = true

	maxMessageBuffer = 4

	dataDirectory = "data/"
	logsDirectory = "data/logs/"
	disableOutfitsForPrivilegedPlayers = false
	bankSystem = true
	spellNameInsteadOfWords = false
	emoteSpells = true
	unifiedSpells = true
	promptExceptionTracerErrorBox = true
	storePlayerDirection = false
	savePlayerData = true
	monsterLootMessage = 3
	monsterLootMessageType = 25
	separateViplistPerCharacter = false
	vipListDefaultLimit = 20
	vipListDefaultPremiumLimit = 100

	allowChangeOutfit = true
	allowChangeColors = true
	allowChangeAddons = true
	addonsOnlyPremium = false

	ghostModeInvisibleEffect = false
	ghostModeSpellEffects = false

	idleWarningTime = 14 * 60 * 1000
	idleKickTime = 15 * 60 * 1000
	expireReportsAfterReads = 1
	playerQueryDeepness = -1
	protectionTileLimit = 8
	houseTileLimit = 10
	tileLimit = 5

	freePremium = false
	premiumForPromotion = false
	updatePremiumStateAtStartup = true

	blessings = true
	blessingOnlyPremium = false
	blessingReductionBase = 30
	blessingReductionDecrement = 5
	eachBlessReduction = 8
	useFairfightReduction = true
	pvpBlessingThreshold = 20
	fairFightTimeRange = 60

	experienceStages = true
	rateExperience = 999
	rateExperienceFromPlayers = 0
	levelToOfflineTraining = 8
	rateSkill = 30
	rateSkillOffline = 10
	rateMagic = 15
	rateMagicOffline = 5
	rateLoot = 4
	rateSpawn = 1
	rateSpawnMin = 1
	rateSpawnMax = 2
	formulaLevel = 5.0
	formulaMagic = 1.0
	rateMonsterHealth = 1.0
	rateMonsterMana = 1.0
	rateMonsterAttack = 0.8
	rateMonsterDefense = 1.5

	minLevelThresholdForKilledPlayer = 0.9
	maxLevelThresholdForKilledPlayer = 1.1

	rateStaminaLoss = 1
	rateStaminaGain = 1
	rateStaminaThresholdGain = 1
	staminaRatingLimitTop = 40 * 60
	staminaRatingLimitBottom = 14 * 60
	staminaLootLimit = 14 * 60
	rateStaminaAboveNormal = 1.2
	rateStaminaUnderNormal = 0.5
	staminaThresholdOnlyPremium = false

	experienceShareRadiusX = 10
	experienceShareRadiusY = 10
	experienceShareRadiusZ = 1
	experienceShareLevelDifference = 2 / 3
	extraPartyExperienceLimit = 7
	extraPartyExperiencePercent = 5
	experienceShareActivity = 30 * 1000
	
	-- Party Multiplier Experience
	enablePartyVocationBonus = true
	twoVocationExpMultiplier = 1.4
	threeVocationExpMultiplier = 1.6
	fourVocationExpMultiplier = 2.0

	globalSaveEnabled = false
	globalSaveHour = 04
	globalSaveMinute = 00
	shutdownAtGlobalSave = false
	cleanMapAtGlobalSave = false

	minRateSpawn = 1
	maxRateSpawn = 3
	deSpawnRange = 2
	deSpawnRadius = 50

	maxPlayerSummons = 2
	teleportAllSummons = false
	teleportPlayerSummons = true

	disableLuaErrors = false
	adminLogs = true
	displayPlayersLogging = true
	prefixChannelLogs = ""
	runFile = "server/run.log"
	outputLog = "server/out.log"
	truncateLogOnStartup = false
	logPlayersStatements = false

	managerPort = 7171
	managerLogs = true
	managerPassword = ""
	managerLocalhostOnly = true
	managerConnectionsLimit = 1

	adminPort = 7171
	adminPassword = ""
	adminLocalhostOnly = true
	adminConnectionsLimit = 1
	adminRequireLogin = true
	adminEncryption = ""
	adminEncryptionData = ""

	saveGlobalStorage = true
	bufferMutedOnSpellFailure = false