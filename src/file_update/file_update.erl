%%%-------------------------------------------------------------------
%%% @author lqq,liqiqiang@youkia.net
%%% @copyright (C) 2023, youkia,www.youkia.net
%%% @doc   本地热更模块
%%% @end
%%%-------------------------------------------------------------------
-module(file_update).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
    file_list_info
}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    {_, FileDir} = file:get_cwd(),
    ModFileDir = hd(lists:reverse(string:tokens(FileDir, "/"))),
    Dir = FileDir ++ "/_build/default/lib/" ++ ModFileDir ++ "/ebin",
    {ok, FileNames} = file:list_dir(Dir),
    Fun = fun(FileName, Acc) ->
        case string:tokens(FileName, ".") of
            [_, "beam"] ->
                {ok, FileInfo} = file:read_file_info(Dir ++ "/" ++ FileName, [{time, local}]),
                put(FileName, FileInfo),
                [FileName | Acc];
            _ ->
                Acc
        end
    end,
    NewFileNames = lists:foldl(Fun, [], FileNames),
    timer:send_after(3 * 1000, self(), 'update'),
    {ok, #state{file_list_info = NewFileNames}}.

handle_call(_Request, _From, State = #state{}) ->
    {reply, ok, State}.

handle_cast(_Request, State = #state{}) ->
    {noreply, State}.

%%检查更新
handle_info('update', State = #state{file_list_info = OldFileList}) ->
    timer:send_after(3 * 1000, self(), 'update'),
    {_, FileDir} = file:get_cwd(),
    ModFileDir = hd(lists:reverse(string:tokens(FileDir, "/"))),
    Dir = FileDir ++ "/_build/default/lib/" ++ ModFileDir ++ "/ebin",
    {ok, FileNames} = file:list_dir(Dir),
    Fun = fun(FileName, {Acc, Acc1, Acc2}) ->
        case string:tokens(FileName, ".") of
            [ModString, "beam"] ->
                {ok, FileInfo} = file:read_file_info(Dir ++ "/" ++ FileName, [{time, local}]),
                case get(FileName) of
                    FileInfo ->
                        {lists:delete(FileName, Acc), [FileName | Acc1], Acc2};
                    _ ->  %%文件变了，重新加载
                        put(FileName, FileInfo),
                        Mod = list_to_atom(ModString),
                        code:purge(Mod),
                        code:load_file(Mod),
                        {lists:delete(FileName, Acc), [FileName | Acc1], [FileName | Acc2]}
                end;
            _ ->
                {Acc, Acc1, Acc2}
        end
    end,
    {DeleteFiles, NewFileNames, UpdateFileName} = lists:foldl(Fun, {OldFileList, [], []}, FileNames),
    DeleteFUn = fun(FileName) ->
        [ModString | _] = string:tokens(FileName, "."),
        code:purge(list_to_atom(ModString))
    end,
    lists:map(DeleteFUn, DeleteFiles),
    [io:format("===~p===update===~p~n", [calendar:local_time(), UpdateFileName]) || UpdateFileName =/= []],
    [io:format("===~p===delete===~p~n", [calendar:local_time(), DeleteFiles]) || DeleteFiles =/= []],
    {noreply, State#state{file_list_info = NewFileNames}};
handle_info(_Info, State = #state{}) ->
    {noreply, State}.


terminate(_Reason, _State = #state{}) ->
    ok.

code_change(_OldVsn, State = #state{}, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
