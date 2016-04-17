
# tafel

[![Build Status](https://secure.travis-ci.org/jmettraux/tafel.svg)](http://travis-ci.org/jmettraux/tafel)
[![Gem Version](https://badge.fury.io/rb/tafel.svg)](http://badge.fury.io/rb/tafel)

A Ruby library to turn pieces of data into arrays of arrays (tables).

## interface

### Tafel.turn

Input: array of hashes or hashes of hashes
Output: array of arrays (table)

TODO

### Tafel.grow

Input: hash
Output: array of arrays (table)

TODO

### Tafel.flatten

Turns nested tables into a single table.

```ruby
  require 'tafel'

  Tafel.flatten(
    [ [ 0, 1 ],
      [ 2, [ [ 3, 4 ], [ 5, 6 ] ] ] ]
  )
    # -->
      [ [ 0, 1, nil ],
        [ 2, 3, 4 ],
        [ nil, 5, 6 ] ]
```

## license

MIT, see LICENSE.txt

