script "beefy_combat_tools.ash";
import "beefy_tools.ash";

//////////////////////////////////
//Global Variables

	//////////////////////////////////
	//Spells
	string capped_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min((class(pastamancer)*skill(Bringing Up the Rear)*PASTA+1)*CAP,(base+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+BONUS_ELEMENTAL_DAMAGE+SAUCE*min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*((base+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+BONUS_ELEMENTAL_DAMAGE+SAUCE*min(L,10)*skill(Intrinsic Spiciness)))";

	string weapon_dmg = "(min(floor(WEAPON_STAT*ATTK_TYPE_STAT_MOD*WPN_TYPE_STAT_MOD)-MONDEF,0)+(max(1,WEAPON_DMG)*CRIT*ATK_TYPE_WPN_DMG_MOD)+BONUS_WEAPON_DAMAGE)*(1+WEAPON_MULT)+OFFHAND+BONUS_ELEMENTAL_DAMAGE";

	//skill() 0 1
	//effect() 0 1
	//class() 0 1
	//SAUCE 0 or 1 if sauce spell
	//MON_GROUP monster group size
	//SPELL_GROUP spell group size
	//CAP spell damage cap
	//MYST_SCALING mysticality scaling
	//BONUS_SPELL_DAMAGE bonus spell damage
	//BONUS_ELEMENTAL_DAMAGE bonus elemental damage
	//SPELL_CRIT Spell Critical Percent
	//CRIT Critical Hit Percent
	//SPELL_MULT spell percent damage
	//WEAPON_MULT -- weapon damage mult - includes ranged
	//PASTA 0 or 1 if pasta spell
	//OFFHAND - offhand weapon damage
	//WEAPON_DMG - weapon damage
	//BONUS_WEAPON_DAMAGE - bonus weapon damage
	//ATTK_TYPE_STAT_MOD - 1.25 non-seal clubber's lunging thrust-smack, 1.3, seal-clubber's lunging thrust-smack or northern explosion, 1.4 bashing slam smash, 1 otherwise
	//WPN_TYPE_STAT_MOD - 1 for melee, .75 range, .25 no weapon
	//ATK_TYPE_WPN_DMG_MOD - 2 for thrust-smack/mighty axing, 3 for lunging-thrust-smack/northern explosion
	//		5 for bashing slam smash, 5 for cleave, 1 otherwise
	//BONUS_WEAPON_DMG includes ranged damage for ranged weapon

	record combat_skill
	{
		skill sk;
		string dmg_exp;
		int [element] min_damage;
		int [element] max_damage;
		float [string] dmg_props;
		boolean [string] props;		
	};
	record skdmg
	{
		skill sk;
		float dmg; //damage dealt per use
		int ttd; // turns to death
		int tmtw; //total mana to win
		int dmg_taken; //expected_damage from monster
	};

	combat_skill [skill] cmbt_skills;
	skill [int] spell_skills = {to_skill("Salsaball"),to_skill("Stream of Sauce"),to_skill("Surge of Icing"),to_skill("Saucestorm"),to_skill(4023),to_skill("Wave of Sauce"),to_skill("Saucecicle"),to_skill("Saucegeyser"),to_skill("Saucemageddon"),to_skill("Spaghetti Spear"),to_skill("Ravioli Shurikens"),to_skill("Candyblast"),to_skill("Cannelloni Cannon"),to_skill("Stringozzi Serpent"),to_skill("Stuffed Mortar Shell"),to_skill("Weapon of the Pastalord"),to_skill("Fearful Fettucini")};
	boolean [skill] sk_cast_once;
	sk_cast_once[to_skill("Stuffed Mortar Shell")] = true;
//Saucerer
	cmbt_skills[to_skill("Salsaball")] = new combat_skill(
		to_skill("Salsaball"),
		capped_spell_dmg,
		int [element]  {$element[hot] : 2},
		int [element]  {$element[hot] : 3},
		float [string] {"MYST_SCALING" : 0.0, "CAP" : 8.0, "SPELL_GROUP" : 1.0, "SAUCE" : 1.0},
		boolean [string] {"spell" : true}
		);

	cmbt_skills[to_skill("Stream of Sauce")] = new combat_skill(
		to_skill("Stream of Sauce"),
		capped_spell_dmg,
		int [element]  {$element[hot] : 9},
		int [element]  {$element[hot] : 11},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 24.0, "SPELL_GROUP" : 1.0, "SAUCE" : 1.0},
		boolean [string] {"spell" : true}
		);

	cmbt_skills[to_skill("Surge of Icing")] = new combat_skill(
		to_skill("Surge of Icing"),
		capped_spell_dmg,
		int [element]  {$element[none] : 14},
		int [element]  {$element[none] : 18},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 24.0, "SPELL_GROUP" : 1.0, "SAUCE" : 1.0},
		boolean [string] {"spell" : true}
		);

	cmbt_skills[to_skill("Saucestorm")] = new combat_skill(
		to_skill("Saucestorm"),
		capped_spell_dmg,
		int [element]  {$element[hot] : 20,$element[cold] : 20},
		int [element]  {$element[hot] : 24,$element[cold] : 24},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 50.0, "SPELL_GROUP" : 2.0, "SAUCE" : 1.0},
		boolean [string] {"spell" : true}
		);

		//Käsesoßesturm
	cmbt_skills[to_skill(4023)] = new combat_skill(
		to_skill("4023"),
		capped_spell_dmg,
		int [element]  {$element[stench] : 40},
		int [element]  {$element[stench] : 44},
		float [string] {"MYST_SCALING" : 0.3, "CAP" : 2100.0, "SPELL_GROUP" : 5.0, "SAUCE" : 1.0},
		boolean [string] {"spell" : true}
		);

	cmbt_skills[to_skill("Wave of Sauce")] = new combat_skill(
		to_skill("Wave of Sauce"),
		capped_spell_dmg,
		int [element]  {$element[hot] : 45},
		int [element]  {$element[hot] : 50},
		float [string] {"MYST_SCALING" : 0.3, "CAP" : 100.0, "SPELL_GROUP" : 2.0, "SAUCE" : 1.0},
		boolean [string] {"spell" : true}
		);

	cmbt_skills[to_skill("Saucecicle")] = new combat_skill(
		to_skill("Saucecicle"),
		capped_spell_dmg,
		int [element]  {$element[cold] : 45},
		int [element]  {$element[cold] : 50},
		float [string] {"MYST_SCALING" : 0.4, "CAP" : 150.0, "SPELL_GROUP" : 1.0, "SAUCE" : 1.0},
		boolean [string] {"spell" : true}
		);

	cmbt_skills[to_skill("Saucegeyser")] = new combat_skill(
		to_skill("Saucegeyser"),
		uncapped_spell_dmg,
		int [element]  {$element[hot] : 60,$element[cold] : 60},
		int [element]  {$element[hot] : 70,$element[cold] : 70},
		float [string] {"MYST_SCALING" : 0.4, "SPELL_GROUP" : 3.0, "SAUCE" : 1.0},
		boolean [string] {"spell" : true,"best" : true}
		);

	cmbt_skills[to_skill("Saucemageddon")] = new combat_skill(
		to_skill("Saucemageddon"),
		uncapped_spell_dmg,
		int [element]  {$element[hot] : 80,$element[cold] : 80},
		int [element]  {$element[hot] : 90,$element[cold] : 90},
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 5.0, "SAUCE" : 1.0},
		boolean [string] {"spell" : true,"best" : true}
		);

//Pastamancer
	cmbt_skills[to_skill("Spaghetti Spear")] = new combat_skill(
		to_skill("Spaghetti Spear"),
		capped_spell_dmg,
		int [element]  {$element[none] : 2},
		int [element]  {$element[none] : 3},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 8.0, "SPELL_GROUP" : 1.0, "PASTA" : 1.0},
		boolean [string] {"spell" : true}
		);
	

	cmbt_skills[to_skill("Ravioli Shurikens")] = new combat_skill(
		to_skill("Ravioli Shurikens"),
		capped_spell_dmg,
		int [element]  {$element[none] : 2},
		int [element]  {$element[none] : 34},
		float [string] {"MYST_SCALING" : 0.0, "CAP" : 10.0, "SPELL_GROUP" : 1.0, "PASTA" : 1.0, "repeat" : 2},
		boolean [string] {"pasta random" : true,"spell" : true}
		);

	cmbt_skills[to_skill("Candyblast")] = new combat_skill(
		to_skill("Candyblast"),
		capped_spell_dmg,
		int [element]  {$element[none] : 8},
		int [element]  {$element[none] : 16},
		float [string] {"MYST_SCALING" : 0.25, "CAP" : 50.0, "SPELL_GROUP" : 1.0, "PASTA" : 1.0}
		boolean [string] {"spell" : true}
		);

	cmbt_skills[to_skill("Cannelloni Cannon")] = new combat_skill(
		to_skill("Cannelloni Cannon"),
		capped_spell_dmg,
		int [element]  {$element[none] : 16},
		int [element]  {$element[none] : 32},
		float [string] {"MYST_SCALING" : 0.25, "CAP" : 50.0, "SPELL_GROUP" : 2.0, "PASTA" : 1.0},
		boolean [string] {"pasta random" : true,"spell" : true}
		);

	cmbt_skills[to_skill("Stringozzi Serpent")] = new combat_skill(
		to_skill("Stringozzi Serpent"),
		capped_spell_dmg,
		int [element]  {$element[none] : 16},
		int [element]  {$element[none] : 32},
		float [string] {"MYST_SCALING" : 0.25, "CAP" : 75.0, "SPELL_GROUP" : 2.0, "PASTA" : 1.0},
		boolean [string] {"pasta random" : true,"spell" : true}
		);

	cmbt_skills[to_skill("Stuffed Mortar Shell")] = new combat_skill(
		to_skill("Stuffed Mortar Shell"),
		uncapped_spell_dmg,
		int [element]  {$element[none] : 32},
		int [element]  {$element[none] : 64},
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 3.0, "PASTA" : 1.0},
		boolean [string] {"pasta random" : true,"spell" : true}
		);

	cmbt_skills[to_skill("Weapon of the Pastalord")] = new combat_skill(
		to_skill("Weapon of the Pastalord"),
		uncapped_spell_dmg,
		int [element]  {$element[none] : 32},
		int [element]  {$element[none] : 64},
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 1.0, "PASTA" : 1.0}
		boolean [string] {"pastalord" : true,"spell" : true}
		);

	cmbt_skills[to_skill("Fearful Fettucini")] = new combat_skill(
		to_skill("Fearful Fettucini"),
		uncapped_spell_dmg,
		int [element]  {$element[spooky] : 32},
		int [element]  {$element[spooky] : 64},
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 1.0, "PASTA" : 1.0}
		boolean [string] {"spell" : true}
		);

	cmbt_skills[to_skill("none")] = new combat_skill(
		to_skill("none"),
		weapon_dmg,
		int [element]  {},
		int [element]  {},
		float [string] {"ATTK_TYPE_STAT_MOD" : 1, "ATK_TYPE_WPN_DMG_MOD" : 1}
		boolean [string] {"attack" : true}
		);
	cmbt_skills[to_skill("Clobber")] = new combat_skill(
		to_skill("none"),
		"WEAPON_DMG+ceil(sqrt(BONUS_WEAPON_DAMAGE))+ceil(sqrt(COLD_DMG))+ceil(sqrt(HOT_DMG))+ceil(sqrt(SLEAZE_DMG))+ceil(sqrt(SPOOKY_DMG))+ceil(sqrt(STENCH_DMG))",
		int [element]  {},
		int [element]  {},
		float [string] {}
		boolean [string] {"base" : true}
		);
	cmbt_skills[to_skill("Lunge Smack")] = new combat_skill(
		to_skill("Lunge Smack"),
		weapon_dmg + "+5",
		int [element]  {},
		int [element]  {},
		float [string] {"ATTK_TYPE_STAT_MOD" : 1, "ATK_TYPE_WPN_DMG_MOD" : 1}
		boolean [string] {"attack" : true}
		);
	cmbt_skills[to_skill("Thrust-Smack")] = new combat_skill(
		to_skill("Thrust-Smack"),
		weapon_dmg,
		int [element]  {},
		int [element]  {},
		float [string] {"ATTK_TYPE_STAT_MOD" : 1, "ATK_TYPE_WPN_DMG_MOD" : 2}
		boolean [string] {"attack" : true}
		);
	cmbt_skills[to_skill("Lunging Thrust-Smack")] = new combat_skill(
		to_skill("Lunging Thrust-Smack"),
		weapon_dmg,
		int [element]  {},
		int [element]  {},
		float [string] {"ATTK_TYPE_STAT_MOD" : 1.25, "ATK_TYPE_WPN_DMG_MOD" : 3}
		boolean [string] {"attack" : true}
		);
	cmbt_skills[to_skill("Northern Explosion")] = new combat_skill(
		to_skill("Northern Explosion"),
		weapon_dmg,
		int [element]  {},
		int [element]  {},
		float [string] {"ATTK_TYPE_STAT_MOD" : 1.3, "ATK_TYPE_WPN_DMG_MOD" : 3}
		boolean [string] {"attack" : true}
		);


//////////////////////////////////
//Spell damage

float dmg_eval(string expr, float[string] vars)
{
	//skill() 0 1
	//effect() 0 1
	//class() 0 1
	//SAUCE 0 or 1 if sauce spell
	//MON_GROUP monster group size
	//SPELL_GROUP spell group size
	//CAP spell damage cap
	//MYST_SCALING mysticality scaling
	//BONUS_SPELL_DAMAGE bonus spell damage
	//BONUS_ELEMENTAL_DAMAGE bonus elemental damage
	//SPELL_CRIT Spell Critical Percent
	//CRIT Critical Hit Percent
	//SPELL_MULT spell percent damage
	//WEAPON_MULT -- weapon damage mult - includes ranged
	//PASTA 0 or 1 if pasta spell
	//OFFHAND - offhand weapon damage
	//WEAPON_DMG - weapon damage
	//BONUS_WEAPON_DAMAGE - bonus weapon damage
	//ATTK_TYPE_STAT_MOD - 1.25 non-seal clubber's lunging thrust-smack, 1.3, seal-clubber's lunging thrust-smack or northern explosion, 1.4 bashing slam smash, 1 otherwise
	//WPN_TYPE_STAT_MOD - 1 for melee, .75 range, .25 no weapon
	//ATK_TYPE_WPN_DMG_MOD - 2 for thrust-smack/mighty axing, 3 for lunging-thrust-smack/northern explosion
	//		5 for bashing slam smash, 5 for cleave, 1 otherwise
	//BONUS_WEAPON_DMG includes ranged damage for ranged weapon

	//WEAPON_DMG - weapon damage
	//BONUS_WEAPON_DAMAGE - bonus weapon damage
	//ATTK_TYPE_STAT_MOD - 1.25 non-seal clubber's lunging thrust-smack, 1.3, seal-clubber's lunging thrust-smack or northern explosion, 1.4 bashing slam smash, 1 otherwise
	//WPN_TYPE_STAT_MOD - 1 for melee, .75 range, .25 no weapon
	//ATK_TYPE_WPN_DMG_MOD - 2 for thrust-smack/mighty axing, 3 for lunging-thrust-smack/northern explosion
	//		5 for bashing slam smash, 5 for cleave, 1 otherwise
	//BONUS_WEAPON_DMG includes ranged damage for ranged weapon  
	buffer b;
	matcher m = create_matcher( "\\b[a-zA-Z0-9_]*\\b", expr );
	while (m.find()) {
		string var = m.group(0);
		switch (m.group(0))
		{
			case "MUS":
				m.append_replacement(b, my_buffedstat($stat[muscle]).to_string());
			break;
			case "MYS":
				m.append_replacement(b, my_buffedstat($stat[mysticality]).to_string());
			break;
			case "MOX":
				m.append_replacement(b, my_buffedstat($stat[moxie]).to_string());
			break;
			case "WEAPON_DMG":
				m.append_replacement(b, to_float(equipped_item($slot[weapon]).get_power()*.15).to_string());
			break;
			case "WEAPON_STAT":
				if(weapon_type(equipped_item($slot[weapon])) == $stat[moxie])
				{
					m.append_replacement(b, my_buffedstat($stat[moxie]).to_string());
				}
				else
				{
					m.append_replacement(b, my_buffedstat($stat[muscle]).to_string());
				}
			break;
			case "OFFHAND":
				if(equipped_item($slot[off-hand]) != $item[none])
				{
					if(weapon_type(equipped_item($slot[off-hand])) != $stat[none])
					{
						m.append_replacement(b, "0");
					}
					else
					{
						m.append_replacement(b, (to_float(equipped_item($slot[off-hand]).get_power()*.15)).to_string());
					}
				}
				else
				{
					m.append_replacement(b, "0");
				}
			break;
			case "WPN_TYPE_STAT_MOD":
				if(weapon_type(equipped_item($slot[weapon])) == $stat[moxie])
				{
					m.append_replacement(b, (0.75).to_string());
				}
				else if (equipped_item($slot[weapon]) == $item[none])
				{
					m.append_replacement(b, (0.25).to_string());
				}
				else
				{
					m.append_replacement(b, (1).to_string());
				}
			break;
			case "BONUS_SPELL_DAMAGE":
				m.append_replacement(b, numeric_modifier("Spell Damage").to_string());
			break;
			case "BONUS_WEAPON_DAMAGE":
				if(weapon_type(equipped_item($slot[weapon])) == $stat[moxie])
				{
					m.append_replacement(b, (numeric_modifier("Ranged Damage") + numeric_modifier("Weapon Damage")).to_string());
				}
				else
				{
					m.append_replacement(b, numeric_modifier("Weapon Damage").to_string());
				}
			break;     
			case "SPELL_CRIT":
				m.append_replacement(b, (numeric_modifier("Spell Critical Percent")/100).to_string());
			break;
			case "CRIT":
				m.append_replacement(b, (numeric_modifier("Critical Hit Percent")/100).to_string());
			break;
			case "SPELL_MULT":
				m.append_replacement(b, (numeric_modifier("spell damage percent")/100).to_string());
			break;
			case "WEAPON_MULT":
				if(weapon_type(equipped_item($slot[weapon])) == $stat[moxie])
				{
					m.append_replacement(b, ((numeric_modifier("Ranged Damage Percent") + numeric_modifier("Weapon Damage Percent"))/100).to_string());
				}
				else
				{
					m.append_replacement(b, (numeric_modifier("Weapon Damage Percent")/100).to_string());
				}
			break;
			case "RANGED_MULT":
				m.append_replacement(b, (numeric_modifier("Ranged Damage Percent")/100).to_string());
			break;
			case "COLD_DMG":
				m.append_replacement(b, numeric_modifier("Cold Damage").to_string());
			break;
			case "HOT_DMG":
				m.append_replacement(b, numeric_modifier("Hot Damage").to_string());
			break;
			case "SLEAZE_DMG":
				m.append_replacement(b, numeric_modifier("Sleaze Damage").to_string());
			break;
			case "SPOOKY_DMG":
				m.append_replacement(b, numeric_modifier("Spooky Damage").to_string());
			break;
			case "STENCH_DMG":
				m.append_replacement(b, numeric_modifier("Stench Damage").to_string());
			break;
			case "BONUS_ELEMENTAL_DAMAGE":
				m.append_replacement(b,
				(numeric_modifier("Cold Damage")
				+numeric_modifier("Hot Damage")
				+numeric_modifier("Sleaze Damage")
				+numeric_modifier("Spooky Damage")
				+numeric_modifier("Stench Damage")).to_string());
			break;
			default:
				if (vars contains var)
				{
					m.append_replacement(b, vars[var].to_string());
				}
			break;
		}
		// could implement functions, pref access, etc. here
	}
	m.append_tail(b);
	//print(b.to_string());
	return modifier_eval(b.to_string());
}

float el_damage_dealt(combat_skill spell, float min, float max, element el, monster mon)
{
	//print (spell.sk.to_string());
	/*
	string capped_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*min((class(pastamancer)*skill(Bringing Up the Rear)*PASTA+1)*CAP,(base+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+BONUS_ELEMENTAL_DAMAGE+SAUCE*min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*EL_MULT*(1+SPELL_MULT)*((base+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+BONUS_ELEMENTAL_DAMAGE+SAUCE*min(L,10)*skill(Intrinsic Spiciness)))";
	*/
	float [string] vars;
	foreach var in spell.dmg_props
	{
		vars[var] = spell.dmg_props[var];
	}
	if(!(vars contains "SAUCE"))
	{
		vars["SAUCE"] = 0.0;
	}
	if(!(vars contains "PASTA"))
	{
		vars["PASTA"] = 0.0;
	}
	vars["base"] = (max + min)/2;
	vars["MON_GROUP"] = 1; // to replace
	vars["MONDEF"] = mon.monster_defense();
	switch(el)
	{
		case $element[hot]:
			vars["BONUS_ELEMENTAL_DAMAGE"] = numeric_modifier("hot spell damage");
			switch(mon.monster_element())
			{
				case $element[hot]:
					vars["EL_MULT"] = 0;
				break;
				case $element[cold]:
				case $element[spooky]:
					vars["EL_MULT"] = 2;
				break;
				default:
					vars["EL_MULT"] = 1;
				break;
			}
		break;
		case $element[cold]:
			vars["BONUS_ELEMENTAL_DAMAGE"] = numeric_modifier("cold spell damage");
			switch(mon.monster_element())
			{
				case $element[cold]:
					vars["EL_MULT"] = 0;
				break;
				case $element[sleaze]:
				case $element[stench]:
					vars["EL_MULT"] = 2;
				break;
				default:
					vars["EL_MULT"] = 1;
				break;
			}
		break;
		case $element[sleaze]:
			vars["BONUS_ELEMENTAL_DAMAGE"] = numeric_modifier("sleaze spell damage");
			switch(mon.monster_element())
			{
				case $element
				[hot]:
				case $element[stench]:
					vars["EL_MULT"] = 2;
				break;
				case $element[sleaze]:
					vars["EL_MULT"] = 0;
				break;
				default:
					vars["EL_MULT"] = 1;
				break;
			}
		break;
		case $element[spooky]:
			vars["BONUS_ELEMENTAL_DAMAGE"] = numeric_modifier("spooky spell damage");
			switch(mon.monster_element())
			{
				case $element[cold]:
				case $element[sleaze]:
					vars["EL_MULT"] = 2;
				break;
				case $element[spooky]:
					vars["EL_MULT"] = 0;
				break;
				default:
					vars["EL_MULT"] = 1;
				break;
			}
		break;
		case $element[stench]:
			vars["BONUS_ELEMENTAL_DAMAGE"] = numeric_modifier("stench spell damage");
			switch(mon.monster_element())
			{
				case $element[hot]:
				case $element[spooky]:
					vars["EL_MULT"] = 2;
				break;
				case $element[stench]:
					vars["EL_MULT"] = 0;
				break;
				default:
					vars["EL_MULT"] = 1;
				break;
			}
		break;
		default:
			vars["BONUS_ELEMENTAL_DAMAGE"] = 1;
			vars["EL_MULT"] = 1;
		break;
	}
	return dmg_eval(spell.dmg_exp, vars);
}

float damage_dealt(combat_skill spell, monster mon)
{
	float total_damage = 0;
	int times = 1+ spell.dmg_props["repeat"];
	for i from 1 to times by 1
	{
		if(spell.props["pasta random"] == true)
		{
			foreach el in $elements[hot, cold, sleaze, stench, spooky]
			{
				total_damage += el_damage_dealt(spell, spell.min_damage[$element[none]], spell.max_damage[$element[none]], el, mon) / 5;
			}
		}
		else if (spell.props["best"] == true)
		{
			foreach el in spell.min_damage
			{
				total_damage = max(total_damage,el_damage_dealt(spell, spell.min_damage[el], spell.max_damage[el], el, mon));
			}
		}
		else
		{
			if(spell.min_damage.count() == 0)
			{
				total_damage += el_damage_dealt(spell, 0, 0, $element[none], mon);
			}
			else
			{
				foreach el in spell.min_damage
				{
					total_damage += el_damage_dealt(spell, spell.min_damage[el], spell.max_damage[el], el, mon);
				}
			}
		}
	}
	return total_damage;
}
float damage_dealt(combat_skill spell)
{
	return damage_dealt(spell,last_monster());
}
float damage_dealt(skill spell, monster mon)
{
	return damage_dealt(cmbt_skills[spell],mon);
}
float damage_dealt(skill spell)
{
	return damage_dealt(cmbt_skills[spell],last_monster());
}
//////////////////////////////////
//Skill Picking

	skdmg [int] best_skills(string sktype,monster mon, boolean have_only)
	{
		float mp_regen = (numeric_modifier("mp regen min") + numeric_modifier("mp regen max"))/2;
		boolean [skill] choices;
		foreach sk in cmbt_skills
		{
			//print(sk.to_string());
			//print(cmbt_skills[sk].dmg_exp);
			if (sktype == "" || cmbt_skills[sk].props contains sktype)
			{
				if(have_skill(sk) && have_only)
				{
					choices[sk] = true;
				}
				else if (!have_only)
				{
					choices[sk] = true;
				}
			}
			/*
			if(mp_cost(sk) < mp_regen && have_skill(sk))
			{
				choices[sk] = true;
			}*/
		}
		skdmg [int] skillranks;
		foreach sk in choices
		{
			skdmg myskdmg = new skdmg();
			myskdmg.dmg = damage_dealt(sk,mon);
			myskdmg.sk = sk;
			myskdmg.ttd = ceil(mon.monster_hp()/ max(1,myskdmg.dmg));
			myskdmg.tmtw = myskdmg.ttd * mp_cost(sk);
			myskdmg.dmg_taken = mon.expected_damage() * myskdmg.ttd;
			skillranks[skillranks.count()] = myskdmg;

		}
		foreach num in skillranks
		{
			if(skillranks[num].ttd > 15)
			{
				remove skillranks[num];
			}
		}
		sort skillranks by value.tmtw;
		return skillranks;
	}
	skdmg [int] best_skills(monster mon)
	{
		return best_skills("", mon, true);
	}
	skdmg [int] best_skills(string sktype, monster mon)
	{
		return best_skills(sktype, mon, true);
	}
	skdmg [int] best_skills(boolean have_only)
	{
		return best_skills("",last_monster(), have_only);
	}
	skdmg [int] best_skills(string sktype, boolean have_only)
	{
		return best_skills(sktype, last_monster(), have_only);
	}
	skdmg [int] best_skills()
	{
		return best_skills("",last_monster(), true);
	}
	skdmg [int] best_skills(string sktype)
	{
		return best_skills(sktype, last_monster(), true);
	}

	void print_best_skills(string sktype, monster mon, boolean have_only)
	{
		print("monster is: " +  mon.to_string());
		skdmg [int] bs = best_skills(sktype,mon, have_only);
		foreach num in bs
		{
			print_html("%s has damage %s, ttd %s, mana used %s, dmg_taken %s",string [int] {to_string(bs[num].sk),to_string(bs[num].dmg),to_string(bs[num].ttd),to_string(bs[num].tmtw),to_string(bs[num].dmg_taken)});
		}
	}
	void print_best_skills(string sktype,boolean have_only)
	{
		print_best_skills(sktype,last_monster(), have_only);
	}
	void print_best_skills(boolean have_only)
	{
		print_best_skills("",last_monster(), have_only);
	}
	void print_best_skills(string sktype, monster mon)
	{
		print_best_skills(sktype,mon, true);
	}
	void print_best_skills(monster mon)
	{
		print_best_skills("",mon, true);
	}
	void print_best_skills(string sktype)
	{
		print_best_skills(sktype,last_monster(), true);
	}
	void print_best_skills()
	{
		print_best_skills("",last_monster(), true);
	}

void beefy_combat_tools_parse(string command)
{
	string [int] arry = command.split_string(",");
	switch (arry[0])
	{
		case "all spells":
			switch(arry.count())
			{
				case 1:
					print_best_skills("spell",false);
				break;
				case 2:
					print_best_skills("spell",arry[1].to_monster(),false);
				break;
			}
		case "spell":
			switch(arry.count())
			{
				case 1:
					print_best_skills("spell");
				break;
				case 2:
					print_best_skills("spell",arry[1].to_monster());
				break;
			}
		break;
		case "all":
			switch(arry.count())
			{
				case 1:
					print_best_skills("",false);
				break;
				case 2:
					print_best_skills("",arry[1].to_monster(),false);
				break;
			}
		break;
		case "attack":
			switch(arry.count())
			{
				case 1:
					print_best_skills("attack");
				break;
				case 2:
					print_best_skills("attack",arry[1].to_monster());
				break;
			}
		break;
		case "all attacks":
			switch(arry.count())
			{
				case 1:
					print_best_skills("attack",false);
				break;
				case 2:
					print_best_skills("attack",arry[1].to_monster(),false);
				break;
			}
		break;
		default:
		break;
	}
}

void main(string command)
{
	beefy_combat_tools_parse(command);
}