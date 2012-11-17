---
layout: post
category : ArduCopter
tags : [ArduCopter]
---
{% include JB/setup %}

ArduCopter 代码阅读记录
=====================

------------------------------------------------------------------------------

### `CLI` 接口

CLI的处理函数式`run_cli()`，是通过`GCS_MAVLINK::update()`进行调用的；  

最后封装成为：

	/*
	 *  look for incoming commands on the GCS links
	 */
	static void gcs_update(void)
	{
	    gcs0.update();
	    if (gcs3.initialised) {
	        gcs3.update();
	    }
	}


这个函数，在Arduino的loop进行了调用。

-------------------------------------------------------------------------------

### `init_ardupilot()` 函数

初始化设置   

##### 1、USB连接检查

	检查USB是否连接，如果已连接，UART0 将连接到 ATMEGA32 上，通过USB发送到 Host。  
	否则，UART0是通过无线模块连接到地面控制站的，需要延时 1s，以满足上电条件。

##### 2、初始化串口

	初始化 UART0、UART1(GPS).

##### 3、初始 I2C 总线

##### 4、初始 SPI 总线

##### 5、isr_registry.init();

	暂时不知道这个到底是干什么东东的~~

##### 6、输出版本信息

##### 7、IO设置--LED设置

##### 8、从EEPROMS载入参数

##### 9、初始化GCS

	其实就是把UART0和GCS关联起来：gcs0.init(&Serial)

##### 10、如果有 DataFlsah，初始DataFlash

##### 11、APM\_RC.setHIL(rc_override)
	
	需要进一步明确这是干什么的~~

##### 12、电机设置

##### 13、初始 timer_scheduler

	这个 timer_scheduler 暂时不知道怎么运作的~~

##### 14、初始化 GPS

##### 15、初始化压力传感器

##### 16、初始化声纳传感器

##### 17、初始化飞行模式和飞行任务

	init_commands();
	reset_control_switch();

##### 18、地面设置
	
	startup_ground();

##### 19、Log ? Limit ?


------------------------------------------------------------------------------

### `/libraries/AP_IMU/` 分析


这个文件夹下的代码主要是为加速度和陀螺仪提供校准功能的，运行在传感器驱动 `_ins` 之上。     
主函数通过调用 `AP_IMU_INS::update()` 即可得到经过校准的传感器数据。

#### IMU.h / IMU.cpp
	
声明了一个 `IMU` 类，定义了一写虚函数和几个重要的变量；函数没有具体的代码实现，都是在派生类总实现的。

重要的变量：

	AP_Vector6f    _sensor_cal;     // 传感器校准数据
	Vector3f       _accel;          // 最新的加速的数据
	Vector3f       _gyro;           // 最新的陀螺仪数据
	uint32_t       _sample_time;    // 采样时间
	
	

####  AP\_IMU\_INS.h / AP\_IMU\_INS.cpp

* init()

	输入参数如果为 `WARM_START`，表示是热启动，不进行传感器校准数据的采集，校准数据是从 EEPROM  中读取的。

	否则，进行校准数据采样计算，并保存。

* init_gyro()
	
	采集陀螺仪传感器的校准数据，并保存。具体的实现是在 `_init_gyro()` 函数中实现的。

* init_accel()
	
	采集加速度传感器的校准数据，并保存。具体的实现是在 `_init_accel()` 函数中实现的。

* update()

		_ins->update();
		_ins->get_gyros(gyros);
		_ins->get_accels(accels);
		_sample_time = _ins->sample_time();

	通过上述代码获取到传感器数据 `gyros`、`accels`，以及采样时间 `_sample_time`。

	接着进行数据校准：

	    // convert corrected gyro readings to delta acceleration
	    //
	    _gyro.x = _calibrated(0, gyros[0]);
	    _gyro.y = _calibrated(1, gyros[1]);
	    _gyro.z = _calibrated(2, gyros[2]);
		
	    // convert corrected accelerometer readings to acceleration
	    //
	    _accel.x = _calibrated(3, accels[0]);
	    _accel.y = _calibrated(4, accels[1]);
	    _accel.z = _calibrated(5, accels[2]);

	得到的数据保存在 `_gyro` 和 `_accel` 中。
