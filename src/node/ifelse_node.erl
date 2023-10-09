%%%-------------------------------------------------------------------
%%% @author zhaohongbin@tasmarter.com
%%% @copyright (C) 2023, tasmarter,http://www.tasmarter.com/
%%% @doc
%%%         if...else...
%%%         条件为真  执行左节点
%%%         条件为假  执行右节点
%%% @end
%%% Created : 09. 10月 2023 16:00
%%%-------------------------------------------------------------------
-module(ifelse_node).

-description("ifelse_node").
-copyright('zhaohongbin').
-author("zhaohongbin").
-vsn(1).

%%%=======================EXPORT=======================
-export([node/3,debug_node/3]).

%%%=======================INCLUDE======================
-include("behavior_tree.hrl").
%%%=======================DEFINE======================

%%%=======================RECORD=======================

%%%=================EXPORTED FUNCTIONS=================
%% ----------------------------------------------------
%% Description:节点
%% ----------------------------------------------------
node(ObjectId, {CheckNode, LeftNode, RightNode}, Args) ->
    case btree_lib:tick_node(ObjectId, CheckNode, Args) of
        {?SUCCESS, NArgs} ->
            btree_lib:tick_node(ObjectId, LeftNode, NArgs);
        {?FAILURE, NArgs} ->
            btree_lib:tick_node(ObjectId, RightNode, NArgs)
    end.
%% ----------------------------------------------------
%% Description:节点
%% ----------------------------------------------------
debug_node(ObjectId, {CheckNode, LeftNode, RightNode}, Args) ->
    case btree_lib:tick_node(ObjectId, CheckNode, Args) of
        {?SUCCESS, NArgs} ->
            btree_lib:tick_node(ObjectId, LeftNode, NArgs);
        {?FAILURE, NArgs} ->
            btree_lib:tick_node(ObjectId, RightNode, NArgs)
    end.


%%%===================LOCAL FUNCTIONS==================
%% ----------------------------------------------------
%% Description: 
%% Args: 
%% Returns: 
%% ----------------------------------------------------
