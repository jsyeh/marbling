ArrayList<ArrayList<PVector>> curves; //許多頂點構成curve, 許多curve構成curves
int pressT, pressT2; //pressT: 按下mouse時的時間, pressT2: 滴墨時前一次位移的時間, 之後可合併
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
    print(curve.size()+" "); //這裡印出 curve 裡的頂點數量
  } //上面是完整的資料結構
  println(curves.size()); //這裡印出 curves 的數量, 發現越來越慢, 因為頂點越來越多
  if( mousePressed ){ //正在 press 按下時, 先用 ellipse 來畫
    //pressT: 按下mouse時的時間
    float dt=sqrt((millis()-pressT)); //繪圖時,算出時間差dt=現在-pressT, 用它算墨量, 開根號後當成直徑
    PVector center = curves.get(curves.size()-1).get(0); //之前按下去的點存在這裡,當圓心
    ellipse(center.x, center.y, dt, dt);
    
    float dt2=sqrt((millis()-pressT2)); //墨量與時間正比, 直徑需要開根號, pressT2: 滴墨時前一次位移的時間
    eq1_inkDrop(center.x, center.y, dt2/2); //在滴墨時, 依照墨量(半徑) 持續修改其他頂點位置
    pressT2=millis(); //這裡同時更新時間, 以便算出正確的墨量
  }
}
void mousePressed(){ //按下去時, 建新的 curve, 同時暫時把圓心放在裡面
  ArrayList<PVector> curve = new ArrayList<PVector>();
  curve.add( new PVector(mouseX,mouseY) );
  curves.add(curve); //暫時把圓心放在裡面
  pressT2=pressT=millis(); //記錄按下去的時間
}
void mouseReleased(){ //放開mouse時, 把整個圓的圓周上的頂點, 逐一加入 curve 裡, 完成資料結構
  float dt=sqrt((millis()-pressT)); //繪圖時,算出時間差dt=現在-pressT, 把它開根號,當成直徑
  ArrayList<PVector> curve = curves.get(curves.size()-1); //最出 curves 的最後一條 curve, 裡面只存圓心座標
  PVector center = curve.get(0); //之前把按下去的點存在這裡
  curve.remove(0); //把原本的圓心刪掉, 下面準備加入圓周上的點
  for(float angle=0; angle<PI*2; angle+=2*PI/(dt*PI)){ //這裡非常密集,讓圓周上頂點距離很短,相鄰1 pixel
    PVector pt = new PVector(center.x+dt/2*cos(angle), center.y+dt/2*sin(angle)); //圓周上頂點用 sin() cos() 算出來
    curve.add(pt); //所以每個加進去的頂點, 都在圓周上, 而且相鄰 1 pixel
  }
}
//論文裡提到, 滴墨有2種狀況: 一種要變形(慢), 一種不變形(快)
void eq1_inkDrop(float cx, float cy, float r){ //滴墨的變形公式 equation 1 
  for( ArrayList<PVector> curve : curves ){
    if(curve.size()<=1) continue;//避開(最後一個curve) 圓心的點, 避免公式出錯
    for( PVector pt : curve ){
      float dx=pt.x-cx, dy=pt.y-cy; //公式裡面, 要計算 P-C 向量
      float scale = sqrt(1+r*r/(dx*dx+dy*dy)); //公式裡面的移動比例
      pt.x = cx + (pt.x-cx)*scale; //依移動比例, 改變現有頂點的位置
      pt.y = cy + (pt.y-cy)*scale; //依移動比例, 改變現有頂點的位置
    }
  }
}
