package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class PauseScreen extends FlxGroup
{
	private var _alpha:Float;
	
	private var _back:FlxSprite;
	private var _txtPause:FlxText;
	private var _btnResume:FlxButton;
	
	public var clickedResume:Bool = false;
	
	public function new() 
	{
		super(0);
	
		_back = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		_back.scrollFactor.x = _back.scrollFactor.y = 0;
		add(_back);
		
		_txtPause = new FlxText(0, 16, FlxG.width, "Paused", 8);
		_txtPause.alignment = "center";
		_txtPause.scrollFactor.x = _txtPause.scrollFactor.y = 0;
		add(_txtPause);
		
		_btnResume = new FlxButton(0, 0, "Resume", goResume);
		_btnResume.scrollFactor.x = _btnResume.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_btnResume);
		add(_btnResume);
		
		alpha = 0;
	}
	
	
	
	private function goResume():Void
	{
		if (_alpha >= 1)
			clickedResume = true;
	}
	
	function get_alpha():Float 
	{
		return _alpha;
	}
	
	function set_alpha(value:Float):Float 
	{
		_alpha = value;
		
		_btnResume.label.alpha = _txtPause.alpha = _btnResume.alpha =  _back.alpha = _alpha;
		
		return _alpha;
	}
	
	public var alpha(get_alpha, set_alpha):Float;
	
}