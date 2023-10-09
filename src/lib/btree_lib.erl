%%%-------------------------------------------------------------------
%%% @author zhaohongbin@tasmarter.com
%%% @copyright (C) 2023, tasmarter,http://www.tasmarter.com/
%%% @doc
%%%
%%% @end
%%% Created : 09. 10月 2023 15:26
%%%-------------------------------------------------------------------
-module(btree_lib).

-description("btree_lib").
-copyright('zhaohongbin').
-author("zhaohongbin").
-vsn(1).

%%%=======================EXPORT=======================
-export([for_list/2, for_list/3]).
-compile(export_all).
%%%=======================INCLUDE======================
-include("behavior_tree.hrl").
%%%=======================DEFINE======================

%%%=======================RECORD=======================

%%%=================EXPORTED FUNCTIONS=================
%% ----------------------------------------------------
%% Description: 循环
%% ----------------------------------------------------
for_list(_Fun, []) -> ok;
for_list(Fun, [H | D]) ->
    case Fun(H) of
        ok ->
            for_list(Fun, D);
        break ->
            ok
    end.
for_list(_Fun, Acc, []) -> Acc;
for_list(Fun, Acc, [H | D]) ->
    case Fun(H, Acc) of
        {break, NewAcc} ->
            NewAcc;
        {ok, NewAcc} ->
            for_list(Fun, NewAcc, D);
        NewAcc ->
            for_list(Fun, NewAcc, D)
    end.
%% ----------------------------------------------------
%% Description: 节点执行
%% ----------------------------------------------------
tick_node(ObjectId, Node, Args) ->
    case Node of
        {root, NextNode} ->  %%根节点
            tick_node(ObjectId, NextNode, Args);
        {leaf, {M, F, A}} ->  %%叶子节点
            M:F(ObjectId, A, Args);
        {selector_node, [_ | _] = ChileNodes} ->  %%选择节点 任意一个为true，返回true
            selector_node:node(ObjectId, ChileNodes, Args);
        {sequence_node, [_ | _] = ChileNodes} ->  %%顺序节点，子节点全部为true，返回true,否则返回false
            sequence_node:node(ObjectId, ChileNodes, Args);
        {parallel_node, [_ | _] = ChileNodes} ->  %%平行节点  执行其所有子节点
            parallel_node:node(ObjectId, ChileNodes, Args);
        {ifelse_node, {_, _, _} = ChileNodes} ->  %%if...else...  条件为真  执行左节点 条件为假  执行右节点
            ifelse_node:node(ObjectId, ChileNodes, Args);
        {loop_num_node, {_N, _} = ChileNode} ->  %%循环次数节点  循环N次
            loop_num_node:node(ObjectId, ChileNode, Args);
        {loop_bool_node, {_Bool, _} = ChileNode} ->  %%循环节点，直到子节点返回 和bool相关的值  true : ?SUCCESS  false:?FAILURE
            loop_bool_node:node(ObjectId, ChileNode, Args)
    end.

%%%===================LOCAL FUNCTIONS==================
%% ----------------------------------------------------
%% Description:
%% ----------------------------------------------------
test() ->
    Node = {root,   %%根节点
        {
            ifelse_node,  %% if else 节点
            {
                {leaf, {?MODULE, leaf, [1]}},
                {selector_node, [{leaf, {?MODULE, leaf, [2]}}]},
                {loop_num_node, {5, {leaf, {?MODULE, leaf, [3]}}}}
            }
        }
    },
    tick_node(1, Node, []).

leaf(_, [ID], Args) ->
    io:format("M===~p :~p===~p~n", [?MODULE, ?LINE, {ID}]),
    case lists:member(ID, [1]) of
        true ->
            {?FAILURE, Args};
        _ ->
            {?SUCCESS, Args}
    end.
