-module(control_system).

-include("config.hrl").

%% API
-export([control_system/2]).

control_system(Elevator, Floors) ->
  control_system(Elevator, Floors, sets:new(), 1, 0).

control_system(Elevator, Floors, Queued_floors, Current_direction, Current_floor) ->
  receive
    {button_pressed, Floor_number} ->
      New_queued_floors = sets:add_element(Floor_number, Queued_floors),
      control_system(Elevator, Floors, New_queued_floors, Current_direction, Current_floor);

    {button_unpressed, Floor_number} ->
      New_queued_floors = sets:del_element(Floor_number, Queued_floors),
      control_system(Elevator, Floors, New_queued_floors, Current_direction, Current_floor);

%%    {step}  -> case sets:is_empty(Queued_floors) of
%%                 true -> control_system(Elevator, Floors, Queued_floors, Current_direction);
%%                 false -> self() ! {move}
%%               end;
    {step} ->
      Direction = handle_direction(Current_direction, Current_floor),
      New_floor = Current_floor + Direction,
      Elevator ! {move, New_floor},
      control_system(Elevator, Floors, Queued_floors, Direction, New_floor)
%%
  end.

handle_direction(1, ?FLOOR_COUNT-1) -> -1;
handle_direction(-1, 0) -> 1;
handle_direction(Direction, _) -> Direction.