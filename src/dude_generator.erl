-module(dude_generator).
-import(math, [pow/2]).
-include("config.hrl").

%% API
-export([dude_generator/1]).


dude_generator(Floor_PIDs) ->
  receive
    {dude, From, To} ->
      lists:nth(From + 1, Floor_PIDs) ! {dude, To},
      dude_generator(Floor_PIDs);

    {step} -> handle_all_floors(Floor_PIDs),
      dude_generator(Floor_PIDs)
  end.

handle_all_floors(Floor_PIDs) ->
  handle_all_floors(?FLOOR_COUNT, Floor_PIDs).

handle_all_floors(0, _) -> ok;
handle_all_floors(N, Floor_PIDs) ->
  generate_dude(lists:nth(N, Floor_PIDs), chance_to_spawn(N - 1)).


generate_dude(From_PID, Roll_to_spawn)
  when Roll_to_spawn =< ?DUDE_PER_STEP_CHANCE ->
  From_PID ! dude();
generate_dude(_, Roll_to_spawn)
  when Roll_to_spawn > ?DUDE_PER_STEP_CHANCE ->
  ok.

chance_to_spawn(Floor_number) ->
  (1/(pow(?FLOOR_COUNT/2, 2)))* pow((Floor_number - ?FLOOR_COUNT/2), 2).

dude() ->
  Destination_floor = round(rand:uniform() * ?FLOOR_COUNT),
  {dude, Destination_floor}.

