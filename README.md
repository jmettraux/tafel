
# tafel

[![Build Status](https://secure.travis-ci.org/jmettraux/tafel.svg)](http://travis-ci.org/jmettraux/tafel)
[![Gem Version](https://badge.fury.io/rb/tafel.svg)](http://badge.fury.io/rb/tafel)

A Ruby library to turn pieces of data into arrays of arrays (tables).

## interface

Tafel provides 3 main methods.

### Tafel .to_htable .to_h

Turns the argument into a table where keys are arrayed horizontally.

```ruby
  require 'tafel'

  #
  # hash of hashes

  Tafel.to_h(
    {
      'USD' => { code: 'USD', change: 1.0, min: 500, status: 'active' },
      'EUR' => { code: 'EUR', change: 1.07, status: 'active' },
      'CHF' => { code: 'CHF', change: 1.08, min: 700 }
    }
  )
    # ==>
      [
        [ :key, :code, :change, :min, :status ],
        [ 'USD', 'USD', 1.0, 500, 'active' ],
        [ 'EUR', 'EUR', 1.07, nil, 'active' ],
        [ 'CHF', 'CHF', 1.08, 700, nil ]
      ]

  #
  # array of hashes

  Tafel.to_htable(
    [
      { a: 1, b: 2 },
      { a: 3, b: 4, c: 5 },
      { a: 6, c: 7 }
    ]
  )
    # ==>
      [
        [ :a, :b, :c ],
        [ 1, 2, nil ],
        [ 3, 4, 5 ],
        [ 6, nil, 7 ]
      ]

  #
  # plain hash

  Tafel.to_htable(
    { a: 3, b: 4, c: 5 }
  )
    # ==>
      [
        [ :a, :b, :c ],
        [ 3, 4, 5 ]
      ]
```

### Tafel .to_vtable .to_v

Turns the argument into a table where keys are arrayed vertically.

It leaves non-array and no-hash instances as is.

```ruby
  require 'tafel'

  Tafel.to_v(
    { interpreter: 'Leo Ferre', song: { name: "C'est extra", year: 1969 } }
  )
    # ==>
      [
        [ :interpret, 'Leo Ferre' ],
        [ :song, [ [ :name, "C'est extra" ], [ :year, 1969 ] ] ]
      ]
```

It accepts a limit integer parameter defaulting to -1 (recurse entirely). For example:

```ruby
  Tafel.to_v(
    { interpreter: 'Leo Ferre', song: { name: "C'est extra", year: 1969 } },
    1
  )
    # ==>
      [
        [ :interpret, 'Leo Ferre' ],
        [ :song, { name: "C'est extra", year: 1969 } ]
      ]
```

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

