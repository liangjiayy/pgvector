# 1. 基于官方镜像
FROM postgres:16

# 2. 换国内源（可选，加速 apt）
RUN sed -i 's@deb.debian.org@mirrors.aliyun.com@g' /etc/apt/sources.list

# 3. 安装编译依赖 & 编译 pgvector
RUN apt-get update && apt-get install -y --no-install-recommends \
        postgresql-server-dev-16 \
        build-essential \
        git \
    && git clone --depth 1 https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    && rm -rf /tmp/pgvector \
    && apt-get purge -y postgresql-server-dev-16 build-essential git \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 4. 把初始化 SQL 拷到 Postgres 官方识别的目录
#    该目录下的 *.sql 文件会在首次启动时自动执行
COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d/

# 5. 开放端口（文档性声明）
EXPOSE 5432

# 6. 官方父镜像已经写好 CMD，无需再写
