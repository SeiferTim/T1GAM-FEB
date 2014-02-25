package ;

import flixel.addons.text.FlxBitmapFont;
import flixel.addons.ui.FlxButtonPlus;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class PauseScreen extends FlxGroup
{
	private var _alpha:Float;
	
	private var _back:FlxSprite;
	
	private var _grpMain:FlxGroup;
	private var _txtPause:GameFont;
	private var _btnResume:GameButton;
	private var _btnQuit:GameButton;
	private var _btnRetry:GameButton;
	private var _quitting:Bool = false;
	
	public var clickedResume:Bool = false;
	
	private var _askingConfirm:Bool = false;
	
	
	private var _grpConfirm:FlxGroup;
	private var _txtConfirm:GameFont;
	private var _btnYes:GameButton;
	private var _btnNo:GameButton;
	
	
	private var _helpKeys:FlxSprite;
	private var _helpMouse:FlxSprite;
	
	public function new() 
	{
		super(0);
	
		_back = new FlxSprite(4, 4).makeGraphic(FlxG.width-8, FlxG.height-8, 0x99000000);
		_back.scrollFactor.x = _back.scrollFactor.y = 0;
		
		add(_back);
		
		_grpMain = new FlxGroup();
		add(_grpMain);
		
		_txtPause = new GameFont("***   Paused   ***", GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_txtPause.y = 32;
		FlxSpriteUtil.screenCenter(_txtPause, true, false);
		_grpMain.add(_txtPause);
		
		
		
		_btnResume = new GameButton(0, 0, "Resume", goResume,GameButton.STYLE_LARGE);
		_btnResume.scrollFactor.x = _btnResume.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_btnResume);
		_grpMain.add(_btnResume);
		
		_btnRetry = new GameButton(0, 0, "Retry", goRetry, GameButton.STYLE_LARGE_GREEN);
		_btnRetry.scrollFactor.x = _btnRetry.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_btnRetry, true, false);
		_btnRetry.y = _btnResume.y + _btnResume.height + 16;
		_grpMain.add(_btnRetry);
		
		_btnQuit = new GameButton(0, 0, "Quit", goQuit,GameButton.STYLE_LARGE_RED);
		_btnQuit.scrollFactor.x = _btnQuit.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_btnQuit, true, false);
		_btnQuit.y = _btnRetry.y + _btnRetry.height + 16;
		_grpMain.add(_btnQuit);
		
		_grpConfirm = new FlxGroup();
		_grpConfirm.active = false;
		_grpConfirm.visible = false;
		add(_grpConfirm);
		
		
		
		_txtConfirm = new GameFont("Really Quit?",GameFont.STYLE_SM_WHITE,FlxBitmapFont.ALIGN_CENTER);
		_txtConfirm.y = 32;
		FlxSpriteUtil.screenCenter(_txtConfirm, true, false);
		_grpConfirm.add(_txtConfirm);
		
		_btnYes = new GameButton(0, 0, "Yes", onConfirmYes,GameButton.STYLE_LARGE_RED);
		_btnYes.scrollFactor.x = _btnYes.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_btnYes, false, true);
		_btnYes.x = (FlxG.width / 2) - _btnYes.width - 16;
		_grpConfirm.add(_btnYes);
		
		_btnNo = new GameButton(0, 0, "No", onConfirmNo,GameButton.STYLE_LARGE_GREEN);
		_btnNo.scrollFactor.x = _btnNo.scrollFactor.y = 0;
		_btnNo.x = (FlxG.width / 2) + 16;
		FlxSpriteUtil.screenCenter(_btnNo, false, true);
		_grpConfirm.add(_btnNo);
		
		#if !FLX_NO_KEYBOARD
		_helpKeys = new FlxSprite(0, 0, "assets/images/keyboard-controls.png");
		_helpKeys.x = (FlxG.width / 2) - _helpKeys.width - 96;
		_helpKeys.y = FlxG.height - _helpKeys.height - 48;
		_helpKeys.alpha = .8;
		add(_helpKeys);
		#end
		#if (!FLX_NO_MOUSE && !FLX_NO_TOUCH)
		_helpMouse = new FlxSprite(0, 0).loadGraphic("assets/images/touch-controls.png", true, false, 207, 56);
		_helpMouse.animation.add("play", [0, 1], 2);
		_helpMouse.animation.play("play");
		_helpMouse.x = (FlxG.width / 2) + 96;
		_helpMouse.y = FlxG.height - _helpMouse.height - 48;
		_helpMouse.alpha = .8;
		add(_helpMouse);
		#end
		
		alpha = 0;
	}
	
	private function goRetry():Void
	{
		if (alpha >= 1 && !_askingConfirm)
		{
			_quitting = false;
			_askingConfirm = true;
			_grpConfirm.active = true;
			_grpConfirm.visible = true;
			_grpMain.active = false;
			_grpMain.visible = false;
			_txtConfirm.text = "Really Retry?";
			FlxSpriteUtil.screenCenter(_txtConfirm, true, false);
		}
	}
	
	private function goQuit():Void
	{
		if (alpha >= 1 && !_askingConfirm)
		{
			_quitting = true;
			_askingConfirm = true;
			_grpConfirm.active = true;
			_grpConfirm.visible = true;
			_grpMain.active = false;
			_grpMain.visible = false;
			_txtConfirm.text = "Really Quit?";
			FlxSpriteUtil.screenCenter(_txtConfirm, true, false);
		}
	}
	
	private function onConfirmYes():Void
	{
		if (alpha < 1 || !_askingConfirm)
			return;
		
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, doneFadeQuit);
		
	}
	
	private function doneFadeQuit():Void
	{
		if (_quitting)
		{
			FlxG.sound.playMusic("title");
			FlxG.switchState(new MenuState());
		}
		else
			FlxG.switchState(new PlayState());
	}
	
	private function onConfirmNo():Void
	{
		if (alpha < 1 || !_askingConfirm)
			return;
		_grpConfirm.visible = false;
		_grpConfirm.active = false;
		_grpMain.active = true;
		_grpMain.visible = true;
		_askingConfirm = false;
		
	}
	
	private function goResume():Void
	{
		if (_alpha >= 1 && !_askingConfirm)
			clickedResume = true;
	}
	
	function get_alpha():Float 
	{
		return _alpha;
	}
	
	function set_alpha(value:Float):Float 
	{
		_alpha = value;
		
		_btnResume.label.alpha = _txtPause.alpha = _btnResume.alpha =  _back.alpha = _alpha;
		
		return _alpha;
	}
	
	public var alpha(get_alpha, set_alpha):Float;
	
}