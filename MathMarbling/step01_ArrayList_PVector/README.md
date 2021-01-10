Math Marbling Step 01
=====================

ArrayList PVector
-----------------

在這個版本裡, 開始使用 Java 的 ```ArrayList``` 資料結構, 配合 Processing 的 ```PVector``` 來建立水畫需要的資料結構。在前一版 step00 直接使用 ```ellipse()``` 來畫, 而在這個版本, 則是使用 ```beginShape()``` 及 ```endShape()``` 配合 ```vertex()``` 來畫。

在這個版本中, 使用了進階的 for迴圈 ```for(PVector pt : curve)``` 及更大圈的資料結構。在繪圖時, 則是經常重覆繪製 (依照2層 ```ArrayList``` 來繪製), 會比較耗費時間。

在按下mouse的時候, 先把 mouseX,mouseY 當成圓心存起來, 同時暫時以 ```ellipse()``` 來畫這個長大中的圓。

在放開mouse的時候, 將現在這個圓的圓周上的頂點 密集的建立好 (希望頂點距離為 1 pixel)
其中for迴圈裡, 每次增加的角度 2 * PI / (dt * PI) 不容易被理解 --- 它的意思是, 這個圓的周長是 2 * PI * 半徑, 也就是 dt * PI, 因為 dt 是直徑。所以如果周長的頂點希望相鄰 1 pixel, 就要把 2*PI 的角度, 除以圓周長 (dt * PI), 也就是 2 * PI / (dt * PI)。

```Processing
for(float angle=0; angle<PI*2; angle+=2*PI/(dt*PI)){
```


Processing Code
---------------

```Processing
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
      stroke(255,0,0); ellipse(pt.x, pt.y, 1,1);
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
  ArrayList<PVector> curve = curves.get(curves.size()-1);
  PVector center = curve.get(0); //之前把按下去的點存在這裡
  curve.remove(0); //把原本的圓心刪掉, 下面準備加入圓周上的點
  for(float angle=0; angle<PI*2; angle+=2*PI/(dt*PI)){ //這裡非常密集,讓圓周上頂點距離很短,相鄰1 pixel
    PVector pt = new PVector(center.x+dt/2*cos(angle), center.y+dt/2*sin(angle)); //圓周上頂點用 sin() cos() 算出來
    curve.add(pt);
  }
}
```