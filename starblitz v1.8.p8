pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- space-カ☉カ⬇️カ🐱オふカ█ "starblitz" オひオめカ◆ pico-8
-- オぬオのカ🐱オゆカ█: 88g

-- オかオˇオきオˇオうオˇオえオえオつオˇ オ▤ オ❎オ…オかオこオくオあオおオ★オつオˇ オえオ…オくオけオきオおオ▥オあオ▤
player = {x=64, y=120, w=8, h=8}
bullets = {}
enemies = {}
stars = {}
star_count = 30
score = 0
shoot_cooldown = 0

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
  -- オまオやオまカ●オまオぬオめオまオほオまカ█カ⬇️オふオも オほオのカ➡️オほオひカ⬅️
  stars = {}
  for i=1,star_count do
    add(stars, {
      x = rnd(128),
      y = rnd(128),
      speed = rnd(1) + 0.5
    })
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
    player.x = mid(0, player.x, 120)

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
      add(enemies, {x=rnd(120), y=-8})
    end

    -- オゆオねオやオゆオのオめカ◆オふオも オのカ█オぬオはオゆオの オま オよカ█オゆオのオふカ█カ◆オふオも オむオゆオめオめオまオほオまオま
    for e in all(enemies) do
      e.y += 1
      if e.y > 120 then
        game_state = "game_over"
      end
      if e.y > 128 then
        del(enemies, e)
      end
      for b in all(bullets) do
        if abs(e.x - b.x) < 4 and abs(e.y - b.y) < 4 then
          del(enemies, e)
          del(bullets, b)
          score += 1
          break
        end
      end
      if abs(e.x - player.x) < 4 and abs(e.y - player.y) < 4 then
        game_state = "game_over"
      end
    end

    -- オゆオねオやオゆオのオめカ◆オふオも オほオのカ➡️オほオひカ⬅️
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
    -- カ⬇️オのオふオめオまカ♥オふオやオやオゆオふ オめオゆオはオゆ
    local title = "starblitz"
    local tx = flr((128 - (#title * 8)) / 2)
    local ty = 48
    for i=1,#title do
      print(sub(title,i,i), tx + (i-1)*8, ty, 7)
    end
    -- オのオふカ█カ▒オまカ◆ オま オぬオのカ🐱オゆカ█
    local info = "v1.8 - made by 88g"
    local ix = flr((128 - (#info * 4)) / 2)
    print(info, ix, ty + 16, 6)

  else
    -- カ░オゆオや オま オほオのオふオほオひカ⬅️ (play オま game_over)
    cls(1)
    for s in all(stars) do
      pset(s.x, s.y, 7)
    end

    if game_state == "play" then
      -- オまオはカ█オゆオむ
      spr(0, player.x, player.y)
      -- オよカ⬇️オめオま
      for b in all(bullets) do
        rectfill(b.x, b.y, b.x+1, b.y+4, 10)
      end
      -- オのカ█オぬオはオま (オよオふカ█オふオのカ➡️カ█オやカ⬇️カ🐱カ⬅️オふ)
      for e in all(enemies) do
        spr(1, e.x, e.y, 1, 1, 1, 1)
      end
      -- カ▒カ♥カ➡️カ🐱
      print("score:"..score, 2, 2, 11)

    elseif game_state == "game_over" then
      -- オよオゆオめカ⬇️オよカ█オゆオほカ█オぬカ♥オやオぬカ◆ オよオぬオやオふオめカ😐
      rectfill(0, 40, 127, 87, 0)
      local msg = "game over"
      local mx = flr((128 - (#msg * 4)) / 2)
      local my = 56
      print(msg, mx, my, 8)
      print("press z to retry", flr((128 - 96) / 2), my+16, 6)
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
