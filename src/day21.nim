import
  algorithm,
  strformat,
  strutils,
  sequtils,
  sets,
  tables,
  npeg,
  aoc2020pkg/bench

type
  Food = tuple[ingredients: seq[string], allergens: seq[string]]

proc partOne(input: seq[Food]): string =
  var
    lookup: Table[string, HashSet[string]]
    allIngredients: CountTable[string]
  for (ingredients, allergens) in input:
    let ingredientSet = ingredients.toHashSet
    for ingredient in ingredients:
      allIngredients.inc(ingredient)
    for allergen in allergens:
      if lookup.hasKeyOrPut(allergen, ingredientSet):
        lookup[allergen] =  lookup[allergen].intersection(ingredientSet)
  var total = 0
  for ingredient, count in allIngredients:
    var hasAllergen = false
    for k, v in lookup:
      if v.contains(ingredient):
        hasAllergen = true
        break
    if not hasAllergen:
      total += count
  $total

proc partTwo(input: seq[Food]): string =
  var
    lookup: Table[string, HashSet[string]]
  for (ingredients, allergens) in input:
    let ingredientSet = ingredients.toHashSet
    for allergen in allergens:
      if lookup.hasKeyOrPut(allergen, ingredientSet):
        lookup[allergen] =  lookup[allergen].intersection(ingredientSet)
  var
    seen: HashSet[string]
    pairs: seq[tuple[ingredient, allergen: string]]
  while seen.len < lookup.len:
    for allergen, ingredients in lookup:
      var possible = ingredients.difference(seen)
      if possible.len == 1:
        seen.incl(possible)
        pairs.add((possible.pop, allergen))
  let byAllergen = pairs.sortedByIt(it.allergen)
  $byAllergen.mapIt(it.ingredient).join(",")

when isMainModule:
  echo "### DAY 21 ###"

  let input = stdin.readAll

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  var
    foods: seq[Food]
    ingredients: seq[string]
    allergens: seq[string]

  let parser = peg "foods":
    foods <- *(food * "\p") * !1
    food <- ingredients * ?(" " * allergens):
      foods.add((ingredients, allergens))
      ingredients = @[]
      allergens = @[]
    ingredients <- ingredient * *(" " * ingredient)
    allergens <- "(contains " * allergen * *(", " * allergen) * ")"
    ingredient <- >+Alpha:
      ingredients.add($1)
    allergen <- >+Alpha:
      allergens.add($1)

  doAssert parser.match(input).ok

  benchmark:
    echo(fmt"P1: {partOne(foods)}")
    echo(fmt"P2: {partTwo(foods)}")
