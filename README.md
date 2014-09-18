jquery.appear.js
=========================
スクロールでイベント発火するjQueryプラグイン。1.10系で制作。

How to use
-----------------------
    // 単純なアニメーションの場合
    $('.appear-top').appearAnimate({
      // 変化前のスタイルを記述
      opacity: 0,
      top: -10,
      position: 'relative'
    },{
      // 変化後のスタイルを記述
      opacity: 1,
      top: 0
    },{
    　// アニメーションのオプションを記述
    　duration: 600,
    　easing: 'easeOutQuint'
    });
 
    // 自分で挙動を細かく定義したい場合
    $('.appear-top').appearFunction(function($this){
      // 要素の位置までスクロールされる前の記述
      $this.hide();
    }, function($this){
      // 要素の位置までスクロールされた後の記述
      $this.show();
    });