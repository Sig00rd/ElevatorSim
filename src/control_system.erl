-module(control_system).

-include("config.hrl").

%% API
-export([control_system/3]).

control_system(Elevator, Floors, Queued_floors) ->
  receive
    {button_pressed, Floor_number} ->
      New_queued_floors = sets:add_element(Queued_floors, Floor_number),
      control_system(Elevator, Floors, New_queued_floors)
      %Current_floor = Elevator ! {get_floor, self()},
      %Destination = check_destination(Current_floor, Floor_number),
      %Elevator ! {move, Destination}
  end.
