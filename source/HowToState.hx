package ;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.text.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.macro.Expr.MetadataEntry;

class HowToState extends FlxState
{

	private var _hasKeys:Bool = true;
	private var _hasMouse:Bool = true;
	private var _hasTouch:Bool = true;
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
		
		var _txtMode:GameFont = new GameFont("How to Play", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);//new FlxBitmapFont("assets/images/small_white_font.png", 16, 16, FlxBitmapFont.TEXT_SET1, 96, 0, 0, 16, 0);
		_txtMode.scrollFactor.x = _txtMode.scrollFactor.y = 0;
		_txtMode.y = 16;
		FlxSpriteUtil.screenCenter(_txtMode, true, false);
		add(_txtMode);
		
		#if (FLX_NO_KEYBOARD)
		_hasKeys = false;
		#end
		#if (FLX_NO_MOUSE)
		_hasMouse = false;
		#end
		#if (FLX_NO_TOUCH)
		_hasTouch = false;
		#end
		
		var _text:GameFont = new GameFont("You are in charge of a flock of", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16;
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		var _text:GameFont = new GameFont("skittish animals called Meat Bags.", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + _text.height + 4;
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		
		if (_hasKeys && _hasMouse && _hasTouch)
		{			
			var _text:GameFont = new GameFont("Use WASD/Arrow Keys, Mouse, or Touch", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
			_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*3);
			FlxSpriteUtil.screenCenter(_text, true, false);
			add(_text);
		}
		else if (_hasMouse && _hasTouch)
		{			
			var _text:GameFont = new GameFont("Use the Mouse, or Touch", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
			_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*3);
			FlxSpriteUtil.screenCenter(_text, true, false);
			add(_text);
		}
		else if (_hasKeys && _hasTouch)
		{			
			var _text:GameFont = new GameFont("Use WASD/Arrow Keys, or Touch", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
			_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*3);
			FlxSpriteUtil.screenCenter(_text, true, false);
			add(_text);
		}
		else if (_hasKeys && _hasMouse)
		{			
			var _text:GameFont = new GameFont("Use WASD/Arrow Keys, or the Mouse", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
			_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*3);
			FlxSpriteUtil.screenCenter(_text, true, false);
			add(_text);
		}
		else if (_hasKeys)
		{			
			var _text:GameFont = new GameFont("Use WASD/Arrow Keys", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
			_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*3);
			FlxSpriteUtil.screenCenter(_text, true, false);
			add(_text);
		}		
		else if (_hasMouse)
		{			
			var _text:GameFont = new GameFont("Use the Mouse", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
			_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*3);
			FlxSpriteUtil.screenCenter(_text, true, false);
			add(_text);
		}
		else if (_hasTouch)
		{			
			var _text:GameFont = new GameFont("Use Touch", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
			_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*3);
			FlxSpriteUtil.screenCenter(_text, true, false);
			add(_text);
		}
		
		var _text:GameFont = new GameFont("to move around the pasture.", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*4);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		
		var _text:GameFont = new GameFont("Keep them from escaping, but don't", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*6);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		var _text:GameFont = new GameFont("get too close, or their weak", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*7);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		var _text:GameFont = new GameFont("hearts will burst, killing them!", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*8);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		
		var _text:GameFont = new GameFont("Game Modes", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*10);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _text:GameFont = new GameFont("Normal: last for 1 minute.", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*11);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		
		var _text:GameFont = new GameFont("Endless: last as long as you can.", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*12);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		
		var _text:GameFont = new GameFont("Hunger: kill them all as fast as you can!", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_text.y = _txtMode.y + _txtMode.height + 16 + ((_text.height+4)*13);
		FlxSpriteUtil.screenCenter(_text, true, false);
		add(_text);
		
		var _btn:GameButton = new GameButton(0, 0, "Main Menu", clickMainMenu, GameButton.STYLE_SMALL,0, true);
		_btn.x = FlxG.width - _btn.width - 16;
		_btn.y = FlxG.height - GameButton.SIZE_SM_H - 16;
		add(_btn);
		
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, true, doneFadeIn);
		
		super.create();
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