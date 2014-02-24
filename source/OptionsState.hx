package ;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.text.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class OptionsState extends FlxState
{
	private var _loaded:Bool = false;
	private var _leaving:Bool = false;
	#if desktop
	private var _optScreen:GameButton;
	private var _optSize:GameButton;
	#end

	private var _grpMain:FlxGroup;
	private var _grpConfirm:FlxGroup;
	private var _optSlide1:CustomSlider;
	
	override public function create():Void 
	{
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
		
		_grpMain = new FlxGroup();
		add(_grpMain);
		
		var _txtOpts:GameFont = new GameFont("Options", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
		_txtOpts.y = 16;
		FlxSpriteUtil.screenCenter(_txtOpts, true, false);
		_grpMain.add(_txtOpts);
		
		var _optText1:GameFont = new GameFont("Volume", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_RIGHT);  //(16, 48, 100, "Volume", 8);
		_optText1.x = 16;
		_optText1.y = 48;
		_grpMain.add(_optText1);
		
		_optSlide1 = new CustomSlider(_optText1.x + _optText1.width + 16, _optText1.y, Std.int (FlxG.width - _optText1.width - 80), 64, 16, 14, 0, 1, SlideChange);
		_optSlide1.decimals = 1;
		_optSlide1.value = FlxG.sound.volume;
		_grpMain.add(_optSlide1);
		
		
		#if desktop
		var _optText2:GameFont = new GameFont("Screen Mode", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_RIGHT);// (16, 72, 100, "Screen Mode", 8);
		_optText2.x = 16;
		_optText2.y = 72;
		_grpMain.add(_optText2);
		
		_optScreen = new  GameButton(_optText2.x + _optText2.width + 16, _optText2.y , FlxG.fullscreen ? "Fullscreen" : "Window", changeScreen, GameButton.STYLE_LARGE, 200);
		_grpMain.add(_optScreen);
		
		#end
		
		var _btnDone:GameButton = new GameButton(0, 0, "Done", goDone,GameButton.STYLE_LARGE);
		FlxSpriteUtil.screenCenter(_btnDone, true, false);
		_btnDone.y = FlxG.height - _btnDone.height - 16;
		_grpMain.add(_btnDone);
		
		
		
		var _btnClear:GameButton = new GameButton(0, 0, "Clear Data", goClearData, GameButton.STYLE_SMALL_RED, 0, true);
		_btnClear.y = FlxG.height - _btnClear.height - 16;
		_btnClear.x = FlxG.width - _btnClear.width - 16;
		_grpMain.add(_btnClear);
		
		_grpConfirm = new FlxGroup();
		_grpConfirm.active = false;
		_grpConfirm.visible = false;
		
		var _txtConfirm:GameFont = new GameFont("Clear Data?", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
		_txtConfirm.y = 16;
		FlxSpriteUtil.screenCenter(_txtConfirm, true, false);
		_grpConfirm.add(_txtConfirm);
		
		var _txtConfirmWarn:GameFont = new GameFont("Warning: This is PERMANANT!", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
		_txtConfirmWarn.y = 40;
		FlxSpriteUtil.screenCenter(_txtConfirmWarn, true, false);
		_grpConfirm.add(_txtConfirmWarn);
		
		var _btnYes:GameButton = new GameButton(0, 0, "Yes", goClearYes, GameButton.STYLE_LARGE_RED);
		_btnYes.x = (FlxG.width / 2) - _btnYes.width - 16;
		_btnYes.y = 64;
		_grpConfirm.add(_btnYes);
		
		var _btnNo:GameButton = new GameButton(0, 0, "No", goClearNo, GameButton.STYLE_LARGE_GREEN);
		_btnNo.x = (FlxG.width / 2) + 16;
		_btnNo.y = 64;
		_grpConfirm.add(_btnNo);
		
		add(_grpConfirm);
		
		Reg.save.bind("flixel");
		
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, true, doneFadeIn);
		
		super.create();
	}
	
	private function goClearYes():Void
	{
		
		Reg.save.erase();
		Reg.loadData();
		Reg.save.bind("flixel");
		_optSlide1.value = FlxG.sound.volume;
		_grpConfirm.visible = false;
		_grpConfirm.active = false;
		_grpMain.visible = true;
		_grpMain.active = true;
		
	}
	
	private function goClearNo():Void
	{
		_grpConfirm.visible = false;
		_grpConfirm.active = false;
		_grpMain.visible = true;
		_grpMain.active = true;
	}
	
	private function goClearData():Void
	{
		if (_leaving || !_loaded || _grpConfirm.visible)
			return;
		_grpConfirm.visible = true;
		_grpConfirm.active = true;
		_grpMain.visible = false;
		_grpMain.active = false;
		
		
	}
	
	#if desktop
	private function changeScreen():Void
	{
		FlxG.fullscreen = !FlxG.fullscreen;
		Reg.IsFullscreen = FlxG.fullscreen;
		Reg.save.data.fullscreen = FlxG.fullscreen;
		Reg.save.flush();
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
		if (_leaving || !_loaded|| _grpConfirm.visible)
			return;
		_leaving = true;
		Reg.save.close();
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, goDoneDone);
		
	}
	
	private function goDoneDone():Void
	{
		FlxG.switchState(new MenuState());
	}
	
	private function SlideChange(Value:Float):Void
	{
		FlxG.sound.volume = Value;
		Reg.save.data.volume = FlxG.sound.volume;
		Reg.save.flush();
		FlxG.sound.play("blip");
	}
	
	private function doneFadeIn():Void
	{
		_loaded = true;
	}
	
}