script "beefy_combat_tools.ash";
import "beefy_tools.ash";

//////////////////////////////////
//Global Variables

	//////////////////////////////////
	//Spells
	string capped_spell_dmg = "ceil(min(GROUPSIZE,groupmax)*el_mult*(1+SPELL_MULT)*((base+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+BONUS_ELEMENTAL_DAMAGE+SAUCE*min(L,10)*skill(Intrinsic Spiciness)))";
	string uncapped_spell_dmg = "ceil(min(MON_GROUP,SPELL_GROUP)*el_mult*(1+SPELL_MULT)*min((class(pastamancer)*skill(Bringing Up the Rear)*PASTA + 1)*CAP,(base+floor(MYS*MYST_SCALING))*(1+SPELL_CRIT)+BONUS_SPELL_DAMAGE+BONUS_ELEMENTAL_DAMAGE+SAUCE*min(L,10)*skill(Intrinsic Spiciness)))";
	//skill() 0 1
	//effect() 0 1
	//class() 0 1
	//SAUCE 0 or 1 if sauce spell
	//MON_GROUP monster group size
	//SPELL_GROUP spell group size
	//CAP spell damage cap
	//MYST_SCALING mysticality scaling
	//CRIT crit chance
	//BONUS_SPELL_DAMAGE bonus spell damage
	//BONUS_ELEMENTAL_DAMAGE bonus elemental damage
	//SPELL_CRIT Spell Critical Percent
	//CRIT Critical Hit Percent
	//SPELL_MULT spell percent damage
	//PASTA 0 or 1 if pasta spell
	record combat_spell
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

	combat_spell [skill] cmbt_spells;
	skill [int] spell_skills = {to_skill("Salsaball"),to_skill("Stream of Sauce"),to_skill("Surge of Icing"),to_skill("Saucestorm"),to_skill(4023),to_skill("Wave of Sauce"),to_skill("Saucecicle"),to_skill("Saucegeyser"),to_skill("Saucemageddon"),to_skill("Spaghetti Spear"),to_skill("Ravioli Shurikens"),to_skill("Candyblast"),to_skill("Cannelloni Cannon"),to_skill("Stringozzi Serpent"),to_skill("Stuffed Mortar Shell"),to_skill("Weapon of the Pastalord"),to_skill("Fearful Fettucini")};
	boolean [skill] sk_cast_once;
	sk_cast_once[to_skill("Stuffed Mortar Shell")] = true;
//Saucerer
	cmbt_spells[to_skill("Salsaball")] = new combat_spell(
		to_skill("Salsaball"),
		capped_spell_dmg,
		int [element]  {$element[hot] : 2},
		int [element]  {$element[hot] : 3},
		float [string] {"MYST_SCALING" : 0.0, "CAP" : 8.0, "SPELL_GROUP" : 1.0, "SAUCE" : 1.0}
		);

	cmbt_spells[to_skill("Stream of Sauce")] = new combat_spell(
		to_skill("Stream of Sauce"),
		capped_spell_dmg,
		int [element]  {$element[hot] : 9},
		int [element]  {$element[hot] : 11},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 24.0, "SPELL_GROUP" : 1.0, "SAUCE" : 1.0}
		);

	cmbt_spells[to_skill("Surge of Icing")] = new combat_spell(
		to_skill("Surge of Icing"),
		capped_spell_dmg,
		int [element]  {$element[none] : 14},
		int [element]  {$element[none] : 18},
		float [string] {"myst_scale" : 0.2, "CAP" : 24.0, "SPELL_GROUP" : 1.0, "SAUCE" : 1.0}
		);

	cmbt_spells[to_skill("Saucestorm")] = new combat_spell(
		to_skill("Saucestorm"),
		capped_spell_dmg,
		int [element]  {$element[hot] : 20,$element[cold] : 20},
		int [element]  {$element[hot] : 24,$element[cold] : 24},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 50.0, "SPELL_GROUP" : 2.0, "SAUCE" : 1.0}
		);

		//Käsesoßesturm
	cmbt_spells[to_skill(4023)] = new combat_spell(
		to_skill("4023"),
		capped_spell_dmg,
		int [element]  {$element[stench] : 40},
		int [element]  {$element[stench] : 44},
		float [string] {"MYST_SCALING" : 0.3, "CAP" : 2100.0, "SPELL_GROUP" : 5.0, "SAUCE" : 1.0}
		);

	cmbt_spells[to_skill("Wave of Sauce")] = new combat_spell(
		to_skill("Wave of Sauce"),
		capped_spell_dmg,
		int [element]  {$element[hot] : 45},
		int [element]  {$element[hot] : 50},
		float [string] {"MYST_SCALING" : 0.3, "CAP" : 100.0, "SPELL_GROUP" : 2.0, "SAUCE" : 1.0}
		);

	cmbt_spells[to_skill("Saucecicle")] = new combat_spell(
		to_skill("Saucecicle"),
		capped_spell_dmg,
		int [element]  {$element[cold] : 45},
		int [element]  {$element[cold] : 50},
		float [string] {"MYST_SCALING" : 0.4, "CAP" : 150.0, "SPELL_GROUP" : 1.0, "SAUCE" : 1.0}
		);

	cmbt_spells[to_skill("Saucegeyser")] = new combat_spell(
		to_skill("Saucegeyser"),
		uncapped_spell_dmg,
		int [element]  {$element[hot] : 60,$element[cold] : 60},
		int [element]  {$element[hot] : 70,$element[cold] : 70},
		float [string] {"MYST_SCALING" : 0.4, "SPELL_GROUP" : 3.0, "SAUCE" : 1.0},
		boolean [string] {"best" : true}
		);

	cmbt_spells[to_skill("Saucemageddon")] = new combat_spell(
		to_skill("Saucemageddon"),
		uncapped_spell_dmg,
		int [element]  {$element[hot] : 80,$element[cold] : 80},
		int [element]  {$element[hot] : 90,$element[cold] : 90},
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 5.0, "SAUCE" : 1.0},
		boolean [string] {"best" : true}
		);

//Pastamancer
	cmbt_spells[to_skill("Spaghetti Spear")] = new combat_spell(
		to_skill("Spaghetti Spear"),
		capped_spell_dmg,
		int [element]  {$element[none] : 2},
		int [element]  {$element[none] : 3},
		float [string] {"MYST_SCALING" : 0.2, "CAP" : 8.0, "SPELL_GROUP" : 1.0, "PASTA" : 1.0}
		);
	

	cmbt_spells[to_skill("Ravioli Shurikens")] = new combat_spell(
		to_skill("Ravioli Shurikens"),
		capped_spell_dmg,
		int [element]  {$element[none] : 2},
		int [element]  {$element[none] : 34},
		float [string] {"MYST_SCALING" : 0.0, "CAP" : 10.0, "SPELL_GROUP" : 1.0, "PASTA" : 1.0, "repeat" : 2},
		boolean [string] {"pasta random" : true}
		);

	cmbt_spells[to_skill("Candyblast")] = new combat_spell(
		to_skill("Candyblast"),
		capped_spell_dmg,
		int [element]  {$element[none] : 8},
		int [element]  {$element[none] : 16},
		float [string] {"MYST_SCALING" : 0.25, "CAP" : 50.0, "SPELL_GROUP" : 1.0, "PASTA" : 1.0}
		);

	cmbt_spells[to_skill("Cannelloni Cannon")] = new combat_spell(
		to_skill("Cannelloni Cannon"),
		capped_spell_dmg,
		int [element]  {$element[none] : 16},
		int [element]  {$element[none] : 32},
		float [string] {"MYST_SCALING" : 0.25, "CAP" : 50.0, "SPELL_GROUP" : 2.0, "PASTA" : 1.0},
		boolean [string] {"pasta random" : true}
		);
	cmbt_spells[to_skill("Cannelloni Cannon")].props["pasta random"] = true;
	cmbt_spells[to_skill("Cannelloni Cannon")].props["pasta"] = true;
	cmbt_spells[to_skill("Cannelloni Cannon")].props["butr"] = true;

	cmbt_spells[to_skill("Stringozzi Serpent")] = new combat_spell(
		to_skill("Stringozzi Serpent"),
		capped_spell_dmg,
		int [element]  {$element[none] : 16},
		int [element]  {$element[none] : 32},
		float [string] {"MYST_SCALING" : 0.25, "CAP" : 75.0, "SPELL_GROUP" : 2.0, "PASTA" : 1.0},
		boolean [string] {"pasta random" : true}
		);

	cmbt_spells[to_skill("Stuffed Mortar Shell")] = new combat_spell(
		to_skill("Stuffed Mortar Shell"),
		uncapped_spell_dmg,
		int [element]  {$element[none] : 32},
		int [element]  {$element[none] : 64},
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 3.0, "PASTA" : 1.0},
		boolean [string] {"pasta random" : true}
		);

	cmbt_spells[to_skill("Weapon of the Pastalord")] = new combat_spell(
		to_skill("Weapon of the Pastalord"),
		uncapped_spell_dmg,
		int [element]  {$element[none] : 32},
		int [element]  {$element[none] : 64},
		float [string] {"MYST_SCALING" : 0.5, "SPELL_GROUP" : 1.0, "PASTA" : 1.0}
		boolean [string] {"pastalord" : true}
		);

	cmbt_spells[to_skill("Fearful Fettucini")] = new combat_spell(
		to_skill("Fearful Fettucini"),
		uncapped_spell_dmg,
		int [element]  {$element[spooky] : 32},
		int [element]  {$element[spooky] : 64},
		float [string] {"MYST_SCALING" : 0.5, "CAP" : 50.0, "SPELL_GROUP" : 1.0, "PASTA" : 1.0}
		);
	//////////////////////////////////
	//Combat skills
	record melee_skill
	{
		boolean [string] props;
		string [element] min_damage;
		string [element] max_damage;
		float [stat] boost;
	};



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
	//CRIT crit chance
	//BONUS_SPELL_DAMAGE bonus spell damage
	//BONUS_ELEMENTAL_DAMAGE bonus elemental damage
	//SPELL_CRIT Spell Critical Percent
	//CRIT Critical Hit Percent
	//SPELL_MULT spell percent damage
	//WEAPON_MULT weapon damage percent
	//RANGED_MULT Ranged Weapon damage percent
	//WEAPON_DAMAGE Weapon Damage  
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
			case "BONUS_SPELL_DAMAGE":
				m.append_replacement(b, numeric_modifier("Spell Damage").to_string());
				break;
			case "WEAPON_DAMAGE":
				m.append_replacement(b, numeric_modifier("Weapon Damage").to_string());
				break;     
			case "SPELL_CRIT":
				m.append_replacement(b, (numeric_modifier("Spell Critical Percent")/100).to_string());
				break;
			case "CRIT":
				m.append_replacement(b, (numeric_modifier("Critical Hit Percent")/100).to_string());
				break;
			case "SPELL_MULT"
				m.append_replacement(b, (numeric_modifier("spell damage percent")/100).to_string());
				break;
			case "WEAPON_MULT"
				m.append_replacement(b, (numeric_modifier("Weapon Damage Percent")/100).to_string());
				break;
			ase "RANGED_MULT"
				m.append_replacement(b, (numeric_modifier("Ranged Damage Percent")/100).to_string());
				break;
			case "SPELL_MULT"
				m.append_replacement(b, (numeric_modifier("spell damage percent")/100).to_string());
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
	print(b.to_string());
	return modifier_eval(b.to_string());
}

float el_damage_dealt(combat_spell spell, float min, float max, element el, monster mon)
{
	/*
	string capped_spell_dmg = "ceil(el_mult*multiplier*((base+floor(MYS*myst_scale))*crit+bonus_spell_damage+bonus_elemental_damage))";
	string uncapped_spell_dmg = "ceil(el_mult*multiplier*min(cap,(base+floor(MYS*myst_scale))*crit+bonus_spell_damage+bonus_elemental_damage))";
	*/
	float [string] vars;
	foreach var in spell.dmg_props
	{
		vars[var] = spell.dmg_props[var];
	}
	if(!vars contains "SAUCE")
	{
		vars["SAUCE"] = 0.0;
	}
	if(!vars contains "PASTA")
	{PASTA
		vars["PASTA"] = 0.0;
	}
	vars["base"] = (max + min)/2;
	vars["MON_GROUP"] = 1; // to replace
	switch(el)
	{
		case $element[hot]:
			vars["bonus_elemental_damage"] = numeric_modifier("hot spell damage");
			switch(mon.monster_element())
			{
				case $element[hot]:
					vars["el_mult"] = 0;
				break;
				case $element[cold]:
				case $element[spooky]:
					vars["el_mult"] = 2;
				break;
				default:
					vars["el_mult"] = 1;
				break;
			}
		break;
		case $element[cold]:
			vars["bonus_elemental_damage"] = numeric_modifier("cold spell damage");
			switch(mon.monster_element())
			{
				case $element[cold]:
					vars["el_mult"] = 0;
				break;
				case $element[sleaze]:
				case $element[stench]:
					vars["el_mult"] = 2;
				break;
				default:
					vars["el_mult"] = 1;
				break;
			}
		break;
		case $element[sleaze]:
			vars["bonus_elemental_damage"] = numeric_modifier("sleaze spell damage");
			switch(mon.monster_element())
			{
				case $element
				[hot]:
				case $element[stench]:
					vars["el_mult"] = 2;
				break;
				case $element[sleaze]:
					vars["el_mult"] = 0;
				break;
				default:
					vars["el_mult"] = 1;
				break;
			}
		break;
		case $element[spooky]:
			vars["bonus_elemental_damage"] = numeric_modifier("spooky spell damage");
			switch(mon.monster_element())
			{
				case $element[cold]:
				case $element[sleaze]:
					vars["el_mult"] = 2;
				break;
				case $element[spooky]:
					vars["el_mult"] = 0;
				break;
				default:
					vars["el_mult"] = 1;
				break;
			}
		break;
		case $element[stench]:
			switch(mon.monster_element())
			{
				case $element[hot]:
				case $element[spooky]:
					vars["el_mult"] = 2;
				break;
				case $element[stench]:
					vars["el_mult"] = 0;
				break;
				default:
					vars["el_mult"] = 1;
				break;
			}
			vars["bonus_elemental_damage"] = numeric_modifier("stench spell damage");
		break;
		default:
			vars["bonus_elemental_damage"] = 1;
			vars["el_mult"] = 1;
		break;
	}
	return dmg_eval(spell.dmg_exp, vars);
}

float damage_dealt(combat_spell spell, monster mon)
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
			foreach el in spell.min_damage
			{
				total_damage += el_damage_dealt(spell, spell.min_damage[el], spell.max_damage[el], el, mon);
			}
		}
	}
	return total_damage;
}
float damage_dealt(combat_spell spell)
{
	return damage_dealt(spell,last_monster());
}
float damage_dealt(skill spell, monster mon)
{
	return damage_dealt(cmbt_spells[spell],mon);
}
float damage_dealt(skill spell)
{
	return damage_dealt(cmbt_spells[spell],last_monster());
}
//////////////////////////////////
//Skill Picking

	skdmg [int] best_spells(monster mon, boolean have_only)
	{
		float mp_regen = (numeric_modifier("mp regen min") + numeric_modifier("mp regen max"))/2;
		boolean [skill] choices;
		foreach num in spell_skills
		{
			if(have_skill(spell_skills[num]) && have_only)
			{
				choices[spell_skills[num]] = true;
			}
			else if (!have_only)
			{
				choices[spell_skills[num]] = true;
			}
			/*
			if(mp_cost(spell_skills[num]) < mp_regen && have_skill(spell_skills[num]))
			{
				choices[spell_skills[num]] = true;
			}*/
		}
		skdmg [int] spellranks;
		foreach sk in choices
		{
			skdmg myskdmg = new skdmg();
			myskdmg.dmg = damage_dealt(sk,mon);
			myskdmg.sk = sk;
			myskdmg.ttd = ceil(mon.monster_hp()/ max(1,myskdmg.dmg));
			myskdmg.tmtw = myskdmg.ttd * mp_cost(sk);
			myskdmg.dmg_taken = mon.expected_damage() * myskdmg.ttd;
			spellranks[spellranks.count()] = myskdmg;

		}
		foreach num in spellranks
		{
			if(spellranks[num].ttd > 15)
			{
				remove spellranks[num];
			}
		}
		sort spellranks by value.tmtw;
		return spellranks;
	}
	skdmg [int] best_spells(monster mon)
	{
		return best_spells(mon, true);
	}
	skdmg [int] best_spells(boolean have_only)
	{
		return best_spells(last_monster(), have_only);
	}
	skdmg [int] best_spells()
	{
		return best_spells(last_monster(), true);
	}

	void print_best_spells(monster mon, boolean have_only)
	{
		print("monster is: " +  mon.to_string());
		skdmg [int] bs = best_spells(mon, have_only);
		foreach num in bs
		{
			print_html("%s has damage %s, ttd %s, mana used %s, dmg_taken %s",string [int] {to_string(bs[num].sk),to_string(bs[num].dmg),to_string(bs[num].ttd),to_string(bs[num].tmtw),to_string(bs[num].dmg_taken)});
		}
	}
	void print_best_spells(boolean have_only)
	{
		print_best_spells(last_monster(), have_only);
	}
	void print_best_spells(monster mon)
	{
		print_best_spells(mon, true);
	}
	void print_best_spells()
	{
		print_best_spells(last_monster(), true);
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
					print_best_spells(false);
				break;
				case 2:
					print_best_spells(arry[1].to_monster(),false);
				break;
			}
			case "spell":
			switch(arry.count())
			{
				case 1:
					print_best_spells();
				break;
				case 2:
					print_best_spells(arry[1].to_monster());
				break;
			}
		break;
		case "all":
		break;
		case "attack":
		break;
		case "all attacks":
		break;
		default:
		break;
	}
}

void main(string command)
{
	beefy_combat_tools_parse(command);
}