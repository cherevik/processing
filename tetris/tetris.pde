float CELLSIZE = 20.0;
float HEIGHT = 20; 
float WIDTH = 10;

/*-------------------- BOARD -----------------*/
class Board {
  int [][] pile; 
 
  Board() {
    this.pile = new int[(int)WIDTH][(int)HEIGHT];
    clear(); 
  }
  
  void clear() {
    for (int i = 0; i < WIDTH; i ++) {
      for (int j = 0; j < HEIGHT; j ++) {
        this.pile[i][j] = 0; 
      }  
    }
  }
  
  void draw() {
    rectMode(CENTER);
    fill(255);
    for (int i = 0; i < WIDTH; i ++) {
      for (int j = 0; j < HEIGHT; j ++) {
        if (this.pile[i][j] != 0) {
          float x = CELLSIZE * (i + 0.5); 
          float y = CELLSIZE * (j + 0.5);
          rect(x, y, CELLSIZE, CELLSIZE);
        }     
      }
    }   
  }

  void compactPile() {
    for (int i = 0; i < HEIGHT; i ++) {
      boolean filled = true; 
      for (int j = 0; j < WIDTH && filled; j ++) {
        if (this.pile[j][i] == 0) {
          filled = false; 
        }
      }  
      if (filled) {
        // remove this row 
        for (int k = 0; k < WIDTH; k ++) {
          for (int l = i; l > 0; l --) {
             this.pile[k][l] = this.pile[k][l-1];
          }
          this.pile[k][0] = 0;        
        }  
      }
    }
  }

  boolean occupied(int x, int y) {
    if (x < 0 || x >= WIDTH || y < 0 || y >= HEIGHT) {
      return false; 
    }
    return this.pile[x][y] != 0;
  }  
  
  void occupy(int x, int y) {
    this.pile[x][y] = 1;
  }
}

Board board = new Board(); 

/*-------------------- SHAPES -----------------*/
class Shape {
  
  PVector position; 
  PVector [] blocks; 
  float [] angles; 
  int state;
  
  Shape() {
    this.position = new PVector(6,0);
    this.state = 0;  
  }
  
  void draw() {
    rectMode(CENTER);
    fill(255);
    pushMatrix();
    translate((this.position.x+0.5)*CELLSIZE, (this.position.y+0.5)*CELLSIZE);
    rotate(this.angles[this.state]);
    for (int i = 0; i < this.blocks.length; i ++) {
      rect(this.blocks[i].x * CELLSIZE, this.blocks[i].y * CELLSIZE, CELLSIZE, CELLSIZE);
    }  
    popMatrix();    
  }
  
  void drop() {
    this.position.y += 1;  
  }
  
  boolean canDrop() {
    PVector new_position = new PVector(this.position.x, this.position.y);
    new_position.y += 1;
    return valid(new_position, this.state); 
  }
  
  void spin() {
    int new_state = (this.state + 1) % this.angles.length;
    if (this.valid(this.position, new_state)) {
      this.state = new_state;
    }  
  }
  
  void left() {
    PVector new_position = new PVector(this.position.x, this.position.y); 
    new_position.x -= 1;
    if (this.valid(new_position, this.state)) {
       this.position = new_position;
    } 
  }
  
  void right() {
    PVector new_position = new PVector(this.position.x, this.position.y); 
    new_position.x += 1;
    if (this.valid(new_position, this.state)) {
       this.position = new_position;
    } 
  }
  
  void bottom_drop() {
    while (this.canDrop()) {
      this.drop();
    }
  }
  
  boolean valid(PVector pos, int st) {
    for (int i = 0; i < this.blocks.length; i ++) {
      PVector block = this.blocks[i]; 
      PVector test = new PVector(block.x, block.y); 
      test.rotate(this.angles[st]);
      test.add(pos); 
      int x = round(test.x); 
      int y = round(test.y);
      if (x < 0 || x >= WIDTH || y < 0 || y >= HEIGHT) {
        return false;
      }
      if (board.occupied(x, y)) {
        return false; 
      }
    }  
    return true;
  }
  
  boolean valid() {
    return valid(this.position, this.state); 
  }
  
  void addToPile() {
    for (int i = 0; i < this.blocks.length; i ++) {
      PVector block = this.blocks[i]; 
      PVector test = new PVector(block.x, block.y); 
      test.rotate(this.angles[this.state]);
      test.add(this.position); 
      int x = round(test.x); 
      int y = round(test.y);
      board.occupy(x, y); 
    }  
  }
}

class OShape extends Shape {
  OShape() {
    this.blocks = new PVector[] {
      new PVector(0, 0), 
      new PVector(0, 1), 
      new PVector(-1, 1), 
      new PVector(-1, 0)
    }; 
    this.angles = new float[] { 
      0
    };
  }
}

class IShape extends Shape {
  IShape() {
    this.blocks = new PVector[] {
      new PVector(1, 0), 
      new PVector(0, 0), 
      new PVector(-1, 0), 
      new PVector(-2, 0)
    };
    this.angles = new float[] {
      0, -HALF_PI
    };
  }
}

class SShape extends Shape {
  SShape() {
    this.blocks = new PVector[] {
      new PVector(1, 0), 
      new PVector(0, 0), 
      new PVector(0, 1), 
      new PVector(-1, 1)
    };
    this.angles = new float[] {
      0, -HALF_PI
    };
  }
}

class ZShape extends Shape {
  ZShape() {
    this.blocks = new PVector[] {
      new PVector(1, 1), 
      new PVector(0, 1), 
      new PVector(0, 0), 
      new PVector(-1, 0)
    };
    this.angles = new float[] {
      0, -HALF_PI
    };
  }
}

class LShape extends Shape {
  LShape() {
    this.blocks = new PVector[] {
      new PVector(1, 0), 
      new PVector(0, 0), 
      new PVector(-1, 0), 
      new PVector(-1, 1)
    };
    this.angles = new float[] {
      0, -HALF_PI, -PI, HALF_PI
    };
  }
}

class JShape extends Shape {
  JShape() {
    this.blocks = new PVector[] {
      new PVector(1, 1), 
      new PVector(1, 0), 
      new PVector(0, 0), 
      new PVector(-1, 0)
    };
    this.angles = new float[] {
      0, -HALF_PI, -PI, HALF_PI
    };
  }
}

class TShape extends Shape {
  TShape() {
     this.blocks = new PVector[] {
       new PVector(1,0),
       new PVector(0,0),
       new PVector(0,1),
       new PVector(-1,0)
     };
    this.angles = new float[] {
      0, -HALF_PI, -PI, HALF_PI
    };
  } 
}

Shape spawn() {
   Shape piece;
   int index = Math.round(random(255)%7); 
   switch (index) {
     case 0: 
       piece = new OShape(); 
       break; 
     case 1: 
       piece = new IShape(); 
       break; 
     case 2: 
       piece = new SShape(); 
       break; 
     case 3: 
       piece = new ZShape(); 
       break; 
     case 4: 
       piece = new LShape(); 
       break; 
     case 5: 
       piece = new JShape(); 
       break; 
     default: 
       piece = new TShape(); 
       break;
   }
   if (!piece.valid()) {
     board.clear();
   }
   return piece; 
}


int level = 0; 
long countdown = 0;
Shape active_piece = null;
long ts; 

void setup() {
  size(200, 400); 
  background(0);
  ts = millis();
  board.clear(); 
}

void draw() {
  background(0);
  if (active_piece != null) {    
    active_piece.draw();
  }
  board.draw();
  long new_ts = millis();
  long delta = new_ts - ts; 
  ts = new_ts; 
  countdown = countdown - delta;   
  if (countdown > 0) {
    return; 
  }
  countdown = 50 * (11-level);
  if (active_piece == null) {
    active_piece = spawn();  
  }
  if (active_piece.canDrop()) {
    active_piece.drop(); 
  } else {
    active_piece.addToPile();
    active_piece = null;
    board.compactPile();
  }
}

void keyPressed() {  
  if (active_piece == null) {
    return; 
  }
  switch (keyCode) {
    case 38: // UP
      active_piece.spin(); 
      break; 
    case 39: // RIGHT
      active_piece.right(); 
      break; 
    case 37: // LEFT
      active_piece.left();
      break; 
    case 32: // DOWN
      active_piece.bottom_drop();
      active_piece.addToPile();
      active_piece = null;
      board.compactPile();
      break; 
  }    
}

