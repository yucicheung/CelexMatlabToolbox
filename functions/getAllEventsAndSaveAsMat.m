function events = getAllEventsAndSaveAsMat(binPath,eventsMatPath)
% function events = getAllEventsAndSaveAsMat(binPath,eventsMatPath)
% 
% Read and decode all events from bin file stored in 'binPath' and get
% events in struct format, which contains field [x,y,adc,t], where 'x','y'
% is the column,row index of events, 'adc' stands for brightness level of
% the pixel, and t is the **continuous timestamp**.
% 
% Takes in:
%     'binPath'
%         Full Path of the bin file to be read.
%     'eventsMatPath'
%         The path to mat file in which the events are saved.
% 
% Returns:
%     'events'
%         The events struct containing fields 'x','y','adc','t'
%         In which,
%           'x'
%               The array of column index of each event, ranging from 1 to 768.
%           'y'
%               The array of row index of each event, ranging from 1 to 639.
%           'adc'
%               The array of brightness level of each event,ranging from 0 to 511.
%           't'
%               The array of continuous timestamp of each event.
% 
% Written by Yuxin Zhang - Jun 21st,2018

% varargin check
narginchk(2,2);

% global variable setup
global X Y bytesPerEvent

% file read in
fid=fopen(binPath);
while true
    judgeEvent=fread(fid,bytesPerEvent,'uint8');
    if isRow(judgeEvent)
        fseek(fid,4,-1);
        break
    end
end
[bytes,bytesCount]=fread(fid,'uint8');

% variable set-up
timeBits=17;
timeStep=uint64(2^timeBits);
eventsCount=0;% index starting from 1
events_x=zeros(1,bytesCount,'uint16');
events_y=zeros(1,bytesCount,'uint16');
events_adc=zeros(1,bytesCount,'uint16');
events_t=zeros(1,bytesCount,'uint64');
timeBase=uint64(0);
bytesIndex=1;

%% Decoding
% decode events into x,y,a,t
fprintf('Decoding events...\n');
tic;
while bytesIndex<bytesCount
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
                x=X-1-x;
            end
            a=uint16(mod(byte1,16));%A[3:0]
            a=a+bitshift(mod(byte2,32),4);%A[8:4]
            
            % save pixel data into array
            eventsCount=eventsCount+1;
            events_x(eventsCount)=x;
            events_y(eventsCount)=y;
            events_adc(eventsCount)=a;
            events_t(eventsCount)=t;
            bytesIndex=bytesIndex+bytesPerEvent;
        case 255
            % special event
            bytesIndex=bytesIndex+bytesPerEvent;
            timeBase=timeStep+timeBase;
            continue
        otherwise
            %row event
            y=uint16(mod(byte0,128));%Y[6:0]
            y=y+bitshift((mod(byte1,128)-mod(byte1,16)),3);%Y[9:7]
            t=uint64(mod(byte1,16));%T[3:0]
            t=t+bitshift(mod(byte2,128),4);%T[10:4]
            t=t+bitshift(mod(byte3,64),11);%T[16:11]
            t=t+timeBase;
            bytesIndex=bytesIndex+bytesPerEvent;
            continue
    end
end
% coordinated correction
events_x=events_x+1;
events_y=Y-events_y;

decodeTime=toc;
fprintf('Done. Takes %ss.\n',num2str(decodeTime));

%% Trimming pixel arrays
tic;
fprintf('Trimming events...\n');
[events_x,events_y,events_adc,events_t]=trimPixelArray(events_x,events_y,...
    events_adc,events_t,eventsCount);
trimTime=toc;
fprintf('Done. Takes %ss.\n',num2str(trimTime));

%% Saving events into mat
fprintf('Saving events into mat...\n');
save(eventsMatPath,'events_x','events_y','events_adc','events_t');
fprintf('Finish getting %s events and saving them into mat file.\n',num2str(eventsCount));

%% Return events struct
events.x=events_x;
events.y=events_y;
events.t=events_t;
events.adc=events_adc;

end
function [flag]=isRow(event)
        if (event(1)&&event(2)&&event(3)&&event(4))
            flag=true;
        else
            flag=false;
        end
end

function [events_x,events_y,events_adc,events_t] = trimPixelArray(events_x,...
        events_y,events_adc,events_t,eventsCount)
    % Trim the zero pairs to reallocate the extra preallocated memory.  
    events_x=events_x(1:eventsCount);
    events_y=events_y(1:eventsCount);
    events_adc=events_adc(1:eventsCount);
    events_t=events_t(1:eventsCount);
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