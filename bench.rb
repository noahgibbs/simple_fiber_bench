#!/usr/bin/env ruby

require "fiber"

def mandel_fiber(c)
  Fiber.new do
    z = c

    # "If the series of Zs will always stay close to c and never trend away, that
    #  point is in the Mandelbrot set." -- Jonathan Coulton, "Mandelbrot Set"
    loop do
      10.times { z = z * z + c }
      Fiber.yield z
    end
  end
end

10.times do
  test_point = Complex.rect(rand() * 2.0 - 1.0, rand() * 2.0 - 1.0)
  diverge = false

  f = mandel_fiber(test_point)
  puts "Point: #{test_point.inspect}"

  8.times do |i|
    z = f.resume
    if z.abs > 2.0
      diverge = true
      puts "  -> Point diverges after #{i+1}0 iterations"
      break
    end
  end

  unless diverge
    puts "  -> Point does not diverge after 80 iterations"
  end

  puts "\n\n"
end
