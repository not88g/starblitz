pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- space-カ☉カ⬇️カ🐱オふカ█ "starblitz" オひオめカ◆ pico-8
-- オぬオのカ🐱オゆカ█: カ🐱カ⬅️, オやオぬカ♥オまオやオぬカ🅾️カ웃オまオみ オむオゆオひオふカ█

-- オかオˇオきオˇオうオˇオえオえオつオˇ オ▤ オ❎オ…オかオこオくオあオおオ★オつオˇ オえオ…オくオけオきオおオ▥オあオ▤
player = {x=64, y=120, w=8, h=8}
bullets = {}
enemies = {}
score = 0
shoot_cooldown = 0

-- game states: logo ヌ●★ play ヌ●★ game_over
game_state = "logo"
logo_timer = 0
logo_duration = 120  -- 120 オむオぬオひカ█オゆオの = 2 カ▒オふオむカ⬇️オやオひカ⬅️ オよカ█オま 60 fps

function reset_game()
  -- カ▒オねカ█オゆカ▒ オまオはカ█オゆオのカ⬅️カ✽ オよオふカ█オふオもオふオやオやカ⬅️カ✽
  player.x = 64
  player.y = 120
  bullets = {}
  enemies = {}
  score = 0
  shoot_cooldown = 0
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

    -- オゆオねオやオゆオのオめカ◆オふオも オのカ█オぬオはオゆオの, オよカ█オゆオのオふカ█カ◆オふオも オむオゆオめオめオまオほオまオま
    for e in all(enemies) do
      e.y += 1
      if e.y > 128 then del(enemies, e) end

      -- オよカ⬇️オめカ◆-オのカ█オぬオは
      for b in all(bullets) do
        if abs(e.x - b.x) < 4 and abs(e.y - b.y) < 4 then
          del(enemies, e)
          del(bullets, b)
          score += 1
          break
        end
      end

      -- オのカ█オぬオは-オまオはカ█オゆオむ
      if abs(e.x - player.x) < 4 and abs(e.y - player.y) < 4 then
        game_state = "game_over"
      end
    end

  elseif game_state == "game_over" then
    -- オへオひオふオも オやオぬオへオぬカ🐱オまカ◆ z, カ♥カ🐱オゆオねカ⬅️ オよオふカ█オふオほオぬオよカ⬇️カ▒カ🐱オまカ🐱カ😐
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
    local title = "starblitz"
    local tx = (128 - (#title * 4)) / 2
    local ty = 56
    print(title, tx, ty, 7)
    print("press z to start", (128-80)/2, ty+16, 6)

  elseif game_state == "play" then
    cls()
    -- カ█オまカ▒カ⬇️オふオも オまオはカ█オゆオむオぬ
    rectfill(player.x, player.y, player.x+player.w, player.y+player.h, 7)
    -- カ█オまカ▒カ⬇️オふオも オよカ⬇️オめオま
    for b in all(bullets) do
      rectfill(b.x, b.y, b.x+1, b.y+4, 10)
    end
    -- カ█オまカ▒カ⬇️オふオも オのカ█オぬオはオゆオの
    for e in all(enemies) do
      rectfill(e.x, e.y, e.x+6, e.y+6, 8)
    end
    -- カ█オまカ▒カ⬇️オふオも カ▒カ♥カ➡️カ🐱
    print("score:"..score, 2, 2, 11)

  elseif game_state == "game_over" then
    cls(0)
    local msg = "game over"
    local mx = (128 - (#msg * 4)) / 2
    local my = 56
    print(msg, mx, my, 8)
    print("press z to retry", (128-96)/2, my+16, 6)
  end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
