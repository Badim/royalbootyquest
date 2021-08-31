-- table.insert(heroes, {tag="Warrior",	class="red"});
-- table.insert(heroes, {tag="Silencer",	class="green"});

--range = melee, ranged, self, ally, team, all
-- strX - str modificator (default 1)
-- draw - draw extra X card(s)
-- types 1-attack, 2-skill, 3-power
_G.CTYPE_ATTACK=1;
_G.CTYPE_SKILL=2;
_G.CTYPE_POWER=3;
_G.CTYPE_STATUS=4;
_G.CTYPE_CURSE=5;

_G.DTYPE_NORMAL=nil;
_G.DTYPE_TRUE=2; -- ignoring armor & weak
_G.DTYPE_DIRECT=3; -- ignoring weak
_G.card_counter=1; -- for messages in-battle

-- rarity = 0/1/2/3

-- wounds to self deck, to self hand, to enemy deck, to enemy draw
-- feedback={woundDeck, woundHand, woundDraw, vulnerable}
-- 58/75
x = "x";
X = "x";
_G.null = "null";
onUseDiscardRnd={action="discard", target="hand", filter={"ctype", "all", false}, amount="rnd"};
onUseDiscardOne={action="discard", target="hand", filter={"ctype", "all", false}, amount=1};
onUseDiscardTwo={action="discard", target="hand", filter={"ctype", "all", false}, amount=2};
onUseDiscardThree={action="discard", target="hand", filter={"ctype", "all", false}, amount=3};
onUseDiscardAllCards={action="discard", target="all", filter={"ctype", "all", false}, amount="all"};
onUseRedeck={action="redeck", target="draw", filter={"ctype", "all", false}};

-- onUse={action="discard", target="all", filter={"ctype", "all", false}, amount="all"}

table.insert(cards, {tag="Strike",		class="any", rarity=0, ctype=CTYPE_ATTACK, range='enemy', dmg=6, armor=0, strX=1, poison=0, energy=1, onUpgrade={dmg=9}});
table.insert(cards, {tag="Bash",		class="red", rarity=0, ctype=CTYPE_ATTACK, range='enemy', dmg=8, vulnerable=2, poison=0, energy=2});
table.insert(cards, {tag="Heavy Blade",	class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=14, strX=3, energy=2});
table.insert(cards, {tag="Cleave",		class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemies', dmg=8, energy=1, onUpgrade = {dmg=11}});
table.insert(cards, {tag="Clothesline",	class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=12, weak=2, energy=2});
table.insert(cards, {tag="Iron Wave",	class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=5, armor=5, energy=1});
table.insert(cards, {tag="Thunderclap",	class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemies', dmg=4, vulnerable=1, energy=1});
table.insert(cards, {tag="Pomel Strike",class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=9, energy=1, draw=1, onUpgrade={dmg=10, draw=2}});
table.insert(cards, {tag="Twin Strike",	class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=5, times=2, energy=1});
table.insert(cards, {tag="Body Slam",	class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=0, strX=1, dmgByAttrFromSource="armor", energy=1, onUpgrade = {energy=0}});
table.insert(cards, {tag="Boomerang",	class="red", rarity=1, ctype=CTYPE_ATTACK, range='rnd', dmg=3, times=3, energy=1});
table.insert(cards, {tag="Anger",		class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=6, energy=0, onUse={action="copy", target="this", to="draw"}, onUpgrade={dmg=8}});
table.insert(cards, {tag="Wild Strike",	class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=12, energy=1, woundsToDeck=1});
table.insert(cards, {tag="Perfected Strike",class="red",rarity=1,ctype=CTYPE_ATTACK,range='enemy', dmg=6, energy=2, addDmgByCard={"Strike", 2}, onUpgrade = {addDmgByCard={"Strike", 3}}});
table.insert(cards, {tag="Headbutt",	class="red", rarity=1, ctype=CTYPE_ATTACK,range='enemy', dmg=9, energy=1, onUse=onUseRedeck});
table.insert(cards, {tag="Clash",		class="red", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=14, energy=0, playable="attack_hand"});

table.insert(cards, {tag="Uppercut",	class="red", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=13, weak=1, vulnerable=1, energy=2});
table.insert(cards, {tag="Sever Soul",	class="red", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=16, energy=2, hand={action="exhaust", ctype=CTYPE_ATTACK, value=false}});
table.insert(cards, {tag="Pummel",		class="red", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=2, times=4, energy=1, exhaust=true});
table.insert(cards, {tag="Hemokinesis",	class="red", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=14, harm=3, energy=1});
table.insert(cards, {tag="Carnage",		class="red", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=20, energy=2, ethereal=true, onUpgrade = {dmg=28}});
table.insert(cards, {tag="Rampage",		class="red", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=8, energy=1, onUse={action="plus", target="dmg", val=4}});
table.insert(cards, {tag="Reckless Charge",class="red",rarity=2,ctype=CTYPE_ATTACK, range='enemy', dmg=7, energy=0, once={addCards={deck={"Dazed"}}, range='self'}, onUpgrade = {dmg=11}});
table.insert(cards, {tag="DropKick",	class="red", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=5, energy=1, ifEnemy={condition="vulnerable", play={range="self", energyAdd=1, draw=1}}});
table.insert(cards, {tag="Whirlwind",	class="red", rarity=2, ctype=CTYPE_ATTACK, range='enemies', dmg=5, energy="x", onUpgrade = {dmg=8}});
table.insert(cards, {tag="Searing Blow",class="red", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=12, dmgPerUpgrade=4, energy=2, unlimited=true, onUpgrade={}});
table.insert(cards, {tag="Blood for Blood",class="red",rarity=2,ctype=CTYPE_ATTACK,range='enemy',dmg=18, energy=4, discount="attacked", onUpgrade = {energy=3, dmg=22}});

table.insert(cards, {tag="Immolate",	class="red", rarity=3, ctype=CTYPE_ATTACK,range='enemies', energy=2, dmg=21, onUpgrade={dmg=28}, once={range="self", addCards={draw={"Burn"}}}});
table.insert(cards, {tag="Bludgeon",	class="red", rarity=3, ctype=CTYPE_ATTACK, range='enemy', dmg=32, energy=3});
table.insert(cards, {tag="Reaper",		class="red", rarity=3, ctype=CTYPE_ATTACK, range='enemies', dmg=4, energy=2, vamp=1, exhaust=true});
table.insert(cards, {tag="Fiend Fire",	class="red", rarity=3, ctype=CTYPE_ATTACK, range='enemy', energy=2, hand={action="exhaust", ctype='all', value=false, onCount={dmg=7}}});
table.insert(cards, {tag="Feed",		class="red", rarity=3, ctype=CTYPE_ATTACK, range='enemy', dmg=10, feed=3, energy=1, exhaust=true, onUpgrade = {dmg=12, feed=4}});

table.insert(cards, {tag="Defend",		class="any", rarity=0, ctype=CTYPE_SKILL, range='self', armor=5, energy=1, onUpgrade={armor=8}});
table.insert(cards, {tag="Shrug it Off",class="red", rarity=1, ctype=CTYPE_SKILL, range='self', armor=8, energy=1, draw=1, onUpgrade = {armor=11}});
table.insert(cards, {tag="Flex",		class="red", rarity=1, ctype=CTYPE_SKILL, range='self', str=2, strNext=-2, energy=0});
table.insert(cards, {tag="Havoc",		class="red", rarity=1, ctype=CTYPE_SKILL,  range='self', energy=1, drawPlayExhaust=1});
table.insert(cards, {tag="Warcry",		class="red", rarity=1, ctype=CTYPE_SKILL, range='self', draw=1, energy=0, exhaust=true, onUse={action="redeck", target="hand", filter={"ctype", "all", false}}});
table.insert(cards, {tag="Armaments",	class="red", rarity=1, ctype=CTYPE_SKILL, range='self', armor=5, energy=1, onUse={action="upgrade", target="hand", filter={"ctype", "all", false}}});
table.insert(cards, {tag="True Grit",	class="red", rarity=1, ctype=CTYPE_SKILL, range='self', armor=7, energy=1, onUse={action="exhaust", target="hand", filter={"ctype", "all", false}, amount="rnd"}});

table.insert(cards, {tag="Intimidate",	class="red", rarity=2, ctype=CTYPE_SKILL, range='enemies', weak=1, energy=0, exhaust=true});
table.insert(cards, {tag="Disarm",		class="red", rarity=2, ctype=CTYPE_SKILL, range='enemy', str=-2, energy=1, exhaust=true, onUpgrade = {str=-3}});
table.insert(cards, {tag="Shockwave",	class="red", rarity=2, ctype=CTYPE_SKILL, range='enemies', weak=3, vulnerable=3, energy=2, exhaust=true});
table.insert(cards, {tag="Battle Trance",class="red",rarity=2, ctype=CTYPE_SKILL, range='self', draw=3, energy=0, frozen=1});
table.insert(cards, {tag="Bloodletting",class="red", rarity=2, ctype=CTYPE_SKILL, range='self', harm=3, energyAdd=1, energy=0, onUpgrade = {energyAdd=2}});
table.insert(cards, {tag="Seeing Red",	class="red", rarity=2, ctype=CTYPE_SKILL, range='self', energyAdd=2, energy=1, exhaust=true});
table.insert(cards, {tag="Second Wind",	class="red", rarity=2, ctype=CTYPE_SKILL, range='self', energy=1, hand={action="exhaust", ctype=CTYPE_ATTACK, value=false, onCount={armor=5}}});
table.insert(cards, {tag="Dual Wield",	class="red", rarity=2, ctype=CTYPE_SKILL, range='self', energy=1, onUse={action="copy", target="hand", filter={"ctype", CTYPE_SKILL, false}, amount=1, copies=1},
	onUpgrade = {onUse={action="copy", target="hand", filter={"ctype", CTYPE_SKILL, false}, amount=1, copies=2}}});
table.insert(cards, {tag="Entrench",	class="red", rarity=2, ctype=CTYPE_SKILL,  range='self', armorMlt=2, energy=2});
table.insert(cards, {tag="Ghostly Armor",class="red",rarity=2, ctype=CTYPE_SKILL, range='self', armor=10, energy=1, ethereal=true});
table.insert(cards, {tag="Power Through",class="red",rarity=2, ctype=CTYPE_SKILL, range='self', armor=15, energy=1, woundsToHand=2});
table.insert(cards, {tag="Infernal Blade",class="red",rarity=2,ctype=CTYPE_SKILL, range='self', energy=1, exhaust=true, create={count=1, attr="ctype", val=CTYPE_ATTACK, energyTemp=0}});
table.insert(cards, {tag="Burning Pact",class="red", rarity=2, ctype=CTYPE_SKILL, range='self', energy=1, onUse={action="exhaust", target="hand", filter={"ctype", "all", false}, amount=1, onCount={range="self", draw=2}}, onUpgrade={onUse={action="exhaust", target="hand", filter={"ctype", "all", false}, amount=1, onCount={range="self", draw=3}}}});
table.insert(cards, {tag="Flame Barrier",class="red", rarity=2, ctype=CTYPE_SKILL, range='self', armor=12, energy=2, flamebarrier=4, onUpgrade = {armor=16, flamebarrier=6}});
table.insert(cards, {tag="Rage",		class="red", rarity=2, ctype=CTYPE_SKILL, range='self', energy=1, rage=3, onUpgrade = {rage=5}});
table.insert(cards, {tag="Sentinel",	class="red", rarity=2, ctype=CTYPE_SKILL, range='self', armor=5, energy=1, onExhaust={energyAdd=2}});
table.insert(cards, {tag="Spot Weakness",class="red", rarity=2, ctype=CTYPE_SKILL, range='enemy', energy=1, ifEnemy={intend="dmg", play={range="self", str=3}}, onUpgrade={ifEnemy={intend="dmg", play={range="self", str=4}}}});

table.insert(cards, {tag="Offering",	class="red", rarity=3, ctype=CTYPE_SKILL, range='self', harm=6, energyAdd=2, draw=3, energy=0, exhaust=true, onUpgrade = {draw=5}});
table.insert(cards, {tag="Impervious",	class="red", rarity=3, ctype=CTYPE_SKILL, range='self', armor=30, energy=2, exhaust=true});
table.insert(cards, {tag="Limit Break",	class="red", rarity=3, ctype=CTYPE_SKILL, range='self', strMlt=2, energy=1, exhaust=true});
table.insert(cards, {tag="Double Tap",	class="red", rarity=3, ctype=CTYPE_SKILL, range='self', energy=1, doubletap=1, onUpgrade={doubletap=2}});
table.insert(cards, {tag="Exhume",		class="red", rarity=3, ctype=CTYPE_SKILL, range='self', energy=1, onUpgrade = {energy=0}, onUse={action="rehand", target="trash", filter={"ctype", "all", false}}});

table.insert(cards, {tag="Inflame",		class="red", rarity=2, ctype=CTYPE_POWER, range='self', str=2, energy=1});
table.insert(cards, {tag="Metallicize",	class="red", rarity=2, ctype=CTYPE_POWER, range='self', protect=3, energy=1});
table.insert(cards, {tag="Fire Breathing",	class="red", rarity=2, ctype=CTYPE_POWER, range='self', firebreath=1, energy=1, onUpgrade = {energy=0}});
table.insert(cards, {tag="Rupture",		class="red", rarity=2, ctype=CTYPE_POWER, range='self', energy=1, rupture=1});--add one str on harm
table.insert(cards, {tag="Evolve",		class="red", rarity=2, ctype=CTYPE_POWER,  range='self', energy=1, evolve=1, onUpgrade={evolve=2}});
table.insert(cards, {tag="Feel No Pain",class="red", rarity=2, ctype=CTYPE_POWER,  range='self', energy=1, feelnopain=3, onUpgrade = {feelnopain=4}});
table.insert(cards, {tag="Combust",		class="red", rarity=2, ctype=CTYPE_POWER, range='self', energy=1, bleeding=1, combust=5, onUpgrade = {combust=6}});
table.insert(cards, {tag="Corruption",	class="red", rarity=2, ctype=CTYPE_POWER, range='self', energy=3, corruption=1});
table.insert(cards, {tag="Barricade",	class="red", rarity=3, ctype=CTYPE_POWER, range='self', energy=3, barricade=1});
table.insert(cards, {tag="Demon Form",	class="red", rarity=3, ctype=CTYPE_POWER, range='self', energy=3, demon=2});--add 2 str on turn
table.insert(cards, {tag="Juggernaut",	class="red", rarity=3, ctype=CTYPE_POWER, range='self', energy=2, juggernaut=5, onUpgrade = {juggernaut=7}});--do 3 dmg to rnd enemy on armor
table.insert(cards, {tag="Dark Embrace",class="red", rarity=3, ctype=CTYPE_POWER,  range='self', energy=2, darkembrace=1});
table.insert(cards, {tag="Berserk",		class="red", rarity=3, ctype=CTYPE_POWER,  range='self', energy=0, energetic=1, vulnerableSelf=2, onUpgrade = {vulnerableSelf=1}});
table.insert(cards, {tag="Brutality",	class="red", rarity=3, ctype=CTYPE_POWER,  range='self', energy=0, brutality=1});


table.insert(cards, {tag="Neutralize",		class="green",	rarity=0, ctype=CTYPE_ATTACK, energy=0, range='enemy', dmg=3, weak=1, onUpgrade={dmg=4, weak=2}});
table.insert(cards, {tag="Bane",			class="green",	rarity=1, ctype=CTYPE_ATTACK, energy=1, range='enemy', dmg=7, ifEnemy={condition="poison", play={dmg=7, range='enemy'}}, 
	onUpgrade={dmg=10, ifEnemy={condition="poison", play={dmg=10, range='enemy'}}}});--Deal 7(10) damage, if the enemy is Poisoned, deal 7(10) damage again
table.insert(cards, {tag="Dagger Spray",	class="green",	rarity=1, ctype=CTYPE_ATTACK, range="enemies", energy=1, dmg=4, times=2, onUpgrade={dmg=6}});--Deal 4(6) damage to all enemy twice
table.insert(cards, {tag="Dagger Throw",	class="green",	rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=9, draw=1, onUse=onUseDiscardOne, onUpgrade={dmg=12}});--Deal 9(12) damage, draw 1 card, discard 1 card
table.insert(cards, {tag="Flying Knee",		class="green",	rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=8, nextTurn={range='self', energyAdd=1}, onUpgrade={dmg=11}});--Deal 8(11) damage, Next Turn gain 1 energy
table.insert(cards, {tag="Poisoned Stab",	class="green",	rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=6, poison=3, onUpgrade={dmg=8, poison=4}});--Deal 5(6) damage. Apply 3(4) Poison.
table.insert(cards, {tag="Quick Slash",		class="green",	rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=8, draw=1, onUpgrade={dmg=12}});--Deal 8(12) damage. Draw 1 card
table.insert(cards, {tag="Slice",			class="green",	rarity=1, ctype=CTYPE_ATTACK, energy=0, range="enemy", dmg=5, onUpgrade={dmg=8}});--Deal 5(8) damage
table.insert(cards, {tag="Sucker Punch",	class="green",	rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=7, weak=1, onUpgrade={dmg=9, weak=2}});--Deal 7(9) damage. Apply 1(2) weak
table.insert(cards, {tag="Underhanded Strike",class="green",rarity=1, ctype=CTYPE_ATTACK, energy=0, range="self", playable="unplayable", onDiscard={dmg=7, range='rnd'}, onUpgrade={onDiscard={dmg=10, range='rnd'}}});--Unplayable. If this card is discarded from your hand deal 7(10) damage to a random enemy.
-- table.insert(cards, {tag="Sneaky Strike",class="green",rarity=1, ctype=CTYPE_ATTACK, energy=0, range="self", playable="unplayable", onDiscard={dmg=7, range='rnd'}, onUpgrade={onDiscard={dmg=10, range='rnd'}}});--Unplayable. If this card is discarded from your hand deal 7(10) damage to a random enemy.


table.insert(cards, {tag="All Out Attack",	class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemies", dmg=10, onUse=onUseDiscardRnd, onUpgrade={dmg=14}});--Deal 10(14) damage to all enemies, draw 1 less card next turn
table.insert(cards, {tag="Backstab",		class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=0, range="enemy", dmg=11, innate=true, exhaust=true, onUpgrade={dmg=15}});--Deal 11(15) damage. Innate. Exhaust.
table.insert(cards, {tag="Choke",			class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=12, choke=3, onUpgrade={choke=5}});--Deal 12 damage, whenever you play a cards this turn targeted enemy loses 3(5) hp
table.insert(cards, {tag="Dash",			class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemy", armor=10, dmg=10, onUpgrade={armor=13, dmg=13}});--Gain 10(13) Block, deal 10(13) damage
table.insert(cards, {tag="Endless Agony",	class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=0, range="enemy", dmg=4, exhaust=true, onUpgrade={dmg=6}, onDraw={action="copy", target="this", to="hand"}});--Whenever you draw this card add a copy to your hand.Deal 4 (6) damage. Exhaust
table.insert(cards, {tag="Eviscerate",		class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=4, range="enemy", discount="discard", dmg=6, times=3, onUpgrade={dmg=8}});--Cost 1 less for each discarded card this turn. Deal 6(8) damage three times.
table.insert(cards, {tag="Finisher",		class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=0, strX=0, dmgByAttrFromSource="card_type_1_played", times=6, onUpgrade={times=8}});--Deal 6(8) damage for each attack play this turn
table.insert(cards, {tag="Flechettes",		class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=0, strX=0, dmgByAttrFromSource="card_type_2_hand", times=4, onUpgrade={times=6}});--Deal 4(6) damage for each skill in your hand
table.insert(cards, {tag="Heel Hook",		class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=5, ifEnemy={condition="weak", play={range="self", energyAdd=1, draw=1}}, onUpgrade={dmg=8}});--Deal 5(7) damage, if the enemy is Weak gain 1 energy and draw a card.
table.insert(cards, {tag="Masterful Stab",	class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=0, range="enemy", dmg=15, playable="lastcard", onUpgrade={dmg=20}});--Can only be played if there are no other cards in your hand.Deal 15(20) damage
table.insert(cards, {tag="Predator",		class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=15, onUpgrade={dmg=20}, nextTurn={range='self', draw=2}});--Deal 15(20) damage. Draw 2 more card next turn
table.insert(cards, {tag="Riddle with Holes",class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=3, times=5, onUpgrade={dmg=4}});--Deal 3(4) damage 5 times
table.insert(cards, {tag="Skewer",			class="green",	rarity=2, ctype=CTYPE_ATTACK, energy=x, range="enemy", dmg=7, onUpgrade={dmg=10}});--Spend all energy . Deal 7(10) damage X times.
	
table.insert(cards, {tag="Die Die Die",		class="green",	rarity=3, ctype=CTYPE_ATTACK, energy=1, range="enemies", dmg=13, exhaust=true, onUpgrade={dmg=17}});--Deal 13(17) damage to all enemies. Exhaust.
table.insert(cards, {tag="Glass Knife",		class="green",	rarity=3, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=8, times=2, onUpgrade={dmg=12}, onUse={action="plus", target="dmg", val=-2}});--Deal 8(12) damage twice.Glass Knife's damage is lowered by 2 this combat.
-- table.insert(cards, {tag="Grand Finale",	class="green",	rarity=3, ctype=CTYPE_ATTACK, energy=0, range="enemies", dmg=40, onUpgrade={dmg=50}, playable="empydeck"});--Can only be played if there are no cards in your draw pile, deal 40 damage to all enemies.
table.insert(cards, {tag="Unload",			class="green",	rarity=3, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=12, onUpgrade={dmg=16}, hand={action="discard", ctype=CTYPE_ATTACK, value=false}});--Deal 12(16) damage, discard ALL non attack card.

table.insert(cards, {tag="Survivor",			class="green",	rarity=1,	ctype=CTYPE_SKILL,	range='self',	energy=1, armor=8, onUse={action="discard", target="hand", filter={"ctype", "all", false}}, onUpgrade={armor=11}});
table.insert(cards, {tag="Acrobatics",			class="green",	rarity=1,	ctype=CTYPE_SKILL,	range="self",	energy=1, draw=3, onUse=onUseDiscardOne, onUpgrade={draw=4}});--	Draw 3 (4) cards discard 1 cad
table.insert(cards, {tag="Backflip",			class="green",	rarity=1,	ctype=CTYPE_SKILL,	range="self",	energy=1, armor=5, draw=2, onUpgrade={armor=8}});--	Gain 5(8) Block, draw 2 cards
table.insert(cards, {tag="Cloak And Dagger",	class="green",	rarity=1,	ctype=CTYPE_SKILL,	range="self",	energy=1, armor=6, addCards={hand={"Shiv"}}, onUpgrade={addCards={hand={"Shiv", "Shiv"}}}});--	Gain 6 Block, Add 1(2) Shiv to your hand
table.insert(cards, {tag="Deadly Poison",		class="green",	rarity=1,	ctype=CTYPE_SKILL,	range="enemy",	energy=1, poison=5, onUpgrade={poison=7}});--	Apply 4(6) Poison
table.insert(cards, {tag="Deflect",				class="green",	rarity=1,	ctype=CTYPE_SKILL,	range="self",	energy=0, armor=4, onUpgrade={armor=6}});--	Gain 4(6) Block
table.insert(cards, {tag="Dodge and Roll",		class="green",	rarity=1,	ctype=CTYPE_SKILL,	range="self",	energy=1, armor=4, nextTurn={range='self', armor=4}, onUpgrade={armor=6, nextTurn={range='self', armor=6}}});--	Gain 4(6) Block, Next turn gain 4(6) Block
table.insert(cards, {tag="Outmaneuver",			class="green",	rarity=1,	ctype=CTYPE_SKILL,	range="self",	energy=1, nextTurn={range='self', energyAdd=2}, onUpgrade={nextTurn={range='self', energyAdd=3}}});--	Next turn gain 2 (3) energy
table.insert(cards, {tag="Piercing Wail",		class="green",	rarity=1,	ctype=CTYPE_SKILL,	range="enemies",energy=1, str=-6, strNext=6, onUpgrade={str=-8, strNext=8}, exhaust=true});--	All enemy lose 6(8) strength for 1 turn. Exhaust.
table.insert(cards, {tag="Prepared",			class="green",	rarity=1,	ctype=CTYPE_SKILL,	range="self",	energy=0, draw=1, onUse=onUseDiscardOne, onUpgrade={draw=2, onUse=onUseDiscardTwo}});--	Draw 1 (2) card(s), Discard 1(2) card(s).
table.insert(cards, {tag="Survivor",			class="green",	rarity=1,	ctype=CTYPE_SKILL,	range="self",	energy=1, armor=8, onUse=onUseDiscardOne, onUpgrade={armor=11}});--	Gain 8(11) block. Discard a card
table.insert(cards, {tag="Blade Dance",			class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="self",	energy=1, addCards={hand={"Shiv", "Shiv"}}, onUpgrade={addCards={hand={"Shiv", "Shiv", "Shiv"}}}});--	Add 2 (3) Shivs to your hand
table.insert(cards, {tag="Blur",				class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="self",	energy=1, armor=5, blur=1, onUpgrade={armor=8}});--	Gain 5(8) Block, Block is not removed at the start of your next turn
table.insert(cards, {tag="Bouncing Flask",		class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="rnd",	energy=2, times=3, poison=3, onUpgrade={times=4}});--	Apply 3 Poison to a random enemy 3(4) times
table.insert(cards, {tag="Calculated Gamble",	class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="self",	energy=0, exhaust=true, onUpgrade={exhaust=false}, hand={action="discard", ctype='all', value=false, onCount={draw=1}}});--	Discard your hand then draw that many cards. Exhaust.(non-exhaust)
table.insert(cards, {tag="Catalyst",			class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="enemy",	energy=1, poisonMlt=2, onUpgrade={poisonMlt=3}, exhaust=true});--	Double (Triple) an enemy's Poison. Exhaust
table.insert(cards, {tag="Concentrate",			class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="self",	energy=0, energyAdd=2, onUse=onUseDiscardThree, onUpgrade={onUse=onUseDiscardTwo}});--	Discard 3 (2) cards, gain 2 energy
table.insert(cards, {tag="Crippling Poison",	class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="enemies",energy=2, poison=4, weak=2, exhaust=true, onUpgrade={poison=7}});
table.insert(cards, {tag="Distraction",			class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="self",	energy=1, onUpgrade={energy=0}, create={count=1, attr="ctype", val=CTYPE_SKILL, energyTemp=0}});--	Add a Random skill to your hand, it cost 0 this turn
table.insert(cards, {tag="Escape Plan",			class="green",	rarity=2,	ctype=CTYPE_SKILL,	energy=0, range="self",	draw=1, ifDraw={ctype=CTYPE_SKILL, range='self', armor=3}, onUpgrade={ifDraw={ctype=CTYPE_SKILL, range='self', armor=5}}});--	Draw a card.If the card is a skill gain 3(5) Block
table.insert(cards, {tag="Expertise",			class="green",	rarity=2,	ctype=CTYPE_SKILL,	energy=1, range="self",	drawUntil=6, onUpgrade={drawUntil=8}});--	Draw cards until you have 6(8) in hand.
table.insert(cards, {tag="Leg Sweep",			class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="enemy",	energy=2, weak=2, armor=12, onUpgrade={armor=15, weak=3}});--	Apply 2(3) Weak. Gain 12(15) Block
table.insert(cards, {tag="Malaise",				class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="enemy",	energy=x, str=-1, weak=1, exhaust=true, onUpgrade={extraX=1}});--	Spend all energy. Enemy lose X (+1) strength, Apply X (+1) weak. Exhaust
table.insert(cards, {tag="Reflex",				class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="self",	energy=0, onDiscard={range="self", draw=1}, playable="unplayable", onUpgrade={onDiscard={range="self", draw=2}}});--	Unplayable. If this card is discarded from your hand draw a card.(2 cards)
table.insert(cards, {tag="Setup",				class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="self",	energy=1, onUse={action="redeck", target="hand", filter={"ctype", "all", false}, changePick={energyTillUse=0}}, onUpgrade={energy=0}});--	Place a card in your hand on top of your draw pile. It cost 0 until it is played
table.insert(cards, {tag="Terror",				class="green",	rarity=2,	ctype=CTYPE_SKILL,	range="enemy",	energy=1, vulnerable=99, onUpgrade={energy=0}, exhaust=true});--	Apply 99 Vulnerable, Exhaust.

table.insert(cards, {tag="Corpse Explosion",	class="green",	rarity=3,	ctype=CTYPE_SKILL,	energy=2, range="enemy", poison=6, corpseexplosion=1, onUpgrade={poison=9}});--Enemy loses all Poison. Deal damage equivalent to twice (3 times) the amount lost to all enemies.
table.insert(cards, {tag="Adrenaline",			class="green",	rarity=3,	ctype=CTYPE_SKILL,	range="self",	energy=0, energyAdd=1, draw=2, onUpgrade={energyAdd=2}, exhaust=true});--	Gain 1 (2) energy, draw 2 cards. Exhaust
table.insert(cards, {tag="Alchemize",			class="green",	rarity=3,	ctype=CTYPE_SKILL,	range="self",	energy=1, potion=1, onUpgrade={energy=0}, exhaust=true});--	Obtain a random Potion. Exhaust.
table.insert(cards, {tag="Bullet Time",			class="green",	rarity=3,	ctype=CTYPE_SKILL,	range="self",	energy=3, frozen=1, onUpgrade={energy=2}, onUse={action="change", target="hand", filter={"ctype", "all", false}, changePick={energyTemp=0}, amount="all"}});--	You cannot draw any cads this turn. Reduce the cost of cards in your hand to 0 this turn.
table.insert(cards, {tag="Burst",				class="green",	rarity=3,	ctype=CTYPE_SKILL,	range="self",	energy=1, doubleskill=1, onUpgrade={doubleskill=2}});--	This turn your next 1(2) skill is played twice
table.insert(cards, {tag="Doppelganger",		class="green",	rarity=3,	ctype=CTYPE_SKILL,	range="self",	energy=x, nextTurn={range="self", draw=1, energyAdd=1}, onUpgrade={extraX=1}, exhaust=true});--	Next Turn Draw X(+1) cards and gain X(+1) energy
table.insert(cards, {tag="Nightmare",			class="green",	rarity=3,	ctype=CTYPE_SKILL,	range="self",	energy=3, onUpgrade={energy=2}, exhaust=true, onUse={action="copy", target="hand", filter={"ctype", "all", false}, amount=1, nextTurn=true, copies=3}});--	Choose a card. Next turn, add 3 copies of that card into your hand. Exhaust.
table.insert(cards, {tag="Phantasmal Killer",	class="green",	rarity=3,	ctype=CTYPE_SKILL,	range="self",	energy=2, nextTurn={range="self", dmgmultiply=2}, onUpgrade={energy=1}});--	On next turn, your attack damage is doubled
table.insert(cards, {tag="Storm of Steel",		class="green",	rarity=3,	ctype=CTYPE_SKILL,	range="self",	energy=2, onUpgrade={hand={action="discard", ctype='all', value=false, onCount={addCards={hand={"Shiv"}, upgrade=true}}}}, hand={action="discard", ctype='all', value=false, onCount={addCards={hand={"Shiv"}}}}});--	Discard your hand. Add 1 (upgraded) Shiv to your hand for each card discarded
table.insert(cards, {tag="Tactician",			class="green",	rarity=3,	ctype=CTYPE_SKILL,	range="self",	energy=0, playable="unplayable", onDiscard={range="self", energyAdd=1}, onUpgrade={onDiscard={range="self", energyAdd=2}}});--	Unplayable. If this card is discarded from your hand gain 1(2) energy

table.insert(cards, {tag="Accuracy",			class="green",	rarity=2,	ctype=CTYPE_POWER,	energy=1, range="self",	accuracy=3, onUpgrade={accuracy=5}});--	Shivs deal 3 (5) additional damage
table.insert(cards, {tag="Caltrops",			class="green",	rarity=2,	ctype=CTYPE_POWER,	energy=1, range="self",	spike=3, onUpgrade={spike=5}});--	Whenever you are attacked deal 3(5) damage to the attacker
table.insert(cards, {tag="Footwork",			class="green",	rarity=2,	ctype=CTYPE_POWER,	energy=1, range="self",	dex=2, onUpgrade={dex=3}});--	Gain 2(3) Dexterity
table.insert(cards, {tag="Infinite Blades",		class="green",	rarity=2,	ctype=CTYPE_POWER,	energy=1, range="self",	infiniteblades=1, onUpgrade={innate=true}});--	(Innate) At the start of your turn, add a Shiv to your hand
table.insert(cards, {tag="Noxious Fumes",		class="green",	rarity=2,	ctype=CTYPE_POWER,	energy=1, range="self",	noxiousfumes=2, onUpgrade={noxiousfumes=3}});--	At the start of your turn apply 2 (3) Poison to ALL enemies.
table.insert(cards, {tag="Well-Laid Plans",		class="green",	rarity=2,	ctype=CTYPE_POWER,	energy=0, range="self",	retaincards=1, onUpgrade={retaincards=2}});--	At the end of your turn, you can choose 1(2) card to retain in your hand
table.insert(cards, {tag="A Thousand Cuts",		class="green",	rarity=3,	ctype=CTYPE_POWER,	energy=2, range="self",	thousandcuts=1, onUpgrade={thousandcuts=2}});--	Whenever you play a card, deal 1 (2) damage to all enemies
table.insert(cards, {tag="After Image",			class="green",	rarity=3,	ctype=CTYPE_POWER,	energy=1, range="self",	afterimage=1, onUpgrade={innate=true}});--	(Innate) Whenever you play a card, gain 1 Block
table.insert(cards, {tag="Envenom",				class="green",	rarity=3,	ctype=CTYPE_POWER,	energy=2, range="self",	envenom=1, onUpgrade={energy=1}});--	Whenever an attack deals damage apply 1 Poison.
table.insert(cards, {tag="Tools of the Trade",	class="green",	rarity=3,	ctype=CTYPE_POWER,	energy=1, range="self",	toolsofthetrade=1, onUpgrade={energy=0}});--	At the start of your turn draw a card and discard a card.
-- table.insert(cards, {tag="Wraith Form",			class="green",	rarity=3,	ctype=CTYPE_POWER,	energy=3, range="self",	wraithform=3, onUpgrade={wraithform=5}});--	Whenever you play a skill, deal 3 (5) damage to a random enemy
table.insert(cards, {tag="Wraith Form",			class="green",	rarity=3,	ctype=CTYPE_POWER,	energy=3, range="self",	intangible=3, losingdex=1, onUpgrade={energy=2}});--	Whenever you play a skill, deal 3 (5) damage to a random enemy




-- missing blue: Cold Shower, Spontaneous mutation, scales of knowledge, unfavorable exchange
-- missing blue: nonviolence resistance, price of knowledge
-- missing blue: chaos fishing, greed, Immense Capabilities

-- blue new cards: harm to dmg, harm to str, harm to poison

-- todo: entangled - no attacks card for X turns

require("data_cards_none");
require("data_cards_violet");
require("data_cards_blood");
require("data_cards_blue");
require("data_cards_fire");
require("data_cards_mech");
require("data_cards_voodoo");


table.insert(potions, {tag="Attack Potion",		class="any", rarity=1,  ctype="potion", range='self', create={count=1, attr="ctype", val=CTYPE_ATTACK, energyTemp=0}});
table.insert(potions, {tag="Power Potion",		class="any", rarity=1,  ctype="potion", range='self', create={count=1, attr="ctype", val=CTYPE_POWER, energyTemp=0}});
table.insert(potions, {tag="Block Potion",		class="none", rarity=1,  ctype="potion", range='self', armor=12});
table.insert(potions, {tag="Dexterity Potion",	class="none", rarity=1,  ctype="potion", range='self', dex=2});
table.insert(potions, {tag="Strength Potion",	class="none", rarity=1,  ctype="potion", range='self', str=2});
table.insert(potions, {tag="Energy Potion",		class="none", rarity=1,  ctype="potion", range='self', energyAdd=2});
table.insert(potions, {tag="Swift Potion",		class="none", rarity=1,  ctype="potion", range='self', draw=3});
table.insert(potions, {tag="Regen Potion",		class="none", rarity=1,  ctype="potion", range='self', regen=5});

table.insert(potions, {tag="Explosive Potion",	class="none", rarity=1,  ctype="potion", range='enemies', dmg=10, dtype=DTYPE_TRUE});--, dtype=DTYPE_TRUE
table.insert(potions, {tag="Fire Potion",		class="none", rarity=1,  ctype="potion", range='enemy', dmg=20});
table.insert(potions, {tag="Poison Potion",		class="none", rarity=1,  ctype="potion", range='enemy', poison=6});
table.insert(potions, {tag="Weak Potion",		class="none", rarity=1,  ctype="potion", range='enemy', weak=3});
table.insert(potions, {tag="Fear Potion",		class="none", rarity=1,  ctype="potion", range='enemy', vulnerable=3});

table.insert(potions, {tag="Ancient Potion",	class="none", rarity=2,  ctype="potion", range='self', artifact=1});
table.insert(potions, {tag="Essence of Steel",	class="none", rarity=2,  ctype="potion", range='self', shield=4});
table.insert(potions, {tag="Liquid Bronze",		class="none", rarity=2,  ctype="potion", range='self', spike=3});

-- Blood Potion (Ironclad only)	Uncommon	Heal for 10% of your Max HP.
-- Entropic Brew	Rare	Fill all your empty potion slots with random potions.
-- Fairy in a Bottle	Rare	When you would die, heal to 10% of your Max HP instead and discard this potion.
-- Focus Potion(Defect only) Uncommon	Gain 2 Focus.
-- Fruit Juice	Rare	Gain 5 Max HP.
-- Gambler's Brew	Uncommon	Discard any number of cards, then draw that many.
-- Ghost In A Jar (Silent only)	Rare	Gain 1 Intangible.

-- Power Potion	Common	Add a random Power card to your hand, it costs 0 this turn.
-- Regen Potion	Uncommon	Gain 5 Regeneration.
-- Skill Potion	Common	Add a random Skill card to your hand, it costs 0 this turn.
-- Smoke Bomb	Rare	Escape from a non-boss combat. Receive no rewards.
-- Snecko Oil	Rare	Become Confused. Draw 2 cards.
-- Speed Potion	Common	Gain 5 Dexterity. At the end of your turn, lose 5 Dexterity.
-- Steroid Potion	Common	Gain 5 Strength. At the end of your turn, lose 5 Strength.
-- Strength Potion	Common	Gain 2 Strength (for this combat only).
-- Swift Potion	Common	Draw 3 cards.
-- Weak Potion	Common	Apply 3 Weak to target enemy.




events = {};

-- table.insert(events, {tag="One Handed Bandit", lvl="any", actions={
	-- {txt="[Play]", minigame="bandit"},
	-- {txt="[Leave]"}
-- }});
table.insert(events, {tag="Wheel of Fortune", lvl="any", avatar="maid", actions={
	{txt="[Play]", minigame="wheel"},
	{txt="[Leave]"}
}});
table.insert(events, {tag="Match and Keep", lvl="any", avatar="maid", actions={
	{txt="[Play]", minigame="match"},
	{txt="[Leave]"}
}});

table.insert(events, {tag="Designer", lvl="any", actions={
	{txt="[Adjustments]",  price={cost={money=40}, upgraderandom=2}}, --Lose 40 Gold. Upgrade 2 random cards.
	{txt="[Clean Up]",  price={cost={money=60}, transform=2}}, --Lose 60 Gold. Transform 2 cards.
	{txt="[Full Service]",  price={cost={money=90}, removecard=1, upgraderandom=1}}, --Lose 90 Gold. Remove a card, then upgrade a random card.
	{txt="[Punch]",  dmg=3}
}});

table.insert(events, {tag="Duplicator", lvl="any", actions={
	{txt="[Use]", dublicate=1}, --Duplicate a card in your deck.
	{txt="[Leave]"},
}});
table.insert(events, {tag="Face Trader", lvl="any", actions={
	{txt="[Touch]",  dmg=10, money=75}, --Lose X HP (10% of Max HP). Gain 75 Gold.
	{txt="[Trade]",  randomrelic="boots"}, --50%: Good Face. 50%: Bad Face.
	{txt="[Leave]",  }, --(Nothing happens)
}});

table.insert(events, {tag="Ancient Writing", lvl=2, actions={
	{txt="[Elegance]", removecard=1},
	{txt="[Simplicity]", upgrade={"Strike", "Defend"}}
}});

table.insert(events, {tag="The Ssssserpent", lvl=1, actions={
	{txt="[Agree]", money=175, card="Doubt"},
	{txt="[Disagree]"}
}});
table.insert(events, {tag="Blood Upgrade", lvl=2, actions={
	{txt="[Spil]", upgrade=1, dmg=15},
	{txt="[Leave]"},
}});
table.insert(events, {tag="World of Goop", lvl=1, actions={
	{txt="[Gather Gold]", money=75, dmg=12},
	{txt="[Leave It]", moneylose=40},
}});
table.insert(events, {tag="Big Fish", lvl=1, actions={
	{txt="[Banana]", heal=1/3},
	{txt="[Donut]", hpmax=5},
	{txt="[Box]", relic=1, card="Regret"},
}});
table.insert(events, {tag="Dead Adventurer", lvl="any", loots={money=30, potion=1, relic=1, nothing=true}, enemy_party="Sentries", actions={
	{txt="[Search]", search=25},
	{txt="[Leave]", close=true},
}});
table.insert(events, {tag="Purifier", lvl="any", actions={
	{txt="[Pray]", removecard=1},
	{txt="[Leave]"},
}});
table.insert(events, {tag="Upgrade Shrine", lvl="any", actions={
	{txt="[Pray]", upgrade=1},
	{txt="[Leave]"},
}});
table.insert(events, {tag="Transmogrifier", lvl="any", actions={
	{txt="[Pray]", transform=1},
	{txt="[Leave]"},
}});
table.insert(events, {tag="Golden Idol", lvl=1, actions={
	{txt="[Take]", relic="Golden Idol", actions={
		{txt="[Outrun]",  card="Injury"},
		{txt="[Smash]",  dmg=20},
		{txt="[Hide]",  hpmax=-5},
	}},
	{txt="[Leave]"},
}});
-- table.insert(events, {tag="Take it or Leave it", lvl=1, sure=1, actions={
	-- {txt="[Take]", card="Avito Help"},
	-- {txt="[Leave]", money=30},
-- }});
table.insert(events, {tag="Golden Shrine", lvl="any", actions={
	{txt="[Pray]", money=100},
	{txt="[Desecrate]", money=250, card="Regret"},
	{txt="[Leave]"},
}});
table.insert(events, {tag="Lab", lvl="any",actions={
	{txt="[Search]", potion=3}
}});
table.insert(events, {tag="Living Wall", lvl=1, actions={
	{txt="[Forget]", removecard=1},
	{txt="[Change]", transform=1},
	{txt="[Grow]", upgrade=1},
}});
table.insert(events, {tag="Ominous Forge", lvl="any", actions={
	{txt="[Forge]", upgrade=1, rnd={chance=25, card="Injury"}},
	{txt="[Rummage]", relic=1, rnd={chance=75, card="Normality"}},
	{txt="[Leave]"},
}});

table.insert(events, {tag="Shining Light", lvl=1, actions={
	{txt="[Enter]", upgraderandom=2, dmg=15},
	{txt="[Leave]"},
}});

table.insert(events, {tag="Scrap Ooze", lvl=1, actions={
	{txt="[Reach Inside]", dmg=3, rnd={chance=25, relic=1, onFail={actions={
		{txt="[Reach Inside]", dmg=4, rnd={chance=35, relic=1, onFail={actions={
			{txt="[Reach Inside]", dmg=5, rnd={chance=45, relic=1, onFail={actions={
				{txt="[Reach Inside]", dmg=6, rnd={chance=55, relic=1, onFail={actions={
					{txt="[Reach Inside]", dmg=7, rnd={chance=65, relic=1, onFail={actions={
						{txt="[Reach Inside]", dmg=8, rnd={chance=75, relic=1, onFail={actions={
							{txt="[Reach Inside]", dmg=9, rnd={chance=85, relic=1, onFail={actions={
								{txt="[Reach Inside]", dmg=10, rnd={chance=95, relic=1, onFail={actions={
									{txt="[Reach Inside]", dmg=11, relic=1}
								}}}},
								{txt="[Leave]"},
							}}}},
							{txt="[Leave]"},
						}}}},
						{txt="[Leave]"},
					}}}},
					{txt="[Leave]"},
				}}}},
				{txt="[Leave]"},
			}}}},
			{txt="[Leave]"},
		}}}},
		{txt="[Leave]"},
	}}}},
	{txt="[Leave]"},
}});

table.insert(events, {tag="The Cleric", lvl=1, actions={
	{txt="[Heal]", moneylose=35, heal=1/4},
	{txt="[Purify]", price={cost={money=50}, removecard=1}, proceed=false},
	{txt="[Leave]"},
}});

table.insert(events, {tag="The Divine Fountain", lvl="any", req={curses=1}, actions={
	{txt="[Drink]", removecurses="all"},
	{txt="[Leave]"},
}});

table.insert(events, {tag="The Woman in Blue", lvl="any", req={money=50}, actions={
	{txt="[Buy A]", moneylose=20, potion=1},
	{txt="[Buy B]", moneylose=30, potion=2},
	{txt="[Buy C]", moneylose=40, potion=3},
	{txt="[Leave]"},
}});

table.insert(events, {tag="Vampires Court", lvl=2,  actions={
	{txt="[Offer]", price={cost={relic="Blood Vial"}, removecard="Strike", card="Bite", times=5}},
	{txt="[Accept]", price={cost={hpmax=20}, removecard="Strike", card="Bite", times=5}},
	{txt="[Refuse]"},
}});

table.insert(events, {tag="Council of Ghosts", lvl="any", actions={
	{txt="[Accept]", price={cost={hpmax=50}, card="Apparition", times=5}},
	{txt="[Refuse]"},
}});

table.insert(events, {tag="Bonfire Spirits", lvl="any", actions={
	{txt="[Offer]", removecard=1, rewards={{ctype=CTYPE_CURSE, relic="Scrap"}, {rarity=0}, {rarity=1, heal=5}, {rarity=2, heal=100}, {rarity=3, heal=100, hpmax=10}}},
	{txt="[Leave]"},
}});

table.insert(events, {tag="Bullies", lvl=2, actions={
	{txt="[Pay Up]", moneylose=100, msg="Skip the fight, but Bullies make fun of you. Wimp."},
	{txt="[Fight]", fight="Byrds", reward={relic="Red Mask"}},
}});

table.insert(events, {tag="Cursed Tome", lvl=2, lvl2=3, actions={
	{txt="[Read]", msg="In an abandoned temple, you find a giant book, open, riddled with cryptic writings. As you try to interpret the elaborate script, it begins to shift and morph into writing you are familiar with.", actions={
		{txt="[Continue]", dmg=1, actions={
			{txt="[Continue]", dmg=2, actions={
				{txt="[Continue]", dmg=3, actions={
					{txt="[Take]", dmg=10, rnd={chance=33, hidden=true, relic="Enchiridion", onFail={rnd={chance=50, relic="Necronomicon", onFail={relic="Nilrys Codex"}}}}},
					{txt="[Stop]", dmg=3},
				}},
			}},
		}},
	}},
	{txt="[Leave]", },
}});

table.insert(events, {tag="Addicted", lvl=2,  actions={
	{txt="[Give]", price={cost={money=85}, relic=1}},
	{txt="[Card]", price={cost={card="JAX"}, relic=1}},
	{txt="[Leave]"}
}});

table.insert(events, {tag="Dealer", lvl=2,  actions={
	{txt="[Pay]", price={cost={money=77}, card="JAX"}},
	{txt="[Decline]"}
}});

table.insert(events, {tag="The Nest", lvl=2, actions={
	{txt="[Smash and Grab]", money=99},
	{txt="[Stay in Line]", card="Ritual Dagger", dmg=6},
}});



-- Falling
-- Forgotten Altar
-- Hypnotizing Colored Mushrooms
-- Joust
-- Knowing Skull
-- The Library
-- The Moai Head
-- The Mausoleum
-- N'loth
-- Old Beggar
-- Sensory stone
-- Sphere
-- Tomb of Lord Red Mask
-- Winding Halls
-- Wing Statue
-- The Joust (Gamble 50 money for 70% - 100, 30% - 250
-- SEnsory Stone: add corolless cards 1 for 0, 2 for 5 hp, 3 for 10 hp

-- https://slaythespire.gamepedia.com/Category:Events
-- http://slay-the-spire.wikia.com/wiki/Events

-- minigame: Match and Keep!
-- minigame: spin the wheel!

_G.handicaps = {};
table.insert(handicaps, {tag="money", moneylose=9999});
table.insert(handicaps, {hpmaxper=-15, reAddHandicap=-5});
table.insert(handicaps, {removecard="rnd"});

table.insert(handicaps, {enemiesbonus={str=5, artifact=1}, reAddHandicap=1});
table.insert(handicaps, {enemiesbonus={regen=10, artifact=1}, reAddHandicap=1});
table.insert(handicaps, {enemiesbonus={demon=3, artifact=1}, reAddHandicap=1});
table.insert(handicaps, {enemiesbonus={beatofdeath=1, artifact=1}, reAddHandicap=1});
table.insert(handicaps, {enemiesbonus={armor=50}, reAddHandicap=50});


royal.customs = {};
table.insert(royal.customs, {ctype=3, tag="Draft", cleanStartingDeck=true, cardPicks=15}); -- draft 15 cards
table.insert(royal.customs, {ctype=3, tag="Sealed Deck", cleanStartingDeck=true, cardRnd=30}); -- 30 random cards
-- table.insert(royal.customs, {ctype=3, tag="Endless"}); -- winning will return to same act + bligth?
-- table.insert(royal.customs, {ctype=3, tag="Blight Chest"}); -- boss chests contains blight after act3
-- table.insert(royal.customs, {ctype=3, tag="Hoarder"}); -- clone cards on pick up, shop remove disabled
table.insert(royal.customs, {ctype=3, tag="Insanity", cleanStartingDeck=true, cardRnd=50}); -- 50 random cards
-- table.insert(royal.customs, {ctype=3, tag="Chimera", cleanStartingDeck=true, cards={"Strike", "Strike", "Strike", "Defend", "Defend", "Defend", "Bash", "Survivor", "Zap"}}); -- fusion of starting decks of 3 heroes
table.insert(royal.customs, {ctype=3, tag="Praise Snecko", loserelics0=1, relic="Snecko Eye"}); -- Snecko Eye instead of starting relic
-- table.insert(royal.customs, {ctype=3, tag="Shiny"}); -- add a copy of each rare card
-- table.insert(royal.customs, {ctype=3, tag="Specialized"}); -- start with 5 copy of each card
-- table.insert(royal.customs, {ctype=3, tag="Vintage"}); -- normal drop relics instead of cards
-- table.insert(royal.customs, {ctype=3, tag="Controled Chaos"}); -- start with Frozen Eye, at battle starts - adds 10 random cards at bottom of battle deck
table.insert(royal.customs, {ctype=3, tag="Inception", loserelics0=1, relic="Unceasing Top"}); -- replaces starting relic with Unceasing Top


table.insert(royal.customs, {ctype=4, tag="All Star", cardRndColorless=5}); -- start iwht 5 colorless cards
table.insert(royal.customs, {ctype=4, tag="Diverse", relic="Prism Stone"}); -- cards are not restricted by your characer
for i=1,#heroes do
	-- table.insert(royal.customs, {ctype=4, tag="Red" -- mix red cards to your deck
	-- tag="Green" -- mix green cards to your deck
	-- heroes[i].class
end
-- table.insert(royal.customs, {ctype=4, tag="Colorless Cards"}); -- colorless cards now appear in rewards
table.insert(royal.customs, {ctype=4, tag="Heirloom", relic3=1}); -- start with 1 rare relic
table.insert(royal.customs, {ctype=4, tag="Time Dilation", enemiesbonus={slow=1}}); -- all enemies start with the slow debugg
-- table.insert(royal.customs, {ctype=4, tag="Flight"}); -- You may ignore paths when choosing the next room
table.insert(royal.customs, {ctype=4, tag="My True Form", cards={"Demon Form", "Wraith Form", "Echo Form"}});	-- start with copy of demon form, wraith form, echo form


-- table.insert(royal.customs, {ctype=5, tag="Deadly Events"}); -- question rooms can now contain elites, but are also more treasures
table.insert(royal.customs, {ctype=5, tag="Binary", login={cardsreward=-1}}); -- card rewards contain -1 pick
table.insert(royal.customs, {ctype=5, tag="One Hit Wonder", hpmaxper = -99}); -- start the game with 1 Max HP
-- table.insert(royal.customs, {ctype=5, tag="Cursed Run"});	-- Whenever you defeat a boss - become cursed. you Starting relic replaced with	--Cursed Key, Darkstone Periapt, Du-Vu Doll
-- table.insert(royal.customs, {ctype=5, tag="Bug Game Hunter"}); -- More Elites and better rewards
table.insert(royal.customs, {ctype=5, tag="Lethality", enemiesbonus={str=3}, herobonus={str=3}}); -- You start each combat with +3 str and enemies too
table.insert(royal.customs, {ctype=5, tag="Midas", login={nosmith=true, money_bonus=100}}); -- Enemies drop 200% more gold, smith is disabled
-- table.insert(royal.customs, {ctype=5, tag="Night Terrors"}); -- resting heal 100%, but reduce hp max -5
-- table.insert(royal.customs, {ctype=5, tag="Terminal"}); -- new room decreases 1 hp max, +5 plated armor
-- table.insert(royal.customs, {ctype=5, tag="Certain Future"}); -- only one paths
-- table.insert(royal.customs, {ctype=5, tag="Starter Deck", relic="Busted Crown", }); -- Busted Crown and Binary more - enemies will drop no cards




_G.startups = {};

table.insert(startups, {lvl=0, potion=3});-- Obtain 3 random potions 
table.insert(startups, {lvl=0, card3="rnd"});-- Obtain a random Rare Card -- 
-- table.insert(startups, {lvl=0, cardNone2="rnd"});-- Obtain a random colorless uncommon Card -- 
table.insert(startups, {lvl=0, card1=1});-- Choose a card -- table.insert(loot, {"card", 0});
table.insert(startups, {lvl=0, relic="Neows Lament"}); --Enemies in your next three combats have 1 HP
table.insert(startups, {lvl=0, transform=1});-- Transform a card 
table.insert(startups, {lvl=0, upgrade=1});-- Upgrade a card 
table.insert(startups, {lvl=0, removecard=1});-- Remove a card 
table.insert(startups, {lvl=0, hpmax=10}); -- Gain 10% Max HP
table.insert(startups, {lvl=0, money=100});-- Gain 100 gold 
table.insert(startups, {lvl=0, relic1=1});-- Obtain a random Common Relic 

table.insert(startups, {lvl=1, card3=1});-- Choose a Rare Card -- table.insert(loot, {"card", 2, 3});
table.insert(startups, {lvl=1, transform=2});-- Transform two cards 
table.insert(startups, {lvl=1, removecard=2});-- Remove two cards 
table.insert(startups, {lvl=1, hpmax=15});-- Gain 20% Max HP
table.insert(startups, {lvl=1, money=250});-- Gain 250 gold
table.insert(startups, {lvl=1, relic3=1});-- Obtain a random Rare Relic  

table.insert(startups, {lvl=2, relic4=1});-- Obtain a random Rare Relic 
table.insert(startups, {lvl=-2, loserelics0=1});-- Obtain a random Rare Relic 

table.insert(startups, {lvl=-1, dmg=20}); -- Lose 30% of current health
table.insert(startups, {lvl=-1, moneylose=999}); -- Lose all gold 
table.insert(startups, {lvl=-1, dmg=35}); -- Lose 50% of current health
table.insert(startups, {lvl=-1, card="Clumsy"});-- Obtain a Curse
table.insert(startups, {lvl=-1, card="Injury"});-- Obtain a Curse
table.insert(startups, {lvl=-1, hpmax=-5}); -- Lose 10% Max HP