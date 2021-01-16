Math Marbling (數學做水畫)
==========================

Intoduction (簡介)
------------------
這個目錄裡, 介紹如何一步步把 Jaffer 在他的網頁裡介紹的 Mathematical Marbling 數學水畫做出來。在這裡, 我是使用 Processing 來一步步實作。

Steps (步驟)
------------
首先先建立程式的框架, 使用 ArrayList<PVector> 來建立很長的資料結構(裡面有許多邊界的點), 之後便可以用這個資料結構, 來描繪出墨水的邊界。

- Step00_ManyEllipse 
  - 利用許多重覆的白色圓形, 疊在在黑色畫布上, 還沒任何資料結構
- Step01_ArrayList_PVector
  - 修改資料結構, 利用兩層 ArrayList 做出 Step00 的效果
- Step02_DropInkFunction
  - 實作 Mathematical Marbling 3.1.1 InkDropFunction 滴墨效果 公式(1) 

- TODO: 圖(1)切換deformation、
- TODO: 3.1.2. TineLineFunction 公式(2) 
- TODO: 3.1.3. WavePatternFunction 公式(3) 
- TODO: 3.1.4. CircularTineLineFunction 公式(4) 
- TODO: 3.1.5. VortexPatternFunction
- TODO: 3.2. SharpCorner 公式(5)
- TODO: 3.3. VectorImageOutput 
- TODO: (推薦色)調色盤選色
- TODO: 多解析度問題(Surface Pro會太小/太慢)


References (參考文獻)
---------------------
- https://people.csail.mit.edu/jaffer/Marbling/
- Lu, S.; Jaffer, A.; Jin, X.; Zhao, H.; Mao, X.; , "Mathematical Marbling," IEEE Computer Graphics and Applications, Nov.-Dec. 2012 (vol. 32 no. 6) pp 26-35.
