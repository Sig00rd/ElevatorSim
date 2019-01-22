-module(elevator).
-include("config.hrl").

%% API
-export([elevator/2]).

elevator(Drawer, Floors) ->
  receive
    {set_control_system, Control_system_PID} ->
      elevator([], 0, Control_system_PID, Drawer, Floors)
  end.

elevator(Dudes_inside, Current_floor, Control_system, Drawer, Floors) ->
  receive
    {entering, Dudes_entering} ->
      send_button_pressed_messages(Control_system, Dudes_entering),
      New_dudes_list = lists:append(Dudes_inside, Dudes_entering),
      Drawer ! {elevator, New_dudes_list, Current_floor},
      elevator(New_dudes_list, Current_floor, Control_system, Drawer, Floors);

    {move, Floor} ->
      Current_Floor_PID = lists:nth(Current_floor+1, Floors),
      Current_Floor_PID ! {open, ?ELEVATOR_CAPACITY - length(Dudes_inside), self()},
      Drawer ! {elevator, Dudes_inside, Floor},
      Dudes_staying = unload_dudes(Dudes_inside, Current_floor, Control_system, Drawer),
      elevator(Dudes_staying, Floor, Control_system, Drawer, Floors);

    {get_floor, From} ->
      From ! Current_floor,
      elevator(Dudes_inside, Current_floor, Control_system, Drawer, Floors)
%%
%%    {unload} ->
%%      Unloaded_dudes = unloaded_dudes(Dudes_inside, Current_floor),
%%      Dudes_staying = lists:subtract(Dudes_inside, Unloaded_dudes),
%%      Control_system ! {button_unpressed, Current_floor},
%%      Drawer ! {elevator, Dudes_staying, Current_floor},
%%      elevator(Dudes_staying, Current_floor, Control_system, Drawer, Floors)

  end.

unload_dudes(Dudes_inside, Current_floor, Control_system, Drawer) ->
  Unloaded_dudes = unloaded_dudes(Dudes_inside, Current_floor),
  Dudes_staying = lists:subtract(Dudes_inside, Unloaded_dudes),
  Control_system ! {button_unpressed, Current_floor},
  Drawer ! {elevator, Dudes_staying, Current_floor},
  Dudes_staying.

send_button_pressed_messages(_, []) -> ok;
send_button_pressed_messages(Control_system, [H|T]) ->
  Control_system ! {button_pressed, H},
  send_button_pressed_messages(Control_system, T).

unloaded_dudes(Dudes_inside, Current_floor) ->
  [Dude || Dude <- Dudes_inside, Dude == Current_floor].
