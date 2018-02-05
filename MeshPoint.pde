
class MeshPoint {

  Mesh parent;

  ArrayList <MeshPoint> neighbours = new ArrayList();


  int index = 0;
  Vec3D pos = new Vec3D(); // {float, float, float} - COLORMAP: 3, 4, 5
  boolean isBorder = false; // {0 or 1} - COLORMAP: 1
  boolean isCorner = false; // {0 or 1} - COLORMAP: 2
  float curvature = 0; //{-1,1} - COLORMAP: 6
  float roughness = 0; //{0,1} - COLORMAP: 7
  float maxSlope = 0; //{-1,1} - COLORMAP: 8
  Vec3D normal = new Vec3D(); // {float, float, float} - VECTORMAP: 1
  Vec3D dirLowestNeighbour = new Vec3D(); // {float, float, float} - VECTORMAP: 2
  Vec3D dirHighestNeighbour = new Vec3D(); //{float, float, float} - VECTORMAP: 3


  MeshPoint(Mesh parent, Vec3D pos) {
    this.parent = parent;
    this.pos = pos;
    index = parent.meshPoints.size();
  }

  void analyzeBorders() {
    float eps = 0.01;
    if (abs(pos.x - parent.minX)<eps || 
      abs(pos.x - parent.maxX)<eps ||
      abs(pos.z - parent.minZ)<eps || 
      abs(pos.z - parent.maxZ)<eps) {
      isBorder = true;
    }
  }

  void analyzeCorners() {
    float eps = 0.01;
    if ((abs(pos.x - parent.minX)<eps && abs(pos.z - parent.minZ)<eps)||
      (abs(pos.x - parent.minX)<eps && abs(pos.z - parent.maxZ)<eps) ||
      (abs(pos.x - parent.maxX)<eps && abs(pos.z - parent.minZ)<eps) ||
      (abs(pos.x - parent.maxX)<eps && abs(pos.z - parent.maxZ)<eps)) {
      isCorner = true;
    }
  }

  void analyzeCurvature() {
  }

  void analyzeRoughness() {
  }

  void analyzeMaxSlope() {
  }


  void analyzeNeighbours() {
    neighbours = new ArrayList();
    ArrayList <MeshPoint> pointsToSearch = new ArrayList(parent.meshPoints);

    int numNeighbours = 8;
    if (isBorder) numNeighbours = 5;
    if (isCorner) numNeighbours = 3;

    //TODO: Implement KNN algorithm
    for (int i=0; i<numNeighbours; i++) {

      float minDist = Float.MAX_VALUE;
      int indexClosest = -1;

      for (int j=0; j<pointsToSearch.size(); j++) {
        MeshPoint check = (MeshPoint) pointsToSearch.get(j);
        if (pos.distanceTo(check.pos) < minDist && this !=check) {
          minDist = pos.distanceTo(check.pos);
          indexClosest = j;
        }
      }


      MeshPoint closest = (MeshPoint) pointsToSearch.get(indexClosest);
      neighbours.add(closest);
      pointsToSearch.remove(closest);
    }

    println("analyzed point " + index + " / " + parent.meshPoints.size());
  }

  void drawLineToNeighbours() {

    for (MeshPoint neighbour : neighbours) {
      stroke(100);
      strokeWeight(1);
      line(pos.x, pos.y, pos.z, neighbour.pos.x, neighbour.pos.y, neighbour.pos.z);
    }
  }

  void display() {

    strokeWeight(5);

    //No map
    if (colorMap == 0) {
      stroke(255);
    }

    //isBorder
    else if (colorMap == 1) {
      if (isBorder) stroke(255, 0, 0);
      else stroke(255);
    }

    //isCorner
    else if (colorMap == 2) {
      if (isCorner) stroke(255, 0, 0);
      else stroke(255);
    }

    //pos.x
    else if (colorMap == 3) {

      color c = getColor(pos.x, parent.minX, parent.maxX);  
      stroke(c);
    }

    //pos.y
    else if (colorMap == 4) {

      color c = getColor(pos.y, parent.minY, parent.maxY);  
      stroke(c);
    }

    //pos.z
    else if (colorMap == 5) {
      color c = getColor(pos.z, parent.minZ, parent.maxZ);  
      stroke(c);
    }

    //curvature
    else if (colorMap == 6) {
    }

    //roughness
    else if (colorMap == 7) {
    }

    //maxSlope
    else if (colorMap == 8) {
    }


    point(pos.x, pos.y, pos.z);
  }
}