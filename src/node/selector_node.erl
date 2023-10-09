%%%-------------------------------------------------------------------
%%% @author zhaohongbin@tasmarter.com
%%% @copyright (C) 2023, tasmarter,http://www.tasmarter.com/
%%% @doc
%%%     选择节点 任意一个为true，返回true
%%% @end
%%% Created : 09. 10月 2023 15:11
%%%-------------------------------------------------------------------
-module(selector_node).

-description("selector_node").
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
                {break, {?SUCCESS, NAcc}};
            {?FAILURE, NAcc} ->
                {?FAILURE, NAcc}
        end
    end,
    btree_lib:for_list(Fun, {?FAILURE, Args}, ChileNodes).

%% ----------------------------------------------------
%% Description:节点
%% ----------------------------------------------------
debug_node(ObjectId, ChileNodes, Args) ->
    Fun = fun(Node, {_, Acc}) ->
        case btree_lib:tick_node(ObjectId, Node, Acc) of
            {?SUCCESS, NAcc} ->
                {break, {?SUCCESS, NAcc}};
            {?FAILURE, NAcc} ->
                {?FAILURE, NAcc}
        end
    end,
    btree_lib:for_list(Fun, {?FAILURE, Args}, ChileNodes).

%%%===================LOCAL FUNCTIONS==================
%% ----------------------------------------------------
%% Description: 
%% Args: 
%% Returns: 
%% ----------------------------------------------------
