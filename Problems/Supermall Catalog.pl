% Supermall catalog: item(Name, Price in Taka).
item(rice, 60).
item(flour, 45).
item(sugar, 80).
item(milk, 120).
item(bread, 50).
item(egg, 12).
item(chicken, 240).
item(beef, 600).
item(fish, 300).
item(apple, 180).
item(banana, 10).
item(orange, 150).
item(soap, 50).
item(shampoo, 120).
item(toothpaste, 90).
item(tea, 200).
item(coffee, 400).
item(butter, 550).
item(cheese, 500).
item(yogurt, 70).
item(honey, 600).
item(biscuits, 80).
item(chocolate, 250).
item(nuts, 750).
item(cooking_oil, 180).
item(salt, 35).
item(spices, 150).
item(onion, 80).
item(garlic, 120).
item(potato, 40).
item(carrot, 60).
item(tomato, 90).
item(cucumber, 50).
item(cabbage, 100).
item(cauliflower, 130).
item(lettuce, 90).
item(mango, 200).
item(watermelon, 350).
item(grapes, 280).
item(peach, 220).
item(strawberry, 400).
item(soft_drink, 70).
item(juice, 150).
item(mineral_water, 30).
item(detergent, 250).
item(handwash, 180).
item(shaving_cream, 350).
item(deodorant, 500).
item(perfume, 1200).





total_cost([], 0).
total_cost([Item|Rest], Total) :-
    item(Item, Price), 
    total_cost(Rest, Subtotal), 
    Total is Price + Subtotal. % Sum up prices
