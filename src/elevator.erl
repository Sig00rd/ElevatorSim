-module(elevator).

-include("config.hrl").

%% API
-export([elevator/2, unload_dudes/2]).

elevator(Dudes_list, Current_floor) -> ok.

unload_dudes(Dudes_list, Current_floor) ->
  [Dude || Dude <- Dudes_list, Dude = Current_floor].

