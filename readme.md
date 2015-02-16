#Fog of Chess
###A Chess Game of Limited Information

###TODO:
* [X] Add all pieces to board
* [X] Rename BoardView to Board
* [X] Move game logic to GameEngine class
* [x] Split out movement rules by piece
* [x] Cache board status for O(1) square lookups
* [x] Display captured pieces to 'bank' at top/bottom of board
* [ ] Create log of moves
  * [ ] Keep track of current move number
  * [ ] White's turn if current_move %% 2  == 1
  * [ ] Save move once executed with enumeration
* [ ] List possible moves per piece
* [ ] Detect check per square
* [ ] Finish rules
  * [ ] Implement en passant
  * [ ] Implement castling
  * [ ] Prevent moves into check
  * [ ] Detect checkmate
  * [ ] Allow players to resign
* [ ] Network iphones.
* [ ] Limit view based on piece position.
* [ ] Upgrade all UI
  * [ ] Real navigations
    * [ ] Welcome/Intro Screen
    * [ ] Home Screen
    * [ ] Game screen
  * [ ] 'You're turn' animation/text box
  * [ ] New Pieces
  * [ ] New Board
  * [ ] Piece animations
  * [ ] Cool 'fog' animations
* [ ] Replay feature
  * [ ] 'God view' (see whole board)
  * [ ] 'My view' (see with my vision)
  * [ ] 'Opponent view' (see with their vision)
  * [ ] Speed slider (slow, medium, fast)
* [ ] Users
  * [ ] Sign in
  * [ ] Save games
  * [ ] Find friends
* [ ] Alerts
  * [ ] Allow for "it's your turn" notifications
