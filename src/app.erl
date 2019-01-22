-module(app).
-import(elevator, [elevator/0]).
-include("config.hrl").

%% API
-export([start/0]).

start() ->
  Floors = spawn_floors(?FLOOR_COUNT),
  Elevator = spawn(elevator, elevator, []),
  Control_system = spawn(control_system, control_system, [Elevator, Floors]),

  utils:broadcast({set_control_system, Control_system}, [Elevator|Floors]),
  simulation().


simulation() -> ok.

spawn_floors(Number_of_floors) ->
  spawn_floors([], Number_of_floors).

spawn_floors(Floors_list, 0) ->
  Floors_list;
spawn_floors(Floors_list, Number_of_floors) ->
  New_floor = spawn(floor, floor, [Number_of_floors]),
  spawn_floors([New_floor|Floors_list], Number_of_floors-1).