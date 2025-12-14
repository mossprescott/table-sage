# Visualizing the League Table

Experiments with showing the table for a football (soccer) league, where not all clubs have
necessarily played the same number of matches, and different clubs have upcoming matches
of varying difficulty.

The idea is to render the whole season (or a portion of it at a time), with each club's point
total growing (or not) with each match.
- when one club has a match to play, you can see how its points total compares to the other clubs' *before* they played again.
- you can see the "form" of each club in the shape of its points over time
- future results are projected in a simple way, to give a general idea of what might happen next
- lots of options to play around and see what works

## TODO

Experiment with actually predicting match results based on each club's home and away results so
far. This won't be very sophisticated, but hopefully good enough to give a sense of who has a
tough series of matches coming up.

Keep improving the display:
- indicate in the overall graph which results are projected
- ways to focus the view on just recent results, or just a subset of clubs, etc.

## Demo

See it in action at [index.html](https://mossprescott.github.io/table-sage/index.html).