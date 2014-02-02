package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _btnPlay:FlxButton;
	private var _leaving:Bool = false;
	private var _loading:Bool = true;
	
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
		
		_btnPlay = new FlxButton(0, 0, "Play da Game", goGame);
		FlxSpriteUtil.screenCenter(_btnPlay, true, false);
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		add(_btnPlay);
		
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, true, fadeInDone);
		
		super.create();
	}
	
	private function fadeInDone():Void
	{
		_loading = false;
	}
	
	private function goGame():Void
	{
		if (_leaving || _loading )
			return;
		_leaving = true;
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
		super.update();
	}	
}