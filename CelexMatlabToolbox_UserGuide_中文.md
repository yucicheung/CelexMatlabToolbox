# CelexMatlabToolbox用户文档

## 基本介绍

CelexMatlabToolbox是针对Celex IV的采集数据进行处理的Matlab工具箱。

- **文件结构及功能说明**
  - `createImgFromRawData.m`(即上一版发布的文件`bin2picByFixedAmountOfEvents.m`)
    - 针对bin文件实时解码
    - 二值图像的实时显示及存储；
    - 灰度图像的实时显示及存储；
    - 累积式灰度图的实时显示及存储；
  - 函数集合`functions`
    - 对bin文件进行批量解码为`x,y,adc,t`格式(其中`t`为连续时间)；
    - 将解码事件转存为mat文件及其读取；
    - 二值图的显示及存储；
    - 灰度图的显示及存储；
    - 累积式灰度图的显示及存储；
    - 去噪二值图的显示及存储；
    - 去噪灰度图的显示及存储；
    - 事件流的三维动态显示。
  - `demo.m`
    - 可运行的示例文件，提供对所有工具箱函数的调用示例。

## 使用说明

- 使用前
  - 请右键点击`CelexMatlabToolbox`包含文件夹及其子文件夹；
  - 根据自己的需要修改`demo.m`中相应路径。
- 对于`functions`中每个函数都含有相应的功能及输入输出描述，具体请使用`help`+函数名查看，如`help showAllPic`;
- 所有函数输入输出示例均可以在`demo.m`文件中查看。
- 本工具箱对GUI版本1.4及2.1录制数据均兼容。



## `functions`用户接口介绍

- **批量解码及文件格式转存、读取和截取**

| 函数原型                                                     | 功能描述                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `events=getAllEventsAndSaveAsMat(binPath,eventsMatPath)`     | 从`binPath`对应路径读取bin文件，解码为含有[x,y,a,t]的结构体`events`并将其作为返回值。同时在`eventsMatPath`路径下存储解码后的mat文件 |
| `events=loadEventsMat(eventsMatPath)`                        | 从`eventsMatPath`中读取`events`结构体并返回                  |
| `croppedEvents=getCroppedEvents(events,startEventsNum,eventsSum)` | 从`events`结构体中截取从`startEventNum`开始的`eventSum`个事件，以相同形式结构体返回 |

**注意:**为了节省保存空间，我们使用4个数据类型不同的`array`（分别是`events_X`,`events_y`,`events_adc`,`events_t`）来保存事件数据，而非直接保存结构体，要读取`events.mat`为结构体，请调用`loadEventsMat`函数。



- **2D图片的可视化和存储**

| 函数原型                                                | 功能描述                                                     |
| ------------------------------------------------------- | ------------------------------------------------------------ |
| `showAllPic(events,eventDelta,displayTime)`             | 显示*二值图*，*灰度图*和*累积式灰度图*。拼接图像<br>每张图片由`events`结构体中顺序选取`eventsDelta`个事件合成，每张图片显示时长为`displayTime`。 |
| `showBinaryPic(events,eventDelta,displayTime)`          | 显示*二值图片*                                               |
| `showGrayPic(events,eventDelta,displayTime)`            | 显示*灰度图*                                                 |
| `showAccumulatedGrayPic(events,eventDelta,displayTime)` | 显示*累积式灰度图*                                           |
| `saveAllPic(events,eventDelta,saveDir)`                 | 同时存储*二值图*，*灰度图*和*累积式灰度图*<br>每张图片由`events`结构体中顺序选取`eventsDelta`和事件合成，分别存储在`saveDir`下的`binaryPics`、`grayPics`和`accumulatedGrayPics`文件夹中 |
| `saveBinaryPic(events,eventDelta,saveDir)`              | 存储*二值图*                                                 |
| `saveGrayPic(events,eventDelta,saveDir)`                | 存储*灰度图*                                                 |
| `saveAccumulatedGrayPic(events,eventDelta,saveDir)`     | 存储*累积式灰度图*                                           |



- **去噪图片的可视化及存储**

| 函数原型                                                     | 功能描述                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `showDenoisedBinaryComparison(events,eventDelta,displayTime)` | 显示*二值图*和*去噪二值图*拼接图像。<br>每张图片由`events`结构体中顺序选取`eventDelta`个事件合成，每张图片显示时长为`displayTime` |
| `showDenoisedBinaryPic(events,eventDelta,displayTime)`       | 显示*去噪二值图*                                             |
| `saveDenoisedGrayComparison(events,eventDelta,saveDir)`      | 显示*灰度图*和*去噪灰度图*拼接图像。                         |
| `showDenoisedGrayPic(events,eventDelta,displayTime)`         | 显示*去噪灰度图*                                             |
| `saveDenoisedGrayComparison(events,eventDelta,saveDir)`      | 存储*二值图*和*去噪二值图*拼接图像。<br>每张图片由`events`结构体中顺序选取`eventDelta`个事件合成，存储在`saveDir`下的`denoisedGrayComparison`文件夹中 |
| `saveDenoisedGrayPic(events,eventDelta,saveDir)`             | 存储*去噪灰度图*于`saveDir`下的`denoisedGrayPics`文件夹中    |
| `saveDenoisedBinaryComparison(events,eventDelta,saveDir)`    | 存储*二值图*和*去噪二值图*拼接图像于`saveDir`下的`denoisedBinaryComparison`文件夹中 |
| `saveDenoisedBinaryPic(events,eventDelta,saveDir)`           | 存储*去噪二值图*于`saveDir`下的`denoisedBinaryPics`文件夹中  |



- **3D事件流动态显示**

| 函数原型                     | 功能描述                                   |
| ---------------------------- | ------------------------------------------ |
| `showEventsFlow3D( events )` | 根据输入的`events`结构体动态显示三维事件流 |
