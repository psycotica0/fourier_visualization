color pink = color(255, 200, 200);
color cyan = color(0, 255, 255);
color yellow = color(255, 255, 0);
color magenta = color(255, 0, 255);

int origin_x;
int origin_y;

Signal signal;
Guy[] guys;

void setup() {
	// set the background color
	background(255);

	size(300, 300);

	origin_x = width/2;
	origin_y = height/2;

	guys = {
		new Guy(2, pink),
		new Guy(1.5, cyan),
		new Guy(1, yellow),
		new Guy(0.5, magenta),
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
	ellipse(origin_x, origin_y, 10, 10);
	popStyle();
}

class Guy {
	/* These the current state of the guy */
	int x;
	int y;
	float angle;

	/* This remembers the rate we want to spin at */
	float rate;

	/* Drawing Colours */
	color fillColor;

	/* These are just drawing parameters */
	final int radius = 10;
	final int facing_width = 4;
	final int facing_height = 15;

	Guy(float rotate_rate, color c) {
		this.x = origin_x;
		this.y = origin_y;
		this.rate = rotate_rate;
		this.angle = 0;
		this.fillColor = c;
	}

	void draw() {
		pushMatrix();

		translate(this.x, this.y);
		rotate(this.angle);

		pushStyle();
		fill(this.fillColor);
		ellipse(0, 0, this.radius * 2, this.radius * 2);
		popStyle();

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

	float step() {
		return this.rate * TWO_PI / frameRate;
	}

	void update() {
		this.angle += this.step();
	}

	float[] values(int n) {
		float[] ret = new float[n];
		float theta = this.angle;

		for (int i=0; i < n; i++) {
			ret[i] = sin(theta);
			theta += this.step();
		}

		return ret;
	}

	float value() {
		return this.values(1)[0];
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

	float values(int n) {
		float[] sums = new float[n];
		for (int i = 0; i < this.signals.length; i++) {
			float[] vs = this.signals[i].values(n);
			for (int j = 0; j < n; j++) {
				sums[j] = (sums[j] * i + vs[j]) / (i + 1);
			}
		}

		return sums;
	}
}
