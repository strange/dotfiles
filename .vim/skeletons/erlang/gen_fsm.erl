-module(module_name).

-behaviour(gen_fsm).

-export([start_link/0]).

-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3,
        terminate/3, code_change/4]).

-define(SERVER, ?MODULE).

%% External API

start_link() ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% States

state_name(_Event, State) ->
    {next_state, state_name, State}.

%% Callbacks

init(_Args) ->
    State = [],
    {ok, state_name, State}.

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    {reply, ok, StateName, State}.

handle_info(_Msg, StateName, State) ->
    {next_state, StateName, State}.

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVersion, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% Internal API
