script "beefy_monsters.ash";

//////////////////////////////////
//Monsters

record monster_status
{
	monster me;
	boolean simulation;
	int hp;
	int attack;
	int defense;
	int damage;
	skdmg [skill] dots;
};

record dropdata {
   item drop;
   int rate;
   string type;
};

monster_status init(monster_status mon)
{
	if(!mon.simulation)
	{
		mon.hp = monster_hp();
		mon.attack = monster_attack();
		mon.defense = monster_defense();
		mon.damage = expected_damage();
	}
	else
	{
		mon.hp = mon.me.monster_hp();
		mon.attack = mon.me.monster_attack();
		mon.defense = mon.me.monster_defense();
		mon.damage = mon.me.expected_damage();
	}
	return mon;

}
monster_status mon_init(monster mon, boolean simulate)
{
	monster_status newms = new monster_status(mon, simulate);

	return newms.init();
}

int attack(monster_status mon)
{
	if(!mon.simulation)
	{
		return monster_attack();
	}
	return mon.attack;
}

int defense(monster_status mon)
{
	if(!mon.simulation)
	{
		return monster_defense();
	}
	return mon.defense;
}

int hp(monster_status mon)
{
	if(!mon.simulation)
	{
		return monster_hp();
	}
	return mon.hp;
}

int damage(monster_status mon)
{
	if(!mon.simulation)
	{
		return expected_damage();
	}
	return mon.damage;
}

string to_string(monster_status mon)
{
	return mon.me.to_string();
}

int monster_initiative(monster_status mon)
{
	if(!mon.simulation)
	{
		return monster_initiative();
	}
	return mon.monster_initiative();
}

element monster_element(monster_status mon)
{
	if(!mon.simulation)
	{
		return monster_element();
	}
	return mon.me.monster_element();
}

boolean [string] subtypes(monster_status mon)
{
	return mon.me.sub_types;
}

boolean is_banished(monster_status mon)
{
	return mon.me.is_banished();
}

int [item] item_drops(monster_status mon)
{
	if(!mon.simulation)
	{
		return item_drops();
	}
	return mon.item_drops();
}

dropdata [int] item_drops_array(monster_status mon)
{
	dropdata [int] drop_array;
	foreach index, rec in mon.item_drops_array()
	{
		drop_array[index] = new dropdata(rec.drop,rec.rate,rec.type);
	}
	return drop_array;
}

monster_status [int] get_mons(location loc)
{
	monster_status [int] mon_array;
	monster [int] mons = loc.get_monsters();
	foreach num in mons
	{
		mon_array[num] = mon_init(mons[num],true);
	}

	return mon_array;
}

/////////////
//Damage Effects
float monster_physical_reduction(monster_status mon)
{
	return (1.0 - to_float(mon.me.physical_resistance) / 100.0);
}

boolean [element,element] __mon_el_weakness = {
	$element[cold] : $elements[spooky, hot],
	$element[hot] : $elements[stench, sleaze],
	$element[sleaze] : $elements[cold, spooky],
	$element[spooky] : $elements[hot, stench],
	$element[stench] : $elements[sleaze, cold]
};

float damage_mult(monster_status mon, element el)
{
	if (el == $element[none])
	{
		return mon.monster_physical_reduction();
	}
	else
	{
		if (mon.monster_element() == el)
		{
			return 0.0;
		}
		else if(__mon_el_weakness[mon.monster_element(),el])
		{
			return 2.0;
		}
	}
	return 1;
}

boolean stagger_immune(monster mon, int ml)
{
	if(ml > 150)
	{
		return true;
	}
	return false;
}

int stun_resist(monster mon, int ml)
{
	return min(0,max(100,ml-50));
}

monster_status apply_skill(monster_status mon, skdmg skd)
{
	if(skd.dothitdmg != 0 || skd.attack_dlot != 0 || skd.defense_dlot != 0)
	{
		mon.dots[skd.sk] = skd;
	}
	mon.hp = mon.hp - skd.dothitdmg;
	mon.defense = mon.defense - skd.defense_dlot;
	mon.attack = mon.attack - skd.attack_dlot;

	mon.hp = mon.hp - skd.hitdmg;
	mon.defense = mon.defense - skd.defense_delevel;
	mon.attack = mon.attack - skd.attack_delevel;

	return mon;
}

monster_status next_turn(monster_status mon)
{
	foreach sk in mon.dots
	{
		mon.hp = mon.hp - mon.dots[sk].dothitdmg;
		mon.defense = mon.defense - mon.dots[sk].defense_dlot;
		mon.attack = mon.attack - mon.dots[sk].attack_dlot;
	}

	return mon;
}

boolean is_dead(monster_status mon)
{
	if(mon.hp <= 0)
	{
		return true;
	}
	return false;
}