class HellRunner : DoomPlayer
{
	// The star of the show.

	int slideframes;
	int jumpframes;

	int linkcount;
	int linktimer;

	default
	{
		Player.StartItem "PulsarHand";
		//Speed 0.8;
		Friction 0.99;
	}

	override void Tick()
	{
		Super.Tick();
		// Add a damage aura when the player is above a certain speed.
		if(vel.Length()>10)
		{
			A_Explode(ceil(vel.Length()*(1.5+CountInv("PowerStrength"))),vel.Length()*3+radius,flags:XF_NOTMISSILE,fulldamagedistance:radius);
		}

		// Damage is healed...from your score.
		if(health < 100 && score >= 5)
		{
			int amt = min(100-health,5);
			score -= amt;
			A_GiveInventory("Health",amt);
		}

		// Handle link chains and scoring from that.
		linktimer = max(linktimer-1,0);

		if(linktimer < 1 && linkcount > 0)
		{
			A_GiveInventory("ScoreItem",linkcount);
			linkcount = max(linkcount-1,0);
		}
		// Now let's handle special inputs.

		// Raw inputs.
		let btn = GetPlayerInput(INPUT_BUTTONS);
		let oldbtn = GetPlayerInput(INPUT_OLDBUTTONS);
		// Is the player inputting a direction?
		bool isMoving = btn & (BT_FORWARD | BT_BACK | BT_MOVELEFT | BT_MOVERIGHT);
		// What's the actual direction we're inputting?
		double xv = 0.0; double yv = 0.0; double ang = 0.0;
		if(isMoving)
		{
			xv = GetPlayerInput(MODINPUT_FORWARDMOVE)/12800.0;
			yv = GetPlayerInput(MODINPUT_SIDEMOVE)/10240.0;
			ang = atan2(-yv,xv);
		}

		// Tick down timers.
		slideframes = max(slideframes-1,0);
		jumpframes = max(jumpframes-1,0);

		// Handle sliding.
		if(btn & BT_CROUCH)
		{
			// Slide!
			friction = 1.08;
			if(!(oldbtn & BT_CROUCH) && slideframes < 1 && isMoving)
			{
				// Sliding gives you a slight boost in your movement direction,
				// but only if you haven't done a slide boost within the past second.
				// No spam 4 u.
				// If you don't input a direction, you don't get a slide.
				Thrust(5,ang+angle);
			}

			// And pseudo-trimping.
			if(vel.z<0 && abs(vel.z)*2.0>abs(floorz-pos.z) && slideframes > 15)
			{
				Thrust(-vel.z*0.5,ang+angle);
				vel.z *= 0.5;
			}
			slideframes = 35;
		}
		else if(slideframes < 15)
		{
			// Friction only resets a certain amount of time *after* leaving a slide.
			friction = 0.99;
		}

		// Handle special jumping cases.
		if(btn & BT_JUMP && floorz - pos.z == 0)
		{
			if(isMoving && jumpframes < 1)
			{
				// Jumping while moving gives a boost.
				Thrust(1,ang+angle);
			} 
			else if(!isMoving && btn & BT_CROUCH && jumpframes < 1)
			{
				// If you're crouching and you hit the jump button without pressing a movement key,
				// you do a super jump.
				vel.z += 20;
				jumpframes = 35;
			}
		}
	}

	void LinkUp()
	{
		// Standardized way of increasing Link Count.
		linkcount += 1;
		linktimer = 70;
	}

	override bool CanTouchItem(Inventory item)
	{
		if(super.CanTouchItem(item))
		{
			LinkUp();
			return true;
		}
		else
		{
			return false;
		}
	}
}

class PulsarHand : Weapon
{
	// Your primary weapon. Also a means of getting around.

	int boost;

	default
	{
		Weapon.SlotNumber 1;
	}

	states
	{
		Select:
			PUNG A 1 A_Raise();
			Loop;
		Deselect:
			PUNG A 1 A_Lower(); // I don't even think we have any other weapons...
			Loop;
		Ready:
			PUNG A 1 
			{
				A_WeaponReady();
				invoker.boost = 0;
			}
			Loop;
		Fire:
			PUNG D 5
			{
				// The projectile gets fired here. But first:
				let pit = invoker.owner.pitch;
				let ang = invoker.owner.angle;
				let spd = invoker.owner.vel.Length();
				invoker.owner.Vel3DFromAngle(-spd,ang,pit);
				// And now the shot.
				A_FireProjectile("PulsarBlast");
				A_StartSound("weapons/pulsf");
				// TODO: Pick better sound
			}
			PUNG C 15;
			PUNG B 10;
			PUNG A 5;
			Goto Ready;
		AltFire:
			PUNG A 1
			{
				// Increase boost.
				invoker.boost = clamp(0,invoker.boost+1,35);

				// Slow player.
				Vector3 newvel = invoker.owner.vel;
				newvel.x = newvel.x * 0.5;
				newvel.y = newvel.y * 0.5;
				newvel.z = newvel.z * 0.2;
				invoker.owner.vel = newvel;
				// Suck in coins.
				let ti = ThinkerIterator.Create("ScoreItem",STAT_DEFAULT);
				Thinker mo;
				while(mo = ti.Next())
				{
					let act = Actor(mo);
					let inv = Inventory(mo);
					bool isCoin = mo is "CoinCopper" || mo is "CoinSilver" || mo is "CoinGold";
					if(isCoin && CheckIfCloser(act,256,true))
					{
						console.printf(mo.GetClassName());
						act.VelIntercept(invoker.owner,30);

						let btn = invoker.owner.GetPlayerInput(INPUT_BUTTONS);
						bool isMoving = btn & (BT_FORWARD | BT_BACK | BT_MOVELEFT | BT_MOVERIGHT);

						if(!isMoving
						&& act.Vec2To(invoker.owner).Length()<invoker.owner.radius
						&& act.pos.z < invoker.owner.pos.z+invoker.owner.height
						&& act.pos.z+act.height > invoker.owner.pos.z)
						{
							// All that just to simulate giving an item.
							let plr = HellRunner(invoker.owner);
							invoker.owner.A_GiveInventory(mo.GetClassName(),inv.amount);
							plr.LinkUp();
							act.A_Remove(AAPTR_DEFAULT,RMVF_EVERYTHING);
						}
					}
				}
			}
			PUNG A 0 A_Refire();
		AltRelease:
			PUNG A 0
			{
				if(invoker.boost > 15) { return ResolveState(null); } else { return ResolveState("Ready"); }
			}
			PUNG D 5
			{
				invoker.owner.Vel3DFromAngle(invoker.boost,invoker.owner.angle,invoker.owner.pitch);
			}
			PUNG C 4;
			PUNG B 3;
			Goto Ready;
	}
}

class PulsarBlast : FastProjectile
{
	// Burst of plasma goodness.

	default
	{
		Speed 50;
		PROJECTILE;
		RenderStyle "Add";
		DamageFunction 60;
		Scale 2;
		MissileType "PulsarTrail";
		MissileHeight 8;
	}

	states
	{
		Spawn:
			PLSS AB 4 Bright;
			Loop;
		Death:
			PLSE A 4 Bright 
			{ 
				A_Explode(128,flags:XF_THRUSTZ); 
				A_StartSound("weapons/rocklx");
				A_RadiusThrust(flags:RTF_AFFECTSOURCE|RTF_THRUSTZ|RTF_NOIMPACTDAMAGE);
			}
			PLSE BCDE 5 Bright;
			Stop;
	}
}

class PulsarTrail : Actor
{
	// A long tail for the Pulsar shot.

	default
	{
		+NOINTERACTION;
		RenderStyle "Add";
		Scale 0.5;
	}

	states
	{
		Spawn:
			PLSE ABCDE 3 Bright;
			Stop;
	}
}