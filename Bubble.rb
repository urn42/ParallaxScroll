class Bubble
	attr_reader :x, :y

	def initialize(image, window)
		@image = image
		@color = Gosu::Color.new(0xff000000)
		@color.red = rand(256-40) +40
		@color.green = rand(256-40) +40
		@color.blue = rand(256-40) +40
		@x = rand * window.width
		@y = rand * window.height
    @direction = rand(360)
    @window = window
	end

	def draw
		@image.draw(@x - @image.width / 2.0, @y - @image.height / 2.0, ZOrder::Stars, 1, 1, @color, :add)
	end

  def move
    @x += Gosu::offset_x(@direction, 0.5)
    @y += Gosu::offset_y(@direction, 0.5)
    @x %= @window.width + @image.width
    @y %= @window.height + @image.width
  end

  def collect_stars(stars)
    if stars.reject! {|star| Gosu::distance(@x, @y, star.x, star.y) < 35} then
      #sound or something
    end
  end

  def attack(player)
    if Gosu::distance(@x, @y, player.x, player.y) < 35 && player.health > 0 then
      player.shake
      player.health -= 1
    end 
  end
end