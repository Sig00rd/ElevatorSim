-module(elevator).
-import(lists, [subtract/2]).
-include("config.hrl").

%% API
-export([elevator/3]).

elevator(Dudes_inside, Current_floor, Control_system) ->
  receive
    {entering, Dudes_entering} ->
      send_button_pressed_messages(Control_system, Dudes_entering),
      New_dudes_list = append(Dudes_inside, Dudes_entering),
      elevator(New_dudes_list, Current_floor);
    {move, Direction} ->
      New_floor = move(Current_floor, Direction),
      elevator(Dudes_inside, New_floor);
    {get_floor, From} ->
      From ! Current_floor;
    {unload} ->
      Unloaded_dudes = unloaded_dudes(Dudes_inside, Current_floor),
      Dudes_staying = subtract(Dudes_inside, Unloaded_dudes),
      elevator(Dudes_staying, Current_floor)
  end.

% Direction is:
% -1 to travel downwards, 1 upwards, 0 to stay on the same floor
move(Current_floor, Direction) ->
  Current_floor + Direction.

send_button_pressed_messages(_, []) -> ok;
send_button_pressed_messages(Control_system, [H|T]) ->
  Control_system ! {button_pressed, H},
  send_button_pressed_messages(Control_system, T).


unloaded_dudes(Dudes_inside, Current_floor) ->
  [Dude || Dude <- Dudes_inside, Dude = Current_floor].
