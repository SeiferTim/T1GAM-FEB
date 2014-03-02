package ;
import flixel.FlxObject;

class Player extends DisplaySprite
{
	private var _shadow:MeatBagShadow;
	private var _image:DisplaySprite;
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(24, 24, 0x0);
		
		width = 12;
		height = 14;
		offset.x = 6;
		offset.y = 8;
		
		_image = new DisplaySprite();
		_image.relativeX = 0;
		_image.relativeY = 0;
		
		_image.loadGraphic("assets/images/player.png", true, true, 24, 24);
		_image.animation.add("up-walk", [6, 7, 8], 8);
		_image.animation.add("down-walk", [3, 4, 5], 8);
		_image.animation.add("lr-walk", [0, 1, 2], 8);
		_image.animation.add("up", [6], 60, false);
		_image.animation.add("down", [3], 60, false);
		_image.animation.add("lr", [0], 60, false);
		_image.animation.play("down");
		_image.forceComplexRender = true;
		_image.calcZ = false;
		_image.z = 10;
		add(_image);
		forceComplexRender = true;
		_shadow = new MeatBagShadow(X, Y);
		_shadow.relativeX = 4;
		_shadow.relativeY = 8;
		_shadow.calcZ = false;
		_shadow.z = 0;
		add(_shadow);
	}
	
	override public function update():Void 
	{
		
		if (velocity.x > 0 && Math.abs(velocity.x) > Math.abs(velocity.y))
		{
			facing = FlxObject.RIGHT;
			
			
		}
		else if (velocity.x < 0 && Math.abs(velocity.x) > Math.abs(velocity.y))
		{
			facing = FlxObject.LEFT;
			
		}
		else if (velocity.y > 0)
		{
			facing = FlxObject.DOWN;
			
		}
		else if (velocity.y < 0)
		{
			facing = FlxObject.UP;
		}
		
		if (velocity.x != 0 || velocity.y != 0)
		{
			switch (facing)
			{
				case FlxObject.LEFT:
					_image.animation.play("lr-walk");
				case FlxObject.RIGHT:
					_image.animation.play("lr-walk");
				case FlxObject.UP:
					_image.animation.play("up-walk");
				case FlxObject.DOWN:
					_image.animation.play("down-walk");
			}
		}
		else
		{
			switch (facing)
			{
				case FlxObject.LEFT:
					_image.animation.play("lr");
				case FlxObject.RIGHT:
					_image.animation.play("lr");
				case FlxObject.UP:
					_image.animation.play("up");
				case FlxObject.DOWN:
					_image.animation.play("down");
			}
		}
		
		super.update();
	}
	
}