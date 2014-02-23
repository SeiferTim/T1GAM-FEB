package ;
import flixel.addons.text.FlxBitmapFont;

class GameFont extends FlxBitmapFont
{

	public static inline var STYLE_SM_WHITE:Int = 0 ;
	public static inline var STYLE_TINY_WHITE:Int = 2 ;
	public static inline var STYLE_LG_NUMBERS:Int = 1 ;
	
	public var style(default, null):Int = 0;
	
	
	public function new(Text:String = "", Style:Int = 0, Alignment:String = FlxBitmapFont.ALIGN_LEFT, AllowLower:Bool = true ) 
	{
		style = Style;
		
		
		switch(style)
		{
			case STYLE_TINY_WHITE:
				super("assets/images/tiny_white.png", 8, 8, FlxBitmapFont.TEXT_SET1, 95, 0, 0, 0, 0);
				setText(Text, true, 0, 4, align, AllowLower);
			case STYLE_SM_WHITE:
				super("assets/images/small_white_font.png", 16, 16, FlxBitmapFont.TEXT_SET1, 95, 0, 0, 0, 0);
				setText(Text, true, 0, 8, align, AllowLower);
			case STYLE_LG_NUMBERS:
				super("assets/images/huge_numbers.png", 32, 32, " .0123456789:", 13, 0, 0, 0, 0);
				setText(Text, true, 0, 0, align, AllowLower);
			default:
				
			
		}
		
		
	}

}