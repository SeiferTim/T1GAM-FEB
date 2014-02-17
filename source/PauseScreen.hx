package ;

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
	private var _txtPause:FlxText;
	private var _btnResume:FlxButton;
	private var _btnQuit:FlxButton;
	
	public var clickedResume:Bool = false;
	
	private var _askingConfirm:Bool = false;
	
	
	private var _grpConfirm:FlxGroup;
	private var _txtConfirm:FlxText;
	private var _btnYes:FlxButton;
	private var _btnNo:FlxButton;
	
	
	public function new() 
	{
		super(0);
	
		_back = new FlxSprite(4, 4).makeGraphic(FlxG.width-8, FlxG.height-8, 0x99000000);
		_back.scrollFactor.x = _back.scrollFactor.y = 0;
		
		add(_back);
		
		_grpMain = new FlxGroup();
		add(_grpMain);
		
		_txtPause = new FlxText(0, 16, FlxG.width, "Paused", 8);
		_txtPause.alignment = "center";
		_txtPause.scrollFactor.x = _txtPause.scrollFactor.y = 0;
		_grpMain.add(_txtPause);
		
		_btnResume = new FlxButton(0, 0, "Resume", goResume);
		_btnResume.scrollFactor.x = _btnResume.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_btnResume);
		_grpMain.add(_btnResume);
		
		_btnQuit = new FlxButton(0, 0, "Quit", goQuit);
		_btnQuit.scrollFactor.x = _btnQuit.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_btnQuit, true, false);
		_btnQuit.y = _btnResume.y + _btnResume.height + 16;
		_grpMain.add(_btnQuit);
		
		_grpConfirm = new FlxGroup();
		_grpConfirm.active = false;
		_grpConfirm.visible = false;
		add(_grpConfirm);
		
		
		
		_txtConfirm = new FlxText(0, 16, FlxG.width, "Really Quit?", 8);
		_txtConfirm.alignment = "center";
		_txtConfirm.scrollFactor.x = _txtConfirm.scrollFactor.y = 0;
		_grpConfirm.add(_txtConfirm);
		
		_btnYes = new FlxButton(0, 0, "Yes", onConfirmYes);
		_btnYes.scrollFactor.x = _btnYes.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_btnYes, false, true);
		_btnYes.x = (FlxG.width / 2) - _btnYes.width - 16;
		_grpConfirm.add(_btnYes);
		
		_btnNo = new FlxButton(0, 0, "No", onConfirmNo);
		_btnNo.scrollFactor.x = _btnNo.scrollFactor.y = 0;
		_btnNo.x = (FlxG.width / 2) + 16;
		FlxSpriteUtil.screenCenter(_btnNo, false, true);
		_grpConfirm.add(_btnNo);
		
		alpha = 0;
	}
	
	private function goQuit():Void
	{
		if (alpha >= 1 && !_askingConfirm)
		{
			_askingConfirm = true;
			_grpConfirm.active = true;
			_grpConfirm.visible = true;
			_grpMain.active = false;
			_grpMain.visible = false;
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
		FlxG.switchState(new MenuState());
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