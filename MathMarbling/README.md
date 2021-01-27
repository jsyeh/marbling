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
  - 可用 bSimpleInkDrop 切換是否使用滴墨的公式(1)/是否切換deformation
- Step03_TineLineFunction
  - 實作 Mathematical Marbling 3.1.2 TineLineFunction 拉線效果 公式(2)
  - function=0: 使用滴墨的公式(1)/是否切換deformation, function=2: 簡單滴墨, function=2: 使用拉線的公式(2)
  - 使用keyboard切換function功能
  - 在 function=2時, 每次 mousePressed 時 備份 curves, mouseReleased 時, 暫一個段落。
  - 如果 TineLineFunction 的結果不滿意, 可以按 ESC鍵, 回到備份的 curves2 (但ESC在其他功能會關閉, 需要保護一下)
- Step04_WavyFunction
  - 實作 Mathematical Marbling 3.1.3 WavePatternFunction Sine波的公式(3)
  - keyboard 及 mouse 的效果, 與 step03 類似
  - 有 UNDO 能力
- Step05_CircularTineLine
  - 實作 Mathematical Marbling 3.1.4 CircularTineLineFunction 圓形拉動(旋轉)公式(4)
  - mousePressed時會決定圓心, mouseDragged時會有虛擬的圓, 讓人可以看到參考半徑r。如果mouseDragged是逆時針繞時, 就逆時針增加 alpha; 如果順時針繞時, 就順時針減少 alpha
  - 有 UNDO 能力
- Step05_VortexPatternFunction
  - 實作 Mathematical Marbling 3.1.5 旋渦效果(Vortex Pattern Function) 
  - 程式模仿 step05_CircularTineLine
  - mousePressed時會決定圓心, mouseDragged時會有虛擬的圓心。轉的效果放大一些, 同時讓 mouseDragged 單純左右、上下拖曳 也會有部分轉動的效果。

- TODO: 3.2. SharpCorner 公式(5) 因 Vortex 效果時, 發現中間有錯亂的狀況, 所以需要 ShaprCorner, 新增更多的 curve boundary 頂點 (pixel-wise)
- TODO: 3.3. VectorImageOutput
- TODO: (推薦色)調色盤選色
- TODO: 多解析度問題(Surface Pro會太小/太慢)


References (參考文獻)
---------------------
- https://people.csail.mit.edu/jaffer/Marbling/
- Lu, S.; Jaffer, A.; Jin, X.; Zhao, H.; Mao, X.; , "Mathematical Marbling," IEEE Computer Graphics and Applications, Nov.-Dec. 2012 (vol. 32 no. 6) pp 26-35.
