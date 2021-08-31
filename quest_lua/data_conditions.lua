_G.cards_indexes = {};
for i=1,#cards do
	local obj = cards[i];
	cards_indexes[obj.tag] = obj;
	
	if(options_debug~=true)then
		_G.language:addEnWord(get_name_id(obj.tag), obj.tag);
	end
end
_G.potions_indexes = {};

if(cards_indexes["Boomerang"])then
	-- cards_indexes["Strike"].onUpgrade = {dmg=9};
	cards_indexes['Bash'].onUpgrade = {dmg=10, vulnerable=3};
	cards_indexes['Heavy Blade'].onUpgrade = {strX=5};
	-- cards_indexes['Cleave'].onUpgrade = {dmg=10};
	cards_indexes['Clothesline'].onUpgrade = {dmg=14, weak=3};
	cards_indexes['Iron Wave'].onUpgrade = {dmg=7, armor=7};
	cards_indexes['Thunderclap'].onUpgrade = {dmg=7};
	-- cards_indexes['Pomel Strike'].onUpgrade = {dmg=10, draw=2};
	cards_indexes['Twin Strike'].onUpgrade = {dmg=7};
	cards_indexes['Boomerang'].onUpgrade = {times=4};
	-- cards_indexes['Anger'].onUpgrade = {dmg=6};
	cards_indexes['Wild Strike'].onUpgrade = {dmg=17};
	-- cards_indexes['Perfect Strike'].onUpgrade = {addDmgByCard={"Strike", 3}};
	cards_indexes['Headbutt'].onUpgrade = {dmg=12};
	cards_indexes['Clash'].onUpgrade = {dmg=18};
	cards_indexes['Uppercut'].onUpgrade = {weak=2, vulnerable=2};
	cards_indexes['Sever Soul'].onUpgrade = {dmg=20};
	cards_indexes['Pummel'].onUpgrade = {times=5};
	cards_indexes['Hemokinesis'].onUpgrade = {harm=2, dmg=18};
	-- cards_indexes['Carnage'].onUpgrade = {dmg=26};
	cards_indexes['Rampage'].onUpgrade = {onUse={action="plus", target="dmg", val=8}};
	-- cards_indexes['Rekless Charge'].onUpgrade = {dmg=12};
	cards_indexes['DropKick'].onUpgrade = {dmg=8};
	-- cards_indexes['Whirlwind'].onUpgrade = {dmg=8};
	-- cards_indexes['Searing Blow'].onUpgrade = {};
	-- cards_indexes['Blood for Blood'].onUpgrade = {energy=3, dmg=18};
	cards_indexes['Bludgeon'].onUpgrade = {dmg=42};
	cards_indexes['Reaper'].onUpgrade = {dmg=5};
	cards_indexes['Fiend Fire'].onUpgrade = {hand={action="exhaust", ctype='all', value=false, onCount={dmg=10}}};

	cards_indexes['Flex'].onUpgrade = {str=4, strNext=-4};
	cards_indexes['Intimidate'].onUpgrade = {weak=2};
	-- cards_indexes['Disarm'].onUpgrade = {str=-3};
	cards_indexes['Shockwave'].onUpgrade = {weak=5, vulnerable=5};
	cards_indexes['Battle Trance'].onUpgrade = {draw=4};
	cards_indexes['Impervious'].onUpgrade = {armor=40};
	cards_indexes['Limit Break'].onUpgrade = {exhaust=false};
	-- cards_indexes['Offering'].onUpgrade = {draw=5};
	cards_indexes['Seeing Red'].onUpgrade = {energy=0};
	cards_indexes['Second Wind'].onUpgrade = {hand={action="exhaust", ctype=CTYPE_ATTACK, value=false, onCount={armor=7}}};
	-- cards_indexes['Dual Wield'].onUpgrade = {onUse={action="copy", target="hand", filter={"ctype", CTYPE_SKILL, false}, amount=2}};
	cards_indexes['Havoc'].onUpgrade = {energy=0};
	cards_indexes['Entrench'].onUpgrade = {energy=1};
	cards_indexes['Ghostly Armor'].onUpgrade = {armor=13};
	cards_indexes['Power Through'].onUpgrade = {armor=20};
	cards_indexes['Armaments'].onUpgrade = {onUse={action="upgrade", target="hand", filter={"ctype", "all", false}, amount="all"}};
	cards_indexes['True Grit'].onUpgrade = {armor=9, onUse={action="exhaust", target="hand", filter={"ctype", "all", false}, amount=1}};
	cards_indexes['Infernal Blade'].onUpgrade = {energy=0};
	cards_indexes['Warcry'].onUpgrade = {draw=2};
	-- cards_indexes['Rage'].onUpgrade = {rage=6};
	cards_indexes['Sentinel'].onUpgrade = {armor=8, onExhaust={energyAdd=3}};

	cards_indexes['Inflame'].onUpgrade = {str=3};
	cards_indexes['Metallicize'].onUpgrade = {protect=4};
	-- cards_indexes['Fire Breath'].onUpgrade = {energy=0};
	cards_indexes['Rupture'].onUpgrade = {energy=0};
	-- cards_indexes['Feel No Pain'].onUpgrade = {feelnopain=6};
	cards_indexes['Corruption'].onUpgrade = {energy=2};
	cards_indexes['Barricade'].onUpgrade = {energy=2};
	cards_indexes['Demon Form'].onUpgrade = {demon=3};
	cards_indexes['Dark Embrace'].onUpgrade = {energy=1};
	cards_indexes['Brutality'].onUpgrade = {innate=true};

end

if(cards_indexes["Shiv"])then
	-- cards_indexes['Shiv'].onUpgrade = {dmg=6};
	cards_indexes['Bite'].onUpgrade = {dmg=8, heal=3};
	cards_indexes['Dramatic Entrance'].onUpgrade = {dmg=8};
	-- cards_indexes['Mind Blast'].onUpgrade = {innate=true};
	cards_indexes['Swift Strike'].onUpgrade = {dmg=8};
	cards_indexes['JAX'].onUpgrade = {str=3};
	cards_indexes['Blind'].onUpgrade = {range="enemies"};
	cards_indexes['Trip'].onUpgrade = {range="enemies"};
	cards_indexes['Dark Shackles'].onUpgrade = {str=-15, strNext=15};
	cards_indexes['Deep Breath'].onUpgrade = {draw=2};
	cards_indexes['Finesse'].onUpgrade = {armor=4};
	cards_indexes['Good Instincts'].onUpgrade = {armor=7};
	-- cards_indexes['Jack Of All Trades'].onUpgrade = {create={count=2, attr="class", val="none"}};
	cards_indexes['Madness'].onUpgrade = {energy=0};
	cards_indexes['Panacea'].onUpgrade = {artifact=2};
	cards_indexes['Purity'].onUpgrade = {onUse={action="exhaust", target="hand", filter={"ctype", "all", false}, amount=5}};
	cards_indexes['Secret Weapon'].onUpgrade = {exhaust=false};
	cards_indexes['Apotheosis'].onUpgrade = {energy=1};
	-- cards_indexes['Enlightenment'].onUpgrade = {enlightenment=99};
	cards_indexes['Master Of Strategy'].onUpgrade = {draw=4};
	cards_indexes['Secret Technique'].onUpgrade = {exhaust=false};
	cards_indexes['Thinking Ahead'].onUpgrade = {exhaust=false};
	-- cards_indexes['Transmutation'].onUpgrade = {create={count=1, attr="class", val="none", upgrade=true}};
	cards_indexes['Sadistic Nature'].onUpgrade = {sadistic=4};
	cards_indexes['Panache'].onUpgrade = {panache=14};
end

-- hinted - описание будет браться из текстового файла, без расшифровки - скоре всего это талант.
-- intend - после добавления - цель обновит свои намериния(например слабость - цель будет меньше наносить дмг)
-- target - "self" - такие эффекты всегда кастуються на того кто их делает - даже если цель враг

conditions.money = {};
conditions.str = {hinted=true};
conditions.wristblade={};
conditions.pain = {hidden=true};--hidden=true
conditions.harmed = {expire=9999, hidden=false};
conditions.attacked = {hidden=true, expire=9999}; -- how many TIMES (this turn stand for "expire=9999")
conditions.damaged = {hidden=true, expire=9999}; -- how much DAMAGE (this turn stand for "expire=9999")
conditions.weak = {expire=1, debuff=true, expireAtEnd=true, intend=true, hinted=true};
conditions.frail = {expire=1, debuff=true, expireAtEnd=true};
conditions.spike = {event="dmg", play={range="enemy", dmg=1, strX=0, gfx_target="spikes3"}};
conditions.boss = {number=false, hidden=true};
conditions.minion = {number=false, hidden=false};
conditions.drawless = {event="turn", expire=1, debuff=true};
conditions.drawpower = {event="turn", play={range="self", draw=1}};
conditions.drawonpower = {event="played_"..CTYPE_POWER, play={range="self", draw=1}};
conditions.frozen = {expire=1};
conditions.losingdex = {event="turn", play={range="self", dex=-1}};
conditions.corpseexplosion = {number=false};
conditions.energysave = {number=false};
conditions.finished = {number=false};
conditions.leacharmor = {debuff=true, event="dmg", hinted=true, play={range="enemy", armorToTarget=1}};
conditions.armortoweak = {expire=999, event="armor", play={range="enemies", weak=1}};

conditions.upgradenewtempcards = {number=false};

conditions.hex = {event="played_not_"..CTYPE_ATTACK, play={addStatuses={deck={"Dazed"}}}, debuff=true};
conditions.vulnerable = {event="turn", expire=1, debuff=true, expireAtEnd=true};
conditions.strNext = {msg=false};

conditions.extrax = {msg=false, };
conditions.freecast = {event="turn", expire=999};
conditions.freeattack = {event="turn", expire=999};

conditions.skipTurn = {hinted=true, event="turn", play={range="self", skipTurnAct=true}, expire=9999};

conditions.cards_game = {hidden=true};
conditions.cards_game_1 = {hidden=true}; -- Attack cards played this game
conditions.cards_game_2 = {hidden=true};
conditions.cards_game_3 = {hidden=true};
conditions.cards_game_4 = {hidden=true};
conditions.cards_game_5 = {hidden=true};

conditions.cards_turn_1 = {expire=9999, hidden=true}; -- Attack cards played this turn
conditions.cards_turn_2 = {expire=9999, hidden=true};
conditions.cards_turn_3 = {expire=9999, hidden=true};
conditions.cards_turn_4 = {expire=9999, hidden=true};
conditions.cards_turn_5 = {expire=9999, hidden=true};

conditions.magnetism = {event="turn", play={range='self', create={count=1, attr="class", val="none"}}};
conditions.energetic = {hinted=true, event="turn", play={range='self', energyAdd=1}};
conditions.energymax = {hidden=true};
conditions.energeticsuper = {event="turn", play={range='self', energetic=1}};
conditions.blinded = {event="turn", number=false}; -- hardcoded =)
conditions.shield = {event="turnEnd", expireAtEnd=true, play={range='self', armor=1, dexX=0}, hinted=true};
-- conditions.armorminimum = {event="turn", play={range='self', ifEnemy={czero="armor", play={armor=1}}}};
conditions.healing = {event="heal"};
conditions.aggressive = {event="dmg", play={range="self", str=1}};
conditions.blur = {event="turn", expire=1};
conditions.protect = {event="turnEnd", expireAtEnd=true, play={range='self', armor=1, dexX=0}};
conditions.rupture = {event="harm", play={str=1, range='self'}};
conditions.juggernaut = {event="armor", play={dmg=1, range='rnd', strX=0, dtype=DTYPE_TRUE}};
-- conditions.juggernaut1 = {event="armor", play={dmg=3, range='rnd', strX=0, dtype=DTYPE_TRUE}};
-- conditions.juggernaut2 = {event="armor", play={dmg=5, range='rnd', strX=0, dtype=DTYPE_TRUE}};
conditions.evolve = {event="addedCtype"..CTYPE_STATUS, play={range="self", draw=1}};
conditions.feelnopain = {event="exhausted", play={armor=1, range='self'}};
conditions.darkembrace = {event="exhausted", play={draw=1}};
conditions.firebreath = {event="played_"..CTYPE_ATTACK, play={dmg=1, range='enemies'}};
conditions.rage = {event="played_"..CTYPE_ATTACK, play={armor=1}, expire=999};
conditions.demon = {event="turn", play={str=1, range='self'}};
-- conditions.berserk = {event="turn"}; -- hardcoded =)
conditions.brutality = {event="turn", play={harm=1, draw=1}};

-- conditions.combust1 = {event="turnEnd", play={harm=1, dmg=5, range='enemies'}};
-- conditions.combust2 = {event="turnEnd", play={harm=1, dmg=6, range='enemies'}};
conditions.combust = {event="turnEnd", play={dmg=1, range='enemies'}};
conditions.bleeding = {event="turnEnd", play={harm=1, range='self'}};

conditions.flamebarrier = {event="dmg", play={dmg=1, range='enemy'}, expire=999};
conditions.doubletap = {event="played_"..CTYPE_ATTACK, expire=999};
conditions.doubleheavytap = {event="played_"..CTYPE_ATTACK, expire=999, hidden=true};
conditions.doubleskill = {event="played_"..CTYPE_SKILL, expire=999};
conditions.doublepower = {event="played_"..CTYPE_POWER, expire=999};
conditions.doubleplay = {expire=999};
conditions.dmgmultiply = {event="turn", expire=999};
conditions.corruption	= {number=false, rewrite={ctype=CTYPE_SKILL, attrs={energy=0, exhaust=true}}};
conditions.candleblue	= {number=false, hidden=true, rewrite={ctype=CTYPE_CURSE, attrs={playable=null, harm=1, exhaust=true}}};
conditions.candlered	= {number=false, rewrite={ctype=CTYPE_STATUS,attrs={playable=null, exhaust=true}}};

conditions.rebound = {expire=999};
conditions.retainhand = {expire=1, hidden=true};

conditions.barricade = {event="turnEnd", number=false};
conditions.shieldup = {event="udmg", play={armor=1}, once=true};
conditions.entangled = {expire=1, expireAtEnd=true, debuff=true, hinted=true};
conditions.artifact = {event="condition"};
conditions.enrage = {event="enemy_played_"..CTYPE_SKILL, play={range='self', str=1}, number=false};
conditions.curiosity = {event="enemy_played_"..CTYPE_POWER, play={range='self', str=1}};
conditions.sporecloud = {event="death", play={vulnerable=1, range='enemies'}};
conditions.stealmoney = {event="played_"..CTYPE_ATTACK};




conditions.poison = {event="turn", expire=1, debuff=true, hinted=true};
-- conditions.enlightenment = {event="turn", expire=1, expireAtEnd=true};
conditions.panache = {event="played_cards_5", play={range='enemies', dmg=1}};
conditions.sadistic = {event="enemy_debuff", play={dmg=1, range="enemy"}};
conditions.sleep = {event="turn", expire=1, expireAtEnd=true};
conditions.regen = {event="turn", expire=1, play={heal=1}, expireAtEnd=true};
conditions.regenx = {event="turn", play={heal=1}, expireAtEnd=true};
conditions.lifelink = {event="turn", play={range="revive", heal=1}, hinted=true};
conditions.kaboom = {event="death", play={dmg=1, range="rnd"}}; -- dmgByAttrFromTarget
conditions.shift = {damageable=true, callback="onShift"};
conditions.shifted = {expire=1, hidden=true};
conditions.shiftAdd = {hidden=true};
conditions.intangible = {expire=1, hinted=true};
conditions.preventdmg = {};

conditions.untargetable = {expire=1, hinted=true};

conditions.udmgtoarmor = {event="udmg", play={tag="udmgtoarmor", range="self", nextTurn={range="self", armor=1}}};--armor per unblocked attack for next turn(couse now is enemy turn)
conditions.choke = {event="enemy_played_any", play={range="self", harm=1}, expire=999};

conditions.malleable = {event="udmg", play={range="self", armor=1}, expire=999};
conditions.malleableTurn = {event="turn", play={range="self", malleable=1}, hidden=true};
conditions.malleableRtn = {event="udmg", play={range="self", malleable=1}, hidden=true};

conditions.infiniteblades = {event="turn", play={range="self", addCards={hand={"Shiv"}}}};
conditions.noxiousfumes = {event="turn", play={range="enemies", poison=1}};
conditions.thousandcuts = {event="played_any", play={range="enemies", dmg=1, strX=0}};
conditions.afterimage = {event="played_any", play={range="self", armor=1}};
-- conditions.wraithform = {event="played_"..CTYPE_SKILL, play={range="rnd", dmg=1}};
conditions.accuracy = {}; -- dosent matter =)
conditions.envenom = {event="unblocked_dmg", play={range="enemy", poison=1}};
conditions.retaincards = {event="turn"};
conditions.toolsofthetrade = {event="turn", play={range="self", draw=1, onUse=onUseDiscardOne}};
conditions.confuse = {event="death", debuff=true, number=false};
conditions.potionless = {event="death", debuff=true, number=false};
conditions.lockon = {expire=1, hinted=true};

conditions.slow = {event="enemy_played_"..CTYPE_ATTACK, play={range='self', vulnerability=10}};
conditions.vulnerability = {expire=999999};

conditions.charm = {event="dmg", expire=1, debuff=true, play={range="self", tag="Charm", dmg=1}, hinted=true};
conditions.magicwall = {event="played_"..CTYPE_SKILL, play={range="self", armor=1}, expireAtEnd=true, expire=9999};
conditions.silenceskills = {event="death", expireAtEnd=true, expire=1};
conditions.drawondebuff = {event="debuff", play={draw=1, range="self"}};
conditions.discardstatuses = {event="turn", play={range='self', onUse={action="exhaust", target="hand", filter={"ctype", CTYPE_STATUS, true}, amount="rnd"}}};
conditions.abyssalscream = {event="dmg", play={range="enemy", charm=1}};
conditions.devilfriendship = {event="played_"..CTYPE_SKILL, play={range="rnd", charm=1}};
conditions.souleater = {event="kill", play={range="self", heal=1}};
conditions.supercharge = {event="dmg", play={range="self", energyAdd=1}};
conditions.oneversusall = {event="turn", play={range="enemies", armor=1}};
conditions.charmstorm = {event="turn", play={range="enemies", charm=1}};
conditions.charmmin = {event="turn", play={range="enemies", ifEnemy={condition="charm", val=0, play={range='enemy', charm=1}}}};
conditions.revive = {};
conditions.charmtoenergy = {event="turn", play={range="enemies", ifEnemy={condition="charm", play={range='enemy', energyAdd=1}}}};
conditions.charmtodmg = {event="turn", play={range="enemies", ifEnemy={condition="charm", play={range='enemy', dmg=1}}}};
conditions.charmdouble = {expire=999, expireAtEnd=true};
conditions.drawperenemy = {event="turn", play={range="enemies", draw=1}};
conditions.dread = {event="dmg", play={range="enemy", weak=1}};
conditions.cheapretainer = {};

conditions.burn = {event="burned", play={range="self", dmg=1}, hinted=true};
conditions.burningplates = {event="dmg", play={range="enemy", dmg=1, once={range="self", nextTurn={range="self", armor=1}}}, hinted=true};
conditions.flaming = {event="udmg", play={range="self", burn=1}, expire=999};
conditions.impskin = {event="played_"..CTYPE_SKILL, play={range="self", burningplates=1}, expire=999};
conditions.phoenix = {event="revived", play={range="self", addCards={hand={"Phoenix Wing"}}}};
conditions.ashmaker = {event="turn", play={range="self", onUse={action="transform", val="Ash", target="hand", skip=true, filter={"ctype", "all", false}}}};
conditions.simulation = {event="samecardinhand", play={range="self", str=1}};

conditions.manashield = {event="turnEnd", play={range="self", armorFromEnergyMax=1}, super=true};
conditions.armorpiercing = {super=true};