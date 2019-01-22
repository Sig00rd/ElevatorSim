-module(control_system).

-include("config.hrl").

%% API
-export([control_system/2]).

control_system(Elevator, Floors) ->
  control_system(Elevator, Floors, sets:new(), 1).

control_system(Elevator, Floors, Queued_floors, Current_direction) ->
  receive
    {button_pressed, Floor_number} ->
      New_queued_floors = sets:add_element(Floor_number, Queued_floors),
      io:format("dodano piętro"),
      control_system(Elevator, Floors, New_queued_floors, Current_direction);

    {button_unpressed, Floor_number} ->
      New_queued_floors = sets:del_element(Floor_number, Queued_floors),
      control_system(Elevator, Floors, New_queued_floors, Current_direction);

    {step}  -> case sets:is_empty(Queued_floors) of
                 true -> control_system(Elevator, Floors, Queued_floors, Current_direction);
                 false -> self ! {move}
               end;

    {move} ->
      Current_floor = Elevator ! {get_floor, self()},
      Direction = handle_direction(Current_direction, Current_floor),
      Elevator ! {move, Direction},
      control_system(Elevator, Floors, Queued_floors, Direction)
      %
  end.

handle_direction(1, ?FLOOR_COUNT-1) -> -1;
handle_direction(-1, 0) -> 1.