script "beefy_SRLightsOut.ash";

void DoLightsOut()
{
	string path = get_property("LightsOutPath");
	if(path == "none")
	{
		if(get_property("LightsOutPath") == "nextSpookyravenElizabethRoom")
		{
			path = get_property("nextSpookyravenStephenRoom");
		}
		else
		{
			path = get_property("nextSpookyravenElizabethRoom");
		}
	}
	print("Spookyraven Lights Out Adventure!");
	adv1(get_property(path).to_location(),-1,"");
}


void main(string setting)
{
	switch(setting.to_lower_case())
	{
		case "on":
			cli_execute("spookyraven on");
			set_property("LightsOutPath","nextSpookyravenStephenRoom");
			print("Spooky Raven Lights Out enabled, doing Stephen first");
			break;
		case "elizabeth":
		case "liz":
		case "e":
			cli_execute("spookyraven on");
			set_property("LightsOutPath","nextSpookyravenElizabethRoom");
			print("Spooky Raven Lights Out enabled, doing Elizabeth first");
			break;
		case "stephen":
		case "steph":
		case "s":
			cli_execute("spookyraven on");
			set_property("LightsOutPath","nextSpookyravenStephenRoom");
			print("Spooky Raven Lights Out enabled, doing Stephen first");
			break;
		case "off":
			cli_execute("spookyraven off");
			print("spookyraven disabled");
			break;
	}
}