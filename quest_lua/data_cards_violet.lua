-- notes:
-- новая карта если на враге слабость - то получить силу

conditions.masochism = {event="dmg", play={range="self", draw=1}};


table.insert(cards, {tag="Choker",			class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=0, ifEnemy={condition="charm", play={range='enemy', dmg=10}}, 
																					onUpgrade={ifEnemy={condition="charm", play={range='enemy', dmg=14}}}});	
table.insert(cards, {tag="Crippling Blow",	class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=7, vulnerable=1, onUpgrade={dmg=12}});	
table.insert(cards, {tag="Hate Spike",		class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=0, range="enemy", dmg=4, charm=1, onUpgrade={dmg=6, charm=2}});	
table.insert(cards, {tag="Berserker Rage",	class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", strX=0, missingHP={dmg=1, val=1}, exhaust=true, harm=3, onUpgrade={harm=2}});		
table.insert(cards, {tag="Flame Blow",		class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=8, onUse=onUseDiscardOne, onUpgrade={dmg=11}});	
table.insert(cards, {tag="Leash",			class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemies", dmg=3, onUpgrade={energy=0, dmg=5}, ifEnemy={condition="charm", play={range='self', energyAdd=1}}});	
table.insert(cards, {tag="Combo Blow",		class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=6, addDmgByCard={"Blow", 4}, onUpgrade={addDmgByCard={"Blow", 6}}});		
table.insert(cards, {tag="Deceptive Blow",	class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=9, weak=1, onUpgrade={dmg=12, weak=2}});	
table.insert(cards, {tag="Overextend",		class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=15, drawless=3, onUpgrade={dmg=20, drawless=2}});	
table.insert(cards, {tag="Cruel Intentions",class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=x,	range="enemies", dmg=4, charm=1, onUpgrade={dmg=6}});	
table.insert(cards, {tag="Blind Kick",		class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=1,	range="rnd", dmg=8, onUpgrade={dmg=11}});	
table.insert(cards, {tag="Vertigo",			class="violet",	rarity=1, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=3, times=3, onUpgrade={dmg=5}});	
	
table.insert(cards, {tag="Slice and Dice",	class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=7, ifEnemy={condition="charm", play={range='enemy', dmg=7}}, onUpgrade={dmg=10, ifEnemy={condition="charm", play={range='enemy', dmg=10}}}});
table.insert(cards, {tag="Purify with Fire",class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=8, onUse={action="discard", target="hand", filter={"ctype", CTYPE_STATUS, true}}, onUpgrade={dmg=10, onUse={action="discard", target="hand", amount=2, filter={"ctype", CTYPE_STATUS, true}}}});
table.insert(cards, {tag="Heaven or Hell",	class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=50, harm=10, exhaust=true, onUpgrade={dmg=70}});
table.insert(cards, {tag="Half Life",		class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=10, ifEnemy={hpLess=50, play={range="enemy", dmg=10}}, onUpgrade={dmg=12, ifEnemy={hpLess=50, play={range="enemy", dmg=12}}}});	
table.insert(cards, {tag="Scythe Dance",	class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=5, dmgByEnemiesCount=5, onUpgrade={dmg=6, dmgByEnemiesCount=9}});--Deal 5(8)+X damage to enemy, where X - number of enemies		
table.insert(cards, {tag="Steel Fury",		class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=x,	range="enemies", dmg=3, ifEnemy={condition="charm", play={range='enemy', dmg=3}}, onUpgrade={dmg=5, ifEnemy={condition="charm", play={range='enemy', dmg=5}}}});
table.insert(cards, {tag="Blow a Kiss",		class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=5, ifEnemy={condition="charm", play={range='self', energyAdd=1, draw=1}}, onUpgrade={dmg=7}});
table.insert(cards, {tag="Reposte",			class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=2,	range="enemy", dmg=12, armor=5, onUpgrade={dmg=15, armor=8}});		
table.insert(cards, {tag="Surprise Attack",	class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=2,	range="enemies", dmg=12, onUpgrade={dmg=16}});		
table.insert(cards, {tag="Flay",			class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=14, str=-1, strNext=1, onUpgrade={dmg=20}});	
table.insert(cards, {tag="To The Hilt",		class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=1,	range="enemy", dmg=9, ifEnemy={condition="weak", play={range='enemy', str=-1}}, onUpgrade={dmg=12, ifEnemy={condition="weak", play={range='enemy', str=-2}}}});	
table.insert(cards, {tag="Swift Draw",		class="violet",	rarity=2, ctype=CTYPE_ATTACK, energy=2,	range="enemy", dmg=10, onUse={action="change", target="hand", filter={"ctype", CTYPE_ATTACK, true}, changePick={energyTemp=0}, amount=1}, onUpgrade={dmg=15, onUse={action="change", target="hand", filter={"ctype", CTYPE_ATTACK, true}, changePick={energyTemp=0}, amount="all"}}});	
	
table.insert(cards, {tag="Sad Ending",		class="violet",	rarity=3, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=0, exhaust=true, ifEnemy={condition="charm", val=1, play={range="enemy", dmg=50}}, onUpgrade={energy=1}});
table.insert(cards, {tag="Precision",		class="violet",	rarity=3, ctype=CTYPE_ATTACK, energy=2,	range="enemy", dmg=0, hand={action="discard", ctype=CTYPE_ATTACK, value=false, onCount={dmg=6}}, onUpgrade={hand={action="discard", ctype=CTYPE_ATTACK, value=false, onCount={dmg=8}}}});		
table.insert(cards, {tag="Redeemer",		class="violet",	rarity=3, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=0, strX=0, times=2, dmgByAttrFromTarget="charm", once={range="enemy", nulify="charm"}, onUpgrade={energy=1, times=3}});		
-- table.insert(cards, {tag="Bioforge",		class="violet",	rarity=3, ctype=CTYPE_ATTACK, energy=0,	range="enemy", dmg=4, energyAdd=1, onUpgrade={dmg=6, energyAdd=2}}); -- energyAdd works only on my self!
table.insert(cards, {tag="Final Hour",		class="violet",	rarity=3, ctype=CTYPE_ATTACK, energy=3, range="enemy", drawToDmg=1, onUpgrade={energy=2}});

table.insert(cards, {tag="Lure",			class="violet",	rarity=0, ctype=CTYPE_SKILL, energy=0, range="enemy", charm=3, onUpgrade={energy=0, charm=4}});
table.insert(cards, {tag="Hide and Wait",	class="violet",	rarity=1, ctype=CTYPE_SKILL, energy=1, range="enemy", armor=6, charm=3, onUpgrade={armor=9}});	
table.insert(cards, {tag="Retreat",			class="violet",	rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", armor=4, draw=1, onUpgrade={armor=6}});		
table.insert(cards, {tag="Even the Odds",	class="violet",	rarity=1, ctype=CTYPE_SKILL, energy=2, range="self", armor=6, once={range="enemies", armor=2}, onUpgrade={armor=8, once={range="enemies", armor=4}}});	
table.insert(cards, {tag="Magma Veins",		class="violet",	rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", energyAdd=1, onUse=onUseDiscardOne, onUpgrade={energyAdd=2}});	
table.insert(cards, {tag="Corrupted Chain",	class="violet",	rarity=1, ctype=CTYPE_SKILL, energy=0, range="enemy", dmg=4, ifEnemy={intend="dmg", play={range="enemy", weak=2}}, onUpgrade={innate=true}});
table.insert(cards, {tag="Dance In Flames",	class="violet",	rarity=1, ctype=CTYPE_SKILL, energy=2, range="enemies", vulnerable=2, weak=2, onUpgrade={vulnerable=4, weak=4}});
table.insert(cards, {tag="Extra Heart",		class="violet",	rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", draw=1, ifDraw={ctype=CTYPE_ATTACK, range='self', armor=3}, onUpgrade={ifDraw={ctype=CTYPE_ATTACK, range='self', armor=5}}});
table.insert(cards, {tag="Hidden Weapon",	class="violet",	rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", exhaust=true, create={count=1, attr="ctype", val=CTYPE_POWER, energyTemp=0}, onUpgrade={energy=0}});		

table.insert(cards, {tag="Battle Meditation",class="violet",rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", nextTurn={range="self", energyAdd=2}, onUpgrade={nextTurn={range="self", energyAdd=3}}, exhaust=true});
table.insert(cards, {tag="Preparations",	class="violet",	rarity=2, ctype=CTYPE_SKILL, energy=1, range="enemies", ifEnemy={intend="dmg", play={range="self", armor=8}}, onUpgrade={ifEnemy={intend="dmg", play={range="self", armor=12}}}});
table.insert(cards, {tag="Second Skin",		class="violet",	rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", armor=7, onUse={action="plus", target="armor", val=3}, onUpgrade={onUse={action="plus", target="armor", val=5}}});	
table.insert(cards, {tag="Chains of Love",	class="violet",	rarity=2, ctype=CTYPE_SKILL, energy=1, range="enemy", charmMlt=2, exhaust=true, onUpgrade={exhaust=null}});
table.insert(cards, {tag="Magic Wall",		class="violet",	rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", magicwall=4, onUpgrade={magicwall=6}});		
table.insert(cards, {tag="Seduction",		class="violet",	rarity=2, ctype=CTYPE_SKILL, energy=1, range="enemies", charm=3, onUpgrade={charm=4}});
table.insert(cards, {tag="Delayed Pleasure",class="violet",	rarity=2, ctype=CTYPE_SKILL, energy=2, range="self", nextTurn={charmdouble=1}, onUpgrade={energy=1}});	
table.insert(cards, {tag="Unlimited Desires",class="violet",rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", create={count=2, attr="ctype", val=CTYPE_SKILL}, onUpgrade={energy=0}});
table.insert(cards, {tag="Strange Exchange",class="violet",	rarity=2, ctype=CTYPE_SKILL, energy=0, range="self", onUse=onUseDiscardOne, energyAdd=1, onUpgrade={onUse=onUseDiscardTwo, energyAdd=2}});
table.insert(cards, {tag="Love for Sale",	class="violet",	rarity=2, ctype=CTYPE_SKILL, energy=x, range="enemy", charm=1, onUpgrade={extraX=2}}); -- too low!

table.insert(cards, {tag="Blind Fury",		class="violet",	rarity=3, ctype=CTYPE_SKILL, energy=0, range="self", str=3, strNext=-3, silenceskills=1, onUpgrade={str=5, strNext=-5}});
table.insert(cards, {tag="Full Offense",	class="violet",	rarity=3, ctype=CTYPE_SKILL, energy=2, range="self", onUpgrade={energy=1}, onUse={action="change", target="hand", filter={"ctype", CTYPE_ATTACK, true}, changePick={energyTemp=0}, amount="all"}});	
table.insert(cards, {tag="Copycat",			class="violet",	rarity=3, ctype=CTYPE_SKILL, energy=1, range="self", doubleskill=1, onUpgrade={doubleskill=2}});
table.insert(cards, {tag="Boiling Blood",	class="violet",	rarity=3, ctype=CTYPE_SKILL, energy=1, range="self", harm=2, armor=6, missingHP={attr="armor", val=0.4}, onUpgrade={harm=1, armor=10}});	
table.insert(cards, {tag="All Included",	class="violet",	rarity=3, ctype=CTYPE_SKILL, energy=2, range="enemy", charm=2, weak=2, vulnerable=2, exhaust=true, onUpgrade={charm=4, weak=4, vulnerable=4}});	
table.insert(cards, {tag="Turn the Tables",	class="violet",	rarity=3, ctype=CTYPE_SKILL, energy=1, range="enemy", str=-3, strNext=3, onUpgrade={energy=0}, once={range="self", str=3, strNext=-3}});	
table.insert(cards, {tag="Diamond Scythe",	class="violet",	rarity=3, ctype=CTYPE_SKILL, energy=1, range="enemy", weak=99, exhaust=true, onUpgrade={energy=0}});
table.insert(cards, {tag="Purgatory",		class="violet",	rarity=3, ctype=CTYPE_SKILL, energy=1, range="enemy", exhaust=true, onUpgrade={energy=0}, nulify="str"});
table.insert(cards, {tag="Made in Abyss",	class="violet",	rarity=3, ctype=CTYPE_SKILL, energy=3, range="enemy", vulnerable=2, onUse={action="upgrade", target="all", filter={"ctype", CTYPE_ATTACK, true}, amount="all"}, onUpgrade={vulnerable=4}});

table.insert(cards, {tag="Masochism",		class="violet",	rarity=1, ctype=CTYPE_POWER, energy=0, range="self", masochism=1, onUpgrade={masochism=2}});
table.insert(cards, {tag="Obsession",		class="violet",	rarity=2, ctype=CTYPE_POWER, energy=1, range="self", charmmin=1, onUpgrade={energy=0}});
table.insert(cards, {tag="Crown of Thorns",	class="violet",	rarity=2, ctype=CTYPE_POWER, energy=1, range="self", charmtodmg=3, onUpgrade={charmtodmg=4}});
table.insert(cards, {tag="Hell Pact",		class="violet",	rarity=2, ctype=CTYPE_POWER, energy=1, range="self", drawperenemy=1, onUpgrade={innate=true}});		
table.insert(cards, {tag="Dread",			class="violet",	rarity=2, ctype=CTYPE_POWER, energy=1, range="self", dread=2, onUpgrade={energy=0}});	
table.insert(cards, {tag="Unfair Play",		class="violet",	rarity=2, ctype=CTYPE_POWER, energy=1, range="self", drawondebuff=1, onUpgrade={energy=0}});	
table.insert(cards, {tag="Born in Flames",	class="violet",	rarity=2, ctype=CTYPE_POWER, energy=1, range="self", discardstatuses=1, onUpgrade={energy=0}});
table.insert(cards, {tag="Abyssal Scream",	class="violet",	rarity=2, ctype=CTYPE_POWER, energy=2, range="self", abyssalscream=2, onUpgrade={energy=1, abyssalscream=3}});
table.insert(cards, {tag="Carnival",		class="violet",	rarity=3, ctype=CTYPE_POWER, energy=3, range="self", charmtoenergy=1, onUpgrade={innate=true}});		
table.insert(cards, {tag="Devil Friendship",class="violet",	rarity=3, ctype=CTYPE_POWER, energy=2, range="self", devilfriendship=2, onUpgrade={devilfriendship=4}});
table.insert(cards, {tag="Soul Eater",		class="violet",	rarity=3, ctype=CTYPE_POWER, energy=2, range="self", souleater=4, onUpgrade={souleater=6}});
table.insert(cards, {tag="Obsidian Skin",	class="violet",	rarity=3, ctype=CTYPE_POWER, energy=2, range="self", udmgtoarmor=6, onUpgrade={energy=1, udmgtoarmor=8}});	
table.insert(cards, {tag="Supercharge",		class="violet",	rarity=3, ctype=CTYPE_POWER, energy=3, range="self", supercharge=1, onUpgrade={energy=2}});
table.insert(cards, {tag="Reincarnation",	class="violet",	rarity=3, ctype=CTYPE_POWER, energy=2, range="self", revive=5, onUpgrade={revive=10}});	
table.insert(cards, {tag="One Versus All",	class="violet",	rarity=3, ctype=CTYPE_POWER, energy=1, range="self", oneversusall=2, onUpgrade={oneversusall=3}});	
table.insert(cards, {tag="Gathering Storm",	class="violet",	rarity=3, ctype=CTYPE_POWER, energy=3, range="self", charmstorm=1, onUpgrade={energy=2}});