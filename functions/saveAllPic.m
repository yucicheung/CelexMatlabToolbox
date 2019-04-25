function [] = saveAllPic( events,eventDelta,saveDir )
%function [] = saveAllPic( events,eventDelta,saveDir )
%
% Save binary pics, gray pics and accumulated gray pics at the same time,
% which will be saved under the folder
% 'binaryPics','grayPics','accumulatedGrayPics' in specified directory
% 'saveDir'.
% 
% Takes in:
%     'events'
%         The stuct of events containing fields x,y,adc,t.
%     'eventsDelta'
%         The amount of events to form each picture.
%     'saveDir'
%         The directory to place the folders for storing different pics. 
%     
% Written by YuxinZhang - June 27th,2018
    

% Varargin check
assert(length(events.x)==length(events.y),'Length of x,y should be equal!');
narginchk(3,3);
grayDir=fullfile(saveDir,'grayPics');
binaryDir=fullfile(saveDir,'binaryPics');
accumulatedDir=fullfile(saveDir,'accumulatedGrayPics');
dirChk(grayDir),dirChk(binaryDir),dirChk(accumulatedDir)

% Variable set-up
global X Y
len=length(events.x);
grayImg=zeros(Y,X);
accumulatedGrayImg=zeros(Y,X);
binaryImg=zeros(Y,X);

% Get images and show
imgIndex=1;
stopNum=fix(len/eventDelta);
eventsXBuffer=zeros(1,eventDelta,'uint16');
eventsYBuffer=zeros(1,eventDelta,'uint16');
eventsAdcBuffer=zeros(1,eventDelta,'uint16');
pos=zeros(1,2,'uint16');

fprintf('Start saving all images...\n')
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
    imgIndexStr=num2str(imgIndex);
    normAccGrayImg=normalizePic(accumulatedGrayImg);
    grayImg=normalizePic(grayImg);
    grayPath=fullfile(grayDir,sprintf('%s.jpg',imgIndexStr));
    binaryPath=fullfile(binaryDir,sprintf('%s.jpg',imgIndexStr));
    accumulatedPath=fullfile(accumulatedDir,sprintf('%s.jpg',imgIndexStr));
    imwrite(grayImg,grayPath);
    imwrite(binaryImg,binaryPath);
    imwrite(normAccGrayImg,accumulatedPath);
    binaryImg(:)=0;
    grayImg(:)=0;
    imgIndex=imgIndex+1;
end
fprintf('Finished saving all images.\n')
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
