gameStates = {
	paused				= 0 --Game is paused
	waitingTxtSelection = 1 --Game is waiting for player to select a text object
	waitingIngSelection = 2 --Text object has been selected, waiting for player to find ingredient
	dragging			= 3 --Player is dragging ingredient
	ingredientSnap		= 4 --Player has placed ingredient somewhere other than staging area, snapping ingredient back to it's orignal position
	waitingFire			= 5 --All staging area slots are full, waiting for player to select "Fire It!"
	levelOver			= 6 --Level has ended
}