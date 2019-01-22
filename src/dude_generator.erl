-module(dude_generator).
-import(rand, [uniform/0]).
-import(math, [pow/2]).
-import(lists, [nth/2]).
-include("config.hrl").

%% API
-export([dude_generator/1]).


dude_generator(Floor_PIDs) ->
  receive
    {dude, From, To} ->
      nth(From+1, Floor_PIDs) ! dude(To);

    {step} ->  handle_all_floors(Floor_PIDs)
  end.

handle_all_floors(Floor_PIDs) ->
  handle_all_floors(?FLOOR_COUNT, Floor_PIDs).

handle_all_floors(0, _) -> ok;
handle_all_floors(N, Floor_PIDs) ->
  generate_dude(lists:nth(N, Floor_PIDs), chance_to_spawn(N-1)).


generate_dude(From_PID, Roll_to_spawn)
  when Roll_to_spawn =< ?DUDE_PER_STEP_CHANCE ->
    From_PID ! dude();
generate_dude(Floor_PID, Roll_to_spawn)
  when Roll_to_spawn > ?DUDE_PER_STEP_CHANCE ->
    ok.

chance_to_spawn(Floor_number) ->
  (1/(pow(?FLOOR_COUNT/2, 2)))* pow((?FLOOR_COUNT/2 - Floor_number), 2).

dude() ->
  Destination_floor = round(random:uniform() * ?FLOOR_COUNT),
  {dude, Destination_floor}.

