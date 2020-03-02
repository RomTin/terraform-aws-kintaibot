variable "id" {
  type        = string
  description = "リソースが一意になるように付与する任意の文字列"
}


/* ====================
Slack関連設定
==================== */

variable "slack_token" {
  type        = string
  description = "SlackAppのOutgoingWebhookが発行するSlackToken"
}

variable "user_id" {
  type        = string
  description = "自身のSlack User ID"
}

variable "destinations" {
  type        = list
  description = "勤怠連絡の報告先Slackチャンネル"
}

/* ====================
設定（勤怠）
==================== */

variable "undef_action_text" {
  type        = list
  description = "未定義遷移のレスポンス"
}

variable "illegal_action_text" {
  type        = list
  description = "不正遷移のレスポンス"
}

variable "different_user" {
  type        = list
  description = "許可されていないユーザーからのコマンドのレスポンス"
}

/* ====================
設定（勤怠）
==================== */

variable "work_start_words" {
  type        = list
  description = "勤怠開始のトリガーワード"
}

variable "work_start_text" {
  type        = string
  description = "勤怠開始の報告文面"
}

variable "work_start_res" {
  type        = string
  description = "勤怠開始のレスポンス"
}

variable "remote_work_start_words" {
  type        = list
  description = "在宅勤怠開始のトリガーワード"
}

variable "remote_work_start_text" {
  type        = string
  description = "在宅勤怠開始の報告文面"
}

variable "remote_work_start_res" {
  type        = string
  description = "在宅勤怠開始のレスポンス"
}

variable "work_end_words" {
  type        = list
  description = "勤怠終了のトリガーワード"
}

variable "work_end_text" {
  type        = string
  description = "勤怠終了の報告文面"
}

variable "work_end_res" {
  type        = string
  description = "勤怠終了のレスポンス"
}

/* ====================
設定（休憩）
==================== */

variable "break_start_words" {
  type        = list
  description = "休憩開始のトリガーワード"
}

variable "break_start_text" {
  type        = string
  description = "休憩開始の報告文面"
}

variable "break_start_res" {
  type        = string
  description = "休憩開始のレスポンス"
}

/* ====================
設定（離席）
==================== */

variable "afk_start_words" {
  type        = list
  description = "離席開始のトリガーワード"
}

variable "afk_start_text" {
  type        = string
  description = "離席開始の報告文面"
}

variable "afk_start_res" {
  type        = string
  description = "離席開始のレスポンス"
}

/* ====================
設定（復帰）
==================== */

variable "recover_words" {
  type        = list
  description = "復帰のトリガーワード"
}

variable "recover_text" {
  type        = string
  description = "復帰の報告文面"
}

variable "recover_res" {
  type        = string
  description = "復帰のレスポンス"
}

/* ====================
設定（ブロードキャスト）
==================== */

variable "broadcast_words" {
  type        = list
  description = "ブロードキャストのトリガーワード"
}

variable "broadcast_text" {
  type        = string
  description = "ブロードキャストの報告文面"
}

variable "broadcast_res" {
  type        = string
  description = "ブロードキャストのレスポンス"
}

/* ====================
設定（キャンセル）
==================== */

variable "cancel_words" {
  type        = list
  description = "キャンセルのトリガーワード"
}

variable "cancel_text" {
  type        = string
  description = "キャンセルの報告文面"
}

variable "cancel_res" {
  type        = string
  description = "キャンセルのレスポンス"
}