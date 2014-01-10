require 'rubygems'
require 'gosu'
require '.\\Player'
require '.\\Shot'
require '.\\Bubble'

class GameWindow < Gosu::Window
  def initialize
    super 1024, 768, false
    self.caption = 'Parallax Scroller'

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    @parallax = Array.new
    @parallax.push(BGLayer.new(self, 500, 0xff101010))
    @parallax.push(BGLayer.new(self, 250, 0xff303030))
    @parallax.push(BGLayer.new(self, 250, 0xff606060))
    @parallax.push(BGLayer.new(self, 250, 0xff909090))
    @parallax.push(BGLayer.new(self, 250, 0xffc0c0c0))
    @parallax.push(BGLayer.new(self, 100, 0xfff0f0f0))
    @parallax.push(BGLayer.new(self, 50, 0xffffffff))

    @player = Player.new(self)
    @player.warp(self.width / 2, self.height / 2)
  end

  def update
    if button_down? Gosu::KbLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp then
      @parallax.each {|layer| layer.accelerate(@player.angle-180)}
      @player.burn = true
    else
      @player.burn = false
    end
    if button_down? Gosu::KbDown then
    end

    @parallax.each_with_index {|layer, index| layer.move_motes(index)}
    @player.move
  end

  def draw
    @parallax.each {|layer| layer.draw}
    @player.draw
  end

  def button_down(id)
  	if id == Gosu::KbEscape
  		close
  	end
  end
end

class BGLayer
  def initialize(window, mote_count, mote_color)
    @motes = Array.new
    @mote_color = mote_color
    @window = window
    @a = @vel_x = @vel_y = 0.0
    while @motes.size < mote_count
      @motes.push(Mote.new(window, ".", @mote_color, rand(window.width), rand(window.height)))
    end
  end

  def accelerate(angle)
    @vel_x += Gosu::offset_x(angle, 0.5)
    @vel_y += Gosu::offset_y(angle, 0.5)
  end

  def draw
    @motes.each {|mote| mote.draw}
  end

  def move_motes(rate)
    @motes.each {|mote| mote.move(@vel_x*rate,@vel_y*rate)}
    @vel_x *= 0.96
    @vel_y *= 0.96
  end
end

class Mote
  attr_accessor :x, :y, :a, :color

  @color = nil

  def initialize(window, text, mote_color, x, y, angle = 0)
    @x = x
    @y = y
    @a = angle
    @rot_vel = 0
    @window = window
    @image = Gosu::Image.from_text(@window, text, Gosu::default_font_name, 30, 10, 200, :center)
    @color = mote_color
  end

  def move(x,y)
    @x += x
    @y += y
    @a += @rot_vel
    @x %= @window.width
    @y %= @window.height
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Stars, @a, 0.5, 0.5, 1, 1, @color)
  end
end

module ZOrder
  Background, Stars, Player, Shield, UI = *0..4
end

window = GameWindow.new
window.show