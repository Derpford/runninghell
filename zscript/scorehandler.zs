class ScoreItemPlacer : EventHandler
{
	// Replaces all Bonuses with copper coins,
	// replaces all Ammo with silver coins,
	// replaces all health with gold coins.

	override void CheckReplacement(ReplaceEvent e)
	{
		// Coin replacements
		if(e.Replacee is "HealthBonus" || e.Replacee is "ArmorBonus")
		{
			e.Replacement = "CoinCopper";
			return;
		}
		if(e.Replacee is "Ammo")
		{
			e.Replacement = "CoinSilver";
			return;
		}
		if(e.Replacee is "Health")
		{
			e.Replacement = "CoinGold";
			return;
		}

		// Weapon replacements
		if(e.Replacee is "Weapon")
		{
			if(e.Replacee is "Pistol" || e.Replacee is "Shotgun" || e.Replacee is "Chaingun")
			{
				e.Replacement = "GemSmall";
				return;
			}
			if(e.Replacee is "SuperShotgun" || e.Replacee is "RocketLauncher")
			{
				e.Replacement = "GemMedium";
				return;
			}
			if(e.Replacee is "PlasmaRifle" || e.Replacee is "Chainsaw" || e.Replacee is "BFG9000")
			{
				e.Replacement = "GemLarge";
				return;
			}
		}

		// Armor replacements
		if(e.Replacee is "Armor")
		{
			if(e.Replacee is "GreenArmor")
			{
				e.Replacement = "GemMedium";
				return;
			}

			if(e.Replacee is "BlueArmor")
			{
				e.Replacement = "GemLarge";
				return;
			}
		}
	}

	override void WorldThingDied(WorldEvent e)
	{
		// Things drop coins on death based on their health.
		int amt = e.Thing.SpawnHealth();
		while(amt>0)
		{
			double xv = frandom(-8,8); double yv = frandom(-8,8);
			double zv = frandom(4,12);
			string it = "CoinCopper";
			if(amt>20) 
			{ 
				it = "CoinGold";
				amt -= 20;
			}
			else if(amt>10)
			{
				it = "CoinSilver";
				amt -= 10;
			}
			else
			{
				amt -= 5;
			}
			e.Thing.A_SpawnItemEX(it,xvel:xv,yvel:yv,zvel:zv);
		}
	}
}