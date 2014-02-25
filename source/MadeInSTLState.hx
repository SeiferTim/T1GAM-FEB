package ;

import flixel.addons.display.FlxGridOverlay;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTileblock;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class MadeInSTLState extends FlxState
{

	private var _grpStampede:FlxGroup;
	private var _sprSTL:FlxSprite;
	private var _twn:FlxTween;
	private var _doneL:Bool = false;
	private var _doneM:Bool = false;
	private var _doneF:Bool = false;
	private var m:MeatBag;
	private var _leaving:Bool = false;
	
	override public function create():Void 
	{
		
		FlxG.autoPause = false;
		FlxG.cameras.bgColor = 0xff131c1b;
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		var _grass:FlxSprite = FlxGridOverlay.create(64, 64, FlxG.width + 64, FlxG.height+64, false, true, 0xff77C450, 0xff67b440);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_grass);
		add(_grass);
		
		var _random:FlxTileblock = new FlxTileblock(0, 0, FlxG.width+64, FlxG.height+64);
		_random.loadTiles("assets/images/random_junk.png", 32, 32, 64);
		_random.scrollFactor.x = _random.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_random);
		add(_random);
		
		
		_grpStampede = new FlxGroup(1);
		add(_grpStampede);
		
		
		_sprSTL = new FlxSprite(0, 0, "assets/images/Made-in-STL-art.png");
		FlxSpriteUtil.screenCenter(_sprSTL);
		_sprSTL.alpha = 0;
		add(_sprSTL);
		
		m = new MeatBag(FlxG.width, (FlxG.height/2)-8);
		m.facing = FlxObject.LEFT;
		m.velocity.x = -400;
		m.velocity.y = 0;
		m.isReal = false;
		_grpStampede.add(m);
		
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, true, doneFadeIn);
		
		super.create();
	}
	
	private function doneFadeIn():Void
	{
		FlxG.sound.play("madeinstl", .6, false, true, doneMusic);
		_twn = FlxTween.singleVar(_sprSTL, "alpha", 1, Reg.FADE_DUR*4, { type:FlxTween.ONESHOT, ease:FlxEase.quintInOut, complete:doneSprFadeIn } );
	}
	
	private function doneMusic():Void
	{
		_doneM = true;
	}
	
	private function doneSprFadeIn(T:FlxTween):Void
	{
		_doneF = true;
	}
	
	override public function update():Void 
	{
		if (m.x < -16)
		{
			_doneL = true;
		}
		
		if (_doneM && _doneL && _doneF && !_leaving)
		{
			_leaving = true;
			FlxG.sound.playMusic("title");
			FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, doneFadeOut);
		}
		
		super.update();
	}
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new MenuState());
	}
	
}