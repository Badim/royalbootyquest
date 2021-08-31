table.insert(cards, {tag="Shiv",			class="none", rarity=0, ctype=CTYPE_ATTACK, range='enemy', dmg=3, dmgByAttrFromSource="accuracy", energy=0, exhaust=true, onUpgrade={dmg=6}});
table.insert(cards, {tag="Bite",			class="none", rarity=0, ctype=CTYPE_ATTACK, range='enemy', dmg=7, heal=2, energy=1});
table.insert(cards, {tag="Ritual Dagger",	class="none", rarity=0, ctype=CTYPE_ATTACK, range='enemy', dmg=9, energy=1, exhaust=true, onKill={dmg=3, permanent=true}, onUpgrade={onKill={dmg=4, permanent=true}}});

table.insert(cards, {tag="Avito Help", 		class="none", rarity=0, ctype=CTYPE_SKILL, energy=1, range="self", armor=1, exhaust=true, onUse={action="plus", target="armor", val=2, permanent=true}, onUpgrade={onUse={action="plus", target="armor", val=3, permanent=true}}});

table.insert(cards, {tag="Dramatic Entrance",class="none", rarity=1, ctype=CTYPE_ATTACK, range='enemies', dmg=6, energy=0,  innate=true, exhaust=true});
table.insert(cards, {tag="Flash of Steel",	class="none", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=3, draw=1, energy=0, onUpgrade = {dmg=6}});
table.insert(cards, {tag="Mind Blast",		class="none", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=0, deckToDmg=1, energy=2, innate=true, onUpgrade = {energy=1}});
table.insert(cards, {tag="Swift Strike",	class="none", rarity=1, ctype=CTYPE_ATTACK, range='enemy', dmg=5, energy=0});

table.insert(cards, {tag="Apparition",		class="none", rarity=0, ctype=CTYPE_SKILL, range='self', energy=1, intangible=1, exhaust=true, ethereal=true, onUpgrade={energy=0}});
table.insert(cards, {tag="JAX",				class="none", rarity=0, ctype=CTYPE_SKILL, range='self', harm=3, str=2, energy=0, exhaust=true});
table.insert(cards, {tag="Bandage",		class="none", rarity=1, ctype=CTYPE_SKILL, range='self', heal=4, energy=0, exhaust=true, onUpgrade = {heal=6}});
table.insert(cards, {tag="Blind",			class="none", rarity=1, ctype=CTYPE_SKILL, range='enemy', weak=2, energy=0});
table.insert(cards, {tag="Trip",			class="none", rarity=1, ctype=CTYPE_SKILL, range='enemy', vulnerable=2, energy=0});
table.insert(cards, {tag="Dark Shackles",	class="none",rarity=1, ctype=CTYPE_SKILL, range='enemy', str=-9, strNext=9, energy=0});
table.insert(cards, {tag="Deep Breath",		class="none", rarity=1, ctype=CTYPE_SKILL, range='self', draw=1, energy=0, shuffle=true});
table.insert(cards, {tag="Finesse",			class="none", rarity=1, ctype=CTYPE_SKILL, range='self', armor=2, draw=1, energy=0});
table.insert(cards, {tag="Good Instincts",	class="none", rarity=1, ctype=CTYPE_SKILL, range='self', armor=4, energy=0});
table.insert(cards, {tag="Jack Of All Trades",class="none", rarity=1, ctype=CTYPE_SKILL, range='self', energy=0, exhaust=true, create={count=1, attr="class", val="none"}, onUpgrade={create={count=2, attr="class", val="none"}}});
table.insert(cards, {tag="Madness",			class="none", rarity=1, ctype=CTYPE_SKILL, range='self', energy=1, exhaust=true, onUse={action="change", target="hand", filter={"ctype", "all", false}, amount="rnd", changePick={energy=0}}});
table.insert(cards, {tag="Panacea",			class="none", rarity=1, ctype=CTYPE_SKILL, range='self', artifact=1, energy=0, exhaust=true});
table.insert(cards, {tag="Purity",			class="none", rarity=1, ctype=CTYPE_SKILL, range='self', energy=0, exhaust=true, onUse={action="exhaust", target="hand", filter={"ctype", "all", false}, amount=3}});
table.insert(cards, {tag="Secret Weapon",	class="none",rarity=2, ctype=CTYPE_SKILL, range='self', energy=0, exhaust=true, onUse={action="rehand", target="deck", filter={"ctype", CTYPE_ATTACK, true}}});
table.insert(cards, {tag="Apotheosis",		class="none", rarity=2, ctype=CTYPE_SKILL, range='self', energy=2, exhaust=true, onUse={action="upgrade", target="all", filter={"ctype", "all", false}, amount="all"}});	
table.insert(cards, {tag="Enlightenment",	class="none", rarity=2, ctype=CTYPE_SKILL, range='self', energy=0, onUse={action="change", target="hand", filter={"ctype", "all", false}, amount="all", changePick={energyTemp=1}}, onUpgrade = {onUse={action="change", target="hand", filter={"ctype", "all", false}, amount="all", changePick={energy=1}}}});
table.insert(cards, {tag="Master Of Strategy",	class="none", rarity=2, ctype=CTYPE_SKILL, range='self', draw=3, energy=0, exhaust=true});	
table.insert(cards, {tag="Secret Technique",class="none", rarity=2, ctype=CTYPE_SKILL, range='self', energy=0, exhaust=true, onUse={action="rehand", target="deck", filter={"ctype", CTYPE_SKILL, true}}});
table.insert(cards, {tag="Thinking Ahead",	class="none", rarity=2, ctype=CTYPE_SKILL, range='self', draw=2, energy=0, exhaust=true, onUse={action="redeck", target="hand", filter={"ctype", "all", false}}});
table.insert(cards, {tag="Transmutation",	class="none", rarity=2, ctype=CTYPE_SKILL, range='self', energy=X, exhaust=true, create={count=1, attr="class", val="none"}, onUpgrade = {create={count=1, attr="class", val="none", upgrade=true}}});

table.insert(cards, {tag="Forgetting to Aim",	class="none", rarity=3, ctype=CTYPE_SKILL, energy=2, range="enemy", ignore="dmg", onUpgrade={energy=1}, exhaust=true});-- Badim Card =)

table.insert(cards, {tag="Sadistic Nature",	class="none", rarity=2, ctype=CTYPE_POWER, range='self', sadistic=3, energy=0});
table.insert(cards, {tag="Panache",			class="none", rarity=2, ctype=CTYPE_POWER, range='self', panache=10, energy=0});
table.insert(cards, {tag="Magnetism",		class="none", rarity=2, ctype=CTYPE_POWER, range='self', magnetism=1, energy=2, onUpgrade={energy=1}});


table.insert(cards, {tag="Wound",		class="negative", rarity=1, ctype=CTYPE_STATUS,  range='self', energy=0, playable="unplayable"});
table.insert(cards, {tag="Burn",		class="negative", rarity=1, ctype=CTYPE_STATUS,  range='self', energy=0, playable="unplayable", onTurn={dmg=2, range='self', strX=0}, onUpgrade={dmg=4}});
table.insert(cards, {tag="Dazed",		class="negative", rarity=1, ctype=CTYPE_STATUS,  range='self', energy=0, ethereal=true, playable="unplayable"});

table.insert(cards, {tag="Slimed",		class="negative", rarity=1, ctype=CTYPE_STATUS,  range='self', energy=1, exhaust=true});
table.insert(cards, {tag="Void",		class="negative", rarity=1, ctype=CTYPE_STATUS,  range='self', energy=0, playable="unplayable", exhaust=true, onDraw={action="play", play={energyAdd=-1, range="self"}}});

table.insert(cards, {tag="Clumsy",		class="negative", rarity=1, ctype=CTYPE_CURSE,  range='self', energy=0, ethereal=true, playable="unplayable"});
table.insert(cards, {tag="Injury",		class="negative", rarity=1, ctype=CTYPE_CURSE,  range='self', energy=0, playable="unplayable"});
table.insert(cards, {tag="Decay",		class="negative", rarity=1, ctype=CTYPE_CURSE,  range='self', energy=0, playable="unplayable", onTurn={dmg=2, range='self', strX=0}});
table.insert(cards, {tag="Doubt",		class="negative", rarity=1, ctype=CTYPE_CURSE,  range='self', energy=0, playable="unplayable", onTurn={weak=1, range='self'}});
table.insert(cards, {tag="Parasite",	class="negative", rarity=1, ctype=CTYPE_CURSE,  range='self', energy=0, playable="unplayable"});
table.insert(cards, {tag="Normality",	class="negative", rarity=1, ctype=CTYPE_CURSE,  range='self', energy=0, playable="unplayable", onEvent={event="played_cards_3", play={endTurn=true}}});
table.insert(cards, {tag="Regret",		class="negative", rarity=1, ctype=CTYPE_CURSE,  range='self', energy=0, playable="unplayable", onTurn={range='self', harmByAttr="card_type_all_hand", dtype=DTYPE_TRUE}});

table.insert(cards, {tag="Necronomicurse",class="negative",rarity=0,ctype=CTYPE_CURSE,  range='self', energy=0, playable="unplayable", escape=false});


-- table.insert(cards, {tag="Immolate Old",	class="old", rarity=3, ctype=CTYPE_ATTACK,range='enemies', energy=1, onUse={action="exhaust", target="hand", filter={"ctype", "all", false}, onNegativeCard={dmg=10, range='enemies'}}}); -- old