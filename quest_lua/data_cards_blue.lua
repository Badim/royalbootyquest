-- pain - сделать что нибуть с болью - например что каждые 10 - сьдаються в лечение, и дамагу от боли сделать - получиться рандом тогда по канону героя

table.insert(cards, {tag="Eastern Candy",	class="blue",rarity=1, ctype=CTYPE_ATTACK, range='rnd', dmg=3, dmgRnd=4, energy=1, 
	rnd={50, {range='self', poison=1, poisonRnd=2}}, onUpgrade={rnd={50, {range='enemy', poison=1, poisonRnd=2}}}});
table.insert(cards, {tag="Winning",			class="blue", rarity=1, ctype=CTYPE_ATTACK, range='enemy', energy=1, rndCards={{range="enemy", dmg=1, dmgRnd=5}, {range="self", heal=1, healRnd=5}}});
table.insert(cards, {tag="Chain Lightning",	class="blue", rarity=1,ctype=CTYPE_ATTACK, range='rndmiss', dmg=1, dmgRnd=4, harm=1, harmRnd=2, energy=1, onUpgrade={dmg=2, dmgRnd=5}});
table.insert(cards, {tag="Infinite Rage",	class="blue", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=2, dmgRnd=4, energy=1, retain=true, onUpgrade={dmg=3, dmgRnd=9}});
table.insert(cards, {tag="Do or Die",		class="blue", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=12, energy=0, rnd={50, {range="enemy", harm=6}}, onUpgrade={dmg=16, rnd={50, {range="enemy", harm=4}}}});
table.insert(cards, {tag="Corrosion",		class="blue", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=0, dmgByAttrFromTarget="armor", energy=1, poison=4, onUpgrade={poison=6}});
table.insert(cards, {tag="Chaos Clash",		class="blue", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=5, energy=3, vamp=1, rnd={50, {range='enemy', dmg=5, vamp=1}}, onUpgrade={energy=2}});
table.insert(cards, {tag="Counterstrike",	class="blue", armor=0, rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=1, dmgRnd=2, energy=0, playable="harmed", harmToBlock=1, onUpgrade={harmToBlock=2, dmg=2}});
table.insert(cards, {tag="Counterknowlege",	class="blue", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=1, dmgRnd=2, energy=0, draw=1, drawRnd=2, playable="harmed", onUpgrade={dmg=2, draw=2}});
table.insert(cards, {tag="Chaotic Bargain",	class="blue", rarity=1,ctype=CTYPE_ATTACK, range='enemy', dmg=1, dmgRnd=9, energy=2, onUse={action="redeck", target="draw", filter={"ctype", "all", false}}, onUpgrade={dmg=5, dmgRnd=5, energy=1}});
table.insert(cards, {tag="Shugardeath",		class="blue", rarity=2, ctype=CTYPE_ATTACK, range='rndmiss', dmg=4, dmgRnd=6, energy=3, rnd={50, {range='self', poison=1, poisonRnd=2}}, onUpgrade={energy=2}});
table.insert(cards, {tag="Blind Attack",	class="blue", rarity=2, ctype=CTYPE_ATTACK, range='rnd', dmg=5, dmgRnd=3, energy=2, onUpgrade={dmg=9}, retain=true});
table.insert(cards, {tag="Mediocrity Art",	class="blue", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=7, dmgRnd=7, energy=2, energyAdd=1, energyAddRnd=1, harm=1, harmRnd=5, onUpgrade={harmRnd=2, energyAddRnd=2}});
table.insert(cards, {tag="Possessed Strike",class="blue", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=15, dmgRnd=5, energy=4, discount="harmed", onUpgrade={dmg=20, dmgRnd=10}});
table.insert(cards, {tag="Cauterization",	class="blue", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=1, dmgRnd=1, energy=x, heal=1, healRnd=1, onUpgrade={dmgRnd=3, healRnd=2}});
table.insert(cards, {tag="Dangerous Game",	class="blue", rarity=2, ctype=CTYPE_ATTACK, range='enemy', dmg=10, dmgRnd=5, energy=1, innate=true, retain=true, exhaust=true, onUpgrade={dmg=15}, rnd={10, {hpleft=1, range='self'}}});
-- table.insert(cards, {tag="Abscenent Challenge",	class="blue", rarity=3, ctype=CTYPE_ATTACK, range='enemy', energy=2, rndCards={{range='enemy', hpPer=0.5}, {range='enemy', hpPer=2}}, onUpgrade={energy=1}});
table.insert(cards, {tag="Energy Drink",		class="blue", rarity=3, ctype=CTYPE_ATTACK, range='enemy', energyAdd=1, energyAddRnd=5, dmg=2, dmgRnd=12, energy=3, onUpgrade={energy=2, dmg=3, dmgRnd=18}});
table.insert(cards, {tag="Uncontrolled Power",	class="blue", rarity=3, ctype=CTYPE_ATTACK, range='rnd', dmg=15, dmgRnd=10, energy=3, weak=1, weakRnd=2, onUpgrade={energy=2, weak=2, dmg=20}});
-- 10 more attacks

table.insert(cards, {tag="Crazy Wape",		class="blue", rarity=0, ctype=CTYPE_SKILL, range='rnd', poison=2, poisonRnd=6, energy=0, onUpgrade={poison=3, poisonRnd=9}});
table.insert(cards, {tag="Paper Shield",	class="blue", rarity=1, ctype=CTYPE_SKILL, range="self", energy=1, armor=1, armorRnd=4, onUpgrade={armor=3, armorRnd=2}});
table.insert(cards, {tag="Spiked Shield",	class="blue", rarity=1, ctype=CTYPE_SKILL, range="self", armor=6, armorRnd=6, energy=1, rnd={20, {range="self", harm=1, harmRnd=2, msg="wrong_side_dumbass"}}, onUpgrade={armor=9}});
table.insert(cards, {tag="Deal with Death", class="blue", rarity=1, ctype=CTYPE_SKILL, range="self", draw=1, drawRnd=2, harm=1, harmRnd=2, energy=1, onUpgrade={heal=1, healRnd=2, harm=null, drawRnd=null}});
table.insert(cards, {tag="Night Studies", 	class="blue", rarity=1, ctype=CTYPE_SKILL, range="self", energy=1, rndCards={{range="self", draw=1}, {range="self", draw=2}, {range="self", draw=3, harm=1, harmRnd=2}}, onUpgrade={rndCards={{range="self", draw=1}, {range="self", draw=2}, {range="self", draw=3, heal=1, healRnd=2}}}});
table.insert(cards, {tag="Recitation", 		class="blue", rarity=1, ctype=CTYPE_SKILL, range="self", energy=0, energyAdd=1, energyAddRnd=2, harm=0, harmRnd=1, onUpgrade={energyAdd=2}});
table.insert(cards, {tag="Cantrip", 		class="blue", rarity=1, ctype=CTYPE_SKILL, range="self", energy=1, draw=2, rnd={50, {range="self", draw=2}}, onUpgrade={energy=0}});
table.insert(cards, {tag="Mathematician", 	class="blue", rarity=1, ctype=CTYPE_SKILL, range="enemies", energy=1, armor=3, ethereal=true, heal=1, onUpgrade={heal=2, armor=4}});
table.insert(cards, {tag="Complex Defence",	class="blue", rarity=2, ctype=CTYPE_SKILL, 	range='self', armor=10, armorRnd=5, energy=2, weak=1, weakRnd=4, onUpgrade={armorRnd=10, weakRnd=2}});
table.insert(cards, {tag="Dubious Justice",	class="blue", rarity=2, ctype=CTYPE_SKILL, 	range='enemy', armor=5, armorRnd=5, energy=2, rndCards={{range='self', armor=5, armorRnd=5}, {range='enemy', armor=5, armorRnd=5}}, onUpgrade={armor=10, armorRnd=10}});
table.insert(cards, {tag="Useless Knowledge",class="blue",rarity=2, ctype=CTYPE_SKILL,	range='self', energy=1, hand={action="discard", ctype='all', value=false, onCount={armor=4}}, onUpgrade={hand={action="discard", ctype='all', value=false, onCount={armor=6}}}});
table.insert(cards, {tag="Playing with Fire",class="blue",rarity=2, ctype=CTYPE_SKILL,	range='self', energy=0, playable="harmed", dex=2, onUpgrade={dex=3}});
table.insert(cards, {tag="Stop this Madness",class="blue",rarity=2, ctype=CTYPE_SKILL,	range='enemies', energy=0, playable="harmed", str=-1, dex=-1, exhaust=true, onUpgrade={str=-1, dex=-1, exhaust=null}});
-- changed! -- table.insert(cards, {tag="Dynamic Defence",	class="blue", rarity=2, ctype=CTYPE_SKILL,	range='self', energy=2, dynamicdefence=2, onUpgrade={dynamicdefence=3}});
-- table.insert(cards, {tag="TacticianBlue",	class="blue", rarity=2, ctype=CTYPE_SKILL,	energy=3, range="enemy", exhaust=true, rnd={50, {range="enemy", interrupt=1}}, onUpgrade={interrupt=1, rnd=null}});
table.insert(cards, {tag="Poison Blood",	class="blue", rarity=2, ctype=CTYPE_SKILL, 	energy=1, range='enemy', ifEnemy={condition="poison", play={range="enemy", nulify="poison", heal=4}}, exhaust=true, onUpgrade={energy=0}})
-- 16 more skills

conditions.interrupt = {event="turn", expire=1, debuff=true, expireAtEnd=true}; -- blue hero
conditions.genie = {event="turn", play={str=1, strRnd=2, harm=0, harmRnd=2, range='self'}};
conditions.shuffling = {event="turn", play={draw=3, discard=2}};
conditions.wobblyunion = {event="turn", play={rndCards={{heal=2, healRnd=3}, {harm=1, harmRnd=2}}}};
conditions.thereisnoregret = {event="turn", play={range="rnd", dmg=1, dmgRnd=6}};
conditions.cascadingrecharge = {event="turn", play={range="enemy", dmg=1}, expire=-1};
conditions.bloodgift = {event="harm", play={range="rnd", poison=1}};

table.insert(cards, {tag="Concentration", 		class="blue", rarity=1, ctype=CTYPE_POWER, range="self", energy=2, genie=3, onUpgrade={genie=4}});
table.insert(cards, {tag="Shuffling", 			class="blue", rarity=1, ctype=CTYPE_POWER, range="self", energy=1, shuffling=1, onUpgrade={energy=0}});
table.insert(cards, {tag="Wobbly Union", 		class="blue", rarity=1, ctype=CTYPE_POWER, range="self", energy=0, wobblyunion=1, onUpgrade={innate=true}});
table.insert(cards, {tag="There is no Regret",	class="blue", rarity=1, ctype=CTYPE_POWER, range="self", energy=2, thereisnoregret=1, onUpgrade={innate=true}});
table.insert(cards, {tag="Cascading Recharge",	class="blue", rarity=2, ctype=CTYPE_POWER, range="self", energy=3, cascadingrecharge=1, weak=1, weakRnd=2, onUpgrade={innate=true}});
table.insert(cards, {tag="Blood Gift",			class="blue", rarity=2, ctype=CTYPE_POWER, range="self", energy=1, bloodgift=4, onUpgrade={energy=0}});
table.insert(cards, {tag="Impossible Order",	class="blue", rarity=2, ctype=CTYPE_POWER, 	range='self', str=1, strRnd=4, energy=2, onUpgrade={str=2, strRnd=5}});
-- 5 more powers

