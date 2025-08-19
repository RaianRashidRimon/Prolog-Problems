% Facts about family members
parent(john, mary).     % John is a parent of Mary
parent(john, james).    % John is a parent of James
parent(mary, lisa).     % Mary is a parent of Lisa
parent(james, tom).     % James is a parent of Tom
parent(lisa, claire).   % Lisa is a parent of Claire

% Defining rules for family relationships

% X is a parent of Y
is_parent(X, Y) :- parent(X, Y).




% X is a child of Y (inverse of parent)
is_child(X, Y) :- parent(Y, X).



% X and Y are siblings if they share at least one parent
is_sibling(X, Y) :- parent(P, X), parent(P, Y), X \= Y.



% X is a grandparent of Y if X is a parent of a parent of Y
is_grandparent(X, Y) :- parent(X, P), parent(P, Y).

% X is an ancestor of Y if X is a parent of Y or X is a grandparent of Y
is_ancestor(X, Y) :- parent(X, Y).
is_ancestor(X, Y) :- parent(X, P), is_ancestor(P, Y).







% Examples to query the family tree
% ?- is_parent(john, mary).  % Should return true.
% ?- is_sibling(mary, james). % Should return true.
% ?- is_grandparent(john, tom). % Should return true.
