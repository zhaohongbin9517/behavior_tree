%%%-------------------------------------------------------------------
%%% @author 
%%% @copyright
%%% @doc
%%%     文件热更监程
%%% @end
%%%-------------------------------------------------------------------
-module(file_update_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).
-export([start_unlink/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).
start_unlink() ->
    {ok, Pid} = supervisor:start_link({local, ?SERVER}, ?MODULE, []),
    unlink(Pid).


init([]) ->
    SupFlags = #{strategy => one_for_one, intensity => 4, period => 5},
    ChildSpecs = [
        #{id => file_update,
            start => {file_update, start_link, []},
            restart => permanent,
            shutdown => brutal_kill,
            type => worker,
            modules => [file_update]}
    ],
    {ok, {SupFlags, ChildSpecs}}.

