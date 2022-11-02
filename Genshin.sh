#GENSHIN STORY SKIPPING AND AUTOWALKING SCRIPT!

  #DEPENDENCIES: xdotool, wmctrl, xinput

#INSTRUCTIONS

#move this script, KillGOR.sh RestoreGOR.sh, to the location "~/.scripts" on your linux system if it doesn't exist create it

#STEAM LAUNCH OPTIONS https://help.steampowered.com/en/faqs/view/7D01-D2DD-D75E-2955
  #RUN WITHOUT TERMINAL AND AUTO START ON GAME START
    #[gamemoderun %command% & ~/.scripts/Genshin.sh] (no brackets)
      #OR [gamemoderun %command% & ~/.scripts/Genshin.sh > ~/.scripts/output.txt] and use [tail -f ~/.scripts/output.txt] in a seperate terminal to Debug issues (also no brackets)

#GameOverlay attempts to hook to script on game start using LAUNCH OPTIONS.
#The link to this script is on this scripts GitHub Page - it just changes the name of GameOverlayRender.so to GOR64.so and GOR32.so and restores it at the end of this script
#if you have a fix for this please let me know! create an issue in the Github Page thank you!

GOR=true #SET TO FALSE IF RUNNING THE SCRIPT THROUGH STEAM LAUNCH OPTIONS 

if [ $GOR = false ]; then
  . ~/.scripts/KillGOR.sh
fi

#=============OPTIONS=============#
  #Set the time before the script starts to keep the script running while the game Starts up
timer=18

  #when true This Prevents the Program from exiting and does not clear the scripts output as it runs
log=false

  #Sets this to match the window decoration Title of the game window
win="Genshin Impact"

  #PREVENT AFK COMBAT mashes F1 in tandom with autoclicker to effectively pause the game the moment the cutseens and textboxes exit
prevComb=true

#====***IMPORTATNT*** PLEASE SET THESE VARIABLES BELOW TO ALLOW THE SCRIPT TO WORK FOR YOU===#

  #determine a location that the mouse will move to when activating the Autoclicker (Default for 1080p = x1342 y720)
xy="1342 720" #GET MOUSE LOCATION WITH [sleep 7;xdotool getmouselocation] run the command & position mouse over the the in game reply buttons

  #exclude your browser in window search (so if you have a browser open looking up genshin content it wont register as the game window)
browser="Firefox"

#=========*****INPUT DEVICE SETTINGS*****=============#

  #My Default = Logitech G500s Laser Gaming Mouse Keyboard	id=18 Key112 = PGup
  #use [xinput list] (no brackets) to determine which device you are using Auto Cancel (Keyboard, Mouse, Controller etc.)to get the DEVICE ID
devid=8 #For Both auto click and autowalk

  #to determine the keyboard/mouse button/key ID
  #use [sleep 5; xinput query-state "DEVICE ID"] (no brackets or quotations) Hold down the desired key before the 5 second duration is up and scroll through the output
  #to see which key/button ID You were holding the output line you are looking for will look like this key[112]=down or button[1]=down
buttorkey=key #if the output of [sleep 5; xinput query-state "DEVICE ID"] was a key or button set accordingly

  #Key/button ID number from the output of [sleep 5; xinput query-state "DEVICE ID"]
key=62 #AUTO CLICK BUTTON

key2=108 #AUTO WALK BUTTON

keyw=25 #W KEY TO TOGGLE OFF THE AUTOWALK

esc=9 #Escape key to toggle off all

  #use the same method to determine the settings for mouse
mouseID=13 #device ID

mbuttorkey=button #button or key

mkey=1 #button or key ID

  #Case Sensitivity
down=down #Set to "Down" if [sleep 5; xinput query-state "DEVICE ID"] output was "key[112]=Down"

up=up #Set to "Up" if [sleep 5; xinput query-state "DEVICE ID"] output was "key[112]=Up" check the surrounding keys to determine which to use

#===============OPTIONS-END===============#(EDITING ANYTHING BELOW THIS POINT MIGHT BREAK THE SCRIPT)
printf "\nAUTO CLICKER:RALT AND WALKING:RSHIFT SCRIPT\n\nWAITING $timer SECONDS FOR $win TO START...\n\n"

sleep $timer

winid="$(xdotool search --name '$win')";

echo "AWAITING INPUT..."

tog=false

togw=false

nofocus=false
#Determines window Focus toggles off if window loss focus
checkfocus(){
  if [ $nofocus = false ] && [ $tog = true ]; then
      echo "$win LOST FOCUS TOGGLING AC OFF"
  fi
}
checkfocusw(){
  if [ $nofocus = false ] && [ $togw = true ]; then
      echo "$win LOST FOCUS TOGGLING AW OFF"
  fi
}
#togglable logging to prevent Output Clutter
logging(){
  if [ $log = false ]; then
    clear
    echo "AWAITING INPUT..."
  fi
}
#actual click logic
skipstory(){
  if [ $tog = true ]; then
      xdotool click --window '$winid' 1
      if [ $prevComb = true ]; then
        xdotool key --window '$winid' 'F1'
      fi
  fi
}
#toggle on off logic & moves mouse to specified location 
toggle(){
if [ $tog = false ]; then
    logging
    echo "CLICKER TOGGLE ON"
    
    tog=true

    #Move mouse to bottom item
    xdotool mousemove --screen 0 $xy
else
    logging
    echo "CLICKER TOGGLE OFF"

    tog=false
fi
}
#toggles autowalk on/off outputs to console
togglew(){
if [ $togw = false ]; then
    logging
    echo "AUTOWALK TOGGLE ON"
    xdotool keydown --window '$winid' 'w'
    togw=true
else
    logging
    echo "AUTOWALK TOGGLE OFF"
    xdotool keyup --window '$winid' 'w'
    togw=false
fi
}
#infinite loop to contiously check if Game Exists and if the window is active
while :
  do
    #check if Game exists 
    if wmctrl -l | grep "$win" | grep -v "$browser" > /dev/null; then
      #save active window to variable
      curwin="$(xdotool getwindowfocus getwindowname | uniq)"
      #check if active window is the same as the Game Named above
      if [ "$curwin" = "$win" ]; then
        #constantly execute the function skip story (wont do anything if tog=false)
        skipstory
        #Sets nofocus to false because confirmed Game is active window
        nofocus=false
        #if exists and focused then check if the Specified key is down if so AutoClick
        if xinput query-state $devid | grep "$buttorkey\[$key\]=$down" > /dev/null; then
          #enables autoclick
          toggle
          # wait .5 secounds to prevent spamming the output
          sleep 0.5
        fi
            
        #if exists and focused then check if the mouse 1 key is down if so Toggle OFF
        if xinput query-state $mouseID | grep "$mbuttorkey\[$mkey\]=$down" > /dev/null; then
          #checks if the the toggle is on
          if [ $tog = true ]; then
            #clear the output
            logging
            #ouput if toggle is on and mouse is clicked
            echo "MOUSE CLICKED TOGGLING AC OFF"
            fi
              #turns off the Autoclicker
              tog=false
              # wait .5 secounds to prevent spamming the output
              sleep 0.5
            fi
            #if exists and focused then check if the specified key is pressed and toggles the AutoWalk
            if xinput query-state $devid | grep "$buttorkey\[$key2\]=$down" > /dev/null; then
              #Toggles autowalk
              togglew
              #wait ,5 second to prevent spamming the output
              sleep 0.5
            fi
            if xinput query-state $devid | grep "$buttorkey\[$keyw\]=$down" > /dev/null; then
              if [ $togw = true ]; then
                logging
                echo "W PRESSED TOGGLING AW OFF"
              fi
                togw=false
            fi
            if xinput query-state $devid | grep "$buttorkey\[$esc\]=$down" > /dev/null; then
              logging
              tog=false
              togw=false
              echo "ESCAPE KEY PRESSED ALL TOGGLES DISABLED"
            fi
        #only executes when game has lost focus
      else
        logging
        #tell the user that the game window has lost focus output clicking has stopped
        checkfocus
        #tell user the game has lost focus output walk has stopped
        checkfocusw
        #toggle off Autoclicker
        tog=false
        #toggle off AutoWalking
        togw=false
        #set nofocus to true to prevent output spam
        nofocus=true
        #wait 2 seconds to prevent the program from infinitely looping too fast when not focused
        sleep 2
      fi
    else
      #clear the output
      clear
      #Restore the GameOverlayRender.so to allow use for other games
      if [ $GOR = false ]; then
        . ~/.scripts/RestoreGOR.sh
      fi
      #Tell the user that the game has closed
      echo $win" HAS CLOSED"
      #allow for 5 seconds for the user to read the output
      sleep 5
      #if logging is not enabled just exit the program
      if [ $log = false ]; then
          exit
      fi  
    fi
done
