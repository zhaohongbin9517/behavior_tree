%%%-------------------------------------------------------------------
%%% @author zhaohongbin@tasmarter.com
%%% @copyright (C) 2023, tasmarter,http://www.tasmarter.com/
%%% @doc
%%%      循环节点  最后一次循环结果返回
%%% @end
%%% Created : 09. 10月 2023 16:41
%%%-------------------------------------------------------------------
-module(loop_num_node).

-description("loop_node").
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
node(ObjectId, {Num, ChileNode}, Args) ->
    Fun = fun(_, {_, NArgs}) ->
        btree_lib:tick_node(ObjectId, ChileNode, NArgs)
    end,
    lists:foldl(Fun, {?SUCCESS, Args}, lists:seq(1, Num)).
%% ----------------------------------------------------
%% Description:节点
%% ----------------------------------------------------
debug_node(ObjectId, {Num, ChileNode}, Args) ->
    Fun = fun(_, {_, NArgs}) ->
        btree_lib:tick_node(ObjectId, ChileNode, NArgs)
    end,
    lists:foldl(Fun, {?SUCCESS, Args}, lists:seq(1, max(Num, 1))).


%%%===================LOCAL FUNCTIONS==================
%% ----------------------------------------------------
%% Description: 
%% Args: 
%% Returns: 
%% ----------------------------------------------------
