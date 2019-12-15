width = 20;
height = 10;
extrusion = height / 2;
separation = 5;
textHeightCoeff = .4;
textXoffset = (width - extrusion) / 2;

module drawLabel(x, y, isRotated, string){
    offsetY = (height * (1 - textHeightCoeff) / 2);
    translate([x + (isRotated ? (width*2) - textXoffset : textXoffset), y + offsetY, 2.5]){
        text(string, height * textHeightCoeff, "Muli:style=Bold");
    }
}
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
    drawLabel(x, y, isRotated, "A");
    vertices = [[0, 0], [0, height], [width, height], [width + extrusion, height / 2], [width, 0]];
    drawPolygon(x, y, isRotated, vertices);
};
module drawT(x, y, isRotated) {
    y = y * height;
    drawLabel(x, y, isRotated, "T");
    vertices = [[0, 0], [0, height], [width, height], [width - extrusion, height / 2], [width, 0]];
    drawPolygon(x, y, isRotated, vertices);
};

module G(vertices) union(){
    translate([width, height / 2, 0]) circle(height / 2, $fn = 100);
    polygon(vertices);
}

module drawG(x, y, isRotated) {
    y = y * height;
    drawLabel(x, y, isRotated, "G");
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
    drawLabel(x, y, isRotated, "C");
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

sequence = "A";

for(i = [0 : len(sequence)]){
    base = sequence[i];
    if(base == "A"){
        complimentary = "T";
        drawA(0, i, false);
        drawT(separation, i, true);
    }
    if(base == "T"){
        complimentary = "A";
        drawT(0, i, false);
        drawA(separation, i, true);
    }
    if(base == "C"){
        complimentary = "G";
        drawC(0, i, false);
        drawG(separation, i, true);
    }
    if(base == "G"){
        complimentary = "C";
        drawG(0, i, false);
        drawC(separation, i, true);
    }
    
}