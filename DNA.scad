width = 20;
height = 10;
extrusion = height / 2;
separation = 7;
textHeightCoeff = .4;
textXoffset = 5;

//https://gist.github.com/Stemer114/7e420ea8ad9733c4e0ba
module ring(
        h=1,
        od = 10,
        id = 5,
        de = 0.1
        ) 
{
    difference() {
        cylinder(h=h, r=od/2, $fn=20);
        translate([0, 0, -de])
            cylinder(h=h+2*de, r=id/2, $fn=20);
    }
}


module drawLabel(x, y, isRotated, string){
    offsetY = (height * (1 - textHeightCoeff) / 2);
    translate([x + (isRotated ? (width*2) - textXoffset : textXoffset), y + offsetY, 2.5]){
        text(text=string, size=(height * textHeightCoeff), font="Muli:style=Bold", halign=(isRotated ? "right" : "left"));
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
module drawT(x, y, isRotated, useRNAencoding = false) {
    y = y * height;
    drawLabel(x, y, isRotated, useRNAencoding ? "U" : "T");
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

rna = true;
sequence = "AUG";

for(i = [0 : len(sequence)]){
    base = sequence[len(sequence) - i - 1];
    if(base == "A"){
        drawA(0, i, false);
        drawT(separation, i, true, rna);
    }
    if(base == "T" || base == "U"){
        drawT(0, i, false, base == "U");
        drawA(separation, i, true);
    }
    if(base == "C"){
        drawC(0, i, false);
        drawG(separation, i, true);
    }
    if(base == "G"){
        drawG(0, i, false);
        drawC(separation, i, true);
    }
    
}
translate([width / 2, (height * len(sequence)) + 1, 0]) ring(h=3, id=2, od=3, de=.01);
translate([(width / 2) + separation + width, (height * len(sequence)) + 1, 0]) ring(h=3, id=2, od=3, de=.01);