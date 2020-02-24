## 勤怠bot for Slack

## Usage

```
$ terraform init
$ terraform apply --var-file=./main.tfvars
```

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | 2.21.1 |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| afk\_start\_res | 離席開始のレスポンス | `string` | n/a | yes |
| afk\_start\_text | 離席開始の報告文面 | `string` | n/a | yes |
| afk\_start\_words | 離席開始のトリガーワード | `list` | n/a | yes |
| break\_start\_res | 休憩開始のレスポンス | `string` | n/a | yes |
| break\_start\_text | 休憩開始の報告文面 | `string` | n/a | yes |
| break\_start\_words | 休憩開始のトリガーワード | `list` | n/a | yes |
| destinations | 勤怠連絡の報告先Slackチャンネル | `list` | n/a | yes |
| different\_user | 許可されていないユーザーからのコマンドのレスポンス | `list` | n/a | yes |
| id | リソースが一意になるように付与する任意の文字列 | `string` | n/a | yes |
| illegal\_action\_text | 不正遷移のレスポンス | `list` | n/a | yes |
| recover\_res | 復帰のレスポンス | `string` | n/a | yes |
| recover\_text | 復帰の報告文面 | `string` | n/a | yes |
| recover\_words | 復帰のトリガーワード | `list` | n/a | yes |
| slack\_token | SlackAppのOutgoingWebhookが発行するSlackToken | `string` | n/a | yes |
| undef\_action\_text | 未定義遷移のレスポンス | `list` | n/a | yes |
| user\_id | 自身のSlack User ID | `string` | n/a | yes |
| work\_end\_res | 勤怠終了のレスポンス | `string` | n/a | yes |
| work\_end\_text | 勤怠終了の報告文面 | `string` | n/a | yes |
| work\_end\_words | 勤怠終了のトリガーワード | `list` | n/a | yes |
| work\_start\_res | 勤怠開始のレスポンス | `string` | n/a | yes |
| work\_start\_text | 勤怠開始の報告文面 | `string` | n/a | yes |
| work\_start\_words | 勤怠開始のトリガーワード | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| api\_url | SlackAppのOutgoingWebhookに設定するAPIのURL |

