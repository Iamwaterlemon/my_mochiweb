%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc Web server for my_mochiweb.

-module(my_mochiweb_web).
-author("Mochi Media <dev@mochimedia.com>").

-export([start/1, stop/0, loop/2]).

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    Loop = fun (Req) ->
                   ?MODULE:loop(Req, DocRoot)
           end,
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    mochiweb_http:stop(?MODULE).

loop(Req, DocRoot) ->
    "/" ++ Path = Req:get(path),
    try
        case Req:get(method) of
            Method when Method =:= 'GET'; Method =:= 'HEAD' ->
                case Path of
                  "index" ->
                    Req:respond({200, [{"Content-Type", "text/plain"}],
                    "Hello everyone! I am my_mochiweb!\n"});
				  "hello" ->
				   Req:respond({200, [{"Content-Type", "text/plain"}], 
						   "Hi! nice to meet you!\n"});
                    _ ->
                        Req:serve_file(Path, DocRoot)
                end;
            'POST' ->
                case Path of
                    _ ->
	                    PostData = Req:parse_post(),
						Data = proplists:get_value("post_data", PostData),
						io:format("PostD~p~n", [PostData]),
					    {ok, Fp} = file:open("demo.dat", [append]),
						{{Year,Month,Day},{Hour,Min,Second}} = calendar:local_time(),
						NewData = "2016" ++"-"++ erlang:integer_to_list(Month)
                            ++"-"++ erlang:integer_to_list(Day)
                            ++"  "++ erlang:integer_to_list(Hour)
                            ++":"++ erlang:integer_to_list(Min)
                            ++":"++ erlang:integer_to_list(Second) ++"  "++ Data ++ "</br>",
						% BinData = erlang:iolist_to_binary(NewData),
		                % io:format("NewData: ~p~n", [erlang:binary_to_list(BinData)]),
						file:write(Fp, NewData), 
						file:close(Fp),
						{ok, ChangeData} = file:read_file("demo.dat"),
				    	%io:format("Data:~p  ChangeData:~ts~n", [ChangeData, [list_to_binary(Data)]]),
						Req:respond({200, [{"Content-Type", "text/plain;charset=utf-8"}],
					    erlang:binary_to_list(ChangeData)})
						
                end;
            _ ->
                Req:respond({501, [], []})
        end
    catch
        Type:What ->
            Report = ["web request failed",
                      {path, Path},
                      {type, Type}, {what, What},
                      {trace, erlang:get_stacktrace()}],
            error_logger:error_report(Report),
            Req:respond({500, [{"Content-Type", "text/plain"}],
                         "request failed, sorry\n"})
    end.

%% Internal API

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.

%%
%% Tests
%%
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

you_should_write_a_test() ->
    ?assertEqual(
       "No, but I will!",
       "Have you written any tests?"),
    ok.

-endif.
