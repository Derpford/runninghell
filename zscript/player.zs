class HellRunner : DoomPlayer
{
	// The star of the show.

	int slideframes;
	int jumpframes;

	default
	{
		Player.StartItem "PulsarHand";
		//Speed 0.8;
		Friction 0.99;
	}

	override void Tick()
	{
		Super.Tick();

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
			slideframes = 35;
			if(!(oldbtn & BT_CROUCH) && slideframes < 1 && isMoving)
			{
				// Sliding gives you a slight boost in your movement direction,
				// but only if you haven't done a slide boost within the past second.
				// No spam 4 u.
				// If you don't input a direction, you don't get a slide.
				Thrust(5,ang+angle);
			}
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
}

class PulsarHand : Weapon
{
	// Your primary weapon. Also a means of getting around.

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
			PUNG A 1 A_WeaponReady();
			Loop;
		Fire:
			PUNG D 5
			{
				// The projectile gets fired here. But first:
				let pit = invoker.owner.pitch;
				let ang = invoker.owner.angle;
				let spd = invoker.owner.vel.Length();
				invoker.owner.VelFromAngle(cos(pit)*-spd,ang);
				invoker.owner.vel.z = sin(pit)*spd;
			}
			PUNG C 15;
			PUNG B 10;
			PUNG A 5;
			Goto Ready;
	}
}