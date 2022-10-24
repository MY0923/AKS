# Chart の設定ファイル調整順番

1. Chart.yaml ファイルを編集し、Chart の基本的な情報や appVersion を指定する
2. values.yaml ファイルを編集し、使用するコンテナイメージファイルや Service に割り当てるポート番号、ServiceAccount および Ingress を作成するかどうかを指定する
3. templates/deployment.yaml を編集し、作成する Pod のパラメータなどを変更する
4. templates.service.yaml を編集し、使用するポートなどの情報を変更する
5. 必要に応じて serviceaccount.yaml や ingress.yaml を編集してパラメータや設定を変更する
