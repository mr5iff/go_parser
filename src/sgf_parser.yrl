%%%%%%%%%%%%%%%%%%%%
%% Non terminals
%%%%%%%%%%%%%%%%%%%%

Nonterminals
trees tree nodes node variations variation properties property.

%%%%%%%%%%%%%%%%%%%%
%% Terminals
%%%%%%%%%%%%%%%%%%%%

Terminals
propident propvalue ';' '(' ')'.

%%%%%%%%%%%%%%%%%%%%
%% Rootsymbol
%%%%%%%%%%%%%%%%%%%%

Rootsymbol trees.

%%%%%%%%%%%%%%%%%%%%
%% Rules
%%%%%%%%%%%%%%%%%%%%

% trees -> tree : ['$1'].
% trees -> tree trees : ['$1'] ++ '$2'.

% tree -> nodes : {tree, '$1'}.

% variation -> '(' nodes ')' : {variation, '$2'}.
% variation -> '(' nodes variation ')' : {variation, '$2', '$3'}.

% nodes -> variation : ['$1'].
% nodes -> variation nodes : ['$1'] ++ '$2'.

% nodes -> node : ['$1'].
% nodes -> node nodes : ['$1'] ++ '$2'.

% node -> ';' properties : {node, '$2'}.

% properties -> property : ['$1'].
% properties -> property properties : ['$1'] ++ '$2'.

% property -> propident propvalue : {property, '$1', '$2'}.

trees -> tree : ['$1'].
trees -> tree trees : ['$1'] ++ '$2'.

tree -> variation : {tree, '$1'}.

variations -> variation : ['$1'].
variations -> variation variations : ['$1'] ++ '$2'.

variation -> '(' nodes ')' : {variation, '$2'}.

nodes -> node : ['$1'].
nodes -> node nodes : ['$1'] ++ '$2'.

node -> ';' properties : {node, '$2', []}.
node -> ';' properties variations : {node, '$2', ['$3']}.

properties -> property : ['$1'].
properties -> property properties : ['$1'] ++ '$2'.

property -> propident propvalue : {property, list_to_binary(unwrap('$1')), list_to_binary(unwrap('$2'))}.

%%%%%%%%%%%%%%%%%%%%
%% Code
%%%%%%%%%%%%%%%%%%%%

Erlang code.

unwrap({_,_,V}) -> V.