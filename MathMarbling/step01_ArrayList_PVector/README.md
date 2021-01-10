Math Marbling Step 01
=====================

ArrayList PVector
-----------------

在這個版本裡, 開始使用 Java 的 ```ArrayList``` 資料結構, 配合 Processing 的 ```PVector``` 來建立「水畫」需要的資料結構。在前一版 step00 直接使用 ```ellipse()``` 來畫, 而在這個版本, 則是使用 ```beginShape()``` 及 ```endShape()``` 配合 ```vertex()``` 來畫。

在這個版本中, 使用了進階的 for迴圈 ```for(PVector pt : curve)``` 及更大圈的資料結構。在繪圖時, 則是經常重覆繪製 (依照2層 ```ArrayList``` 來繪製), 會比較耗費時間。

在按下mouse的時候, 先把 mouseX,mouseY 當成圓心存起來, 同時暫時以 ```ellipse()``` 來畫這個長大中的圓。

在放開mouse的時候, 將現在這個圓的圓周上的頂點 密集的建立好 (希望頂點距離為 1 pixel)

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
```

More Detail (額外講解)
--------------------
關於 ```ArrayList<ArrayList<PVector> curves``` 我們從小到大, 慢慢介紹。

- ```PVector``` 是 Processing 的向量class, 這個(小)資料結構裡面, 有3個分量 x, y, z 
  - 所以 ```PVector pt = new PVector( 10, 20, 30 );``` 會建出裡面有 (10, 20, 30) 的向量
  - 也可以把向量, 看成是頂點的位置
- ```ArrayList<PVector>``` 是利用 Java 的 ArrayList (大)資料結構, 裡面可以放許多(小)資料結構 PVector
  - 所以 ```ArrayList<PVector> curve = new ArrayList<PVector>();``` 會建立一個空的 ArrayList, 裡面將可以放你用 PVector 建立的點
  - ```curve.add( new PVector(10, 20) );``` 會把一個頂點 (10, 20) 加到 curve 裡面去
  - ```curve.get( 0 )``` 會取出 curve 裡面第 0 個頂點
  - ```curve.remove( 0 )``` 會刪除 curve 裡面第 0 個頂點 (會較沒率, 因為後面的點要逐一移過來補刪除後的漏洞)
- ```ArrayList<ArrayList<PVector>>``` 是 2層的 ArrayList 資料結構
  - 所以 ```ArrayList<ArrayList<PVector>> curves = new ArrayList<ArrayList<PVector>>();``` 會建立 2層的 ArrayList, 裡面將可以放很多條 curve, 每個 curve 裡有很多的頂點
  - ```curves.add( curve );``` 可以把一條 curve 加到 curves 裡面
  - ```curves.get( 0 )``` 可以取出 curves 裡面的第一條 curve
  - ```curves.get( curves.size()-1 )``` 可以取出 curves 裡面的最後一條 curve

關於 for(迴圈) 與 ArrayList 的配合
- ArrayList 是 Java 特別的資料結構, 又叫 container, 裡面可以放其他的資料結構 or 物件
- for(迴圈) 特別對這類的資料結構, 設計新的語法
- 下方是簡單的例子。而程式碼 void draw() 裡面, 也用這個技巧, 來畫出 curves 裡, 每段 curve 上面的頂點

```Processing
ArrayList<PVector> curve = new ArrayList<PVector>(); //宣告 curve, 它是個 ArrayList 資料結構, 裡面有許多 PVector
curve.add( new PVector(100, 100) ); //add 第1個頂點
curve.add( new PVector(200, 100) ); //add 第2個頂點
curve.add( new PVector(300, 100) ); //add 第3個頂點
for( PVector pt : curve ){ //這種 for迴圈的寫法, 可以讓 pt 依序會是 curve 裡面的每一個頂點
  //你便可以在迴圈裡使用 pt 這個頂點
}
```

關於 mouseReleased() 裡, 如何建立 ArrayList<PVector> curve ? 
- for迴圈裡, 每次增加的角度 2 * PI / (dt * PI) 不容易被理解 --- 它的意思是, 這個圓的周長是 2 * PI * 半徑, 也就是 dt * PI, 因為 dt 是直徑。所以如果希望周長的頂點間相鄰 1 pixel, 就要把 2 * PI 的角度, 除以圓周長 (dt * PI), 也就是每個頂點間的角度差 2 * PI / (dt * PI)。
```Processing
for(float angle=0; angle<PI*2; angle+=2*PI/(dt*PI)){
```

```Processing
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
```
