function events = getCroppedEvents(events,startEventsNum,eventsSum)
% function events = getCroppedEvents(eventsMatPath,startEventsNum,eventsSum)
% 
% Crop the certain amount('eventsSum') of events starting from index
% 'startEventsNum'.
%
% Takes in:
%     'events'
%         The struct that contains fields x,y,adc,t.
%     'startEventsNum'
%         The index of the first event to be returned.
%     'eventsSum'
%         The total amount of events to be returned.
% 
% Returns:
%     'events'
%         A event struct that contains fields x,y,adc,t, which consists of
%         a certain section that user specified.
% 
% Written by Yuxin Zhang - Jun 21st,2018

narginchk(3,3);

stopNum=startEventsNum+eventsSum-1;
events.x=events.x(startEventsNum:stopNum);
events.y=events.y(startEventsNum:stopNum);
events.adc=events.adc(startEventsNum:stopNum);
events.t=events.t(startEventsNum:stopNum);
fprintf('Returned %s events starting from index %s\n.',num2str(eventsSum),num2str(startEventsNum))

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
