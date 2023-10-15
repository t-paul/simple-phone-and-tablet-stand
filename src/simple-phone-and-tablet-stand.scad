// Simple Phone and Tablet Stand
//
// Torsten Paul <Torsten.Paul@gmx.de>, October 2015
// CC BY-SA 4.0
// https://creativecommons.org/licenses/by-sa/4.0/

$fa = 2;
$fs = .5;

model = 4;
models = [
	[ "iPhone5", 3, 12, 92, 30, 50 ],
	[ "iPhone6", 4, 14, 100, 45, 50 ],
	[ "iPhone6-with-case", 4, 16, 100, 45, 50 ],
	[ "iPhone6-with-case-portrait", 4, 16, 30, 70, 60 ],
	[ "iPadAir", 4, 20, 100, 60, 70 ],
	[ "iPadAir-with-case", 4, 24, 95, 70, 70 ],
	[ "iPhoneSE-with-case", 4, 18, 95, 45, 50 ],
	[ "iPhoneSE-with-case-portrait", 4, 18, 30, 70, 60 ],
];

function model() = models[model][0];
function model_n() = models[model][0];
function model_h() = models[model][1];
function model_r() = models[model][2];
function model_w() = models[model][3];
function model_o() = models[model][4];
function model_angle() = models[model][5];

module iPhone5() {
	r = 10;
	l = 124 - 2 * r;
	w = 60 - 2 * r;

	linear_extrude(height = 8) {
		hull() {
			for (x = [-1, 1], y = [0, 1]) {
				translate([x * l/2, y * w + r]) circle(r);
			}
		}
	}
}

module iPhone6() {
	r = 6;
	l = 138.14 + 0.8 - 2 * r;
	w = 66.97;
	w2 = w + 0.3 - 2 * r;
	x = 0.6;
	h = 6.85 - x;

	cx = 13.31;
	cy = 6.88;
	cd = 7.2;
	ch = 1.5;

	translate([l / 2 + r - cy, cx, -h / 2 - ch]) {
		cylinder(d1 = cd + 0.8, d2 = cd + 0.8 + 5, h = h / 2 + ch);
	}

	translate([0, w / 2, 0]) minkowski() {
		linear_extrude(0.5 + x, center = true) offset(r) square([l - h, w2 - h], center = true);
		sphere(h / 2);
	}
}

module iPhone6WithCase(portrait = false) {
	width = 71;
	length = 141;
	
	r = 8;
	l = (portrait ? width : length) + 0.8 - 2 * r;
	w = (portrait ? length : width);
	
	w2 = w + 0.3 - 2 * r;
	x = 0.6;
	h = 9 - x;

	translate([0, w / 2, 0]) minkowski() {
		linear_extrude(0.5 + x, center = true) offset(r) square([l - h, w2 - h], center = true);
		sphere(h / 2);
	}
}

module iPhoneSEWithCase(portrait = false) {
	width = 73;
	length = 143;
	
	r = 8;
	l = (portrait ? width : length) + 0.8 - 2 * r;
	w = (portrait ? length : width);
	
	w2 = w + 0.3 - 2 * r;
	x = 0.6;
	h = 11.6 - x;

	translate([0, w / 2, 0]) minkowski() {
		linear_extrude(0.5 + x, center = true) offset(r) square([l - h, w2 - h], center = true);
		sphere(h / 2);
	}
}

module iPadAir() {
	r = 10;
	l = 240 - 2 * r;
	w = 170 - 2 * r;
	h = 7.5 + 0.4;
	o = 1.5;

	hull() {
		for (x = [-1, 1], y = [0, 1]) {
			translate([x * l/2, y * w + r, h]) {
				difference() {
					union() {
						translate([0, 0, -o])
							resize([2 * r, 2 * r, 2 * h - o])
								sphere(r);
						cylinder(r = r, h = 2 * o, center = true);
					}
					translate([-2 * r, -2 * r, 0]) cube(4 * r);
				}
			}
		}
	}
}

module iPadAirWithCase(case_thickness = 1.8) {
    minkowski() {
        iPadAir();
        sphere(case_thickness);
    }
}

module phone() {
	if (model() == "iPhone5") {
		iPhone5();
	} else if (model() == "iPhone6") {
		iPhone6();
	} else if (model() == "iPhone6-with-case") {
		iPhone6WithCase();
	} else if (model() == "iPhone6-with-case-portrait") {
		iPhone6WithCase(true);
	} else if (model() == "iPadAir") {
		iPadAir();
	} else if (model() == "iPadAir-with-case") {
		iPadAirWithCase();
	} else if (model() == "iPhoneSE-with-case") {
        iPhoneSEWithCase();
    } else if (model() == "iPhoneSE-with-case-portrait") {
        iPhoneSEWithCase(true);
    }
}

module o(s) {
	translate([s * (model_w()/2 + model_r()), model_o()])
		children();
}

module half_sphere(r) {
	difference() {
		sphere(r);
		translate([-r, -r, -r - model_h() / 2]) cube([2 * r, 2 * r, r]);
	}
}

module phone_stand() {
	difference() {
		r = model_r();
		h = model_h();
		union() {
			r2 = 2 * r / 3;
			linear_extrude(height = h, convexity = 3) {
				offset(-r/2) offset(r/2) {
					circle(r2);
					hull() {
						circle(2);
						o(-1) circle(r);
					}
					hull() {
						circle(2);
						o(1) circle(r);
					}
				}
			}
			translate([0, 0, h]) {
				half_sphere(r2);
				o(-1) half_sphere(r);
				o(1) half_sphere(r);
			}
		}
		#translate([0, model_o()+2, h+2])
            rotate([model_angle(), 0, 180])
                phone();
	}
}

echo(str("Selected model: ", model_n()));
phone_stand();
