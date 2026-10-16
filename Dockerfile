# syntax=docker/dockerfile:1.4
FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# news-sl はコミット SHA で固定する(マージ後の main の SHA に更新するか --build-arg NEWS_SL_REF=<sha> で上書き)。
ARG NEWS_SL_REF=c7a2da025e4dd6c4a41d5826939279653194424e

# gh token は BuildKit secret で受ける(news-sl が public の間は無くても匿名 clone で通る。token は層に残らない)。
#   docker buildx build --platform linux/amd64 --secret id=gh_token,src=<tokenを書いた一時ファイル> ...
RUN --mount=type=secret,id=gh_token,required=false \
    TOKEN="$(cat /run/secrets/gh_token 2>/dev/null || true)"; \
    if [ -n "$TOKEN" ]; then AUTH="x-access-token:${TOKEN}@"; else AUTH=""; fi; \
    pip install --no-cache-dir boto3 requests \
      "news-sl @ git+https://${AUTH}github.com/wakaba0325-hub/news-sl.git@${NEWS_SL_REF}"

ENTRYPOINT ["python", "-m", "news_sl.build_l3"]
# 既定は書込あり。世代削除は --prune apply を足したときだけ(既定 dry-run)
CMD ["--apply"]
