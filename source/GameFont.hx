package ;
import flixel.addons.text.FlxBitmapFont;

class GameFont extends FlxBitmapFont
{

	public static inline var STYLE_SM_WHITE:Int = 0 ;
	public static inline var STYLE_LG_NUMBERS:Int = 1 ;
	
	public var style(default, null):Int = 0;
	
	
	public function new(Text:String = "", Style:Int = 0, Alignment:String = FlxBitmapFont.ALIGN_LEFT ) 
	{
		style = Style;
		
		
		switch(style)
		{
			case STYLE_SM_WHITE:
				super("assets/images/small_white_font.png", 16, 16, FlxBitmapFont.TEXT_SET1, 16, 0, 0, 0, 0);
			case STYLE_LG_NUMBERS:
				super("assets/images/huge_numbers.png", 32, 32, " .0123456789:", 13, 0, 0, 0, 0);
			default:
				
			
		}
		setText(Text, false, 0, 0, align, true);
		
	}

}