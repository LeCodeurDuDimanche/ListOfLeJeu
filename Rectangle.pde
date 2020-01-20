import processing.core.PVector;

public class Rectangle extends Forme {
	
	 PVector pos;
	 float w, h;
	
	public Rectangle(PVector p, float w, float h)
	{
		pos = p;
		this.w = w;
		this.h= h;
	}

	@Override
	boolean collision(Rectangle r) {
		return (pos.x + w >= r.pos.x &&
				pos.x <= r.pos.x + r.w &&
				pos.y + h >= r.pos.y &&
				pos.y <= r.pos.y + r.h);
	}

	@Override
	boolean collision(Cercle c) {
		return c.collision(this);
	}

	@Override
	boolean collision(Point p) {
		return 	p.pos.x >= pos.x &&
				p.pos.x <= pos.x + w &&
				p.pos.y >= pos.y &&
				p.pos.y <= pos.y + h;
	}
	
	public String toString()
	{
		return pos.x+";"+pos.y+" "+w+";"+h;
	}

	@Override
	public PVector getCenter() {
		return PVector.add(pos, new PVector(w/2, h/2));
	}
	
	@Override
	public PVector getNearest(float x, float y) {
		PVector vec = new PVector();
		if (x >= pos.x + w)
		{
			vec.x = pos.x + w;
			vec.y = constrain(y, pos.y, pos.y + h);
		}
		else if (x <= pos.x)
		{
			vec.x = pos.x;
			vec.y = constrain(y, pos.y, pos.y + h);
		}
		else if (y <= pos.y)
		{
			vec.x = constrain(x, pos.x, pos.x + w);
			vec.y = pos.y;
		}
		else if (y >= pos.y + h)
		{
			vec.x = constrain(x, pos.x, pos.x + w);
			vec.y = pos.y + h;
		}
		else
			vec = PVector.add(pos, new PVector(w / 2, h / 2));
		
		return vec;
	}

	@Override
	public Forme getTranslation(PVector dir) {
		return new Rectangle(PVector.add(dir, pos), w, h);
	}
	
	

}
