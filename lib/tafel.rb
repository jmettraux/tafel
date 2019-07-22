
module Tafel

  VERSION = '1.0.2'

  def self.table?(o)

    o.is_a?(Array) && o.all? { |r| r.is_a?(Array) }
  end

  # .to_vtable: keys are arrayed vertically (y explosion)
  # .to_htable: keys are arrayed horizontally (x explosion)

  def self.to_vtable(x, limit=-1)

    return x if limit == 0

    case x
      when Hash then x.to_a.collect { |k, v| [ k, to_vtable(v, limit - 1) ] }
      when Array then x.inject([]) { |a, e| a << [ a.size, to_vtable(e) ]; a }
      else x
    end
  end

  def self.to_htable(x)

    kla0 = narrow_class(x)

    kla1 = nil
    if kla0
      vs = x.respond_to?(:values) ? x.values : x
      kla = narrow_class(vs.first)
      kla1 = vs.all? { |v| kla ? v.is_a?(kla) : false } ? kla : nil
    end

#p [ kla0, kla1 ]
    case [ kla0, kla1 ]
      when [ Hash, Hash ] then to_h_hash_hash(x)
      when [ Array, Hash ] then to_h_array_hash(x)
      when [ Hash, nil ] then to_h_hash(x)
      else x
    end
  end

  class << self
    alias to_v to_vtable
    alias to_h to_htable
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

      next unless s

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

    if table?(o) && o.any?
      [ o.collect { |r| r.size }.max, o.size ]
    else
      [ 0, 0 ]
    end
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
    end if table.any?
  end

  def self.narrow_class(x)

    return Array if x.is_a?(Array)
    return Hash if x.is_a?(Hash)
    nil
  end

  def self.to_h_hash_hash(h)

    keys = h.values.inject([ :key ]) { |ks, v| ks.concat(v.keys) }.uniq
    table = [ keys ]

    h.each do |k, v|
      table << keys[1..-1].inject([ k ]) { |row, key| row << v[key]; row }
    end

    table
  end

  def self.to_h_hash(h)

    [ h.keys, h.inject([]) { |a, (k, v)| a << v; a } ]
  end

  def self.to_h_array_hash(a)

    keys = a.inject([]) { |ks, h| ks.concat(h.keys) }.uniq
    table = [ keys ]

    a.each do |h|
      table << keys.inject([]) { |row, key| row << h[key]; row }
    end

    table
  end
end

