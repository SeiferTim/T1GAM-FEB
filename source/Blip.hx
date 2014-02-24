package ;

import flixel.FlxSprite;

class Blip extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X - 32, Y - 32);
		
		loadGraphic("assets/images/blip.png", true, false, 64, 64);
		animation.add("play", [0, 1, 2, 3, 4, 5], 30, false);
		//animation.play("play",true);
		kill();
		
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X - 32, Y - 32);		
		animation.play("play",true);
	}
	
	override public function update():Void 
	{
		if (animation.finished)
		{
			kill();
		}
		super.update();
	}
	
}