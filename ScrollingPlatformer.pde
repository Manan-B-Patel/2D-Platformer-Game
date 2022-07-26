import processing.sound.*;

final static float SPEED = 4;
final static float SIZE = 50;
final static float JUMP = 14;
static float MOVE_SPEED = 4;
final static float SPRITE_SCALE = 50.0/128;

static float SPRITE_SIZE = 50;
static float GRAVITY = .6;
static float JUMP_SPEED = 14; 

final static int NEUTRAL_FACING = 0; 
final static int RIGHT_FACING = 1; 
final static int LEFT_FACING = 2; 
final static int BOTTOM_FACING = 3; 
final static int TOP_FACING = 4; 

final static float WIDTH = SPRITE_SCALE * 16;
final static float HEIGHT = SPRITE_SIZE * 36;
final static float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;

final static float COIN_SCALE = 0.4;




//declare global variables
Player player;
PImage snow, crate, red_brick, brown_brick, coin, spider, playerImage, tnt, explode, speedBoost, extraLife, big, metal,
redStone1, redStone2, redStone3, redStone4, blackStone1, blackStone2, blackStone3, blackStone4, background1, background2,
background3, background4, orb;
PImage lives3, lives2, lives1, lives0;
ArrayList<Sprite> platforms;
ArrayList<Sprite> coins; 
ArrayList<Enemy> enemies;
ArrayList<Sprite> tnts;
ArrayList<Stompers> stomp;
ArrayList<Sprite> grow;
ArrayList<Sprite> speed;
ArrayList<Sprite> life;
ArrayList<Sprite> orbs;

Timer timer, timer1, timer2;



SoundFile mCoin, mJumpS, mJumpL, mPowerUp, mTheme, mExplosion, mFall, mGameOver, mfireball, mtext;
boolean isGameOver, condition1, condition2, condition4, condition5, cond;
int score;

float view_x;
float view_y;

int wi;
int he;


//initialize them in setup().
void setup(){
  size(800, 600);
  imageMode(CENTER);
  playerImage = loadImage("player_stand_right.png");
  player = new Player(playerImage, 0.8);
  player.center_y = 100;
  player.center_x = 100;
  platforms = new ArrayList<Sprite>();
  coins = new ArrayList<Sprite>();
  enemies = new ArrayList<Enemy>();
  tnts = new ArrayList<Sprite>();
  stomp = new ArrayList<Stompers>();
  grow = new ArrayList<Sprite>();
  speed = new ArrayList<Sprite>();
  life = new ArrayList<Sprite>();
  orbs = new ArrayList<Sprite>();
  
  mExplosion = new SoundFile(this, "smw_thunder.wav");
  mFall = new SoundFile(this, "smb_browser_falls.wav");
  mGameOver = new SoundFile(this, "smb3_game_over.wav");
  mfireball = new SoundFile(this, "smb_fireball.wav");
  mtext = new SoundFile(this, "smb3_text.wav");
  mCoin = new SoundFile(this, "smb3_coin.wav");
  mJumpS = new SoundFile(this, "smb_jump-small.wav");
  mJumpL = new SoundFile(this, "smb_jump-super.wav");
  mPowerUp = new SoundFile(this, "nsmb_power-up.wav");
  mTheme = new SoundFile(this, "094 World 8 - Bowsers World.mp3");
  
  mExplosion.amp(1);
  

  
  timer = new Timer(0);
  timer1 = new Timer(0);
  timer2 = new Timer(1000000);
  timer2.countUP();
  
  view_x = 0;
  view_y = 0;
  
  score = 0;
  
  condition1 = false;
  condition2 = false;
  condition4 = true;
  condition5 = true;
  cond = true;
  isGameOver = false;
  
  speedBoost = loadImage("Speed increaser.png");
  extraLife = loadImage("Health.png");
  big = loadImage("firerate increaser.png");
  
  background1 = loadImage("mines_BG.png");
  
  redStone1 = loadImage("ground0.png");
  redStone2 = loadImage("ground2.png");
  redStone3 = loadImage("groundl.png");
  redStone4 = loadImage("groundr.png");
  
  blackStone1 = loadImage("g0.png");
  blackStone2 = loadImage("g3.png");
  blackStone3 = loadImage("g11.png");
  blackStone4 = loadImage("g12.png");
  
  lives3 = loadImage("6.png");
  lives2 = loadImage("4.png");
  lives1 = loadImage("2.png");
  lives0 = loadImage("0.png");

  orb = loadImage("orb_red.png");
  metal = loadImage("Metal Box.png");
  explode = loadImage("ex.png");
  tnt = loadImage("TNT.png");  
  spider = loadImage("spider_walk_right1.png");
  coin = loadImage("gold1.png"); 
  red_brick = loadImage("red_brick.png");
  brown_brick = loadImage("brown_brick.png");
  crate = loadImage("crate.png");
  snow = loadImage("snow.png");
  wi = crate.width;
  he = crate.height;
  lives3.resize(lives3.width*2,lives3.height * 2);
  lives2.resize(lives2.width*2,lives2.height * 2);
  lives1.resize(lives1.width*2,lives1.height * 2);
  lives0.resize(lives0.width*2,lives0.height * 2);
  speedBoost.resize(wi, he);
  extraLife.resize(wi, he);
  big.resize(wi, he);
  tnt.resize(wi, he);
  metal.resize(wi,he);
  background1.resize(800,600);
  
  createPlatforms("map.csv");
  
}

// modify and update them in draw().
void draw(){
  background(background1);
  if(timer2.getTime() > mTheme.duration())
  {
    playMusic();
  }
  scroll();
  displayAll();
  if(!isGameOver){
    updateAll();
    collectCoins();
    collectPowerUps();
    checkDeath();
    orbC();
  }  
} 

void playMusic(){
    mTheme.play();
    timer2.setTime(0);
    timer2.countUP();
}


void displayAll(){
  for(Sprite s: platforms)
    s.display();
  
  for(Sprite l: tnts){
    l.display();
  }
  
  
  
  for(Sprite l: speed){
    l.display();
  }
  
  for(Sprite l: life){
    l.display();
  }
  
  for(Sprite l: grow){
    l.display();
  }
  for(Sprite x: orbs){
    x.display();
  }

  player.display();
  for(Enemy e: enemies)
  {
    e.display();
  }
  
  for(Stompers x: stomp){
    x.display();
  }
  
  if(condition1){
     timer.countUP();
     if(timer.getTime() > 20){
       MOVE_SPEED = SPEED;
       timer.setTime(0);
       condition1 = false;
     }
    }
    
  if(condition2){
   timer.countUP();
   if(timer.getTime() > 20){
     JUMP_SPEED = JUMP;
     timer.setTime(0);
     condition2 = false;
    }
  }
  
  textSize(32);
  fill(255, 0, 0);
  text("Coins:" + score, view_x + 50, view_y + 50);
  if(player.lives == 3)
    //text("Lives:", view_x + 50, view_y + 100);
    image(lives3, view_x + 100, view_y + 75);
  else if(player.lives == 2)
    //text("Lives:", view_x + 50, view_y + 100);
    image(lives2, view_x + 100, view_y + 75);
  else if(player.lives == 1)
    //text("Lives:", view_x + 50, view_y + 100);
    image(lives1, view_x + 100, view_y + 75);
  else if(player.lives == 0)
    //text("Lives:", view_x + 50, view_y + 100);
    image(lives0, view_x + 100, view_y + 75);
    
  
  if(isGameOver){
    fill(0,0,255);
    text("GAME OVER!", view_x + width/2 - 100, view_y + height/2);
    mCoin.stop();
    mJumpS.stop();
    mJumpL.stop();
    mPowerUp.stop();
    mTheme.stop();
    mExplosion.stop();
    //mFall.stop();
    mGameOver.stop();
    mfireball.stop();
    mtext.stop();
    if(player.lives == 0){
      text("You Lose!", view_x + width/2 - 100, view_y + height/2 + 50);
      //mtext.play();
    }
    else{
      text("You Win!", view_x + width/2 - 100, view_y + height/2 + 50);
      //mtext.play();
    }
    text("Press SPACE to restart!", view_x + width/2 - 100, view_y + height/2 + 100);
    MOVE_SPEED = SPEED;
    JUMP_SPEED = JUMP;
  }
}

void updateAll(){
  
  player.updateAnimation();
  resolvePlatformCollisions(player, platforms);
  
  for(Enemy e: enemies){
    e.update();
    e.updateAnimation();
  }
  
  for(Stompers x: stomp){
    x.update();
    x.updateAnimation();
  }
  for(Sprite x: coins){
    x.display();
    ((AnimatedSprite)x).updateAnimation();
  } 
  
}
void collectPowerUps(){
  ArrayList<Sprite> collision_list = checkCollisionList(player, speed);
  if(collision_list.size() > 0){
    for(Sprite s: collision_list){
       speed.remove(s);
       mPowerUp.play();
       MOVE_SPEED *= 2;
       condition1 = true;
    }
    
  }
  
  ArrayList<Sprite> collision_list1 = checkCollisionList(player, life);
  if(collision_list1.size() > 0){
    for(Sprite s: collision_list1){
       life.remove(s);
       mPowerUp.play();
       if(player.lives < 3){
         player.lives++;
       }
    }
  }
  
  ArrayList<Sprite> collision_list2 = checkCollisionList(player, grow);
  if(collision_list2.size() > 0){
    for(Sprite s: collision_list2){
       grow.remove(s);
       mPowerUp.play();
       JUMP_SPEED *= 1.5;
       condition2 = true;
    }
  }
}
void collectCoins(){
  ArrayList<Sprite> collision_list = checkCollisionList(player, coins);
  if(collision_list.size() > 0){
    for(Sprite coin: collision_list){
       coins.remove(coin);
       mCoin.play();
       score++;
    }
  }
  
  if(coins.size() == 0){
    isGameOver = true;
  }
}

void orbC(){
  ArrayList<Sprite> collision_list = checkCollisionList(player, orbs);
  if(collision_list.size() > 0){
    for(Sprite o: collision_list){
       orbs.remove(o);
    }
  }
  
  if(orbs.size() <= 1){
    isGameOver = true;
  }
}
void createPlatforms(String filename){
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++){
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++){
      if(values[col].equals("a")){
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("b")){
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("c")){
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("d")){
        Coin s = new Coin(coin, COIN_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        coins.add(s);
      }
      else if(values[col].equals("e")){
        Sprite s = new Sprite(tnt, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        tnts.add(s);
      }
      else if(values[col].equals("f")){
        Sprite s = new Sprite(redStone2, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("g")){
        int lengthGap = 2;
        float bTop = row * SPRITE_SIZE;
        float bBottom = bTop + lengthGap * SPRITE_SIZE;
        Stompers s = new Stompers(blackStone2, SPRITE_SCALE, bBottom, bTop);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        stomp.add(s);
      }
      else if(values[col].equals("h")){
        Sprite s = new Sprite(speedBoost, SPRITE_SCALE / 1.5);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        speed.add(s);
      }
      else if(values[col].equals("i")){
        Sprite s = new Sprite(extraLife, SPRITE_SCALE / 1.5);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        life.add(s);
      }
      else if(values[col].equals("j")){
        Sprite s = new Sprite(big, SPRITE_SCALE / 1.5);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        grow.add(s);
      }
      else if(values[col].equals("k")){
        Sprite s = new Sprite(metal, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("l")){
        Sprite s = new Sprite(orb, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        orbs.add(s);
      }
      else if(values[col].equals("0")){
        continue; // continue with for loop, i.e do nothing.
      }
      else{
        // use Processing int() method to convert a numeric string to an integer
        // representing the walk length of the spider.
        // for example int a = int("9"); means a = 9.
        int lengthGap = int(values[col]);
        float bLeft = col * SPRITE_SIZE;
        float bRight = bLeft + lengthGap * SPRITE_SIZE;
        Enemy enemy = new Enemy(spider, 52/70.0, bLeft, bRight);
        enemy.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;      // see cases above.
        enemy.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        // add enemy to enemies arraylist.
        enemies.add(enemy);
      }
    }
  } 
}

void checkDeath(){
  boolean s = false;
  ArrayList<Stompers> st = checkCollisionListStompers(player, stomp);
  
  if(st.size() > 0){
    resolvePlatformCollisions1(player, st);
    for(Stompers p: st){
      if(p.getBottom() >= player.getTop() + SPRITE_SIZE/2){
        s = true;
        break;
      }
    }
  }
  
  
  boolean collideEnemy = false;
  ArrayList<Enemy> e = checkCollisionListEnemy(player, enemies);
  if(e.size() > 0){
    collideEnemy = true;
   }
  boolean explo = false;
  ArrayList<Sprite> t = checkCollisionList(player, tnts);
  if(t.size() > 0){
    explo = true;
  }
  
  boolean fallOffCliff = player.getBottom() > GROUND_LEVEL;
  
  if(s){
    player.lives--;
    if(player.lives == 0){
      isGameOver = true;
    }
    else {
      text("YOU DIED! Press R to respawn!", view_x + width/2 - 200, view_y + height/2 + 100);
      mtext.play();
      mTheme.pause();
      timer2.setTime(100000);
      noLoop();
    }
  }
  
  if(collideEnemy){
    if(player.change_x != 0 || player.change_y == 0){
    player.lives--;
    if(player.lives == 0){
      isGameOver = true;
    }
    else {
      text("YOU DIED! Press R to respawn!", view_x + width/2 - 200, view_y + height/2 + 100);
      mtext.play();
      mTheme.pause();
      timer2.setTime(100000);
      noLoop();
    }
    } else
    {
      resolvePlatformCollisionsE(player, enemies);
      for(Enemy x: e){
        enemies.remove(x);
        mfireball.play();
      }
      
    }
  }
  
  if(fallOffCliff){
    //mFall.play();
    player.lives--;
    if(player.lives == 0){
      isGameOver = true;
    }
    else {
      text("YOU FELL! Press R to respawn!", view_x + width/2 - 200, view_y + height/2 + 100);
      mtext.play();
      mTheme.pause();
      timer2.setTime(100000);
      noLoop();
    }
  }
  
  if(explo){
    player.lives--;
    for(Sprite x: t){
      tnts.remove(x);
      image(explode, x.center_x, x.center_y, explode.width / 4, explode.height / 4);
      mExplosion.play();
    }
    if(player.lives == 0){
      isGameOver = true;
    }
    else {
      text("YOU DIED! Press R to respawn!", view_x + width/2 - 200, view_y + height/2 + 100);
      mtext.play();
      mTheme.pause();
      timer2.setTime(100000);
      noLoop();
      
    }
  }
  
}


void scroll(){
  float right_boundary = view_x + width - RIGHT_MARGIN;
  if(player.getRight() > right_boundary){
    view_x += player.getRight() - right_boundary;
  }
  
  float left_boundary = view_x + LEFT_MARGIN;
  if(player.getLeft() < left_boundary){
    view_x -= left_boundary - player.getLeft();
  }
  
  float bottom_boundary = view_y + height - VERTICAL_MARGIN;
  if(player.getBottom() > bottom_boundary){
    view_y += player.getBottom() - bottom_boundary;
  }
  
  float top_boundary = view_y + VERTICAL_MARGIN;
  if(player.getTop() < top_boundary){
    view_y -= top_boundary - player.getTop();
  }
  
  translate(-view_x, -view_y);

}


// returns true if sprite is one a platform.
public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls){
  // move down say 5 pixels
  s.center_y += 5;

  // check to see if sprite collide with any walls by calling checkCollisionList
  ArrayList<Sprite> collision_list = checkCollisionList(s, walls);
  
  // move back up 5 pixels to restore sprite to original position.
  s.center_y -= 5;
  
  // if sprite did collide with walls, it must have been on a platform: return true
  // otherwise return false.
  return collision_list.size() > 0; 
}


// Use your previous solutions from the previous lab.

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  // add gravity to change_y of sprite
  s.change_y += GRAVITY;
  
  // move in y-direction by adding change_y to center_y to update y position.
  s.center_y += s.change_y;
  
  // Now resolve any collision in the y-direction:
  // compute collision_list between sprite and walls(platforms).
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  
  /* if collision list is nonempty:
       get the first platform from collision list
       if sprite is moving down(change_y > 0)
         set bottom of sprite to equal top of platform
       else if sprite is moving up
         set top of sprite to equal bottom of platform
       set sprite's change_y to 0
  */
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_y > 0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y < 0){
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  }

  // move in x-direction by adding change_x to center_x to update x position.
  s.center_x += s.change_x;
  
  // Now resolve any collision in the x-direction:
  // compute collision_list between sprite and walls(platforms).   
  col_list = checkCollisionList(s, walls);

  /* if collision list is nonempty:
       get the first platform from collision list
       if sprite is moving right
         set right side of sprite to equal left side of platform
       else if sprite is moving left
         set left side of sprite to equal right side of platform
  */

  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_x > 0){
        s.setRight(collided.getLeft());
    }
    else if(s.change_x < 0){
        s.setLeft(collided.getRight());
    }
  }}
  
  public void resolvePlatformCollisions1(Sprite s, ArrayList<Stompers> walls){
  
  s.center_x += s.change_x;
  
    
  ArrayList<Stompers> col_list = checkCollisionListStompers(s, walls);

  
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    /*if(s.change_y >= 0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y <= 0){
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;*/
    //if(collided. > player.getTop()){
    if(s.change_x > 0){
        s.setRight(collided.getLeft());
    }
    else if(s.change_x < 0){
        s.setLeft(collided.getRight());
    }
    //}
  }
    
  
  /* if collision list is nonempty:
       get the first platform from collision list
       if sprite is moving down(change_y > 0)
         set bottom of sprite to equal top of platform
       else if sprite is moving up
         set top of sprite to equal bottom of platform
       set sprite's change_y to 0
  */
  /*
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_y > 0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y < 0){
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  } 
  */
  

  
}
public void resolvePlatformCollisionsE(Sprite s, ArrayList<Enemy> walls){
  
  s.center_y += s.change_y;
  
    
  ArrayList<Enemy> col_list = checkCollisionListEnemy(s, walls);

  
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_y >= 0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y <= 0){
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
    }
  }
    
  
  /* if collision list is nonempty:
       get the first platform from collision list
       if sprite is moving down(change_y > 0)
         set bottom of sprite to equal top of platform
       else if sprite is moving up
         set top of sprite to equal bottom of platform
       set sprite's change_y to 0
  */
  /*
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_y > 0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y < 0){
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  } 
  */
  

  


boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}

boolean checkCollisionX(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}

boolean checkCollisionStomp(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  
  if(noYOverlap || noXOverlap){
    return false;
  }
  else{
    if(!noYOverlap){
    return true;
    }
    return false;
  }
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

public ArrayList<Enemy> checkCollisionListEnemy(Sprite s, ArrayList<Enemy> list){
  ArrayList<Enemy> collision_list = new ArrayList<Enemy>();
  for(Enemy p: list){
    if(checkCollisionX(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

public ArrayList<Stompers> checkCollisionListStompers(Sprite s, ArrayList<Stompers> list){
  ArrayList<Stompers> collision_list = new ArrayList<Stompers>();
  for(Stompers p: list){
    if(checkCollisionStomp(s, p))
      collision_list.add(p);
  }
  return collision_list;
}


// called whenever a key is pressed.
void keyPressed(){
  if(keyCode == RIGHT){
    player.change_x = MOVE_SPEED;
  }
  else if(keyCode == LEFT){
    player.change_x = -MOVE_SPEED;
  }
  // add an else if and check if key pressed is 'a' and if sprite is on platforms
  // if true then give the sprite a negative change_y speed(use JUMP_SPEED)
  // defined above
  else if(keyCode == UP && isOnPlatforms(player, platforms)){
    if(Math.abs(JUMP_SPEED) == JUMP){
      mJumpS.play();
    } else{
      mJumpL.play();
    }
    player.change_y = -JUMP_SPEED;
      
  } else if(isGameOver && key == ' '){
    
    setup();
  } else if(key == 'r'){
    loop();
    player.center_y = 100;
    player.center_x = 100;
    MOVE_SPEED = SPEED;
    JUMP_SPEED = JUMP;
  } else if(keyCode == SHIFT && condition4){
    player.w /= 2;
    player.h /= 2;
    ArrayList<Sprite> x = checkCollisionList(player, platforms);
    if(x.size() > 0){
      Sprite e = x.get(0);
      if(player.getTop() >= e.getBottom())
      {
        player.setTop(e.getBottom());
      }
    }
    condition4 = false;
    condition5 = true;
  }
}

// called whenever a key is released.
void keyReleased(){
  if(keyCode == RIGHT){
    player.change_x = 0;
  }
  else if(keyCode == LEFT){
    player.change_x = 0;
  } else if(keyCode == SHIFT && condition5){
    player.w *= 2;
    player.h *= 2;
    condition5 = false;
    condition4 = true;
  }
}
