package ;

import flash.display.BitmapData;
import flash.geom.Point;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.text.FlxBitmapFont;
import flixel.addons.ui.FlxUIButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTileblock;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
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
		
		var _grass:FlxSprite =  FlxGridOverlay.create(64,48, FlxG.width + 64, FlxG.height+64, false, true, 0xff77C450, 0xff67b440);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_grass);
		add(_grass);
		
		
		var _random:FlxTileblock = new FlxTileblock(0, 0, FlxG.width+64, FlxG.height+64);
		_random.loadTiles("assets/images/random_junk.png", 32, 32, 64);
		_random.scrollFactor.x = _random.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_random);
		add(_random);
		
		add(new FlxSprite(4, 4).makeGraphic(FlxG.width - 8, FlxG.height - 8, 0x99000000));
		
		var _t1:NewGameFont = new NewGameFont(0, 8, "This game was made as part of", NewGameFont.STYLE_TINY);
		FlxSpriteUtil.screenCenter(_t1, true, false);
		add(_t1);
		
		var _t2:NewGameFont = new NewGameFont(0, _t1.y + _t1.height + 4, "Tim's 1-Game-a-Month Project", NewGameFont.STYLE_TINY);
		FlxSpriteUtil.screenCenter(_t2, true, false);
		add(_t2);
		
		var _t3:LinkText = new LinkText(0, _t2.y + _t2.height + 4, "t1gam.tims-world.com", clickT1GamLink);
		FlxSpriteUtil.screenCenter(_t3, true, false);
		add(_t3);
		
		//var _btn:GameButton = new GameButton(_t3.x+ _t3.width + 16, _t3.y+(_t3.height/2)-10, " ", clickT1GamLink, GameButton.STYLE_SMALL, 0, true);
		//add(_btn);
		
		var _t4:NewGameFont = new NewGameFont(0,_t3.y + _t3.height + 16,"Concept, Programming, Design",NewGameFont.STYLE_TINY);
		FlxSpriteUtil.screenCenter(_t4, true, false);
		add(_t4);
		
		var _t5:NewGameFont = new NewGameFont(0,_t4.y + _t4.height + 4, "Tim I Hely",NewGameFont.STYLE_MED,NewGameFont.COLOR_GREEN);
		FlxSpriteUtil.screenCenter(_t5, true, false);
		add(_t5);
		
		var _t6:LinkText = new LinkText(0, _t5.y + _t5.height + 4, "tims-world.com", clickTimsLink);
		FlxSpriteUtil.screenCenter(_t6, true, false);
		add(_t6);
		
		//var _btn:GameButton = new GameButton(_t5.x+ _t5.width + 16, _t5.y+(_t5.height/2)-10, " ", clickTimsLink, GameButton.STYLE_SMALL, 0, true);
		//add(_btn);
		
		var _t7:NewGameFont = new NewGameFont(0,_t6.y + _t6.height + 16,"Music",NewGameFont.STYLE_TINY);
		FlxSpriteUtil.screenCenter(_t7, true, false);
		add(_t7);
		
		var _t8:NewGameFont = new NewGameFont(0,_t7.y+_t7.height + 4,"Fat Bard", NewGameFont.STYLE_MED,NewGameFont.COLOR_GREEN);
		FlxSpriteUtil.screenCenter(_t8, true, false);
		add(_t8);
		
		var _t9:LinkText = new LinkText(0, _t8.y + _t8.height + 4, "fatbard.tumblr.com", clickFBLink);
		FlxSpriteUtil.screenCenter(_t9, true, false);
		add(_t9);
		
		//var _btn:GameButton = new GameButton(_text7.x+ _text7.width + 16, _text7.y-4 , "^", clickFBLink, GameButton.STYLE_SMALL, 0, true);
		//add(_btn);
		
		
		var _t10:NewGameFont = new NewGameFont(0,_t9.y+ _t9.height + 16,"Art",NewGameFont.STYLE_TINY);
		FlxSpriteUtil.screenCenter(_t10, true, false);
		add(_t10);
		
		var _t11:NewGameFont = new NewGameFont(0,_t10.y + _t10.height + 4, "Ryan Malm", NewGameFont.STYLE_MED,NewGameFont.COLOR_GREEN);
		FlxSpriteUtil.screenCenter(_t11, true, false);
		add(_t11);
		
		var _t12:LinkText = new LinkText(0, _t11.y + _t11.height + 4,  "ryanmalm.com", clickRyanLink);
		FlxSpriteUtil.screenCenter(_t12, true, false);
		add(_t12);
		
		
		var _t13:NewGameFont = new NewGameFont(0,_t12.y + _t12.height + 16, "Vicky Hedgecock", NewGameFont.STYLE_MED,NewGameFont.COLOR_GREEN);
		FlxSpriteUtil.screenCenter(_t13, true, false);
		add(_t13);
		
		
		//var _btn:GameButton = new GameButton(_text9.x+ _text9.width + 16, _text9.y-4 , "^", clickFBLink, GameButton.STYLE_SMALL, 0, true);
		//add(_btn);*/
		
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
	
	
	private function clickRyanLink():Void
	{
		FlxG.openURL("http://ryanmalm.com");
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