// Nov 2013
// http://jiyu-kenkyu.org
// http://kow-luck.com
//
// This work is licensed under a Creative Commons 3.0 License.
// (Attribution - NonCommerical - ShareAlike)
// http://creativecommons.org/licenses/by-nc-sa/3.0/
// 
// This basically means, you are free to use it as long as you:
// 1. give http://kow-luck.com a credit
// 2. don't use it for commercial gain
// 3. share anything you create with it in the same way I have
//
// If you want to use this work as free, or encourage me,
// please contact me via http://kow-luck.com/contact

//========================================
import processing.opengl.*;

int nodesNUM = 26;
int nSize = 300;
Nodes[] nodes = new Nodes[nodesNUM];

int []X = {
  -nSize,      0,  nSize, -nSize,      0,  nSize, -nSize,      0,  nSize, 
  -nSize,      0,  nSize, -nSize,  /*0,*/  nSize, -nSize,      0,  nSize, 
  -nSize,      0,  nSize, -nSize,      0,  nSize, -nSize,      0,  nSize
};
int []Y = {
  -nSize, -nSize, -nSize,      0,      0,      0,  nSize,  nSize,  nSize, 
  -nSize, -nSize, -nSize,      0,  /*0,*/      0,  nSize,  nSize,  nSize, 
  -nSize, -nSize, -nSize,      0,      0,      0,  nSize,  nSize,  nSize
};
int []Z = {
  -nSize, -nSize, -nSize, -nSize, -nSize, -nSize, -nSize, -nSize, -nSize, 
       0,      0,      0,      0,  /*0,*/      0,       0,     0,      0, 
   nSize,  nSize,  nSize,  nSize,  nSize,  nSize,  nSize,  nSize,  nSize
};

float zView, zViewInc;
float rotEyeX, rotEyeY, rotEyeZ;
//==============
void setup() {
  size(1280, 720, OPENGL);
  frameRate(60);
  for (int i = 0; i < nodesNUM; i ++) {
    nodes[i] = new Nodes(X[i], Y[i], Z[i], nSize);
  }
  zView = -width;
  zViewInc = 3;
  rotEyeX = 0;
  rotEyeY = 0;
  rotEyeZ = 0;
}
//==============
void draw() {
  background(0);
  ambientLight(5, 5, 5);
  directionalLight(100, 100, 100, 1, 1, -1);
  translate(width/2, height/2, 0);
  eyeMove();
  eyeRotation();
  pointLight(255, 255, 255, 0, 0, -nSize*1.5); 
  shininess(7.0); 
  for (int i = 0; i < nodesNUM; i++) {
    nodes[i].display();
  }
  noStroke();
  fill(240, 255, 255);
  sphereDetail(40);
  shininess(10.0); 
  sphere(nSize/3);
  println(frameRate);
}
//==============   
void eyeMove() {
  translate(0, 0, zView);
  zView += zViewInc;
  if (zView <-width || zView > width/3) {
    zViewInc *= -1;
  }
} 
//==============  
void eyeRotation() {
  rotateX(radians(rotEyeX) + radians(mouseY/2));
  rotateY(radians(rotEyeX) + radians(mouseX/2));
  rotateZ(radians(rotEyeX));
  rotEyeX += 0.2;
  rotEyeY += 0.8;
  rotEyeZ += 0.3;
  if (radians(rotEyeX) + radians(mouseY) > 360) {
    rotEyeX = 0;
  }
  if (radians(rotEyeY) + radians(mouseY) > 360) {
    rotEyeY = 0;
  }
  if (radians(rotEyeZ) > 360) {
    rotEyeZ = 0;
  }
}
//========================
public class Nodes {
  int NUM = 16;  
  float[] xPos = new float[NUM];
  float[] yPos = new float[NUM];
  float[] zPos = new float[NUM];
  float[] xMov = new float[NUM];
  float[] yMov = new float[NUM];
  float[] zMov = new float[NUM];

  float lineAlpha;
  float sphRad;

  float displayX, displayY, displayZ, bounceArea;
//======================== 
  Nodes(float _displayX, float _displayY, float _displayZ, int _bounceArea) {
    displayX = _displayX;
    displayY = _displayY;
    displayZ = _displayZ;
    bounceArea = _bounceArea;

    for (int i=0; i<NUM; i++) {
      xPos[i] = random(-bounceArea/2, bounceArea/2);
      yPos[i] = random(-bounceArea/2, bounceArea/2);
      zPos[i] = random(-bounceArea/2, bounceArea/2);
      xMov[i] = random(-4, 4);
      yMov[i] = random(-2, 2);
      zMov[i] = random(-6, 6);
    }
  }
  //========================
  public void display() {
    colorMode(RGB, 255, 255, 255, bounceArea);
    this.drawMe();
    this.moveAndBounce();
  }

  //========================
  private void drawMe() {
    sphRad = bounceArea / 9;
    sphereDetail(14);

    pushMatrix();
    translate(displayX, displayY, displayZ);
   
    for (int i = 1; i < NUM; i++) {
      pushMatrix();
      translate(xPos[i], yPos[i], zPos[i]);
      noStroke();
      fill(200);
      sphere(sphRad);
      popMatrix();

      for (int j = i; j < NUM; j++) {
        lineAlpha = bounceArea - (dist(xPos[i], yPos[i], zPos[i], xPos[j], yPos[j], zPos[j]));
        strokeWeight(1);
        stroke(255, 255, 255, lineAlpha);
        line(xPos[i], yPos[i], zPos[i], xPos[j], yPos[j], zPos[j]);
      }
    }
    popMatrix();
  }

  //========================
  private void moveAndBounce() {
    for (int i = 1; i < NUM; i++) {
      xPos[i] += xMov[i];
      yPos[i] += yMov[i];
      zPos[i] += zMov[i];

      if (xPos[i] < -bounceArea/2 || xPos[i] > bounceArea/2) {
        xMov[i] *=-1;
      }
      if (yPos[i] < -bounceArea/2 || yPos[i] > bounceArea/2) {
        yMov[i] *=-1;
      }
      if (zPos[i] < -bounceArea/2 || zPos[i] > bounceArea/2) {
        zMov[i] *=-1;
      }
    }
  }
}


