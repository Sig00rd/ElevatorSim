-module(app).
-import(elevator, [elevator/0]).
-include("config.hrl").

%% API
-export([start/0, input_redirect/3, simulation/1]).

start() ->
  Drawer = spawn(drawer, drawer, []),
  Floors = spawn_floors(?FLOOR_COUNT, Drawer),
  Elevator = spawn(elevator, elevator, [Drawer, Floors]),
  Control_system = spawn(control_system, control_system, [Elevator, Floors]),
  utils:broadcast({set_control_system, Control_system}, [Elevator|Floors]),
  Dude_generator = spawn(dude_generator, dude_generator, [Floors]),
  Input_redirect = spawn(app, input_redirect, [self(), Dude_generator, Drawer]),
  Input = spawn(input, startInput, [Input_redirect]),
  PIDs_that_accept_step = [Dude_generator, Control_system],
  Simulation = spawn(app, simulation, [PIDs_that_accept_step]),
  receive
    exit ->
      io:format("Gonna die :( \n"),
      Simulation ! exit,
      ok
  end.


simulation(PIDs) ->
  self() ! simulate,
  receive
    simulate ->
      utils:broadcast({step}, PIDs),
      timer:sleep(?STEP_INTERVAL),
      simulation(PIDs);
    exit ->
      io:format("Simulation ended \n")
  end.

spawn_floors(Number_of_floors, Drawer) ->
  spawn_floors([], Number_of_floors, Drawer).

spawn_floors(Floors_list, -1, _) ->
  Floors_list;
spawn_floors(Floors_list, Number_of_floors, Drawer) ->
  New_floor = spawn(floor, floor, [Number_of_floors, Drawer]),
  spawn_floors([New_floor|Floors_list], Number_of_floors-1, Drawer).

input_redirect(Main, Dude_generator, Drawer) ->
  receive
    draw_now ->
      Drawer ! draw_now,
      input_redirect(Main, Dude_generator, Drawer);
    exit ->
      Main ! exit;
    {newDude, From, To} ->
      Dude_generator ! {newDude, From, To},
      input_redirect(Main, Dude_generator, Drawer)
  end.