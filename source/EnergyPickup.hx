package ;
import flixel.addons.display.FlxNestedSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Tile Isle
 */
class EnergyPickup extends DisplaySprite
{
	private var _shadow:MeatBagShadow;
	private var _item:EnergyPickupBody;
	private var _dying:Bool = false;
	private var _twnDeath:FlxTween;
	
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(16, 16, 0x0);
		_shadow = new MeatBagShadow(X, Y);
		_shadow.z = 0;
		add(_shadow);
		_item = new EnergyPickupBody(X, Y);
		_item.z = 10;
		add(_item);
	}
	
	override public function revive():Void 
	{
		_dying = false;
		alpha = 1;
		super.revive();
	}
	override public function update():Void 
	{
		_children.sort(sortZ);
		super.update();
		_shadow.relativeScaleX = .25 + (_item.relativeY / 10);
	}
	
	
	private function sortZ(O1:FlxNestedSprite, O2:FlxNestedSprite):Int
	{
		if (cast(O1,DisplaySprite).z > cast(O2,DisplaySprite).z)
			return 1;
		else if (cast(O1,DisplaySprite).z < cast(O2,DisplaySprite).z)
			return -1;
		else
			return 0;
	}
	
	public function startKilling():Void
	{
		if (!_dying)
		{
			_dying = true;
			_twnDeath = FlxTween.singleVar(this, "alpha", 0, .2, { type:FlxTween.ONESHOT, ease: FlxEase.quadOut, complete: doneFadeOut } );
		}

	}
	
	private function doneFadeOut(T:FlxTween):Void
	{
		T.destroy();
		T = null;
	}
	
	function get_dying():Bool 
	{
		return _dying;
	}
	
	public var dying(get_dying, null):Bool;
}