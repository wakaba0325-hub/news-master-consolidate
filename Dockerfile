FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir boto3 "news-sl @ git+https://github.com/wakaba0325-hub/news-sl.git"

ENTRYPOINT ["python", "-m", "news_sl.build_l3"]
CMD ["--apply"]
