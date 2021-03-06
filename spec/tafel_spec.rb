
#
# specifying tafel
#
# Fri Apr  8 12:13:49 JST 2016
#

require 'spec_helper'


describe Tafel do

  describe '.table?' do

    it 'returns true if the argument is a table' do

      expect(Tafel.table?([])).to eq(true)
      expect(Tafel.table?([ [], [], [] ])).to eq(true)
    end

    it 'returns false if the argument is not a table' do

      expect(Tafel.table?(:x)).to eq(false)
      expect(Tafel.table?(1)).to eq(false)
      expect(Tafel.table?({})).to eq(false)
      expect(Tafel.table?([ 1, 2, 3 ])).to eq(false)
    end
  end

#  describe '.array' do
#
#    it 'arrays a hash into a tree' do
#
#        expect(Tafel.array(
#          {
#            'USD' => { 'code' => 'USD', 'change' => 1.01 },
#            'CHF' => { 'code' => 'CHF', 'change' => 1.08 }
#          }
#        )).to eq(
#          [
#            [ 'USD', [ [ 'code', 'USD' ], [ 'change', 1.01 ] ] ],
#            [ 'CHF', [ [ 'code', 'CHF' ], [ 'change', 1.08 ] ] ],
#          ]
#        )
#    end
#
#    it 'turns a hash into a tree' do
#
#      expect(Tafel.array(
#        { profile: { eyes: 'brown', hair: 'brown' },
#          numbers: [ 1, 2, 3, 5 ],
#          tools: {
#            pocket: [ 'swiss army knife', 'spyderco' ],
#            toolbox: [ { name: 'screwdriver', brand: 'makita' } ] } }
#      )).to eq(
#        [
#          [ :profile, [ [ :eyes, 'brown' ], [ :hair, 'brown' ] ] ],
#          [ :numbers, [ 1, 2, 3, 5 ] ],
#          [ :tools, [
#            [ :pocket, [ 'swiss army knife', 'spyderco' ] ],
#            [ :toolbox, [ [ [ :name, 'screwdriver' ], [ :brand, 'makita' ] ] ] ]
#          ] ]
#        ]
#      )
#    end
#  end

  describe '.to_htable' do

    it 'leaves non-array and non-hash as is' do

      expect(Tafel.to_htable(1)).to eq(1)
      expect(Tafel.to_htable(:x)).to eq(:x)
      expect(Tafel.to_htable(true)).to eq(true)
      expect(Tafel.to_htable('oompf')).to eq('oompf')
    end

    it 'turns hashes of hashes to tables' do

      expect(Tafel.to_h(
        {
          'USD' => { code: 'USD', change: 1.0, min: 500, status: 'active' },
          'EUR' => { code: 'EUR', change: 1.07, status: 'active' },
          'CHF' => { code: 'CHF', change: 1.08, min: 700 }
        }
      )).to eq(
        [
          [ :key, :code, :change, :min, :status ],
          [ 'USD', 'USD', 1.0, 500, 'active' ],
          [ 'EUR', 'EUR', 1.07, nil, 'active' ],
          [ 'CHF', 'CHF', 1.08, 700, nil ]
        ]
      )
    end

    it 'turns arrays of hashes to tables' do

      expect(Tafel.to_htable(
        [
          { a: 1, b: 2 },
          { a: 3, b: 4, c: 5 },
          { a: 6, c: 7 }
        ]
      )).to eq(
        [
          [ :a, :b, :c ],
          [ 1, 2, nil ],
          [ 3, 4, 5 ],
          [ 6, nil, 7 ]
        ]
      )
    end

    it 'turns hashes to tables' do

      expect(Tafel.to_htable(
        { a: 3, b: 4, c: 5 }
      )).to eq(
        [
          [ :a, :b, :c ],
          [ 3, 4, 5 ]
        ]
      )
    end
  end

  describe '.to_vtable' do

    it 'turns a hash into a table' do

      expect(Tafel.to_v(
        { name: 'Leo Ferre', title: 'Mr', age: -1 }
      )).to eq(
        [
          [ :name, 'Leo Ferre' ],
          [ :title, 'Mr' ],
          [ :age, -1 ]
        ]
      )
    end

    it 'runs recursively' do

      expect(Tafel.to_v(
        { interpreter: 'Leo Ferre', song: { name: "C'est extra", year: 1969 } }
      )).to eq(
        [
          [ :interpreter, 'Leo Ferre' ],
          [ :song, [ [ :name, "C'est extra" ], [ :year, 1969 ] ] ]
        ]
      )
    end

    it 'accepts a "limit" int argument to control recursion' do

      expect(Tafel.to_v(
        { interpret: 'Leo Ferre', song: { name: "C'est extra", year: 1969 } },
        1
      )).to eq(
        [
          [ :interpret, 'Leo Ferre' ],
          [ :song, { name: "C'est extra", year: 1969 } ]
        ]
      )
    end

    it 'turns an array into a table' do

      expect(Tafel.to_v(
        [ 'aa', 'bb', 'cc' ]
      )).to eq(
        [
          [ 0, 'aa' ], [ 1, 'bb' ], [ 2, 'cc' ]
        ]
      )
    end

    it 'turns an hash of arrays into a table' do

      expect(Tafel.to_v(
        { 'a' => [ 'a', 'A' ], 'b' => [ 'b', 'B' ] }
      )).to eq(
        [
          [ 'a', [ [ 0, 'a' ], [ 1, 'A' ] ] ],
          [ 'b', [ [ 0, 'b' ], [ 1, 'B' ] ] ]
        ]
      )
    end
  end

  describe '.flatten' do

    it 'fails when the argument is not an array of arrays' do

      expect {
        Tafel.flatten(false)
      }.to raise_error(ArgumentError, 'not a table')
    end

    it 'does not flatten when not necessary (misc cases)' do

      expect(Tafel.flatten([])).to eq([])
      expect(Tafel.flatten([ [] ])).to eq([ [] ])
      expect(Tafel.flatten([ [ nil ] ])).to eq([ [ nil ] ])
      expect(Tafel.flatten([ [ nil ], [] ])).to eq([ [ nil ], [] ])
      expect(Tafel.flatten([ [ 1 ], [ 2 ] ])).to eq([ [ 1 ], [ 2 ] ])
    end

    it 'does not flatten when not necessary' do

      expect(Tafel.flatten(
        [ [ 0, 1 ], [ 2, 3 ] ]
      )).to eq(
        [ [ 0, 1 ], [ 2, 3 ] ]
      )
    end

    it 'flattens xxx' do

      expect(Tafel.flatten(
        [ [ 0, 1 ],
          [ 2 ] ]
      )).to eq(
        [ [ 0, 1 ],
          [ 2 ] ]
      )
    end

    it 'flattens a non-balanced array' do

      expect(Tafel.flatten(
        [ [ 0, 1 ], [ 2 ] ]
      )).to eq(
        [ [ 0, 1 ], [ 2 ] ]
      )
    end

    it 'flattens an empty array element' do

      expect(Tafel.flatten(
        [ [ 0, 1 ], [ [] ] ]
      )).to eq(
        [ [ 0, 1 ], [ nil, nil ] ]
      )
    end

    it 'flattens (0)' do

      expect(Tafel.flatten(
        [ [ 0, 1 ],
          [ 2, [ [ 3, 4 ], [ 5, 6 ] ] ] ]
      )).to eq(
        [ [ 0, 1, nil ],
          [ 2, 3, 4 ],
          [ nil, 5, 6 ] ]
      )
    end

    it 'flattens (1)' do

      expect(Tafel.flatten(
        [ [ 0, 1 ],
          [ 2, [ [ 3, 4 ], [ 5, 6 ] ] ],
          [ 7, [ [ 8, 9 ], [ 10 ] ] ] ]
      )).to eq(
        [ [ 0, 1, nil ],
          [ 2, 3, 4 ],
          [ nil, 5, 6 ],
          [ 7, 8, 9 ],
          [ nil, 10, nil ] ]
      )
    end

    it 'flattens (2)' do

      t = Tafel.to_v(
        { interpret: 'Leo Ferre', song: { name: "C'est extra", year: 1969 } })

      expect(Tafel.flatten(t)).to eq(
        [
          [ :interpret, 'Leo Ferre', nil ],
          [ :song, :name, "C'est extra" ],
          [ nil, :year, 1969 ]
        ]
      )
    end

    it 'only flattens one level' do

      expect(Tafel.flatten(
        [ [ 0, 1 ],
          [ 2, [ [ 3, 4 ], [ 5, [ 6, 7 ] ] ] ] ]
      )).to eq(
        [ [ 0, 1, nil ],
          [ 2, 3, 4 ],
          [ nil, 5, [ 6, 7 ] ] ]
      )
    end
  end
end

