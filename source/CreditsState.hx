package ;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.text.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTileblock;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class CreditsState extends FlxState
{

	private var _loading:Bool = true;
	private var _leaving:Bool = false;
	
	
	override public function create():Void 
	{
		
		
		FlxG.autoPause = false;
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		var _grass:FlxSprite =  FlxGridOverlay.create(64, 64, FlxG.width + 64, FlxG.height+64, false, true, 0xff77C450, 0xff67b440);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_grass);
		add(_grass);
		
		
		var _random:FlxTileblock = new FlxTileblock(0, 0, FlxG.width+64, FlxG.height+64);
		_random.loadTiles("assets/images/random_junk.png", 32, 32, 64);
		_random.scrollFactor.x = _random.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_random);
		add(_random);
		
		add(new FlxSprite(4, 4).makeGraphic(FlxG.width - 8, FlxG.height - 8, 0x99000000));
		
		var _t1:NewGameFont = new NewGameFont(0, 16, "This game was made as part of");
		FlxSpriteUtil.screenCenter(_t1, true, false);
		add(_t1);
		
		/*
	
		
		var _text1:GameFont = new GameFont("This game was made as part of", GameFont.STYLE_TINY_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text1.y = 16;
		FlxSpriteUtil.screenCenter(_text1, true, false);
		add(_text1);
		
		var _text2:GameFont = new GameFont("Tim's 1-Game-a-Month Project", GameFont.STYLE_TINY_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text2.y = _text1.y + 12;
		FlxSpriteUtil.screenCenter(_text2, true, false);
		add(_text2);
		
		var _text3:GameFont = new GameFont("t1gam.tims-world.com", GameFont.STYLE_TINY_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text3.y = _text2.y  + 12;
		FlxSpriteUtil.screenCenter(_text3, true, false);
		add(_text3);
		
		var _btn:GameButton = new GameButton(_text3.x+ _text3.width + 16, _text3.y-4, "^", clickT1GamLink, GameButton.STYLE_SMALL, 0, true);
		add(_btn);
		
		var _text4:GameFont = new GameFont("Concept, Programming, Design: ", GameFont.STYLE_TINY_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text4.y = _text3.y + 20;
		FlxSpriteUtil.screenCenter(_text4, true, false);
		add(_text4);
		
		var _text5:GameFont = new GameFont("Tim I Hely - tims-world.com", GameFont.STYLE_TINY_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text5.y = _text4.y + 12;
		FlxSpriteUtil.screenCenter(_text5, true, false);
		add(_text5);
		
		var _btn:GameButton = new GameButton(_text5.x+ _text5.width + 16, _text5.y -4 , "^", clickTimsLink, GameButton.STYLE_SMALL, 0, true);
		add(_btn);
		
		
		
		var _text6:GameFont = new GameFont("Music: ", GameFont.STYLE_TINY_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text6.y = _text5.y + 20;
		FlxSpriteUtil.screenCenter(_text6, true, false);
		add(_text6);
		
		var _text7:GameFont = new GameFont("Fat Bard - fatbard.tumblr.com", GameFont.STYLE_TINY_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text7.y = _text6.y + 12;
		FlxSpriteUtil.screenCenter(_text7, true, false);
		add(_text7);
		
		var _btn:GameButton = new GameButton(_text7.x+ _text7.width + 16, _text7.y-4 , "^", clickFBLink, GameButton.STYLE_SMALL, 0, true);
		add(_btn);
		
		
		var _text8:GameFont = new GameFont("Art: ", GameFont.STYLE_TINY_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text8.y = _text7.y + 20;
		FlxSpriteUtil.screenCenter(_text8, true, false);
		add(_text8);
		
		var _text9:GameFont = new GameFont("Ryan Malm - ...", GameFont.STYLE_TINY_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text9.y = _text8.y + 12;
		FlxSpriteUtil.screenCenter(_text9, true, false);
		add(_text9);
		
		var _btn:GameButton = new GameButton(_text9.x+ _text9.width + 16, _text9.y-4 , "^", clickFBLink, GameButton.STYLE_SMALL, 0, true);
		add(_btn);*/
		
		var _btn:GameButton = new GameButton(0, 0, "Main Menu", clickMainMenu, GameButton.STYLE_SMALL,0, true);
		_btn.x = FlxG.width - _btn.width - 16;
		_btn.y = FlxG.height - GameButton.SIZE_SM_H - 16;
		add(_btn);
		
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, true, doneFadeIn);
		
		super.create();
	}

	
	
	private function clickFBLink():Void
	{
		FlxG.openURL("http://FatBard.tumblr.com");
	}
	
	private function clickT1GamLink():Void
	{
		FlxG.openURL("http://t1gam.tims-world.com");
	}
	
	private function clickTimsLink():Void
	{
		FlxG.openURL("http://tims-world.com");
	}
	
	private function doneFadeIn():Void
	{
		_loading = false;
	}
	
	private function clickMainMenu():Void
	{
		if (_loading || _leaving)
			return;
		_leaving = true;
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, doneFadeOut);
		
	}
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new MenuState());
	}
	
}