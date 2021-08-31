-- Painful Strike	Common	Attack	2(1)	Deal 5(9) Damage. Create Doll of Pain
-- Hopeless Strike	Common	Attack	2(1)	Deal 6(10) Damage. Create Doll of Hope
-- Rotten Strike	Common	Attack	2(1)	Deal 7(11) Damage. Create Doll of Decay
conditions.dollofpain = {voodoo=true, expire=1, event="turnEnd", play={tag="dollofpain", range="rnd", dmg=1}, expireAtEnd=false, hinted=true, target="source"};
conditions.dollofhope = {voodoo=true, expire=1, event="turnEnd", play={range="self", heal=1}, expireAtEnd=false, hinted=true, target="source"};
conditions.dollofdecay= {voodoo=true, expire=1, event="turnEnd", play={range="rnd", str=-1, strNext=1}, expireAtEnd=false, hinted=true, target="source"};
conditions.dollofacid = {voodoo=true, expire=1, event="turn", play={range="rnd", poison=1}, expireAtEnd=false, hinted=true, target="source"};

conditions.dollinthesleeve = {event="turn", play={rndCards={
{addCards={hand={"Doll of Pain"}}}, 
{addCards={hand={"Doll of Decay"}}}, 
{addCards={hand={"Doll of Hope"}}},
{addCards={hand={"Doll of Acid"}}},
}}};
-- "Механика: Дебафер, создает куклы. Кукла напрямую не участвует в бою, 
-- но используется картами для нанесения урона, наложения дебафов, лечения.
-- Максимально может быть 3 куклы.

-- vulnerabilityshroud - переделать в куклу!

-- Doll of Pain: Deal 3+Hatred Damage to random enemy at the end of player turn
-- Doll of Hope: Heal 1+Hatred HP at the end of player turn
-- Doll of Decay: Debuff 3+Hatred Strength to random enemy at the end of player turn (for 1 turn)
-- Doll of Acid - poison
-- Doll of Feedback - spike
-- нужны карты со спайком! 2-3 варианта - при получении дмг, каждый ход +1, и тп

-- -1 Hatred each turn"
-- Когда буду делать карты с выбор куклы - надо учитывать как то её силу, по идее.

table.insert(cards, {tag="Breath of Swamp",		class="voodoo", rarity=0, ctype=CTYPE_ATTACK, energy=0, range="enemy", poison=3, onUpgrade={poison=4}}); -- Apply 3(4) Poison
-- table.insert(cards, {tag="Damnation",			class="voodoo", rarity=0, ctype=CTYPE_ATTACK, energy=0, range="enemy", onUpgrade={}}); -- Execute Doll. Deal 7(9) Damage
table.insert(cards, {tag="Last Rite",			class="voodoo", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", onConditions={range="self", action="purge", attr="voodoo", val=true, onCount={range="enemy", dmg=10}}, onUpgrade={onConditions={range="self", action="purge", attr="voodoo", val=true, onCount={range="enemy", dmg=13}}}}); -- Execute all Dolls. Deal 10(13) for each Doll
table.insert(cards, {tag="Fates Call",			class="voodoo", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", onConditions={range="self", attr="voodoo", val=true, onCount={range="enemy", dmg=4}}, onUpgrade={onConditions={range="self", attr="voodoo", val=true, onCount={range="enemy", dmg=6}}}}); -- Deal 4(6) Damage for each Doll
table.insert(cards, {tag="Toxic Dolls",			class="voodoo", rarity=1, ctype=CTYPE_ATTACK, energy=0, range="enemy", onConditions={range="self", attr="voodoo", val=true, onCount={range="enemy", poison=2}}, onUpgrade={onConditions={range="self", attr="voodoo", val=true, onCount={range="enemy", poison=3}}}}); -- Apply 2(3) Poison for each Doll
table.insert(cards, {tag="Aftermath",			class="voodoo", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemies", dmg=0, ifEnemy={condition="poison", play={range="enemy", dmg=9}}, onUpgrade={ifEnemy={condition="poison", play={range="enemy", dmg=12}}}}); -- Deal 8(10) Damage for each enemy with Poison
-- table.insert(cards, {tag="Guillotine",			class="voodoo", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", onUpgrade={energy=0}}); -- Execute Doll. Deal Damage == Doll's Hatred
table.insert(cards, {tag="Purge",				class="voodoo", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=0, dmgByAttrFromTarget="poison", onUpgrade={nulify=null}, nulify="poison"}); -- Appy instant Damage equal Poison stacks on enemy. Remove Poison
table.insert(cards, {tag="Hatred Slash",		class="voodoo", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=9, onConditions={range="self", action="add", attr="voodoo", val=true, add=1}, onUpgrade={dmg=12, onConditions={range="self", action="add", attr="voodoo", val=true, add=2}}}); -- Deal 10(12) Damage. Add +2(+3) Hatred to each Doll 
table.insert(cards, {tag="Infected Blade",		class="voodoo", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=8, poison=3, onUpgrade={dmg=10, poison=4}}); -- Deal 8(10) Damage. Apply 3(4) Poison
table.insert(cards, {tag="Grim Mix",			class="voodoo", rarity=1, ctype=CTYPE_ATTACK, energy=X, range="enemy", poison=4, onUpgrade={poison=7}}); -- Apply 3(4) Poison X times
table.insert(cards, {tag="Shepherd of Souls",	class="voodoo", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=6, vulnerable=1, onUpgrade={dmg=9, vulnerable=2}}); -- Deal 6(9) Damage. Apply 1(2) Vulnerability
-- table.insert(cards, {tag="Soul Shackles",		class="voodoo", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", onUpgrade={}}); -- Execute Doll. Draw random Attack from your draw pile and play it free this turn
table.insert(cards, {tag="Painful Strike",		class="voodoo", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=5, dollofpain=4, onUpgrade={dmg=9, dollofpain=5}}); -- Deal 5(9) Damage. Create Doll of Pain
table.insert(cards, {tag="Hopeful Strike",		class="voodoo", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=6, exhaust=true, dollofhope=2, onUpgrade={dmg=9}}); -- Deal 6(10) Damage. Create Doll of Hope
table.insert(cards, {tag="Rotten Strike",		class="voodoo", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=8, dollofdecay=3, exhaust=true, onUpgrade={dmg=13, dollofdecay=4}});
table.insert(cards, {tag="Stranglethorns",		class="voodoo", rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemies", dmg=10, onUpgrade={dmg=14}}); -- Deal 10(14) Damage to ALL enemies.
table.insert(cards, {tag="Terrify",				class="voodoo", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", poison=6, ifEnemy={intend="dmg", play={range="enemy", weak=1}}, onUpgrade={poison=8, ifEnemy={intend="dmg", play={range="enemy", weak=2}}}, }); -- Apply 5(6) Poison. If the enemy intends to attack, apply 1(2) Weak
table.insert(cards, {tag="Tormented Soil",		class="voodoo", rarity=3, ctype=CTYPE_ATTACK, energy=3, range="enemies", dmg=25, onUpgrade={dmg=30}, exhaust=true}); -- Deal 25(30) Damage to ALL enemies.
-- table.insert(cards, {tag="Black Mark",			class="voodoo", rarity=2, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=9, lockon=2, onUpgrade={dmg=12}}); -- Deal 9(12) Damage. For the next 2 turns, Dolls target this enemy. #Lockon now works differently#
-- table.insert(cards, {tag="Eclipse",				class="voodoo", rarity=1, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=8, shuffle=true, onUpgrade={dmg=11}}); -- Deal 8(11) Damage. Appy 1 Agony
-- table.insert(cards, {tag="Twilight Assault",	class="voodoo", rarity=3, ctype=CTYPE_ATTACK, energy=2, range="enemies", dmg=7, shuffle=true, onUpgrade={energy=1, dmg=7}}); -- Deal 7(9) Damage and apply 1 Agony to ALL enemies
table.insert(cards, {tag="Midnight Ritual",		class="voodoo", rarity=3, ctype=CTYPE_ATTACK, energy=2, range="enemy", dmg=10, exhaust=true, onConditions={range="self", action="play", attr="voodoo", val=true}, onUpgrade={dmg=15}}); -- Deal 10(15) Damage. Trigger effect of each Doll
-- table.insert(cards, {tag="Reaper of Souls",		class="voodoo", rarity=3, ctype=CTYPE_ATTACK, energy=1, range="enemy", dmg=12, onUpgrade={dmg=15}}); -- Deal 13(17) damage. If enemy died, return card to hand or exhaust!
table.insert(cards, {tag="Damned Dolls",		class="voodoo", rarity=2, ctype=CTYPE_ATTACK, energy=2, range="enemy", poison=4, onConditions={range="self", action="play", attr="voodoo", val=true}, onUpgrade={energy=1, poison=5}}); -- Apply 4(5) Poison. Trigger effect of each Doll
table.insert(cards, {tag="Voracity",			class="voodoo", rarity=1, ctype=CTYPE_ATTACK, energy=X, range="enemy", dmg=9, onUpgrade={dmg=13}}); -- Deal 9(13) Damage X times

-- table.insert(cards, {tag="Venomous Ooze",		class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=2, range="enemy", poison=10, shuffle=true, onUpgrade={poison=12}, exhaust=true}); -- Apply 10(12) Poison. Appy 1 Agony
table.insert(cards, {tag="Poisoned Fume",		class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=3, range="enemies", poison=10, exhaust=true, onUpgrade={poison=15}}); -- Apply 10(15) Poison to each enemy
table.insert(cards, {tag="Unseen Threat",		class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=3, range="enemy", poison=20, exhaust=true, onUpgrade={poison=25}}); -- Apply 20(25) Poison

table.insert(cards, {tag="Marionette",			class="voodoo", rarity=0, ctype=CTYPE_SKILL, energy=1, range="self", rndCards={{dollofpain=4}, {dollofhope=2}, {dollofdecay=3}}, onUpgrade={energy=0}}); -- Create random Doll
table.insert(cards, {tag="Gasp",				class="voodoo", rarity=0, ctype=CTYPE_SKILL, energy=1, range="enemy", str=-5, strNext=5, onUpgrade={str=-7, strNext=7}}); -- Debuff 5(7) Strength for 1 turn
-- table.insert(cards, {tag="Dark Harvest",		class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=0, range="self", onUpgrade={energy=0}}); -- Execute Doll. Draw 2(3) Cards
-- table.insert(cards, {tag="Blood Link",			class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=2, range="self", onUpgrade={energy=1}, exhaust=true}); -- Execute Doll. Restore HP == Doll's Hatred. Exhaust
-- table.insert(cards, {tag="Enchantment",			class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", onUpgrade={energy=0}}); -- Add +2(+4) Hatred to selected Doll
-- table.insert(cards, {tag="Recless Enchantment",			class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=2(1), onUpgrade={}}); -- Add +8(+10) Hatred to selected Doll for 1 turn
table.insert(cards, {tag="Doll of Pain",		class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", dollofpain=5, exhaust=true, onUpgrade={dollofpain=8}}); -- Create Doll of Pain
table.insert(cards, {tag="Doll of Hope",		class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", dollofhope=3, exhaust=true, onUpgrade={energy=0}}); -- Create Doll of Hope
table.insert(cards, {tag="Doll of Decay",		class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", dollofdecay=4, exhaust=true, onUpgrade={energy=0}}); -- Create Doll of Decay
table.insert(cards, {tag="Doll of Acid",		class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", dollofacid=4, exhaust=true, onUpgrade={dollofacid=5}}); -- Create Doll of Acid
-- table.insert(cards, {tag="Soul Absorption",		class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=0, range="self", onUpgrade={}}); -- Execute Doll. For current turn gain Strength == Doll's Hatred
-- table.insert(cards, {tag="Phantom Clone",		class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=1, range="self", onUpgrade={energy=0}}); -- Duplicate selected Doll with accumulated Hatred
-- table.insert(cards, {tag="Fake Victim",			class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=2, range="self", onUpgrade={energy=1}}); -- Execute Doll. Negate next Attack damage on this turn
table.insert(cards, {tag="Necromutation",		class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", onUse={action="redeck", target="trash", filter={"ctype", "all", false}, amount="rnd"}, onUpgrade={energy=0}}); -- Bring card from Trash
-- table.insert(cards, {tag="Well of Hatred",		class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=2, range="self", pickCondition={range="self", action="double", attr="voodoo", val=true}, exhaust=true, onUpgrade={pickCondition={range="self", action="triple", attr="voodoo", val=true}}}); -- Doubles(Triples) Hatred on selected Doll
table.insert(cards, {tag="Shadow Call",			class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=2, range="self", onConditions={range="self", action="play", attr="voodoo", val=true}, times=2, exhaust=true, onUpgrade={times=3}}); -- For this turn all your Dolls proc effect twice(thrice)
table.insert(cards, {tag="Hidden Wound",		class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=1, range="enemy", onConditions={range="self", attr="voodoo", val=true, onCount={range="enemy", str=-5, strNext=5}}, onUpgrade={energy=0}}); -- Debuff 4(6) Strength for each Doll for 1 turn
table.insert(cards, {tag="Pure Immolation",		class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", onConditions={range="self", attr="voodoo", val=true, onCount={range="self", energyAdd=1}}, onUpgrade={energy=0}}); -- Execute Doll. Gain 1(2) Energy
table.insert(cards, {tag="Mutilation",			class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=1, range="enemy", exhaust=true, str=-3, onUpgrade={str=-4}}); -- Debuff 4(6) Strength permanently
table.insert(cards, {tag="Chains of Damnation",	class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=2, range="enemies", exhaust=true, str=-6, strNext=6, onUpgrade={str=-8, strNext=8}}); -- Debuff 10(14) Strength for 1 turn for each enemy
table.insert(cards, {tag="Energy Vein",			class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", energyAdd=2, exhaust=true, onUpgrade={energyAdd=3}}); -- Gain 2(3) Energy.
-- table.insert(cards, {tag="Cursed Ground",		class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=1, range="self", onUpgrade={}}); -- Execute Doll. Appy 2(4) Weak, 2(4) Vulnerability to enemy
-- table.insert(cards, {tag="Cycle of Life",		class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=1, range="self", onUpgrade={energy=0}}); -- All Dolls you execute this turn will be recreated on execution.
-- table.insert(cards, {tag="Void Mirror",			class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=2, range="self", onUpgrade={energy=1}}); -- Reflect next Attack damage back to attacker
-- table.insert(cards, {tag="Dolls Dance",			class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=X, range="self", rndCards={{dollofpain=3}, {dollofhope=1}, {dollofdecay=2}}, onUpgrade={}}); -- Create X random Dolls (Max 3)
-- table.insert(cards, {tag="Asthenia",			class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=2, range="enemy", exhaust=true, str=-30, onUpgrade={energy=1}}); -- Debuff 30 Strength permanently
-- table.insert(cards, {tag="Conniption",			class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=2, onUpgrade={energy=1}}); -- Add +20 Hatred to selected Doll for 1 turn
-- table.insert(cards, {tag="Life Gambler",		class="voodoo", rarity=1, ctype=CTYPE_SKILL, energy=1, range="self", onUpgrade={energy=0}}); -- Execute Doll. Drop all cards and draw same amount
table.insert(cards, {tag="Fury",				class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=2, range="self", exhaust=true, onConditions={range="self", action="add", attr="voodoo", val=true, add=6}, onUpgrade={onConditions={range="self", action="add", attr="voodoo", val=true, add=8}}}); -- Add +6(+8) Hatred to each Doll
table.insert(cards, {tag="Death Ruler",			class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=1, range="self", doubletap=1, onUpgrade={energy=0}}); -- All Attack cards this turn played twice
table.insert(cards, {tag="Shady Move",			class="voodoo", rarity=3, ctype=CTYPE_SKILL, energy=1, range="self", onConditions={range="self", action="purge", attr="voodoo", val=true, onCount={range="self", cleanse=true}}, onUpgrade={energy=0}}); -- Execute all Dolls, clear latest debuff on self
table.insert(cards, {tag="Relapse",				class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=1, range="enemy", str=-6, strNext=6, ifEnemy={condition="poison", play={str=2, range='self'}}, onUpgrade={energy=0, str=-9, strNext=9, ifEnemy={condition="poison", play={str=3, range='self'}}}}); -- Debuff 6(10) Strength for one turn. If enemy Poisoned, steal Strength for 1 turn
table.insert(cards, {tag="Backslide",			class="voodoo", rarity=2, ctype=CTYPE_SKILL, energy=2, range="enemy", str=-6, strNext=6, ifEnemy={condition="poison", play={str=-6, range='enemy'}}, onUpgrade={energy=1, str=-9, strNext=9, ifEnemy={condition="poison", play={str=-9, range='enemy'}}}}); -- Debuff 8(12) Strength for one turn. If enemy Poisoned, debuff permanently

conditions.voodoo = {hinted=true};
conditions.wavesofcreation = {event="voodoo", play={range="enemies", dmg=1}};
conditions.uncontrollableritual = {event="turn", play={range="self", rndCards={{dollofpain=3}, {dollofhope=2}}}};
conditions.vulnerabilityshroud = {event="turn", play={range="rnd", vulnerable=1}};
conditions.weaknessshroud = {event="dmg", play={range="rnd", weak=1}};
conditions.painconversion = {event="udmg", play={range="self", energyAdd=1}};
conditions.callofshadows = {event="turnEnd", play={range="self", onConditions={range="self", attr="voodoo", val=true, onCount={range="rnd", dmg=1}}}};
conditions.acolytes = {event="turn", play={range="self", onConditions={range="self", attr="voodoo", val=true, onCount={range="self", energyAdd=1}}}};
conditions.shadowhand = {event="turn", play={range="self", doubletap=1}};
conditions.quickdraw = {event="turn", play={range="self", freecast=1}};


table.insert(cards, {tag="Waves of Creation",	class="voodoo", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", wavesofcreation=3, onUpgrade={wavesofcreation=4}}); -- Whenever you create a Doll, deal 3(4) Damage to all enemies
table.insert(cards, {tag="Master of Tactics",	class="voodoo", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", drawpower=1, onUpgrade={energy=0}}); -- At the start of your turn draw +1(+2) Card
table.insert(cards, {tag="Uncontrollable Ritual",class="voodoo",rarity=3, ctype=CTYPE_POWER, energy=2, range="self", uncontrollableritual=1, onUpgrade={energy=1}}); -- At the end of the turn create 1 random Doll
table.insert(cards, {tag="Vulnerability Shroud",class="voodoo", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", vulnerabilityshroud=1, onUpgrade={energy=0}}); -- At the start of your turn appy Vulnerability for all enemies
table.insert(cards, {tag="Weakness Shroud",		class="voodoo", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", weaknessshroud=1, onUpgrade={innate=true}}); -- At the start of your turn appy Weak for all enemies
-- table.insert(cards, {tag="Drops of Energy",		class="voodoo", rarity=3, ctype=CTYPE_POWER, energy=2, range="self", onUpgrade={energy=1}}); -- Whenever you execute Doll, gain 1(2) Energy
table.insert(cards, {tag="Angered Dolls",		class="voodoo", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", voodoo=3, onUpgrade={innate=true}}); -- Whenever you create a Doll, add +5 Hatred to it
table.insert(cards, {tag="Quick Draw",			class="voodoo", rarity=3, ctype=CTYPE_POWER, energy=2, range="self", quickdraw=1, onUpgrade={energy=1}}); -- The first card you play each turn is played Free
table.insert(cards, {tag="Doll in the Sleeve",	class="voodoo", rarity=3, ctype=CTYPE_POWER, energy=1, range="self", dollinthesleeve=1, onUpgrade={innate=true}}); -- At the start of your turn, add a random Doll card into your hand
table.insert(cards, {tag="Spiritual Body",		class="voodoo", rarity=3, ctype=CTYPE_POWER, energy=2, range="self", spike=4, onUpgrade={energy=1}}); -- Whenever you take Attack damage, reflect 50% of damage back to attacker
table.insert(cards, {tag="Pain Conversion",		class="voodoo", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", painconversion=1, onUpgrade={innate=0}}); -- Whenever you take Attack damage, gain 1 Energy for the next turn
table.insert(cards, {tag="Call of Shadows",		class="voodoo", rarity=2, ctype=CTYPE_POWER, energy=1, range="self", callofshadows=3, onUpgrade={callofshadows=5}}); -- At the end of the turn deal 3(4) Damage to random enemy for each Doll
table.insert(cards, {tag="Acolytes",			class="voodoo", rarity=3, ctype=CTYPE_POWER, energy=3, range="self", acolytes=1, onUpgrade={energy=2}}); -- At the start of the turn gain 1 Energy for each Doll
table.insert(cards, {tag="Shadow Hand",			class="voodoo", rarity=2, ctype=CTYPE_POWER, energy=2, range="self", shadowhand=1, onUpgrade={energy=1}}); -- The first Attack you play each turn deal damage twice