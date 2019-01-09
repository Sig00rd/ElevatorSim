-module(floor).
-import(lists, [append/2, sublist/2, subtract/2]).
-include("config.hrl").

%% API
-export([
  floor/1,
  test/0
  ]).

floor(Floor_number) ->
  receive
    {set_control_system, Control_system_PID} -> floor(Floor_number, Control_system_PID, [])
  end.

floor(Floor_number, Control_system, Dudes_queue) ->
  receive
    {set_control_system, Control_system_PID} ->
      floor(Floor_number, Control_system_PID, Dudes_queue);
    {{dude, Id}, From} ->
      Queue = append(Dudes_queue, [Id]),
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

test() ->
  QPID = spawn(floor, floor, [[], 1]),
  QPID ! {{dude, 1}, self()},
  QPID ! {{dude, 2}, self()},
  QPID ! {open, 2, self()},
  QPID ! {{dude, 3}, self()},
  QPID ! {open, 0, self()},
  QPID ! {open, 2, self()},
  {ok}.
