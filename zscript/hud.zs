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

		// The score.
		DrawString(mBigFont,FormatNumber(plr.score,10),(0,-32),btxtflags,Font.CR_BRICK);

		if(plr.linkcount > 0)
		{
			// The current link count.
			DrawString(mBigFont,"LINK "..plr.linkcount,(0,-128),ttxtflags,Font.CR_CYAN);
			Fill(color(128,128,128,255),-plr.linktimer,-140,plr.linktimer*2,16,ttxtflags|DI_ITEM_CENTER_BOTTOM);
		}
	}

}