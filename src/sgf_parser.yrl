%%%%%%%%%%%%%%%%%%%%
%% Non terminals
%%%%%%%%%%%%%%%%%%%%

Nonterminals
trees tree nodes node variations variation properties property propvalues.

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

% Sgf contains usually one game
trees -> tree : ['$1'].
trees -> tree trees : ['$1'] ++ '$2'.

tree -> variation : {tree, '$1'}.

variations -> variation : ['$1'].
variations -> variation variations : ['$1'] ++ '$2'.

variation -> '(' nodes ')' : {variation, '$2'}.

nodes -> node : ['$1'].
nodes -> node nodes : ['$1'] ++ '$2'.

node -> ';' properties : {node, '$2', []}.
node -> ';' properties variations : {node, '$2', '$3'}.

properties -> property : ['$1'].
properties -> property properties : ['$1'] ++ '$2'.

% Some propvalues are on multiple lines! seeff4_ex.sgf
propvalues -> propvalue : unwrap('$1').
propvalues -> propvalue propvalues : unwrap('$1') ++ '$2'.

property -> propident propvalues : {property, list_to_binary(unwrap('$1')), list_to_binary('$2')}.

%%%%%%%%%%%%%%%%%%%%
%% Code
%%%%%%%%%%%%%%%%%%%%

Erlang code.

unwrap({_,_,V}) -> V.