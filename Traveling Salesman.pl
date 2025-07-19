% Distance between cities (Graph Representation)
distance(a, b, 10).
distance(a, c, 15).
distance(a, d, 20).
distance(b, c, 35).
distance(b, d, 25).
distance(c, d, 30).

route(X, Y, D) :- distance(X, Y, D).
route(Y, X, D) :- distance(X, Y, D).




tsp(Start, Path, Cost) :-
    findall(P, permute([b, c, d], P), Permutations), 
    findall(C, (member(P, Permutations), tour_cost([Start|P], Start, C)), Costs),
    min_member(Cost, Costs), 
    member(Path, Permutations),
    tour_cost([Start|Path], Start, Cost).  






tour_cost([Last], Start, Cost) :- route(Last, Start, Cost).
tour_cost([A, B | Rest], Start, Cost) :-
    route(A, B, C1),
    tour_cost([B | Rest], Start, C2),
    Cost is C1 + C2.


permute([], []).
permute(L, [H|T]) :- select(H, L, R), permute(R, T).
