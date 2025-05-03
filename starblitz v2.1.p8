pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- space-カ☉カ⬇️カ🐱オふカ█ "starblitz (beta)" オひオめカ◆ pico-8
-- オぬオのカ🐱オゆカ█: 88g

-- オかオˇオきオˇオうオˇオえオえオつオˇ オ▤ オ❎オ…オかオこオくオあオおオ★オつオˇ オえオ…オくオけオきオおオ▥オあオ▤
player = {x=64, y=120, w=8, h=8}
bullets = {}
enemies = {}
stars = {}
star_count = 30
score = 0
shoot_cooldown = 0
next_boss_score = 25   -- カ♥オふカ█オふオほ カ▒オむオゆオめカ😐オむオゆ オゆカ♥オむオゆオの カ▒オよオぬオのオやオまカ🐱カ▒カ◆ オねオゆカ▒カ▒

-- カ▒オむオゆカ█オゆカ▒カ🐱カ😐 オのカ█オぬオはオゆオの オま カ☉オぬオは カ⬇️カ▒オむオゆカ█オふオやオまカ◆
enemy_base_speed = 0.5
speed_increment = 0.2

-- game states: logo ヌ●★ play ヌ●★ game_over
game_state = "logo"
logo_timer = 0
logo_duration = 120   -- 120 オむオぬオひカ█オゆオの = 2 カ▒オふオむカ⬇️オやオひカ⬅️ オよカ█オま 60 fps

function reset_game()
  player.x = 64
  player.y = 120
  bullets = {}
  enemies = {}
  score = 0
  shoot_cooldown = 0
  next_boss_score = 25
  stars = {}
  for i=1,star_count do
    add(stars, { x=rnd(128), y=rnd(128), speed=rnd(0.5)+0.2 })
  end
end

function _init()
  game_state = "logo"
  logo_timer = 0
  reset_game()
end

function _update()
  if game_state == "logo" then
    logo_timer += 1
    if logo_timer > logo_duration or btnp(4) then
      game_state = "play"
    end

  elseif game_state == "play" then
    -- オひオのオまオへオふオやオまオふ オまオはカ█オゆオむオぬ カ▒カ🐱カ█オふオめオむオぬオもオま オま wasd
    if btn(0) or btn(4) then player.x -= 2 end   -- ヌ●… or a
    if btn(1) or btn(5) then player.x += 2 end   -- ヌ●★ or d
    if btn(2) or btn(17) then player.y -= 2 end  -- ヌ●➡️ or w
    if btn(3) or btn(18) then player.y += 2 end  -- ヌ●⧗ or s
    player.x = mid(0, player.x, 120)
    player.y = mid(0, player.y, 120)

    -- カ▒カ🐱カ█オふオめカ😐オねオぬ: z オま オいオあオう
    shoot_cooldown += 1
    if (btn(4) or stat(34)==1) and shoot_cooldown > 15 then
      add(bullets, {x=player.x+3, y=player.y})
      shoot_cooldown = 0
    end

    -- オゆオねオやオゆオのオめカ◆オふオも オよカ⬇️オめオま
    for b in all(bullets) do
      b.y -= 4
      if b.y < 0 then del(bullets, b) end
    end

    -- カ▒オよオぬオのオや オゆオねカ⬅️カ♥オやカ⬅️カ✽ オのカ█オぬオはオゆオの
    if rnd(100) < 1.5 then
      add(enemies, {x=rnd(120), y=-8, size=1})
    end

    -- カ▒オよオぬオのオや オねオゆカ▒カ▒オぬ オよカ█オま オひオゆカ▒カ🐱オまオへオふオやオまオま オよオゆカ█オゆオはオぬ
    if score >= next_boss_score then
      add(enemies, {x=rnd(120), y=-16, size=2, is_boss=true})
      next_boss_score += 25
    end

    -- オゆオねオやオゆオのオめカ◆オふオも オのカ█オぬオはオゆオの オま オよカ█オゆオのオふカ█カ◆オふオも オむオゆオめオめオまオほオまオま
    local enemy_speed = enemy_base_speed + flr(score/10) * speed_increment
    for e in all(enemies) do
      e.y += enemy_speed
      if e.y > 120 then game_state = "game_over" end
      if e.y > 128 then del(enemies, e) end

      -- オよカ⬇️オめカ◆-オのカ█オぬオは
      for b in all(bullets) do
        if abs(e.x - b.x) < 4*e.size and abs(e.y - b.y) < 4*e.size then
          del(enemies, e)
          del(bullets, b)
          score += 1
          break
        end
      end

      -- オのカ█オぬオは-オまオはカ█オゆオむ
      if abs(e.x - player.x) < 4*e.size and abs(e.y - player.y) < 4*e.size then
        game_state = "game_over"
      end
    end

    -- オゆオねオやオゆオのオめカ◆オふオも オほオのカ➡️オほオひカ⬅️ オのカ▒オふオはオひオぬ オの play
    for s in all(stars) do
      s.y += s.speed
      if s.y > 128 then
        s.y = 0
        s.x = rnd(128)
      end
    end

  elseif game_state == "game_over" then
    if btnp(4) then
      game_state = "logo"
      logo_timer = 0
      reset_game()
    end
  end
end

function _draw()
  if game_state == "logo" then
    cls(0)
    -- オめオゆオはオゆ オねオふオほ オほオのカ➡️オほオひオゆカ♥オふオむ
    local title = "starblitz (beta)"
    local tx = flr((128 - (#title*4)) / 2)
    local ty = 48
    print(title, tx, ty, 7)
    -- オのオふカ█カ▒オまカ◆ オま オぬオのカ🐱オゆカ█
    local info = "v2.1 - made by 88g"
    local ix = flr((128 - (#info*4)) / 2)
    print(info, ix, ty+16, 6)

  else
    -- カ░オゆオや オま オほオのカ➡️オほオひカ⬅️ (play オま game_over)
    cls(1)
    for s in all(stars) do pset(s.x, s.y, 7) end

    if game_state == "play" then
      -- オまオはカ█オゆオむ
      spr(0, player.x, player.y)
      -- オよカ⬇️オめオま
      for b in all(bullets) do rectfill(b.x, b.y, b.x+1, b.y+4, 10) end
      -- オのカ█オぬオはオま オま オねオゆカ▒カ▒カ⬅️
      for e in all(enemies) do spr(1, e.x, e.y, e.size, e.size, 1, 1) end
      print("score:"..score, 2, 2, 11)

    elseif game_state == "game_over" then
      -- オよオぬオやオふオめカ😐
      rectfill(0, 40, 127, 87, 0)
      local msg = "game over"
      local mx = flr((128 - (#msg*4)) / 2)
      local my = 56
      print(msg, mx, my, 8)
      print("press z to retry", flr((128-96)/2), my+16, 6)
    end
  end
end

__gfx__
00060000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666000008880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666600008880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666600088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666600088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666600088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666600088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
