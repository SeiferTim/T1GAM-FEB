package ;

class Level
{

	public var number(default, null):Int;
	public var numberOfMBsPer(default, null):Int;
	public var bestScores:Array<Int>;
	
	public function new(Number:Int = 0, NumberOfMBsPer:Int = 0) 
	{
		bestScores  = [0, 0];
		number = Number;
		numberOfMBsPer = NumberOfMBsPer;
	}
	
}