%%%-------------------------------------------------------------------
%%% @author zhaohongbin@tasmarter.com
%%% @copyright (C) 2023, tasmarter,http://www.tasmarter.com/
%%% @doc
%%%      顺序节点，子节点全部为true，返回true,否则返回false
%%% @end
%%% Created : 09. 10月 2023 15:48
%%%-------------------------------------------------------------------
-module(sequence_node).

-description("sequence_node").
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
    Fun = fun(Node, {_, Acc}) ->
        case btree_lib:tick_node(ObjectId, Node, Acc) of
            {?SUCCESS, NAcc} ->
                {?SUCCESS, NAcc};
            {?FAILURE, NAcc} ->
                {break, {?FAILURE, NAcc}}
        end
    end,
    btree_lib:for_list(Fun, {?SUCCESS, Args}, ChileNodes).

%% ----------------------------------------------------
%% Description:节点
%% ----------------------------------------------------
debug_node(ObjectId, ChileNodes, Args) ->
    Fun = fun(Node, {_, Acc}) ->
        case btree_lib:tick_node(ObjectId, Node, Acc) of
            {?SUCCESS, NAcc} ->
                {?SUCCESS, NAcc};
            {?FAILURE, NAcc} ->
                {break, {?FAILURE, NAcc}}
        end
    end,
    btree_lib:for_list(Fun, {?SUCCESS, Args}, ChileNodes).


%%%===================LOCAL FUNCTIONS==================
%% ----------------------------------------------------
%% Description: 
%% Args: 
%% Returns: 
%% ----------------------------------------------------
