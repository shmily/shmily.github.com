---
layout: post
category : Raspberry-Pi
tags : [Raspberry-Pi, linux, arm, tutorial]
---
{% include JB/setup %}

vim-7.3 移植到 Raspberry-Pi
==========================

	Host : ubuntu 12.04 LTS
	Tool : arm-bcm2708hardfp-linux-gnueabi-gcc
	
## 前言

Raspberry-Pi 上运行的是自己编译的 `linux-3.2` + `build-root`，默认的编辑器是 nano、vi，但是都没有语法高亮的功能（也许是我不会配置 ^..^），很是不习惯。于是决定移植一个vim...

## ncurses-5.9 移植

vim 需要用到`libncurses.so`这个链接库，需要先行编译。  

* 下载 ncurses-5.9.tar.gz
	

* 配置

		./configure \
		CC=arm-bcm2708hardfp-linux-gnueabi-gcc \
		--host=arm-linux \
		--target=arm-linux \
		--enable-widec \
		--with-shared \
		--prefix=$(pwd)/_install
	
	
* 编译
		
		make HOSTCC=gcc CXX=arm-bcm2708hardfp-linux-gnueabi-c++ && make install

	有需要用的的文件如下：

		.
		├── include
		│   └── ncursesw
		├── lib
		│   ├── libncursesw.a
		│   ├── libncursesw.so -> libncursesw.so.5
		└───├── libncursesw.so.5 -> libncursesw.so.5.9
		    └── libncursesw.so.5.9

	include 文件夹，是编译vim时需要的头文件
		
	libncursesw.so 是生成的ncurses的库，但是vim需要的是libncurses.so，我估计`w`是因为配置时使用了`--enable-widec`的后缀，于是创建软连接：

		ibncurses.a -> libncursesw.a
		libncurses.so -> libncursesw.so
		libncurses.so.5 -> libncursesw.so.5
		libncurses.so.5.9 -> libncursesw.so.5.9

## vim-7.3 移植
	

* 下载 vim-7.3.tar.bz2
	

* 配置
		
		./configure \
		--with-features=normal \
		--disable-gui \
		--without-x \
		--disable-selinux \
		--disable-acl \
		--disable-gpm \
		--prefix=/usr/tools \
		CPPFLAGS=-I/home/shmily/armLinux/Rpi/ncurses-5.9/_install/include/ncursesw \ LDFLAGS=-L/home/shmily/armLinux/Rpi/ncurses-5.9/_install/lib/

	因为是在Raspberry上运行，暂时没有Xorg，不需要GUI，所以：`--disable-gui --without-x`
	
	需要注意的是 --prefix 参数， 这个安装路径会直接编译进 vim ，运行vim的时候就是从这个路径查找文件的，运行 vim --version ：

		fall-back for $VIM: "/usr/share/vim"
	
	这个就是 vim 的安装路径，必须对应在目标板上，为了不和host上的安装路径冲突，我使用/usr/tools  
	对应的目标板的路径为：
		
		fall-back for $VIM: "/usr/tools/share/vim"
	

* 编译
	
		make CC=arm-bcm2708hardfp-linux-gnueabi-gcc
		make STRIP=arm-bcm2708hardfp-linux-gnueabi-strip install

	对输出文件进行 strip 操作，删除不必要的信息（符号信息，调试信息），能有效减少文件大小。

	
* 安装
	
	拷贝  /usr/tools 到目标板上，同时把 libncurses.so 拷贝到目标板的 /usr/lib 上，vim就可以在目标板运行。

	但是，现在依然是没有语法高亮的功能~~~ （^..^）  
	需要继续努力啊~

	
* 配置

	建立 ~/.vimrc 文件，这个是vim启动时读取的配置文件，我们使用vim的默认模板创建

		 cp /usr/tools/share/vim/vim73/vimrc_example.vim ~/.vimrc

	配置文件是有了， syntax on，但是....还是不亮~~，神马情况啊~~

	只能问问 `Google大神` 了，得到了一个重要的信息：

		TERM="xterm" 与 terminfo
	
	vim 会根据 TERM 变量确定使用的什么样的终端类型，只有使用正确的终端类型，颜色高亮才会有效果，终端类型的定义是在 terminfo 文件夹下的，比如 ubuntu 路径为： /lib/terminfo

	依着葫芦画瓢吧~， 在开发板上建立 /lib/terminfo，拷贝配置文件
		
		export TERM=xterm
		vim

	很遗憾，依然是黑白分明，彩色在哪里~~~~！！！

	继续 `Google大神`......  
	....  
	....   
	....  

		Terminfo 的数据已经编译成了非文本格式，必须使用 infocmp 这个程序来读取数据并翻译成纯文本。
		
		例如： 
		显示VT100 数据： infocmp vt100 
		显示当前使用的终端的数据： infocmp

	这段文字给了我一些启发，于是在ubuntu上试着运行
		
		shmily@Dell: /lib/terminfo $ infocmp lib/terminfo/v/vt100
		infocmp: couldn't open terminfo file lib/terminfo/v/vt100.

	什么情况，怎么会找不到呢？ 继续

		shmily@Dell: /lib/terminfo $ infocmp vt100
		#       Reconstructed via infocmp from file: /lib/terminfo/v/vt100
		vt100|vt100-am|dec vt100 (w/advanced video),
		        am, mc5i, msgr, xenl, xon,
		        cols#80, it#8, lines#24, vt#3,
		        acsc=``aaffggjjkkllmmnnooppqqrrssttuuvvwwxxyyzz{{||}}~~,
		        bel=^G, blink=\E[5m$<2>, bold=\E[1m$<2>,
		        clear=\E[H\E[J$<50>, cr=^M, csr=\E[%i%p1%d;%p2%dr,
		        cub=\E[%p1%dD, cub1=^H, cud=\E[%p1%dB, cud1=^J,
		        cuf=\E[%p1%dC, cuf1=\E[C$<2>,
		        cup=\E[%i%p1%d;%p2%dH$<5>, cuu=\E[%p1%dA,
		        cuu1=\E[A$<2>, ed=\E[J$<50>, el=\E[K$<3>, el1=\E[1K$<3>,
		        enacs=\E(B\E)0, home=\E[H, ht=^I, hts=\EH, ind=^J, ka1=\EOq,
		        ka3=\EOs, kb2=\EOr, kbs=^H, kc1=\EOp, kc3=\EOn, kcub1=\EOD,
		        kcud1=\EOB, kcuf1=\EOC, kcuu1=\EOA, kent=\EOM, kf0=\EOy,
		        kf1=\EOP, kf10=\EOx, kf2=\EOQ, kf3=\EOR, kf4=\EOS, kf5=\EOt,
		        kf6=\EOu, kf7=\EOv, kf8=\EOl, kf9=\EOw, lf1=pf1, lf2=pf2,
		        lf3=pf3, lf4=pf4, mc0=\E[0i, mc4=\E[4i, mc5=\E[5i, rc=\E8,
		        rev=\E[7m$<2>, ri=\EM$<5>, rmacs=^O, rmam=\E[?7l,
		        rmkx=\E[?1l\E>, rmso=\E[m$<2>, rmul=\E[m$<2>,
		        rs2=\E>\E[?3l\E[?4l\E[?5l\E[?7h\E[?8h, sc=\E7,
		        sgr=\E[0%?%p1%p6%|%t;1%;%?%p2%t;4%;%?%p1%p3%|%t;7%;%?%p4%t;5%;m%?%p9%t\016%e\017%;$<2>,
		        sgr0=\E[m\017$<2>, smacs=^N, smam=\E[?7h, smkx=\E[?1h\E=,
		        smso=\E[7m$<2>, smul=\E[4m$<2>, tbc=\E[3g,

	这会是对了，看来这个 /lib/terminfo/ 路径不是固定的啊~~，到底是怎么来的呢？

	在之前的 ncurses-5.9 交叉编译的过程，还生成了  arm-linux-infocmp 文件  
	下载到目标板上，运行

		arm-linux-infocmp vt100
		infocmp: couldn't open terminfo file /home/shmily/armLinux/Rpi/ncurses-5.9/_install/lib/terminfo/v/vt100
	
	原来这个路径是和 ncurses 编译安装时的路径有关的，于是把 terminfo/ 拷贝到 目标板 /home/shmily/armLinux/Rpi/ncurses-5.9/_install/lib/ 下，运行 vim

	终于，有颜色了~~~~！！！


PS ：
		
		resize 命令 ： 更新当前的终端窗口大小，在使用串口终端是，总是显示不完整，resize后就好了
		
		交叉编译时使用 --host 配置选项， 假设交叉工具为 ： arm-bcm2708hardfp-linux-gnueabi-gcc
		./configure --host=arm-bcm2708hardfp-linux-gnueabi 可以指定编译工具的前缀
