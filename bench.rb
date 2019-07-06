#!/usr/bin/env ruby

require "fiber"

def mandel_fiber(c, radius)
  Fiber.new do
    z = c
    iter = 0
    diverge = false

    # "If the series of Zs will always stay close to c and never trend away, that
    #  point is in the Mandelbrot set." -- Jonathan Coulton, "Mandelbrot Set"
    loop do
      if z.abs > radius
        diverge = true
        Fiber.yield z, iter, diverge
        break
      end
      iter += 1
      z = z * z + c
      Fiber.yield z, iter, diverge if iter % 10 == 0
    end
  end
end

10.times do
  test_point = Complex.rect(rand() * 2.0 - 1.0, rand() * 2.0 - 1.0)

  f = mandel_fiber(test_point, 2.0)
  puts "Point: #{test_point.inspect}"

  iter, diverge = 0, false

  loop do
    z, iter, diverge = f.resume
    break if diverge
    break if iter >= 80
  end

  puts "  -> Point #{diverge ? "diverges" : "does not diverge"} after #{iter} iterations"

  puts "\n\n"
end
