Math Marbling Step 03
=====================

Tine Line Pattern Function
--------------------------

在這個版本裡, 使用 Mathematical Marbling 的公式(2) 來進行 拉動(Tine Line Pattern Function) 的模擬。公式(2)如下:

![\Large P'=P+\frac{\alpha\lambda}{d+\lambda}M](https://latex.codecogs.com/gif.latex?\mathbf{P'}=\mathbf{P}&plus;\frac{\alpha\lambda}{d&plus;\lambda}\mathbf{M})

因為需要重覆審視 tine line 出來的結果, 所以必須要有 Undo 的能力。因此, curves 裡的頂點不應該直接修改。應該要可以演練後, 再決定是否要確定。

Processing Code
---------------

```Processing
ArrayList<ArrayList<PVector>> curves; //許多頂點構成curve, 許多curve構成curves
ArrayList<ArrayList<PVector>> curves2=null; //為了 Undo 而先backup到curves2, 讓curves暫秀出演練結果, 供 tine line使用
int pressT, pressT2; //pressT: 按下mouse時的時間, pressT2: 滴墨時前一次位移的時間, 之後可合併
//boolean bSimpleInkDrop=false;//切換簡單滴墨(快) or 公式(1)滴墨(慢,deformation)
void setup(){
  size(512,512);
  curves = new ArrayList<ArrayList<PVector>>();
  textAlign(LEFT, TOP);
  textSize(32);
}
void draw(){
  background(0); //黑色的背景
  fill(255);
  for( ArrayList<PVector> curve : curves ){ //這裡程式較無效率
    beginShape(); //逐一從 curves 裡, 取出 圓形的 curve 來畫 
    for( PVector pt : curve ){ //從圓形的 curve 裡, 取出 頂點pt
      vertex(pt.x, pt.y);
    }
    endShape();
    print(curve.size()+" "); //這裡印出 curve 裡的頂點數量
  } //上面是完整的資料結構
  println("curves.size():",curves.size()); //這裡印出 curves 的數量, 發現越來越慢, 因為頂點越來越多
  if( (function==0||function==1) && mousePressed ){ //正在 press 按下時, 先用 ellipse 來畫
    //pressT: 按下mouse時的時間
    float dt=sqrt((millis()-pressT)); //繪圖時,算出時間差dt=現在-pressT, 用它算墨量, 開根號後當成直徑
    PVector center = curves.get(curves.size()-1).get(0); //之前按下去的點存在這裡,當圓心
    ellipse(center.x, center.y, dt, dt);
    
    float dt2=sqrt((millis()-pressT2)); //墨量與時間正比, 直徑需要開根號, pressT2: 滴墨時前一次位移的時間
    if(function==0) eq1_inkDrop(center.x, center.y, dt2/2); //在滴墨時, 依照墨量(半徑) 持續修改其他頂點位置
    else if(function==1) simple_inkDrop(center.x, center.y, dt2/2);
    else if(function==2) {}
    pressT2=millis(); //這裡同時更新時間, 以便算出正確的墨量
  }
  text(functionText[function], 0, 0);
}
String [] functionText={"Ink Drop", "Ink Drop Simple", "Tine Line Pattern"};
int function=0; //0: Ink Drop, 1: Ink Drop Simple, 2: Tine Line Pattern
//要思考一下使用者介面: keyboard切換功能, mouse 要依 function不同而做對應動作
//draw()裡的 mousePressed 則是只用來滴墨用,因為它太頻繁呼叫了
void keyPressed(){ //利用鍵盤來切換功能
  if(key=='0') function=0; //Ink Drop
  if(key=='1') function=1; //Ink Drop Simple
  if(key=='2'){
    function=2; //Tine Line Pattern
    curves2=new ArrayList<ArrayList<PVector>>(); //backup curves to curves2
    for( ArrayList<PVector> curve : curves ){
      ArrayList<PVector> now = new ArrayList<PVector>();
      for( PVector pt : curve ){
        now.add(new PVector(pt.x, pt.y));
      }
      curves2.add(now);
    }
  }
}
void mousePressed(){ //按下去時, 建新的 curve, 同時暫時把圓心放在裡面
  if(function==0 || function==1 || function==2){
    ArrayList<PVector> curve = new ArrayList<PVector>();
    curve.add( new PVector(mouseX,mouseY) );
    curves.add(curve); //暫時把圓心放在裡面
    pressT2=pressT=millis(); //記錄按下去的時間
  }
}
void mouseDragged(){
  if(function==2){
    PVector A = curves.get(curves.size()-1).get(0);
    PVector L = new PVector(mouseX-A.x, mouseY-A.y);
    eq2_tineLinePattern(A, L, L.mag(), 8); //跑太慢, 會當掉
  }
}
void mouseReleased(){
  if(function==0 || function==1){ //滴墨放開mouse時, 把整個圓的圓周上的頂點, 逐一加入 curve 裡, 完成資料結構
    float dt=sqrt((millis()-pressT)); //繪圖時,算出時間差dt=現在-pressT, 把它開根號,當成直徑
    ArrayList<PVector> curve = curves.get(curves.size()-1); //最出 curves 的最後一條 curve, 裡面只存圓心座標
    PVector center = curve.get(0); //之前把按下去的點存在這裡
    curve.remove(0); //把原本的圓心刪掉, 下面準備加入圓周上的點
    for(float angle=0; angle<PI*2; angle+=2*PI/(dt*PI)){ //這裡非常密集,讓圓周上頂點距離很短,相鄰1 pixel
      PVector pt = new PVector(center.x+dt/2*cos(angle), center.y+dt/2*sin(angle)); //圓周上頂點用 sin() cos() 算出來
      curve.add(pt); //所以每個加進去的頂點, 都在圓周上, 而且相鄰 1 pixel
    }
  }else if(function==2){ //tine line 時, 可以刪除最新的curve
    //ask Yes or No 
    //remove all curves2, and accept curves and curves
    curves.remove(curves.size()-1);
  }
}
//論文裡提到, 滴墨有2種狀況: 一種要變形(慢), 一種不變形(快)
void eq1_inkDrop(float cx, float cy, float r){ //滴墨的變形公式 equation 1
  for( ArrayList<PVector> curve : curves ){
    if(curve.size()<=1) continue; //避開(最後一個curve) 圓心的點, 避免公式出錯
    for( PVector pt : curve ){
      float dx=pt.x-cx, dy=pt.y-cy; //公式裡面, 要計算 P-C 向量
      float scale = sqrt(1+r*r/(dx*dx+dy*dy)); //公式裡面的移動比例
      pt.x = cx + (pt.x-cx)*scale; //依移動比例, 改變現有頂點的位置
      pt.y = cy + (pt.y-cy)*scale; //依移動比例, 改變現有頂點的位置
    }
  }
}
void simple_inkDrop(float cx, float cy, float r){
  //如Fig. 1(f) 所示, 不使用公式(1)變型, just simple ink drop 
}
void eq2_tineLinePattern(PVector A, PVector L, float alpha, float lambda){
  //這裡使用公式(2)的作法
  PVector M = new PVector(L.x, L.y).normalize();
  PVector N = new PVector(L.y, -L.x).normalize();

  stroke(255,0,0);
  line(A.x, A.y,  A.x+L.x, A.y+L.y);
  stroke(0);
  
  //for( ArrayList<PVector> curve : curves ){
  for(int i=0; i<curves.size(); i++){
    ArrayList<PVector> curve = curves.get(i);
    if(curve.size()<=1) continue; //避開(最後一個curve) 圓心的點, 避免公式出錯
    ArrayList<PVector> curve2 = curves2.get(i); //做完上面的檢查, 才能取用 curves2的這個 curve2 (因為新的 curves那一條還沒copy,會當機) 
    //for( PVector pt : curve ){
    for(int j=0; j<curve.size(); j++){
      PVector pt=curve.get(j);
      PVector pt2=curve2.get(j);
      
      float d = abs( PVector.sub(pt,A).dot(N) );
      float s=(alpha*lambda)/(d+lambda);
      pt.x = pt2.x + s*M.x;
      pt.y = pt2.y + s*M.y;
    }
  }
}
```

More Details (更多細節)
-----------------------

1. 目前的作法, 是在選擇 function=2 也就是 tine line 時, 馬上 copy 整個 curves。
接下來 mouseDragged 時, 會以 mousePressed的(mouseX,mouseY)為基準, 再以 mouseDragged的距離為 alpha, 來進行 tine line效果。