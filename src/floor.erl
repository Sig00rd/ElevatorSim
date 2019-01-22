-module(floor).
-import(lists, [append/2, sublist/2, subtract/2]).
-include("config.hrl").

%% API
-export([
  floor/2
  ]).

floor(Floor_number, Drawer) ->
  receive
    {set_control_system, Control_system_PID} -> floor(Floor_number, Control_system_PID, [], Drawer)
  end.

floor(Floor_number, Control_system, Dudes_queue, Drawer) ->
  receive
    {set_control_system, Control_system_PID} ->
      floor(Floor_number, Control_system_PID, Dudes_queue, Drawer);
    {dude, Destination_floor} ->
      Queue = append(Dudes_queue, [Destination_floor]),
      Control_system ! {button_pressed, Floor_number},
      Drawer ! {floor, Floor_number, Queue},
      floor(Floor_number, Control_system, Queue, Drawer);
    {open, Free_slots, From} ->
      Dudes_entering = dudes_entering(Dudes_queue, Free_slots),
      From ! {entering, Dudes_entering},
      floor(Floor_number, Control_system, subtract(Dudes_queue, Dudes_entering), Drawer)
  end.

dudes_entering(_, 0) ->
  [];
dudes_entering(Dudes_queue, Free_slots) ->
  sublist(Dudes_queue, Free_slots).
