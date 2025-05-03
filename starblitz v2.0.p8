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
next_boss_score = 25  -- カ♥オふカ█オふオほ カ▒オむオゆオめカ😐オむオゆ オゆカ♥オむオゆオの カ▒オよオぬオのオやオまカ🐱カ▒カ◆ オねオゆカ▒カ▒

-- game states: logo ヌ●★ play ヌ●★ game_over
game_state = "logo"
logo_timer = 0
logo_duration = 120  -- 120 オむオぬオひカ█オゆオの = 2 カ▒オふオむカ⬇️オやオひカ⬅️ オよカ█オま 60 fps

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
    add(stars, { x=rnd(128), y=rnd(128), speed=rnd(1)+0.5 })
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
    -- オひオのオまオへオふオやオまオふ オまオはカ█オゆオむオぬ
    if btn(0) then player.x -= 2 end
    if btn(1) then player.x += 2 end
    if btn(2) then player.y -= 2 end  -- オのオよオふカ█カ➡️オひ
    player.x = mid(0, player.x, 120)
    player.y = mid(0, player.y, 120)

    -- カ▒カ🐱カ█オふオめカ😐オねオぬ
    shoot_cooldown += 1
    if btn(4) and shoot_cooldown > 15 then
      add(bullets, {x=player.x+3, y=player.y})
      shoot_cooldown = 0
    end

    -- オゆオねオやオゆオのオめカ◆オふオも オよカ⬇️オめオま
    for b in all(bullets) do
      b.y -= 4
      if b.y < 0 then del(bullets, b) end
    end

    -- カ▒オよオぬオのオや オのカ█オぬオはオゆオの
    if rnd(100) < 1.5 then
      add(enemies, {x=rnd(120), y=-8, size=1})
    end

    -- カ▒オよオぬオのオや オねオゆカ▒カ▒オぬ
    if score >= next_boss_score then
      add(enemies, {x=rnd(120), y=-16, size=2, is_boss=true})
      next_boss_score += 25
    end

    -- オゆオねオやオゆオのオめカ◆オふオも オのカ█オぬオはオゆオの オま オよカ█オゆオのオふカ█カ◆オふオも オむオゆオめオめオまオほオまオま
    for e in all(enemies) do
      e.y += 1
      -- オふカ▒オめオま オひオゆカ☉オめオま オひオゆ オやオまオほオぬ ヌ█⬆️ オよカ█オゆオまオはカ█カ⬅️カ☉
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
    -- オめオゆオはオゆ カ▒ オぬカ▒カ🐱オふカ█オまカ▒オむオぬオもオま
    local title = "*** starblitz (beta) ***"
    local tx = flr((128 - (#title*4)) / 2)
    local ty = 48
    print(title, tx, ty, 7)
    -- オのオふカ█カ▒オまカ◆ オま オぬオのカ🐱オゆカ█
    local info = "v2.0 - made by 88g"
    local ix = flr((128 - (#info*4)) / 2)
    print(info, ix, ty+16, 6)

  else
    -- カ░オゆオや オま オほオのカ➡️オほオひカ⬅️
    cls(1)
    for s in all(stars) do
      pset(s.x, s.y, 7)
    end

    if game_state == "play" then
      -- オまオはカ█オゆオむ
      spr(0, player.x, player.y)
      -- オよカ⬇️オめオま
      for b in all(bullets) do rectfill(b.x, b.y, b.x+1, b.y+4, 10) end
      -- オのカ█オぬオはオま オま オねオゆカ▒カ▒カ⬅️
      for e in all(enemies) do
        local sw = e.size
        spr(1, e.x, e.y, sw, sw, 1, 1)
      end
      print("score:"..score, 2, 2, 11)

    elseif game_state == "game_over" then
      -- オよオゆオめカ⬇️オよカ█オゆオほカ█オぬカ♥オやオぬカ◆ オよオぬオやオふオめカ😐
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
