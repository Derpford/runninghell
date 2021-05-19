class HellrunnerHUD : BaseStatusBar
{
	// Gotta be able to see the score.
	HUDFont mBigFont; 

	override void NewGame()
	{
		Super.NewGame();
	}

	override void Init()
	{
		mBigFont = HUDFont.Create("BIGFONT");	
	}

	override void Draw(int state, double ticfrac)
	{
		Super.Draw(state, ticfrac);

		BeginHUD();
		DrawFullScreenStuff();
	}

	void DrawFullScreenStuff()
	{
		let plr = HellRunner(CPlayer.mo);

		int btxtflags = DI_SCREEN_CENTER_BOTTOM|DI_TEXT_ALIGN_CENTER;
		int ttxtflags = DI_SCREEN_CENTER|DI_TEXT_ALIGN_CENTER;
		int cbarflags = DI_SCREEN_CENTER_BOTTOM|DI_ITEM_CENTER_BOTTOM;

		// The score.
		DrawString(mBigFont,FormatNumber(plr.score,10),(0,-32),btxtflags,Font.CR_BRICK);

		// The speedometer.
		let velCol = Font.CR_RED;
		if(plr.vel.Length()<15)
		{
			velCol = Font.CR_BLUE;
		}
		DrawString(mBigFont,FormatNumber(plr.vel.Length(),5),(0,-96),btxtflags,velCol);

		if(plr.linkcount > 0)
		{
			// The current link count.
			DrawString(mBigFont,"LINK "..plr.linkcount,(0,-128),ttxtflags,Font.CR_CYAN);
			Fill(color(128,128,128,255),-plr.linktimer,-140,plr.linktimer*2,16,ttxtflags|DI_ITEM_CENTER_BOTTOM);
		}


		// Keys.
		String keySprites[6] =
		{
			"STKEYS2",
			"STKEYS0",
			"STKEYS1",
			"STKEYS5",
			"STKEYS3",
			"STKEYS4"
		};

		for(int i = 0; i < 6; i++)
		{
			if(CPlayer.mo.CheckKeys(i+1,false,true)) { DrawImage(keySprites[i],(-40+(16*i),-56),cbarflags,scale:(2,2)); }
		}
	}

}