int n;
PImage[][] pg;
int[][][] p;
ArrayList<int[]> moves;
int moveCount;
boolean solved;

void setup() {
  size(600, 600); //6x6-ra (593, 593)
  frameRate(60);
  n=10;
  pg=new PImage[n][n];
  p=new int[n][n][2];
  moves=new ArrayList<int[]>();
  moveCount=0;
  solved=false;
  colorMode(HSB, 1);
  noStroke();
  background(0);
  for (int k=0; k<width; k++) {
    fill(((float)k/width+0.6)%1, 1, 1);
    circle(width/2, width/2, width-k);
  }
  PImage img=new PImage(width, height);
  loadPixels();
  img.loadPixels();
  img.pixels=pixels.clone();
  img.updatePixels();
  updatePixels();
  background(0);
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      p[i][j]=new int[]{i, j};
      pg[i][j]=img.get(i*width/n, j*width/n, width/n, width/n);
    }
  }
  scramble(floor(pow(n, 2)));
  frameRate(60);
}

void draw() {
  //println(frameRate);
  for (int i=0; i<1; i++) {
    if (!solved) {
      step();
    }
  }
  show();
}

void step() {
  int[] wrong=null;
  int[] wrongP=null;
  boolean found=false;
  for (int j=1; j<n; j++) {
    for (int i=0; i<n; i++) {
      if (!(p[i][j][0]==i&&p[i][j][1]==j)) {
        wrong=new int[]{i, j};
        wrongP=p[wrong[0]][wrong[1]].clone();
        if (!(wrongP[0]==0&&wrongP[1]==1)) {
          if (wrongP[1]>0) {
            found=true;
          }
        }
      }
      if (found) {
        break;
      }
    }
    if (found) {
      break;
    }
  }
  if (found) {
    if (wrong[0]>0) {
      move(0, 0, 0, wrong[0]);
      move(wrong[0], 0, n-wrong[1], 0);
      move(0, 0, 0, n-wrong[0]);
      move(wrong[0], 0, wrong[1], 0);
    } else {
      move(0, 0, n-wrong[1], 0);
      move(0, 0, 0, n-1);
      move(0, 0, wrong[1], 0);
      move(0, 0, 0, 1);
    }
    if (wrongP[0]>0) {
      move(wrongP[0], 0, n-wrongP[1], 0);
      move(0, 0, 0, wrongP[0]);
      move(wrongP[0], 0, wrongP[1], 0);
      move(0, 0, 0, n-wrongP[0]);
    } else {
      move(0, 0, 0, 1);
      move(0, 0, n-wrongP[1], 0);
      move(0, 0, 0, n-1);
      move(0, 0, wrongP[1], 0);
    }
  } else {
    for (int i=0; i<n; i++) {
      if (!(p[i][0][0]==i&&p[i][0][1]==0)) {
        wrong=new int[]{i, 0};
        wrongP=p[wrong[0]][wrong[1]].clone();
        if (!(wrongP[0]==0&&wrongP[1]==1)) {
          if (wrongP[1]>0) {
            found=true;
          }
        }
      }
      if (found) {
        break;
      }
    }
    if (found) {
      move(0, 0, 0, n-wrong[0]);
      move(0, 0, n-1, 0);
      move(0, 0, 0, wrong[0]);
      move(0, 0, 1, 0);
      if (wrongP[0]>0) {
        move(wrongP[0], 0, n-wrongP[1], 0);
        move(0, 0, 0, wrongP[0]);
        move(wrongP[0], 0, wrongP[1], 0);
        move(0, 0, 0, n-wrongP[0]);
      } else {
        move(0, 0, 0, 1);
        move(0, 0, n-wrongP[1], 0);
        move(0, 0, 0, n-1);
        move(0, 0, wrongP[1], 0);
      }
    } else {
      for (int i=0; i<n; i++) {
        if (!(p[i][0][0]==i&&p[i][0][1]==0)) {
          wrong=new int[]{i, 0};
          wrongP=p[wrong[0]][wrong[1]].clone();
          if (wrongP[1]==0) {
            found=true;
          }
        }
        if (found) {
          break;
        }
      }
      if (found) {
        move(0, 0, 0, n-wrong[0]);
        move(0, 0, n-1, 0);
        move(0, 0, 0, n-wrongP[0]+wrong[0]);
        move(0, 0, 1, 0);
        move(0, 0, 0, wrongP[0]);
      } else {
        if (!(p[0][1][0]==0&&p[0][1][1]==1)) {
          wrong=new int[]{p[0][1][0], 0};
          move(0, 0, 0, n-wrong[0]);
          move(0, 0, n-1, 0);
          for (int i=n-1; i>1; i-=2) {
            move(0, i, 0, n-1);
            move(0, 0, 2, 0);
            move(0, i, 0, 1);
            move(0, 0, n-1, 0);
            move(0, i, 0, n-1);
            move(0, 0, n-1, 0);
            move(0, i, 0, 1);
          }
          move(0, 0, 0, wrong[0]);
        }
        solved=true;
        printMoves();
      }
    }
  }
}

void move(int x, int y, int lx, int ly) {
  moves.add(new int[]{x, y, lx, ly});
  moveCount++;
  int[][] temp;
  lx=lx%n;
  ly=ly%n;
  if (lx>0) {
    if (lx<n/2) {
      temp=new int[lx][2];
      for (int i=0; i<lx; i++) {
        temp[i]=p[x][i+n-lx].clone();
      }
      for (int i=n-1; i>=lx; i--) {
        p[x][i]=p[x][i-lx].clone();
      }
      for (int i=0; i<lx; i++) {
        p[x][i]=temp[i].clone();
      }
    } else {
      lx=n-lx;
      temp=new int[lx][2];
      for (int i=0; i<lx; i++) {
        temp[i]=p[x][i].clone();
      }
      for (int i=0; i<n-lx; i++) {
        p[x][i]=p[x][i+lx].clone();
      }
      for (int i=0; i<lx; i++) {
        p[x][i+n-lx]=temp[i].clone();
      }
    }
  }
  if (ly>0) {
    if (ly<n/2) {
      temp=new int[ly][2];
      for (int i=0; i<ly; i++) {
        temp[i]=p[i+n-ly][y].clone();
      }
      for (int i=n-1; i>=ly; i--) {
        p[i][y]=p[i-ly][y].clone();
      }
      for (int i=0; i<ly; i++) {
        p[i][y]=temp[i].clone();
      }
    } else {
      ly=n-ly;
      temp=new int[ly][2];
      for (int i=0; i<ly; i++) {
        temp[i]=p[i][y].clone();
      }
      for (int i=0; i<n-ly; i++) {
        p[i][y]=p[i+ly][y].clone();
      }
      for (int i=0; i<ly; i++) {
        p[i+n-ly][y]=temp[i].clone();
      }
    }
  }
}

void scramble(int step) {
  for (int i=0; i<step; i++) {
    if (random(1)<0.5) {
      move(floor(random(n)), 0, floor(random(n-1)+1), 0);
    } else {
      move(0, floor(random(n)), 0, floor(random(n-1)+1));
    }
  }
}

void printP(int mode) {
  switch(mode) {
  case 0:
    for (int j=0; j<n; j++) {
      for (int i=0; i<n; i++) {
        print("("+complete(p[i][j][0], 0)+","+complete(p[i][j][1], 0)+") ");
      }
      println();
    }
    break;
  case 1:
    for (int j=0; j<n; j++) {
      for (int i=0; i<n; i++) {
        print(complete(p[i][j][0]+p[i][j][1]*n, 1)+" ");
      }
      println();
    }
    break;
  }
  println();
}

String complete(int x, int mode) {
  String s="";
  int xLength;
  int nLength;
  switch(mode) {
  case 0:
    xLength=floor(log(x)/log(10));
    nLength=floor(log(n)/log(10));
    if (x!=0) {
      for (int i=0; i<nLength-xLength; i++) {
        s+="0";
      }
    } else {
      for (int i=0; i<nLength; i++) {
        s+="0";
      }
    }
    break;
  case 1:
    xLength=floor(log(x)/log(10));
    nLength=floor(log(pow(n, 2))/log(10));
    if (x!=0) {
      for (int i=0; i<nLength-xLength; i++) {
        s+="0";
      }
    } else {
      for (int i=0; i<nLength; i++) {
        s+="0";
      }
    }
    break;
  }
  return s+x;
}

void printMoves() {
  println();
  print("new int[][]{{"+moves.get(0)[0]+","+moves.get(0)[1]+","+moves.get(0)[2]+","+moves.get(0)[3]+"}");
  for (int i=1; i<moves.size(); i++) {
    print(",{"+moves.get(i)[0]+","+moves.get(i)[1]+","+moves.get(i)[2]+","+moves.get(i)[3]+"}");
  }
  println("}");
}

void show() {
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      image(pg[p[i][j][0]][p[i][j][1]], i*(width/n), j*(height/n));
    }
  }
}
