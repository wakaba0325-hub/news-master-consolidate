# news-master-consolidate

`news_sl.build_l3`(news-slパッケージ本体)を日次実行するだけのランナー。ロジック本体はnews-sl側にあり、このリポはDockerイメージ化とECSタスク定義のみを持つ。

- 入力: 各`<source>-news-collector`が書く `master/news_sources/<source>/{最新}/<source>.csv`
  (現状PR TIMESのみ)
- 出力: `master/news_master/{当日}/news_master.csv`(company_master突合済み・新規掲載フラグ`is_new_today`付き)

company_master突合ロジック(正規化・閉鎖法人除外・body_snippetからの都道府県あいまい解消・
`match_method`列)の詳細はnews-sl側の`news_sl/l3.py`のdocstring参照。

PR TIMESは6時間おき(1日4回)実行のため、本ランナーもPR TIMESの実行完了後に走らせる必要がある。

## 使い方

```bash
docker build -t news-master-consolidate .
docker run --rm -e AWS_... news-master-consolidate  # 既定で --apply(本番書込)
```
