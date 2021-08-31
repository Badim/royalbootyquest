enemies = {};
parties = {};
elites = {};
bosses = {};

table.insert(enemies, {tag="Acid Slime 1",	scin="spider", lvl=1, hp=8, hpadd=4, order=false, cards={{range="enemy", dmg=5}, {range="enemy", dmg=3}, {range="enemy", weak=1}}});
table.insert(enemies, {tag="Acid Slime 2",	scin="spider", lvl=1, hp=30, order=false, cards={{dmg=10}, {range="enemy", weak=1}, {dmg=7, addCards={deck={"Slimed"}}}}});
table.insert(enemies, {tag="Acid Slime 3",	scin="spider", lvl=1, hp=40, order=false, cards={{range="enemy", dmg=16}, {range="enemy", weak=2}, {range="enemy", dmg=12, addCards={draw={"Slimed", "Slimed"}}}}, onHalf={range="self", suicide=true, summon={amount=2, hp=1, list={"Acid Slime 2"}}}});

table.insert(enemies, {tag="Spike Slime 1",	scin="spiderling", lvl=1, hp=8, hpadd=4, order=false, cards={{dmg=5},{dmg=3},{frail=1}}, });
table.insert(enemies, {tag="Spike Slime 2",	scin="spiderling", lvl=1, hp=12, order=false, cards={{dmg=10},{frail=1}}, });
table.insert(enemies, {tag="Spike Slime 3",	scin="spiderling", lvl=1, hp=40, order=false, cards={{range="enemy", dmg=16}, {range="enemy", frail=2}}, onHalf={range="self", suicide=true, summon={amount=2, hp=1, list={"Spike Slime 2"}}}});

-- party lvl=2
table.insert(enemies, {tag="Sneaky Gremlin",	scin="gnome_range",		hp=9,  cards={{dmg=9}}});
table.insert(enemies, {tag="Fat Gremlin",		scin="gnome_axe",		hp=15, cards={{dmg=4, weak=1}}});
table.insert(enemies, {tag="Mad Gremlin",		scin="gnome_sekira", 	hp=22, aggressive=2, cards={{dmg=4}}});
table.insert(enemies, {tag="Shield Gremlin",	scin="gnome_mage",		hp=13, cards={{range="ally", armor=7}}});
table.insert(enemies, {tag="Wizard Gremlin",	scin="gnome_rifle",		hp=23, hpadd=2, order=true, cards={{range='self'}, {range='self'}, {range="enemy", dmg=25}}});

local summon_grimlins_card = {range='self', summon={min=1, max=3, amount=2, list={"Sneaky Gremlin", "Fat Gremlin", "Mad Gremlin", "Shield Gremlin", "Wizard Gremlin"}}};
table.insert(enemies, {tag="Gremlin Leader",	scin="bigsmith",		hp=155, hpadd=7, order=false, 
	ini={summon_grimlins_card},
	cards={	summon_grimlins_card,
			{range='party', str=3, armor=6}, {range='enemy', dmg=6, times=3}}});

table.insert(enemies, {tag="Cultist",	scin="bastard", lvl=1, hp=48, hpadd=6, ini={{range='self', demon=3}}, cards={{dmg=3, superanimation=true}}});

table.insert(enemies, {tag="Louse",		scin="goblin_shield", lvl=1, hp=10, hpadd=5, order=false, cards={{range='enemy', dmg=5}, {range='enemy', dmg=6}, {range='enemy', weak=2}, {range='self', str=3}}, shieldup=4, shieldupRnd=4});

table.insert(enemies, {tag="Fungi Beast",scin="zombe", lvl=1, hp=22, hpadd=4, sporecloud=2, cards={{dmg=6}, {range='self', str=3}}, perks={}});

table.insert(enemies, {tag="Jaw Worm",	scin="orc_heavy", hp=40, hpadd=4, cards={{dmg=11}, {range='self', str=3, armor=6}, {dmg=7, armor=5}}});
table.insert(enemies, {tag="Slaver 1",	scin="ranger", hp=45, hpadd=5, cards={{dmg=12}, {dmg=7,weak=1}}, perks={}});
table.insert(enemies, {tag="Slaver 2",	scin="archer", hp=45, hpadd=5, cards={{dmg=13}, {dmg=8,weak=1}, {range='enemy', entangled=1}, {range='enemy', dmg=9, vulnerable=1}}, perks={}});

table.insert(enemies, {tag="Sentry",	scin="ent", lvl=1, hp=35, hpadd=5, artifact=1, order=true, cards={
	{range="enemy", gfx_target="nova_in", gfx_source="nova_out", addCards={draw={"Dazed", "Dazed"}}}, 
	{range="enemy", dmg=9, gfx_target="spikes3"},
}});
table.insert(enemies, {tag="Sentry1",	scin="ent", lvl=1, hp=35, hpadd=5, artifact=1, order=true, cards={
	{range="enemy", gfx_target="nova_in", gfx_source="nova_out", addCards={draw={"Dazed", "Dazed"}}}, 
	{range="enemy", dmg=9, gfx_target="spikes3"},
}});

table.insert(enemies, {tag="Sentry2",	scin="ent", lvl=1, hp=35, hpadd=5, artifact=1, order=true, cards={
	{range="enemy", dmg=9, gfx_target="spikes3"}, 
	{range="enemy", gfx_target="nova_in", gfx_source="nova_out", addCards={draw={"Dazed", "Dazed"}}},
}});

table.insert(enemies, {tag="Byrd",		scin="garpy", hp=25, hpadd=5, flightmax=3, order=false, cards={{dmg=1, times=5, range='enemy'}, {dmg=12, range='enemy'}, {str=1, range='self'}}});
table.insert(enemies, {tag="Chosen",	scin="goblin_elder", hp=95, hpadd=4, cards={{range="enemy", weak=3, onUse={action="play", play={str=3, range="self"}}}, 
																		{dmg=16}, {hex=1, msg="Suffer!"}, {vulnerable=2, dmg=10}, }});
table.insert(enemies, {tag="Snake Plant", scin="knightsword", hp=75, hpadd=4,	malleableTurn=3, malleableRtn=1, cards={{weak=2, frail=2}, {dmg=7, times=3}, {dmg=7, times=3}}});

table.insert(enemies, {tag="Snecko", scin="mag_blue", ini={{confuse=1, range="enemy"}}, hp=114, hpadd=6, cards={{range="enemy", dmg=8, vulnerable=2}, {range="enemy", dmg=16}}, order=false});
table.insert(enemies, {tag="Book of Stabbing", scin="elf", hp=160, stabing=1, cards={{dmg=21}, {dmg=6, times=2}, {dmg=6, times=3}, {dmg=21}, {dmg=6, times=4}, {dmg=6, times=5}, {dmg=21},  {dmg=6, times=6}, {dmg=21},  {dmg=6, times=7}, {dmg=21},  {dmg=6, times=8}}});

table.insert(enemies, {tag="Looter",	scin="pirate", hp=44, hpadd=4, stealmoney=15, cards={{dmg=10}, {dmg=10}}, escape={{armor=10}}});-- armor > exit

table.insert(enemies, {tag="Mugger",	scin="pirate", hp=45, hpadd=5, stealmoney=15, cards={{dmg=15}, {dmg=15}}, escape={{armor=10}}});

table.insert(enemies, {tag="Centurion", hp=78, scin="warrior_mace", order=false, cards={{range="enemy", dmg=12}, {range="enemy", dmg=12}, {range="ally", armor=15}, {range="enemy", dmg=6, times=3}}});
table.insert(enemies, {tag="Mystic", 	hp=52, scin="mag_red", hpadd=1, order=false, cards={{range="party", str=2}, {range="party", heal=16}}});


table.insert(enemies, {tag="Shelled Parasite", scin="vampire_red", hp=68, hpadd=4, armor=14, shield=14, order=false,
ini={{rndCards={{tag="Suck", dmg=10, vamp=1}, {tag="Double Strike", dmg=6, times=2}}}},
cards={
	{tag="Suck", dmg=10, vamp=1}, 
	{tag="Double Strike", dmg=6, times=2}, 
	{tag="Suck", dmg=10, vamp=1}, 
	{tag="Double Strike", dmg=6, times=2}, 
	{tag="Fell", dmg=18, frail=2}, 
}});

-- party - swapable enemies within party
table.insert(enemies, {tag="Spiker",	party="bots",	scin="ram", hp=42, hpadd=14, spike=3, cards={{dmg=7}, {range="self", spike=2}}, order=false});
table.insert(enemies, {tag="Exploder",	party="bots",	scin="sheep", hp=30, hpadd=5, cards={{dmg=9}, {dmg=9}, {dmg=30, suicide=true}}, order=true});
table.insert(enemies, {tag="Repulsor",	party="bots",	scin="fox", hp=29, hpadd=6, cards={
	{dmg=11},
	{addCards={deck={"Dazed", "Dazed"}}},
	{addCards={deck={"Dazed", "Dazed"}}},
	{addCards={deck={"Dazed", "Dazed"}}},
	{addCards={deck={"Dazed", "Dazed"}}},
}});

table.insert(enemies, {tag="Spheric Guardian",	scin="elf_grey", hp=20, armor=20, barricade=1, artifact=3, 
cards={{armor=25, range='self'}, {dmg=10, frail=5, range='enemy'}, {dmg=10, times=2, range='enemy'}, {dmg=10, range='enemy', armor=15}}});

table.insert(enemies, {tag="Orb Walker", scin="elf_evil", lvl=5, hp=90, hpadd=6, demon=3, order=false,
cards={
	{dmg=10, addCards={deck={"Burn"}, draw={"Burn"}}}, 
	{dmg=15}},
});


table.insert(enemies, {tag="The Maw",	scin="mingmage", hp=300, order=false, ini={{range='enemy', weak=3, frail=3}}, cards={{str=3, range='self'}, {dmg=25}, {dmg=5}, {dmg=5, times=2}, {dmg=5, times=5}}});

table.insert(enemies, {tag="Nemesis",	scin="paladin", hp=175, order=false, 
	cards={
		{range='enemy', addCards={draw={"Burn", "Burn", "Burn"}}, once={range="self", intangible=1}},
		{rndCards={{tag="Attack", range="enemy", dmg=6, times=3}, {tag="Scythe", range="enemy", dmg=45}}},
}});

table.insert(enemies, {tag="Darkling",	scin="vampire", lvl=5, hp=50, lifelink=50, hpadd=5, order=false, cards={{dmg=7, range='enemy'}, {dmg=8, range='enemy'}, {dmg=9, range='enemy'}, {dmg=10, range='enemy'}, {dmg=11, range='enemy'}, {dmg=8, times=2, range='enemy'}, {armor=12, range="self"}}});

table.insert(enemies, {tag="Taskmaster",	scin="knightarcher", hp=55, hpadd=5, cards={{dmg=7, addCards={deck={"Wound"}}}}});
table.insert(enemies, {tag="Lagavulin",		scin="renekton", lvl=1, hp=110, hpadd=0, sleep=2, order=true, cards={{dmg=18},{dmg=18},{dex=-1, str=-1}}});

table.insert(enemies, {tag="Gremlin Nob",	scin="azir", lvl=1, hp=82, hpadd=4, ini={{range='self', enrage=2}}, cards={{dmg=14}, {dmg=14}, {dmg=6, vulnerable=2}}});
table.insert(enemies, {tag="Giant Head",	scin="dragon", hp=500, slow=1, cards={{dmg=13}, {dmg=13}, {weak=3}, {dmg=13}, {dmg=30}, {dmg=35}, {dmg=40}}});

table.insert(enemies, {tag="Fire Orb", 		scin="ram_red", hp=16, hpadd=4, cards={{dmg=9, addCards={draw={"Burn"}}}, {dmg=25}}});
table.insert(enemies, {tag="Flame Bruiser",	scin="witch_red", hp=124, hpadd=6, cards={{range="self", summon={min=1, max=3, amount=1, list={"Fire Orb"}}}, {range="enemy", dmg=11, times=2, addCards={draw={"Burn"}}}}});
table.insert(parties, {tag="Fire Party", lvl=5, units={"Flame Bruiser", "Fire Orb"}});
table.insert(parties, {tag="Fire Party", lvl=6, units={"Fire Orb", "Flame Bruiser", "Fire Orb"}});

-- table.insert(enemies, {tag="Serpent",	hp=170, cards={{range="enemy", constricted=10}, {range="enemy", dmg=22}, {range="enemy", dmg=16}}});
-- table.insert(parties, {tag="Serpent", lvl=5, units={"Serpent"}});


-- Bullies:
-- Pointy(5x2), Romeo{{dmg=10}, {dmg=15}}, Bear({dex=-2}, {dmg=9, armor=9}, {dmg=18})


table.insert(parties, {tag="Slimes",		lvl=1, units={"Spike Slime 1", "Acid Slime 2"}});
table.insert(parties, {tag="Slimes",		lvl=1, units={"Spike Slime 1", "Spike Slime 1", "Acid Slime 1", "Acid Slime 1"}});
table.insert(parties, {tag="Slimes5",		lvl=1, units={"Spike Slime 1", "Spike Slime 1", "Spike Slime 1", "Acid Slime 1", "Acid Slime 1"}});
table.insert(parties, {tag="Cultist",		lvl=1, units={"Cultist"}});
table.insert(parties, {tag="Looter",		lvl=1, units={"Looter"}});
table.insert(parties, {tag="Louses",		lvl=1, units={"Louse", "Louse"}});
table.insert(parties, {tag="Jaw Worm",		lvl=1, units={"Jaw Worm"}});
table.insert(parties, {tag="Slaver",		lvl=1, units={"Slaver 1"}});
table.insert(parties, {tag="Slaver",		lvl=1, units={"Slaver 2"}});
table.insert(parties, {tag="Slimes",		lvl=1, units={"Spike Slime 3"}});

table.insert(parties, {tag="Gremlins",		lvl=1, units={"Sneaky Gremlin", "Fat Gremlin", "Shield Gremlin", "Wizard Gremlin"}});
table.insert(parties, {tag="Gremlins",		lvl=1, units={"Sneaky Gremlin", "Fat Gremlin", "Mad Gremlin", "Shield Gremlin"}});
table.insert(parties, {tag="Gremlins",		lvl=1, units={"Sneaky Gremlin", "Fat Gremlin", "Mad Gremlin", "Shield Gremlin"}});

table.insert(parties, {tag="Jaw Worm",		lvl=2, units={"Jaw Worm"}});
table.insert(parties, {tag="Jaw Worms",		lvl=2, units={"Jaw Worm", "Louse"}});
table.insert(parties, {tag="Louses",		lvl=2, units={"Louse", "Louse", "Louse"}});
table.insert(parties, {tag="Fungi Beasts",lvl=2, units={"Fungi Beast", "Fungi Beast"}});
table.insert(parties, {tag="Cult Slime",	lvl=2, units={"Cultist", "Acid Slime 2"}});
table.insert(parties, {tag="Slaver Slime",	lvl=2, units={"Slaver 2", "Spike Slime 2"}});
table.insert(parties, {tag="Slimes3",		lvl=2, units={"Acid Slime 3"}});

table.insert(parties, {tag="Spheric Guardian",	lvl=3, units={"Spheric Guardian"}});
table.insert(parties, {tag="Fungi Beasts",	lvl=3, units={"Fungi Beast", "Fungi Beast", "Fungi Beast"}});
table.insert(parties, {tag="Byrds", 			lvl=3, units={"Byrd", "Byrd", "Byrd"}});
table.insert(parties, {tag="Chosen",			lvl=3, units={"Chosen"}});
table.insert(parties, {tag="Shelled Parasite",	lvl=3, units={"Shelled Parasite"}});

table.insert(parties, {tag="Cultist Chosen",	lvl=3, units={"Cultist", "Chosen"}}); -- too strong for lvl 2?
table.insert(parties, {tag="Snake Plant",		lvl=3, units={"Snake Plant"}});

table.insert(parties, {tag="Heroes Party",		lvl=3, units={"Centurion", "Mystic"}});
table.insert(parties, {tag="Heroes Party",		lvl=4, units={"Centurion", "Mystic"}});

table.insert(parties, {tag="Snecko",		lvl=4, units={"Snecko"}});

table.insert(parties, {tag="Cultist Chosen",	lvl=4, units={"Cultist", "Chosen"}}); -- too strong for lvl 2?
table.insert(parties, {tag="Cultists",			lvl=4, units={"Cultist", "Cultist", "Cultist"}});
table.insert(parties, {tag="Shelled Slaver",	lvl=4, units={"Shelled Parasite", "Slaver 1"}});

table.insert(parties, {tag="Darklings",			lvl=5, units={"Darkling", "Darkling", "Darkling"}});
table.insert(parties, {tag="Walker",			lvl=5, units={"Orb Walker"}});
table.insert(parties, {tag="Bots",				lvl=5, units={"Exploder", "Exploder", "Exploder"}});

table.insert(parties, {tag="Bots",				lvl=6, units={"Exploder", "Exploder", "Exploder", "Exploder"}});

table.insert(parties, {tag="Bots 1",			lvl=6, units={"Exploder", "Exploder", "Spheric Guardian"}});
table.insert(parties, {tag="Bots 2",			lvl=6, units={"Exploder", "Exploder", "Orb Walker"}});
table.insert(parties, {tag="Jaw Worms",			lvl=6, units={"Jaw Worm", "Jaw Worm", "Jaw Worm"}});


table.insert(parties, {tag="The Maw",	lvl=5, units={"The Maw"}});


table.insert(elites, {tag="Sentries", lvl=1, units={"Sentry1", "Sentry2", "Sentry1"}});
table.insert(elites, {tag="Gremlin Nob", lvl=1, units={"Gremlin Nob"}});
table.insert(elites, {tag="Lagavulin", lvl=1, units={"Lagavulin"}});

table.insert(elites, {tag="Slavers", lvl=2, units={"Slaver 1", "Taskmaster", "Slaver 2"}});
table.insert(elites, {tag="Gremlin Leader", lvl=2, units={"Gremlin Leader"}});
table.insert(elites, {tag="Book of Stabbing", lvl=2, units={"Book of Stabbing"}});

table.insert(elites, {tag="Walkers",	lvl=3, units={"Orb Walker", "Orb Walker"}});
table.insert(elites, {tag="Head",	lvl=3, units={"Giant Head"}});
table.insert(elites, {tag="Nemesis",	lvl=3, units={"Nemesis"}});

table.insert(elites, {tag="Sand Golems", lvl=4, units={"Spire Spear", "Spire Shield"}});

table.insert(elites, {tag="Walkers",	lvl=5, units={"Orb Walker", "Orb Walker"}});
table.insert(elites, {tag="Head",		lvl=5, units={"Giant Head"}});
table.insert(elites, {tag="Nemesis",	lvl=5, units={"Nemesis"}});
table.insert(elites, {tag="Sand Golems",lvl=5, units={"Spire Spear", "Spire Shield"}});



table.insert(bosses, {tag="Slime Boss", 	lvl=1, 	achievement=1, units={"Slime Boss"}});
table.insert(bosses, {tag="The Guardian", 	lvl=1, 	achievement=2, units={"The Guardian"}});
table.insert(bosses, {tag="The Hexaghost", 	lvl=1, 	achievement=3, units={"The Hexaghost"}});

table.insert(bosses, {tag="Bronze Statue", 	lvl=2, 	achievement=4, units={"Bronze Statue"}});
table.insert(bosses, {tag="The Collector", 	lvl=2, 	achievement=5, units={"The Collector"}});
table.insert(bosses, {tag="The Champ", 		lvl=2, 	achievement=6, units={"The Champ"}});

table.insert(bosses, {tag="Time Eater", 	lvl=3, 	achievement=7, units={"Time Eater"}});
table.insert(bosses, {tag="Awakened One", 	lvl=3, 	achievement=8, units={"Cultist", "Cultist", "Awakened One"}});
table.insert(bosses, {tag="Pastries2", 		lvl=3, 	achievement=9, units={"Deca", "Donu"}});

table.insert(bosses, {tag="Corrupt Heart", 	lvl=4, 	achievement=10, final=true, units={"Corrupt Heart"}});

table.insert(bosses, {tag="Time Eaters", 	lvl=5, units={"Time Eater", "Time Eater"}});
table.insert(bosses, {tag="Awakened Two", 	lvl=5, units={"Orb Walker", "Orb Walker", "Awakened One"}});
table.insert(bosses, {tag="Pastries3", 		lvl=5, units={"Deca", "Donu", "Donu"}});
table.insert(bosses, {tag="Pastries3", 		lvl=5, units={"Deca", "Deca", "Donu"}});
table.insert(bosses, {tag="Eolevan", 		lvl=5, units={"The Eolevan"}});

table.insert(bosses, {tag="Corrupt Hearts", lvl=6, units={"Corrupt Heart", "Corrupt Heart"}});
table.insert(bosses, {tag="Eolevan 2.0", 	lvl=6, units={"The Eolevan", "Eolevan Minion", "Eolevan Minion", "Eolevan Minion"}});
table.insert(bosses, {tag="Pastries4", 		lvl=6, units={"Deca", "Deca", "Donu", "Donu"}});


table.insert(enemies, {tag="Slime Boss",		scin="witch", boss=1, hp=140, order=true, 
cards={{range='enemy', addCards={deck={"Slimed","Slimed","Slimed"}}, drawless=2}, {range='self'}, {dmg=35}}, 
onHalf={range="self", superanimation=true, suicide=true, summon={amount=2, hp=1, list={"Spike Slime 3", "Acid Slime 3"}}}});

table.insert(enemies, {tag="The Guardian", 	scin="trol",  boss=1, hp=220, shift=30, shiftAdd=0, 
	cards={{range='self'}, {tag="Bash", dmg=32, range='enemy'}, {tag="Steam", weak=2, vulnerable=2}, {tag="Whirlwind", dmg=5, times=4, range='enemy'}},
	onShift={range="self", shifted=3, shiftAdd=10, armor=20},
	shiftCards={{range='self', spike=3}, {range="enemy", dmg=9}, {range="enemy", dmg=8, times=2, once={shift=30, spike=-3, range="self"}}}});

table.insert(enemies, {tag="The Hexaghost",	scin="veigar", boss=1, hp=250, order=true, ini={{range='self'}, {times=3, dmg=6}}, cards={
	{tag="Sear",	range='enemy', dmg=6, addCards={draw={"Burn"}}},
	{tag="Tackle",	range='enemy', dmg=5, times=2}, 
	{tag="Sear",	range='enemy', dmg=6, addCards={draw={"Burn"}}},
	{tag="Inflame",	range="self", armor=12, str=2},
	{tag="Tackle",	range='enemy', dmg=5, times=2}, 
	{tag="Sear",	range='enemy', dmg=6, addCards={draw={"Burn"}}},
	{tag="Inferno",	range='enemy', dmg=6, times=2, addCards={draw={"Burn", "Burn", "Burn"}}}, 
}});

-- 1. Activate
-- 2. Divider

-- 3. Sear
-- 4. Tackle
-- 5. Sear
-- 6. Inflame
-- 7. Tackle
-- 8. Sear
-- 9. Inferno

-- 10+. Repeat 3 to 9

table.insert(enemies, {tag="Bronze Orb",	hp=52, scin="orc", hpadd=6, cards={{stealcard=1, range='enemy'}, {dmg=8, range='enemy'}}, });
table.insert(enemies, {tag="Bronze Statue",	boss=1, scin="minotaur", hp=300, cards={{range='self', summon={min=1, max=3, amount=2, list={"Bronze Orb", "Bronze Orb"}}}, 
{range='enemy', dmg=7, times=2}, {range='enemy', str=3, armor=9}, {range='enemy', dmg=7, times=2}, {dmg=45, range='enemy', play={range='self', sleep=1}}}, });

table.insert(enemies, {tag="The Collector",  boss=1, scin="mag_black", hp=282, cards={{range="self", summon={min=1, max=2, amount=2, list={"Collector Minion"}}}, {str=3, armor=15, range="party"}, {dmg=18}, {range="enemy", weak=3, vulnerable=3}}});
table.insert(enemies, {tag="Collector Minion", scin="skeletwarrior", hp=38, hpadd=2, order=false, cards={{dmg=7}, {dmg=8}, {dmg=9}}});

table.insert(enemies, {tag="The Champ",		scin="warrior_defender", boss=1, hp=420, specialAction={hp=50, card={str=6, cleanse=true, range='self'}}, --rage when below HP truehot
															cards={{dmg=10, frail=2, vulnerable=2}, {armor=15, protect=5, range='self'}, {dmg=15}, {str=2, range='self'}, {dmg=6, times=3}}});

conditions.timeeater = {event="enemy_played_any", play={range="self", timewarp=-1}};	
conditions.timewarp = {onExpire={range="self", str=2, timewarp=12, msg=false, stealturn=true}, hinted=true, _forcedhint=true};														
table.insert(enemies, {tag="Time Eater",	scin="genie", boss=1, hp=456, timeeater=1, timewarp=12, specialAction={hp=50, card={range="self", cleanse=true, healUp=228, superanimation=true}}, --rage when below HP truehot
															order=false, cards={{dmg=6, times=3}, {dmg=25, drawless=2}, {range="enemy", armor=20, weak=1, vulnerable=1}}});


table.insert(enemies, {tag="Donu", boss=1, hp=250, scin="airbow", artifact=2,	cards={{str=3, range="party"}, {dmg=10, times=2, range="enemy"}}});
table.insert(enemies, {tag="Deca", boss=1, hp=250, scin="airsword", artifact=2,	cards={{dmg=10, times=2, range="enemy", addCards={draw={"Dazed"}}}, {armor=16, range="party"}}});


table.insert(enemies, {tag="Awakened One", boss=1, scin="nasus", regenx=10, curiosity=2, hp=300, unawakened=1, order=false, 
cards={{dmg=20}, {dmg=6, times=4}},
shiftCards={{dmg=40}, {dmg=18, superanimation=true, addCards={deck={"Void"}}}, {dmg=10, times=3}}});
conditions.unawakened = {event="death", hinted=true, play={range='self', heal=9999, sleep=1, shifted=99, unawakened=-1, curiosity=-2, cleanse=true, untargetable=1}};



table.insert(enemies, {tag="Spire Shield",	scin="sandpriest", hp=110, order=true, behind=50,
ini={
	
},
shuffleCards={"Bash", "Fortify"}, 
cards={
	{tag="Bash", range="enemy", dmg=12, str=-1}, -- Deals 12 damage. If the player has at least 1 Orb slot, has a 50% chance to apply -1 Focus. Otherwise, applies -1 Strength.
	{tag="Fortify", superanimation=true, range="party", armor=30}, --All enemies gain 30 Block.
	{tag="Smash", range="enemy", dmg=34, armorFromUdmg=1}, -- Deals 34 damage. Gains Block equal to its damage output.
}, 
});

table.insert(enemies, {tag="Spire Spear",scin="sandspear", hp=160, order=true, behind=50,
ini={
	{tag="Burn Strike", range="enemy", dmg=5, times=2, addCards={draw={"Burn"}}}, -- Deals 5x2 damage. Adds 2 Burns into your discard pile.
},
shuffleCards={"Piercer", "Burn Strike"}, 
cards={
	{tag="Skewer", range="enemy", dmg=10, times=3}, --Deals 10x3 damage
	{tag="Piercer", range="party", str=2}, -- All enemies gain 2 Strength.	
	{tag="Burn Strike", range="enemy", superanimation=true, dmg=5, times=2, addCards={draw={"Burn", "Burn"}}},
}, 
});


conditions.beatofdeath = {event="enemy_played_any", play={range="enemy", dmg=1}};-- Beat of Death X: Whenever you play a card, take X damage.
conditions.maximumpain = {event="turn", play={range="self", invincible=1}, hidden=true}; -- works only in conjuction with invincible
conditions.invincible = {expire=9999}; -- works only in conjuction with maximumpain
conditions.painfulstabs = {event="unblocked_dmg", play={range="enemy", addCards={draw={"Wound"}}}};-- Painful Stabs: Shuffle 1 Wound into your Discard Pile each time you receive unblocked attack damage.

table.insert(enemies, {tag="Corrupt Heart",	scin="airgolem", boss=1, hp=750, maximumpain=300, beatofdeath=1, order=true, 
-- Applies 2 Weak, 2 Frail and 2 Vulnerable. Shuffles a Dazed, Slimed, Wound, Burn and a Void into the draw pile
ini={
	{range='enemy', superanimation=true, weak=2, frail=2, vulnerable=2, addCards={deck={"Dazed", "Slimed", "Wound", "Burn", "Void"}}},
},
cards={
	{tag="Blood Shots", range="enemy", dmg=2, times=12},
	{tag="Echo", range="enemy", dmg=40},
	{tag="Buff", superanimation=true, range="self", cleanse="str", str=2, artifact=2}, -- Remove all Strength Down debuffs, gain 2 Strength and *additional buffs.
	
	{tag="Blood Shots", range="enemy", dmg=2, times=12},
	{tag="Echo", range="enemy", dmg=40},
	{tag="Buff", superanimation=true, range="self", cleanse="str", str=2, beatofdeath=1},
	
	{tag="Blood Shots", range="enemy", dmg=2, times=12},
	{tag="Echo", range="enemy", dmg=40},
	{tag="Buff", superanimation=true, range="self", cleanse="str", str=2, painfulstabs=1},
	
	{tag="Blood Shots", range="enemy", dmg=2, times=12},
	{tag="Echo", range="enemy", dmg=40},
	{tag="Buff", superanimation=true, range="self", cleanse="str", str=10},
	
	{tag="Blood Shots", range="enemy", dmg=2, times=12},
	{tag="Echo", range="enemy", dmg=40},
	{tag="Buff", superanimation=true, range="self", cleanse="str", str=50},
	
	-- 1st Buff: Artifact 2
	-- 2nd Buff: Beat of Death 1
	-- 3rd Buff: Painful Stabs
	-- 4th Buff: Strength 10
	-- 5th Buff and higher: Strength 50
}, 
});

-- - Main boss 500 / 1000 / 1500 hp (stage 5 / 10 / 15 etc.)
-- - Heal 50 hp each turn.
-- - 50% resistant to poison (so you need 2 poison to do 1 DMG)
-- - Spawns 3 new smaller enemies (100 hp) when there are no enemies EACH TURN. 
	-- (So if there are 2 alive it spawns 1, basically at the start of the players turn 
	-- there are always 3 small enemies and the boss)
-- regenx=50, artifact=5
-- - Turn 1, range="self", artifact=1, str=20, cleanse="str", summon
-- - Turn 2, range="enemy", dmg=20, weak=2
-- - Small enemies all attack for 2/4/8/16/32/64 per turn (scaling, if an enemy is killed --> scaling restarts)

-- azir_recolor skeletarcher

table.insert(enemies, {tag="The Eolevan",  boss=1, scin="azir_recolor", hp=500, regenx=50, artifact=5, order=false,
cards={
	{range="enemy", dmg=20, weak=2, cleanse=true}, 
	{range="self", artifact=1, str=20, cleanse="str", summon={min=2, max=3, amount=3, list={"Eolevan Minion"}}}, 
}});
table.insert(enemies, {tag="Eolevan Minion", scin="skeletarcher", hp=90, hpadd=9, minion=1, demon=3, cards={{dmg=3}}});

for i=1,#enemies do
	local enemy = enemies[i];
	if(enemy.ini)then
		for j=1,#enemy.ini do
			local card = enemy.ini[j];
			if(card.tag==nil)then
				card.tag = enemy.tag..' '.."start"..j;
			end
		end
	end
	if(enemy.cards)then
		for j=1,#enemy.cards do
			local card = enemy.cards[j];
			if(card.tag==nil)then
				card.tag = enemy.tag..' '.."card"..j;
			end
		end
	end
end

function _G.getEnemyObjByTag(eid)
	table.shuffle(enemies);
	for i=1,#enemies do
		if(enemies[i].tag == eid)then
			return enemies[i];
		end
	end
	return nil
end
function _G.getEnemySquadByTag(tag)
	local lists = {parties, elites, bosses};
	for l=1,#lists do
		local list = lists[l];
		for i=1,#list do
			if(list[i].tag==tag)then
				return list[i];
			end
		end
	end
end