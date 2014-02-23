package ;

import flash.display.BitmapData;
import flash.geom.Point;
import flixel.addons.text.FlxBitmapFont;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.text.FlxText.FlxTextFormat;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author 
 */
class GameButton extends FlxUITypedButton<GameFont>
{

	public inline static var STYLE_SMALL:Int = 0;
	public inline static var STYLE_LARGE:Int = 1;
	
	public inline static var SIZE_LG_W:Int = 112;
	public inline static var SIZE_LG_H:Int = 28;
	
	public inline static var SIZE_SM_W:Int = 80;
	public inline static var SIZE_SM_H:Int = 20;
	
	private static var  _slices:Array<Array<Int>> = [[6, 6, 12, 12], [6, 6, 12, 12], [6, 6, 12, 12], [6, 6, 12, 12]];
	
	public function new(X:Float = 0, Y:Float = 0, Label:String, OnClick:Void -> Void, Style:Int = 0, Width:Int = 0, FitText:Bool = false) 
	{
		
		super(X, Y, Label, OnClick);
		
		switch(Style)
		{
			case STYLE_SMALL:
				var l:GameFont = new GameFont(Label, GameFont.STYLE_TINY_WHITE, FlxBitmapFont.ALIGN_CENTER, false);
				loadGraphicSlice9(["assets/images/button_thin.png"], Width == 0 ? (FitText ? Std.int(l.width + 16) : SIZE_SM_W) : Width, SIZE_SM_H, _slices , FlxUI9SliceSprite.TILE_NONE, -1, false, 18, 18);
				label = l;
			case STYLE_LARGE:
				var l:GameFont = new GameFont(Label, GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER, false);
				loadGraphicSlice9(["assets/images/button_thin.png"], Width == 0 ? (FitText ? Std.int(l.width + 24) : SIZE_LG_W) : Width, SIZE_LG_H, _slices , FlxUI9SliceSprite.TILE_NONE, -1, false, 18, 18);
				label = l;
		}
		
		up_toggle_color = over_toggle_color = over_color = down_color = down_toggle_color = up_color = 0xffffff;
		
		autoCenterLabel();
		broadcastToFlxUI = false;
		
	}
	
}