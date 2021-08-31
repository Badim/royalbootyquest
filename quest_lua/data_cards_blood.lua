conditions.battlefervor = {event="turnEnd", event2="battle_won", play={range="self", heal=1}, expire=99, hinted=true, expireAtEnd=true, target="source"};

conditions.battlefervor1 = {event="dmg", play={range="self", battlefervor=1}, hidden=true};
conditions.battlefervor2 = {event="played_"..CTYPE_ATTACK, play={range="self", battlefervor=1}, hidden=true};
conditions.ignoreHarm = {expire=1, hinted=false, expireAtEnd=true};

-- I meant it might be nice to have s card which makes BF not go away (for 1 turn) at the end of turn"
-- Suggestion: "Discard your hand, get 4(6) BF per card discarded"-- Similar to this card. (ebergy = 2)

-- fun channel
-- Можете добавить специальный скин на кровавого мага и специальную вкладку для этого? Когда скин включен изменяется стартовая реликвия на банка чёрной крови эта реликвия делает что бы когда играешь карту которая даёт bf наносит 1 урона случайному врагу (это моя фантазия)


-- conditions.draining = {event="turn", play={drained=1, range='self'}, expire=99, hinted=true};
-- conditions.drained = {expire=1};
conditions.voidwind = {event="played_"..CTYPE_SKILL, play={range="enemies", dmg=1}};
conditions.ritualist = {event="played_"..CTYPE_SKILL, play={range="self", battlefervor=1}, expire=99};
conditions.wickedcircle = {event="harm", play={vulnerable=1, range='rnd'}};
conditions.lacrimarium = {event="turn", play={harm=1, energyAdd=1}};
conditions.liquidlies = {event="played_"..CTYPE_ATTACK, play={battlefervor=1}};
conditions.gardenofstones = {event="played_"..CTYPE_ATTACK, play={armor=1}};
conditions.scardiary = {event="turn", play={onUse={action="upgrade", target="hand", filter={"ctype", "all", false}, amount="rnd"}}};
conditions.thequietroom = {event="exhausted", play={battlefervor=1, range='self'}};
conditions.thornmail = {event="harm", play={dmg=1, range='enemies'}};
-- conditions.seaofsins = {event="turn", play={range="enemies", ifEnemy={condition="drained", play={range='enemy', dmg=1}}}};
conditions.thedarkhalf = {event="turn", play={range="self", ifEnemy={hpLess=50, play={range="self", battlefervor=1}}}};
conditions.absorption = {event="debuff", play={range="self", battlefervor=1}};

table.insert(cards, {tag="Unleashed Pain",	class="blood", rarity=0, ctype=CTYPE_ATTACK, energy=0, range="enemy", dmg=4, onUpgrade={dmg=6}, battlefervor=1});
table.insert(cards, {tag="Ignite",			class="blood", rarity=1, ctype=CTYPE_ATTACK, energy=0, range="enemy", dmg=12, onUpgrade={dmg=16}, once={range="self", nulify="battlefervor"}});
table.insert(cards, {tag="Dripping Red",	class="blood", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", harm=1, dmg=10, onUpgrade={dmg=14}});
-- table.insert(cards, {tag="Kinslayer",		class="blood", rarity=1, ctype=CTYPE_ATTACK, energy=X, range="enemy", harm=1, dmg=6, onUpgrade={dmg=9}}); -- Bleed Well is same, wtf?
table.insert(cards, {tag="Bleed Well",		class="blood", rarity=1, ctype=CTYPE_ATTACK, energy=X, range="enemy", harm=1, dmg=7, onUpgrade={dmg=9}});
table.insert(cards, {tag="Spilling Blood",	class="blood", rarity=1, ctype=CTYPE_ATTACK, energy=0, range="enemies", dmg=7, onUpgrade={dmg=10}, harm=2});--once={range="self", harm=2}
table.insert(cards, {tag="Hardened Claws",	class="blood", rarity=1, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=8, draw=1, onUpgrade={dmg=10, draw=2}});
table.insert(cards, {tag="Razor Dance",		class="blood", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", times=2, dmg=4, onUpgrade={times=3}, dmgByAttrFromSource="card_type_1_played"});
table.insert(cards, {tag="Abhorrent Blade",	class="blood", rarity=1, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=18, onUpgrade={dmg=26}, battlefervor=2});
table.insert(cards, {tag="Sorrow Remains",	class="blood", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", hand={action="discard", ctype=CTYPE_ATTACK, value=true, onCount={dmg=8, battlefervor=1}}, onUpgrade={hand={action="discard", ctype=CTYPE_ATTACK, value=true, onCount={dmg=10, battlefervor=1}}}});
table.insert(cards, {tag="Scream Silence",	class="blood", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=9, onUpgrade={dmg=12}, onUse={action="redeck", target="this", to="deck"}});-- Deal 9(10) damage. If enemy HP becomes < 50% after that, return card to draw pile
table.insert(cards, {tag="Devourer Paradise",class="blood",rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemies", dmg=9, onUpgrade={dmg=12}, nulify="battlefervor" });

table.insert(cards, {tag="Death Adventure",	class="blood", rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=14, onUpgrade={dmg=16}, battlefervor=1});
table.insert(cards, {tag="Pallid Reflection",class="blood",rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=6, getAddDmgByAttr={list="hand", attr="ctype", val=CTYPE_ATTACK, dmg=3}, onUpgrade={energy=1, getAddDmgByAttr={list="hand", attr="ctype", val=CTYPE_ATTACK, dmg=5}}});
-- table.insert(cards, {tag="Crawling Fear",	class="blood", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=5, onUpgrade={dmg=8}, once={range="self", ifEnemy={condition="battlefervor", play={energyAdd=1, draw=1, range='self'}}}});
table.insert(cards, {tag="Blood Oasis",		class="blood", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", harm=1, dmg=15, onUpgrade={dmg=18}, onUse={action="plus", target="harm", val=1}});
table.insert(cards, {tag="Corrupted Claws",	class="blood", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=5, onUpgrade={dmg=9}, battlefervor=2});
table.insert(cards, {tag="Blood and Chaos",	class="blood", rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemies", harm=3, dmg=6, onUpgrade={energy=1, dmg=8}, battlefervor=1});
table.insert(cards, {tag="Shadow Assault",	class="blood", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", harm=2, dmg=13, onUpgrade={dmg=17}, drawless=1});-- Deal 13(15) damage. Lose 2 HP. Next turn gain -1 Energy
table.insert(cards, {tag="Filthy Secret",	class="blood", rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemies", dmg=7, onUpgrade={dmg=10}, battlefervor=1});
table.insert(cards, {tag="Spineless",		class="blood", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=9, onUpgrade={dmg=12}, onUse={action="change", target="hand", filter={"ctype", CTYPE_ATTACK, true}, changePick={energyTemp=0}, amount="all"}});-- Deal 9(12) damage. All Attacks this turn cost you 0 HP
table.insert(cards, {tag="Shroud of Darkness",class="blood",rarity=2,ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=11, onUpgrade={dmg=15}, onUse={action="rehand", target="deck", filter={"ctype", CTYPE_ATTACK, true}, changePick={energyTemp=0}}});-- Deal 11(15) damage. Draw Attack card after and play for 0 Energy
table.insert(cards, {tag="Blades Prison",	class="blood", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", harm=2, dmg=9, vulnerable=2, onUpgrade={dmg=12, vulnerable=3}});-- Deal 9(12) damage. Apply Vulnerable for 2(3) turns. Lose 2 HP
table.insert(cards, {tag="Curtain Call",	class="blood", rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemy", hand={action="discard", ctype="all", value=false, onCount={dmg=10}}, 
	onUpgrade={hand={action="discard", ctype="all", value=false, onCount={dmg=12}}, exhaust=false}, exhaust=true});--Discard all cards. Deal 10(12) damage for each card	exhaust	
	
table.insert(cards, {tag="Biocage",			class="blood", rarity=3, ctype=CTYPE_ATTACK, energy=3, range="enemy", harm=6, dmg=40, onUpgrade={dmg=50}, exhaust=true});
table.insert(cards, {tag="Natural Selection",class="blood",rarity=3, ctype=CTYPE_ATTACK, energy=0, range="enemy", battlefervor=2, dmg=4, onUpgrade={dmg=6}, onUse={action="plus", target="battlefervor", val=1}});-- Deal 3(+1) damage. +1 Upgrade for this combat. Can be upgraded any number of times
-- table.insert(cards, {tag="Night Victim",	class="blood", rarity=3, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=10, times=1, onUpgrade={times=2}, once={range="self", ifEnemy={condition="battlefervor", more=2, play={range="enemy", dmg=10}}}});
table.insert(cards, {tag="Rotting Misery",	class="blood", rarity=3, ctype=CTYPE_ATTACK, energy=2, range="enemy", battlefervor=4, dmg=10, onUpgrade={energy=1, dmg=12}, onUse={action="minus", target="battlefervor", val=1, min=1}});

table.insert(cards, {tag="Killer Instinct",	class="blood", rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", ignore="battlefervor", str=3, strNext=-3, onUpgrade={str=5, strNext=-5}});--This turn your Attacks do NOT restore HP, but deal +2(+3) damage
table.insert(cards, {tag="Succumb",			class="blood", rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", battlefervor=2, onUpgrade={battlefervor=3}, onUse=onUseDiscardOne});
table.insert(cards, {tag="Intermission",	class="blood", rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", battlefervor=1, onUpgrade={battlefervor=2}});
table.insert(cards, {tag="Rotten Soil",		class="blood", rarity=1, ctype=CTYPE_SKILL, energy=1, range="enemy", harm=1, weak=2, onUpgrade={weak=3}});
table.insert(cards, {tag="Devotion",		class="blood", rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", energyAdd=1, onUpgrade={energyAdd=2}, onUse=onUseDiscardOne});--Discard card, gain 1(2) Energy
table.insert(cards, {tag="Dark Offering",	class="blood", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", armor=12, harm=3, onUpgrade={harm=2, armor=15}});--Gain 10(12) Block, lose 3(2) HP
table.insert(cards, {tag="Incarnation",		class="blood", rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", harm=3, onUpgrade={harm=2}, onUse=onUseRedeck});-- Lose 3(2) HP, select card from your discard pile
table.insert(cards, {tag="Trickster",		class="blood", rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", harm=1, draw=1, onUpgrade={draw=2}});-- Lose 1 HP, draw 1(2) card
table.insert(cards, {tag="Food for Soul",	class="blood", rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", nulify="battlefervor", energyAdd=1, onUpgrade={energyAdd=2}});
table.insert(cards, {tag="Evil Eye",		class="blood", rarity=1, ctype=CTYPE_SKILL, energy=0, range="enemy", harm=2, vulnerable=2, onUpgrade={vulnerable=3}});
table.insert(cards, {tag="Scorched Skin",	class="blood", rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", harm=1, armor=8, onUpgrade={armor=12}});

table.insert(cards, {tag="Consume Rage",	class="blood", rarity=2, ctype=CTYPE_SKILL, energy=2, range="self", battlefervorMlt=2, onUpgrade={energy=1}, exhaust=true});
table.insert(cards, {tag="Ethereal Shuffle",class="blood", rarity=2, ctype=CTYPE_SKILL, energy=0, range="self", harm=3, dmgmultiply=2, onUpgrade={dmgmultiply=3}});-- Lose 1 HP, this turn, your next Attack played twice(thrice)
table.insert(cards, {tag="Decaying Flesh",	class="blood", rarity=2, ctype=CTYPE_SKILL, energy=0, range="enemies", weak=1, onUpgrade={weak=2}, once={range="self", harm=2}});--Apply 1(2) Weak to ALL enemies. Lose 3(2) HP
table.insert(cards, {tag="Ghost Blades",	class="blood", rarity=2, ctype=CTYPE_SKILL, energy=1, range="enemy", dmg=12, onUpgrade={dmg=15}, nulify="armor", battlefervor=1});--This turn your Attacks ignores enemy Block	exhaust	
table.insert(cards, {tag="Crystallization",	class="blood", rarity=2, ctype=CTYPE_SKILL, energy=0, range="self", frail=1, str=3, strNext=-2, onUpgrade={str=4, strNext=-3}});--Apply 1 Frail on YOURSELF. All Attack this turn deal +2(+3) damage
table.insert(cards, {tag="Void Pact",		class="blood", rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", ignoreHarm=1, onUpgrade={energy=0}});--For this turn you do NOT lose HP from your Attacks and Skills
table.insert(cards, {tag="That Enough",		class="blood", rarity=2, ctype=CTYPE_SKILL, energy=0, range="enemy", dmgByAttrFromSource="battlefervor", times=2, onUpgrade={times=3}});
-- table.insert(cards, {tag="Knowing of Limits",class="blood",rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", ignore="nulify", onUpgrade={energy=0}}); -- ignore="nulify" не работает
table.insert(cards, {tag="Harsh Lesson",	class="blood", rarity=2, ctype=CTYPE_SKILL, energy=1, range="enemy", ifEnemy={intend="dmg", play={range="self", dex=2}}, onUpgrade={ifEnemy={intend="dmg", play={range="self", dex=3}}}});--For this turn when you lose HP from enemy Attack gain +1(+2) Dexterity
table.insert(cards, {tag="Pain and Gain",	class="blood", rarity=2, ctype=CTYPE_SKILL, energy=0, range="self", harm=3, energyAdd=2, onUpgrade={harm=2, energyAdd=3}});--Gain 2(3) Energy, lose 3(2) HP

table.insert(cards, {tag="Get Over Here",	class="blood", rarity=3, ctype=CTYPE_SKILL, energy=0, range="enemy", dmgByAttrFromSource="battlefervor", times=3, onUpgrade={times=4}, exhaust=true, nulify="battlefervor"});
table.insert(cards, {tag="Ritualist",		class="blood", rarity=3, ctype=CTYPE_SKILL, energy=1, range="self", ritualist=1, onUpgrade={ritualist=2}});--Whenever you play a Skill this turn, gain 1(2) HP
table.insert(cards, {tag="Battle Focus",	class="blood", rarity=3, ctype=CTYPE_SKILL, energy=0, range="self", draw=1, ifDraw={ctype=CTYPE_SKILL, range='self', battlefervor=2}, onUpgrade={ifDraw={ctype=CTYPE_SKILL, range='self', battlefervor=3}}});--Draw a card. If the card is a Attack gain 1(2) HP
-- table.insert(cards, {tag="Evasive Maneuvers",class="blood",rarity=2, ctype=CTYPE_SKILL, energy=1, onUpgrade={energy=0}});--If you not lose HP from Attacks this turn, next turn draw +2(3) Attack cards
table.insert(cards, {tag="Void Armor",		class="blood", rarity=3, ctype=CTYPE_SKILL, energy=2, range="self", armor=15, hand={action="discard", ctype='all', value=false}, onUpgrade={armor=20}});--Discard all cards from hand, Gain 15(20) Block
table.insert(cards, {tag="Undying Rage",	class="blood", rarity=3, ctype=CTYPE_SKILL, energy=2, range="self", onUpgrade={energy=1}, intangible=1, exhaust=true});--You CAN'T DIE this turn.	exhaust	
table.insert(cards, {tag="Cleanse",			class="blood", rarity=3, ctype=CTYPE_SKILL, energy=1, range="self", cleanse=true, harm=5, onUpgrade={energy=0}, exhaust=true});-- Lose 5 HP, remove all debufs from self	exhaust	
table.insert(cards, {tag="Immaculate",		class="blood", rarity=3, ctype=CTYPE_SKILL, energy=2, range="self", onUse={action="change", target="hand", filter={"ctype", CTYPE_SKILL, true}, changePick={energyTemp=0}, amount="all"}, onUpgrade={energy=1}});--All Skill cards played this turn cost 0
-- table.insert(cards, {tag="Reinforce",		class="blood", rarity=3, ctype=CTYPE_SKILL, energy=2, onUpgrade={energy=1}});--On next turn, your Blocks that you cast will be doubled
-- table.insert(cards, {tag="Overpower",		class="blood", rarity=3, ctype=CTYPE_SKILL, energy=1, onUpgrade={energy=0}});-- For this turn, gain Strenght equal your missing HP. Lose this Strenght after	exhaust	


table.insert(cards, {tag="Void Wind",		class="blood", rarity=2, ctype=CTYPE_POWER, energy=2, range="self", voidwind=2, onUpgrade={voidwind=3}});
table.insert(cards, {tag="Wicked Circle",	class="blood", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", wickedcircle=1, onUpgrade={wickedcircle=2}});
table.insert(cards, {tag="Lacrimarium",		class="blood", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", lacrimarium=1, onUpgrade={energy=0}});
table.insert(cards, {tag="The Dark Half",	class="blood", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", thedarkhalf=1, onUpgrade={thedarkhalf=2}});
table.insert(cards, {tag="Liquid Lies",		class="blood", rarity=2, ctype=CTYPE_POWER, energy=2, range="self", liquidlies=1, onUpgrade={energy=1}});
table.insert(cards, {tag="Garden of Stones",class="blood", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", gardenofstones=2, onUpgrade={energy=0, gardenofstones=3}});
table.insert(cards, {tag="Scar Diary",		class="blood", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", scardiary=1, onUpgrade={energy=0}});
-- table.insert(cards, {tag="Umbral Blades",	class="blood", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", onUpgrade={energy=0}});--At the start of your turn discard all Block cards, draw random Attack card for each
table.insert(cards, {tag="Dying Embers",	class="blood", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", brutality=1, onUpgrade={energy=0}});
table.insert(cards, {tag="The Quiet Room",	class="blood", rarity=2, ctype=CTYPE_POWER, energy=2, range="self", thequietroom=4, onUpgrade={innate=true}});
table.insert(cards, {tag="Thornmail",		class="blood", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", thornmail=3, onUpgrade={innate=true}});
-- table.insert(cards, {tag="Equilibrium",		class="blood", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", onUpgrade={energy=0}});--At the start of your turn, select 1 card from discard pile. Lose 1 HP for this
-- table.insert(cards, {tag="Ethereal chains",	class="blood", rarity=3, ctype=CTYPE_POWER, energy=3, range="self", onUpgrade={energy=2}});--You no longer discard your hand at the end of the turn. 
-- table.insert(cards, {tag="Sea of Sins",		class="blood", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", seaofsins=2, onUpgrade={seaofsins=3}});
table.insert(cards, {tag="Absorption",		class="blood", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", absorption=2, onUpgrade={absorption=3}});-- For this turn for each Debuff casted on you, gain 1(2) HP