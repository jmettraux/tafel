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

  VERSION = '0.3.0'

  def self.table?(o)

    o.is_a?(Array) && o.all? { |r| r.is_a?(Array) }
  end

  def self.to_vtable(x, limit=-1)

    return x if limit == 0

    case x
      when Hash then x.to_a.collect { |k, v| [ k, to_vtable(v, limit - 1) ] }
      when Array then x.collect { |e| [ to_vtable(e) ] }
      else x
    end
  end

  class << self
    alias to_v to_vtable
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

    ss.each do |row|
      maxh = row.collect { |cell| cell[1] }.max
      maxh = maxh < 1 ? 1 : maxh
      row.each { |cell| cell[1] = maxh }
    end
    ss.collect { |row| row.size }.max.times do |x|
      maxw = ss.collect { |row| cell = row[x]; cell ? cell[0] : 1 }.max
      maxw = maxw < 1 ? 1 : maxw
      ss.each { |row| cell = row[x]; cell[0] = maxw if cell }
    end

    w = ss.first.collect(&:first).reduce(&:+)
    h = ss.collect { |row| row[0].last }.reduce(&:+)

    a = Array.new(h) { Array.new(w) }

    iterate(ss) do |x, y, s|

      left = x > 0 ? ss[y][x - 1] : nil
      above = y > 0 ? ss[y - 1][x] : nil

      woff = left ? left[2] + left[0] : 0
      hoff = above ? above[3] + above[1] : 0

      s.push(woff, hoff)

      copy(a, woff, hoff, table[y][x])
    end

    a
  end

  protected # well...

  def self.size(o)

    table?(o) ? [ o.collect { |r| r.size }.max, o.size ] : [ 0, 0 ]
  end

  def self.copy(target, woff, hoff, source)

    if table?(source)
      iterate(source) { |x, y, v| target[hoff + y][woff + x] = v }
    else
      target[hoff][woff] = source
    end
  end

  def self.iterate(table)

    table.first.size.times do |x|
      table.size.times do |y|
        yield(x, y, table[y][x])
      end
    end
  end
end

