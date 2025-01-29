shader_type canvas_item;

uniform float red: hint_range(-1.0, 1.0)  = 0.0;
uniform float green: hint_range(-1.0, 1.0) = 0.0;
uniform float blue: hint_range(-1.0, 1.0) = 0.0; 


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
  vec4 input_color = texture(TEXTURE, UV); // Read from texture again.
  vec4 output_color = vec4(input_color.r + red, input_color.g + green, input_color.b + blue, input_color.a);
  COLOR = output_color;
//  COLOR = vec4(abs(sin(TIME)),0.0,0.0,1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
