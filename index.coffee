DEBUG = false
SPEED = 160
GRAVITY = 1100
FLAP = 320
SPAWN_RATE = 1 / 1200
OPENING = 120
SCALE = 1

# Flappy Pix - Sistema de Monetização
# Flappy Pix - Sistema de Monetização
valorPorCano = 10.00 # Legacy fallback
saldoAcumulado = 0
taxaPorSegundo = 1.00
multiplicador = 1.0
survivalTimer = 0
comboStacks = []
sessionEarnings = 0
floatingText = null
multiText = null
tentativasRestantes = 5
bannerVisivel = true

HEIGHT = 384
WIDTH = 288
GAME_HEIGHT = 336
GROUND_HEIGHT = 64
GROUND_Y = HEIGHT - GROUND_HEIGHT

parent = document.querySelector("#screen")
gameStarted = undefined
gameOver = undefined

deadTubeTops = []
deadTubeBottoms = []
deadInvs = []

bg = null
# credits = null
tubes = null
invs = null
bird = null
ground = null

score = null
scoreText = null
instText = null
gameOverText = null
pontosText = null
saldoText = null

flapSnd = null
scoreSnd = null
hurtSnd = null
fallSnd = null
swooshSnd = null

tubesTimer = null


floor = Math.floor

# Flappy Pix - Funções de Monetização
atualizarSaldo = ->
  if saldoText
    saldoText.setText "SALDO: R$ " + saldoAcumulado.toFixed(2)

lastMsg = ""

showHypeMessage = ->
  msgs = [
    "UAU!"
    "PARABÉNS!"
    "NOVO MILIONÁRIO!"
    "PIX CHEGANDO!"
    "RUMO AO MILHÃO!"
    "QUE JOGADA!"
    "TÁ CHOVENDO PIX!"
    "SÓ LUCRO!"
    "AULA DE FATURE!"
    "RECEBA!"
    "MAIS DINHEIRO!"
    "TOQUE DE MIDAS!"
    "SEGURA O PIX!"
    "FOGUETE NÃO TEM RÉ!"
    "DECOLOU!"
    "MESTRE DO PIX!"
    "PIX NO BOLSO!"
    "TÁ RICO!"
    "OLHA O GANHO!"
    "VAI QUE É TUA!"
  ]
  
  # Avoid repetition
  loop
    msg = msgs[Math.floor(Math.random() * msgs.length)]
    break if msg isnt lastMsg
  
  lastMsg = msg
  
  el = document.createElement("div")
  el.className = "hype-message"
  el.innerText = msg
  el.style.top = (20 + Math.random() * 40) + "%" 
  
  container = document.querySelector("#hype-container")
  container.appendChild(el)
  
  setTimeout ->
    container.removeChild(el)
  , 2000
  return

# Social Proof Logic
showNotification = (icon, text) ->
  el = document.createElement("div")
  el.className = "social-proof-card"
  el.innerHTML = "#{icon}<div class='social-content'>#{text}</div>"
  
  container = document.querySelector("#notification-container")
  container.appendChild(el)
  
  setTimeout ->
    if container.contains(el)
      container.removeChild(el)
  , 4500
  return

scheduleSocialProof = ->
  names = [
    "Carlos H.", "Ana P.", "Eduardo M.", "Fernanda S.", "João V.", "Beatriz L.",
    "Lucas R.", "Mariana C.", "Gabriel O.", "Juliana K.", "Rafael T.", "Larissa B.",
    "Pedro G.", "Camila D.", "Gustavo N.", "Letícia F.", "Daniel S.", "Amanda W.",
    "Felipe J.", "Carolina M.", "Bruno A.", "Vanessa R.", "Thiago L.", "Bianca P.",
    "Rodrigo H.", "Jessica T.", "Leonardo C.", "Melissa G.", "Vinicius D.", "Gabriela S."
  ]
  
  # Pastel colors for avatars
  colors = ["#FFB7B2", "#B5EAD7", "#E2F0CB", "#FFDAC1", "#C7CEEA", "#F0E68C", "#D8BFD8", "#FF6961"]

  runSequence = ->
    name = names[Math.floor(Math.random() * names.length)]
    initial = name.charAt(0)
    color = colors[Math.floor(Math.random() * colors.length)]
    
    avatarHtml = "<div class='social-avatar' style='background-color: #{color}; color: #333'>#{initial}</div>"
    
    # Varied phrases for Join PRO
    joinPhrases = [
      "entrou para o plano <span class='pro-badge'>PRO</span>"
      "agora faz parte do clube <span class='pro-badge'>PRO</span>"
      "acabou de assinar o <span class='pro-badge'>PRO</span>"
      "garantiu sua vaga no <span class='pro-badge'>PRO</span>"
      "começou a lucrar no <span class='pro-badge'>PRO</span>"
    ]
    joinText = joinPhrases[Math.floor(Math.random() * joinPhrases.length)]

    # Varied phrases for Withdraw
    withdrawPhrases = [
      "acabou de sacar"
      "recebeu um PIX de"
      "faturou agora"
      "retirou para a conta"
      "lucrou hoje"
    ]
    withdrawText = withdrawPhrases[Math.floor(Math.random() * withdrawPhrases.length)]

    # Step 1: Join PRO
    showNotification avatarHtml, "<strong>#{name}</strong> #{joinText}"
    
    # Step 2: Withdraw (after 2s)
    setTimeout ->
      amount = (Math.floor(Math.random() * 400) + 150) 
      showNotification avatarHtml, "<strong>#{name}</strong> #{withdrawText} <strong>R$ #{amount},00</strong>! UAU"
    , 2000
    
    # Schedule next sequence
    nextDelay = Math.random() * 8000 + 5000 # 5-13 seconds
    setTimeout runSequence, nextDelay
    return

  # Start the loop
  setTimeout runSequence, 3000
  return

generateLeaderboard = ->
  names = ["Roberto M.", "Fernanda K.", "André L.", "Patrícia S.", "Marcos P."]
  container = document.querySelector("#leaderboard-container")
  
  updateHeader = ->
    header = container.querySelector('.leaderboard-header')
    if container.classList.contains("expanded")
      header.innerText = "🏆 TOP 5 PIX DO DIA"
    else
      header.innerText = "🏆 TOP 5"
  
  # Auto collapse logic
  collapseTimeout = null
  startAutoCollapse = ->
    clearTimeout(collapseTimeout) if collapseTimeout
    collapseTimeout = setTimeout ->
      if container.classList.contains("expanded")
        container.classList.remove("expanded")
        updateHeader()
    , 5000 # 5 seconds
  
  # Add toggle functionality
  container.addEventListener "click", ->
    container.classList.toggle("expanded")
    updateHeader()
    if container.classList.contains("expanded")
      startAutoCollapse()
      
  # Global function to expand leaderboard
  window.expandLeaderboard = ->
    if !container.classList.contains("expanded")
      container.classList.add("expanded")
      updateHeader()
      startAutoCollapse()
  
  # Start collapsed (remove initial expanded class)
  
  html = """
    <div class='leaderboard-header'>🏆 TOP 5</div>
    <div class='leaderboard-content'>
  """
  
  for i in [0..4]
    name = names[i]
    val = 5000 - (i * 800) + Math.floor(Math.random() * 500)
    rankClass = "r-#{i+1}"
    
    html += """
      <div class='leaderboard-item'>
        <div class='rank #{rankClass}'>#{i+1}</div>
        <div class='player-name'>#{name}</div>
        <div class='player-value'>R$ #{val},00</div>
      </div>
    """
    
  html += "</div>"
    
  container.innerHTML = html
  
  return

generateLeaderboard()
# scheduleSocialProof()

atualizarPontos = ->
  if pontosText
    pontosText.setText "PONTOS: " + score

carregarSaldo = ->
  # Resetar saldo para uma nova seção (limpa ganhos anteriores)
  saldoAcumulado = 0
  salvarSaldo()

salvarSaldo = ->
  window.localStorage.setItem "saldoFlappyPix", saldoAcumulado

main = ->
  spawntube = (openPos, flipped) ->
    tube = null

    tubeKey = if flipped then "tubeTop" else "tubeBottom"
    if flipped
      tubeY = floor(openPos - OPENING / 2 - 320)
    else
      tubeY = floor(openPos + OPENING / 2)

    if deadTubeTops.length > 0 and tubeKey == "tubeTop"
      tube = deadTubeTops.pop().revive()
      tube.reset(game.world.width, tubeY)
    else if deadTubeBottoms.length > 0 and tubeKey == "tubeBottom"
      tube = deadTubeBottoms.pop().revive()
      tube.reset(game.world.width, tubeY)
    else
      tube = tubes.create(game.world.width, tubeY, tubeKey)
      tube.body.allowGravity = false

    # Move to the left
    tube.body.velocity.x = -SPEED
    tube

  spawntubes = ->
    # check dead tubes
    tubes.forEachAlive (tube) ->
      if tube.x + tube.width < game.world.bounds.left
        deadTubeTops.push tube.kill() if tube.key == "tubeTop"
        deadTubeBottoms.push tube.kill() if tube.key == "tubeBottom"
      return
    invs.forEachAlive (invs) ->
      deadInvs.push invs.kill() if invs.x + invs.width < game.world.bounds.left
      return

    tubeY = game.world.height / 2 + (Math.random()-0.5) * game.world.height * 0.2

    # Bottom tube
    bottube = spawntube(tubeY)

    # Top tube (flipped)
    toptube = spawntube(tubeY, true)

    # Add invisible thingy
    if deadInvs.length > 0
      inv = deadInvs.pop().revive().reset(toptube.x + toptube.width / 2, 0)
    else
      inv = invs.create(toptube.x + toptube.width / 2, 0)
      inv.width = 2
      inv.height = game.world.height
      inv.body.allowGravity = false
    inv.body.velocity.x = -SPEED
    return

  addScore = (_, inv) ->
    invs.remove inv
    score += 1
    scoreText.setText score
    scoreSnd.play()
    
    # Combo Trigger
    comboStacks.push game.time.now
    
    # Show Combo Text
    survivalBonus = Math.floor(survivalTimer / 5) * 1.0
    currentMulti = 1.0 + survivalBonus + (comboStacks.length) * 0.5
    if currentMulti > 4.0 then currentMulti = 4.0
    comboVal = currentMulti.toFixed(1)
    
    comboFly = game.add.text(bird.x, bird.y - 20, "COMBO #{comboVal}x!",
      font: "10px 'Press Start 2P'"
      fill: "#FFD700"
      stroke: "#000"
      strokeThickness: 3
    )
    game.add.tween(comboFly).to({ y: bird.y - 60, alpha: 0 }, 800, Phaser.Easing.Linear.None, true).onComplete.add -> comboFly.destroy()
    
    showHypeMessage()
    return

  setGameOver = ->
    gameOver = true
    # Save balance only on game over
    salvarSaldo()
    bird.body.velocity.y = 100 if bird.body.velocity.y > 0
    bird.animations.stop()
    bird.frame = 1
    
    tentativasRestantes -= 1
    if tentativasRestantes < 0 then tentativasRestantes = 0
    
    msgTentativa = if tentativasRestantes > 0 then "TOQUE\nPARA TENTAR NOVAMENTE\n(" + tentativasRestantes + " restam)" else "LIMITE ATINGIDO!\nVOLTE MAIS TARDE"
    instText.setText msgTentativa
    instText.renderable = true
    hiscore = window.localStorage.getItem("hiscore")
    hiscore = (if hiscore then hiscore else score)
    hiscore = (if score > parseInt(hiscore, 10) then score else hiscore)
    window.localStorage.setItem "hiscore", hiscore
    gameOverText.setText "GAME OVER\n\nRECORDE\n\n" + hiscore
    gameOverText.renderable = true

    # Stop all tubes
    tubes.forEachAlive (tube) ->
      tube.body.velocity.x = 0
      return

    invs.forEach (inv) ->
      inv.body.velocity.x = 0
      return


    # Stop spawning tubes
    game.time.events.remove(tubesTimer)

    # Make bird reset the game
    game.time.events.add 1000, ->
      game.input.onTap.addOnce ->
        if tentativasRestantes > 0
          reset()
          swooshSnd.play()
        else
          # Show Withdrawal Modal
          modal = document.getElementById('withdrawal-modal')
          if modal
            # Update dynamic balance
            amountEl = document.getElementById('withdraw-amount')
            if amountEl
              amountEl.value = "R$ " + saldoAcumulado.toFixed(2).replace('.', ',')
              
            modal.style.display = 'flex'
            console.log '💰 Modal de Saque (Mock) Exibido!'
          game.input.onTap.removeAll()

    hurtSnd.play()
    return

  flap = ->
    start()  unless gameStarted
    unless gameOver
      # bird.body.velocity.y = -FLAP
      bird.body.gravity.y = 0;
      bird.body.velocity.y = -100;
      tween = game.add.tween(bird.body.velocity).to(y:-FLAP, 25, Phaser.Easing.Bounce.In,true);
      tween.onComplete.add ->
        bird.body.gravity.y = GRAVITY
      flapSnd.play()
    return

  preload = ->
    assets =
      spritesheet:
        bird: [
          "assets/bird.png"
          36
          26
        ]

      image:
        tubeTop: ["assets/tube1.png"]
        tubeBottom: ["assets/tube2.png"]
        ground: ["assets/ground.png"]
        bg: ["assets/bg.png"]

      audio:
        flap: ["assets/sfx_wing.mp3"]
        score: ["assets/sfx_point.mp3"]
        hurt: ["assets/sfx_hit.mp3"]
        fall: ["assets/sfx_die.mp3"]
        swoosh: ["assets/sfx_swooshing.mp3"]

    Object.keys(assets).forEach (type) ->
      Object.keys(assets[type]).forEach (id) ->
        game.load[type].apply game.load, [id].concat(assets[type][id])
        return

      return

    return

  create = ->
    console.log("%cFLAPPY PIX", "color: #00E676; font-size: x-large");
    ratio = window.innerWidth / window.innerHeight
    document.querySelector('#loading').style.display = 'none'

    # Gerenciar Banner
    window.gameInstance = 
      clickBanner: ->
        bannerVisivel = false
        document.getElementById('banner-overlay').style.display = 'none'
        console.log '🎮 Jogo: Banner marcado como invisível'
        return

    # Verificar se foi clicado antes de carregar
    if window.bannerClicadoAntes
      bannerVisivel = false
      document.querySelector('#banner-overlay').style.display = 'none'

    # Set world dimensions
    Phaser.Canvas.setSmoothingEnabled(game.context, false)
    game.stage.scaleMode = Phaser.StageScaleMode.SHOW_ALL
    game.stage.scale.setScreenSize(true)
    game.world.width = WIDTH
    game.world.height = HEIGHT

    # Draw bg
    bg = game.add.tileSprite(0, 0, WIDTH, HEIGHT, 'bg')

    # Credits 'yo
    # credits = game.add.text(game.world.width / 2, HEIGHT - GROUND_Y + 50, "",
    #   font: "8px \"Press Start 2P\""
    #   fill: "#fff"
    #   stroke: "#430"
    #   strokeThickness: 4
    #   align: "center"
    # )
    # credits.anchor.x = 0.5


    # # Add clouds group
    # clouds = game.add.group()

    # Add tubes
    tubes = game.add.group()

    # Add invisible thingies
    invs = game.add.group()

    # Add bird
    bird = game.add.sprite(0, 0, "bird")
    bird.anchor.setTo 0.5, 0.5
    bird.animations.add "fly", [
      0
      1
      2
    ], 10, true
    bird.body.collideWorldBounds = true
    bird.body.setPolygon(
      24,1,
      34,16,
      30,32,
      20,24,
      12,34,
      2,12,
      14,2
    )

    # Add ground
    ground = game.add.tileSprite(0, GROUND_Y, WIDTH, GROUND_HEIGHT, "ground")
    ground.tileScale.setTo SCALE, SCALE

    # Add score text
    scoreText = game.add.text(game.world.width / 2, game.world.height / 4, "",
      font: "16px \"Press Start 2P\""
      fill: "#fff"
      stroke: "#430"
      strokeThickness: 4
      align: "center"
    )
    scoreText.anchor.setTo 0.5, 0.5

    # Add pontos text (mobile-first, dentro do jogo)
    pontosText = game.add.text(10, 10, "PONTOS: 0",
      font: "8px \"Press Start 2P\""
      fill: "#FFD700"
      stroke: "#000"
      strokeThickness: 2
      align: "left"
    )
    pontosText.fixedToCamera = true

    # Add saldo text (mobile-first, dentro do jogo)
    saldoText = game.add.text(10, 25, "SALDO: R$ 0,00",
      font: "8px \"Press Start 2P\""
      fill: "#00FF00"
      stroke: "#000"
      strokeThickness: 2
      align: "left"
    )
    saldoText.fixedToCamera = true

    # Multiplier Text HUD
    multiText = game.add.text(10, 40, "MULT: 1.0x (R$1.00/s)",
      font: "8px \"Press Start 2P\""
      fill: "#FFFFFF"
      stroke: "#000"
      strokeThickness: 2
    )
    multiText.fixedToCamera = true
    
    # Atualizar saldo inicial
    atualizarSaldo()
    
    # Floating Text for Session Earnings
    floatingText = game.add.text(0, 0, "+R$ 0,00",
      font: "10px \"Press Start 2P\""
      fill: "#00FF00"
      stroke: "#000"
      strokeThickness: 3
      align: "center"
    )
    floatingText.anchor.setTo 0.5, 0.5
    floatingText.alpha = 0

    # Add instructions text
    instText = game.add.text(game.world.width / 2, game.world.height - game.world.height / 4, "",
      font: "8px \"Press Start 2P\""
      fill: "#fff"
      stroke: "#430"
      strokeThickness: 4
      align: "center"
    )
    instText.anchor.setTo 0.5, 0.5

    # Add game over text
    gameOverText = game.add.text(game.world.width / 2, game.world.height / 2, "",
      font: "16px \"Press Start 2P\""
      fill: "#fff"
      stroke: "#430"
      strokeThickness: 4
      align: "center"
    )
    gameOverText.anchor.setTo 0.5, 0.5
    gameOverText.scale.setTo SCALE, SCALE

    # Add sounds
    flapSnd = game.add.audio("flap")
    scoreSnd = game.add.audio("score")
    hurtSnd = game.add.audio("hurt")
    fallSnd = game.add.audio("fall")
    swooshSnd = game.add.audio("swoosh")

    # Add controls
    game.input.onDown.add ->
      if !bannerVisivel
        flap()
      return

    # RESET!
    reset()
    return

  reset = ->
    gameStarted = false
    gameOver = false
    score = 0
    # credits.renderable = true
    # credits.setText "see console log\nfor github url"
    scoreText.setText "FLAPPY PIX"
    instText.setText "TOQUE\nPARA VOAR"
    gameOverText.renderable = false
    bird.body.allowGravity = false
    bird.reset game.world.width * 0.3, game.world.height / 2
    bird.angle = 0
    bird.animations.play "fly"
    tubes.removeAll()
    invs.removeAll()
    
    # Reset Multiplier
    multiplicador = 1.0
    survivalTimer = 0
    comboStacks = []
    sessionEarnings = 0
    if multiText then multiText.setText "MULT: 1.0x (R$1.00/s)"
    if saldoText then saldoText.fill = "#00FF00"
    
    # Atualizar textos de pontos e saldo
    atualizarPontos()
    atualizarSaldo()
    return

  start = ->

    # credits.renderable = false
    bird.body.allowGravity = true
    bird.body.gravity.y = GRAVITY

    # SPAWN tubeS!
    tubesTimer = game.time.events.loop 1 / SPAWN_RATE, spawntubes


    # Show score
    scoreText.setText score
    instText.renderable = false

    # START!
    gameStarted = true
    
    # Expand Leaderboard when game starts
    if typeof window.expandLeaderboard is 'function'
      window.expandLeaderboard()
    return

  update = ->
    if gameStarted
      if !gameOver
        # Make bird dive
        bird.angle = (90 * (FLAP + bird.body.velocity.y) / FLAP) - 180
        bird.angle = -30  if bird.angle < -30
        if bird.angle > 80
          bird.angle = 90
          bird.animations.stop()
          bird.frame = 1
        else
          bird.animations.play()

        # Check game over
        game.physics.overlap bird, tubes, ->
          setGameOver()
          fallSnd.play()
        setGameOver() if not gameOver and bird.body.bottom >= GROUND_Y

        # Add score
        game.physics.overlap bird, invs, addScore
        
        # --- PROGRESSIVE MULTIPLIER LOGIC ---
        dt = game.time.physicsElapsed
        survivalTimer += dt
        
        # Clean up expired combos (5 seconds)
        now = game.time.now
        comboStacks = comboStacks.filter (time) -> now - time < 5000
        
        # Calculate Current Multiplier (CAP 4.0x)
        survivalBonus = Math.floor(survivalTimer / 5) * 1.0
        comboBonus = comboStacks.length * 0.5
        multiplicador = 1.0 + survivalBonus + comboBonus
        if multiplicador > 4.0 then multiplicador = 4.0
        
        # Update Multiplier HUD with Earnings/sec info
        if multiText
           earningPerSec = (taxaPorSegundo * multiplicador).toFixed(2)
           multiText.setText "MULT: " + multiplicador.toFixed(1) + "x (R$#{earningPerSec}/s)"
           if multiplicador > 1.0
            multiText.fill = "#FFD700"
            # Pulse effect
            s = 1 + Math.sin(now / 150) * 0.1
            multiText.scale.setTo s, s
          else
            multiText.fill = "#FFFFFF"
            multiText.scale.setTo 1, 1

        # Calculate Final Earnings
        gain = (taxaPorSegundo * multiplicador) * dt
        saldoAcumulado += gain
        sessionEarnings += gain
        
        # Visual Frenzy State (2x+)
        if multiplicador >= 2.0
          if saldoText
            saldoText.fill = "#FFD700" # GOLD
            # Pulse saldo text
            s2 = 1 + Math.sin(now / 100) * 0.1
            saldoText.scale.setTo s2, s2
        else
          if saldoText
            saldoText.fill = "#00FF00"
            saldoText.scale.setTo 1, 1

        # Update Balance Text
        if saldoText
          saldoText.setText "SALDO: R$ " + saldoAcumulado.toFixed(2)
              
        # Update Floating Text
        if floatingText
          floatingText.x = bird.x
          floatingText.y = bird.y + 40
          floatingText.setText "+R$ " + sessionEarnings.toFixed(2)
          floatingText.alpha = 1
          # Pulse effect on floating text
          scaleVal = 1 + Math.sin(game.time.now / 100) * 0.1
          floatingText.scale.setTo scaleVal, scaleVal

      else
        # rotate the bird to make sure its head hit ground
        tween = game.add.tween(bird).to(angle: 90, 100, Phaser.Easing.Bounce.Out, true);
        if bird.body.bottom >= GROUND_Y + 3
          bird.y = GROUND_Y - 13
          bird.body.velocity.y = 0
          bird.body.allowGravity = false
          bird.body.gravity.y = 0

    else
      bird.y = (game.world.height / 2) + 8 * Math.cos(game.time.now / 200)
      bird.angle = 0


    # Scroll ground
    ground.tilePosition.x -= game.time.physicsElapsed * SPEED unless gameOver
    return

  render = ->
    if DEBUG
      game.debug.renderSpriteBody bird
      tubes.forEachAlive (tube) ->
        game.debug.renderSpriteBody tube
        return

      invs.forEach (inv) ->
        game.debug.renderSpriteBody inv
        return

    return

  state =
    preload: preload
    create: create
    update: update
    render: render

  game = new Phaser.Game(WIDTH, HEIGHT, Phaser.CANVAS, parent, state, false, false)
  return

WebFontConfig =
  google:
    families: [ 'Press+Start+2P::latin' ]
  active: main
(->
  wf = document.createElement('script')
  wf.src = (if 'https:' == document.location.protocol then 'https' else 'http') +
    '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js'
  wf.type = 'text/javascript'
  wf.async = 'true'
  s = document.getElementsByTagName('script')[0]
  s.parentNode.insertBefore(wf, s)
)()