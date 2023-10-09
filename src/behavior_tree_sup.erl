%%%-------------------------------------------------------------------
%% @doc trpc_server top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(behavior_tree_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
init([]) ->
  SupFlags = #{strategy => one_for_one, intensity => 100, period => 1},
  ChildSpecs = [
    #{id => file_update_sup,
      start => {file_update_sup, start_link, []},
      restart => permanent,
      shutdown => 2000,
      type => supervisor,
      modules => [file_update_sup]
    }
  ],
  {ok, {SupFlags, ChildSpecs}}.


%%====================================================================
%% Internal functions
%%====================================================================
start_child_(ChildSpec) ->
  case supervisor:check_childspecs([ChildSpec]) of
    ok ->
      supervisor:start_child(?MODULE, ChildSpec);
    {error, Reason} ->
      {error, Reason}
  end.