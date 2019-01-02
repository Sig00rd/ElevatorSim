-module(elevator).

-include("config.hrl").

%% API
-export([elevator/2, unload_dudes/2]).

elevator(Dudes_list, Current_floor) ->
  receive
    {entering, Dudes_entering} ->
      New_dudes_list = append(Dudes_list, Dudes_entering),
      elevator(New_dudes_list, Current_floor);
    {move, Direction} ->
      New_floor = move(Current_floor, Direction),
      elevator(Dudes_list, New_floor)
  end.

% -1 to travel downwards, 1 upwards, 0 to stay on the same floor
move(Current_floor, Direction) ->
  Current_floor + Direction.

unload_dudes(Dudes_list, Current_floor) ->
  [Dude || Dude <- Dudes_list, Dude = Current_floor].
