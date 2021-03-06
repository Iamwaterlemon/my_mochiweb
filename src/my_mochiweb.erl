%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc my_mochiweb.

-module(my_mochiweb).
-author("Mochi Media <dev@mochimedia.com>").
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.


%% @spec start() -> ok
%% @doc Start the my_mochiweb server.
start() ->
    my_mochiweb_deps:ensure(),
    ensure_started(crypto),
    application:start(my_mochiweb).


%% @spec stop() -> ok
%% @doc Stop the my_mochiweb server.
stop() ->
    application:stop(my_mochiweb).
