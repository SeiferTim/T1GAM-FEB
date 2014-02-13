package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _btnPlay:FlxButton;
	private var _btnEndless:FlxButton;
	private var _btnOptions:FlxButton;
	private var _leaving:Bool = false;
	private var _loading:Bool = true;
	private var _tmr:FlxTimer;
	
	private var _grpStampede:FlxGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		_grpStampede = new FlxGroup(300);
		add(_grpStampede);
		
		_tmr = FlxTimer.start(FlxG.width/20000, SpawnMeatBag, 0);
		
		_btnPlay = new FlxButton(0, 0, "Play da Game", goGame);
		
		_btnPlay.x = (FlxG.width /2) - (_btnPlay.width * 1.5) - 32;
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		
		add(_btnPlay);
		
		_btnEndless = new FlxButton(0, 0, "Endless Mode", goEndless);
		
		_btnEndless.x = (FlxG.width /2) - (_btnPlay.width/2);
		_btnEndless.y = _btnPlay.y;
		add(_btnEndless);
		
		_btnOptions = new FlxButton(0, 0, "Options", goOptions);
		_btnOptions.x = (FlxG.width / 2) + (_btnOptions.width / 2) + 32;
		_btnOptions.y = _btnPlay.y;
		add(_btnOptions);
		
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, true, fadeInDone);
		
		super.create();
	}
	
	private function fadeInDone():Void
	{
		_loading = false;
	}
	
	private function goOptions():Void
	{
		if (_leaving || _loading)
			return;
		_leaving = true;
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, goOptionsDone);
	}
	
	private function goOptionsDone():Void
	{
		FlxG.switchState(new OptionsState());
	}
	
	private function goEndless():Void
	{
		if (_leaving || _loading)
			return;
		_leaving = true;
		Reg.mode = Reg.MODE_ENDLESS;
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, goGameDone);
	}
	
	
	private function goGame():Void
	{
		if (_leaving || _loading )
			return;
		_leaving = true;
		Reg.mode = Reg.MODE_NORMAL;
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, false, goGameDone);
	}
	
	
	
	private function goGameDone():Void
	{
		
		FlxG.switchState(new PlayState());
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		
		_grpStampede.forEachAlive(function(m) 
			{
				if (cast(m, MeatBag).x + cast(m, MeatBag).width < 0) 
				cast(m, MeatBag).kill();
			});
		_grpStampede.sort(zSort);
		
		
		
		super.update();
	}	
	
	private function zSort(Order:Int, A:FlxBasic, B:FlxBasic):Int
	{
		var zA:Float = Type.getClassName(Type.getClass(A)) == "ZEmitterExt" ? cast(A, ZEmitterExt).z : cast(A, DisplaySprite).z;
		var zB:Float = Type.getClassName(Type.getClass(B)) == "ZEmitterExt" ? cast(B, ZEmitterExt).z : cast(B, DisplaySprite).z;
		var result:Int = 0;
		if (zA < zB)
			result = Order;
		else if (zA > zB)
			result = -Order;
		return result;
	}
	
	private function SpawnMeatBag(T:FlxTimer):Void
	{
		var m:MeatBag;
		m = cast _grpStampede.recycle(MeatBag, [FlxG.width + 16,  FlxRandom.intRanged( -16, FlxG.height + 16)] );
		m.facing = FlxObject.LEFT;
		m.velocity.x = -400;
		m.isReal = false;
	}
}