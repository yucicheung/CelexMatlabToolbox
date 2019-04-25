function [] = saveDenoisedBinaryPic(events,eventDelta,saveDir)
%function [] = saveDenoisedBinaryPic( events,eventDelta,saveDir )
%
% Save denoised binary pics under the floder 'denoisedBinaryPics' in 
% specified directory 'saveDir'.
% 
% Takes in:
%     'events'
%         The stuct of events containing fields x,y,adc,t.
%     'eventsDelta'
%         The amount of events to form each picture.
%     'saveDir'
%         The directory to place the folder for storing pics. 
%     
% Written by YuxinZhang - June 27th,2018

% Varargin check
assert(length(events.x)==length(events.y),'Length of x,y should be equal!');
narginchk(3,3);
saveDir=fullfile(saveDir,'denoisedBinaryPics');
dirChk(saveDir)

% Variable set-up
global X Y
len=length(events.x);
denoisedBinaryImg=zeros(Y,X);
heatMap=zeros(Y,X);

% Get images and show
imgIndex=1;
stopNum=fix(len/eventDelta);
eventsXBuffer=zeros(1,eventDelta,'uint16');
eventsYBuffer=zeros(1,eventDelta,'uint16');

fprintf('Start saving denoised binary images...\n')
while (imgIndex<=stopNum)
    startEventIndex=(imgIndex-1)*eventDelta+1;
    stopEventIndex=imgIndex*eventDelta;
    eventsXBuffer(:)=events.x(startEventIndex:stopEventIndex);
    eventsYBuffer(:)=events.y(startEventIndex:stopEventIndex);
    eventIndex=1;
    while eventIndex<=eventDelta
        row=eventsYBuffer(eventIndex);
        col=eventsXBuffer(eventIndex);
        denoisedBinaryImg(row,col)=255;
        heatMap(row,col)=heatMap(row,col)+1;
        eventIndex=eventIndex+1;
    end
    weightMap=getWeightMap(heatMap);
    denoisedBinaryImg=denoisedBinaryImg.*weightMap;
    imwrite(denoisedBinaryImg,fullfile(saveDir,sprintf('%s.jpg',num2str(imgIndex))));
    denoisedBinaryImg(:)=0;
    heatMap(:)=0;
    imgIndex=imgIndex+1;
end
fprintf('Finished saving denoised binary images.\n')
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