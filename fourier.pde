Signal signal;
Guy[] guys;

void setup() {
	// set the background color
	background(255);

	size(300, 300);

	guys = {
		new Guy(width/2, height/2, 2),
		new Guy(width/2, height/2, 1.5),
		new Guy(width/2, height/2, 1),
		new Guy(width/2, height/2, 0.5),
	};

	signal = new CompositeSignal({
		new Signal(2, 0),
		new Signal(1.5, 0.5 * PI)
	});

	// smooth edges
	smooth();

	// limit the number of frames per second
	frameRate(30);
} 

void draw() {
	background(255);
	signal.update();

	for (int i=0; i < guys.length; i++) {
		guys[i].update();
		guys[i].step(signal.value());
		guys[i].draw();
	}

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

class Signal {
	float rate;
	float angle;

	Signal(float freq, float phase) {
		this.rate = freq;
		this.angle = phase;
	}

	void update() {
		this.angle += this.rate * TWO_PI / frameRate;
	}

	float value() {
		return sin(this.angle);
	}
}

class CompositeSignal extends Signal {
	Signal[] signals;

	CompositeSignal(Signal[] inputs) {
		this.signals = inputs;
	}

	void update() {
		for (int i = 0; i < this.signals.length; i++) {
			this.signals[i].update();
		}
	}

	float value() {
		float sum = 0;
		for (int i = 0; i < this.signals.length; i++) {
			sum += this.signals[i].value();
		}

		return sum / this.signals.length;
	}
}
