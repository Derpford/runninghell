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
		}
		if(e.Replacee is "Ammo")
		{
			e.Replacement = "CoinSilver";
		}
		if(e.Replacee is "Health")
		{
			e.Replacement = "CoinGold";
		}

		// Weapon replacements
		if(e.Replacee is "Weapon")
		{
			if(e.Replacee is "Pistol" || e.Replacee is "Shotgun" || e.Replacee is "Chaingun")
			{
				e.Replacement = "GemSmall";
			}
			if(e.Replacee is "SuperShotgun" || e.Replacee is "RocketLauncher")
			{
				e.Replacement = "GemMedium";
			}
			if(e.Replacee is "PlasmaRifle" || e.Replacee is "Chainsaw" || e.Replacee is "BFG9000")
			{
				e.Replacement = "GemLarge";
			}
		}

		// Armor replacements
		if(e.Replacee is "Armor")
		{
			if(e.Replacee is "GreenArmor")
			{
				e.Replacement = "GemMedium";
			}

			if(e.Replacee is "BlueArmor")
			{
				e.Replacement = "GemLarge";
			}
		}
	}

}