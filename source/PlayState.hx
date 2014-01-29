package;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.LogitechButtonID;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxCollision;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private static inline var SPEED:Int = 480;
	private static inline var FRICTION:Float = .8;
	
	private var _loading:Bool = true;
	
	private var _player:FlxSprite;
	private var _grpMeat:FlxGroup;
	private var _grpMap:FlxGroup;
	private var _grpHUD:FlxGroup;
	
	private var _grass:FlxSprite;
	private var _map:FlxOgmoLoader;
	private var _walls:FlxTilemap;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		
		_grpMap = new FlxGroup();
		_grpMeat = new FlxGroup();
		_player = new FlxSprite(0, 0).makeGraphic(32, 32, 0xff1F64B1);
		_grpHUD = new FlxGroup();
		
		_grass = FlxGridOverlay.create(64, 64, FlxG.width, FlxG.height,false, true, 0xff77C450, 0xff2A9D0C);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		_grpMap.add(_grass);
		
		_player.x = (FlxG.width - _player.width) / 2;
		_player.y = (FlxG.height - _player.height) / 2;
		_player.forceComplexRender = true;
		
		_map = new FlxOgmoLoader("assets/data/level-0001.oel");
		_walls = _map.loadTilemap("assets/images/walls.png", 16, 16, "walls");
		FlxSpriteUtil.screenCenter(_walls, true, true);
		
		_map.loadEntities(loadEntity, "meats");
		
		_grpMap.add(_walls);
		
		add(_grpMap);
		add(_grpMeat);
		add(_player);
		add(_grpHUD);
		
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, true, fadeInDone);
		
		super.create();
	}
	
	private function loadEntity(EType:String, EXml:Xml):Void
	{
		_grpMeat.add(new MeatBag(Std.parseFloat(EXml.get("x")), Std.parseFloat(EXml.get("y"))));
	}
	
	private function fadeInDone():Void
	{
		_loading = false;
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
		if (_loading)
		{
			super.update();
			return;
		}
		
		playerMovement();
		
		super.update();
		
		FlxG.collide(_player, _walls);
		FlxG.collide(_grpMeat, _grpMeat);
		FlxG.collide(_grpMeat, _walls);
		
		_grpMeat.sort();
		
	}	
	
	private function playerMovement():Void
	{
		var _pressingUp:Bool = false;
		var _pressingDown:Bool = false;
		var _pressingLeft:Bool = false;
		var _pressingRight:Bool = false;
		
		#if !FLX_NO_KEYBOARD
		_pressingUp = FlxG.keys.anyPressed(["W", "UP"]);
		_pressingDown = FlxG.keys.anyPressed(["S", "DOWN"]);
		_pressingLeft = FlxG.keys.anyPressed(["A", "LEFT"]);
		_pressingRight = FlxG.keys.anyPressed(["D", "RIGHT"]);
		#end
		#if !FLX_NO_GAMEPAD
		// do some gamepad stuffs?
		#end
		
		if (_pressingDown && _pressingUp)
			_pressingDown = _pressingUp = false;
		if (_pressingLeft && _pressingRight)
			_pressingLeft = _pressingRight = false;
			
		var mA:Float = -400;
		if (_pressingUp)
		{
			if (_pressingLeft)
				mA = -135;
			else if (_pressingRight)
				mA = -45;
			else 
				mA = -90;
		}
		else if (_pressingDown)
		{
			if (_pressingLeft)
				mA = 135;
			else if (_pressingRight)
				mA = 45;
			else
				mA = 90;
		}
		else if (_pressingLeft)
			mA = -180;
		else if (_pressingRight)
			mA = 0;
		
		if (mA != -400)
		{
			var v:FlxPoint = FlxAngle.rotatePoint(SPEED, 0, 0, 0, mA);
			_player.velocity.x = v.x;
			_player.velocity.y = v.y;
			
			if (_player.velocity.x > 0 && Math.abs(_player.velocity.x) > Math.abs(_player.velocity.y))
				_player.facing = FlxObject.RIGHT;
			else if (_player.velocity.x < 0 && Math.abs(_player.velocity.x) > Math.abs(_player.velocity.y))
				_player.facing = FlxObject.LEFT;
			else if (_player.velocity.y > 0)
				_player.facing = FlxObject.DOWN;
			else if (_player.velocity.y < 0)
				_player.facing = FlxObject.UP;
		}
		
		if (!_pressingDown && !_pressingUp)
			if (Math.abs(_player.velocity.y) > 1)
				_player.velocity.y *= FRICTION;
		if (!_pressingLeft && !_pressingRight)
			if (Math.abs(_player.velocity.x) > 1)
				_player.velocity.x *= FRICTION;
			
		
		
	}
}