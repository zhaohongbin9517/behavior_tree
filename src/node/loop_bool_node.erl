%%%-------------------------------------------------------------------
%%% @author zhaohongbin@tasmarter.com
%%% @copyright (C) 2023, tasmarter,http://www.tasmarter.com/
%%% @doc
%%%     循环节点，一直循环到 成功 or 失败
%%% @end
%%% Created : 09. 10月 2023 16:52
%%%-------------------------------------------------------------------
-module(loop_bool_node).

-description("loop_bool_node").
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
%% Description: 节点
%% ----------------------------------------------------
node(ObjectId, {Bool, ChileNode}, Args) ->
    case btree_lib:tick_node(ObjectId, ChileNode, Args) of
        {?SUCCESS, NArgs} when Bool =:= true ->
            {?SUCCESS, NArgs};
        {?FAILURE, NArgs} when Bool =:= false ->
            {?SUCCESS, NArgs};
        {_, NArgs} ->
            node(ObjectId, {Bool, ChileNode}, NArgs)
    end.
%% ----------------------------------------------------
%% Description: 节点
%% ----------------------------------------------------
debug_node(ObjectId, {Bool, ChileNode}, Args) ->
    case btree_lib:tick_node(ObjectId, ChileNode, Args) of
        {?SUCCESS, NArgs} when Bool =:= true ->
            {?SUCCESS, NArgs};
        {?FAILURE, NArgs} when Bool =:= false ->
            {?SUCCESS, NArgs};
        {_, NArgs} ->
            debug_node(ObjectId, {Bool, ChileNode}, NArgs)
    end.
%%%===================LOCAL FUNCTIONS==================
%% ----------------------------------------------------
%% Description: 
%% Args: 
%% Returns: 
%% ----------------------------------------------------
