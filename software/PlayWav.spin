'  SPIN WAV Player Ver. 1a  (Plays only mono WAV at 16ksps)
'  Copyright 2007 Raymond Allen
'  Settings for Demo Board Audio Output:  Right Pin# = 10, Left Pin# = 11   , VGA base=Pin16, TV base=Pin12


CON buffSize = 256
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000       '80 MHz

VAR long parameter
    long buff1[buffSize]
    long buff2[buffSize]
    long stack1[100]
    long stack2[50]
    word MonoData[buffSize]
    long Pin
    
OBJ
    'text : "vga_text"    'For NTSC TV Video: Comment out this line...
    'text : "tv_text"    'and un-comment this line  (need to change pin parameter for text.start(pin) command below too).
    sd  : "FSRW"
    num : "Numbers"

PUB Main

  start(20)
  repeat
    playbg(string("gobble.wav"))
    waitcnt(cnt+5000*(clkfreq/1000))
    playbg(string("happy.wav"))
    waitcnt(cnt+5000*(clkfreq/1000))
    
PUB start(myPin) | i

  Pin := myPin
  
  'Start up the status display...
  'text.start(16)    'Start the VGA/TV text driver (uses another cog)
                    'The parameter (16) is the base pin used by demo and proto boards for VGA output
                    'Change (16) to (12) when using "tv_text" driver with demo board as it uses pin#12 for video                    
  'text.str(STRING("Starting Up",13))

  'open the WAV file  (NOTE:  Only plays mono, 16000 ksps PCM WAV Files !!!!!!!!!!!!!)
  'access SD card 
  i:=sd.mount(0)
  'if (i==0)
  '  text.str(STRING("SD Card Mounted",13))
  'else
  '  text.str(STRING("SD Card Mount Failed",13))
  '  repeat

PUB playbg(filename) | cog
  'Play a WAV File in the background
  cog := COGNEW(play(filename), @stack2)
  'if (cog == -1)
  '  text.str(string("Ran out of cogs in playbg"))
  return cog

PUB play(filename)|n,i,j,cog  
  'open file
  i:=sd.popen(filename, "r")
  'text.str(STRING("Opening: "))
  'text.str(num.toStr(i,num#dec))
  'text.out(13)

  'ignore the file header (so you better have the format right!)
  'See here for header format:  http://ccrma.stanford.edu/CCRMA/Courses/422/projects/WaveFormat/
  i:=sd.pread(@MonoData, 44) 'read data words to input stereo buffer
  'text.str(STRING("Header Read ",13))


  'Start the player in a new cog
  cog := COGNEW(Player,@stack1)      'Play runs in a seperate COG (because SPIN is a bit slow!!)
  'text.str(STRING("Playing...",13))
  
  'Keep filling buffers until end of file
  ' note:  using alternating buffers to keep data always at the ready...
  n:=buffSize-1
  j:=buffsize*2
  repeat while (j==buffsize*2)  'repeat until end of file
    if (buff1[n]==0)
      j:=sd.pread(@MonoData, buffSize*2) 'read data words to input stereo buffer   
      'fill table 1
      repeat i from 0 to n
         buff1[i]:=($8000+MonoData[i])<<16
    if (buff2[n]==0)
      j:=sd.pread(@MonoData, buffSize*2) 'read data words to input stereo buffer  
      'fill table 1
      repeat i from 0 to n
         buff2[i]:=($8000+MonoData[i])<<16
   
   
  'must have reached the end of the file, so close it
  'text.str(STRING("Closing: "))
  i := sd.pclose
  'text.str(num.toStr(i,num#dec))
  'text.out(13)
  'shut down here
  COGSTOP(cog)
   
PUB Player| i,nextCnt,j
  'Play the wav data using counter modules
  'play on one pin only

  'Set pins to output mode
  DIRA[Pin]~~                              'Set Left Pin to output

  'Set up the counters
  CTRB:= %00110 << 26 + 0<<9 + Pin         'NCO/PWM Single-Ended APIN=Pin (BPIN=0 always 0)   

  'Get ready for fast loop  
  i:=0
  j:=true
  NextCnt:=cnt+1005000

    'Play loop
    'This loop updates the counter with the new desired output level
    'Alternates between buff1 and buff2 so main program can keep buffers full
    repeat 
      repeat i from 0 to buffSize-1
        NextCnt+=5000   ' need this to be 5000 for 16KSPS   @ 80 MHz
        waitcnt(NextCnt)
        if (j)
          FRQB:=buff1[i]~
        else
          FRQB:=buff2[i]~
      NOT j