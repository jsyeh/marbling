Math Marbling Step 07
=====================

在資料結構的部分, ArrayList 的普通 get(i) 差不多, LinkedList 的 for(enhanced loop) 也夠快。

注意: 不要在 ArrayList 插入, 不要在 LinkedList 做 get(i)

所以最後, 我把全部的 ArrayList 都先改成 LinkedList 並確認沒錯/可以執行。
接下來, 寫出 smoothSharp() 讓 function=4 及 function=5 都會去呼叫。

現在的狀況, 會爆增頂點數量。所以會越來越慢。

TODO: 將要再挑戰 「curves 先變 curves2 及 curvesBackup」 接下來只要有 bFar 太遠時, 就把 「curves 再變 curves2」希望能減少亂拉的現象。
最後如果 ESC放棄時, 把 「curvesBackup 改回 curves」

Sharp Contours
--------------


因為需要重覆審視出來的結果, 所以必須要有 Undo 的能力。
因此, curves 裡的頂點不應該直接修改。應該要可以演練後, 再決定是否要確定。

Processing Code
---------------

```Processing
```

More Details (更多細節)
-----------------------

1. 目前的作法, 是在選擇 function=5 之後, 每次 mousePressed 時, 馬上 copy 整個 curves 到 curves2。

2. 使用keyboard切換function功能:  
  - function=0: 使用滴墨的公式(1)/是否切換deformation
  - function=1: 簡單滴墨
  - function=2: 使用拉線的公式(2)
  - function=3: 使用 sine wave 的公式(3)
  - function=4: 使用 Circular 旋轉的公式(4)
  - function=5: 使用 Vortex 旋渦效果
  - 在 function=5時, mousePressed 需要備份 curves 到 curves2, 在 mouseRelease
  - 在 function=5時, 每次 mousePressed 備份 curves 到 curves2。mouseReleased 時, 暫一個段落。
  - 如果 Vortex Pattern Function 的結果不滿意, 可以按 ESC鍵, 回到備份的 curves2 (但ESC在其他功能會關閉, 需要保護一下)
  - TODO: mouseReleased 時應詢問是否套用新 curve or 還原成舊 curves2
