---
layout: page
title: 欢迎来到 Shmily 的窝~~
---
{% include JB/setup %}

这个blog旨在记录鄙人工作生活中的一些心得。   
如果这些文字能对你有所帮助，我会感到很荣幸，如果你问题，可以给我发Email。

`shmily@mail.dlut.edu.cn`

    
## 最近更新的文字

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

## 关于我

在读研究生   
爱好 `Linux、硬件、coding`






