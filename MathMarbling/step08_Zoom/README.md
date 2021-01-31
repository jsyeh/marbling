Math Marbling Step 08
=====================

第08步要做的是 Zoom功能, 也就是「局部放大功能」, 這樣, 便能看到前面的 vector graphics 的效果。
mousePressed 時, 點擊的位置會秀出一個小圈圈, 是用來Zoom的中心點 (zoomX, zoomY)。
所以 draw()函式中, 會有 `translate(-zoomX, -zoomY);` 就是把 zoom的中心點,移到 (0,0) 的位置, 以便縮放。
最後, 再把整個縮放過後的圖, 放在當初 mouseX, mouseY 所在的位置, 也就是 (zoomX2, zoomY2), 在程式碼中,
便是 `translate(zoomX2, zoomY2);`

而這個 zoomX, zoomY 的計算方式, 是照著上面的作法, 倒過來推算出來的。


Processing Code
---------------

在 draw() 的前面, 加上 zoom 的功能
```Processing
void draw(){
  ...
  if(bZoom){
    translate(zoomX2, zoomY2);
    scale(zoomScale);
    translate(-zoomX, -zoomY);
  }
  ...
  if(bZoom) ellipse(zoomX,zoomY, 5,5); //用來 zoom 的中心點
}
```

在mousePressed() 裡面, 加上 zoomX, zoomY, zoomScale 的計算, 並更新 zoomX2, zoomY2
```Processing
void mousePressed(){
  ...
  if(function==6){ //function 6 zoom (下一個要做 move)
    zoomX=(mouseX-zoomX2)/zoomScale+zoomX;//正向公式draw: translate(zoomX2); scale(); translate(-zoomX), 即 showX=(realX-zoomX)*zoomScale+zoomX2 
    zoomY=(mouseY-zoomY2)/zoomScale+zoomY;//反向的公式就是 realX=(showX-zoomX2)*zoomScale+zoomX
    zoomX2=mouseX;
    zoomY2=mouseY;
    bZoom=true;
    if(mouseButton==LEFT) zoomScale*=1.2;
    if(mouseButton==RIGHT) zoomScale/=1.2;
    if(zoomScale<=1){
      zoomScale=1; zoomX=0; zoomY=0; zoomX2=0; zoomY2=0;
      bZoom=false;
    }
  }
}

```

More Details (更多細節)
-----------------------

1. 目前的作法, 是在選擇 function=6 之後, 每次 mousePressed 時, 會看 mouseButton 來決定是 Zoom-In 還是 Zoom-Out

2. 使用keyboard切換function功能:  
  - function=0: 使用滴墨的公式(1)/是否切換deformation
  - function=1: 簡單滴墨
  - function=2: 使用拉線的公式(2)
  - function=3: 使用 sine wave 的公式(3)
  - function=4: 使用 Circular 旋轉的公式(4)
  - function=5: 使用 Vortex 旋渦效果
  - function=8: Zooming 功能
