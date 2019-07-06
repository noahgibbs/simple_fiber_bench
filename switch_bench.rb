#!/usr/bin/env ruby

require "fiber"

OUTER_ITERS = 10_000

t0 = Time.now
OUTER_ITERS.times do
  f = Fiber.new do
    loop do
      Fiber.yield 75.0 * 75.0  # One float multiply - nice and quick
    end
  end

  100.times { f.resume }
end
tfinal = Time.now

total = tfinal - t0
elapsed = total.to_f
per_loop = elapsed / OUTER_ITERS

STDERR.puts "Per loop: #{per_loop.inspect}"
