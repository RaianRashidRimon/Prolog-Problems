:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(clpfd)).

% Define cities and distances
distances(a, b, 10).
distances(a, c, 15).
distances(a, d, 20).
distances(b, c, 35).
distances(b, d, 25).
distances(c, d, 30).
distances(X, Y, D) :- distances(Y, X, D), X \= Y.
distances(X, X, 0).

cities([a, b, c, d]).

% Tour distance
tour_distance([_], _, 0).
tour_distance([City1, City2 | Rest], _, Distance) :-
    distances(City1, City2, D1),
    tour_distance([City2 | Rest], _, D2),
    Distance is D1 + D2.
tour_distance(Tour, Distance) :-
    append(Tour, [First], ClosedTour),
    Tour = [First | _],
    tour_distance(ClosedTour, _, Distance).

% Random tour
random_tour(Tour) :-
    cities(Cities),
    random_permutation(Cities, Tour).

% Population
generate_population(Size, Population) :-
    length(Population, Size),
    maplist(random_tour, Population).

% Fitness
fitness(Tour, Fitness) :-
    tour_distance(Tour, Distance),
    (Distance =:= 0 -> Fitness = 0; Fitness is 10000 / Distance).

% Tournament selection
tournament_selection(Population, Parent) :-
    random(1, 5, K),
    length(Population, PopSize),
    findall(I, (between(1, K, _), random(1, PopSize, I)), Indices),
    maplist(nth1, Indices, Population, Candidates),
    maplist(fitness, Candidates, Fitnesses),
    max_list(Fitnesses, MaxFitness),
    nth1(Index, Fitnesses, MaxFitness),
    nth1(Index, Candidates, Parent).

% Ordered crossover
ordered_crossover(Parent1, Parent2, Child) :-
    length(Parent1, Len),
    random(1, Len, Start),
    random(Start, Len, End),
    segment(Start, End, Parent1, Segment),
    findall(X, (member(X, Parent2), \+ member(X, Segment)), Remaining),
    BeforeLen is Start - 1,
    length(Before, BeforeLen),
    length(Segment, SegLen),
    AfterLen is Len - Start - SegLen + 1,
    length(After, AfterLen),
    append(Before, After, Temp),
    append(Temp, Segment, Child),
    append(Before, After, Remaining).

% Segment
segment(Start, End, List, Segment) :-
    Start1 is Start - 1,
    length(Before, Start1),
    append(Before, Rest, List),
    SegLen is End - Start + 1,
    length(Segment, SegLen),
    append(Segment, _, Rest).

% Mutation
mutate(Tour, Mutated) :-
    length(Tour, Len),
    random(1, Len, I),
    random(1, Len, J),
    I \= J,
    nth1(I, Tour, CityI),
    nth1(J, Tour, CityJ),
    replace(I, CityJ, Tour, Temp),
    replace(J, CityI, Temp, Mutated).
mutate(Tour, Tour).

% Replace
replace(1, X, [_ | T], [X | T]).
replace(N, X, [H | T], [H | R]) :-
    N > 1,
    N1 is N - 1,
    replace(N1, X, T, R).

% New generation
new_generation(Population, NewPopulation) :-
    length(Population, PopSize),
    length(NewPopulation, PopSize),
    generate_new_population(PopSize, Population, NewPopulation).

generate_new_population(0, _, []).
generate_new_population(N, Population, [Child | Rest]) :-
    N > 0,
    tournament_selection(Population, Parent1),
    tournament_selection(Population, Parent2),
    ordered_crossover(Parent1, Parent2, Child1),
    (random(0, 100, R), R < 10 -> mutate(Child1, Child); Child = Child1),
    N1 is N - 1,
    generate_new_population(N1, Population, Rest).

% Best tour
best_tour(Population, BestTour, BestDistance) :-
    maplist(tour_distance, Population, Distances),
    min_list(Distances, BestDistance),
    nth1(Index, Distances, BestDistance),
    nth1(Index, Population, BestTour).

% Genetic algorithm
genetic_tsp(PopSize, Generations, BestTour, BestDistance) :-
    generate_population(PopSize, Population),
    evolve(PopSize, Generations, Population, BestTour, BestDistance).

evolve(_, 0, Population, BestTour, BestDistance) :-
    best_tour(Population, BestTour, BestDistance).
evolve(PopSize, Gen, Population, BestTour, BestDistance) :-
    Gen > 0,
    new_generation(Population, NewPopulation),
    Gen1 is Gen - 1,
    evolve(PopSize, Gen1, NewPopulation, BestTour, BestDistance).

% Run
run_tsp :-
    PopSize = 50,
    Generations = 100,
    genetic_tsp(PopSize, Generations, BestTour, BestDistance),
    format('Best Tour: ~w~n', [BestTour]),
    format('Distance: ~w~n', [BestDistance]).