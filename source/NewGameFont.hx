package ;

import flash.display.BitmapData;
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
	
	
	public static inline var STYLE_SMALL_WHITE:Int = 0;
	public static inline var STYLE_MED_WHITE:Int = 1;
	
	private var _style:Int = 0;
	
	public function new(X:Float, Y:Float, Text:String = "", Style:Int = 0) 
	{
		
		super(X, Y);
		_style = Style;
		drawText(Text);
		
	}
	
	private function drawText(Text:String = ""):Void
	{
		var size:Int = 8;
		var color:Int = 0xffffffff;
		
		switch (_style)
		{
			case STYLE_SMALL_WHITE:
				size = 18;
			case STYLE_MED_WHITE:
				size = 14;
		}
		
		var tmpText:FlxText = new FlxText(0,0,FlxG.width,Text);// 0, 0, FlxG.width, Text, size, true);
		
		/*var format:FlxTextFormat = new FlxTextFormat(0x000000);
		format.format.size = size;
		format.format.font = "assets/fonts/8bitoperator.ttf";
		tmpText.addFormat(format);*/
		
		tmpText.setFormat(Reg.FONT_DEFAULT, size, 0x000000, "left");
		
		
		//tmpText.text = Text;
		//tmpText.textField.setTextFormat(new TextFormat("assets/fonts/8bitoperator.ttf", size, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0));
		tmpText.update();
		tmpText.draw();
		
		var r:Rectangle = tmpText.pixels.getColorBoundsRect(0xFF000000, 0x00000000,false);
		var b1:BitmapData = new BitmapData(Std.int(r.width), Std.int(r.height), true, 0x0);
		b1.copyPixels(tmpText.pixels, r, new Point());
		
		var b2:BitmapData = new BitmapData(b1.width, b1.height, true, color);
		//FlxGradient.overlayGradientOnBitmapData(b2, b1.width, b1.height, [0xffffd948,0xffffd948]);//[0xffffffff,0xffffffff,0xfffffff6, 0xfffffcab, 0xfffff95f, 0xfffff714, 0xffc8c301]);
		b2.fillRect(new Rectangle(0, 0, b1.width, (b1.height / 2) ), 0xffffd948);
		b2.fillRect(new Rectangle(0, (b1.height / 2), b1.width, 1), 0xffffd638);
		b2.fillRect(new Rectangle(0, (b1.height / 2) + 1, b1.width, (b1.height / 2) - 1), 0xffffcc00);
		
		
		var spr:FlxSprite = new FlxSprite();
		
		FlxSpriteUtil.alphaMask(spr, b2, b1);
		
		var b3:BitmapData = new BitmapData(Std.int(r.width), Std.int(r.height), true, 0xff333333);
		
		var spr2:FlxSprite = new FlxSprite();
		FlxSpriteUtil.alphaMask(spr2, b3, b1);
		
		
		//
		//pixels.copyPixels(spr2.pixels, spr2.pixels.rect, new Point(1, 1));
		
		
		//FlxBitmapUtil.merge(spr.pixels, spr.pixels.rect, pixels, new Point(),1,1,1,);
		
		//pixels = spr.pixels;
		

		makeGraphic(Std.int(spr2.width), Std.int(spr2.height + 1), 0x0,true, "txt-"+Text);
		pixels.copyPixels(spr2.pixels, spr2.pixels.rect, new Point(0, 1));
		
		//pixels.merge(spr.pixels, spr.pixels.rect, new Point(), 1, 1, 1, 1);
		
		stamp(spr);
		
		dirty = true;
		
		
	}
	
}