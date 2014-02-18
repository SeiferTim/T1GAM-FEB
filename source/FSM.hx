package ;

/**
 * ...
 * @author Tile Isle
 */
class FSM
{
	public var activeState(default, null):Void->Void;
	
	public function new() 
	{
		
	}
	
	public function setState(State:Void->Void):Void
	{
		activeState = State;
	}
	
	public function update():Void
	{
		if (activeState != null)
			activeState();
	}
	
}