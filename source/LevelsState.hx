package ;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxSpriteAniRot;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class LevelsState extends FlxState
{

	private var _loading:Bool = true;
	private var _buttons:Array<FlxUIButton>;
	
	private var _btnModeNormal:FlxUIButton;
	private var _btnModeEndless:FlxUIButton;
	private var _locks:Array<FlxSprite>;
	
	override public function create() 
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
		
		add(new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x66000000));
		
		_btnModeNormal = new FlxUIButton((FlxG.width / 2) - 88, 32, "Normal Mode", changeMode.bind(Reg.MODE_NORMAL));
		_btnModeEndless = new FlxUIButton((FlxG.width / 2) + 8, 32, "Endless Mode", changeMode.bind(Reg.MODE_ENDLESS));
		
		_btnModeNormal.status = FlxButton.PRESSED;
		_btnModeNormal.skipButtonUpdate = true;
		
		add(_btnModeNormal);
		add(_btnModeEndless);
		
		_buttons = new Array<FlxUIButton>();
		var b:FlxUIButton;
		var buttonAndGapWidth:Float = 80 + 16;
		var buttonAndGapHeight:Float = 20 + 16;
		var screenWidth:Float = Math.floor((FlxG.width - 64) / (buttonAndGapWidth));
		_locks = new Array<FlxSprite>();
		for (l in Reg.levels)
		{
			var bX:Float = 32 + (Math.floor(l.number % screenWidth) * buttonAndGapWidth);
			var bY:Float = 84 + (Math.floor(l.number / screenWidth) * buttonAndGapHeight);

			b = new FlxUIButton(bX, bY, Std.string(l.number + 1), levelButtonClick.bind(l.number));
			add(b);
			if (!l.available)
			{
				b.status = FlxButton.PRESSED;
				b.skipButtonUpdate  = true;
				
				_locks[l.number] = new FlxSprite(b.x - 8 + (b.width/2) , b.y +  10, "assets/images/lock.png");
				add(_locks[l.number]);
			}
			_buttons.push(b);
			
		}
		
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, true, doneFadeIn);
		
		super.create();
	}
	
	private function changeMode(Mode:Int):Void
	{
		if (_loading)
			return;
		switch(Mode)
		{
			case Reg.MODE_NORMAL:
				_btnModeNormal.status = FlxButton.PRESSED;
				_btnModeEndless.status = FlxButton.NORMAL;
				_btnModeNormal.skipButtonUpdate = true;
				_btnModeEndless.skipButtonUpdate = false;
				Reg.mode = Reg.MODE_NORMAL;
				
			case Reg.MODE_ENDLESS:
				_btnModeEndless.status = FlxButton.PRESSED;
				_btnModeNormal.status = FlxButton.NORMAL;
				_btnModeEndless.skipButtonUpdate = true;
				_btnModeNormal.skipButtonUpdate = false;
				Reg.mode = Reg.MODE_ENDLESS;
				
		}
	}
	
	private function doneFadeIn():Void
	{
		_loading = false;
	}
	
	private function levelButtonClick(Number:Int):Void
	{
		if (_loading || _buttons[Number].skipButtonUpdate)
			return;
		Reg.level = Number;
		_loading = true;
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, doneFadeOut);
		
		
	}
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new PlayState());
	}
	
}