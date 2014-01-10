class Shot
  attr_reader :x, :y, :direction, :shot_power

  def initialize(window, image, player)
    @window = window
    @image = image
    @player = player
    @color = Gosu::Color.new(0xffff0000)
    @x = @player.x
    @y = @player.y
    @direction = @player.angle
    @power = @player.shot_power
    @x_trans = 0.1
    @y_trans = 0.2
    @velocity = 20.0
    @pewSound = Gosu::Sample.new(window, "media/LASER1.wav")
    @explosionSound = Gosu::Sample.new(window, "media/Explosion.wav")
    @pewSound.play
  end

  def draw
    @image.draw_rot(@x, @y, 0.9, 180.0+@direction, 0.5, 0.5, @x_trans, @y_trans)
  end

  def move
    @x += Gosu::offset_x(@direction, 0.5) * @velocity
    @y += Gosu::offset_y(@direction, 0.5) * @velocity
    if @x < (0 - @image.width * @x_trans) or 
      @y < (0 - @image.height * @y_trans) or 
      @x > (@window.width + @image.height * @x_trans) or 
      @y > (@window.height + @image.height * @y_trans) then
      @window.shots.pop
    end
  end

  def cause_damage(objects)
    if objects.reject! {|object| Gosu::distance(@x, @y, object.x, object.y) < 35} then
      @player.score += 100
      @explosionSound.play
    end
  end
end