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
bfs(Start, Goal, Path) :-
    bfs_helper([[Start]], Goal, Path).
bfs_helper([[Goal|Rest]|_], Goal, Path) :- 
    reverse([Goal|Rest], Path). 
bfs_helper([CurrentPath|OtherPaths], Goal, Path) :-
    CurrentPath = [CurrentNode|_],
    findall([Next|CurrentPath], 
            (connected(CurrentNode, Next), \+ member(Next, CurrentPath)), 
            NewPaths),
    append(OtherPaths, NewPaths, UpdatedPaths),
    bfs_helper(UpdatedPaths, Goal, Path).