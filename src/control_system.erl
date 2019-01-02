-module(control_system).

-include("config.hrl").

%% API
-export([]).

control_system(Elevator, Floors, Queued_floors_numbers) ->
  receive
    {button_pressed, Floor_number, Floor} ->

  end