package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxGradient;

class TitleBackBar extends FlxNestedSprite
{

	private var _main:FlxNestedSprite;
	private var _top:FlxNestedSprite;
	private var _bottom:FlxNestedSprite;
	private var _started:Bool = false;
	private var _twn:FlxTween;
	private var _twnAlpha:FlxTween;
	
	public function new() 
	{
		super(0, 0);
		makeGraphic(FlxG.width, FlxG.height, 0x0);
		alpha = 0;
		_main = new FlxNestedSprite();
		_main.relativeX = 0;
		_main.relativeY = (FlxG.height / 2) - 35;
		_main.makeGraphic(FlxG.width, 1, 0x00000000);
		_main.pixels = FlxGradient.createGradientBitmapData(FlxG.width, 1, [0x11000000, 0x66000000, 0x66000000, 0x66000000, 0x11000000],1,0);
		_main.dirty = true;
		add(_main);
		_top = new FlxNestedSprite();
		_top.makeGraphic(FlxG.width, 2, 0x00000000);
		_top.pixels = FlxGradient.createGradientBitmapData(FlxG.width, 2, [0x99000000, 0xcc999999, 0xcc000000, 0xcc000000, 0x99000000], 1, 0);
		_top.dirty = true;
		_top.relativeX = 0;
		_top.relativeY = _main.relativeY - (_main.relativeScaleY / 2);
		add(_top);
		_bottom = new FlxNestedSprite();
		_bottom.makeGraphic(FlxG.width, 2, 0x00000000);
		_bottom.pixels = FlxGradient.createGradientBitmapData(FlxG.width, 2, [0x99000000, 0xcc000000, 0xcc000000,0xcc999999, 0x99000000], 1, 0);
		_bottom.dirty = true;
		_bottom.relativeX = 0;
		_bottom.relativeY = _main.relativeY + (_main.relativeScaleY / 2);
		add(_bottom);
	}
	
	public function start():Void
	{
		_started = true;
		
		_twnAlpha = FlxTween.singleVar(this, "alpha", 1, Reg.FADE_DUR*2, { type:FlxTween.ONESHOT, ease:FlxEase.sineIn } );
		_twn = FlxTween.singleVar(_main, "relativeScaleY", FlxG.height/2, 1, { type:FlxTween.ONESHOT, ease:FlxEase.circOut } );
	}
	
	override public function update():Void 
	{
		if (_started)
		{
			_top.relativeY = _main.relativeY - (_main.relativeScaleY / 2);
			_bottom.relativeY = _main.relativeY + (_main.relativeScaleY / 2);
			
		}
		
		super.update();
	}
	
}