# 部署与互动功能配置指南

目标仓库：github.com/DoriaXiao/DoriaXiao.github.io（保持不变，URL 不变）

## 第 0 步：备份旧站

```bash
cd DoriaXiao.github.io
git checkout -b jekyll-archive
git push origin jekyll-archive   # 旧 Jekyll 站完整保留在这个分支
git checkout main
```

## 第 1 步：替换为 Quarto 源码

把本骨架的全部文件复制进仓库根目录（先清空 main 上的旧 Jekyll 文件，
但保留 assets/img/profile.jpg 和 assets/cv/ 下的 PDF，骨架里已留好对应目录）。

本地需要：Quarto（quarto.org 下载）+ R + ggplot2。

```bash
quarto preview    # 本地实时预览
```

## 第 2 步：发布

```bash
quarto publish gh-pages
```

第一次运行会自动创建 gh-pages 分支并推送渲染结果。然后到
GitHub 仓库 Settings -> Pages，把 Source 改为 **gh-pages 分支**（根目录）。
以后每次发文：写 .qmd -> `quarto publish gh-pages`，一条命令。

## 第 3 步：阅读量（GoatCounter，免费）

1. 到 https://www.goatcounter.com 注册，site code 建议填 `doriaxiao`
2. 把 `assets/goatcounter.html` 和 `assets/pageviews.html` 里的 `MYCODE`
   全部替换为你的 site code
3. 在 GoatCounter 后台 Settings 勾选 "Allow adding visitor counts on your website"
   （否则文章页底部的可见计数器不显示）
4. 后台 dashboard 可看每篇文章的访问量、来源、地区

## 第 4 步：评论 + 点赞（giscus，基于 GitHub Discussions，免费无后端）

1. 仓库 Settings -> General -> Features -> 勾选 **Discussions**
2. 安装 giscus app：https://github.com/apps/giscus ，授权给这个仓库
3. 打开 https://giscus.app ，填入仓库名 DoriaXiao/DoriaXiao.github.io，
   Discussion 分类选 Announcements，页面会生成 `data-repo-id` 和
   `data-category-id` 两个值
4. 把这两个值填进 `posts/_metadata.yml` 里的两处 REPLACE_FROM_GISCUS_APP

之后每篇文章底部自动出现评论区，顶部有表情 reactions（👍❤️🎉 等），
这就是"点赞"。读者用 GitHub 账号登录即可评论，学术受众基本人手一个。

## 关于"收藏"

静态网站没有无后端的收藏功能，诚实的答案是不做：读者的收藏行为
发生在浏览器书签和 RSS 订阅里（blog.xml 已自动生成）。giscus 的
reactions + GoatCounter 阅读量已覆盖你需要的反馈信号。

## 必改清单（上线前）

- [ ] index.qmd 里的 REPLACE_WITH_PERSONAL_EMAIL（Stanford 邮箱离职后会停用！）
- [ ] CV PDF 里的联系邮箱同步更新
- [ ] 从旧仓库复制 profile.jpg 和 CV PDF 到 assets/ 对应目录
- [ ] 旧博文（约 5 篇）：从 jekyll-archive 分支把 markdown 内容
      搬到 posts/<日期-标题>/index.qmd，front matter 改成 Quarto 格式
- [ ] 示例文章删掉 `draft: true` 才会出现在列表里
