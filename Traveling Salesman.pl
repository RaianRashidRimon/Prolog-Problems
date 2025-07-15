% Distance between cities (Graph Representation)
distance(a, b, 10).
distance(a, c, 15).
distance(a, d, 20).
distance(b, c, 35).
distance(b, d, 25).
distance(c, d, 30).

% Since the graph is undirected, add reverse distances
route(X, Y, D) :- distance(X, Y, D).
route(Y, X, D) :- distance(X, Y, D).

% Find all possible paths and their costs
tsp(Start, Path, Cost) :-
    findall(P, permute([b, c, d], P), Permutations),  % Generate all city permutations
    findall(C, (member(P, Permutations), tour_cost([Start|P], Start, C)), Costs),
    min_member(Cost, Costs),   % Get minimum cost
    member(Path, Permutations),
    tour_cost([Start|Path], Start, Cost).  % Get the best path

% Calculate cost of a tour (visiting all and returning)
tour_cost([Last], Start, Cost) :- route(Last, Start, Cost).
tour_cost([A, B | Rest], Start, Cost) :-
    route(A, B, C1),
    tour_cost([B | Rest], Start, C2),
    Cost is C1 + C2.

% Generate permutations of a list (Helper function)
permute([], []).
permute(L, [H|T]) :- select(H, L, R), permute(R, T).
