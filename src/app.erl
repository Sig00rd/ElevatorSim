-module(app).
-import(elevator, [elevator/0]).
-include("config.hrl").

%% API
-export([start/0]).

start() ->
  Drawer = spawn(drawer, drawer, []),
  Floors = spawn_floors(?FLOOR_COUNT, Drawer),
  Elevator = spawn(elevator, elevator, [Drawer]),
  Control_system = spawn(control_system, control_system, [Elevator, Floors]),
  utils:broadcast({set_control_system, Control_system}, [Elevator|Floors]),
  Dude_generator = spawn(dude_generator, dude_generator, [Floors]),
  Input = spawn(input, startInput, [self()]),
  PIDs_that_accept_step = [Dude_generator, Control_system],
  simulation(PIDs_that_accept_step).


simulation(PIDs) ->
  utils:broadcast({step}, PIDs),
  timer:sleep(?STEP_INTERVAL),
  simulation(PIDs).

spawn_floors(Number_of_floors, Drawer) ->
  spawn_floors([], Number_of_floors, Drawer).

spawn_floors(Floors_list, 0, _) ->
  Floors_list;
spawn_floors(Floors_list, Number_of_floors, Drawer) ->
  New_floor = spawn(floor, floor, [Number_of_floors, Drawer]),
  spawn_floors([New_floor|Floors_list], Number_of_floors-1, Drawer).