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
% Accumulate pic using certain amount of events
% 
% Author:Yuxin Zhang
% Date:2018-6-12
%   - Read from bin file and decode events; 
%   - Visualize by accumulating certain amount of events;
%   - Visualize in binary mode or accumulated gray mode;
%   - Save binary pic or accumulated gray pic;
% Usage:
%   - User should modify the variables in "User variables set-up" part to
%   make it work for you.
%   - Variables introduction are given in form of comments in "User
%   variables set-up" part.
% ----------------------------------------------------------------------- %
%% User variables set-up
close all;clear;clc;
% general variables
fileName='Recording_20180705_124529343_E_25MHz_tennis_thresh40.bin';
fileDir='D:\03DVS_BinFile\ver2_1\classifiedBin';

displayTime=1e-11;% time for each picture to display
startEvents=0;% to skip the first <startEvents> of events
eventDelta=1e4;% num of events to form a pic

% for saving image
saveDir='D:\03DVS_BinFile\ver2_1\pics';% directory to save gray/binary pics
saveBinary=0;% whether to save bianry pics
saveGray=0;% whether to save accumulated gray pics
saveFormats=["jpg","jpeg","bmp","png","tiff"];
saveFormat=saveFormats(3);% 3 for "bmp"

% for showing image
showBinary=0;% whether to display the binary pic
showGray=0;% whether to display the accumulated gray pic

%% Non-user variables set-up
X=768;
Y=640;
bytesPerEvent=4;
bytesPerDelta=eventDelta*bytesPerEvent;
binaryImg=zeros(Y,X);
accumulatedGrayImg=zeros(Y,X);
grayImg=zeros(Y,X);
normalizedGray=zeros(Y,X); % range in [0,1]
filepath=fullfile(fileDir,fileName);
grayDir=fullfile(saveDir,'gray');
binaryDir=fullfile(saveDir,'binary');
grayPath='';
binaryPath='';
if exist(saveDir,'dir')==0
    mkdir(saveDir)
end
if saveBinary&&(exist(binaryDir,'dir')==0)
    mkdir(binaryDir)
end
if saveGray&&(exist(grayDir,'dir')==0)
    mkdir(grayDir)
end

%% Read in binary data from bin file
fid=fopen(filepath);
% sync to the 1st row event
while true
    judgeEvent=fread(fid,bytesPerEvent,'uint8');
    if isRow(judgeEvent)
        fseek(fid,4,-1);
        break
    end
end
[bytes,bytesCount]=fread(fid,'uint8');
% get pixel data
eventCount=0;
events_x=zeros(1,bytesCount,'uint16');
events_y=zeros(1,bytesCount,'uint16');
events_adc=zeros(1,bytesCount,'uint16');
events_timestamp=zeros(1,bytesCount,'uint32');

%% Prepare data for image showing/saving
x=uint16(0);
y=uint16(0);
a=uint16(0);
t=uint32(0);
c=uint8(0);
bytesIndex=1;
stopNum=bytesCount-mod(bytesCount,eventDelta*bytesPerEvent);
while bytesIndex<stopNum
    byte0=bytes(bytesIndex);
    byte1=bytes(bytesIndex+1);
    byte2=bytes(bytesIndex+2);
    byte3=bytes(bytesIndex+3);
    switch(byte3)
        case 0
            %col event
            x=uint16(mod(byte0,128));%X[6:0]
            x=x+bitshift((mod(byte1,64)-mod(byte1,16)),3);%X[8:7]
            c=uint8(bitshift(byte1,-6));%C[0]
            if c==1
                x=767-x;
            end
            a=uint16(mod(byte1,16));%A[3:0]
            a=a+bitshift(mod(byte2,32),4);%A[8:4]
            % save pixel data
            eventCount=eventCount+1;
            events_x(eventCount)=x;
            events_y(eventCount)=y;
            events_adc(eventCount)=a;
            events_timestamp(eventCount)=t;
        case 255
            % special event
            bytesIndex=bytesIndex+4;
            continue
        otherwise
            %row event
            y=uint16(mod(byte0,128));%Y[6:0]
            y=y+bitshift((mod(byte1,128)-mod(byte1,16)),3);%Y[9:7]
            t=uint32(mod(byte1,16));%T[3:0]
            t=t+bitshift(mod(byte2,128),4);%T[10:4]
            t=t+bitshift(mod(byte3,64),11);%T[16:11]
            bytesIndex=bytesIndex+4;
            continue
    end
    % turn upside down
    binaryImg(Y-y,x+1)=255;
    accumulatedGrayImg(Y-y,x+1)=a;
    grayImg(Y-y,x+1)=a;
    if (bytesIndex~=1)&&(mod(bytesIndex-1,bytesPerDelta)==0)
        picIndex=bytesIndex/bytesPerDelta;
        picIndexStr=num2str(picIndex);
        % img show
        if showBinary&&showGray
            subplot(1,2,1),imshow(binaryImg,[]),title(sprintf("Binary Pic%s",picIndexStr))
            subplot(1,2,2),imshow(accumulatedGrayImg,[]),title(sprintf("Gray Pic%s",picIndexStr))
            pause(displayTime)
        elseif showBinary&&(~showGray)
            imshow(binaryImg,[]),title(sprintf("Binary Pic%s",picIndexStr))
            pause(displayTime)
        elseif (~showBinary)&&showGray
            imshow(accumulatedGrayImg,[]),title(sprintf("Gray Pic%s",picIndexStr))
            pause(displayTime)
        end
        % img save
        if saveBinary
            binaryPath=sprintf('%s\\%s.%s',binaryDir,picIndexStr,saveFormat);
            fprintf('saving %s\n',binaryPath);
            imwrite(binaryImg,binaryPath)
        end
        if saveGray
            grayPath=sprintf('%s\\%s.%s',grayDir,picIndexStr,saveFormat);
            fprintf('saving %s\n',grayPath);
            normalizedGray=(accumulatedGrayImg-min(min(accumulatedGrayImg)))/(max(max(accumulatedGrayImg)));
            imwrite(normalizedGray,grayPath)
        end
        binaryImg=zeros(Y,X);
        grayImg=zeros(Y,X);
    end
    bytesIndex=bytesIndex+4;
end
% Neglect the left events when the amount is not enough to form a pic.
disp("Done.")
disp("Saving mat files.")
matDir='D:\03DVS_BinFile\ver2_1\mat\';% directory to save mat
if (exist(binaryDir,'dir')==0)
    mkdir(matDir)
end
matName=fileName;
matName(end-2:end)='mat';
matPath=fullfile(matDir,matName);
save(matPath,'events_x','events_y','events_adc','events_timestamp','-append')

fclose(fid);

function [flag]=isRow(event)
        if (event(1)&&event(2)&&event(3)&&event(4))
            flag=true;
        else
            flag=false;
        end
end