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
	static public var levels:Array<Level> = [];
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
	static public var save:FlxSave;
	
	static public var playState:PlayState;
	
	static public var leftAlive:Int;
	static public var gameTime:Float;
	
	static public var mode:Int = 0;
	static public inline var MODE_NORMAL:Int = 0;
	static public inline var MODE_ENDLESS:Int = 1;
	static public inline var MODE_HUNGER:Int = 2;
	
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
		
		levels.push(new Level(0, 6));
		levels.push(new Level(1, 10));
		levels.push(new Level(2, 6));
		levels.push(new Level(3, 10));
		levels.push(new Level(4, 4));
		levels.push(new Level(5, 5));
		levels.push(new Level(6, 40));
		levels.push(new Level(7, 50));
		levels.push(new Level(8, 10));
		levels.push(new Level(9, 50));
		levels.push(new Level(10, 20));
		levels.push(new Level(11, 8));

		loadData();
		
		GameInitialized = true;
	}
	
	public static function loadData():Void
	{
		save = new FlxSave();
		save.bind("flixel");
		if (save.data.volume != null)
		{
			FlxG.sound.volume = save.data.volume;
		}
		else
			FlxG.sound.volume = 1;
		
		#if desktop
		IsFullscreen = (save.data.fullscreen != null) ? save.data.fullscreen : true;
		screensize = (save.data.screensize != null) ? save.data.screensize : SIZE_LARGE;
		#end

		var saveLength:Int = 0;
		
		if (save.data.scores != null)
		{
			saveLength = save.data.scores.length;

		}
		
		for (i in 0...levels.length)
		{
			if (i < saveLength)
			{
				levels[i].bestScores = save.data.scores[i];
			}
			else
			{
				levels[i].bestScores = [0,0];
			}
		}
		
		
		save.close();
		
	}
	
	public static function saveScores():Void
	{
		
		var s:Array<Array<Int>> = new Array<Array<Int>>();
		for (l in levels)
		{
			s.push(l.bestScores);
		}
		save.bind("flixel");
		save.data.scores = s;
		save.close();
	}
	
	
}