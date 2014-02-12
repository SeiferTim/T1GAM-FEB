package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class OptionsState extends FlxState
{
	private var _loaded:Bool = false;
	private var _leaving:Bool = false;
	#if desktop
	private var _optScreen:FlxButton;
	private var _optSize:FlxButton;
	#end

	override public function create():Void 
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		var _txtOpts:FlxText = new FlxText(0, 16, FlxG.width, "Options", 8);
		_txtOpts.alignment = "center";
		add(_txtOpts);
		
		var _optText1:FlxText = new FlxText(16, 48, 100, "Volume", 8);
		add(_optText1);
		
		var _optSlide1:CustomSlider = new CustomSlider(_optText1.x + _optText1.width + 16, _optText1.y, Std.int (FlxG.width - _optText1.width - 80), 64, 16, 14, 0, 1, SlideChange);
		_optSlide1.decimals = 1;
		_optSlide1.value = FlxG.sound.volume;
		add(_optSlide1);
		
		
		#if desktop
		var _optText2:FlxText = new FlxText(16, 72, 100, "Screen Mode", 8);
		add(_optText2);
		
		_optScreen = new FlxButton(_optText2.x + _optText2.width + 16, _optText2.y , FlxG.fullscreen ? "Fullscreen" : "Window", changeScreen);
		add(_optScreen);
		
		#end
		
		var _btnDone:FlxButton = new FlxButton(0, 0, "Done", goDone);
		FlxSpriteUtil.screenCenter(_btnDone, true, false);
		_btnDone.y = FlxG.height - _btnDone.height - 10;
		add(_btnDone);
		
		
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, true, doneFadeIn);
		
		super.create();
	}
	
	#if desktop
	private function changeScreen():Void
	{
		FlxG.fullscreen = !FlxG.fullscreen;
		Reg.IsFullscreen = FlxG.fullscreen;
		Reg.saves[0].data.fullscreen = FlxG.fullscreen;
		Reg.saves[0].flush();
		if (FlxG.fullscreen)
		{
			_optScreen.label.text = "Fullscreen";
		}
		else
		{
			_optScreen.label.text = "Window";
		}
	}
	
	#end
	
	private function goDone():Void
	{
		if (_leaving || !_loaded)
			return;
		_leaving = true;
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, goDoneDone);
		
	}
	
	private function goDoneDone():Void
	{
		FlxG.switchState(new MenuState());
	}
	
	private function SlideChange(Value:Float):Void
	{
		FlxG.sound.volume = Value;
		Reg.saves[0].data.volume = FlxG.sound.volume;
		Reg.saves[0].flush();
		FlxG.sound.play("blip");
	}
	
	private function doneFadeIn():Void
	{
		_loaded = true;
	}
	
}