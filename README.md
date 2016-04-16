
# tafel

[![Build Status](https://secure.travis-ci.org/jmettraux/tafel.svg)](http://travis-ci.org/jmettraux/tafel)
[![Gem Version](https://badge.fury.io/rb/tafel.svg)](http://badge.fury.io/rb/tafel)

A Ruby library to turn pieces of data into arrays of arrays (tables).

## interface

### Tafel.turn

Turns an array of hashes into an array of arrays.

TODO

### Tafel.grow

Turns a hash into an array of arrays.

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

