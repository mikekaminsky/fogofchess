#Fog of Chess
###A Chess Game of Limited Information

###TODO:

####Chess Rules:
* [ ] Promote pawn to any piece
* [ ] Detect checkmate

####UI:
* [ ] BUG: Fix highlighting.
* [ ] Create '[COLOR] Wins' screen
* [ ] Add 'resign' for both teams button -- show on screen during game.
* [ ] Add 'restart' button to win screen
  * [ ] Real navigations
    * [ ] Welcome/Intro Screen
    * [ ] Home Screen
    * [ ] Game screen
  * [ ] 'Your turn' animation/text box
  * [ ] New piece images
  * [ ] New board image
  * [ ] Piece movement animations
  * [ ] Cool 'fog' animations
* [ ] Replay feature
  * [ ] 'God view' (see whole board)
  * [ ] 'My view' (see with my vision)
  * [ ] 'Opponent view' (see with their vision)
  * [ ] Speed slider (slow, medium, fast) 

#### Application Infrastructure:
* [ ] Network iphones.
* [ ] Single-user view
* [ ] Limit view based on piece position.
* [ ] Users
  * [ ] Sign in
  * [ ] Save games
  * [ ] Find friends
* [ ] Alerts
  * [ ] Allow for "it's your turn" notifications

###Completed:
* [X] Add all pieces to board
* [X] Rename BoardView to Board
* [X] Move game logic to GameEngine class
* [x] Split out movement rules by piece
* [x] Cache board status for O(1) square lookups
* [x] Display captured pieces to 'bank' at top/bottom of board
* [x] Promote pawn to queen
* [x] Make 'your turn' appear on screen
* [x] Naive castling
* [x] Highlight selected piece during move
* [x] Create log of moves
  * [x] Keep track of current move number
  * [x] White's turn if current_move %% 2  == 1
  * [x] Save move once executed with enumeration
* [x] Tap to select + tap again to move.
* [x] BUG! Move 'square occupied by own team' logic to canMove()
* [x] BUG! castling is implemented in kingCanMove() which breaks move highlighting
* [x] List possible moves per piece
  * [x] List possible moves pawn
  * [x] List possible moves knight
  * [x] List possible moves bishop
  * [x] List possible moves roook
  * [x] List possible moves queen
  * [x] List possible moves king
* [x] Show win screen on capture of king
* [x] Reset game after winning
  * [x] Clear highlighting
  * [x] Clear selections
* [x] Highlight only while selected
* [x] REFACTOR!
  * [x] 'Stateful' things inside board, stateless inside game engine.
  * [x] Simplify the board class
* [x] Clear all arrays after use
* [x] Check if square with king is under attack
* [x] Implement en passant
* [x] Detect if square is under attack?
* [x] Implement correct castling (can't castle through check)
* [x] BUG: Need to account for pawn diagonal attack when doing castling
* [x] Need to take into account future state of the world when validating move does not put king into check.
