
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

  describe '.indent' do

    it 'adds nil columns to an array' do

      expect(
        Tafel.indent(2, [ [ 'a', 'b', ], [ 0, 1 ], [ 2, 3 ] ])
      ).to eq(
        [
          [ nil, nil, 'a', 'b' ],
          [ nil, nil, 0, 1 ],
          [ nil, nil, 2, 3 ]
        ]
      )
    end
  end
end

