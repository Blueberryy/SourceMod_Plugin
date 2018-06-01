## [TF2]MGE Limit

・必要ファイル  
plugins/mgelimit.smx
translations/mgelimit.phrases.txt

MGEに各種縛りルールを追加します。  
MGEが正常動作している必要があります。

以下の各クラスで利用可能です。  
クラス変更直後のみ設定可能  
ゲーム中に変更を行う場合、同じクラスにクラス変更を行ってください。

・スパイ  
バックスタブのみ有効  
バックスタブとリボルバーのみ有効

・スナイパー  
ヘッドショットのみ有効

・エンジニア  
毎ラウンドごとに装置を全て消去する

・ソルジャー(BBallのみ)
ハンディキャップを有効にする

有効にするとキルされなくなります。
ただし設定された値のダメージを受けるとインテルを落とし一定時間スタンします。

**cvars**

>"sm_ml_enable" = "1" ( def. "0" )  
>0:disable 1:enable

>"sm_ml_stunspeed" = "0.8"  
>バスケのハンデに使うスタン時の速度

>"sm_ml_stuntime" = "4"  
>バスケのハンデに使うスタン時間

>"sm_ml_damage" = "200"  
>バスケのハンデでインテルをドロップするダメージ値

>"sm_ml_mode" = "0"  
>0:ダメージを受けない ANY:トドメをさせない(ヘルスが0になると設定した値までヘルスを回復させる)