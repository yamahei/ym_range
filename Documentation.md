class YmRange
=

パターンにマッチする年月の範囲を管理します。
* 特定の年月（例：1976/07）
* 特定の月（例：*/07）
* 特定の年（例：1976/*）
* 特定の複数月（例：*/05,07,11,12）
* 範囲年（例：1976-2000/07）
* 範囲月（例：1976/01-07）
* 範囲年月（例：1976-2000/01-07）

methods
-

### new
* *new (YM-string)* : void
* *new (nil | year_number | year_range, nil, month_number | month_range | month_array)* : void
* *new (date)* : void
* *new ()* : void

`ym-range`インスタンスを生成します。
引数は項[arguments](#arguments)を参照してください。
引数を省略した場合、システム年月の`date`を使用してコンストラクタを実行します。

### include? / cover?
* *include? (year_number, month_number)* : boolean
* *include? (date)* : boolean

指定年月が`ym-range`オブジェクトの範囲内かを判定します。
範囲を引数に取ることはできません。
`cover?`は`include?`のエイリアスです。

引数は項[arguments](#arguments)を参照してください。


arguments
-

### date

`date`オブジェクトの年月を使用して`new (year_number, month_number)`を呼びます。

### nil

全ての範囲を表現します。

* `(1976, nil)`: `(1976, 1..12)`と同じ
* `(nil, 7)`: `(0..9999, 7)`と同じ
* `(nil, nil)`: `(0..9999, 1..12)`と同じ

### year_number, month_number

年および月を表す数字。

* year_number: 0-9999の数字
* month_number: 1-12の数字

### year_range, month_range

年および月の範囲を表す`range`。
※始端、終端を省略した場合、年月の最小、最大を指定したものと見なします。

* year_range: 0-9999の範囲
* month_range: 1-12の範囲

### month_array

複数の月を表す`array`。
要素は1-12の数字を指定します。

* 1-12以外の数字が含まれている場合はエラー
* 1-12の数字が重複してる場合は無視

### YM-string

`nil`, `number`, `range`, `array`（月のみ）を表す文字列を`/`区切りで指定します。

* "1976/7": `(1976, 7)`と同じ
* "1976-2000/7": `(1976..2000, 7)`と同じ
* "1976/7-12": `(1976, 7..12)`と同じ
* "1976/*": `(1976, nil)`と同じ
* "1976/7,8": `(1976, [7, 8])`と同じ
