-module().

-behaviour(gen_server).

-compile(export_all).
-export([start/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
        terminate/2, code_change/3]).

% public

start() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

% internal

init([]) ->
    process_flag(trap_exit, true),
    State = [],
    {ok, State}.

handle_call(_Message, _From, State) ->
    {reply, ok, State}.

handle_cast(_Message, State) ->
    {noreply, State}.

handle_info(_Msg, State) ->
    {noreply, State}.

code_change(_OldVersion, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.
