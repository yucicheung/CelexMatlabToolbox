function [] = showAllPic(events,eventDelta,displayTime)
%function [] = showAllPic(events,eventDelta,displayTime)
%
% Show binary,gray,acumulated gray images at the same time. Pics are
% formed by accumulating a number of events.
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
warning off

% Variable set-up
global X Y
len=length(events.x);
grayImg=zeros(Y,X);
accumulatedGrayImg=zeros(Y,X);
binaryImg=zeros(Y,X);
concatImg=zeros(Y,X*3);

% Get images and show
imgIndex=1;
stopNum=fix(len/eventDelta);
eventsXBuffer=zeros(1,eventDelta,'uint16');
eventsYBuffer=zeros(1,eventDelta,'uint16');
eventsAdcBuffer=zeros(1,eventDelta,'uint16');
pos=zeros(1,2,'uint16');

while (imgIndex<=stopNum)
    startEventIndex=(imgIndex-1)*eventDelta+1;
    stopEventIndex=imgIndex*eventDelta;
    eventsXBuffer(:)=events.x(startEventIndex:stopEventIndex);
    eventsYBuffer(:)=events.y(startEventIndex:stopEventIndex);
    eventsAdcBuffer(:)=events.adc(startEventIndex:stopEventIndex);
    eventIndex=1;
    while eventIndex<=eventDelta
        pos(1)=eventsYBuffer(eventIndex);
        pos(2)=eventsXBuffer(eventIndex);
        adc=eventsAdcBuffer(eventIndex);
        grayImg(pos(1),pos(2))=adc;
        accumulatedGrayImg(pos(1),pos(2))=adc;
        binaryImg(pos(1),pos(2))=255;
        eventIndex=eventIndex+1;
    end
    normAccGrayImg=normalizePic(accumulatedGrayImg);
    grayImg=normalizePic(grayImg);
    concatImg(:,1:X)=binaryImg;
    concatImg(:,(X+1):(2*X))=normAccGrayImg;%normAccGrayImg;
    concatImg(:,(2*X+1):(3*X))=grayImg;
    imshow(concatImg)
    title(sprintf('Binary pic /Accumulated gray pic / Gray pic %s',num2str(imgIndex)))
    pause(displayTime)
    binaryImg(:)=0;
    grayImg(:)=0;
    imgIndex=imgIndex+1;
end
close
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
