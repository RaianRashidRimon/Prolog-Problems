goal([1,2,3,4,5,6,7,8,0]).

move([A,B,C,D,E,F,G,H,0], left,  [A,B,C,D,E,0,G,H,F]).
move([A,B,C,D,E,F,G,0,I], left,  [A,B,C,D,0,F,G,E,I]).
move([A,B,C,D,0,F,G,H,I], left,  [A,B,C,0,D,F,G,H,I]).
move([A,B,C,0,E,F,G,H,I], up,    [0,B,C,A,E,F,G,H,I]).
move([A,B,C,D,0,F,G,H,I], up,    [A,0,C,D,B,F,G,H,I]).
move([A,B,C,D,E,0,G,H,I], up,    [A,B,0,D,E,C,G,H,I]).
move([A,B,C,D,E,F,0,H,I], up,    [A,B,C,0,E,F,D,H,I]).
move([A,B,C,D,E,F,G,0,I], up,    [A,B,C,D,0,F,G,E,I]).
move([A,B,C,D,E,F,G,H,0], up,    [A,B,C,D,E,0,G,H,F]).
move([A,B,C,D,E,F,0,H,I], right, [A,B,C,D,E,F,H,0,I]).
move([A,B,C,D,E,F,G,0,I], right, [A,B,C,D,E,F,G,I,0]).
move([A,B,C,D,0,F,G,H,I], right, [A,B,C,D,F,0,G,H,I]).
move([A,B,C,0,E,F,G,H,I], right, [A,B,C,E,0,F,G,H,I]).
move([A,B,C,D,E,0,G,H,I], down,  [A,B,C,D,E,I,G,H,0]).
move([A,B,C,D,0,F,G,H,I], down,  [A,B,C,D,H,F,G,0,I]).
move([A,B,C,0,E,F,G,H,I], down,  [A,B,C,G,E,F,0,H,I]).
move([A,B,C,D,E,0,G,H,I], left,  [A,B,C,D,0,E,G,H,I]).







solve(Start, Solution) :-
    bfs([[Start]], [], Solution).

bfs([[State | Path] | _], _, [State | Path]) :-
    goal(State).

bfs([[State | Path] | Rest], Visited, Solution) :-
    findall([Next, State | Path],
            (move(State, _, Next), \+ member(Next, [State | Path]), \+ member(Next, Visited)),
            NewPaths),
    append(Rest, NewPaths, Queue),
    bfs(Queue, [State | Visited], Solution).
