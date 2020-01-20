public class Point extends Forme {
	
	PVector pos;
	
	//Attention : pas de suivi de x et y dans ce cas
	public Point(float x, float y)
	{
		this(new PVector(x, y));
	}
	
	public Point(PVector pos)
	{
		this.pos = pos;
	}
	
	@Override
	public PVector getCenter() {
		return pos.copy();
	}

	@Override
	public PVector getNearest(float x, float y) {
		return getCenter();
	}

	@Override
	boolean collision(Rectangle r) {
		return r.collision(this);
	}

	@Override
	boolean collision(Cercle c) {
		return c.collision(c);
	}

	@Override
	boolean collision(Point p) {
		return pos.equals(p.pos);
	}

	@Override
	public Forme getTranslation(PVector dir) {
		return new Point(getCenter());
	}

}
