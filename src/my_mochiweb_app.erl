%% @author Mochi Media <dev@mochimedia.com>
%% @copyright my_mochiweb Mochi Media <dev@mochimedia.com>

%% @doc Callbacks for the my_mochiweb application.

-module(my_mochiweb_app).
-author("Mochi Media <dev@mochimedia.com>").

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for my_mochiweb.
start(_Type, _StartArgs) ->
    my_mochiweb_deps:ensure(),
    my_mochiweb_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for my_mochiweb.
stop(_State) ->
    ok.
