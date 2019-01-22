%%%-------------------------------------------------------------------
%%% @author matematyk60
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. Jan 2019 00:33
%%%-------------------------------------------------------------------
-module(input).
-author("matematyk60").

-include("config.hrl").
%% API
-export([startInput/1, test/0]).

%% sends either {newDude, FromFloor, ToFloor} or exit to parent
%% when user types 'exit' or 'FT' where F and T are numbers from 0 to 9

startInput(Parent) ->
  Input = string:strip(io:get_line(">"), right, $\n),
  case matchString(Input) of
    {ok, Command} ->
      Parent ! Command,
      startInput(Parent);
    wrong ->
      io:format("Invalid input!!!\n"),
      startInput(Parent)
  end.

matchString("exit") ->
  {ok, exit};

matchString(Str) when length(Str) > 1 ->
  From = string:sub_string(Str, 1, 1),
  To = string:sub_string(Str, 2, 2),
  case {string:to_integer(From), string:to_integer(To)} of
    {{error, _}, _} ->
      wrong;
    {_, {error, _}} ->
      wrong;
    {{FromConverted, _}, {ToConverted, _}} ->
      if
        FromConverted =< ?FLOOR_COUNT, ToConverted =< ?FLOOR_COUNT ->
          {ok, {newDude, FromConverted, ToConverted}};
        true ->
          wrong
      end
  end;

matchString(_) ->
  wrong.

test() ->
  W = spawn(input, startInput, [self()]),
  receive
    exit ->
      io:format("DIE");
    Other ->
      io:format(Other)
  end.