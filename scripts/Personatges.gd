class_name Personatge extends Node

enum Nom {
	CAÇADORA,
	JUGLA,
	VELL,
	PROGRAMADORA,
	ANARKO,
	NINIOS,
	MOSSEN,
	BORRATXO,
	ENTERRADORA,
}

static var aparicions_per_personatge: Dictionary = {
	Nom.CAÇADORA: 0,
	Nom.JUGLA: 0,
	Nom.VELL: 0,
	Nom.PROGRAMADORA: 0,
	Nom.ANARKO: 0,
	Nom.NINIOS: 0,
	Nom.MOSSEN: 0,
	Nom.BORRATXO: 0,
	Nom.ENTERRADORA: 0,
}

const DADES: Dictionary = {
	Nom.CAÇADORA: {
		"nom": "Caçadora",
		"sprite": preload("res://escenes/personatges/sprite_caçadora.tscn"),
		"icona": preload("res://escenes/personatges/icona_caçadora.tscn"),
		"dialeg": [
			[
				"Benvolguda, m'han arribat notícies de la vostra àrdua tasca de reconstruir les cases del poblat",
				"Sóc sols una humil caçadora, però he pensat que aquest tronc us ajudaria",
			],
			[
				"Benvolguda, voltava pel bosc i he trobat... un tronc",
				"M'ha fet pensar en vós",
				"Espero que us serveixi. Té una mica de molsa",
			],
			[
				"Què passa, tronca? Es diu així, no?",
				"Els nens m'han dit que és hilarant presentar-se així",
				"És una frase còmica perquè us he dut un tronc",
			],
			[
				"Hola? Pensava que ja no la trobaria",
				"He trobat això entre els matolls... he pensat que hauria de ser per vós",
				"Espero que tingueu un dia especial",
			],
		],
		"obsequis": [
			[
				[Vector2i(0,0), Vector2i(0,1)],
				[Vector2i(9,4), Vector2i(9,5)],
			],
			[
				[Vector2i(0,0), Vector2i(0,1)],
				[Vector2i(7,4), Vector2i(7,5)],
			],
			[
				[Vector2i(0,0), Vector2i(0,1), Vector2i(0,2)],
				[Vector2i(6,6), Vector2i(6,7), Vector2i(6,8)],
			],
			[
				[Vector2i(0,0), Vector2i(0,1), Vector2i(0,2)],
				[Vector2i(8,4), Vector2i(8,5), Vector2i(8,6)],
			],
		],
	},
	Nom.JUGLA: {
		"nom": "Jugla",
		"sprite": preload("res://escenes/personatges/sprite_jugla.tscn"),
		"icona": preload("res://escenes/personatges/icona_jugla.tscn"),
		"dialeg": [
			[
				"Ei... voleu arreglar el poble, eh? Ànims!",
				"Jo no tinc gaire res... bé, m'he begut una Dragacola. Potser us serveix",
			],
			[
				"Suuup... què passa?",
				"Escolta, que si us ha anat bé la llauna, també m'he pres una Dragacola Lite",
				"Que us serveixi! Pau i amor"
			],
			[
				"Què passa, penya?",
				"Que estava jo pensant, si tan bé els hi van les llaunes, tant per tant...",
				"... us en deixo una caixa sencera. Apa, salut i força al canut"
			],
		],
		"obsequis": [
			[
				[Vector2i(0,0), Vector2i(0,1)],
				[Vector2i(2,5), Vector2i(2,6)],
			],
			[
				[Vector2i(0,0), Vector2i(0,1)],
				[Vector2i(2,2), Vector2i(2,3)],
			],
			[
				[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
				[Vector2i(3,7), Vector2i(4,7), Vector2i(3,8), Vector2i(4,8)],
			],
		],
	},
	Nom.VELL: {
		"nom": "Vell",
		"sprite": preload("res://escenes/personatges/sprite_vell.tscn"),
		"icona": preload("res://escenes/personatges/icona_vell.tscn"),
		"dialeg": [
			[
				"Bon dia joveneta, aquest dragot que hi ha a fora és un xic malcarat, no trobes?",
				"Jo vinga a trucar a la porta i ell no volia obrir-me de cap manera",
				"Ves, que voleu reconstruir el poble, oi?",
				"Us duc una canonada que no faig servir",
			],
			[
				"Bona tarda joveneta, a veure si ensenyarem aquesta bèstia a portar-se com toca",
				"Quan jo era jove, au! Cop de bastó i s'arreglava tot fàcil",
				"Però avui rai... rai",
				"Us porto una canonada més, que no sé per què en posen tantes",
			],
			[
				"Bona vesprada joveneta, ara el llangardaix sí que ha aprés maneres",
				"Deu haver sentit això del cop de bastó, he he",
				"Doncs que les dues canonades d'abans aguantaven una paret",
				"Tota per terra, ja us imagineu. Us n'he portat un tros, rai",
			],
		],
		"obsequis": [
			[
				[Vector2i(0,0), Vector2i(0,1)],
				[Vector2i(6,4), Vector2i(6,5)],
			],
			[
				[Vector2i(0,0), Vector2i(0,1)],
				[Vector2i(5,4), Vector2i(5,5)],
			],
			[
				[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
				[Vector2i(4,2), Vector2i(5,2), Vector2i(4,3), Vector2i(5,3)],
			],
		],
	},
	Nom.PROGRAMADORA: {
		"nom": "Programadora",
		"sprite": preload("res://escenes/personatges/sprite_programadora.tscn"),
		"icona": preload("res://escenes/personatges/icona_programadora.tscn"),
		"dialeg": [
			[
				"Bones, m'he assabentat que voleu reconstruir el poble",
				"Jo només vinc a dir-vos que si voleu fer una casa hauríeu de tenir els permisos",
				"Heu llegit el manual de construcció, com a mínim...?",
				"Mira, feu el que vulgueu. Jo he avisat. Xau",
			],
			[
				"Al final he anat a buscar el manual de construcció",
				"Llegiu-vos-el abans de seguir amb la feina, sisplau",
			],
			[
				"No heu llegit el manual, oi?",
				"... ja veig que no... quina barra...",
				"... i encara sense permisos de construcció",
				"No, si ja sabreu. Xau",
			],
			[
				"Saps què? Us he portat la legislació vigent",
				"Llegiu-la, sisplau, abans de seguir la feina",
			],
			[
				"Veig que no feu servir els llibres pel que toca",
				"... tant li fot. Tothom parla bé de valtros",
				"Us n'he dut un altre. De què és? De cuina?",
				"Si tampoc us el llegireu! Au, no em feu riure",
			],
		],
		"obsequis": [
			[],
			[
				[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
				[Vector2i(0,2), Vector2i(1,2), Vector2i(0,3), Vector2i(1,3)],
			],
			[],
			[
				[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
				[Vector2i(0,2), Vector2i(1,2), Vector2i(0,3), Vector2i(1,3)],
			],
			[
				[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
				[Vector2i(8,2), Vector2i(9,2), Vector2i(8,3), Vector2i(9,3)],
			],
		],
	},
	Nom.ANARKO: {
		"nom": "Anarko",
		"sprite": preload("res://escenes/personatges/sprite_anarko.tscn"),
		"icona": preload("res://escenes/personatges/icona_anarko.tscn"),
		"dialeg": [
			[
				"Ep, és aquí la construcció clandestina?",
				"No, i ara, clar que no, he. He",
				"He trobat una totxana, no crec que sigui de ningú",
				"... si algú la reclama, a mi no m'has vist pas",
			],
			[
				"Ep, torno a ser jo",
				"Et deixo una totxana més. Ja saps, tu mutis",
				"Que d'on surt? Mira la senyoreta, amb les seves preguntasses!",
				"... és confidencial, eh?",
			],
			[
				"Ep. Com avança, això?",
				"Un agraïment per la feina que feu per la comunitat",
				"Això ha costat un xic més de trobar...",
				"... però crec que us farà molt de servei. Salut i força!",
			],
		],
		"obsequis": [
			[
				[Vector2i(0,0), Vector2i(1,0)],
				[Vector2i(0,4), Vector2i(0,4)],
			],
			[
				[Vector2i(-1,0), Vector2i(0,0), Vector2i(0,-1)],
				[Vector2i(3,6), Vector2i(4,6), Vector2i(4,5)],
			],
			[
				[Vector2i(0,-1), Vector2i(-1,0), Vector2i(0,0), Vector2i(0,1), Vector2i(0,1)],
				[Vector2i(3,3), Vector2i(2,4), Vector2i(3,4), Vector2i(4,4), Vector2i(3,5)],
			],
		],
	},
	Nom.NINIOS: {
		"nom": "Ninios",
		"sprite": preload("res://escenes/personatges/sprite_ninios.tscn"),
		"icona": preload("res://escenes/personatges/icona_ninios.tscn"),
		"dialeg": [
			[
				"Hola! És veritat que fas una casa?",
				"I el drac t'ajuda? Sou amics?",
				"Nosaltres també volem ajudar! Us portem una cosa",
				"Tava al costat del camí. L'hem punxat amb un pal i no es mou",
			],
			[
				"Hola! Com us vau conèixer tu i el drac?",
				"Us hem portat un altre regal",
				"Aquesta si que es movia una mica, però li hem fotut amb el pal i ja no",
			],
			[
				"Hola! Que falta molt?",
				"Volem jugar amb el drac!",
				"Us hem portat un altre regal. L'hem tocat amb el pal i no es movia gens",
				"... però fa una mica més de pudor que els altres",
			],
		],
		"obsequis": [
			[
				[Vector2i(0,0), Vector2i(0,1)],
				[Vector2i(0,0), Vector2i(0,1)],
			],
			[
				[Vector2i(0,0), Vector2i(0,1)],
				[Vector2i(1,0), Vector2i(1,1)],
			],
			[
				[Vector2i(0,0), Vector2i(0,1)],
				[Vector2i(0,7), Vector2i(0,8)],
			],
		],
	},
	Nom.MOSSEN: {
		"nom": "Mossén",
		"sprite": preload("res://escenes/personatges/sprite_mossen.tscn"),
		"icona": preload("res://escenes/personatges/icona_mossen.tscn"),
		"dialeg": [
			[
				"Déu sia amb tu, germana",
				"He vist que estàs construïnt una casa amb l'ajuda de la bèstia blasfema que m'ha obert la porta",
				"Vinc amoïnat, ha desaparegut una totxana de l'esglèsia, no sé pas si en sabeu res...",
				"Que Déu tingui pietat de vosaltres",
			],
			[
				"Déu sia amb tu, germana",
				"Més totxanes s'han esvanit a l'esglèsia...",
				"No sé pas què fer... sospito de la bèstia infernal... no para de moure maons...",
				"Que el Senyor et tingui en gràcia...",
			],
			[
				"Déu sia amb tu, germana",
				"És espantós... ha desaparegut el Sant Crist de la capella!",
				"El dimoni ha enfonsat arrels en aquest poble que construïu",
				"Vade retro",
			],
			[
				"Déu sia amb tu, germana",
				"Tard o d'hora haureu d'expiar els vostres pecats",
				"No perdo l'esperança per vosaltres, ja que us aveniu a obrir-me la porta",
				"Us deixo aquest obsequi, que us sigui d'ajuda",
			],
		],
		"obsequis": [
			[],
			[],
			[],
			[
				[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
				[Vector2i(1,7), Vector2i(2,7), Vector2i(1,8), Vector2i(2,8)],
			],
		],
	},
	Nom.BORRATXO: {
		"nom": "Borratxo",
		"sprite": preload("res://escenes/personatges/sprite_borratxo.tscn"),
		"icona": preload("res://escenes/personatges/icona_borratxo.tscn"),
		"dialeg": [
			[
				"(hic) Bon dia peldematí",
				"És aquí que construïu cases?",
				"Jo us ajudo en el que calgui, aquí teniu una totxana",
				"Apa, salut",
			],
			[
				"(hic) Bon... migdia",
				"La bèstia que m'ha obert la porta... és un drac?",
				"Us he portat una totxana perquè feu la casa més alta de totes",
				"Apa, salut",
			],
			[
				"....",
				"Què? Bona tarda",
				"Se m'està passant la borratxera, crec",
				"... de tant carregar aquest tros de totxo per vosaltres",
				"Apa, salut",
			],
			[
				"(hic) Boooona vesprada",
				"Aquesta casa que esteu fent és una guapada, eh?",
				"Us volia portar una altra totxana, però ja no me'n queden més",
				"Espero que això us serveixi. Salut!",
			],
		],
		"obsequis": [
			[
				[Vector2i(0,0), Vector2i(1,0)],
				[Vector2i(6,2), Vector2i(7,2)],
			],
			[
				[Vector2i(-1,0), Vector2i(0,0), Vector2i(0,-1)],
				[Vector2i(7,8), Vector2i(8,8), Vector2i(8,7)],
			],
			[
				[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
				[Vector2i(4,0), Vector2i(5,0), Vector2i(4,1), Vector2i(5,1)],
			],
		],
	},
	Nom.ENTERRADORA: {
		"nom": "Enterradora",
		"sprite": preload("res://escenes/personatges/sprite_enterradora.tscn"),
		"icona": preload("res://escenes/personatges/icona_enterradora.tscn"),
		"dialeg": [
			[
				"Hola bonica",
				"M'han dit que esteu fent cases noves",
				"Ja tocava... a aquest poble hi ha més morts que vius",
				"A mi, la veritat... uns quants que me'n sobren",
			],
			[
				"Com aneu?",
				"Aquesta bestiona de fora és ben eixerida",
				"Li duc un regalet, per si li ve fam de tant treballar",
			],
			[
				"Què? Com prova això?",
				"Mireu, estava cavant una tomba, i...",
				"... i m'ha saltat aixons? Què deu ser? És molt gros per ser de persona",
			],
			[
				"No us ho creureu",
				"He seguit cavant a la mateixa tomba, i mireu...",
				"... quina bèstia més estranya. No sembla ni home ni drac",
			],
		],
		"obsequis": [
			[
				[Vector2i(0,0), Vector2i(0,1)],
				[Vector2i(7,6), Vector2i(7,7)],
			],
			[
				[Vector2i(0,0), Vector2i(0,1), Vector2i(0,2)],
				[Vector2i(10,3), Vector2i(10,4), Vector2i(10,5)],
			],
			[
				[Vector2i(0,0), Vector2i(0,1), Vector2i(0,2)],
				[Vector2i(10,6), Vector2i(10,7), Vector2i(10,8)],
			],
			[
				[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)],
				[Vector2i(6,0), Vector2i(7,0), Vector2i(6,1), Vector2i(7,1), Vector2i(8,1)],
			],
		],
	},
}

static func get_enum_from_string(string_value: String) -> int:
	var string_maj = string_value.to_upper()
	if Nom.has(string_maj):
		return Nom[string_maj]
	else:
		push_error("Nom de personatge invàlid: " + string_value)
		return -1

static func augmenta_aparicions(nom: Personatge.Nom) -> void:
	if aparicions_per_personatge[nom] < Personatge.DADES[nom]["dialeg"].size() - 1:
		aparicions_per_personatge[nom] += 1
