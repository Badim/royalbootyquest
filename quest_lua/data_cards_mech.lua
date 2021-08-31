-- mech
_G.pets = {}; -- rabbit fox sheep ram skelet_spider magic_camouflage giant_rat
pets.lightning ={event="turnEnd", scin="fox",	gfx="blast", passive={range="rnd", dmg=3, empowerDmgByTargetAttr="lockon", rangeEnemies="electrodynamics"}, active={range="rnd", dmg=8, empowerByTargetAttr="lockon", rangeEnemies="electrodynamics"}};
pets.frost = 	{event="turnEnd", scin="sheep", gfx="exp_blue", passive={range="owner", armorToTarget=2}, 		active={range="owner", armorToTarget=5}};
pets.shadow = 	{event="turnEnd", scin="ram", gfx="blood_drop", shadowcharge=6, passive={range="self", shadowcharge=6, empowerDmgByTargetAttr="lockon"}, 		active={range="minhp", dmgByAttrFromSource="shadowcharge", dtype=DTYPE_DIRECT, empowerDmgByTargetAttr="lockon"}};
pets.plasma = 	{event="turn", scin="rabbit", gfx="heal_weak", passive={range="owner", energyAdd=1},	active={range="owner", energyAdd=2}};
for attr,obj in pairs(pets) do 
	obj.tag = attr; 
	conditions["summoned_"..attr] = {hidden=true};
	
	-- if(options_debug~=true)then
		-- summoned_frost="Sheeps Summoned"
		-- summoned_lightning=""
		-- local txt = get_txt("summoned_VAL"):gsub("VAL", get_txt(obj.scin));
		-- language:addCurWord("summoned_lightning", get_txt("summoned_VAL"):gsub("VAL", get_txt(obj.scin)));
	-- end
end

conditions.petsmax = {hidden=true};
conditions.focus = {affecting={dmg=true, armorToTarget=true, shadowcharge=true}, hinted=true};
conditions.losingfocus = {event="turn", play={range="self", focus=-1}};
conditions.shadowcharge = {hidden=true};
conditions.storm = {event="played_"..CTYPE_POWER, play={pets={"lightning"}}};
conditions.prime = {event="add_pet", play={range="self", draw=1}};
conditions.repairing = {event="battle_won", play={range="self", heal=1}};
conditions.creativeai = {event="turn", play={range="self", create={count=1, attr="ctype", val=CTYPE_POWER}}};
conditions.staticdischarge = {event="udmg", play={range="self", pets={"lightning"}}};
conditions.helloworld = {event="turn", play={range="self", create={count=1, attr="rarity", val=1}}};
conditions.echoform = {event="turn", play={range="self", doubleplay=1}};
conditions.loop = {event="turn", play={range="self", evokePassive=1}};
conditions.electrodynamics = {number=false};

table.insert(cards, {tag="Cold Snap",		class="mech", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", pets={"frost"}, dmg=6, onUpgrade={dmg=9}});
table.insert(cards, {tag="Ball Lightning",	class="mech", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=7, pets={"lightning"}, onUpgrade={dmg=11}});
table.insert(cards, {tag="Beam Cell",		class="mech", rarity=1, ctype=CTYPE_ATTACK, energy=0, range="enemy", dmg=3, vulnerable=1, onUpgrade={dmg=4, vulnerable=2}});
table.insert(cards, {tag="Sweeping Beam",	class="mech", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemies", dmg=5, draw=1, onUpgrade={dmg=8}});-- Sweeping Beam	Common	Attack	1	Deal 5(8) damage to ALL enemies. Draw 1 card.
table.insert(cards, {tag="Streamline",		class="mech", rarity=1, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=15, onUpgrade={dmg=20}, onUse={action="minus", target="energy", val=1, min=0}}); -- Streamline	Common	Attack	2	Deal 15(20) damage. Whenever you play this card, reduce its cost by 1 for this combat.
table.insert(cards, {tag="Rebound",			class="mech", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=8, once={rebound=1, range='self'}, onUpgrade={dmg=11}}); -- Rebound	Common	Attack	1	Deal 8(11) damage. Place the next card you play this turn on top of your draw pile.
table.insert(cards, {tag="Barrage",			class="mech", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", onPet={onCount={range="enemy", dmg=4, dtype=DTYPE_DIRECT}}, onUpgrade={onPet={onCount={range="enemy", dmg=6, dtype=DTYPE_DIRECT}}}});-- Barrage	Common	Attack	1	Deal 4(6) damage for each Channeled Orb.
table.insert(cards, {tag="Compile Driver",	class="mech", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=7, onPet={onCount={draw=1}, unique=true}, onUpgrade={dmg=10}});-- Compile Driver	Common	Attack	1	Deal 7(10) damage. Draw 1 card for each unique Orb you have.

table.insert(cards, {tag="Go for the Eyes",	class="mech", rarity=2, ctype=CTYPE_ATTACK, energy=0, range='enemy', dmg=3, ifEnemy={intend="dmg", play={range="enemy", weak=1}}, onUpgrade={dmg=4, ifEnemy={intend="dmg", play={range="enemy", weak=2}}}});-- Go for the Eyes	Common	Attack	0	Deal 3(4) damage. If the enemy intends to attack, apply 1(2) Weak.
table.insert(cards, {tag="Blizzard",		class="mech", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemies", times=2, dmg=0, strX=0, dtype=DTYPE_DIRECT, dmgByAttrFromSource="summoned_frost", onUpgrade={times=3}}); -- Deal damage equal to 2(3) times the Frost Channeled this combat to ALL enemies
table.insert(cards, {tag="Claw",			class="mech", rarity=2,	ctype=CTYPE_ATTACK, energy=0, range="enemy", dmg=3, onUse={action="change", target="all", filter={"tag", "Claw", true}, addPick={dmg=2}, amount="all"}, onUpgrade={dmg=5}}); -- Deal 3(5) damage. All Claw cards deal 2 additional damage this combat.
table.insert(cards, {tag="Rip and Tear",	class="mech", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="rnd", times=2, dmg=7, onUpgrade={dmg=9}});-- Rip and Tear	Uncommon	Attack	1	Deal 7(9) damage to a random enemy 2 times.
table.insert(cards, {tag="Doom and Gloom",	class="mech", rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemies", once={pets={"shadow"}}, dmg=10, onUpgrade={dmg=14}});-- Doom and Gloom	Uncommon	Attack	2	Deal 10(14) damage to ALL enemies. Channel 1 Dark.
table.insert(cards, {tag="Melter",			class="mech", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=10, dmgByAttrFromTarget="armor", onUpgrade={dmg=14}});-- Melter	 "dmgByAttrFromTarget":"armor"Uncommon	Attack	1	Remove all Block from an enemy.Deal 10(14) damage.
table.insert(cards, {tag="Sunder",			class="mech", rarity=2, ctype=CTYPE_ATTACK, energy=3, range="enemy", dmg=24, onUpgrade={dmg=32}, ifEnemy={condition="dead", val=true, play={range="self", energyAdd=3}}});-- Sunder	Uncommon	Attack	3	Deal 24(32) damage.If this kills the enemy, gain 3 Energy.
table.insert(cards, {tag="FTL",				class="mech", rarity=2, ctype=CTYPE_ATTACK, energy=0, range="enemy", draw=1, dmg=5, onUpgrade={dmg=6}});-- FTL	Uncommon	Attack	0	Deal 5(6) damage. If you have played less than 3(4) cards this turn, draw 1 card.
table.insert(cards, {tag="Bullseye",		class="mech", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=8, lockon=2, onUpgrade={lockon=3, dmg=11}});-- Lock-On	Uncommon	Attack	1	Deal 8(10) damage. For the next 1(2) turns, Orbs do 50% more dmg.
table.insert(cards, {tag="Scrape",			class="mech", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=7, draw=3, onlyKeepZero=true, onUpgrade={dmg=9, draw=4}});-- Scrape	Uncommon	Attack	1	Deal 7(9) damage. Draw 3(4) cards. Discard all cards drawn this way that do not cost 0.

table.insert(cards, {tag="All For One",		class="mech", rarity=3, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=10, onUse={action="rehand", target="draw", filter={"energy", 0, true}, amount="all"}, onUpgrade={dmg=14}}); -- Deal 10(14) damage. Put all Cost 0 cards from your discard pile into your hand.
table.insert(cards, {tag="Meteor Strike",	class="mech", rarity=3, ctype=CTYPE_ATTACK, energy=5, range="enemy", dmg=24, pets={"plasma", "plasma", "plasma"}, onUpgrade={dmg=30}});-- Meteor Strike	Rare	Attack	5	Deal 24(30) damage. Channel 3 Plasma.
table.insert(cards, {tag="Hyperbeam",		class="mech", rarity=3, ctype=CTYPE_ATTACK, energy=2, range="enemies", dmg=25, once={focus=-3, range="self"}, onUpgrade={dmg=32}});-- Hyperbeam	Rare	Attack	2	Deal 25(32) damage to ALL enemies. Lose 3 Focus.
table.insert(cards, {tag="Thunder Strike",	class="mech", rarity=3, ctype=CTYPE_ATTACK, energy=3, range="rnd", dmg=0, strX=0, times=7, dtype=DTYPE_DIRECT, dmgByAttrFromSource="summoned_lightning", onUpgrade={times=9}});-- Thunder Strike	Rare	Attack	3	Deal 7(9) damage to a random enemy for each Lightning Channeled this combat.
-- table.insert(cards, {tag="Nova",			class="mech", rarity=3, ctype=CTYPE_ATTACK, energy=3, range="rnd", dmg=0, strX=0, times=3, dtype=DTYPE_DIRECT, dmgByAttrFromSource="cards_game_3", onUpgrade={times=4}});--Nova	Rare	Attack	1	Deal damage to ALL enemies equal to 3(4) times the number of Powers played this combat.
table.insert(cards, {tag="Core Surge",		class="mech", rarity=3, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=11, once={range="self", artifact=1}, exhaust=true, onUpgrade={dmg=15}});

table.insert(cards, {tag="Turbo",			class="mech", rarity=1,	ctype=CTYPE_SKILL, energy=0, range="self", energyAdd=2, addCards={draw={"Void"}}, onUpgrade={energyAdd=3}}); -- Turbo	Common	Skill	0	Gain 2(3) Energy. Add a Void into your discard pile.
-- table.insert(cards, {tag="Clone",			class="mech", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", 	petsCloneFirst=1, onUpgrade={energy=0}});
table.insert(cards, {tag="Chill",			class="mech", rarity=1, ctype=CTYPE_SKILL, energy=0, range="enemies", pets={"frost"}, exhaust=true, onUpgrade={innate=true}});
table.insert(cards, {tag="Skim",			class="mech", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", draw=3, onUpgrade={draw=4}});
table.insert(cards, {tag="Zap",				class="mech", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", pets={"lightning"}, onUpgrade={energy=0}});
table.insert(cards, {tag="Chaos",			class="mech", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", pets={"random"}, onUpgrade={pets={"random", "random"}}});
table.insert(cards, {tag="Charge Battery",	class="mech", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", armor=7, onUpgrade={armor=10}, nextTurn={range='self', energyAdd=1}}); -- Charge Battery	Uncommon	Skill	1	Gain 7(10) Block. Next turn, gain 1 Energy.
table.insert(cards, {tag="Leap",			class="mech", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", armor=9, onUpgrade={armor=12}});-- Leap	Common	Skill	1	Gain 9(12) Block.
table.insert(cards, {tag="Hologram",		class="mech", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", armor=3, exhaust=true, onUse={action="rehand", target="draw", filter={"ctype", "all", false}}, onUpgrade={armor=5, exhaust=null}});-- Hologram	Common	Skill	1	Gain 3(5) Block. Return a card from your discard pile to your hand. Exhaust (does not Exhaust).
table.insert(cards, {tag="Coolheaded",		class="mech", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", draw=1, pets={"frost"}, onUpgrade={draw=2}});-- Coolheaded	Common	Skill	1	Channel 1 Frost. Draw 1(2) card(s).
table.insert(cards, {tag="Steam Barrier",	class="mech", rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", armor=6, onUpgrade={armor=8}, onUse={action="minus", target="armor", val=1, min=0}});--Steam Barrier	Gain 6 Block. Decrease this card's Block by 1 this combat.
table.insert(cards, {tag="Stack",			class="mech", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", armor=0, armorFromDraw=1, onUpgrade={armor=3}});-- Stack	Common	Skill	1	Gain Block equal to the number of cards in your discard pile (+3).
table.insert(cards, {tag="Dualcast",		class="mech", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", evoke=2, onUpgrade={energy=0}});-- Dualcast	Basic	Skill	1(0)	Evoke your next Orb 2 times.

table.insert(cards, {tag="Aggregate",		class="mech", rarity=2,	ctype=CTYPE_SKILL, energy=1, range="self", deckToEnergy=6, onUpgrade={deckToEnergy=5}}); --	Gain 1 Energy for every 6(5) cards in your draw pile.
table.insert(cards, {tag="Reinforced Body",	class="mech", rarity=2, ctype=CTYPE_SKILL, energy=X, range="self", armor=7, onUpgrade={armor=9}}); -- Reinforced Body	Uncommon	Skill	X	Gain 7(9) Block X times.
table.insert(cards, {tag="Auto-Shields",	class="mech", rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", ifEnemy={condition="armor", val=0, play={range='self', armor=11}}, onUpgrade={ifEnemy={condition="armor", val=0, play={range='self', armor=15}}}});
table.insert(cards, {tag="Consume",			class="mech", rarity=2, ctype=CTYPE_SKILL, energy=2, range="self", focus=2, petsmax=-1, onUpgrade={focus=3}}); -- Consume	 Uncommon	Skill	2	Gain 2(3) Focus. Lose 1 Orb Slot.
table.insert(cards, {tag="Tempest",			class="mech", rarity=2, ctype=CTYPE_SKILL, energy=X, range="self", pets={"lightning"}, exhaust=true, onUpgrade={extraX=1}});-- Tempest	Uncommon	Skill	X	Channel X (X+1) Lightning. Exhaust.
table.insert(cards, {tag="White Noise",		class="mech", rarity=2,	ctype=CTYPE_SKILL, energy=1, range="self", exhaust=true, create={count=1, attr="ctype", val=CTYPE_POWER, energyTemp=0}, onUpgrade={energy=0}}); -- White Noise	Uncommon	Skill	1(0)	Add a random Power to your hand. It costs 0 this turn. Exhaust.
table.insert(cards, {tag="Boot Sequence",	class="mech", rarity=2, ctype=CTYPE_SKILL, energy=0, range="self", armor=10, innate=true, exhaust=true, onUpgrade={armor=13}});
table.insert(cards, {tag="Glacier",			class="mech", rarity=2, ctype=CTYPE_SKILL, energy=2, range="self", armor=9, pets={"frost", "frost"}, onUpgrade={armor=12}});-- Glacier	Uncommon	Skill	2	Gain 9(12) Block. Channel 2 Frost.
table.insert(cards, {tag="Darkness",		class="mech", rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", pets={"shadow"}, onUpgrade={pets={"shadow", "shadow"}}});-- Darkness	Uncommon	Skill	1	Channel 1(2) Dark.
table.insert(cards, {tag="Force Field",		class="mech", rarity=2, ctype=CTYPE_SKILL, energy=4, range="self", discount="played_ctype3", armor=12, onUpgrade={armor=16}}); -- Uncommon	Skill	4	Costs 1 less Energy for each Power card played this combat. Gain 12(16) Block.
table.insert(cards, {tag="Overclock",		class="mech", rarity=2, ctype=CTYPE_SKILL, energy=0, range="self", draw=2, addCards={draw={"Burn"}}, onUpgrade={draw=3}});--Steam Power	Uncommon	Skill	0	Draw 2(3) cards. Add a Burn into your discard pile.
table.insert(cards, {tag="Genetic Algorithm",class="mech",rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", armor=1, exhaust=true, onUse={action="plus", target="armor", val=2, permanent=true}, onUpgrade={onUse={action="plus", target="armor", val=3, permanent=true}}});-- Genetic Algorithm	Uncommon	Skill	1	Gain 1 Block. When played, permanently increase this card's Block by 2(3). Exhaust.
table.insert(cards, {tag="Equilibrium",		class="mech", rarity=2, ctype=CTYPE_SKILL, energy=2, range="self", armor=13, retainhand=1, onUpgrade={armor=16}});-- Equilibrium Uncommon 2 Gain 13 Block. Retain your hand this turn.
table.insert(cards, {tag="Recycle",			class="mech", rarity=2, ctype=CTYPE_SKILL, range='self', energy=1, onUse={action="exhaust", target="hand", filter={"ctype", "all", false}, amount=1, refund=true}, onUpgrade={energy=0}});-- Recycle	Uncommon	Skill	1(0)	Exhaust a card. Gain Energy equal to its cost.
table.insert(cards, {tag="Double Energy",	class="mech", rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", energyMlt=2, exhaust=true, onUpgrade={energy=0}});--Double Energy	Uncommon	Skill	1(0)	Double your Energy. Exhaust.

table.insert(cards, {tag="Reprogram",		class="mech", rarity=2, ctype=CTYPE_SKILL, energy=0, range="self", peek=4, onUpgrade={peek=6}});-- Reprogram Uncommon	Skill	0	Look at the top 4(6) cards of your draw pile. You may discard any of them.

table.insert(cards, {tag="Amplify",			class="mech", rarity=3, ctype=CTYPE_SKILL, energy=1, range="self", doublepower=1, onUpgrade={doublepower=2}}); -- Amplify	Rare	Skill	1	This turn, your next (1(2)) Power(s) is (are) played twice.
table.insert(cards, {tag="Fusion",			class="mech", rarity=3, ctype=CTYPE_SKILL, energy=2, range="self", pets={"plasma"}, onUpgrade={energy=1}});
table.insert(cards, {tag="Rainbow",			class="mech", rarity=3, ctype=CTYPE_SKILL, energy=2, range="self", pets={"lightning", "frost", "shadow"}, exhaust=true, onUpgrade={exhaust=null}}); -- Rainbow	Rare	Skill	2	Channel 1 Lightning, 1 Frost, and 1 Dark. Exhaust. (does not Exhaust.)
table.insert(cards, {tag="Seek",			class="mech", rarity=3,	ctype=CTYPE_SKILL, energy=0, range="self", exhaust=true, onUse={action="rehand", target="deck", filter={"ctype", "all", false}, amount=1}, onUpgrade={onUse={action="rehand", target="deck", filter={"ctype", "all", false}, amount=2}}});--Seek	Rare	Skill	0	Choose a (2) card(s) from your draw pile and place it (them) into your hand. Exhaust.
table.insert(cards, {tag="Multi-Cast",		class="mech", rarity=3, ctype=CTYPE_SKILL, energy=X, range="self", evoke=1, onUpgrade={extraX=1}});-- Multi-Cast	Rare	Skill	X	Evoke your next Orb X (X+1) times.
table.insert(cards, {tag="Recursion",		class="mech", rarity=3, ctype=CTYPE_SKILL, energy=1, range="self", evoke=1, evokeReSummon=true, onUpgrade={energy=0}});-- Recursion	Rare	Skill	1(0)	Evoke your next Orb.Channel the Orb that was just Evoked.
table.insert(cards, {tag="Reboot",			class="mech", rarity=3, ctype=CTYPE_SKILL, energy=0, range="self", exhaust=true, onUse=onUseDiscardAllCards, after={draw=4}, onUpgrade={after={draw=6}}});--Reboot	Rare	Skill	0	Shuffle all of your cards into your draw pile, then draw 5(7) cards. Exhaust.
table.insert(cards, {tag="Fission",			class="mech", rarity=3, ctype=CTYPE_SKILL, energy=3, range="self", onPet={onCount={draw=1, energyAdd=1, range="self"}, evoke=true}, exhaust=true, onUpgrade={energy=0}});-- Fission	Rare	Skill	2(1) Evoke all your Orbs. Gain BlueEnergy and draw 1 card for each Orb Evoked.Exhaust.

table.insert(cards, {tag="Defragment",		class="mech", rarity=1, ctype=CTYPE_POWER, energy=1, range="self", focus=1, onUpgrade={focus=2}});
table.insert(cards, {tag="Capacitor",		class="mech", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", petsmax=2, onUpgrade={petsmax=3}});
table.insert(cards, {tag="Storm",			class="mech", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", storm=1, onUpgrade={innate=true}});-- Storm	Uncommon	Power	1	(Innate.)Whenever you play a Power, Channel 1 Lightning.
table.insert(cards, {tag="Heatsinks",		class="mech", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", drawonpower=1, onUpgrade={drawonpower=2}});-- Heatsinks	Uncommon	Power	1	Whenever you play a Power card, draw 1(2) card(s).
table.insert(cards, {tag="Self Repair",		class="mech", rarity=1, ctype=CTYPE_POWER, energy=1, range="self", repairing=7, onUpgrade={repairing=10}});-- Self Repair	Uncommon	Power	1	At the end of combat, heal 7(10) HP.
table.insert(cards, {tag="Static Discharge",class="mech", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", staticdischarge=1, onUpgrade={staticdischarge=2}});-- Static Discharge	Uncommon	Power	1	Whenever you take attack damage, Channel 1(2) Lightning.
table.insert(cards, {tag="Hello World",		class="mech", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", helloworld=1, onUpgrade={innate=true}});-- Hello World	Uncommon	Power	1	(Innate.) At the start of your turn, add a random Common card into your hand.
table.insert(cards, {tag="Loop",			class="mech", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", loop=1, onUpgrade={loop=2}});-- Loop	Uncommon	Power	2(1)	At the start of your turn, use the passive ability of your next Orb.
table.insert(cards, {tag="Biased Cognition",class="mech", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", focus=4, losingfocus=1, onUpgrade={focus=5}}); -- Gain 4(5) Focus.At the start of each turn, lose 1 Focus.
table.insert(cards, {tag="Buffer", 			class="mech", rarity=3, ctype=CTYPE_POWER, energy=2, range="self", preventdmg=1, onUpgrade={preventdmg=2}}); -- Prevent the next (1(2)) time(s) you would lose HP.
-- table.insert(cards, {tag="Prime",			class="mech", rarity=3, ctype=CTYPE_POWER, energy=2, range="self", prime=1, onUpgrade={energy=1}});-- Prime	Rare	Power	2(1)	Whenever you Channel an Orb, draw 1 card.
table.insert(cards, {tag="Machine Learning",class="mech", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", drawpower=1, onUpgrade={innate=true}});-- Machine Learning	Rare	Power	1	(Innate.) Draw 1 additional card at the start of each turn.
table.insert(cards, {tag="Creative AI",		class="mech", rarity=3, ctype=CTYPE_POWER, energy=3, range="self", creativeai=1, onUpgrade={energy=2}});-- Creative AI	Rare	Power	3(2)	At the start of each turn, add a random Power card to your hand.
table.insert(cards, {tag="Echo Form",		class="mech", rarity=3, ctype=CTYPE_POWER, energy=3, range="self", ethereal=true, echoform=1, onUpgrade={ethereal=null}});-- Echo Form	Rare	Power	3	The first card you play each turn is played twice.Ethereal. (not Ethereal.)
table.insert(cards, {tag="Electrodynamics",	class="mech", rarity=3, ctype=CTYPE_POWER, energy=2, range="self", electrodynamics=1, pets={"lightning", "lightning"}, onUpgrade={pets={"lightning", "lightning", "lightning"}}}); -- Electrodynamics 2 Rare Lightning now hits ALL enemies. Channel 2(3) Lightning.