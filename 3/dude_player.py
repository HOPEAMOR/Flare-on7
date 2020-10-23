##
# This script will autoplay wednesday.exe from Flare-on7 challenge 3.
# This script reliex on up_0.png and down_0.png being cropped to have just the inner part
# of the box with the letter remaining. this speeds up searching
# The screenshot region is also set for an 800x600 screeen for speed.
# A bigger screen will require a bigger region which will run slower and could be less consistent
##

import pyautogui
import time

def main():
	image_up = "C:\\Users\\Suzy\\Desktop\\gfx\\up_0.png"
	image_down = "C:\\Users\\Suzy\\Desktop\\gfx\\down_0.png"

	#down_init = 0

	while(True):
		image_screen = pyautogui.screenshot(region=(100,310,125,85))
		image_up_pos = pyautogui.locate(image_up,image_screen)
		image_down_pos = pyautogui.locate(image_down,image_screen)
		
		if (image_up_pos != None):
			pyautogui.keyDown("up")
			pyautogui.keyUp("up")
			print("match, jumping: ", image_up_pos)
		if (image_down_pos != None):
			pyautogui.keyDown("down")
			time.sleep(.75)
			pyautogui.keyUp("down")
			print("match, ducking: ", image_down_pos)

def mouse():
	while(True):
		mouse_pos = pyautogui.position()
		print(mouse_pos)
	
	
if __name__ == "__main__":
	main()
	#mouse()
