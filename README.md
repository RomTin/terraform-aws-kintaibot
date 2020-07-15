## 勤怠bot for Slack

## Usage

```
$ terraform init
$ terraform apply --var-file=./main.tfvars
```

## Requirements

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | ~> 2.0 |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| afk\_start\_res | 離席開始のレスポンス<pre>例)<br>席を外します。</pre> | `string` | n/a | yes |
| afk\_start\_text | 勤怠用Slackチャンネルへの離席開始の報告文面<pre>例)<br>ユーザーが離席しました。</pre> | `string` | n/a | yes |
| afk\_start\_words | 離席開始のトリガーワード<pre>例)<br>["離席"]</pre> | `list(string)` | n/a | yes |
| break\_start\_res | 休憩開始のレスポンス<pre>例)<br>休憩時間に入ります。</pre> | `string` | n/a | yes |
| break\_start\_text | 勤怠用Slackチャンネルへの休憩開始の報告文面<pre>例)<br>ユーザーが休憩時間に入りました。</pre> | `string` | n/a | yes |
| break\_start\_words | 休憩開始のトリガーワード<pre>例)<br>["休憩"]</pre> | `list(string)` | n/a | yes |
| broadcast\_res | ブロードキャストのレスポンス<pre>例)<br>伝達しました。</pre> | `string` | n/a | yes |
| broadcast\_text | 勤怠用Slackチャンネルへのブロードキャストの報告文面<pre>※使用しません。</pre> | `string` | n/a | yes |
| broadcast\_words | ブロードキャストのトリガーワード<pre>例)<br>["伝えて"]<br>使い方)<br>`今日は○○の仕事をします。` って伝えて</pre> | `list(string)` | n/a | yes |
| cancel\_res | キャンセルのレスポンス<pre>例)<br>取り消しました。</pre> | `string` | n/a | yes |
| cancel\_text | 勤怠用Slackチャンネルへのキャンセルの報告文面<pre>例)<br>ユーザーが勤怠記録を取り消しました。</pre> | `string` | n/a | yes |
| cancel\_words | キャンセルのトリガーワード<pre>例)<br>["キャンセル"]</pre> | `list(string)` | n/a | yes |
| destinations | 勤怠連絡の報告先Slackチャンネル | `list(string)` | n/a | yes |
| different\_user | 許可されていないユーザーからのコマンドのレスポンス<pre>例)<br>勤怠アクションが許可されていないユーザーです。</pre> | `list(string)` | n/a | yes |
| id | リソースが一意になるように付与する任意の文字列 | `string` | n/a | yes |
| illegal\_action\_text | 不正遷移のレスポンス<pre>例)<br>今の勤怠ステータスに対する不正な勤怠アクションです。</pre> | `list(string)` | n/a | yes |
| recover\_res | 復帰のレスポンス<pre>例)<br>戻りました。</pre> | `string` | n/a | yes |
| recover\_text | 勤怠用Slackチャンネルへの復帰の報告文面<pre>例)<br>ユーザーが仕事に戻りました。</pre> | `string` | n/a | yes |
| recover\_words | 復帰のトリガーワード<pre>例)<br>["再開", "復帰"]</pre> | `list(string)` | n/a | yes |
| remote\_work\_start\_res | 在宅勤怠開始のレスポンス<pre>例)<br>今日も一日頑張ってください。</pre> | `string` | n/a | yes |
| remote\_work\_start\_text | 勤怠用Slackチャンネルへの在宅勤怠開始の報告文面<pre>例)<br>ユーザーが在宅勤務を開始しました。</pre> | `string` | n/a | yes |
| remote\_work\_start\_words | 在宅勤怠開始のトリガーワード<pre>例)<br>["在宅勤務"]</pre> | `list(string)` | n/a | yes |
| slack\_tokens | SlackAppのOutgoingWebhookが発行するSlackToken | `list(string)` | n/a | yes |
| undef\_action\_text | 未定義遷移のレスポンス<pre>例)<br>勤怠アクションが定義されていません。</pre> | `list(string)` | n/a | yes |
| user\_ids | 自身のSlack User ID | `list(string)` | n/a | yes |
| work\_end\_res | 勤怠終了のレスポンス<pre>例)<br>お疲れ様でした。</pre> | `string` | n/a | yes |
| work\_end\_text | 勤怠用Slackチャンネルへの勤怠終了の報告文面<pre>例)<br>ユーザーが勤務を終了しました。</pre> | `string` | n/a | yes |
| work\_end\_words | 勤怠終了のトリガーワード<pre>例)<br>["退社", "退勤"]</pre> | `list(string)` | n/a | yes |
| work\_start\_res | 勤怠開始のレスポンス<pre>例)<br>今日も一日頑張ってください。</pre> | `string` | n/a | yes |
| work\_start\_text | 勤怠用Slackチャンネルへの勤怠開始の報告文面<pre>例)<br>ユーザーが出社しました。</pre> | `string` | n/a | yes |
| work\_start\_words | 勤怠開始のトリガーワード<pre>例)<br>["出社"]</pre> | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| api\_url | SlackAppのOutgoingWebhookに設定するAPIのURL |

