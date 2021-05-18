class TimedBonus : ScoreItem
{
	// Score item that bases its amount on the time of pickup.
	int BaseScore;
	int MinScore;
	int DecayRate; // How many tics is one point loss

	property Score : BaseScore, MinScore;
	property Decay : DecayRate;

	default
	{
		TimedBonus.Score 100,50;
		TimedBonus.Decay 70;
	}

	override bool CanPickup(Actor toucher)
	{
		console.printf("Age "..GetAge());
		console.printf("Decay "..DecayRate);
		amount = BaseScore - Floor(GetAge()/DecayRate);
		//return super.TryPickup(toucher);
		return true;
	}

	override string PickupMessage()
	{
		return Super.PickupMessage().." ("..amount..")";
	}

}

class CoinCopper : ScoreItem
{
	// Coins don't decay.
	default
	{
		Inventory.Amount 5;
		Scale 0.5;
		Inventory.PickupMessage "Copper coin! (5)";
	}

	states
	{
		Spawn:
			SCRC ABCDEFGH 2;
			Loop;
	}
}

class CoinSilver : ScoreItem
{
	default
	{
		Inventory.Amount 10;
		Scale 0.5;
		Inventory.PickupMessage "Silver coin! (10)";
	}

	states
	{
		Spawn:
			SCRS ABCDEFGH 2;
			Loop;
	}
}

class CoinGold : ScoreItem
{
	default
	{
		Inventory.Amount 20;
		Scale 0.5;
		Inventory.PickupMessage "Gold coin! (20)";
	}

	states
	{
		Spawn:
			SCRG ABCDEFGH 2;
			Loop;
	}
}

class GemSmall : TimedBonus
{
	// A small gemstone.

	default
	{
		Inventory.PickupMessage "Small gem!";
	}	

	states
	{
		Spawn:
			GEM1 A 0;
			GEM1 A 0
			{
				int sel = random(1,5);
				switch(sel)
				{
					case 1: return ResolveState("Idle1");
					case 2: return ResolveState("Idle2");
					case 3: return ResolveState("Idle3");
					case 4: return ResolveState("Idle4");
					case 5: return ResolveState("Idle5");
				}
				return ResolveState(null);
			}
		Idle1:
			GEM1 A 1;
			Loop;
		Idle2:
			GEM1 B 1;
			Loop;
		Idle3:
			GEM1 C 1;
			Loop;
		Idle4:
			GEM1 D 1;
			Loop;
		Idle5:
			GEM1 E 1;
			Loop;
	}
}

class GemMedium : GemSmall
{
	// A slightly larger gemstone.

	default
	{
		Inventory.PickupMessage "Gemstone!";
		Scale 1.5;
		TimedBonus.Score 200,100;
		TimedBonus.Decay 35;
	}

	states
	{
		Idle1:
			GEM2 A 1;
			Loop;
		Idle2:
			GEM2 B 1;
			Loop;
		Idle3:
			GEM2 C 1;
			Loop;
		Idle4:
			GEM2 D 1;
			Loop;
		Idle5:
			GEM2 E 1;
			Loop;
	}
}

class GemLarge : GemSmall
{
	// A beeg gemstone.

	default
	{
		Inventory.PickupMessage "Gemstone!";
		Scale 2.0;
		TimedBonus.Score 400,200;
		TimedBonus.Decay 20;
	}

	states
	{
		Idle1:
			GEM3 A 1;
			Loop;
		Idle2:
			GEM3 B 1;
			Loop;
		Idle3:
			GEM3 C 1;
			Loop;
		Idle4:
			GEM3 D 1;
			Loop;
		Idle5:
			GEM3 E 1;
			Loop;
	}
}