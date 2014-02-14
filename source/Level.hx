package ;

class Level
{

	public var number(default, null):Int;
	public var numberOfMBsPer(default, null):Int;
	public var cleared:Bool = false;
	public var available:Bool = false;
	
	public function new(Number:Int = 0, NumberOfMBsPer:Int = 0, Cleared:Bool = false, Available:Bool = false ) 
	{
		number = Number;
		numberOfMBsPer = NumberOfMBsPer;
		cleared = Cleared;
		available = Available;
	}
	
}