-module(utils).
-include("config.hrl").

%% API
-export([
  broadcast/2
  ]).


broadcast(_, []) ->
  true;
broadcast(Message, [H|T]) ->
  H ! Message,
  broadcast(Message, T).