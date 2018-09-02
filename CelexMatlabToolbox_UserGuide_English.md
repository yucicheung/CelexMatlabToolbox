# CelexMatlabToolbox User Guide

## Introduction

CelexMatlabToolbox is a matlab toolbox to process the events collected using Celex IV Dynamic Vision Sensor.

- **File structure and Functions**
  - `createImgFromRawData.m`
    - Real-time decoding of events from raw data.
    - Real-time showing and saving binary pics from raw data.
    - Real-time showing and saving gray pics from raw data..
    - Real-time showing and saving accumulated gray pics from raw data..
  - `functions`: a collection of matlab functions.
    - Decode from raw data(`.bin` file) in batches and return events in format of `x,y,adc,t`，where `t`  is the **continuous time stamp**.
    - Save decoded events as mat file in memory-efficient way.
    - Load events from mat file.
    - Show and save binary pics from events.
    - Show and save gray pics from events.
    - Show and save accumulated gray pics from events.
    - Show and save denoised binary pics from events.
    - Show and save denoised gray pics from events.
    - Display 3D events flow from events.
    - Accumulate frames by specified time interval in certain range (in percentage), and user can skip the first specified amount of frames if needed and also determine the time for each frame to show.
  - `demo.m`
    - An executable demo file, which includes all sample usage to call the functions in folder `functions`.

## Usage

- Before you use
  - Right click on the `CelexMatlabToolbox` folder to **include folder and its subfolders**；
  - Modify the directory and filepath in `demo.m` .
- For each function in `functions` folder,  the description of its corresponding function, input and output is offered. To read the description, please run `help <functionName>` ，for instance`help showAllPic`.
- You can find sample usage of all functions in `demo.m`.



## `functions` API Intruduction

- **Decode from bin file, save and load events and crop them**

| Prototype                                                    | Description                                                  |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `events=getAllEventsAndSaveAsMat(binPath,eventsMatPath)`     | Read bin file  from `binPath`，decode raw data into `events` struct of format [x,y,a,t] and return the struct, meanwhile save the events as mat file specified by `eventsMatPath`. |
| `events=loadEventsMat(eventsMatPath)`                        | Read `events` struct from `eventsMatPath` and return it.     |
| `croppedEvents=getCroppedEvents(events,startEventsNum,eventsSum)` | Crop a length of `eventSum` events from `events ` struct starting from index `startEventNum`. |

**Notice:**To save storage space, the decoded event  data is stored in 4 arrays (`events_X`,`events_y`,`events_adc`,`events_t`)of different data type instead of saving the `events` struct. To get the `events` struct, call function `loadEventsMat`.



- **Showing and saving 2D pics**

| Prototype                                               | Description                                                  |
| :------------------------------------------------------ | :----------------------------------------------------------- |
| `showAllPic(events,eventDelta,displayTime)`             | Show the concatenated pic of  pics in *binary*, *gray*, *accumulatedGray*  mode.<br>Each pic is formed by accumulating events of the number of `eventsDelta`, and each pic will be shown for some time specified in`displayTime`. |
| `showBinaryPic(events,eventDelta,displayTime)`          | Show *binary pic*.                                           |
| `showGrayPic(events,eventDelta,displayTime)`            | Show *gray pic*.                                             |
| `showAccumulatedGrayPic(events,eventDelta,displayTime)` | Show *accumulated gray pic*                                  |
| `saveAllPic(events,eventDelta,saveDir)`                 | Save *binary pic, gray pic, accumulated gray pic* at the same time.<br>Each pic is formed by accumulating events of the number of `eventsDelta`. Above pics will be saved under folders `binaryPics`, `grayPics` and `accumulatedGrayPics` in directory `saveDir`. |
| `saveBinaryPic(events,eventDelta,saveDir)`              | Save *binary pic*.                                           |
| `saveGrayPic(events,eventDelta,saveDir)`                | Save *gray pic*.                                             |
| `saveAccumulatedGrayPic(events,eventDelta,saveDir)`     | Save *accumulated gray pic*.                                 |



- **Events denosing and results saving**

| Prototype                                                    | Description                                                  |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `showDenoisedBinaryComparison(events,eventDelta,displayTime)` | Show the concatenated pic of  *binary pic and denoised binary pic* .<br>Each pic is formed by accumulating events of the number of `eventsDelta`, and each pic will be shown for some time specified in`displayTime`. |
| `showDenoisedBinaryPic(events,eventDelta,displayTime)`       | Show *denoised binary pic*.                                  |
| `saveDenoisedGrayComparison(events,eventDelta,saveDir)`      | Show the concatenated pic of  *gray pic and denoised gray pic* . |
| `showDenoisedGrayPic(events,eventDelta,displayTime)`         | Show *denoised gray pic*.                                    |
| `saveDenoisedGrayComparison(events,eventDelta,saveDir)`      | Save the concatenated pics of  *binary pic and denoised binary pic* .<br>Each pic is formed by accumulating events of the number of `eventsDelta`. Pics are saved under folder `denoisedGrayComparison` in directory `saveDir`. |
| `saveDenoisedGrayPic(events,eventDelta,saveDir)`             | Save *denoised gray pics* under folder `denoisedGrayPics` in directory `saveDir`. |
| `saveDenoisedBinaryComparison(events,eventDelta,saveDir)`    | Save the concatenated pics of  *binary pic and denoised binary pic* under folder `denoisedBinaryComparison` in directory `saveDir`. |
| `saveDenoisedBinaryPic(events,eventDelta,saveDir)`           | Save *denoised binary pics* under folder `denoisedBinaryPics` in directory `saveDir`. |



- **3D events flow showing**

| Prototype                    | Description                                                  |
| :--------------------------- | :----------------------------------------------------------- |
| `showEventsFlow3D( events )` | Dynamically show the 3D events flow based on the input `events`struct. |

- **Accumulate frames by specified time interval**

| **Prototype**                                                | **Description**                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `showBinaryPicByTimeInteval(events,timeDelta,`<br>`displayTime,startPer,endPer,skipPic)` | Based on `events`, the function form each frame by `timeDelta`(ms) in events slice ranging in` [startPer,endPer] `(in percentage).User can skip the first `skipPic` pics. Showing time for each frame is `displayTime`(ms). |

