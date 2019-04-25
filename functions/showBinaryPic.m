function [] = showBinaryPic(events,eventDelta,displayTime)
%function [] = showBinaryPic(events,eventDelta,displayTime)
%
% Show binary pic which is formed by accumulating a number of events.
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
binaryImg=zeros(Y,X);

% Get images and show
imgIndex=1;
stopNum=fix(len/eventDelta);
eventsXBuffer=zeros(1,eventDelta,'uint16');
eventsYBuffer=zeros(1,eventDelta,'uint16');
while (imgIndex<=stopNum)
    startEventIndex=(imgIndex-1)*eventDelta+1;
    stopEventIndex=imgIndex*eventDelta;
    eventsXBuffer(:)=events.x(startEventIndex:stopEventIndex);
    eventsYBuffer(:)=events.y(startEventIndex:stopEventIndex);
    eventIndex=1;
    while eventIndex<=eventDelta
        binaryImg(eventsYBuffer(eventIndex),eventsXBuffer(eventIndex))=255;
        eventIndex=eventIndex+1;
    end
    imshow(binaryImg,[])
    title(sprintf('Binary Pic %s',num2str(imgIndex)))
    pause(displayTime)
    binaryImg(:)=0;
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