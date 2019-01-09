-module(control_system).

-include("config.hrl").

%% API
-export([control_system/2]).

control_system(Elevator, Floors) ->
  control_system(Elevator, Floors, [], 0).

control_system(Elevator, Floors, Queued_floors, Current_direction) ->
  receive
    {button_pressed, Floor_number} ->
      New_queued_floors = sets:add_element(Queued_floors, Floor_number),
      control_system(Elevator, Floors, New_queued_floors, Current_direction)
  end.


%get current floor
%