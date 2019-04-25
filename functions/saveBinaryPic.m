function [] = saveBinaryPic(events,eventDelta,saveDir)
%function [] = saveBinaryPic( events,eventDelta,saveDir )
%
% Save binary pics, which will be saved under the folder 'binaryPics' in 
% specified directory 'saveDir'.
% 
% Takes in:
%     'events'
%         The stuct of events containing fields x,y,adc,t.
%     'eventsDelta'
%         The amount of events to form each picture.
%     'saveDir'
%         The directory to place the folder for storing binary pics. 
%     
% Written by YuxinZhang - June 27th,2018

% Varargin check
assert(length(events.x)==length(events.y),'Length of x,y should be equal!');
narginchk(3,3);
saveDir=fullfile(saveDir,'binaryPics');
dirChk(saveDir)

% Variable set-up
global X Y
len=length(events.x);
binaryImg=zeros(Y,X);

% Get images and show
imgIndex=1;
stopNum=fix(len/eventDelta);
eventsXBuffer=zeros(1,eventDelta,'uint16');
eventsYBuffer=zeros(1,eventDelta,'uint16');

fprintf('Start saving binary images...\n')
while (imgIndex<=stopNum)
    startEventIndex=(imgIndex-1)*eventDelta+1;
    stopEventIndex=imgIndex*eventDelta;
    eventsXBuffer(:)=events.x(startEventIndex:stopEventIndex);
    eventsYBuffer(:)=events.y(startEventIndex:stopEventIndex);
    eventIndex=1;
    while eventIndex<=eventDelta
        row=eventsYBuffer(eventIndex);
        col=eventsXBuffer(eventIndex);
        binaryImg(row,col)=255;
        eventIndex=eventIndex+1;
    end
    picPath=fullfile(saveDir,sprintf('%s%s',num2str(imgIndex),'.jpg'));
    imwrite(binaryImg,picPath)
    binaryImg(:)=0;
    imgIndex=imgIndex+1;
end
fprintf('Finished saving bianry images.\n')
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