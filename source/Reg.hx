package;

import flixel.FlxG;
import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	
	static public inline var FADE_DUR:Float = 0.1;
	
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	static public var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	static public var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	static public var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	static public var score:Int = 0;
	/**
	 * Generic bucket for storing different <code>FlxSaves</code>.
	 * Especially useful for setting up multiple save slots.
	 */
	static public var saves:Array<FlxSave> = [];
	
	static public var playState:PlayState;
	
	static public var leftAlive:Int;
	static public var gameTime:Float;
	
	static public var mode:Int = 0;
	static public var MODE_NORMAL:Int = 0;
	static public var MODE_ENDLESS:Int = 1;
	
	static public var screensize:Int = 0;
	static public var SIZE_SMALL:Int = 0;
	static public var SIZE_LARGE:Int = 1;
	
	
	static public var GameInitialized:Bool = false;
	#if desktop
	static public var IsFullscreen:Bool;
	#end
	
	public static function initGame():Void
	{
		if (GameInitialized)
			return;
		saves.push(new FlxSave());
		saves[0].bind("flixel");
		if (saves[0].data.volume != null)
		{
			FlxG.sound.volume = saves[0].data.volume;
		}
		else
			FlxG.sound.volume = 1;
		
		#if desktop
		IsFullscreen = (saves[0].data.fullscreen != null) ? saves[0].data.fullscreen : true;
		screensize = (saves[0].data.screensize != null) ? saves[0].data.screensize : SIZE_LARGE;
		#end
		
		GameInitialized = true;
	}	
	
}