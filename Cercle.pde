
public class Cercle extends Forme {
	
	PVector pos;
	float r;
	
	public Cercle(PVector p, float rayon)
	{
		pos = p;
		r = rayon;
	}

	@Override
	boolean collision(Rectangle rect) {
		PVector coords = null;
		//On check si on est dans un des angles
		if (pos.x < rect.pos.x && pos.y < rect.pos.y) //Angle superieur gauche
			coords = rect.pos; //Point superieur gauche
		else if (pos.x < rect.pos.x && pos.y > rect.pos.y + rect.h)
			coords = PVector.add(rect.pos, new PVector(0, rect.h)); // Point inferieur gauche
		else if (pos.x > rect.pos.x + rect.w && pos.y < rect.pos.y)
			coords = PVector.add(rect.pos, new PVector(rect.w, 0)); //Point superieur droit
		else if (pos.x > rect.pos.x + rect.w && pos.y > rect.pos.y + rect.h)
			coords = PVector.add(rect.pos, new PVector(rect.w, rect.h)); //Point inferieur droit
		
		//Si on est dans un des 4 angles
		if (coords != null)
		{
			//On cree un cercle representant le point
			Cercle c = new Cercle(coords, 0);
			return collision(c);
		}
		else //Collision de rectangles
		{
			Rectangle moi = new Rectangle(PVector.sub(pos, new PVector(r, r)), r * 2, r * 2);
			return moi.collision(rect);
		}
	}

	@Override
	boolean collision(Cercle c) {
		float distSq = PVector.sub(pos, c.pos).magSq();
		float rayons = c.r + r;
		return distSq <= rayons * rayons;
	}

	@Override
	boolean collision(Point p) {
		PVector dist = p.getCenter();
		return dist.sub(pos).magSq() <= r * r;
	}

	@Override
	public PVector getCenter() {
		return pos.copy();
	}
	
	@Override
	public PVector getNearest(float x, float y)
	{
		PVector vec = new PVector(x, y);
		vec.sub(pos);
		vec.setMag(r);
		
		return PVector.add(pos,  vec);
	}

	@Override
	public Forme getTranslation(PVector dir) {
		return new Cercle(PVector.add(pos, dir), r);
	}


}
