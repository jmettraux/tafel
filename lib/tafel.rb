#--
# Copyright (c) 2016-2016, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.
#++


module Tafel

  VERSION = '0.2.0'

  def self.turn(data, opts={})

    data = to_array(data)

    if data.all? { |row| row.is_a?(Array) }
      data
    elsif data.all? { |row| row.is_a?(Hash) }
      turn_array_of_hashes(data)
    else
      nil
    end
  end

  def self.table?(o)

    o.is_a?(Array) && o.all? { |r| r.is_a?(Array) }
  end

  def self.size(o)

#p [ o, '-->', table?(o) ? [ o.collect { |r| r.size }.max, o.size ] : 0 ]
    table?(o) ? [ o.collect { |r| r.size }.max, o.size ] : [ 0, 0 ]
  end

  def self.flatten(table)

    fail ArgumentError.new('not a table') unless table?(table)

    flat = true

    table =
      table.collect { |r|
        r.collect { |c| next c unless table?(c); flat = false; flatten(c) }
      }

    return table if flat

    ss = table.collect { |r| r.collect { |c| size(c) } }

    ws, hs = [ [], [] ]
    iterate(ss) { |x, y, s| ws[x], hs[y] = s[0], s[1] }

    w = ws.inject(0) { |i, w| i + (w > 0 ? w : 1) }
    h = hs.inject(0) { |i, h| i + (h > 0 ? h : 1) }

    a = Array.new(h) { Array.new(w) }

    iterate(ss) do |x, y, s|
p [ x, y, '->', table[y][x], '/', s, '/', ws[x], hs[y] ]
      left = x > 0 ? ss[y][x - 1] : nil
      above = y > 0 ? ss[y - 1][x] : nil
p [ 'left', left, 'above', above ]
      woff = left ? left[2] + [ 1, left[0] ].max : 0
      hoff = above ? above[3] + [ 1, above[1] ].max : 0
      s.push(woff, hoff)
p [ '->', s ]
      a
    end

    #w =
    #  table.collect(&:size).max
    #sizes =
    #  table.collect { |r|
    #    r.collect { |c| size(c) }.concat([ nil ] * (w - r.size))
    #  }
    #sizes =
    #  sizes.collect { |r|
    #    maxh = r.collect(&:last).max
    #    r.collect { |w, h| [ w, maxh ] }
    #  }
    #(0..sizes.first.size - 1).each { |i|
    #  maxw = (0..sizes.size - 1).collect { |j| sizes[j][i].first }.max
    #  (0..sizes.size - 1).each { |j| sizes[j][i][0] = maxw }
    #}
      #
    #iterate(table) do |x, y, v|
    #  p [ x, y, '->', v, sizes[y][x] ]
    #end

    a

    #w = table.collect(&:size).max
    #table.each { |row| row.concat([ nil ] * (w - row.size)) }

    #table.collect { |row|
    #  h = row.collect { |cell| table?(cell) ? row.size : 1 }.max
    #  row.collect { |cell|
    #    table?(cell) ?
    #  }
    #}.flatten(1)
  end

  protected

  def self.iterate(table)

    (0..table.first.size - 1).each do |x|
      (0..table.size - 1).each do |y|
        yield(x, y, table[y][x])
      end
    end
  end

  def self.to_array(data)

    if data.is_a?(Array)

      data

    elsif data.is_a?(Hash) && data.values.all? { |v| v.is_a?(Hash) }

      data.collect { |k, v| { key: k }.update(v) }

    else

      fail ArgumentError.new("cannot turn root input into an array")
    end
  end

  def self.turn_array_of_hashes(data)

    keys = data.inject([]) { |a, row| a.concat(row.keys) }.uniq

    [ keys ] + data.collect { |row| keys.collect { |k| row[k] } }
  end
end

