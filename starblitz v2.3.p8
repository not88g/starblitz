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
lives = 3                -- オへオまオほオやオま オまオはカ█オゆオむオぬ
next_extra_life = 15     -- オよオゆカ█オゆオは オひオめカ◆ オひオゆオねオぬオのオめオふオやオまカ◆ オへオまオほオやオま
shoot_cooldown = 0
next_boss_score = 25     -- カ♥オふカ█オふオほ カ▒オむオゆオめカ😐オむオゆ オゆカ♥オむオゆオの カ▒オよオぬオのオやオまカ🐱カ▒カ◆ オねオゆカ▒カ▒

-- カ▒オむオゆカ█オゆカ▒カ🐱カ😐 オのカ█オぬオはオゆオの オま カ☉オぬオは カ⬇️カ▒オむオゆカ█オふオやオまカ◆
enemy_base_speed = 0.5
speed_increment = 0.2

-- game states: logo ヌ●★ play ヌ●★ game_over
game_state = "logo"
logo_timer = 0
logo_duration = 120      -- 120 オむオぬオひカ█オゆオの = 2 カ▒オふオむカ⬇️オやオひカ⬅️ オよカ█オま 60 fps

-- カ⬇️カ🐱オまオめオまカ🐱オぬ オよカ█オゆオのオふカ█オむオま オよオふカ█オふカ▒オふカ♥オふオやオまカ◆ オよカ█カ◆オもオゆカ⬇️オはオゆオめカ😐オやオまオむオゆオの
function rect_overlap(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and x1+w1 > x2 and y1 < y2+h2 and y1+h1 > y2
end

function reset_game()
  player.x = 64
  player.y = 120
  bullets = {}
  enemies = {}
  score = 0
  lives = 3
  next_extra_life = 15
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
    -- オひオのオまオへオふオやオまオふ カ▒カ🐱カ█オふオめオむオぬオもオま
    if btn(0) then player.x -= 2 end
    if btn(1) then player.x += 2 end
    if btn(2) then player.y -= 2 end
    if btn(3) then player.y += 2 end
    player.x = mid(0, player.x, 120)
    player.y = mid(0, player.y, 120)

    -- カ▒カ🐱カ█オふオめカ😐オねオぬ: z/x オま オいオあオう
    shoot_cooldown += 1
    if (btnp(4) or btnp(5) or stat(34)==1) and shoot_cooldown > 15 then
      add(bullets, {x=player.x+3, y=player.y, t=0})
      shoot_cooldown = 0
    end

    -- オゆオねオやオゆオのオめオふオやオまオふ オよカ⬇️オめカ😐
    for b in all(bullets) do
      b.y -= 4
      b.t += 1
      if b.y < 0 then del(bullets, b) end
    end

    -- カ▒オよオぬオのオや オのカ█オぬオはオゆオの (カ🐱オゆオめカ😐オむオゆ オゆオひオまオや)
    if #enemies == 0 and rnd(100) < 1.5 then
      add(enemies, {x=rnd(120), y=-8, size=1})
    end

    -- カ▒オよオぬオのオや オねオゆカ▒カ▒オぬ オよカ█オま オひオゆカ▒カ🐱オまオへオふオやオまオま オよオゆカ█オゆオはオぬ
    if score >= next_boss_score then
      add(enemies, {x=rnd(120), y=-16, size=2, is_boss=true})
      next_boss_score += 25
    end

    -- オゆオねオやオゆオのオめオふオやオまオふ オのカ█オぬオはオゆオの オま オむオゆオめオめオまオほオまオま
    local enemy_speed = enemy_base_speed + flr(score/10)*speed_increment
    for e in all(enemies) do
      e.y += enemy_speed
      if e.y > 128 then del(enemies, e) end

      -- カ▒カ🐱オゆオめオむオやオゆオのオふオやオまオふ オよカ⬇️オめカ◆-オのカ█オぬオは
      for b in all(bullets) do
        if rect_overlap(b.x, b.y, 2,4, e.x, e.y, 8*e.size, 8*e.size) then
          del(enemies, e)
          del(bullets, b)
          score += 1
          -- オひオゆオねオぬオのオめカ◆オふオも オへオまオほオやカ😐 オむオぬオへオひオゆオふ オひオゆカ▒カ🐱オまオへオふオやオまオふ オよオゆカ█オゆオはオぬ
          if score >= next_extra_life then
            lives += 1
            next_extra_life += 15
          end
          break
        end
      end

      -- カ▒カ🐱オゆオめオむオやオゆオのオふオやオまオふ オのカ█オぬオは-オまオはカ█オゆオむ
      if rect_overlap(player.x, player.y, player.w, player.h,
                      e.x, e.y, 8*e.size, 8*e.size) then
        lives -= 1
        del(enemies, e)
        if lives <= 0 then
          game_state = "game_over"
        end
      end
    end

    -- オゆオねオやオゆオのオめオふオやオまオふ オほオのカ➡️オほオひ
    for s in all(stars) do
      s.y += s.speed
      if s.y > 128 then s.y = 0; s.x = rnd(128) end
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
    local title = "starblitz (beta)"
    local tx = flr((128-#title*4)/2)
    local ty = 48
    print(title, tx, ty, 7)
    local info = "v2.3 - made by 88g"
    local ix = flr((128-#info*4)/2)
    print(info, ix, ty+16, 6)

  else
    -- カ░オゆオや オま オほオのカ➡️オほオひカ⬅️
    cls(1)
    for s in all(stars) do pset(s.x, s.y, 7) end

    if game_state == "play" then
      -- オまオはカ█オゆオむ
      spr(0, player.x, player.y)
      -- オよカ⬇️オめオま
      for b in all(bullets) do
        if b.t < 2 then
          rectfill(b.x, b.y, b.x+1, b.y+1, 8)
        else
          rectfill(b.x, b.y, b.x+1, b.y+1, 9)
          rectfill(b.x, b.y+2, b.x+1, b.y+3, 9)
        end
      end
      -- オのカ█オぬオはオま オま オねオゆカ▒カ▒カ⬅️
      for e in all(enemies) do spr(1, e.x, e.y, e.size, e.size, 1,1) end
      -- hud
      print("score:"..score, 2, 2, 11)
      print("lives:"..lives, 2, 10, 11)

    elseif game_state == "game_over" then
      rectfill(0,40,127,87,0)
      local msg = "game over"
      local mx = flr((128-#msg*4)/2)
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
