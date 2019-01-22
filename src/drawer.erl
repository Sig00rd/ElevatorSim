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

-include("config.hrl").

%% API
-export([drawer/0]).

drawer() ->
  Floor_numbers = ?FLOOR_COUNT,
  Floors = lists:reverse(setupFloors(Floor_numbers)),
  Elevator = setupElevator(),
  drawer(started, {Floors, Elevator}).


setupFloors(FloorNumbers) ->
  setupFloors([], FloorNumbers - 1).

setupFloors(Floors, -1) ->
  Floors;
setupFloors(Floors, FloorNumber) ->
  setupFloors([{floor, FloorNumber, []} | Floors], FloorNumber - 1).

setupElevator() ->
  {elevator, [], 0}.

drawer(started, State) ->
  %drawEmptyLines(),
  draw(State),
  {Floors, Elevator} = State,
  receive
    %%% update floor with this number state
    {floor, FloorNumber, FloorDudes} ->
      Before = lists:takewhile(fun({floor, Number, _}) -> Number =/= FloorNumber end, Floors),
      Middle = [{floor, FloorNumber, FloorDudes} | []],
      After = lists:nthtail(1, lists:dropwhile(fun({floor, Number, _}) -> Number =/= FloorNumber end, Floors)),
      drawer(started, {Before ++ Middle ++ After, Elevator});

    %%% update elevator state
    {elevator, ElevatorDudes, ElevatorFloor} ->
      drawer(started, {Floors, {elevator, ElevatorDudes, ElevatorFloor}});
    draw_now ->
      drawer(started, State)
  end.

draw({[], _}) ->
  ok;
draw({[{floor, FloorNumber, FloorDudes} | T], Elevator}) ->
  {elevator, _, ElevatorFloor} = Elevator,
  io:format(integer_to_list(FloorNumber) ++ "|"),
  if
    ElevatorFloor == FloorNumber ->
      io:format(elevatorToString(Elevator));
    true ->
      io:format(emptyElevatorSpace())
  end,
  io:format("| " ++ dudesToString(FloorDudes) ++ "\n"),
  draw({T, Elevator}).


emptyElevatorSpace() ->
  "             ".

elevatorToString({elevator, DudesInside, _}) ->
  Prefix = "E[ ",
  Contents = string:left(dudesToString(DudesInside) ++ "              ", 8),
  Postfix = " ]",
  Prefix ++ Contents ++ Postfix.

dudesToString(Dudes) ->
  dudesToString("", Dudes).
dudesToString(Str, [To | T]) ->
  dudesToString(Str ++ integer_to_list(To), T);
dudesToString(Str, []) ->
  Str.

drawEmptyLines() ->
  drawEmptyLines(lists:seq(1, 150)).
drawEmptyLines([]) ->
  ok;
drawEmptyLines([_ | T]) ->
  io:format("\n"),
  drawEmptyLines(T).
