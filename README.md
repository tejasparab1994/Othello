# Team: 410
# Members: Sibendu Dey (dey.s@husky.neu.edu)
# 	 Tejas Parab (parab.t@husky.neu.edu)


## What players will see on the screen and the actions they can take:
	The first page of our game would consist of two input fields wherein the users would be able to enter the game name and their own username. Apart from the two input fields the first page of our game would also have two buttons. 
On entering the game and user names, the players may click the “Play the game” button after which the actual game page would open consisting of the board and a chatbox too. “Play the game” button would also have check, which would check whether the game already has two users or not. If the game has two users, there would be an error message stating that the game is full. 
The other button on the page would be the “Observe the game” button the users would be able to go to the game page and see the two players play. The observers wouldn’t be able to interact in anyway with the game board. Any number of observers would be supported by the game.
On the game page, the board would be placed left-aligned or centered with the chatbox being right aligned, the username entered on the first page would be used in the chatbox to chat with other observers and the two players. The board would consist of 64 tiles. The two players would also be able to chat using the chatbox. We would also be keeping tab of the players’ score on this page.
 
## Game start condition:
	The game would consist of white and black coins. The game would start with 2 black and 2 white coins already placed in the central 4 tiles.No matching colors are connected vertically or horizontally so a miniature chequered pattern is made. Apart from this, the black and white coins would be randomly assigned to the players. The player with black coins plays first. Each player would begin the game with a score of 2.

## Game end condition(win):
	The players’ score would be calculated based on the number of coins they have on the board. As these would keep changing as the game progresses, the game would end when the summation of their scores equals to 64(total tiles on the board). At this point, the player with the most coins would win. We may also implement a timing element to the game, wherein the game needs to be completed in the stipulated time and once the time runs out, the player with higher score wins.