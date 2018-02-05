
class Mesh {

  ArrayList <MeshPoint> meshPoints = new ArrayList();
  
  float minX, minY, minZ, maxX, maxY, maxZ;
  
  float dimX, dimY, dimZ;

  Mesh(String inputPath) {
    importGH(inputPath);
    analyzeBoundingBox();
    analyzeBorders();
    analyzeCorners();
    analyzeNeighbours();
  }
  
  void analyzeNeighbours(){
    for(MeshPoint p : meshPoints){
      p.analyzeNeighbours();
    }
  }
  
  void analyzeBorders(){
    for(MeshPoint p : meshPoints){
      p.analyzeBorders();
    }
  }
  
  void analyzeCorners(){
    for(MeshPoint p : meshPoints){
      p.analyzeCorners();
    }
  }
  
  void display(){
    for(MeshPoint p : meshPoints){
      p.display();
      p.drawLineToNeighbours();
    }
  }
  
  void analyzeBoundingBox(){
    minX = Float.MAX_VALUE;
    minY = Float.MAX_VALUE;
    minZ = Float.MAX_VALUE;
    
    maxX = Float.MIN_VALUE;
    maxY = Float.MIN_VALUE;
    maxZ = Float.MIN_VALUE;
    
    for(MeshPoint p: meshPoints){
      if(p.pos.x < minX) minX = p.pos.x;
      if(p.pos.y < minY) minY = p.pos.y;
      if(p.pos.z < minZ) minZ = p.pos.z;
      if(p.pos.x > maxX) maxX = p.pos.x;
      if(p.pos.y > maxY) maxY = p.pos.y;
      if(p.pos.z > maxZ) maxZ = p.pos.z;
    }
    
     dimX = maxX - minX;
     dimY = maxY - minY;
     dimZ = maxZ - minZ;
    
    println("Mesh Bounding Box Analyzed.");
    println("MinX: " + minX, "MinY: " + minY, "MinZ: " + minZ,
            "MaxX: " + maxX, "MaxY: " + maxY, "MaxZ: " + maxZ);
    println("DimX: " + dimX, "DimY: " + dimY, "DimZ: " + dimZ);
            
  }

  void importGH(String path) {

    String lines[] = loadStrings(path);

    for (int i=0; i<lines.length; i++) {
      String s1[] = split(lines[i], "{");
      String s2[] = split(s1[1], "}");
      String s3[] = split(s2[0], ", ");

      float x = Float.valueOf(s3[0]);
      float y = Float.valueOf(s3[1]);
      float z = Float.valueOf(s3[2]);

      Vec3D v = new Vec3D(x, y, z);
      MeshPoint p = new MeshPoint(this, v);
      meshPoints.add(p);
    }
   
    println("Mesh Imported: " + meshPoints.size() + " MeshPoints");
  }
}