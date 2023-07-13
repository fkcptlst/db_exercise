# 数据库实践的数据库部分

本仓库是[后端](https://github.com/ChrisVicky/forum-in-flask)的数据库结构的描述和实现。

## 使用方法

- 正确建表顺序:
  1. users
  2. badges
  3. posts
  4. comments
  5. posthistory
  6. postlinks
  7. tags
  8. votes

## 文件结构

主要的SQL表放在`SQLs`目录下。

其它的一些utilities在`scripts`目录下（Notebook的hf_token已经过期了，请换成自己的）
