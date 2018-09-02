% ----------------------------------------------------------------------- %
% Copyright 2018 Yuxin Zhang
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
% ----------------------------------------------------------------------- %
%% Global Variable set-up
close all;clear;clc;
global X Y upperADC lowerADC bytesPerEvent timeResolution
X=768;
Y=640;
upperADC=511;
lowerADC=0;
bytesPerEvent=4;
timeResolution=4e-5; %ms
%% Convert all events to pixels in format [x,y,a,t] and save as mat in memory-efficient way
binName='Recording_20180705_124529343_E_25MHz_tennis_thresh40.bin';
binDir='D:/03DVS_BinFile/ver2_1/classifiedBin';

binPath=fullfile(binDir,binName);
eventsMatDir='.';
eventsMatName='events.mat';
eventsMatPath=fullfile(eventsMatDir,eventsMatName);

events=getAllEventsAndSaveAsMat(binPath,eventsMatPath);

%% Crop a user-specified section out of all events
startEventsNum=200;
eventsSum=1000;
eventsMatDir='.';
eventsMatName='events.mat';

events=loadEventsMat(eventsMatPath);
croppedEvents=getCroppedEvents(events,startEventsNum,eventsSum);

%% Show binary/gray/accumulated gray pic
eventDelta=2e4;% The amount of events to form a pic
displayTime=1e-11;% time for each picture to display;
saveDir='D:/03DVS_BinFile/pics';

% showAllPic(events,eventDelta,displayTime);
showBinaryPic(events,eventDelta,displayTime);
% showGrayPic(events,eventDelta,displayTime);
% showAccumulatedGrayPic(events,eventDelta,displayTime);

saveAllPic(events,eventDelta,saveDir);
% saveBinaryPic(events,eventDelta,saveDir);
% saveGrayPic(events,eventDelta,saveDir);
% saveAccumulatedGrayPic(events,eventDelta,saveDir);

%% Show 3D event flow  by converting to continous time flow
showEventsFlow3D(events);

%% Show denoised binary/gray/accumulated gray pic
eventDelta=5e4;% The amount of events to form a pic
displayTime=1e-11;% time for each picture to display;
saveDir='D:/03DVS_BinFile/pics/';
fpnTxtPath=fullfile('D:\00DVS\CeleX-IV\Version_2_1\Release_V21_Windows\DemoGUI\EXE\CelePixelDemo_x64','FPN.txt');

% saveDenoisedBinaryComparison(events,eventDelta,saveDir)
% saveDenoisedBinaryPic(events,eventDelta,saveDir)
% saveDenoisedGrayComparison(events,eventDelta,saveDir)
% saveDenoisedGrayPic(events,eventDelta,saveDir)

showDenoisedBinaryComparison(events,eventDelta,displayTime)
% showDenoisedBinaryPic(events,eventDelta,displayTime)
% showDenoisedGrayPic(events,eventDelta,displayTime)
% showDenoisedGrayComparison(events,eventDelta,displayTime)

%% Accumulate Pic  by timeInterval
timeDelta=10;  % ms
displayTime=25; % ms
startPer=0.2;  % percent of index to start
endPer=0.3;     % percent of index to end
skipPic=0;   % num of skipped pics from the start index under order of "timeDelta"

showBinaryPicByTimeInteval(events,timeDelta,displayTime,startPer,endPer,skipPic);