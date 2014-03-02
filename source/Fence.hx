package ;

/**
 * ...
 * @author ...
 */
class Fence extends DisplaySprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/fence.png", false, false, 8, 16);
		moves = false;
		immovable = true;
		width = 6;
		height = 8;
		offset.x = 1;
		offset.y = 8;
	}
	
}