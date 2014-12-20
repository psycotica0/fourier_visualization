float signal_rate = 2;

float signal_angle;

Guy one_guy;

void setup() {
	// set the background color
	background(255);

	size(300, 300);

	one_guy = new Guy(width/2, height/2, 2);
	signal_angle = 0;

	// smooth edges
	smooth();

	// limit the number of frames per second
	frameRate(30);
} 

void draw() {
	background(255);
	one_guy.update();

	/* Update Signal */
	signal_angle += signal_rate * TWO_PI / frameRate;
	signal = sin(signal_angle);

	one_guy.step(signal);

	one_guy.draw();

	pushStyle();
	noStroke();
	fill(color(0, 0, 255));
	ellipse(width / 2, height / 2, 10, 10);
	popStyle();
}

class Guy {
	/* These the current state of the guy */
	int x;
	int y;
	float angle;

	/* This remembers the rate we want to spin at */
	float rate;

	/* These are just drawing parameters */
	final int radius = 10;
	final int facing_width = 4;
	final int facing_height = 15;

	Guy(int xs, int ys, float rotate_rate) {
		this.x = xs;
		this.y = ys;
		this.rate = rotate_rate;
		this.angle = 0;
	}

	void draw() {
		pushMatrix();

		translate(this.x, this.y);
		rotate(this.angle);

		ellipse(0, 0, this.radius * 2, this.radius * 2);
		rect(-this.facing_width / 2, - this.facing_height, this.facing_width, this.facing_height);

		popMatrix();
	}

	void update() {
		angle += this.rate * TWO_PI / frameRate;
	}

	void step(float speed) {
		y += -speed * sin(this.angle);
		x += speed * cos(this.angle);
	}
}
