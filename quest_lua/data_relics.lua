-- extra relics: https://github.com/kiooeht/Hubris/wiki/Relics

_G.relics = {};
table.insert(relics, {tag="Rich", 				rarity=7, scin=101, condition={}, _store="rich", rich=1});
table.insert(relics, {tag="Richer", 			rarity=7, scin=102, condition={}, _store="richer", rich=2});

table.insert(relics, {tag="Burning Blood", 		rarity=0, scin=109, condition={event="battle_won", play={range="self", heal=6}}});
table.insert(relics, {tag="Prepared Shot",		rarity=0, scin=161, condition={event="battle_start", play={range="self", draw=2}}});
table.insert(relics, {tag="Soul Shackles",		rarity=0, scin=59,  condition={event="turn", play={range="self", consumePain={attr="str", val=0.1}}}});
table.insert(relics, {tag="Ancestors Fangs",	rarity=0, scin=205, condition={event="battle_start", play={range="self", battlefervor1=2, battlefervor2=2}}});
table.insert(relics, {tag="Favorite Doll",		rarity=0, scin=72, condition={event="battle_start", play={range="self", dollofdecay=3}}});
table.insert(relics, {tag="Fox Tail",			rarity=0, scin=93, condition={event="battle_start", play={range="self", pets={"lightning"}}}});

table.insert(relics, {tag="Pure Water",			rarity=0, scin=122, condition={event="battle_start", play={range="self", addCards={hand={"Miracle"}}}}});
table.insert(relics, {tag="Golden Eye",		lbl="scry",	rarity=1, scin=139, condition={event="battle_start", play={range="self", scryAdd=2}}});
table.insert(relics, {tag="Melange",		lbl="scry",	rarity=1, scin=144, condition={event="shuffle", play={range="self", scry=3}}});
table.insert(relics, {tag="Teardrop Locket",lbl="stances",	rarity=1, scin=402, condition={event="battle_start", play={range="self", calm=1}}});
table.insert(relics, {tag="Holy Water", 		rarity=4, scin=123, relicupgrade="Pure Water", condition={event="battle_start", play={range="self", addCards={hand={"Miracle","Miracle","Miracle"}}}}});
table.insert(relics, {tag="Cloak Clasp",	rarity=3, scin=137, condition={event="turnEnd", play={range="self", armorPerCardInHand=1}}});
table.insert(relics, {tag="Stance Keeper", lvl="stances", rarity=0, scin=129, 
	condition={event="stanceNew", play={
		range="self", onUse={action="rehand", target="draw", amount="all", filter={"label", "marked", true}},
}}});

table.insert(relics, {tag="Anchor", 			rarity=1, scin=146, condition={event="battle_start", play={range="self", armor=10}}});
table.insert(relics, {tag="Ancient Tea Set",	rarity=1, scin=162, condition={event="rest", login={extraenergy=2}}, indicator="extraenergy"}); --Whenever you enter a Rest Site, start the next combat with 2 Energy.
table.insert(relics, {tag="Bag of Marbles", 	rarity=1, scin=156, condition={event="battle_start", play={range="enemies", vulnerable=1}}});
table.insert(relics, {tag="Blood Vial", 		rarity=1, scin=103, condition={event="battle_start", play={range="self", heal=2}}});
table.insert(relics, {tag="Bronze Scales", 		rarity=1, scin=232, condition={event="battle_start", play={range="self", spike=3}}});

-- table.insert(relics, {tag="Dream Catcher", 		rarity=1, condition={event="sleep", login={}}});
-- table.insert(relics, {tag="Happy Flower", 		rarity=1, refill="turn", charges=0, chargesmax=3, onCharge={range="self", energyAdd=1}});

table.insert(relics, {tag="Juzu Bracelet", 		rarity=1, scin=211, login={hiddennoenemies=100}});--	Regular enemy combats are no longer encountered in ? rooms.
table.insert(relics, {tag="Lantern", 			rarity=1, scin=234, condition={event="battle_start", play={range="self", energyAdd=1}}});--		Gain 1 Energy on the first turn of each combat.
table.insert(relics, {tag="Oddly Smooth Stone", rarity=1, scin=233, condition={event="battle_start", play={range="self", dex=1}}});--		At the start of each combat, gain 1 Dexterity.
table.insert(relics, {tag="Omamori", 			rarity=1, scin=54,	login={curses_negated=2}, indicator="curses_negated"});--		Negate the next 2 Curses you obtain.
table.insert(relics, {tag="Orichalcum", 		rarity=1, scin=149,	condition={event="turnEnd", play={range='self', ifEnemy={czero="armor", play={armor=6}}}}});--		If you end your turn without Block, gain 6 Block.
-- table.insert(relics, {tag="Pen Nib", 			rarity=1});--		Every 10th Attack you play deals double damage.
table.insert(relics, {tag="Prayer Wheel", 		rarity=1, scin=127, login={cardonbattle=1}});	--	Normal enemies drop an additional card reward
table.insert(relics, {tag="Prayer Dice", 		rarity=1, scin=128, login={cardontreasure=1}});	--	Non-Boss chests now also contain cards
table.insert(relics, {tag="Regal Pillow", 		rarity=1, scin=81, login={restheal=15}});--		Heal an additional 15 HP when you Rest.
table.insert(relics, {tag="Snecko Skull",	lbl="poison",	rarity=1, scin=61, login={poisonadd=1}});--		Whenever you apply Poison, apply an additional 1 Poison.
table.insert(relics, {tag="Strawberry", 		rarity=1, scin=6,	login={hpmax=7}});--		Raise your Max HP by 7.
table.insert(relics, {tag="Tiny Chest", 		rarity=1, scin=108,	login={money=30, hiddentreasure=10}});--		Gain 30 Gold. You are 10% more likely to find treasure in ? rooms.
table.insert(relics, {tag="Vajra", 				rarity=1, scin=224, condition={event="battle_start", play={range="self", str=1}}});--		At the start of each combat, gain 1 Strength.
table.insert(relics, {tag="War Paint", 			rarity=1, scin=21,	quest={upgradeskills=2}});--		Upon pick up, Upgrade 2 random Skills.
table.insert(relics, {tag="Whetstone", 			rarity=1, scin=22,	quest={upgradeattacks=2}});--		Upon pick up, Upgrade 2 random Attacks.

table.insert(relics, {tag="BF Rager", 		lbl="battlefervor",	rarity=1, scin=151, condition={event="battlefervor", play={range="rnd", dmg=1}}, author="fun channel"});

table.insert(relics, {tag="Bowl HPMax", 		rarity=1, scin=86, condition={event="consume", login={hpmax=1}}});
table.insert(relics, {tag="Bowl Potion",	 	rarity=2, scin=87, condition={event="consume", quest={potion=1, proceed=false}}});
table.insert(relics, {tag="Bowl Money", 		rarity=2, scin=88, condition={event="consume", login={money=15}}});--		When adding cards to your deck, you may gain +2 Max HP instead.
table.insert(relics, {tag="Raincoat",	 		rarity=2, scin=82, login={relicstoheal=true}});

table.insert(relics, {tag="Bowl Poison",lbl="poison",rarity=3, scin=406, condition={event="rest_poisonadd", login={poisonadd=1}}, rest="rest_poisonadd", indicator="poisonadd", max=5});
table.insert(relics, {tag="Girya", 				rarity=3, scin=401, condition={event="rest_lift", login={str=1}}, indicator="str", rest="rest_lift", max=5});--		You can now gain Strength at Rest Sites. (3 times max)
table.insert(relics, {tag="Green Tea",	lbl="voodoo", scin=405, rarity=3, condition={event="rest_voodoo", login={voodoo=1}}, indicator="voodoo", rest="rest_voodoo", max=5});
-- table.insert(relics, {tag="Bowl Remove", 	lbl="voodoo",rarity=3, scin=90, condition={event="consume", quest={removecard=1, proceed=false}}});
-- money
-- poisonadd
-- cardsreward
-- resthealper5cards
-- money_heals
-- money_bonus

--quest
-- upgradeskills
-- upgradeattacks
-- quest={proceed=false, change={changePick={innate=true}, amount=1, filter={"ctype", CTYPE_ATTACK, true}}, }
-- removecard
-- potion

table.insert(relics, {tag="Blue Candle", 			rarity=2, scin=39, condition={event="battle_start", play={range="self", candleblue=1}}});--		Curse cards can now be played. Playing a Curse will make you lose 1 HP and Exhausts the card.
table.insert(relics, {tag="Bottled Flame", 			rarity=2, scin=24,	quest={proceed=false, change={changePick={innate=true}, amount=1, filter={"ctype", CTYPE_ATTACK, true}}, }});--		Upon pick up, choose an Attack card. At the start of each combat, this card will be in your hand.
table.insert(relics, {tag="Bottled Lightning", 		rarity=2, scin=138,	quest={proceed=false, change={changePick={innate=true}, amount=1, filter={"ctype", CTYPE_SKILL, true}}, }});--		Upon pick up, choose a Skill card. At the start of each combat, this card will be in your hand.
table.insert(relics, {tag="Bottled Tornado", 		rarity=2, scin=51,	quest={proceed=false, change={changePick={innate=true}, amount=1, filter={"ctype", CTYPE_POWER, true}}, }});--		Upon pick up, choose a Power card. At the start of each combat, this card will be in your hand.
table.insert(relics, {tag="Centennial Puzzle", 		rarity=2, scin=84, condition={event="udmg", once=true, play={range='self', draw=2}}});--		The first time you lose HP each combat, draw 3 cards.
table.insert(relics, {tag="Darkstone Periapt", 		rarity=2, scin=55, condition={event="cursed", login={hpmax=6}}});--		Whenever you obtain a Curse, increase your Max HP by 6.
table.insert(relics, {tag="Frozen Egg", 			rarity=2, scin=9, login={autoupgradepowers=true}});--		Whenever you add a Power card to your deck, it is Upgraded.
table.insert(relics, {tag="Gremlin Horn", 			rarity=2, scin=206, condition={event="kill", play={range="self", draw=1, energyAdd=1}}});--		Whenever an enemy dies, gain 1 Energy and draw 1 card.
table.insert(relics, {tag="Kunai", 					rarity=2, scin=68, condition={event="played_ctype1_x3", play={range='self', dex=1}}});--		Every time you play 3 Attacks in a single turn, gain 1 Dexterity.
table.insert(relics, {tag="Letter Opener", 			rarity=2, scin=69, condition={event="played_ctype2_x3", play={range='enemies', dmg=5, strX=0}}});--		Every time you play 3 Skills in a single turn, deal 5 damage to ALL enemies.
table.insert(relics, {tag="Matryoshka", 			rarity=2, scin=15, login={treasureextrarelic=2}, indicator="treasureextrarelic"});--		The next 2 chests you open contain 2 Relics. (Excludes boss chests)
table.insert(relics, {tag="Meat on the Bone", 		rarity=2, scin=41,  condition={event="battle_won", play={range="self", ifEnemy={hpLess=50, play={range="self", heal=12}}}}});--		If your HP is at or below 50% at the end of combat, heal 12 HP.
table.insert(relics, {tag="Mercury Hourglass", 		rarity=2, scin=254, condition={event="turn", play={range="enemies", dmg=3, strX=0}}});--		At the start of your turn, deal 3 damage to ALL enemies.
table.insert(relics, {tag="Molten Egg", 			rarity=2, scin=412, login={autoupgradeattacks=true}});--		Whenever you add an Attack card to your deck, it is Upgraded.
table.insert(relics, {tag="Mummified Hand", 		rarity=2, scin=216, condition={event="played_"..CTYPE_POWER, play={range="self", onUse={action="change", target="hand", filter={"ctype", "all", false}, changePick={energyTemp=0}, amount="rnd"}}}});--		Whenever you play a Power, a random card in your hand costs 0 for the turn.
table.insert(relics, {tag="Ninja Scroll", lbl="shiv",	rarity=2, scin=126, condition={event="battle_start", play={range="self", addCards={hand={"Shiv","Shiv","Shiv"}}}}});--		Start each combat with 3 Shivs in hand.
table.insert(relics, {tag="Ornamental Fan", 		rarity=2, scin=67, condition={event="played_ctype1_x3", play={range='self', armor=4}}});--		Every time you play 3 Attacks in a single turn, gain 4 Block.
table.insert(relics, {tag="Pantograph", 			rarity=2, scin=221, condition={event="battle_start", play={range="enemies", ifEnemy={condition="boss", play={heal=25}}}}});--		At the start of boss combats, heal 25 HP.
-- table.insert(relics, {tag="Paper Krane", 			rarity=2, });--		Enemies with Weak deal 50% less damage rather than 25%.
-- table.insert(relics, {tag="Paper Phrog", 			rarity=2, });--		Enemies with Vulnerable take 75% more damage rather than 50%.
table.insert(relics, {tag="Pear", 					rarity=2, scin=8, login={hpmax=10}});--		Raise your Max HP by 10.
table.insert(relics, {tag="Runic Dodecahedron", 	rarity=2, scin=165, condition={event="turn", play={range="self", ifEnemy={hpMore=100, play={range="self", energyAdd=1}}}}});--		If your HP is full, gain 1 Energy at the start of each turn.
table.insert(relics, {tag="Self-Forming Clay", 		rarity=2, scin=150, condition={event="battle_start", play={range="self", udmgtoarmor=3}}});--		Whenever you lose HP in combat, gain 3 Block next turn.
table.insert(relics, {tag="Shuriken", 				rarity=2, scin=70, condition={event="played_ctype1_x3", play={range='self', str=1}}});--		Every time you play 3 Attacks in a single turn, gain 1 Strength.
table.insert(relics, {tag="Smiling Mask", 			rarity=2, scin=52, login={shop_remove_card=true}});--		The merchant's card removal service now always costs 50 Gold.
-- table.insert(relics, {tag="The Courier", 			rarity=2, });--		The merchant no longer runs out of cards, relics, or potions and his prices are reduced by 20%.
table.insert(relics, {tag="Toolbox", 				rarity=2, scin=37, condition={event="battle_start", play={range="self", create={count=1, attr="class", val="none"}}}});--		At the start of each combat, add a random colorless card to your hand.
table.insert(relics, {tag="Tough Bandages", lbl="discard",rarity=2, scin=50, condition={event="discard", play={range="self", armor=3}}});--		Whenever you discard a card during your turn, gain 3 Block.
table.insert(relics, {tag="Toxic Egg", 				rarity=2, scin=148, login={autoupgradeskills=true} });--		Whenever you add a Skill card to your deck, it is Upgraded.
table.insert(relics, {tag="Vampiric Fangs",			rarity=2, scin=48, condition={event="kill", play={hpmax=1, range="self"}}});
table.insert(relics, {tag="Question Card", 			rarity=2, scin=18, login={cardsreward=1}});

table.insert(relics, {tag="Chemical X",				rarity=2, scin=155, condition={event="battle_start", play={range="self", extrax=2}}});

table.insert(relics, {tag="Forge Hammer",			rarity=2, scin=121, login={forgerest=true}});

table.insert(relics, {tag="Bird-Faced Urn", 		rarity=3, scin=215, condition={event="played_"..CTYPE_POWER, play={range="self", heal=2}}});--		Whenever you play a Power, heal 2 HP.
-- table.insert(relics, {tag="Calipers", 				rarity=3, });--		At the start of your turn, lose 15 Block rather than all of your Block.
-- table.insert(relics, {tag="Champion Belt", 			rarity=3, });--		Whenever you apply Vulnerable, also apply 1 Weak.
table.insert(relics, {tag="Charon's Ashes", lbl="exhaust",	rarity=3, scin=256, condition={event="exhausted", play={range="enemies", dmg=3, strX=0}}});--		Whenever you Exhaust a card, deal 3 damage to ALL enemies.
table.insert(relics, {tag="Dead Branch", 			rarity=3, scin=53, condition={event="exhausted", play={range="self", create={count=1}}}});--		Whenever you Exhaust a card, add a random card to your hand.
table.insert(relics, {tag="Du-Vu Doll", 			rarity=3, scin=252, condition={event="battle_start", play={range="self", cursesAdd="str"}}});--		For each Curse in your deck, start each combat with 1 additional Strength.
-- table.insert(relics, {tag="Frozen Eye", 			rarity=3, });--		When viewing your Draw Pile, the cards are now shown in order.
-- table.insert(relics, {tag="Gambling Chip", 	lbl="discard",		rarity=3, });--		At the start of each combat, discard any number of cards then draw that many.
-- table.insert(relics, {tag="Ginger", 				rarity=3, });--		You can no longer become Weakened.
table.insert(relics, {tag="Ice Cream", 				rarity=3, scin=213, condition={event="battle_start", play={range="self", energysave=1}}});--		Energy is now conserved between turns.
table.insert(relics, {tag="Magic Flower", 			rarity=3, scin=214,condition={event="battle_start", play={range="self", healing=50}}});--		Healing is 50% more effective during combat.
table.insert(relics, {tag="Mango", 					rarity=3, scin=10, login={hpmax=14}});--		Raise your Max HP by 14.
table.insert(relics, {tag="Old Coin", 				rarity=3, scin=225,login={money=300}});--		Gain 300 Gold.
table.insert(relics, {tag="Peace Pipe", 			rarity=3, scin=47, login={removeatrest=true}});--		You can now remove cards from your deck at Rest Sites.
table.insert(relics, {tag="Red Skull", lbl="str",	rarity=3, scin=204,condition={event="turn", once=true, play={range="self", ifEnemy={hpLess=50, play={range="self", str=3}}}}});-- While your HP is at or below 50%, you have 3 additional Strength.
-- table.insert(relics, {tag="Shovel", 				rarity=3, });--		You can now Dig for loot at Rest Sites.
table.insert(relics, {tag="Sundial", 				rarity=3, scin=236, condition={event="shuffle", play={range="self", energyAdd=1}}});--		Every 3 times you shuffle your deck, gain 2 Energy.
table.insert(relics, {tag="Thread and Needle", 		rarity=3, scin=242, condition={event="battle_start", play={range="self", shield=5}}});--		At the start of each combat, gain 5 Plated Armor.
table.insert(relics, {tag="Tingsha", lbl="discard", rarity=3, scin=164, condition={event="discard", play={range="rnd", dmg=3, strX=0}}});--		Whenever you discard a card during your turn, deal 3 damage to a random enemy for each card discarded.
-- table.insert(relics, {tag="Torii", 					rarity=3, });--		Whenever you would receive 5 or less unblocked Attack damage, reduce it to 1.
table.insert(relics, {tag="Unceasing Top", 			rarity=3, scin=163, condition={event="empty_hand", play={draw=1, range='self'}}});--		Whenever you have no cards in hand during your turn, draw a card.
table.insert(relics, {tag="Fossilized Helix", 		rarity=3, scin=14, condition={event="battle_start", play={range="self", preventdmg=1}}});

-- table.insert(relics, {tag="Astrolabe", 					rarity=4, });--		Upon pickup, choose and Transform 3 cards, then Upgrade them.
table.insert(relics, {tag="Black Blood", 				rarity=4, scin=110, relicupgrade="Burning Blood", condition={event="battle_won", play={range="self", heal=10}}});--		Replaces Burning Blood. At the end of combat, heal 10 HP.
table.insert(relics, {tag="Black Star", 				rarity=4, scin=58, login={elitelootitems=1}});--		Elites now drop 2 Relics when defeated.
table.insert(relics, {tag="Calling Bell", 				rarity=4, scin=140,	quest={relic=3, curse=3}});--		Obtain 3 Curses and 3 Relics.
-- table.insert(relics, {tag="Cursed Key", 				rarity=4, });--		Gain 1 Energy at the start of each turn. Whenever you open a non-boss chest, obtain a Curse.
-- table.insert(relics, {tag="Ectoplasm", 					rarity=4, });--		Gain 1 Energy at the start of each turn. You can no longer gain Gold.
table.insert(relics, {tag="Eternal Feather", 			rarity=4, scin=159,	login={resthealper5cards=3}});--		For every 5 cards in your deck, heal 3 HP whenever you enter a Rest Site.
table.insert(relics, {tag="Lizard Tail", 				rarity=4, scin=202, login={lives=1}, indicator="lives"});--		When you would die, heal to 50% of your Max HP instead (works once).
table.insert(relics, {tag="Mark of Pain", 				rarity=4, scin=135, login={energymax=1}, condition={event="battle_start", play={range="self", addCards={deck={"Wound", "Wound"}}}}});--		Gain 1 Energy at the start of each turn. Start combats with 2 Wounds in your draw pile.
-- table.insert(relics, {tag="Orrery", 					rarity=4, });--		Choose and add 5 cards to your deck.
-- table.insert(relics, {tag="Pandora's Box", 				rarity=4, });--		Transform all Strikes and Defends.
table.insert(relics, {tag="Philosopher's Stone", 		rarity=4, scin=131, login={energymax=1}, condition={event="battle_start", play={range="self", once={range="enemies", str=1}}}});--		Gain 1 Energy at the start of each turn. ALL enemies start with 2 Strength.
-- table.insert(relics, {tag="Runic Cube", 				rarity=4, });--		Max HP is lowered by 20%. Whenever you lose HP, draw 1 card.
table.insert(relics, {tag="Coffee Dripper", 			rarity=4, scin=422, login={energymax=1, norest=true}});
table.insert(relics, {tag="Fusion Hammer", 				rarity=4, scin=125, login={energymax=1, nosmith=true}});
table.insert(relics, {tag="Runic Dome", 				rarity=4, scin=134, login={energymax=1}, condition={event="battle_start", play={range="self", blinded=1}}});--		Gain 1 Energy at the start of each turn. You can no longer see enemy Intents.
table.insert(relics, {tag="Sozu", 						rarity=4, scin=132,	login={energymax=1, potionless=true}});--		Gain 1 Energy at the start of each turn. You can no longer use potions.
-- table.insert(relics, {tag="Runic Pyramid", 				rarity=4, });--		At the end of your turn, you no longer discard your hand. Draw 1 less card each turn.
table.insert(relics, {tag="Snecko Eye", 				rarity=4, scin=38, condition={event="turn", play={range="self", confuse=1, draw=2}}});--		Draw 2 additional cards each turn. Start each combat Confused.
table.insert(relics, {tag="The Specimen", lbl="poison",	rarity=3, scin=23, condition={event="kill", transfer="poison", range="rnd"}});--		Whenever an enemy dies, transfer any Poison it has to a random enemy.
table.insert(relics, {tag="The Charmer", lbl="charm",	rarity=4, scin=25, condition={event="kill", transfer="charm", range="enemies"}});--		Whenever an enemy dies, transfer any Poison it has to a random enemy.
table.insert(relics, {tag="Tiny House", 				rarity=4, scin=223, quest={proceed=false, potion=1, money=30, hpmax=5, card3=1}});--		Obtain 1 potion. Gain 30 Gold. Raise your Max HP by 5. Obtain 1 card.
table.insert(relics, {tag="Velvet Choker", 				rarity=4, scin=107, login={energymax=1}, indicatorHero="card_played_this_turn", condition={event="played_cards_6", play={endTurn=true, tag="Water Amulet", range="self"}}});--		Gain 1 Energy at the start of each turn. You cannot play more than 6 cards per turn.
-- table.insert(relics, {tag="White Beast Statue", 		rarity=4, });--		Potions always drop after combat.
table.insert(relics, {tag="Wrist Blade", lbl="shiv",	rarity=4, scin=175, condition={event="battle_start", play={range="self", wristblade=3}}});--Attacks that cost 0 deal 3 additional damage.


table.insert(relics, {tag="Busted Crown", 			rarity=4, scin=235, login={energymax=1, cardsreward=-2}});--Attacks that cost 0 deal 3 additional damage.

table.insert(relics, {tag="Bloody Idol", 				rarity=5, scin=212,	login={money_heals=5}});--		Whenever you gain Gold, heal 5 HP.
table.insert(relics, {tag="Enchiridion", 				rarity=5, scin=73,	condition={event="battle_start", play={range="self", create={count=1, attr="ctype", val=CTYPE_POWER, energyTemp=0, class="hero"}}}});--		Start each combat with a random Power card in your hand. It costs 0 until the end of turn.
table.insert(relics, {tag="Golden Idol", 				rarity=5, scin=226, login={money_bonus=25}, indicator="money_bonus"});--		Enemies drop 25% more Gold.
table.insert(relics, {tag="Necronomicon", 				rarity=5, scin=74,  condition={event="turn", play={doubleheavytap=1, range="self"}}, cards={"Necronomicurse"}});--		The first Attack played each turn that costs 2 or more is played twice. When you take this relic, become Cursed.
table.insert(relics, {tag="Neows Lament", 				rarity=5, scin=413, login={easyenemies=3}, indicator="easyenemies"});--		Enemies in your first 3 combats will have 1 HP.
table.insert(relics, {tag="Nilrys Codex", 				rarity=5, scin=75, condition={event="turnEnd", play={chooseOneRandom=3}}});--		At the end of each turn, you can choose 1 of 3 random cards to shuffle into your draw pile.
-- table.insert(relics, {tag="Nloth's Gift", 				rarity=5, });--		Triples the chance of receiving rare cards as monster rewards.
-- table.insert(relics, {tag="Odd Mushroom", 				rarity=5, });--		When Vulnerable, take 25% more damage rather than 50%.
table.insert(relics, {tag="Red Mask", 					rarity=5, scin=160, condition={event="battle_start", play={range="enemies", weak=1}}});--		At the start of each combat, apply 1 Weak to ALL enemies.
table.insert(relics, {tag="Scrap", 						rarity=5, scin=411, hint="scrap_hint"});--		It's unpleasant.

table.insert(relics, {tag="Skull Blue",					rarity=5, scin=501, skull=true, hint="skull_key", hidden=true});
table.insert(relics, {tag="Skull Red",					rarity=5, scin=502, skull=true, hint="skull_key", hidden=true});
table.insert(relics, {tag="Skull Green",				rarity=5, scin=503, skull=true, hint="skull_key", hidden=true});

table.insert(relics, {tag="Cultist Headpiece",	group="boots",	rarity=5, scin=26, hint="scrap_hint"}); -- : You feel more talkative.
table.insert(relics, {tag="Face of Cleric",		group="boots",	rarity=5, scin=27, condition={event="battle_won", play={hpmax=1, range="self"}}}); -- : Raise your Max HP by 1 after each combat.
table.insert(relics, {tag="Gremlin Visage",		group="boots",	rarity=5, scin=28, condition={event="battle_start", play={range="self", weak=1}}}); -- : Start each combat with 1 Weak.
table.insert(relics, {tag="Hungry Face",		group="boots",	rarity=5, scin=29, login={emptychest=1}, indicator="emptychest"}); -- : The next non-boss Chest you open is empty.
table.insert(relics, {tag="Ssserpent Head",		group="boots",	rarity=5, scin=30, condition={event="quest", quest={money=50, proceed=false}}}); -- : Whenever you enter a ? room, gain 50 Gold.

-- table.insert(relics, {tag="Cauldron", 					rarity=6, });--		When obtained, brews 5 random potions.
table.insert(relics, {tag="Lees Waffle", 				rarity=6, scin=7,  login={hpmax=7, hp=100}});--		Raise your Max HP by 7 and heal all of your HP.
table.insert(relics, {tag="Medical Kit", 				rarity=6, scin=40, condition={event="battle_start", play={range="self", candlered=1}}});--		Status cards can now be played. Playing a Status will Exhaust the card.
-- table.insert(relics, {tag="Membership Card", 			rarity=6, });--		In future acts, shops appear 50% more often. BONUS: 20% discount on all products!
table.insert(relics, {tag="Strange Spoon", 				rarity=6, scin=255, login={exhaust_fail=50}});--		Cards which Exhaust when played will instead discard 50% of the time.
table.insert(relics, {tag="Toy Ornithopter", 			rarity=6, scin=251, condition={event="potion_used", play={range="self", heal=5}}});--		Whenever you use a potion, heal 3 HP.
table.insert(relics, {tag="The Abacus", 				rarity=6, scin=157, condition={event="shuffle", play={range="self", nextTurn={range="self", armor=6}}}});
table.insert(relics, {tag="Clockwork Souvenir", 		rarity=6, scin=158, condition={event="battle_start", play={range="self", artifact=1}}});
table.insert(relics, {tag="Twisted Funnel",lbl="poison",rarity=6, scin=403, condition={event="battle_start", play={range="enemies", poison=4}}});

table.insert(relics, {tag="Prism Stone", scin=222, rarity=6, login={colorblind=true}});

-- boss		- rarity 4
-- event	- rarity 5
-- shop		- rarity 6

_G.relics_indexes = {};
for i=1,#relics do
	local robj = relics[i];
	relics_indexes[robj.tag] = robj;
end