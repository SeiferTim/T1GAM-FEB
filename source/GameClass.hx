package;

import flash.display.StageQuality;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;

class GameClass extends FlxGame
{
	
	var gameWidth:Int = 683; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 384; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = MadeInSTLState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 120; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	
	/**
	 * You can pretty much ignore this logic and edit the variables above.
	 */
	public function new()
	{
		
		Lib.current.stage.quality = StageQuality.LOW;
		Reg.initGame();
		
		
		#if desktop
		startFullscreen = Reg.IsFullscreen;
		#end
		
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}
		
		#if debug
		initialState = MenuState;
		#end

		super(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);
		FlxG.autoPause = false;
		#if !FLX_NO_MOUSE
		FlxG.mouse.load("assets/images/cursor.png", 2, 0, 0);
		#end
	}
}
