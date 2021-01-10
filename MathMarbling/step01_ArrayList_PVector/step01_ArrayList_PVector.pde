ArrayList<ArrayList<PVector>> curves; //許多頂點構成curve, 許多curve構成curves
int pressT; //按下mouse時的時間
void setup(){
  size(512,512);
  curves = new ArrayList<ArrayList<PVector>>();
}
void draw(){
  background(0); //黑色的背景
  for( ArrayList<PVector> curve : curves ){ //這裡程式較無效率
    beginShape(); //逐一從 curves 裡, 取出 圓形的 curve 來畫 
    for( PVector pt : curve ){ //從圓形的 curve 裡, 取出 頂點pt
      vertex(pt.x, pt.y);
    }
    endShape();
  } //上面是完整的資料結構
  if( mousePressed ){ //正在 press 按下時, 先用 ellipse來畫
    int dt=(millis()-pressT)/10; //繪圖時,算出時間差dt=現在-pressT, 它的1/10當成直徑
    PVector center = curves.get(curves.size()-1).get(0); //之前按下去的點存在這裡,當圓心
    ellipse(center.x, center.y, dt, dt);
  }
}
void mousePressed(){ //按下去時, 建新的 curve, 同時暫時把圓心放在裡面
  ArrayList<PVector> curve = new ArrayList<PVector>();
  curve.add( new PVector(mouseX,mouseY) );
  curves.add(curve); //暫時把圓心放在裡面
  pressT=millis(); //記錄按下去的時間
}
void mouseReleased(){ //放開mouse時, 把整個圓的圓周上的頂點, 逐一加入 curve 裡, 完成資料結構
  int dt=(millis()-pressT)/10; //繪圖時,算出時間差dt=現在-pressT, 它的1/10當成直徑
  ArrayList<PVector> curve = curves.get(curves.size()-1); //最出 curves 的最後一條 curve, 裡面只存圓心座標
  PVector center = curve.get(0); //之前按下去的點(圓心)存在 curve 裡, 等下for(迴圈)要用
  curve.remove(0); //把原本的圓心刪掉, 下面for(迴圈)準備改加入圓周上的點
  for(float angle=0; angle<PI*2; angle+=2*PI/(dt*PI)){ //這裡非常密集,讓圓周上頂點距離很短,相鄰1 pixel
    PVector pt = new PVector(center.x+dt/2*cos(angle), center.y+dt/2*sin(angle)); //圓周上頂點用 sin() cos() 算出來
    curve.add(pt);
  }
}
