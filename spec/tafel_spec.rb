
#
# specifying tafel
#
# Fri Apr  8 12:13:49 JST 2016
#

require 'spec_helper'


describe Tafel do

  describe '.turn' do

    context 'array of arrays' do

      it 'leaves it as is' do

        expect(Tafel.turn(
          [
            [ 'a', 'b' ],
            [ 1, 2 ]
          ]
        )).to eq(
          [
            [ 'a', 'b' ],
            [ 1, 2 ]
          ]
        )
      end
    end

    context 'array of hashes' do

      it 'turns it into an array of arrays' do

        expect(Tafel.turn(
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
    end

    context 'hashes of hashes' do

      it 'turns it into an array of arrays' do

        expect(Tafel.turn(
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
    end
  end

  describe '.array' do

    it 'arrays a hash into a tree' do

        expect(Tafel.array(
          {
            'USD' => { 'code' => 'USD', 'change' => 1.01 },
            'CHF' => { 'code' => 'CHF', 'change' => 1.08 }
          }
        )).to eq(
          [
            [ 'USD', [ [ 'code', 'USD' ], [ 'change', 1.01 ] ] ],
            [ 'CHF', [ [ 'code', 'CHF' ], [ 'change', 1.08 ] ] ],
          ]
        )
    end

    it 'turns a hash into a tree' do

      expect(Tafel.array(
        { profile: { eyes: 'brown', hair: 'brown' },
          numbers: [ 1, 2, 3, 5 ],
          tools: {
            pocket: [ 'swiss army knife', 'spyderco' ],
            toolbox: [ { name: 'screwdriver', brand: 'makita' } ] } }
      )).to eq(
        [
          [ :profile, [ [ :eyes, 'brown' ], [ :hair, 'brown' ] ] ],
          [ :numbers, [ 1, 2, 3, 5 ] ],
          [ :tools, [
            [ :pocket, [ 'swiss army knife', 'spyderco' ] ],
            [ :toolbox, [ [ [ :name, 'screwdriver' ], [ :brand, 'makita' ] ] ] ]
          ] ]
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

    it 'does not flatten when not necessary' do

      expect(Tafel.flatten(
        [ [ 0, 1 ], [ 2, 3 ] ]
      )).to eq(
        [ [ 0, 1 ], [ 2, 3 ] ]
      )
    end

    it 'flattens' do

      expect(Tafel.flatten(
        [ [ 0, 1 ],
          [ 2, [ [ 3, 4 ], [ 5, 6 ] ] ] ]
      )).to eq(
        [ [ 0, 1, nil ],
          [ 2, 3, 4 ],
          [ nil, 5, 6 ] ]
      )
    end

    it 'flattens' do

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

