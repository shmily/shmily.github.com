<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8" />
<meta name="author" content="dylan" />
<meta name="keywords" content="{{ page.tags | join: ',' }}" />
<title>{{ site.name }}{% if page.title %} / {{ page.title }}{% endif %}</title>
<link href="http://dylanvivi.github.com/feed.xml" rel="alternate" title="{{ site.name }}" type="application/atom+xml" />
<link rel="stylesheet" type="text/css" href="/assets/css/site.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/code/googlecode.css" />
{% for style in page.styles %}<link rel="stylesheet" type="text/css" href="{{ style }}" />
{% endfor %}
</head>

<body class="{{ page.pageClass }}">

<div class="main">
	{{ content }}

	<footer>
		<p>&copy; Since 2012</p>
	</footer>
</div>

<side>
	<h2><a href="/">{{ site.name }}</a><a href="/feed.xml" class="feed-link" title="RSS"><img src="http://blog.rexsong.com/wp-content/themes/rexsong/icon_feed.gif" alt="RSS feed" /></a></h2>
	
	<nav class="block">
		<ul>
		{% for category in site.custom.categories %}<li class="{{ category.name }}"><a href="/category/{{ category.name }}/">{{ category.title }}</a></li>
		{% endfor %}
		</ul>
	</nav>
	
	<form action="/search/" class="block block-search">
		<h3>Search</h3>
		<p><input type="search" name="q" placeholder="Search" /></p>
	</form>
	
	<div class="block block-about">
		<h3>About</h3>
		<figure>
			{% if site.meta.author.gravatar %}<img src="{{ site.meta.gravatar}}{{ site.meta.author.gravatar }}?s=48" />{% endif %}
			<figcaption><strong>{{ site.meta.author.name }}</strong></figcaption>
		</figure>
		<p>我要抱着向日葵，一点一点，开始歌唱……</p>
	</div>
	
	<div class="block block-license">
		<h3>Copyright</h3>
		<p><a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/2.5/cn/" target="_blank" class="hide-target-icon" title="Copyright declaration of site content"><img alt="知识共享许可协议" src="http://i.creativecommons.org/l/by-nc-nd/2.5/cn/88x31.png" /></a></p>
	</div>
	
	{% if site.meta.author.github %}
	<div class="block block-fork">
		<a href="https://github.com/{{ site.meta.author.github }}"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png" alt="Fork me on GitHub"></a>
	</div>
	{% endif %}
	
	<div class="block block-thank">
		<h3>Powered by</h3>
		<p>
			<a href="http://disqus.com/" target="_blank">Disqus</a>,
			<a href="http://elfjs.com/" target="_blank">elf+js</a>,
			<a href="https://github.com/" target="_blank">GitHub</a>,
			<a href="http://www.google.com/cse/" target="_blank">Google Custom Search</a>,
			<a href="http://en.gravatar.com/" target="_blank">Gravatar</a>,
			<a href="http://softwaremaniacs.org/soft/highlight/en/">HighlightJS</a>,
			<a href="https://github.com/mojombo/jekyll" target="_blank">jekyll</a>,
			<a href="https://github.com/mytharcher/SimpleGray" target="_blank">SimpleGray</a>
		</p>
	</div>
</side>

<script src="http://elfjs.googlecode.com/files/elf-0.4.0-min.js"></script>
<script src="/assets/js/highlight.pack.js"></script>

<script src="/assets/js/site.js"></script>

<script>hljs.initHighlightingOnLoad();</script>

{% for script in page.scripts %}<script src="{{ script }}"></script>
{% endfor %}
<script src = "http://{{ site.meta.author.disqus }}.{{ site.meta.disqus }}"/>
<script>
site.Urls.GOOGLE_API = '{{site.meta.gapi}}';
site.Urls.DISCUS_COMMENT = '{{ site.meta.author.disqus }}' ? 'http://{{ site.meta.author.disqus }}.{{ site.meta.disqus }}' : '';

site.Vars.SITE_NAME = '{{ site.name }}';
site.Vars.GOOGLE_CUSTOM_SEARCH_ID = '{{ site.meta.author.gcse }}';
</script>
</body>
</html>