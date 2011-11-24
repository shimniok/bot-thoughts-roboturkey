{
 RoboTurkey

 Inspired by RobotGrrl's RoboBird (http://robotgrrl.com/), I decided it would be fun to build an animatronic turkey
 for Thanksgiving and decorate the bird with my 2 year old daughter. The bird is made with a Parallax Propeller (well,
 obviously), 3 hobby servos, an LM386 audio amplifier, a feather boa, lots of craft sticks and hot glue, and other
 sundries

 Dependencies: Servo32v5, PlayWav, tv_text

 Repository for schematics, construction plans, etc.: http://code.google.com/p/bot-thoughts-roboturkey/

 Author: Michael Shimniok  www.bot-thoughts.com

}

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000       '80 MHz

  ms = 80000
  
  delay = 300

  wait = 2000
  
  wings = 5
  wingsUp = 2000
  wingsDown = 1650

  head = 15
  headLeft = 1200
  headMiddle = 1450
  headRight = 1700

  beak = 10
  beakClosed = 1150
  beakOpen = 800

  DEC      =  %000_000_000_0_0_000000_01010     'Decimal, variable widths

VAR
  byte stack[256]

  
OBJ
  servo : "Servo32v5"   ' Servo controller
  wav   : "PlayWav"     ' Play wav sound effects  
  'text  : "tv_text"
  rand  : "RealRandom"
  pc : "Simple_Serial"
  num : "Numbers"
  
PUB Start | x, p, hpos

  pc.init(27,26,9600)

  pc.str(string("Serial initialized",13))
  
  rand.start
  'text.start(16)    'Start the VGA/TV text driver (uses another cog)

  pc.str(string("Random initialized",13))

  'text.str(string("Initializing Servos",13))  
  servo.start
  servo.SetRamp(wings, 1500, delay)
  servo.SetRamp(head, 1500, delay)
  servo.SetRamp(beak, 1500, delay)

  pc.str(string("Servos initialized",13))

  'text.str(string("Initializing WAV player",13))
  wav.start(20)

  pc.str(string("Playback initialized",13))

  waitcnt(cnt+5000*ms)
{
  repeat
    rutabaga
    waitcnt(cnt+wait*ms)  
    happy
    waitcnt(cnt+wait*ms)
    gobble  
    waitcnt(cnt+wait*ms)
    stuffed  
    waitcnt(cnt+wait*ms)
    gobble2  
    waitcnt(cnt+wait*ms)
    gravy  
    waitcnt(cnt+wait*ms)
    gobble3  
    waitcnt(cnt+wait*ms)
    oscar  
    waitcnt(cnt+wait*ms)
}
  hpos := headMiddle

  pc.str(string("RoboTurkey online",13))

  happy
  
  repeat
    p := random
    pc.str(string("r="))
    pc.str(num.toStr(p, DEC))
    pc.tx(13)
    
    if (p < 300)                 ' flap

      if (p < 100)
        x := 2
      elseif (p < 200)
          x := 1
      elseif (p < 300)
          x := 3

      repeat x
        flap(150)

    elseif (p < 800)                 ' look around

      case hpos
        headLeft :
          hpos := headMiddle
        headMiddle :
          if (p < 550)
            hpos := headRight
          else
            hpos := headLeft
        headRight :
          hpos := headMiddle

      servo.set(head, hpos)
      
    elseif (p < 1001)

      if (p < 825)            ' rutabaga
        rutabaga
      elseif (p < 850)        ' oscar
        oscar
      elseif (p < 875)        ' gravy
        gravy  
      elseif (p < 900)        ' gobble
        gobble
      elseif (p < 925)        ' gobble2
        gobble2
      elseif (p < 950)        ' gobble3
        gobble3
      elseif (p < 975)        ' stuffed
        stuffed
      elseif (p < 1001)       ' happy
        happy

    p := random * 10
    waitcnt(cnt+(wait+p)*ms) 
    
  

PUB happy
    'text.str(string("Playing happy.wav",13))
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
    'text.str(string("Playing gobble.wav",13))
    wav.playbg(string("gobble.wav"))     
    servo.set(beak, beakClosed)
    openclose(120)
    openclose(80)
    openclose(120)
    openclose(100)
    servo.set(wings, wingsUp)
    openclose(750)
    servo.set(wings, wingsDown)

PUB gobble2
    'text.str(string("Playing gobble2.wav",13))
    wav.playbg(string("gobble2.wav"))
    servo.set(wings, wingsUp)
    openclose(100)
    openclose(200)
    servo.set(wings, wingsDown)
    openclose(250)
    openclose(100)

PUB gobble3
    'text.str(string("Playing gobble3.wav",13))
    wav.playbg(string("gobble3.wav"))
    servo.set(wings, wingsUp)
    openclose(100)
    servo.set(wings, wingsDown)
    openclose(100)
    openclose(130)
    servo.set(wings, wingsUp)
    openclose(130)
    openclose(120)
    openclose(120)
    servo.set(wings, wingsDown)

PUB gravy
    'text.str(string("Playing gravy.wav",13))
    wav.playbg(string("gravy.wav"))
    openclose(150)
    openclose(50)
    openclose(100)
    servo.set(wings, wingsUp)
    openclose(300)
    openclose(200)
    servo.set(wings, wingsDown)

PUB oscar
    'text.str(string("Playing oscar.wav",13))
    wav.playbg(string("oscar.wav"))
    openclose(300)
    servo.set(wings, wingsUp)
    openclose(250)
    servo.set(wings, wingsDown)
    openclose(100)
    servo.set(wings, wingsUp)
    openclose(260)
    servo.set(wings, wingsDown)
    openclose(120)

PUB stuffed
    'text.str(string("Playing stuffed.wav",13))
    wav.playbg(string("stuffed.wav"))
    servo.set(wings, wingsUp)
    openclose(250)
    servo.set(wings, wingsDown)
    openclose(170)
    openclose(50)

PUB rutabaga
    'text.str(string("Playing rutabaga.wav",13))
    wav.playbg(string("rutabaga.wav"))
    servo.set(wings, wingsUp)
    openclose(200)
    openclose(100)
    openclose(200)
    openclose(150)
    servo.set(wings, wingsDown)
    openclose(100)
    openclose(100)

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

PUB random
    result := ((rand.random & $7F) * 1000) / $7F
