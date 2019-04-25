function[]=showBinaryPicByTimeInteval(events,timeDelta,displayTime,startPer,endPer,skipPic)
% function[]=showBinaryPicByTimeInteval(events,timeDelta,displayTime,startPer,endPer)
%
% Show binary,gray,acumulated gray images at the same time. Pics are
% formed by accumulating a number of events.
%
% Takes in:
%     'events'
%         The stuct of events containing fields x,y,adc,t.
%     'timeDelta'
%         Determine the length of time(ms) to form a frame.
%     'displayTime'
%         The period of time for each pic to show.
%     'startPer'
%         The percent of all events to start from.
%     'endPer'
%         The percent of all events to stop at.
%     'skipPic'
%         Determine how many pics to skip counting from the startIndex 
%         which is determined by the 'startPer'.
% 
% Written by Yuxin Zhang - Sep 2nd,2018

% Varargin check
narginchk(6,6);
warning off
assert(length(events.x)==length(events.y),'Length of x,y should be equal!');
assert(startPer>0,'startPer should be more than 0!');
assert(endPer<=1,'endPer should be less than 1!');

% Variable set-up
global timeResolution X Y
timeStep=timeDelta/timeResolution;
displayTime=displayTime/1000;
len=length(events.t);
startIndex=ceil(len*startPer);
tmp=find(events.t>=(events.t(startIndex)+skipPic*timeStep));
startIndex=tmp(1);

endIndex=ceil(len*endPer);
tmp=find(events.t<=events.t(endIndex));
endIndex=tmp(end);
binaryImg=zeros(Y,X);

% Get images and show
stopNum=fix((events.t(endIndex)-events.t(startIndex))/timeStep);
imgIndex=1;
pos=zeros(1,2,'uint16');

while (imgIndex<=stopNum)
    timestampLow=events.t(startIndex);
    eventLen=length(find(events.t>=timestampLow & events.t<=(timestampLow+timeStep)));
    endIndex=startIndex+eventLen-1;
    eventsXBuffer=events.x(startIndex:endIndex);
    eventsYBuffer=events.y(startIndex:endIndex);
    eventIndex=1;
    while eventIndex<=eventLen
        pos(1)=eventsYBuffer(eventIndex);
        pos(2)=eventsXBuffer(eventIndex);
        binaryImg(pos(1),pos(2))=255;
        eventIndex=eventIndex+1;
    end
    imshow(binaryImg)
    title(sprintf('Binary pic %s',num2str(imgIndex)))
    pause(displayTime)
    binaryImg(:)=0;
    imgIndex=imgIndex+1;
    startIndex=endIndex;
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