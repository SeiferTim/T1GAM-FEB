package ;

import flixel.addons.text.FlxBitmapFont;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;
import flixel.ui.FlxButton;

class GameButton extends FlxUITypedButton<GameFont>
{

	public inline static var STYLE_SMALL:Int = 0;
	public inline static var STYLE_LARGE:Int = 1;
	
	public inline static var STYLE_SMALL_GREEN:Int = 2;
	public inline static var STYLE_LARGE_GREEN:Int = 3;

	public inline static var STYLE_SMALL_YELLOW:Int = 4;
	public inline static var STYLE_LARGE_YELLOW:Int = 5;
	
	public inline static var STYLE_SMALL_RED:Int = 6;
	public inline static var STYLE_LARGE_RED:Int = 7;
	
	public inline static var SIZE_LG_W:Int = 112;
	public inline static var SIZE_LG_H:Int = 28;
	
	public inline static var SIZE_SM_W:Int = 80;
	public inline static var SIZE_SM_H:Int = 20;
	
	private static var  _slices:Array<Array<Int>> = [[7, 7, 41, 38], [7, 7, 41, 38], [7, 7, 41, 38]];
	
	public function new(X:Float = 0, Y:Float = 0, Label:String, OnClick:Void -> Void, Style:Int = 0, Width:Int = 0, FitText:Bool = false) 
	{
		
		super(X, Y, Label, OnClick);
		
		switch(Style)
		{
			case STYLE_SMALL:
				var l:GameFont = new GameFont(Label, GameFont.STYLE_TINY_WHITE, FlxBitmapFont.ALIGN_CENTER, false);
				loadGraphicSlice9(["assets/images/blue_button.png"], Width == 0 ? (FitText ? Std.int(l.width + 16) : SIZE_SM_W) : Width, SIZE_SM_H, _slices , FlxUI9SliceSprite.TILE_NONE, -1, false, 49, 49);
				label = l;
			case STYLE_LARGE:
				var l:GameFont = new GameFont(Label, GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER, false);
				loadGraphicSlice9(["assets/images/blue_button.png"], Width == 0 ? (FitText ? Std.int(l.width + 24) : SIZE_LG_W) : Width, SIZE_LG_H, _slices , FlxUI9SliceSprite.TILE_NONE, -1, false, 49, 49);
				label = l;
			case STYLE_SMALL_GREEN:
				var l:GameFont = new GameFont(Label, GameFont.STYLE_TINY_WHITE, FlxBitmapFont.ALIGN_CENTER, false);
				loadGraphicSlice9(["assets/images/green_button.png"], Width == 0 ? (FitText ? Std.int(l.width + 16) : SIZE_SM_W) : Width, SIZE_SM_H, _slices , FlxUI9SliceSprite.TILE_NONE, -1, false, 49, 49);
				label = l;
			case STYLE_LARGE_GREEN:
				var l:GameFont = new GameFont(Label, GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER, false);
				loadGraphicSlice9(["assets/images/green_button.png"], Width == 0 ? (FitText ? Std.int(l.width + 24) : SIZE_LG_W) : Width, SIZE_LG_H, _slices , FlxUI9SliceSprite.TILE_NONE, -1, false, 49, 49);
				label = l;
			case STYLE_SMALL_YELLOW:
				var l:GameFont = new GameFont(Label, GameFont.STYLE_TINY_WHITE, FlxBitmapFont.ALIGN_CENTER, false);
				loadGraphicSlice9(["assets/images/yellow_button.png"], Width == 0 ? (FitText ? Std.int(l.width + 16) : SIZE_SM_W) : Width, SIZE_SM_H, _slices , FlxUI9SliceSprite.TILE_NONE, -1, false, 49, 49);
				label = l;
			case STYLE_LARGE_YELLOW:
				var l:GameFont = new GameFont(Label, GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER, false);
				loadGraphicSlice9(["assets/images/yellow_button.png"], Width == 0 ? (FitText ? Std.int(l.width + 24) : SIZE_LG_W) : Width, SIZE_LG_H, _slices , FlxUI9SliceSprite.TILE_NONE, -1, false, 49, 49);
				label = l;
			case STYLE_SMALL_RED:
				var l:GameFont = new GameFont(Label, GameFont.STYLE_TINY_WHITE, FlxBitmapFont.ALIGN_CENTER, false);
				loadGraphicSlice9(["assets/images/red_button.png"], Width == 0 ? (FitText ? Std.int(l.width + 16) : SIZE_SM_W) : Width, SIZE_SM_H, _slices , FlxUI9SliceSprite.TILE_NONE, -1, false, 49, 49);
				label = l;
			case STYLE_LARGE_RED:
				var l:GameFont = new GameFont(Label, GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER, false);
				loadGraphicSlice9(["assets/images/red_button.png"], Width == 0 ? (FitText ? Std.int(l.width + 24) : SIZE_LG_W) : Width, SIZE_LG_H, _slices , FlxUI9SliceSprite.TILE_NONE, -1, false, 49, 49);
				label = l;
		}
		
		up_toggle_color = over_toggle_color = over_color = down_color = down_toggle_color = up_color = 0xffffff;
		
		labelOffsets[FlxButton.HIGHLIGHT].y = -2;
		labelOffsets[FlxButton.NORMAL].y = -2;
		
		autoCenterLabel();
		onUp.sound = FlxG.sound.load("mouse-up");
		onDown.sound = FlxG.sound.load("mouse-down");
		//onOver.sound = FlxG.sound.load("mouse-over");
		
		broadcastToFlxUI = false;
		
	}
	
}