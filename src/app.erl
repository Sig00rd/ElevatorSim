-module(app).
-import(floor, [floor/1]).
-import(elevator, [elevator/0]).
-import(utils, [broadc]).
-include("config.hrl").

%% API
-export([start/0]).


start() ->
  Floors = spawn_floors(),
  Elevator = spawn(elevator, elevator, []),
  Control_system = spawn(Elevator, Floors).


simulation() -> ok.

spawn_floors(Number_of_floors) ->
  spawn_floors([], Number_of_floors).
spawn_floors(Floors_list, 0) ->
  Floors_list;
spawn_floors([H|T], Number_of_floors) ->
  New_floor = spawn(floor, floor, [Number_of_floors]),
  spawn_floors([New_floor|[H]++T], Number_of_floors-1).