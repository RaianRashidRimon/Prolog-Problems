edge(a, b).
edge(a, c).
edge(b, d).
edge(b, e).
edge(c, f).
edge(c, g).
edge(d, h).
edge(e, i).
edge(f, j).
edge(g, k).

connected(X, Y) :- edge(X, Y).
connected(Y, X) :- edge(X, Y).
dfs(Start, Goal, Path) :- dfs_helper(Start, Goal, [Start], Path).
dfs_helper(Goal, Goal, Visited, Path) :- 
    reverse(Visited, Path). 
dfs_helper(Current, Goal, Visited, Path) :-
    connected(Current, Next),
    \+ member(Next, Visited),
    dfs_helper(Next, Goal, [Next|Visited], Path). % Continue search

