class ScoreItemPlacer : EventHandler
{
	// Replaces all Bonuses with copper coins,
	// replaces all Ammo with silver coins,
	// replaces all health with gold coins.

	override void CheckReplacement(ReplaceEvent e)
	{
		if(e.Replacee is "HealthBonus" || e.Replacee is "ArmorBonus")
		{
			e.Replacement = "CoinCopper";
		}
		else if(e.Replacee is "Ammo")
		{
			e.Replacement = "CoinSilver";
		}
		else if(e.Replacee is "Health")
		{
			e.Replacement = "CoinGold";
		}
	}

}