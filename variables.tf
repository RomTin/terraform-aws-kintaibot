variable "id" {
  type        = string
  description = "リソースが一意になるように付与する任意の文字列"
}


/* ====================
Slack関連設定
==================== */

variable "slack_tokens" {
  type        = list(string)
  description = "SlackAppのOutgoingWebhookが発行するSlackToken"
}

variable "user_ids" {
  type        = list(string)
  description = "自身のSlack User ID"
}

variable "destinations" {
  type        = list(string)
  description = "勤怠連絡の報告先Slackチャンネル"
}

/* ====================
設定（勤怠）
==================== */

variable "undef_action_text" {
  type        = list(string)
  description = <<DESCRIPTION
未定義遷移のレスポンス
```
例)
勤怠アクションが定義されていません。
```
DESCRIPTION
}

variable "illegal_action_text" {
  type        = list(string)
  description = <<DESCRIPTION
不正遷移のレスポンス
```
例)
今の勤怠ステータスに対する不正な勤怠アクションです。
```
DESCRIPTION
}

variable "different_user" {
  type        = list(string)
  description = <<DESCRIPTION
許可されていないユーザーからのコマンドのレスポンス
```
例)
勤怠アクションが許可されていないユーザーです。
```
DESCRIPTION
}

/* ====================
設定（勤怠）
==================== */

variable "work_start_words" {
  type        = list(string)
  description = <<DESCRIPTION
勤怠開始のトリガーワード
```
例)
["出社"]
```
DESCRIPTION
}

variable "work_start_text" {
  type        = string
  description = <<DESCRIPTION
勤怠用Slackチャンネルへの勤怠開始の報告文面
```
例)
ユーザーが出社しました。
```
DESCRIPTION
}

variable "work_start_res" {
  type        = string
  description = <<DESCRIPTION
勤怠開始のレスポンス
```
例)
今日も一日頑張ってください。
```
DESCRIPTION
}

variable "remote_work_start_words" {
  type        = list(string)
  description = <<DESCRIPTION
在宅勤怠開始のトリガーワード
```
例)
["在宅勤務"]
```
DESCRIPTION
}

variable "remote_work_start_text" {
  type        = string
  description = <<DESCRIPTION
勤怠用Slackチャンネルへの在宅勤怠開始の報告文面
```
例)
ユーザーが在宅勤務を開始しました。
```
DESCRIPTION
}

variable "remote_work_start_res" {
  type        = string
  description = <<DESCRIPTION
在宅勤怠開始のレスポンス
```
例)
今日も一日頑張ってください。
```
DESCRIPTION
}

variable "work_end_words" {
  type        = list(string)
  description = <<DESCRIPTION
勤怠終了のトリガーワード
```
例)
["退社", "退勤"]
```
DESCRIPTION
}

variable "work_end_text" {
  type        = string
  description = <<DESCRIPTION
勤怠用Slackチャンネルへの勤怠終了の報告文面
```
例)
ユーザーが勤務を終了しました。
```
DESCRIPTION
}

variable "work_end_res" {
  type        = string
  description = <<DESCRIPTION
勤怠終了のレスポンス
```
例)
お疲れ様でした。
```
DESCRIPTION
}

/* ====================
設定（休憩）
==================== */

variable "break_start_words" {
  type        = list(string)
  description = <<DESCRIPTION
休憩開始のトリガーワード
```
例)
["休憩"]
```
DESCRIPTION
}

variable "break_start_text" {
  type        = string
  description = <<DESCRIPTION
勤怠用Slackチャンネルへの休憩開始の報告文面
```
例)
ユーザーが休憩時間に入りました。
```
DESCRIPTION
}

variable "break_start_res" {
  type        = string
  description = <<DESCRIPTION
休憩開始のレスポンス
```
例)
休憩時間に入ります。
```
DESCRIPTION
}

/* ====================
設定（離席）
==================== */

variable "afk_start_words" {
  type        = list(string)
  description = <<DESCRIPTION
離席開始のトリガーワード
```
例)
["離席"]
```
DESCRIPTION
}

variable "afk_start_text" {
  type        = string
  description = <<DESCRIPTION
勤怠用Slackチャンネルへの離席開始の報告文面
```
例)
ユーザーが離席しました。
```
DESCRIPTION
}

variable "afk_start_res" {
  type        = string
  description = <<DESCRIPTION
離席開始のレスポンス
```
例)
席を外します。
```
DESCRIPTION
}

/* ====================
設定（復帰）
==================== */

variable "recover_words" {
  type        = list(string)
  description = <<DESCRIPTION
復帰のトリガーワード
```
例)
["再開", "復帰"]
```
DESCRIPTION
}

variable "recover_text" {
  type        = string
  description = <<DESCRIPTION
勤怠用Slackチャンネルへの復帰の報告文面
```
例)
ユーザーが仕事に戻りました。
```
DESCRIPTION
}

variable "recover_res" {
  type        = string
  description = <<DESCRIPTION
復帰のレスポンス
```
例)
戻りました。
```
DESCRIPTION
}

/* ====================
設定（ブロードキャスト）
==================== */

variable "broadcast_words" {
  type        = list(string)
  description = <<DESCRIPTION
ブロードキャストのトリガーワード
```
例)
["伝えて"]
使い方)
`今日は○○の仕事をします。` って伝えて
```
DESCRIPTION
}

variable "broadcast_res" {
  type        = string
  description = <<DESCRIPTION
ブロードキャストのレスポンス
```
例)
伝達しました。
```
DESCRIPTION
}

/* ====================
設定（キャンセル）
==================== */

variable "cancel_words" {
  type        = list(string)
  description = <<DESCRIPTION
キャンセルのトリガーワード
```
例)
["キャンセル"]
```
DESCRIPTION
}

variable "cancel_text" {
  type        = string
  description = <<DESCRIPTION
勤怠用Slackチャンネルへのキャンセルの報告文面
```
例)
ユーザーが勤怠記録を取り消しました。
```
DESCRIPTION
}

variable "cancel_res" {
  type        = string
  description = <<DESCRIPTION
キャンセルのレスポンス
```
例)
取り消しました。
```
DESCRIPTION
}