# kintai-bot for Slack

## Prerequisites

- AWS Account
- Terraform
- SlackApp: `Outgoing WebHooks`
  - Token: argumentの `slack_tokens` で使います。
  - URL(s): outputの `api_url` を設定します。
  - Trigger Word(s): 勤怠アクションの操作に必要なプレフィックスの単語リストです。
- SlackApp: `Incoming WebHooks`
  - 勤怠連絡報告先のチャンネルに設定します。
  - WebHook URLは `destinations` で使います。

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |
| aws | ~> 2.70 |

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | ~> 2.70 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| id | リソースが一意になるように付与する任意の文字列 | `string` | n/a | yes |
| slack\_tokens | SlackAppのOutgoingWebhookが発行するSlackTokenのリスト | `list(string)` | n/a | yes |
| user\_ids | 自身のSlack User IDのリスト | `list(string)` | n/a | yes |
| destinations | 勤怠連絡報告先のSlackチャンネルに設定されているIncomingWebhook URLのリスト | `list(string)` | n/a | yes |
| undef\_action\_text | 未定義遷移のレスポンス | `list(string)` | <pre>[<br>  "勤怠アクションが定義されていません。"<br>]</pre> | no |
| illegal\_action\_text | 不正遷移のレスポンス | `list(string)` | <pre>[<br>  "今の勤怠ステータスに対する不正な勤怠アクションです。"<br>]</pre> | no |
| different\_user | 許可されていないユーザーからのコマンドのレスポンス | `list(string)` | <pre>[<br>  "勤怠アクションが許可されていないユーザーです。"<br>]</pre> | no |
| work\_start\_words | 勤怠開始のトリガーワード | `list(string)` | <pre>[<br>  "出社"<br>]</pre> | no |
| work\_start\_text | 勤怠用Slackチャンネルへの勤怠開始の報告文面 | `string` | `"ユーザーが出社しました。"` | no |
| work\_start\_res | 勤怠開始のレスポンス | `string` | `"今日も一日頑張ってください。"` | no |
| remote\_work\_start\_words | 在宅勤怠開始のトリガーワード | `list(string)` | <pre>[<br>  "在宅勤務"<br>]</pre> | no |
| remote\_work\_start\_text | 勤怠用Slackチャンネルへの在宅勤怠開始の報告文面 | `string` | `"ユーザーが在宅勤務を開始しました。"` | no |
| remote\_work\_start\_res | 在宅勤怠開始のレスポンス | `string` | `"今日も一日頑張ってください。"` | no |
| work\_end\_words | 勤怠終了のトリガーワード | `list(string)` | <pre>[<br>  "退社",<br>  "退勤"<br>]</pre> | no |
| work\_end\_text | 勤怠用Slackチャンネルへの勤怠終了の報告文面 | `string` | `"ユーザーが勤務を終了しました。"` | no |
| work\_end\_res | 勤怠終了のレスポンス | `string` | `"お疲れ様でした。"` | no |
| break\_start\_words | 休憩開始のトリガーワード | `list(string)` | <pre>[<br>  "休憩"<br>]</pre> | no |
| break\_start\_text | 勤怠用Slackチャンネルへの休憩開始の報告文面 | `string` | `"ユーザーが休憩時間に入りました。"` | no |
| break\_start\_res | 休憩開始のレスポンス | `string` | `"休憩時間に入ります。"` | no |
| afk\_start\_words | 離席開始のトリガーワード | `list(string)` | <pre>[<br>  "離席"<br>]</pre> | no |
| afk\_start\_text | 勤怠用Slackチャンネルへの離席開始の報告文面 | `string` | `"ユーザーが離席しました。"` | no |
| afk\_start\_res | 離席開始のレスポンス | `string` | `"席を外します。"` | no |
| recover\_words | 復帰のトリガーワード | `list(string)` | <pre>[<br>  "再開",<br>  "復帰"<br>]</pre> | no |
| recover\_text | 勤怠用Slackチャンネルへの復帰の報告文面 | `string` | `"ユーザーが仕事に戻りました。"` | no |
| recover\_res | 復帰のレスポンス | `string` | `"戻りました。"` | no |
| broadcast\_words | ブロードキャストのトリガーワード<pre>使い方)<br>`今日は○○の仕事をします。` って伝えて</pre> | `list(string)` | <pre>[<br>  "伝えて"<br>]</pre> | no |
| broadcast\_res | ブロードキャストのレスポンス | `string` | `"伝達しました。"` | no |
| cancel\_words | キャンセルのトリガーワード | `list(string)` | <pre>[<br>  "キャンセル"<br>]</pre> | no |
| cancel\_text | 勤怠用Slackチャンネルへのキャンセルの報告文面 | `string` | `"ユーザーが勤怠記録を取り消しました。"` | no |
| cancel\_res | キャンセルのレスポンス | `string` | `"取り消しました。"` | no |

## Outputs

| Name | Description |
|------|-------------|
| api\_url | SlackAppのOutgoingWebhookに設定するAPIのURL |
