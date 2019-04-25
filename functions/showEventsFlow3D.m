function [] = showEventsFlow3D( events )
%function [] = showEventsFlow3D( events )
%
% Show 3D events flow.
% 
% Takes in:
%     'events'
%         The stuct of events containing fields x,y,adc,t.
% 
% Written by YuxinZhang - June 27th,2018

% Varargin check
narginchk(1,1);

% Variable set-up
global X Y
eventDelta=1e5;
showStep=eventDelta/5;
displayTime=1e-2;

% Get 3D events flow and show
events.y=Y-events.y+1;% copy-on-write
xBuffer=zeros(1,eventDelta,'uint16');
yBuffer=zeros(1,eventDelta,'uint16');
tBuffer=linspace(eventDelta,1,eventDelta);

startIndex=1;
stopIndex=eventDelta;
showIndex=1;
stopNum=fix((length(events.x)-eventDelta)/showStep);
while (showIndex<=stopNum)
    xBuffer(:)=events.x(startIndex:stopIndex);
    yBuffer(:)=events.y(startIndex:stopIndex);
    scatter3(tBuffer,xBuffer,yBuffer,'.g');
    axis([1 eventDelta 1 X 1 Y])
    xlabel('Index of Events'),ylabel('Row'),zlabel('Col')
    title('3D Events Flow')
    view(145,15)
    pause(displayTime)
    startIndex=startIndex+showStep;
    stopIndex=stopIndex+showStep;
    showIndex=showIndex+1;
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

