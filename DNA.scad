width = 20;
height = 10;
extrusion = height / 2;
module drawPolygon(x, y, isRotated, vertices){
    if(isRotated){
        x = x * -1;
        y = y * -1;
    }
    translate([x + (isRotated ? width*2 : 0), y + (isRotated ? height : 0), 0]){
        rotate(isRotated ? 180 : 0){
            linear_extrude(height = 2) polygon(vertices);
            linear_extrude(height = 3) {
                difference() {
                    offset(0) polygon(vertices);
                    offset(-1) polygon(vertices);
                }
            }
        }
    }
}
module drawA(x, y, isRotated) {
    y = y * height;
    vertices = [[0, 0], [0, height], [width, height], [width + extrusion, height / 2], [width, 0]];
    drawPolygon(x, y, isRotated, vertices);
};
module drawT(x, y, isRotated) {
    y = y * height;
    vertices = [[0, 0], [0, height], [width, height], [width - extrusion, height / 2], [width, 0]];
    drawPolygon(x, y, isRotated, vertices);
};

module G(vertices) union(){
    translate([width, height / 2, 0]) circle(height / 2, $fn = 100);
    polygon(vertices);
}

module drawG(x, y, isRotated) {
    y = y * height;
    translate([x + (isRotated ? width*2 : 0), y + (isRotated ? height : 0), 0]){
        rotate(isRotated ? 180 : 0){
            vertices = [[0, 0], [0, height], [width, height], [width, 0]];
            linear_extrude(height = 2) G(vertices);
            linear_extrude(height = 3) {
                difference() {
                    offset(0) G(vertices);
                    offset(-1) G(vertices);
                }
            }
        }
    }
};

module C(vertices) difference(){
    polygon(vertices);
    translate([width, height / 2, 0]) circle(height / 2, $fn = 100);
}

module drawC(x, y, isRotated) {
    y = y * height;
    translate([x + (isRotated ? width*2 : 0), y + (isRotated ? height : 0), 0]){
        rotate(isRotated ? 180 : 0){
            vertices = [[0, 0], [0, height], [width, height], [width, 0]];
            linear_extrude(height = 2) C(vertices);
            linear_extrude(height = 3) {
                difference() {
                    offset(0) C(vertices);
                    offset(-1) C(vertices);
                }
            }
        }
    }
};
drawT(0, 0, false);
drawA(1, 0, true);
drawC(0, 1, false);
drawG(1, 1, true);