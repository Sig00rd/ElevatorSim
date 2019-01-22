-module(floor).
-import(lists, [append/2, sublist/2, subtract/2]).
-include("config.hrl").

%% API
-export([
  floor/1
  ]).

floor(Floor_number) ->
  receive
    {set_control_system, Control_system_PID} -> floor(Floor_number, Control_system_PID, [])
  end.

floor(Floor_number, Control_system, Dudes_queue) ->
  receive
    {set_control_system, Control_system_PID} ->
      floor(Floor_number, Control_system_PID, Dudes_queue);
    {dude, Destination_floor} ->
      Queue = append(Dudes_queue, [Destination_floor]),
      Control_system ! {button_pressed, Floor_number},
      floor(Queue, Floor_number, Control_system);
    {open, Free_slots, From} ->
      Dudes_entering = dudes_entering(Dudes_queue, Free_slots),
      From ! {entering, Dudes_entering},
      floor(subtract(Dudes_queue, Dudes_entering), Floor_number, Control_system)
  end.

dudes_entering(_, 0) ->
  [];
dudes_entering(Dudes_queue, Free_slots) ->
  sublist(Dudes_queue, Free_slots).
