script "beefy_combat_tools.ash";

//////////////////////////////////
//Global Variables

	//////////////////////////////////
	//Spells

	record combat_spell
	{
		skill sk;
		int cap;
		int groupmax;

		int [element] min_damage;
		int [element] max_damage;
		float [stat] boost;
		boolean [string] props;
		float [string] dmg_props;
		
		
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

	cmbt_spells[to_skill("Salsaball")] = new combat_spell(
		to_skill("Salsaball"),
		8,
		1,
		int [element]  {$element[hot] : 2},
		int [element]  {$element[hot] : 3},
		float [stat] {$stat[mysticality] : 0.0},
		boolean [string] {"sauce" : true}
		);
	/*
	cmbt_spells[to_skill("Salsaball")].sk = to_skill("Salsaball");
	cmbt_spells[to_skill("Salsaball")].min_damage[$element[hot]] = 2;
	cmbt_spells[to_skill("Salsaball")].max_damage[$element[hot]] = 3;
	cmbt_spells[to_skill("Salsaball")].boost[$stat[mysticality]] = 0.0;
	cmbt_spells[to_skill("Salsaball")].props["sauce"] = true;
	*/
	cmbt_spells[to_skill("Stream of Sauce")] = new combat_spell();
	cmbt_spells[to_skill("Stream of Sauce")].sk = to_skill("Stream of Sauce");
	cmbt_spells[to_skill("Stream of Sauce")].min_damage[$element[hot]] = 9;
	cmbt_spells[to_skill("Stream of Sauce")].max_damage[$element[hot]] = 11;
	cmbt_spells[to_skill("Stream of Sauce")].boost[$stat[mysticality]] = 0.2;
	cmbt_spells[to_skill("Stream of Sauce")].cap = 24;
	cmbt_spells[to_skill("Stream of Sauce")].props["sauce"] = true;

	cmbt_spells[to_skill("Surge of Icing")] = new combat_spell();
	cmbt_spells[to_skill("Surge of Icing")].sk = to_skill("Surge of Icing");
	cmbt_spells[to_skill("Surge of Icing")].min_damage[$element[none]] = 14;
	cmbt_spells[to_skill("Surge of Icing")].max_damage[$element[none]] = 18;
	cmbt_spells[to_skill("Surge of Icing")].boost[$stat[mysticality]] = 0.2;
	cmbt_spells[to_skill("Surge of Icing")].cap = 24;
	cmbt_spells[to_skill("Surge of Icing")].props["sauce"] = true;

	cmbt_spells[to_skill("Saucestorm")] = new combat_spell();
	cmbt_spells[to_skill("Saucestorm")].sk = to_skill("Saucestorm");
	cmbt_spells[to_skill("Saucestorm")].min_damage[$element[hot]] = 20;
	cmbt_spells[to_skill("Saucestorm")].max_damage[$element[hot]] = 24;
	cmbt_spells[to_skill("Saucestorm")].min_damage[$element[cold]] = 20;
	cmbt_spells[to_skill("Saucestorm")].max_damage[$element[cold]] = 24;
	cmbt_spells[to_skill("Saucestorm")].groupmax = 2;
	cmbt_spells[to_skill("Saucestorm")].boost[$stat[mysticality]] = 0.2;
	cmbt_spells[to_skill("Saucestorm")].cap = 50;
	cmbt_spells[to_skill("Saucestorm")].props["sauce"] = true;

		//Käsesoßesturm
	cmbt_spells[to_skill(4023)] = new combat_spell();
	cmbt_spells[to_skill(4023)].sk = to_skill(4023);
	cmbt_spells[to_skill(4023)].min_damage[$element[stench]] = 40;
	cmbt_spells[to_skill(4023)].max_damage[$element[stench]] = 44;
	cmbt_spells[to_skill(4023)].groupmax = 5;
	cmbt_spells[to_skill(4023)].boost[$stat[mysticality]] = 0.3;
	cmbt_spells[to_skill(4023)].cap = 100;
	cmbt_spells[to_skill("4023")].props["sauce"] = true;

	cmbt_spells[to_skill("Wave of Sauce")] = new combat_spell();
	cmbt_spells[to_skill("Wave of Sauce")].sk = to_skill("Wave of Sauce");
	cmbt_spells[to_skill("Wave of Sauce")].min_damage[$element[hot]] = 45;
	cmbt_spells[to_skill("Wave of Sauce")].max_damage[$element[hot]] = 50;
	cmbt_spells[to_skill("Wave of Sauce")].groupmax = 2;
	cmbt_spells[to_skill("Wave of Sauce")].boost[$stat[mysticality]] = 0.3;
	cmbt_spells[to_skill("Wave of Sauce")].cap = 100;
	cmbt_spells[to_skill("Wave of Sauce")].props["sauce"] = true;

	cmbt_spells[to_skill("Saucecicle")] = new combat_spell();
	cmbt_spells[to_skill("Saucecicle")].sk = to_skill("Saucecicle");
	cmbt_spells[to_skill("Saucecicle")].min_damage[$element[cold]] = 45;
	cmbt_spells[to_skill("Saucecicle")].max_damage[$element[cold]] = 50;
	cmbt_spells[to_skill("Saucecicle")].boost[$stat[mysticality]] = 0.4;
	cmbt_spells[to_skill("Saucecicle")].cap = 150;
	cmbt_spells[to_skill("Saucecicle")].props["sauce"] = true;

	cmbt_spells[to_skill("Saucegeyser")] = new combat_spell();
	cmbt_spells[to_skill("Saucegeyser")].sk = to_skill("Saucegeyser");
	cmbt_spells[to_skill("Saucegeyser")].min_damage[$element[hot]] = 60;
	cmbt_spells[to_skill("Saucegeyser")].max_damage[$element[hot]] = 70;
	cmbt_spells[to_skill("Saucegeyser")].min_damage[$element[cold]] = 60;
	cmbt_spells[to_skill("Saucegeyser")].max_damage[$element[cold]] = 70;
	cmbt_spells[to_skill("Saucegeyser")].props["best"] = true;
	cmbt_spells[to_skill("Saucegeyser")].groupmax = 3;
	cmbt_spells[to_skill("Saucegeyser")].boost[$stat[mysticality]] = 0.4;
	cmbt_spells[to_skill("Saucegeyser")].cap = 0;
	cmbt_spells[to_skill("Saucegeyser")].props["sauce"] = true;

	cmbt_spells[to_skill("Saucemageddon")] = new combat_spell();
	cmbt_spells[to_skill("Saucemageddon")].sk = to_skill("Saucemageddon");
	cmbt_spells[to_skill("Saucemageddon")].min_damage[$element[hot]] = 80;
	cmbt_spells[to_skill("Saucemageddon")].max_damage[$element[hot]] = 90;
	cmbt_spells[to_skill("Saucemageddon")].min_damage[$element[cold]] = 80;
	cmbt_spells[to_skill("Saucemageddon")].max_damage[$element[cold]] = 90;
	cmbt_spells[to_skill("Saucemageddon")].props["best"] = true;
	cmbt_spells[to_skill("Saucemageddon")].groupmax = 5;
	cmbt_spells[to_skill("Saucemageddon")].boost[$stat[mysticality]] = 0.5;
	cmbt_spells[to_skill("Saucemageddon")].cap = 0;
	cmbt_spells[to_skill("Saucemageddon")].props["sauce"] = true;

	//Pastamancer
	cmbt_spells[to_skill("Spaghetti Spear")] = new combat_spell();
	cmbt_spells[to_skill("Spaghetti Spear")].sk = to_skill("Spaghetti Spear");
	cmbt_spells[to_skill("Spaghetti Spear")].min_damage[$element[none]] = 80;
	cmbt_spells[to_skill("Spaghetti Spear")].max_damage[$element[none]] = 90;
	cmbt_spells[to_skill("Spaghetti Spear")].boost[$stat[mysticality]] = 0.0;
	cmbt_spells[to_skill("Spaghetti Spear")].cap = 8;
	cmbt_spells[to_skill("Spaghetti Spear")].props["pasta"] = true;
	

	cmbt_spells[to_skill("Ravioli Shurikens")] = new combat_spell();
	cmbt_spells[to_skill("Ravioli Shurikens")].sk = to_skill("Ravioli Shurikens");
	cmbt_spells[to_skill("Ravioli Shurikens")].min_damage[$element[none]] = 2;
	cmbt_spells[to_skill("Ravioli Shurikens")].max_damage[$element[none]] = 4;
	cmbt_spells[to_skill("Ravioli Shurikens")].boost[$stat[mysticality]] = 0;
	cmbt_spells[to_skill("Ravioli Shurikens")].cap = 10;
	cmbt_spells[to_skill("Ravioli Shurikens")].props["pasta random"] = true;
	cmbt_spells[to_skill("Ravioli Shurikens")].props["pasta"] = true;
	cmbt_spells[to_skill("Ravioli Shurikens")].props["butr"] = true;
	cmbt_spells[to_skill("Ravioli Shurikens")].dmg_props["repeat"] = 2;

	cmbt_spells[to_skill("Candyblast")] = new combat_spell();
	cmbt_spells[to_skill("Candyblast")].sk = to_skill("Candyblast");
	cmbt_spells[to_skill("Candyblast")].min_damage[$element[none]] = 8;
	cmbt_spells[to_skill("Candyblast")].max_damage[$element[none]] = 16;
	cmbt_spells[to_skill("Candyblast")].groupmax = 5;
	cmbt_spells[to_skill("Candyblast")].boost[$stat[mysticality]] = 0.25;
	cmbt_spells[to_skill("Candyblast")].cap = 50;
	cmbt_spells[to_skill("Candyblast")].props["pasta"] = true;

	cmbt_spells[to_skill("Cannelloni Cannon")] = new combat_spell();
	cmbt_spells[to_skill("Cannelloni Cannon")].sk = to_skill("Cannelloni Cannon");
	cmbt_spells[to_skill("Cannelloni Cannon")].min_damage[$element[none]] = 16;
	cmbt_spells[to_skill("Cannelloni Cannon")].max_damage[$element[none]] = 32;
	cmbt_spells[to_skill("Cannelloni Cannon")].groupmax = 2;
	cmbt_spells[to_skill("Cannelloni Cannon")].boost[$stat[mysticality]] = 0.25;
	cmbt_spells[to_skill("Cannelloni Cannon")].cap = 50;
	cmbt_spells[to_skill("Cannelloni Cannon")].props["pasta random"] = true;
	cmbt_spells[to_skill("Cannelloni Cannon")].props["pasta"] = true;
	cmbt_spells[to_skill("Cannelloni Cannon")].props["butr"] = true;

	cmbt_spells[to_skill("Stringozzi Serpent")] = new combat_spell();
	cmbt_spells[to_skill("Stringozzi Serpent")].sk = to_skill("Stringozzi Serpent");
	cmbt_spells[to_skill("Stringozzi Serpent")].min_damage[$element[none]] = 16;
	cmbt_spells[to_skill("Stringozzi Serpent")].max_damage[$element[none]] = 32;
	cmbt_spells[to_skill("Stringozzi Serpent")].groupmax = 2;
	cmbt_spells[to_skill("Stringozzi Serpent")].boost[$stat[mysticality]] = 0.25;
	cmbt_spells[to_skill("Stringozzi Serpent")].cap = 75;
	cmbt_spells[to_skill("Stringozzi Serpent")].props["pasta random"] = true;
	cmbt_spells[to_skill("Stringozzi Serpent")].props["pasta"] = true;
	cmbt_spells[to_skill("Stringozzi Serpent")].props["butr"] = true;

	cmbt_spells[to_skill("Stuffed Mortar Shell")] = new combat_spell();
	cmbt_spells[to_skill("Stuffed Mortar Shell")].sk = to_skill("Stuffed Mortar Shell");
	cmbt_spells[to_skill("Stuffed Mortar Shell")].min_damage[$element[none]] = 32;
	cmbt_spells[to_skill("Stuffed Mortar Shell")].max_damage[$element[none]] = 64;
	cmbt_spells[to_skill("Stuffed Mortar Shell")].groupmax = 3;
	cmbt_spells[to_skill("Stuffed Mortar Shell")].boost[$stat[mysticality]] = 0.5;
	cmbt_spells[to_skill("Stuffed Mortar Shell")].cap = 0;
	cmbt_spells[to_skill("Stuffed Mortar Shell")].props["pasta random"] = true;
	cmbt_spells[to_skill("Stuffed Mortar Shell")].props["pasta"] = true;

	cmbt_spells[to_skill("Weapon of the Pastalord")] = new combat_spell();
	cmbt_spells[to_skill("Weapon of the Pastalord")].sk = to_skill("Weapon of the Pastalord");
	cmbt_spells[to_skill("Weapon of the Pastalord")].min_damage[$element[none]] = 32;
	cmbt_spells[to_skill("Weapon of the Pastalord")].max_damage[$element[none]] = 64;
	cmbt_spells[to_skill("Weapon of the Pastalord")].boost[$stat[mysticality]] = 0.5;
	cmbt_spells[to_skill("Weapon of the Pastalord")].cap = 0;
	cmbt_spells[to_skill("Weapon of the Pastalord")].props["pastalord"] = true;
	cmbt_spells[to_skill("Weapon of the Pastalord")].props["pasta"] = true;

	cmbt_spells[to_skill("Fearful Fettucini")] = new combat_spell();
	cmbt_spells[to_skill("Fearful Fettucini")].sk = to_skill("Fearful Fettucini");
	cmbt_spells[to_skill("Fearful Fettucini")].min_damage[$element[spooky]] = 32;
	cmbt_spells[to_skill("Fearful Fettucini")].max_damage[$element[spooky]] = 64;
	cmbt_spells[to_skill("Fearful Fettucini")].groupmax = 2;
	cmbt_spells[to_skill("Fearful Fettucini")].boost[$stat[mysticality]] = 0.5;
	cmbt_spells[to_skill("Fearful Fettucini")].cap = 0;
	cmbt_spells[to_skill("Fearful Fettucini")].props["pasta"] = true;
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

float eval(string expr, float[string] vars)
{
   buffer b;
   matcher m = create_matcher( "\\b[a-z_][a-zA-Z0-9_]*\\b", expr );
   while (m.find()) {
      string var = m.group(0);
      if (vars contains var) {
         m.append_replacement(b, vars[var].to_string());
      }
      // could implement functions, pref access, etc. here
   }
   m.append_tail(b);
   return modifier_eval(b.to_string());
}

float el_damage_dealt(combat_spell spell, float min, float max, element el, monster mon)
{
	string dmg_expr;
	float [string] vars;
	if(spell.cap == 0)
	{
		dmg_expr = "ceil(el_mult*multiplier*floor(base*(1+myst_bonus))*crit+bonus_spell_damage+bonus_elemental_damage)";
	}
	else
	{
		dmg_expr = "ceil(el_mult*multiplier*min(cap,floor(base*(1+myst_bonus))*crit+bonus_spell_damage+bonus_elemental_damage))";
		vars["cap"] = spell.cap;
	}
	vars["multiplier"] = 1 + numeric_modifier("spell damage percent")/100;
	vars["base"] = (max + min)/2;
	vars["myst_bonus"] = spell.boost[$stat[mysticality]] * my_buffedstat($stat[mysticality]);
	vars["crit"] = 1;
	vars["bonus_spell_damage"] = numeric_modifier("spell damage");
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
				case $element[hot]:
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
	return eval(dmg_expr, vars);
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
	skdmg [int] best_spells(monster mon, boolean have_only)
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

	void print_best_spells(monster mon)
	{
		print("monster is: " +  mon.to_string());
		skdmg [int] bs = best_spells(mon);
		foreach num in bs
		{
			print_html("%s has damage %s, ttd %s, mana used %s, dmg_taken %s",string [int] {to_string(bs[num].sk),to_string(bs[num].dmg),to_string(bs[num].ttd),to_string(bs[num].tmtw),to_string(bs[num].dmg_taken)});
		}
	}
	void print_best_spells()
	{
		print_best_spells(last_monster());
	}

void beefy_combat_tools_parse(string command)
{
	string [int] arry = req.split_string(" ");
	switch (arry[0])
	{
		case "choose":
			switch(arry.count())
			{
				case 1:
					print(damage_dealt(arry[0].to_skill(),arry[1].to_monster()).to_string());
				break;
				case 2:
					skdmg [int] bdmgs = best_spells(arry[1].to_monster());
					foreach num in bdmgs
					{
						print(bdmgs[num].sk.to_string() + " : " + bdmgs[num].dmg.to_string());
					}
				break;
			}
		break;
	}
	else
	{
		
		if(arry[0] == "choose")
		{
			skdmg [int] bdmgs = best_spells();
			foreach num in bdmgs
			{
				print(bdmgs[num].sk.to_string() + " : " + bdmgs[num].dmg.to_string());
			}
		}
		else
		{
			print(damage_dealt(arry[0].to_skill()).to_string());
		}
	}
}

void main(string command)
{
	beefy_combat_tools_parse(command)
}