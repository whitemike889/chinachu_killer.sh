# chinachu_killer.sh
録画鯖（*powered by Chinachu γ*）の電源を付けたり消したりするシェルスクリプト。  
ググってもChinachu γで使えるものが見つからなかったので作りました。
* 録画終了後5分たったら電源を切る
* 録画開始3分前になったら起動
* ログイン中は電源を切らない
* chinachuにアクセスがあれば電源を切らない
* 録画中は電源を切らない
* 次の予約まで30分切っていたら電源を切らない

録画番組はNAS上に保存するっていう人向け。  
ローカルに保存してsambaで視聴する人はsmbstatusとかでif文を追加するといいと思う。

sudoでcrontabに`*/30 * * * * /home/foo/bar/chinachu_killer.sh`としておけば、あとは放置でok。

___
前提条件（変更するべき箇所）：  
* chinachuのport：10772
* chinachuの設置場所：/home/chinachu/chinachu/
* スクリプトの置き場所：/home/foo/bar/
