package ;

import flash.display.BitmapData;
import flash.geom.Point;
import flixel.addons.ui.FlxUIButton;

class LinkText extends FlxUIButton
{

	public function new(X:Float=0, Y:Float=0, ?Label:String, ?OnClick:Void -> Void) 
	{
		super(X, Y, "", OnClick);
		
		var _t6:NewGameFont = new NewGameFont(0,0, Label,NewGameFont.STYLE_SMALL,NewGameFont.COLOR_BLUE);

		var _t6b2:NewGameFont = new NewGameFont(0,0, Label,NewGameFont.STYLE_SMALL,NewGameFont.COLOR_WHITE);

		var bd1:BitmapData = new BitmapData(Std.int(_t6.width), Std.int(_t6.height * 3), true, 0x0);
		bd1.copyPixels(_t6.pixels, _t6.pixels.rect, new Point());
		bd1.copyPixels(_t6b2.pixels, _t6b2.pixels.rect, new Point(0, _t6b2.height));
		bd1.copyPixels(_t6b2.pixels, _t6b2.pixels.rect, new Point(0, _t6b2.height*2));
		
		loadGraphicsUpOverDown(bd1);
		
	}
	
}