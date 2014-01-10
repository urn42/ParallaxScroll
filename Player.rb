class Player
  attr_reader :x, :y, :angle
  attr_accessor :shot_power, :burn, :score, :health

  def initialize(window)
    @ship = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @rocket = Gosu::Image.new(window, "media/rocket_flame.png", false)
    @explosion = Gosu::Image.new(window, "media/explosion.png", false)
    @starCollectSound = Gosu::Sample.new(window, "media/Beep.wav")
    @explosionSound = Gosu::Sample.new(window, "media/Explosion.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
    @window = window
    @shot_power = 0
    @health = 100
    @burn = false
    @dead = false
    @expl_factor = 0.2
    @expl_trans = 255
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
    @burn = true
  end
  
  def move
    @x += @vel_x
    @y += @vel_y
    @x %= @window.width + @ship.width
    @y %= @window.height + @ship.width
    
    @vel_x *= 0.99
    @vel_y *= 0.99
  end

  def shake
  	@x += (rand - rand) * 3
  	@y += (rand - rand) * 3
  end

  def draw
    if @health <= 0 then
      explode
      #@explosion.draw(@x-(@explosion.width*0.4)/2.0, @y-(@explosion.height*0.4)/2.0, ZOrder::Shield, 0.4, 0.4, 0xffffffff)
      @explosion.draw(@x-(@explosion.width*@expl_factor)/2.0, @y-(@explosion.height*@expl_factor)/2.0, ZOrder::Shield, @expl_factor, @expl_factor, ((@expl_trans << 24) + 0x00ffffff))
      if Gosu::milliseconds % 10 == 0 then
        @expl_factor += 0.03 unless @expl_factor >= 0.5
        @expl_trans -= 5 unless @expl_trans <= 0
      end
    else
      @ship.draw_rot(@x, @y, 1, @angle)
      @rocket.draw_rot(@x, @y, 0.9, @angle, 0.5, -0.3, 0.3, 0.3) if @burn
    end
  end

  def explode
    if !@dead then
      @explosionSound.play
      @dead = true
    end
  end

  def score
  	@score
  end

  def collect_stars(stars)
  	if stars.reject! {|star| Gosu::distance(@x, @y, star.x, star.y) < 35} then
  		@score += 10
      @starCollectSound.play
  	end
  end
end