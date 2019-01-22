%%%-------------------------------------------------------------------
%%% @author matematyk60
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Jan 2019 22:09
%%%-------------------------------------------------------------------
-module(drawer).
-author("matematyk60").

%% API
-export([drawer/1]).

drawer(Floor_numbers) ->
  .

time

emptyElevatorSpace() ->

  "          ".

elevatorToString({elevator_state, DudesInside, _}) ->
  Prefix = "E[ ",
  timer
  Contents = string:left(dudesToString(DudesInside) ++ "           ", 5),
  Postfix = " ]",
  Prefix ++ Contents ++ Postfix.

dudesToString(Dudes) ->
  dudesToString("", Dudes).
dudesToString(Str, [{dude, Char, _, _} | T]) ->
  dudesToString(Str ++ Char, T);
dudesToString(Str, []) ->
  Str.