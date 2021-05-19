class BouncingBarrel : Actor replaces ExplosiveBarrel
{
	//A barrel that pops up into the air when you slam it.

	default
	{
		Health 20;
		Mass 1;
		+SHOOTABLE;
		+NOBLOOD;
		+ACTIVATEMCROSS;
		+NOICEDEATH;
		+DONTGIB;
		+SOLID;
		+OLDRADIUSDMG; // We kinda need all the old flags because some maps rely on them for pseudoscripting.
		Damagefactor "SpeedForce", 0;
	}

	states
	{
		Spawn:
			BAR1 AB 5;
			Loop;
		Death:
			BAR1 A 1
			{
				invoker.A_StartSound("weapons/rocketf");
				bTHRUACTORS = true;
				A_RadiusThrust(32,128);
				vel.z += 10;
			}
		DeathLoop:
			BAR1 AB 3;
			Loop;
		Crash:
			BEXP A 3 Bright
			{
				invoker.A_StartSound("world/barrelx");
				A_Explode();
			}
			BEXP BCD 4 Bright;
			BEXP E 5 Bright;
			TNT1 A 1050 Bright A_BarrelDestroy; // IDK who would play this in deathmatch with barrel respawn, but okay.
			TNT1 A 5 A_Respawn;
			Wait;

	}
}