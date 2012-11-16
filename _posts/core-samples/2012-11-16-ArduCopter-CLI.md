---
layout: post
category : ArduCopter
tags : [ArduCopter]
---
{% include JB/setup %}

【译】ArduCopter CLI 命令记录
===========================

“setup”菜单
----------

	* erase			-- 擦除 EEPROMS
	* reset 		-- 重置 EEPROMS 为默认数据
	* radio 		-- 记录遥控器各通道的上限和下限 - 非常重要！！!
	* pid			-- 重置默认 PID 参数（如果你曾经改变过）
	* frame			-- 设置飞行器模式：[x, +, tri, hexax, hexa+, y6]
	* motors		-- 电机和电调设置
	* level			-- 水平参数设置，执行这个命令时，保持飞行器水平于地面
	* modes			-- 设置每个飞行模式对应的操纵杆位置（一共有5种模式）
	* current		-- 设置电流传感器	:[开、关]
	* compass		-- 设置地磁传感器	:[开、关]
	* declination	-- 设置当地的磁偏角 -- 可以再网上找[10进制]
	* sonar 		-- 声纳设置
	* show			-- 输出显示所有的参数



“test”菜单
---------
	
	* pwm			-- 输出各通道对应的 PWM
	* radio			-- 输出对应于遥控器 8 个通道的控制值
	* gps 			-- 输出 GPS 数据
	* rawgps		-- 输出原始的 GPS 数据
	* adc			-- 输出 ADC 原始数据
	* imu			-- 输出欧拉角信息
	* battery 		-- 输出电池电量
	* current 		-- 输出电流信息
	* relay			-- 翻转 relay
	* sonar			-- 输出声纳传感器的值（单位：cm）
	* waypoints		-- 废除已有的 waypoints 命令
	* airpressure	-- 输出空气压力
	* compass		-- 输出地磁角度（0：正北）
	* xbee			-- ？
	* mission		-- 向 EEPROMS 写入一个默认的命令 [未实现，'wp']
					-- 如果写入'wp',飞行器会向东飞行15米然后回来
	* eedump		-- 按字节输出 EEPROMS 中的原始数据
	

“logs”菜单
---------
	
	参考 APM 的 wiki 以获取更详尽的信息


ACM 飞行模式
-----------
	
	* ACRO			-- rate 控制. 不适合初学者
	* STABLIZE		-- 根据 roll 和 pitch 操纵杆的输入确定一个保持角度.油门手动
	* SIMPLE		-- 保持第一次进入此模式时的yaw方向.油门手动
	* ALT_HOLD		-- 通过油门控制飞行器高度。
					-- 中间=保持，高=上升，低=下降
	* LOITER		-- 保持当前的 altitude、position 和 yaw.
					-- yaw 可以通过操纵杆改变
					-- roll 和 pitch 可以通过 radio 临时改变
					-- altitude，通过油门改变
	* RTL			-- 将会尝试从当前高度飞回起点
	* AUTO			-- 执行由 Waypoint writter 写入的飞行任务
	* GUIDED		-- 可以通过地面控制站GCS进行交互飞行

