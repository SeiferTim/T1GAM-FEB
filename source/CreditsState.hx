package ;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.text.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
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
		
		var _grass:FlxSprite = FlxGridOverlay.create(16, 16, (Math.ceil(FlxG.width/16)*16)+8, (Math.ceil(FlxG.height/16)*16)+8,false, true, 0xff77C450, 0xff67b440);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_grass);
		add(_grass);
		
		add(new FlxSprite(4, 4).makeGraphic(FlxG.width - 8, FlxG.height - 8, 0x99000000));
		
		var _txtMode:GameFont = new GameFont("Credits", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);//new FlxBitmapFont("assets/images/small_white_font.png", 16, 16, FlxBitmapFont.TEXT_SET1, 96, 0, 0, 16, 0);
		_txtMode.scrollFactor.x = _txtMode.scrollFactor.y = 0;
		_txtMode.y = 16;
		FlxSpriteUtil.screenCenter(_txtMode, true, false);
		add(_txtMode);
		
	
		
		var _text:GameFont = new GameFont("This game was made as part of", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + 4;
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _text:GameFont = new GameFont("Tim's 1-Game-a-Month Project", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_txtMode.height+4) * 2);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _text:GameFont = new GameFont("t1gam.tims-world.com", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_txtMode.height+4) * 3);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _btn:GameButton = new GameButton(_text.x+ _text.width + 16, _text.y , "^", clickT1GamLink, GameButton.STYLE_SMALL, 0, true);
		add(_btn);
		
		var _text:GameFont = new GameFont("Concept, Programming, Design: ", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_txtMode.height+4) * 5);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _text:GameFont = new GameFont("Tim I Hely - tims-world.com", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_txtMode.height+4) * 6);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _btn:GameButton = new GameButton(_text.x+ _text.width + 16, _text.y , "^", clickTimsLink, GameButton.STYLE_SMALL, 0, true);
		add(_btn);
		
		
		
		var _text:GameFont = new GameFont("Music: ", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_txtMode.height+4) * 8);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _text:GameFont = new GameFont("Fat Bard - fatbard.tumblr.com", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_txtMode.height+4) * 9);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _btn:GameButton = new GameButton(_text.x+ _text.width + 16, _text.y , "^", clickFBLink, GameButton.STYLE_SMALL, 0, true);
		add(_btn);
		
		
		var _text:GameFont = new GameFont("Art: ", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_txtMode.height+4) * 11);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _text:GameFont = new GameFont("Ryan Malm - ...", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_txtMode.height+4) * 12);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _btn:GameButton = new GameButton(_text.x+ _text.width + 16, _text.y , "^", clickFBLink, GameButton.STYLE_SMALL, 0, true);
		add(_btn);
		
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