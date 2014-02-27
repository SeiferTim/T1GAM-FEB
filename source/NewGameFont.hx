package ;

import flash.display.BitmapData;
import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.Font;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flixel.addons.plugin.effects.FlxSpecialFX;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxBitmapUtil;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;



class NewGameFont extends FlxSprite
{
	public static inline var STYLE_SMALL:Int = 0;
	public static inline var STYLE_MED:Int = 1;
	public static inline var STYLE_TINY:Int = 2;
	public static inline var STYLE_LARGE:Int = 3;
	
	public static inline var COLOR_YELLOW:Int = 0;
	public static inline var COLOR_RED:Int = 1;
	public static inline var COLOR_BLUE:Int = 2;
	public static inline var COLOR_GREEN:Int = 3;
	public static inline var COLOR_WHITE:Int = 4;
	
	private static var COLORS_YELLOW:Array<Int> = [0xffffd948, 0xffffd638, 0xffffcc00, 0xffa88600];
	private static var COLORS_RED:Array<Int> = [0xfffa8132, 0xfff17524, 0xffe86a17, 0xffaa4e11];
	private static var COLORS_BLUE:Array<Int> = [0xff35baf3, 0xff29b0ea, 0xff1ea7e1, 0xff166e93];
	private static var COLORS_GREEN:Array<Int> = [0xff88e060, 0xff7dd655, 0xff73cd4b, 0xff47832c];
	private static var COLORS_WHITE:Array<Int> = [0xffffffff, 0xfff6f6f6, 0xffeeeeee, 0xffaaaaaa];
	
	private var _color:Int = 0;
	private var _style:Int = 0;
	private var _text:String = "";
	
	public function new(X:Float, Y:Float, Text:String = "", Style:Int = 0, Color:Int = 0) 
	{
		
		super(X, Y);
		_style = Style;
		_color = Color;
		_text = Text;
		drawText();
		
	}
	
	private function drawText():Void
	{
		var size:Int = 8;
		var colors:Array<Int> = COLORS_YELLOW;

		switch (_style)
		{
			case STYLE_SMALL:
				size = 16;
			case STYLE_MED:
				size = 20;
			case STYLE_TINY:
				size = 14;
			case STYLE_LARGE:
				size = 28;
		}
		
		switch (_color)
		{
			case COLOR_YELLOW:
				colors = COLORS_YELLOW;
			case COLOR_BLUE:
				colors = COLORS_BLUE;
			case COLOR_RED:
				colors = COLORS_RED;
			case COLOR_GREEN:
				colors = COLORS_GREEN;
			case COLOR_WHITE:
				colors = COLORS_WHITE;
			
		}
		
		var tmpText:FlxText = new FlxText(0,0,FlxG.width,_text);

		tmpText.setFormat(Reg.FONT_DEFAULT, size, 0x000000, "left");
		
		tmpText.update();
		tmpText.draw();
		
		var r:Rectangle = tmpText.pixels.getColorBoundsRect(0xFF000000, 0x00000000,false);
		var b1:BitmapData = new BitmapData(Std.int(r.width), Std.int(r.height), true, 0x0);
		b1.copyPixels(tmpText.pixels, r, new Point());
		
		var b2:BitmapData = new BitmapData(b1.width, b1.height, true, 0xffffffff);
		b2.fillRect(new Rectangle(0, 0, b1.width, (b1.height / 2) ), colors[0]);
		b2.fillRect(new Rectangle(0, (b1.height / 2), b1.width, 1), colors[1]);
		b2.fillRect(new Rectangle(0, (b1.height / 2) + 1, b1.width, (b1.height / 2) - 1), colors[2]);
		
		var spr:FlxSprite = new FlxSprite();
		
		FlxSpriteUtil.alphaMask(spr, b2, b1);
		makeGraphic(Std.int(spr.width+4), Std.int(spr.height + 4), 0x0,true);
		pixels.copyPixels(spr.pixels, spr.pixels.rect, new Point(2, 2));
		
		var inglow:GlowFilter = new GlowFilter(colors[0], 1, 2, 2, 4, 1, true);
		pixels.applyFilter(pixels, pixels.rect, new Point(), inglow);
		
		var outline:DropShadowFilter = new DropShadowFilter(0, 90, colors[3], 1, 2, 2, 20);
		pixels.applyFilter(pixels, pixels.rect, new Point(), outline);
		
		dirty = true;
		updateFrameData();
		
	}
	
	function get_text():String 
	{
		return _text;
	}
	
	function set_text(value:String):String 
	{
		_text = value;
		drawText();
		return _text;
	}
	
	public var text(get_text, set_text):String;
	
}