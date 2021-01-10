PVector center;//mouse按下時的圓心位置
int pressT;//按下mouse時的時間
void setup(){
  size(512,512);
  background(0);//只有在最前面設定黑色背景
}
void draw(){
  if(mousePressed){
    int dt=(millis()-pressT)/10;//繪圖時,算出時間差dt=現在-pressT, 它的1/10當成直徑
    ellipse(center.x, center.y, dt, dt);//以直徑來畫出圓,模擬滴墨
  }
}
void mousePressed(){
  center = new PVector(mouseX, mouseY);//每次mouse按下去時,會固定1個圓心
  pressT = millis();//並且把按下去的時間 pressT 記錄下來
}
