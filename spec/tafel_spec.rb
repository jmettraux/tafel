
#
# specifying tafel
#
# Fri Apr  8 12:13:49 JST 2016
#

require 'spec_helper'


describe Tafel do

  context 'array of arrays' do

    it 'leaves them untouched' do

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
end

