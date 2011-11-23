' RoboTurkey
'
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000       '80 MHz

  ms = 80000
  
  delay = 300
  wings = 5
  wingsUp = 2000
  wingsDown = 1650

  head = 15
  headLeft = 1200
  headRight = 1700

  beak = 10
  beakClosed = 1150
  beakOpen = 800

VAR
  byte stack[256]

  
OBJ
  servo : "Servo32v5"  ' Servo controller
  wav   : "PlayWav"     ' Play wav sound effects  
  text  : "tv_text"
  
PUB Start | i, cog

  text.start(16)    'Start the VGA/TV text driver (uses another cog)

  text.str(string("Initializing Servos",13))  
  servo.start
  servo.SetRamp(wings, 1500, delay)
  servo.SetRamp(head, 1500, delay)
  servo.SetRamp(beak, 1500, delay)

  text.str(string("Initializing WAV player",13))
  wav.start

  wav.play(string("gobble2.wav"))
  wav.play(string("gobble3.wav"))
  wav.play(string("gravy.wav"))
  wav.play(string("oscar.wav"))
  wav.play(string("stuffed.wav"))
  wav.play(string("oscar.wav"))
  wav.play(string("rutabaga.wav"))



  repeat
    servo.set(head, headLeft)
    happy
    waitcnt(cnt+5000*ms)
    repeat 3
      flap(100)
    waitcnt(cnt+5000*ms)
    servo.set(head, headRight)
    gobble
    waitcnt(cnt+5000*ms)
    flap(250)
    waitcnt(cnt+5000*ms)

PUB happy
    text.str(string("Playing happy.wav",13))
    servo.set(wings, wingsUp)
    wav.playbg(string("happy.wav"))
    servo.set(beak, beakClosed)
    openclose(100)
    openclose(100)
    openclose(350)
    openclose(100)
    servo.set(wings, wingsDown)
    openclose(100)
    
PUB gobble
    text.str(string("Playing gobble.wav",13))
    wav.playbg(string("gobble.wav"))     
    servo.set(beak, beakClosed)
    openclose(120)
    openclose(80)
    openclose(120)
    openclose(100)
    servo.set(wings, wingsUp)
    openclose(750)
    servo.set(wings, wingsDown)

PUB openclose(time)
    servo.set(beak, beakOpen)
    waitcnt(cnt+time*ms)
    servo.set(beak, beakClosed)
    waitcnt(cnt+time*ms)

PUB flap(time)
    servo.set(wings, wingsUp)
    waitcnt(cnt+time*ms)
    servo.set(wings, wingsDown)
    waitcnt(cnt+time*ms)
     