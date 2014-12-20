float rotate_rate = 2;
float signal_rate = 2;

int x;
int y;
float angle;

float signal_angle;

void setup() {
    
    // set the background color
    background(255);
    
    size(300, 300);

    x = width / 2;
    y = height / 2;
    angle = 0;

    signal_angle = 0;
      
    // smooth edges
    smooth();
    
    // limit the number of frames per second
    frameRate(30);
} 

void draw() {
		// Move my guy to his place
    translate(x, y);
		// Rotate him to face the right way
    rotate(angle);
		// Draw him
    guy();

		// Update his state
    angle += rotate_rate * TWO_PI / frameRate;
    signal_angle += signal_rate * TWO_PI / frameRate;
    signal = sin(signal_angle);
    y += -signal * sin(angle);
    x += signal * cos(angle);
}

void guy() {
    radius = 10;
    facing_width = 4;
    facing_height = 15;
    ellipse(0, 0, radius * 2, radius * 2);
    rect(-facing_width / 2, - facing_height, facing_width, facing_height);
}
