import peasy.*;
import toxi.geom.*;

PeasyCam cam;
Mesh mesh;

String inputPath = "data/import/Surfaces__Bottom__TXT/31__Perlin_1.txt";
String outputPath = "data/export/Surfaces__Bottom__TXT/31__Perlin_1result.csv";

boolean displayPoints = true;
boolean displayEdges = true;

int colorMap = 0;
int vectorMap = 0;

int numColorMaps = 8;
int numVectorMaps = 3;

void setup() {
  size(1440, 780, P3D);
  cam = new PeasyCam(this, 100);
  mesh = new Mesh(inputPath);
  exportData();
}

void draw() {
  background(0);
  mesh.display();
  displayBox();
}

void displayBox() {
  noFill();
  stroke(255);
  strokeWeight(1);
  pushMatrix();

  translate(mesh.dimX/2, mesh.dimY/2, mesh.dimZ/2);
  translate(mesh.minX, mesh.minY, mesh.minZ);
  box(mesh.dimX, mesh.dimY, mesh.dimZ);
  popMatrix();
}

color getColor(float value, float min, float max) {
  color result = color(0);

  float t = map(value, min, max, 0, 1);
  
  result = color(t*255);
  
  return result;
}

void exportData(){
  
  PrintWriter output = createWriter(outputPath);

  String header = "";
  header += "index,";
  header += "posX,";
  header += "posY,";
  header += "posZ,";
  header += "isBorder,";
  header += "isCorner,";
  header += "curvature,";
  header += "roughness,";
  header += "maxSlope,";
  header += "normal.x,";
  header += "normal.y,";
  header += "normal.z,";
  header += "dirLowestNeighbour.x,";
  header += "dirLowestNeighbour.y,";
  header += "dirLowestNeighbour.z,";
  header += "dirHighestNeighbour.x,";
  header += "dirHighestNeighbour.y,";
  header += "dirHighestNeighbour.z";

  for (MeshPoint p : mesh.meshPoints) {
    
    String line = "";
    line += p.index + ",";
    line += p.pos.x + ",";
    line += p.pos.y + ",";
    line += p.pos.z + ",";
    line += p.isBorder ? "1," : "0,";
    line += p.isCorner ? "1," : "0,";
    line += p.curvature + ",";
    line += p.roughness + ",";
    line += p.maxSlope + ",";
    line += p.normal.x + ",";
    line += p.normal.y + ",";
    line += p.normal.z + ",";
    line += p.dirLowestNeighbour.x + ",";
    line += p.dirLowestNeighbour.y + ",";
    line += p.dirLowestNeighbour.z + ",";
    line += p.dirHighestNeighbour.x + ",";
    line += p.dirHighestNeighbour.y + ",";
    line += p.dirHighestNeighbour.z;
    
    output.println(line);
  }

  output.flush();
  output.close();

  println("data exported");
  
}

void keyPressed() {

  if (key=='1') {
    colorMap++;
    if (colorMap>numColorMaps) colorMap = 0;
    println("colorMap: " + colorMap);
  }
  if (key=='2') {
    vectorMap++;
    if (vectorMap>numVectorMaps) vectorMap = 0;
    println("vectorMap: " + vectorMap);
  }
}