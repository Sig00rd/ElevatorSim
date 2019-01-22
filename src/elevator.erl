-module(elevator).
-include("config.hrl").

%% API
-export([elevator/1]).

elevator(Drawer) ->
  receive
    {set_control_system, Control_system_PID} ->
      elevator([], 0, Control_system_PID, Drawer)
  end.

elevator(Dudes_inside, Current_floor, Control_system, Drawer) ->
  receive
    {entering, Dudes_entering} ->
      send_button_pressed_messages(Control_system, Dudes_entering),
      New_dudes_list = lists:append(Dudes_inside, Dudes_entering),
      Drawer ! {elevator, New_dudes_list, Current_floor},
      elevator(New_dudes_list, Current_floor, Control_system, Drawer);

    {move, Direction} ->
      New_floor = move(Current_floor, Direction),
      % floor ! {open, ?ELEVATOR_CAPACITY - length(Dudes_inside), self()}
      Drawer ! {elevator, Dudes_inside, New_floor},
      elevator(Dudes_inside, New_floor, Control_system, Drawer);

    {get_floor, From} ->
      From ! Current_floor,
      elevator(Dudes_inside, Current_floor, Control_system, Drawer);

    {unload} ->
      Unloaded_dudes = unloaded_dudes(Dudes_inside, Current_floor),
      Dudes_staying = lists:subtract(Dudes_inside, Unloaded_dudes),
      Control_system ! {button_unpressed, Current_floor},
      Drawer ! {elevator, Dudes_staying, Current_floor},
      elevator(Dudes_staying, Current_floor, Control_system, Drawer)

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
