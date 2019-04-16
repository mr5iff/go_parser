% -- Definitions.

% -- Collection = GameTree { GameTree }
% -- GameTree   = "(" Sequence { GameTree } ")"
% -- Sequence   = Node { Node }
% -- Node       = ";" { Property }
% -- Property   = PropIdent PropValue { PropValue }
% -- PropIdent  = UcLetter { UcLetter }
% -- PropValue  = "[" CValueType "]"
% -- CValueType = (ValueType | Compose)
% -- ValueType  = (None | Number | Real | Double | Color | SimpleText |
% -- 		Text | Point  | Move | Stone)
%
% -- Rules.
%
% -- 'list of':    PropValue { PropValue }
% -- 'elist of':   ((PropValue { PropValue }) | None)

%%%%%%%%%%%%%%%%%%%%
%% Definitions
%%%%%%%%%%%%%%%%%%%%

Definitions.

PROPIDENT  = [A-Z]+
PROPVALUE  = ((\[\])|(\[[^\[\]]+\])|(\[[^\[\]]+(\[.+\])+[^\[\]]+\]))+

WHITESPACE     = [\s\t]
TERMINATOR     = [\n\r]

%%%%%%%%%%%%%%%%%%%%
%% Rules
%%%%%%%%%%%%%%%%%%%%

Rules.

\(             : {token, {'(', TokenLine}}.
\)             : {token, {')', TokenLine}}.
;              : {token, {';', TokenLine}}.
{PROPIDENT}    : {token, {propident, TokenLine, TokenChars}}.
{PROPVALUE}    : {token, {propvalue, TokenLine, TokenChars}}.

{WHITESPACE}+  : skip_token.
{TERMINATOR}+  : skip_token.

%%%%%%%%%%%%%%%%%%%%
%% Erlang code
%%%%%%%%%%%%%%%%%%%%

Erlang code.