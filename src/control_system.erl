-module(control_system).

-include("config.hrl").

%% API
-export([control_system/3]).

control_system(Elevator, Floors, Queued_floors_numbers) ->
  receive
    {button_pressed, Floor_number} ->
      Current_floor = Elevator ! {get_floor, self()},
      Destination = check_destination(Current_floor, Floor_number),
      Elevator ! {move, Destination}
  end.



