%%%-------------------------------------------------------------------
%%% @author zhaohongbin@tasmarter.com
%%% @copyright (C) 2023, tasmarter,http://www.tasmarter.com/
%%% @doc
%%%     平行节点  执行其所有子节点,一个失败，返回失败，全部成功，返回成功
%%% @end
%%% Created : 09. 10月 2023 15:52
%%%-------------------------------------------------------------------
-module(parallel_node).

-description("parallel_node").
-copyright('zhaohongbin').
-author("zhaohongbin").
-vsn(1).

%%%=======================EXPORT=======================
-export([node/3, debug_node/3]).

%%%=======================INCLUDE======================
-include("behavior_tree.hrl").
%%%=======================DEFINE======================

%%%=======================RECORD=======================

%%%=================EXPORTED FUNCTIONS=================
%% ----------------------------------------------------
%% Description:节点
%% ----------------------------------------------------
node(ObjectId, ChileNodes, Args) ->
    Fun = fun(Node, {OldResult, Acc}) ->
        case btree_lib:tick_node(ObjectId, Node, Acc) of
            {?SUCCESS, NAcc} ->
                {OldResult, NAcc};
            {?FAILURE, NAcc} ->
                {?FAILURE, NAcc}
        end
    end,
    btree_lib:for_list(Fun, {?SUCCESS, Args}, ChileNodes).
%% ----------------------------------------------------
%% Description:节点
%% ----------------------------------------------------
debug_node(ObjectId, ChileNodes, Args) ->
    Fun = fun(Node, {OldResult, Acc}) ->
        case btree_lib:tick_node(ObjectId, Node, Acc) of
            {?SUCCESS, NAcc} ->
                {OldResult, NAcc};
            {?FAILURE, NAcc} ->
                {?FAILURE, NAcc}
        end
    end,
    btree_lib:for_list(Fun, {?SUCCESS, Args}, ChileNodes).


%%%===================LOCAL FUNCTIONS==================
%% ----------------------------------------------------
%% Description: 
%% Args: 
%% Returns: 
%% ----------------------------------------------------
