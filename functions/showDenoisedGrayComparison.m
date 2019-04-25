function [] = showDenoisedGrayComparison( events,eventDelta,displayTime )
%function [] = showDenoisedGrayComparison(events,eventDelta,displayTime)
%
% Show concatenated pic of the gray pic and its denoised-version pic.
%
% Takes in:
%     'events'
%         The stuct of events containing fields x,y,adc,t.
%     'eventsDelta'
%         The amount of events to form each picture.
%     'displayTime'
%         The period of time for each pic to show.
% 
% Written by Yuxin Zhang - June 27th,2018

% Varargin check
assert(length(events.x)==length(events.y),'Length of x,y should be equal!');
narginchk(3,3);

% Variable set-up
global X Y
len=length(events.x);
grayImg=zeros(Y,X);
heatMap=zeros(Y,X);
concatImg=zeros(Y,X*2);

% Get images and save
imgIndex=1;
stopNum=fix(len/eventDelta);
eventsXBuffer=zeros(1,eventDelta,'uint16');
eventsYBuffer=zeros(1,eventDelta,'uint16');
eventsAdcBuffer=zeros(1,eventDelta,'uint16');

while (imgIndex<=stopNum)
    startEventIndex=(imgIndex-1)*eventDelta+1;
    stopEventIndex=imgIndex*eventDelta;
    eventsXBuffer(:)=events.x(startEventIndex:stopEventIndex);
    eventsYBuffer(:)=events.y(startEventIndex:stopEventIndex);
    eventsAdcBuffer(:)=events.adc(startEventIndex:stopEventIndex);
    eventIndex=1;
    while eventIndex<=eventDelta
        pos=[eventsYBuffer(eventIndex) eventsXBuffer(eventIndex)];
        grayImg(pos(1),pos(2))=eventsAdcBuffer(eventIndex);
        heatMap(pos(1),pos(2))=heatMap(pos(1),pos(2))+1;
        eventIndex=eventIndex+1;
    end
    weightMap=getWeightMap(heatMap);
    denoisedGrayImg=weightMap.*grayImg;
    concatImg(:,1:X)=grayImg;
    concatImg(:,X+1:end)=denoisedGrayImg;
    imshow(concatImg,[])
    title(sprintf('Gray Pic / Denoised Gray Pic %s',num2str(imgIndex)))
    pause(displayTime)
    grayImg(:)=0;
    heatMap(:)=0;
    imgIndex=imgIndex+1;
end
close
end

function [weightMap]=getWeightMap(heatMap)
thresh=sum(heatMap(:))/sum(heatMap(:)>0);
if thresh<2
    thresh=2;
else
    thresh=fix(thresh);
end
weightMap=heatMap>=thresh;
end
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