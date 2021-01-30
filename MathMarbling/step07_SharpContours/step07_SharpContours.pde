import java.util.LinkedList;
import java.util.ListIterator;
LinkedList<LinkedList<PVector>> curves; //許多頂點構成curve, 許多curve構成curves
LinkedList<LinkedList<PVector>> curves2=null; //為了 Undo 而先backup到curves2, 讓curves暫秀出演練結果, 供 tine line使用
LinkedList<LinkedList<PVector>> curvesBackup=null;
int pressT, pressT2; //pressT: 按下mouse時的時間, pressT2: 滴墨時前一次位移的時間, 之後可合併
//boolean bSimpleInkDrop=false;//切換簡單滴墨(快) or 公式(1)滴墨(慢,deformation)
void setup(){
  size(512,512);
  curves = new LinkedList<LinkedList<PVector>>();
  textAlign(LEFT, TOP);
  textSize(32);
  addRects(); //TODO: for debugging
}
void addRects(){ //TODO: for debugging
  for(int y=0; y<512; y+=16){
    LinkedList<PVector> now = new LinkedList<PVector>();
    for(int x=0;x<512; x+=8){
      now.add(new PVector(x, y));
    }
    for(int x=512;x>=0; x-=8){
      now.add(new PVector(x, y+8));
    }    
    curves.add(now);
  }
}
void draw(){
  background(0); //黑色的背景
  fill(255);
  for( LinkedList<PVector> curve : curves ){ //這裡程式較無效率
    beginShape(); //逐一從 curves 裡, 取出 圓形的 curve 來畫 
    for( PVector pt : curve ){ //從圓形的 curve 裡, 取出 頂點pt
      vertex(pt.x, pt.y);
    }
    endShape();
//    print(curve.size()+" "); //這裡印出 curve 裡的頂點數量
  } //上面是完整的資料結構
//  println("curves.size():",curves.size()); //這裡印出 curves 的數量, 發現越來越慢, 因為頂點越來越多
//comments for debugging
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
String [] functionText={"Ink Drop", "Ink Drop Simple", "Tine Line Pattern", "Wavy Pattern", "Circular Tine Line Pattern", "Vortex Pattern"};
int function=0; //0: Ink Drop, 1: Ink Drop Simple, 2: Tine Line Pattern, 3: Wavy Pattern, 4: Circular Tine Line Pattern, 5: Vortex Pattern
//要思考一下使用者介面: keyboard切換功能, mouse 要依 function不同而做對應動作
//draw()裡的 mousePressed 則是只用來滴墨用,因為它太頻繁呼叫了
void keyPressed(){ //利用鍵盤來切換功能
  if(key=='0') function=0; //Ink Drop
  if(key=='1') function=1; //Ink Drop Simple
  if(key=='2') function=2; //Tine Line Pattern
  if(key=='3') function=3; //Wavy Pattern
  if(key=='4') function=4; //Circular Tine Line Pattern
  if(key=='5') function=5; //Vortex Pattern
  if(key==ESC && (function==2||function==3)){//Undo (for Tine Line Pattern or Wavy Pattern)
    key=0;
    restoreFromCurves2();//TODO: 應該要加一下警告介面, 確認後再 restore比較好
  }else if(key==ESC && (function==4||function==5)){
    key=0;
    restoreFromCurvesBackup();
  }
}
void restoreFromCurvesBackup(){
  //if(curvesBackup!=null && curves!=null){//兩個會不一樣大。這樣不能直接 one-by-one resture
  //  ListIterator li=curves.listIterator(0); //要改成: 把 curves 全部清空, 接著再 copy 給 curves
  //}
  if(curves!=null){
    ListIterator li = curves.listIterator();
    while(li.hasNext()){
      LinkedList<PVector> curve = (LinkedList<PVector>)li.next();
      ListIterator lili=curve.listIterator();
      while(lili.hasNext()){
        lili.next();
        lili.remove();
      }
      li.remove();
    }
  }else curves=new LinkedList<LinkedList<PVector>>();
  
  //backup curves to curves2
  for( LinkedList<PVector> curve : curvesBackup ){
    LinkedList<PVector> now = new LinkedList<PVector>();
    for( PVector pt : curve ){
      now.add(new PVector(pt.x, pt.y));
    }
    curves.add(now);
  }
}
void restoreFromCurves2(){
  if(curves2!=null && curves!=null){
    ListIterator li=curves.listIterator(0);
    ListIterator li2=curves2.listIterator(0);
    while(li2.hasNext()){
      LinkedList<PVector> curve2 = (LinkedList<PVector>)li2.next();
      LinkedList<PVector> curve = (LinkedList<PVector>)li.next();
      ListIterator lili=curve.listIterator();
      ListIterator lili2=curve2.listIterator();
      while(lili2.hasNext()){
        PVector pt2=(PVector)lili2.next();//還沒確認, 待測
        PVector pt =(PVector)lili.next();
        pt.x=pt2.x;
        pt.y=pt2.y;
      }
    }
  }
}
void backupToCurvesBackup(){
  if(curvesBackup!=null){
    ListIterator li = curvesBackup.listIterator();
    while(li.hasNext()){
      LinkedList<PVector> curve = (LinkedList<PVector>)li.next();
      ListIterator lili=curve.listIterator();
      while(lili.hasNext()){
        lili.next();
        lili.remove();
      }
      li.remove();
    }
  }else curvesBackup=new LinkedList<LinkedList<PVector>>();
  
  //backup curves to curves2
  for( LinkedList<PVector> curve : curves ){
    LinkedList<PVector> now = new LinkedList<PVector>();
    for( PVector pt : curve ){
      now.add(new PVector(pt.x, pt.y));
    }
    curvesBackup.add(now);
  }
}
void backupToCurves2(){
  //delete curves2 first //可能會很慢
  if(curves2!=null){
    ListIterator li = curves2.listIterator();
    while(li.hasNext()){
      LinkedList<PVector> curve = (LinkedList<PVector>)li.next();
      ListIterator lili=curve.listIterator();
      while(lili.hasNext()){
        lili.next();
        lili.remove();
      }
      li.remove();
    }
  }else curves2=new LinkedList<LinkedList<PVector>>();
  
  //backup curves to curves2
  for( LinkedList<PVector> curve : curves ){
    LinkedList<PVector> now = new LinkedList<PVector>();
    for( PVector pt : curve ){
      now.add(new PVector(pt.x, pt.y));
    }
    curves2.add(now);
  }
}
void mousePressed(){ //按下去時, 建新的 curve, 同時暫時把圓心放在裡面
  if(function==0 || function==1 || function==2 || function==3 || function==4 || function==5){
    LinkedList<PVector> curve = new LinkedList<PVector>();
    curve.add( new PVector(mouseX,mouseY) );
    curves.add(curve); //暫時把圓心放在裡面
    pressT2=pressT=millis(); //記錄按下去的時間
  }
  if(function==2 || function==3 || function==4 || function==5){
    backupToCurves2();
  }
  if(function==4 || function==5){
    backupToCurvesBackup();
  }
  if(function==4 || function==5) alpha4=0; //function 4 & function 5 共用 alpha4
}
float alpha4=0; //alpha for function 4 & function 5
void mouseDragged(){
  if(function==2){
    PVector A = curves.get(curves.size()-1).get(0);
    PVector L = new PVector(mouseX-A.x, mouseY-A.y);
    eq2_tineLinePattern(A, L, L.mag(), 8); //跑太慢, 會當掉
  }else if(function==3){
    PVector C = curves.get(curves.size()-1).get(0);
    PVector L = new PVector(mouseX-C.x, mouseY-C.y);
    float amplitude=L.mag();
    float wavelength=0.03;//0.1;//TODO: 要畫出梳子的大量平行線, TODO: 要思考 cos(wavelength*v+phase) 的大小關係,好像又有pixels距離除法關係
    //查完 Wikipedia, 我覺得公式中的 wavelength 應該改成 frequence, 即 1/wavelength, 公式應為 cos(2*PI*freq*t+phase)
    PVector N=new PVector(L.y, -L.x).normalize();//.mult(2*PI*1/wavelength);//垂直wavelength方向
    float ratio = C.dot(N)%( 2*PI*1/wavelength ) /(2*PI*1/wavelength);
    float phase = -ratio*2*PI+PI/2;
    //println(ratio, phase);
    float angle = atan2(L.y, L.x);
    eq3_wavyPattern(amplitude, wavelength, phase, angle);//要擺好梳子的控制線, 讓使用者對應效果。
    
    N.mult(2*PI*1/wavelength);
    stroke(255,0,0);
    for(float t=-10; t<=10; t++){
      PVector N2=PVector.mult(N,t).add(C);
      line(N2.x, N2.y,  N2.x+L.x, N2.y+L.y);//畫出梳子的大量平行線,平行對好mouseDragged線
      //line(C.x, C.y,  C.x+L.x, C.y+L.y);//(OK) 要畫出梳子的大量平行線
    }
    stroke(0);//其實是以左上角(0,0)為, 接下來由 angle & wavelength 算出 phase     
  }else if(function==4){
    PVector C = curves.get(curves.size()-1).get(0);
    PVector L = new PVector(mouseX-C.x, mouseY-C.y);
    float r = L.mag();
    alpha4 += diffAngle(C, pmouseX,pmouseY, mouseX,mouseY);//我想到 alpha可以與路徑的張角有關
    //println(alpha4);
    float lambda=8;
    eq4_circularTineLine(C, r, alpha4, lambda);
    if(smoothSharp()>10) backupToCurves2();//will be very very slow
    
    stroke(255,0,0);
    ellipse(C.x, C.y, r*2, r*2); //畫出對應的圓
    stroke(0);
  }else if(function==5){
    PVector C = curves.get(curves.size()-1).get(0);
    PVector L = new PVector(mouseX-C.x, mouseY-C.y);
    float r = L.mag();
    alpha4 += r*diffAngle(C, pmouseX,pmouseY, mouseX,mouseY);//我想到 alpha可以與路徑的張角有關, 放大r倍,讓效果顯著
    alpha4 += (mouseX-pmouseX);//在滑鼠上下移動、左右移動時, 也應該有些旋轉的回饋
    alpha4 += (mouseY-pmouseY);
    //println(alpha4);
    float lambda=8;
    eq5_vortexPattern(C, alpha4, lambda);
    if(smoothSharp()>5) backupToCurves2();//will be very very slow
    
    stroke(255,0,0);  noFill();
    ellipse(C.x, C.y, alpha4,alpha4); //畫出對應的圓
    stroke(0);
  }
}
float smoothSharp(){//return the max distance
  int count=0;
  float maxDist=0;
  ListIterator li = curves.listIterator(0);
  ListIterator li2 = curves2.listIterator(0);
  while(li.hasNext()){
    LinkedList<PVector> curve = (LinkedList<PVector>)li.next();
    LinkedList<PVector> curve2 = (LinkedList<PVector>)li2.next();
    ListIterator lili = curve.listIterator();
    ListIterator lili2 = curve2.listIterator();
    PVector pt11=(PVector)lili.next();
    PVector pt12=null;
    PVector pt21=(PVector)lili2.next();
    PVector pt22=null;
    while(lili.hasNext()){
      count++;
      boolean bFar=false;
      pt12=(PVector)lili.next();
      lili.previous();//這個回跳, 是為了下一行 add()能在正確的位置插入
      float d=dist(pt12.x, pt12.y, pt11.x, pt11.y);
      if( d>maxDist) maxDist=d;
      if( d>5 ) bFar=true;
      if(bFar){
        lili.add( new PVector( (pt11.x+pt12.x)/2, (pt11.y+pt12.y)/2) );
      }
      pt11=(PVector)lili.next();

      pt22=(PVector)lili2.next();
      lili2.previous();//這個回跳, 是為了下一行 add()能在正確的位置插入
      if(bFar){
        lili2.add( new PVector( (pt21.x+pt22.x)/2, (pt21.y+pt22.y)/2) );
      }
      pt21=(PVector)lili2.next();
    }
  }
  println("count:",count);
  return maxDist;
}
float diffAngle(PVector C, float x1, float y1, float x2, float y2){
  if(dist(C.x,C.y, x1,y1)<10) return 0; //如果離圓心太近的移動,先不算數
  float angle1=atan2(y1-C.y, x1-C.x);
  float angle2=atan2(y2-C.y, x2-C.x);
  float ans=-degrees(angle2-angle1);
  if(ans>180) ans-=360;//遇到 +179 - -179 的邊界值時, 調整出合理的值
  if(ans<-180) ans+=360;//遇到 -179 - +179 的邊界值時, 調整出合理的值
  return ans;
}
void mouseReleased(){
  if(function==0 || function==1){ //滴墨放開mouse時, 把整個圓的圓周上的頂點, 逐一加入 curve 裡, 完成資料結構
    float dt=sqrt((millis()-pressT)); //繪圖時,算出時間差dt=現在-pressT, 把它開根號,當成直徑
    LinkedList<PVector> curve = curves.get(curves.size()-1);
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
    curves2.remove(curves2.size()-1);
  }//TODO: 做完時, 記得要重新內插
}
//論文裡提到, 滴墨有2種狀況: 一種要變形(慢), 一種不變形(快)
void eq1_inkDrop(float cx, float cy, float r){ //滴墨的變形公式 equation 1
  for( LinkedList<PVector> curve : curves ){
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
  
  ListIterator li = curves.listIterator();
  ListIterator li2 = curves2.listIterator();
  while(li.hasNext()){
    LinkedList<PVector> curve = (LinkedList<PVector>)li.next();
    if(curve.size()<=1) continue; //避開(最後一個curve) 圓心的點, 避免公式出錯
    LinkedList<PVector> curve2 = (LinkedList<PVector>)li2.next();

    ListIterator lili = curve.listIterator();
    ListIterator lili2 = curve2.listIterator();
    while(lili2.hasNext()){
      PVector pt = (PVector)lili.next();
      PVector pt2 = (PVector)lili2.next();
      
      float d = abs( PVector.sub(pt,A).dot(N) );
      float s=(alpha*lambda)/(d+lambda);
      pt.x = pt2.x + s*M.x;
      pt.y = pt2.y + s*M.y;
    }
  }
}
float f(float v, float Amplitude, float wavelength, float phase){
  return Amplitude*sin(wavelength*v+phase);
}
void eq3_wavyPattern(float Amplitude, float wavelength, float phase, float angle){ //波型公式 equation 3
  ListIterator li = curves.listIterator();
  ListIterator li2 = curves2.listIterator();
  while(li.hasNext()){
    LinkedList<PVector> curve = (LinkedList<PVector>)li.next();
    if(curve.size()<=1) continue; //避開(最後一個curve) 圓心的點, 避免公式出錯
    LinkedList<PVector> curve2 = (LinkedList<PVector>)li2.next();

    ListIterator lili = curve.listIterator();
    ListIterator lili2 = curve2.listIterator();
    while(lili2.hasNext()){
      PVector pt = (PVector)lili.next();
      PVector pt2 = (PVector)lili2.next();
      float v = pt2.x*sin(angle) -pt2.y*cos(angle);
      float s = f(v, Amplitude, wavelength, phase);
      pt.x = pt2.x + s * cos(angle);
      pt.y = pt2.y + s * sin(angle);
    }
  }
}
void eq4_circularTineLine(PVector C, float r, float alpha, float lambda){
  ListIterator li = curves.listIterator();
  ListIterator li2 = curves2.listIterator();
  while(li.hasNext()){
    LinkedList<PVector> curve = (LinkedList<PVector>)li.next();
    if(curve.size()<=1) continue; //避開(最後一個curve) 圓心的點, 避免公式出錯
    LinkedList<PVector> curve2 = (LinkedList<PVector>)li2.next();
    
    ListIterator lili = curve.listIterator();
    ListIterator lili2 = curve2.listIterator();
    while(lili2.hasNext()){
      PVector pt = (PVector)lili.next();
      PVector pt2 = (PVector)lili2.next();

      PVector PC = PVector.sub(pt,C);
      float len=PC.mag();
      float d = abs(len-r);
      float l = alpha*lambda/(d+lambda);
      float theta = l/(len);
      pt.x = C.x + (pt2.x-C.x)*cos(theta) + (pt2.y-C.y)*sin(theta);
      pt.y = C.y + (pt2.x-C.x)*-sin(theta) + (pt2.y-C.y)*cos(theta);
    }
  }  
}
void eq5_vortexPattern(PVector C, float alpha, float lambda){
  ListIterator li = curves.listIterator();
  ListIterator li2 = curves2.listIterator();
  while(li.hasNext()){
    LinkedList<PVector> curve = (LinkedList<PVector>)li.next();
    if(curve.size()<=1) continue; //避開(最後一個curve) 圓心的點, 避免公式出錯
    LinkedList<PVector> curve2 = (LinkedList<PVector>)li2.next();
    
    ListIterator lili = curve.listIterator();
    ListIterator lili2 = curve2.listIterator();
    while(lili2.hasNext()){
      PVector pt = (PVector)lili.next();
      PVector pt2 = (PVector)lili2.next();
      
      PVector PC = PVector.sub(pt,C);
      float d=PC.mag();
      float l = alpha*lambda/(d+lambda);
      float theta = l/(d);
      pt.x = C.x + (pt2.x-C.x)*cos(theta) + (pt2.y-C.y)*sin(theta);
      pt.y = C.y + (pt2.x-C.x)*-sin(theta) + (pt2.y-C.y)*cos(theta);
    }
  }  
}
