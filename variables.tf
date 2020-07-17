variable "id" {
  type        = string
  description = "リソースが一意になるように付与する任意の文字列"
}


/* ====================
Slack関連設定
==================== */

variable "slack_tokens" {
  type        = list(string)
  description = "SlackAppのOutgoingWebhookが発行するSlackTokenのリスト"
}

variable "user_ids" {
  type        = list(string)
  description = "自身のSlack User IDのリスト"
}

variable "destinations" {
  type        = list(string)
  description = "勤怠連絡報告先のSlackチャンネルに設定されているIncomingWebhook URLのリスト"
}


/* ====================
設定（勤怠）
==================== */

variable "undef_action_text" {
  type        = list(string)
  default     = ["勤怠アクションが定義されていません。"]
  description = "未定義遷移のレスポンス"
}

variable "illegal_action_text" {
  type        = list(string)
  default     = ["今の勤怠ステータスに対する不正な勤怠アクションです。"]
  description = "不正遷移のレスポンス"
}

variable "different_user" {
  type        = list(string)
  default     = ["勤怠アクションが許可されていないユーザーです。"]
  description = "許可されていないユーザーからのコマンドのレスポンス"
}

/* ====================
設定（勤怠）
==================== */

variable "work_start_words" {
  type        = list(string)
  default     = ["出社"]
  description = "勤怠開始のトリガーワード"
}

variable "work_start_text" {
  type        = string
  default     = "ユーザーが出社しました。"
  description = "勤怠用Slackチャンネルへの勤怠開始の報告文面"
}

variable "work_start_res" {
  type        = string
  default     = "今日も一日頑張ってください。"
  description = "勤怠開始のレスポンス"
}

variable "remote_work_start_words" {
  type        = list(string)
  default     = ["在宅勤務"]
  description = "在宅勤怠開始のトリガーワード"
}

variable "remote_work_start_text" {
  type        = string
  default     = "ユーザーが在宅勤務を開始しました。"
  description = "勤怠用Slackチャンネルへの在宅勤怠開始の報告文面"
}

variable "remote_work_start_res" {
  type        = string
  default     = "今日も一日頑張ってください。"
  description = "在宅勤怠開始のレスポンス"
}

variable "work_end_words" {
  type        = list(string)
  default     = ["退社", "退勤"]
  description = "勤怠終了のトリガーワード"
}

variable "work_end_text" {
  type        = string
  default     = "ユーザーが勤務を終了しました。"
  description = "勤怠用Slackチャンネルへの勤怠終了の報告文面"
}

variable "work_end_res" {
  type        = string
  default     = "お疲れ様でした。"
  description = "勤怠終了のレスポンス"
}

/* ====================
設定（休憩）
==================== */

variable "break_start_words" {
  type        = list(string)
  default     = ["休憩"]
  description = "休憩開始のトリガーワード"
}

variable "break_start_text" {
  type        = string
  default     = "ユーザーが休憩時間に入りました。"
  description = "勤怠用Slackチャンネルへの休憩開始の報告文面"
}

variable "break_start_res" {
  type        = string
  default     = "休憩時間に入ります。"
  description = "休憩開始のレスポンス"
}

/* ====================
設定（離席）
==================== */

variable "afk_start_words" {
  type        = list(string)
  default     = ["離席"]
  description = "離席開始のトリガーワード"
}

variable "afk_start_text" {
  type        = string
  default     = "ユーザーが離席しました。"
  description = "勤怠用Slackチャンネルへの離席開始の報告文面"
}

variable "afk_start_res" {
  type        = string
  default     = "席を外します。"
  description = "離席開始のレスポンス"
}

/* ====================
設定（復帰）
==================== */

variable "recover_words" {
  type        = list(string)
  default     = ["再開", "復帰"]
  description = "復帰のトリガーワード"
}

variable "recover_text" {
  type        = string
  default     = "ユーザーが仕事に戻りました。"
  description = "勤怠用Slackチャンネルへの復帰の報告文面"
}

variable "recover_res" {
  type        = string
  default     = "戻りました。"
  description = "復帰のレスポンス"
}

/* ====================
設定（ブロードキャスト）
==================== */

variable "broadcast_words" {
  type        = list(string)
  default     = ["伝えて"]
  description = <<DESCRIPTION
ブロードキャストのトリガーワード
```
使い方)
`今日は○○の仕事をします。` って伝えて
```
DESCRIPTION
}

variable "broadcast_res" {
  type        = string
  default     = "伝達しました。"
  description = "ブロードキャストのレスポンス"
}

/* ====================
設定（キャンセル）
==================== */

variable "cancel_words" {
  type        = list(string)
  default     = ["キャンセル"]
  description = "キャンセルのトリガーワード"
}

variable "cancel_text" {
  type        = string
  default     = "ユーザーが勤怠記録を取り消しました。"
  description = "勤怠用Slackチャンネルへのキャンセルの報告文面"
}

variable "cancel_res" {
  type        = string
  default     = "取り消しました。"
  description = "キャンセルのレスポンス"
}