#!/usr/bin/env ruby

require "fiber"

KNOWN_POINTS = [
  {
    r: 0.6834035815381081,
    i: -0.3402545194889641,
    iter: 2,
    diverge: true,
  },
  {
    r: 0.4574076276188268,
    i: -0.3402545194889641,
    iter: 11,
    diverge: true,
  },
  {
    r: -0.38336576121887034,
    i: 0.31978497746348045,
    iter: 80,
    diverge: false,
  },
  {
    r: -0.38311082319380874,
    i: -0.640229531019499,
    iter: 23,
    diverge: true,
  },
  {
    r: -0.5458855742667235,
    i: 0.5192757454218333,
    iter: 17,
    diverge: true,
  },
  {
    r: 0.01836587534857914,
    i: -0.8817678930191915,
    iter: 7,
    diverge: true
  },
  {
    r: -0.7516838256330622,
    i: -0.10958951286014185,
    iter: 27,
    diverge: true
  },
  {
    r: 0.3176599569166043,
    i: 0.5939607508203428,
    iter: 31,
    diverge: true
  }
]

#KNOWN_POINTS.concat ((1..10).map {
#  {
#    r: rand() * 2.0 - 1.0,
#    i: rand() * 2.0 - 1.0,
#    iter: 0,
#    diverge: false,
#  }
#})

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

KNOWN_POINTS.each_with_index do |point, i|
  STDERR.puts "Point: #{point.inspect}"
  test_z = Complex.rect point[:r], point[:i]

  f = mandel_fiber(test_z, 2.0)
  puts "Point: #{test_z.inspect}"

  iter, diverge = 0, false

  loop do
    z, iter, diverge = f.resume
    break if diverge
    break if iter >= 80
  end

  puts "  -> Point #{diverge ? "diverges" : "does not diverge"} after #{iter} iterations"

  if [iter, diverge] != [point[:iter], point[:diverge]]
    raise "Point #{i.inspect} fails! #{iter.inspect}, #{diverge.inspect} != (known) #{point[:iter].inspect}, #{point[:diverge].inspect}"
  end

  puts "\n\n"
end
