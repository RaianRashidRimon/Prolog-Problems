quadratic_roots(A, B, C, Root1, Root2) :-
    D is B * B - 4 * A * C,
    D >= 0,
    Root1 is (-B + sqrt(D)) / (2 * A),
    Root2 is (-B - sqrt(D)) / (2 * A).
