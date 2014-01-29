package ;

/**
 * ...
 * @author Tile Isle
 */
class FSM
{
	private var _activeState:Void->Void;
	
	public function new() 
	{
		
	}
	
	public function setState(State:Void->Void):Void
	{
		_activeState = State;
	}
	
	public function update():Void
	{
		if (_activeState != null)
			_activeState();
	}
	
}