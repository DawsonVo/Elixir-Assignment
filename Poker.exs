defmodule Poker do
	def deal(list) do
		#Dealing hands for player1 and player2 using Enum
		playerTwo = Enum.drop_every(list, 2)
		playerOne = list -- playerTwo
		#Converting inputted values into a numerical+letter representation i.e. 1C, 2D using tuples, divison and mod
		convertTuple = fn
			x when div(x-1, 13) == 0 -> {(rem((x+12), 13)+1), 'C'}
			x when div(x-1, 13) == 1 -> {(rem((x+12), 13)+1), 'D'}
			x when div(x-1, 13) == 2 -> {(rem((x+12), 13)+1), 'H'}
			x when div(x-1, 13) == 3 -> {(rem((x+12), 13)+1), 'S'}
			_ -> :error
		end
		#Using Enum to sort each player's hands
		playerOne = Enum.sort(Enum.map(playerOne, convertTuple))
		playerTwo = Enum.sort(Enum.map(playerTwo, convertTuple))
		Enum.map(play(playerOne, playerTwo), fn {x,y} -> "#{to_string(x)}"<>"#{y}" end)
	end
	#Poker.deal([1,2,10,3,11,4,12,5,13,6])

	#ROYAL FLUSH tie compare suits
	def play([{1, a}, {10, a}, {11, a}, {12, a}, {13, a}], [{1, b}, {10, b}, {11, b}, {12, b}, {13, b}]) do #TIE BREAKER RF
		#compare suits to see which is higher, since both hands will have the same ranks
		if (a>b) do
			[{1, a}, {10, a}, {11, a}, {12, a}, {13, a}]
		else
			[{1, b}, {10, b}, {11, b}, {12, b}, {13, b}]
		end
	end
	def play([{1, a}, {10, a}, {11, a}, {12, a}, {13, a}], _), do: [{1, a}, {10, a}, {11, a}, {12, a}, {13, a}] #PLAYER1 winner RF
	def play(_, [{1, b}, {10, b}, {11, b}, {12, b}, {13, b}]), do: [{1, b}, {10, b}, {11, b}, {12, b}, {13, b}] #PLAYER2 winner RF
	
	#STRAIGHT FLUSH tie compare x4,y4 then suits
	def play([{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}], [{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]) when x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4) and y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4) do #TIE BREAKER SF
		#Compare the last card since the hands are already sorted, compare the suits if ranks are the same
		if(x4==y4) do
			if (a>b) do
				[{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}]
			else
				[{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]
			end
		else
			if (x4>y4) do
				[{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}]
			else
				[{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]
			end
		end
	end
	def play([{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}], _) when x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4) do #PLAYER1 winner STRAIGHT FLUSH
		[{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}]
	end
	def play(_, [{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]) when y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4) do #PLAYER2 winner STRAIGHT FLUSH
		[{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]
	end
	
	#FOUR OF KIND tie breaker compare ranks, no 2 FOK (ie there arent 8 cards of the same rank)
	#Compares each set of card combinations 
	def play([{x, a1}, {x, a2}, {x, a3}, {x, a4}, {x1,a5}], [{y, b1}, {y, b2}, {y, b3}, {y, b4}, {y1, b5}]) do #TIE BREAKER FOUR OF KIND 4/1 & 4/1
		cond do
			#Condition for ace cards
			x==1||y==1 ->
				cond do
					x==1 && y != 1 -> [{x, a1}, {x, a2}, {x, a3}, {x, a4}, {x1, a5}]
					y==1 && x != 1 -> [{y, b1}, {y, b2}, {y, b3}, {y, b4}, {y1, b5}]
				end
			x>y -> [{x, a1}, {x, a2}, {x, a3}, {x, a4}, {x1, a5}]
			x<y -> [{y, b1}, {y, b2}, {y, b3}, {y, b4}, {y1, b5}]
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x1, a1}, {x, a2}, {x, a3}, {x, a4}, {x, a5}], [{y, b1}, {y, b2}, {y, b3}, {y, b4}, {y1, b5}]) do #TIE BREAKER FOUR OF KIND 1/4 & 4/1
		cond do
			y==1 && x != 1 -> [{y, b1}, {y, b2}, {y, b3}, {y, b4}, {y1, b5}]
			x>y -> [{x1, a1}, {x, a2}, {x, a3}, {x, a4}, {x,a5}]
			x<y -> [{y, b1}, {y, b2}, {y, b3}, {y, b4}, {y1, b5}]
			x==y -> [{1," Error Duplicate Cards"}]
		end 
	end
	def play([{x, a1}, {x, a2}, {x, a3}, {x, a4}, {x1, a5}], [{y1, b1}, {y, b2}, {y, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER FOUR OF KIND 4/1 & 1/4
		cond do
			x==1 && y != 1 -> [{x, a1}, {x, a2}, {x, a3}, {x, a4}, {x1,a5}]
			x>y -> [{x, a1}, {x, a2}, {x, a3}, {x, a4}, {x1,a5}]
			x<y -> [{y1, b1}, {y, b2}, {y, b3}, {y, b4}, {y, b5}]
			x==y -> [{1," Error Duplicate Cards"}]
		end 
	end
	def play([{x1, a1}, {x, a2}, {x, a3}, {x, a4}, {x, a5}], [{y1, b1}, {y, b2}, {y, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER FOUR OF KIND 1/4 & 1/4
		cond do
			x>y -> [{x1, a1}, {x, a2}, {x, a3}, {x, a4}, {x,a5}]
			x<y -> [{y1, b1}, {y, b2}, {y, b3}, {y, b4}, {y, b5}]
			x==y -> [{1," Error Duplicate Cards"}]
		end 
	end
	def play([{x, a1}, {x, a2}, {x, a3}, {x, a4}, {x2, a5}], _), do: [{x, a1}, {x, a2}, {x, a3}, {x, a4}, {x2, a5}]#PLAYER1 winner FOUR OF KIND 4/1
	def play([{x2, a1}, {x, a2}, {x, a3}, {x, a4}, {x, a5}], _), do: [{x2, a1}, {x, a2}, {x, a3}, {x, a4}, {x, a5}]#PLAYER1 winner FOUR OF KIND 1/4
	def play(_, [{y, b1}, {y, b2}, {y, b3}, {y, b4}, {y2, b5}]), do: [{y, b1}, {y, b2}, {y, b3}, {y, b4}, {y2, b5}]#PLAYER2 winner FOUR OF KIND 4/1
	def play(_, [{y2, b1}, {y, b2}, {y, b3}, {y, b4}, {y, b5}]), do: [{y2, b1}, {y, b2}, {y, b3}, {y, b4}, {y, b5}]#PLAYER2 winner FOUR OF KIND 1/4

#FULL HOUSE tiebreaker compare rank of TOK, there arent 2 TOK  (ie, no 6 cards of same rank)
#Test each possible card combinstion with full house and compare the ranks
	def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}], [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]) do #TIE BREAKER FH 3/2 & 3/2
		cond do
			#Check if either hands have an ace card
			x==1||y==1 ->
				cond do
				x==1 && y != 1 -> [{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}]
				y==1 && x != 1 -> [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]
				end
			#Compare card values for this combination of cards
			x>y -> [{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}]
			x<y -> [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}], [{y2, b}, {y2, b2}, {y, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER FH 3/2 & 2/3
		cond do
			#Check for if hand1 has Ace TOK
			x==1 -> [{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}]
			#Compare card values for this combination of cards
			x>y -> [{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}]
			x<y -> [{y2, b}, {y2, b2}, {y, b3}, {y, b4}, {y, b5}]
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a}, {x2, a2}, {x, a3}, {x, a4}, {x, a5}], [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]) do #TIE BREAKER FH 2/3 & 3/2
		cond do
			#Check if hand2 has Ace TOK
			y==1 -> [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]
			#Compare card values for this combination of cards
			x>y -> [{x2, a}, {x2, a2}, {x, a3}, {x, a4}, {x, a5}]
			x<y -> [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a}, {x2, a2}, {x, a3}, {x, a4}, {x, a5}], [{y2, b}, {y2, b2}, {y, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER FH 2/3 & 2/3
		cond do
			#Compare card values for this combination of cards
			x>y -> [{x2, a}, {x2, a2}, {x, a3}, {x, a4}, {x, a5}]
			x<y -> [{y2, b}, {y2, b2}, {y, b3}, {y, b4}, {y, b5}]
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	#Each possible winning hand combination 
	def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}], _), do: [{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}]#PLAYER1 FH 3/2 winner
	def play([{x2, a}, {x2, a2}, {x, a3}, {x, a4}, {x, a5}], _), do: [{x2, a}, {x2, a2}, {x, a3}, {x, a4}, {x, a5}]#PLAYER1 FH 3/2 winner
	def play(_, [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]), do: [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]#PLAYER2 FH 3/2 winner
	def play(_, [{y2, b}, {y2, b2}, {y, b3}, {y, b4}, {y, b5}]), do: [{y2, b}, {y2, b2}, {y, b3}, {y, b4}, {y, b5}]#PLAYER2 FH 2/3 winner

#FLUSH tie compare compare the ranks of high card, if all cards are the same rank check suite
#Check the ranking of last (highest rank) card 
	def play([{x, a}, {x2, a}, {x3, a}, {x4, a}, {x5, a}], [{y, b}, {y2, b}, {y3, b}, {y4, b}, {y5, b}]) do #TIE BREAKER FLUSH
		hand1 = [{x, a}, {x2, a}, {x3, a}, {x4, a}, {x5, a}]
		hand2 = [{y, b}, {y2, b}, {y3, b}, {y4, b}, {y5, b}]
		cond do
			#Condition for ace cards
			x==1||y==1 -> 	
			cond do
				x==1 && y != 1 -> hand1
				y==1 && x != 1 -> hand2
				x5 != y5 -> if x5>y5, do: hand1, else: hand2
				x4 != y4 -> if x4>y4, do: hand1, else: hand2
				x3 != y3 -> if x3>y3, do: hand1, else: hand2
				x2 != y2 -> if x2>y2, do: hand1, else: hand2
				a > b -> hand1
				a < b -> hand2
				a == b -> [{1," Error Duplicate Cards"}]
			end
			#Compares ranks in descending order, then compares suits if they're all the same rank 
			x5 != y5 -> if x5>y5, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			a != b -> if a>b, do: hand1, else: hand2
			a == b -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a}, {x2, a}, {x3, a}, {x4, a}, {x5, a}], _), do: [{x, a}, {x2, a}, {x3, a}, {x4, a}, {x5, a}]#PLAYER 1 FLUSH
	def play(_, [{y, b}, {y2, b}, {y3, b}, {y4, b}, {y5, b}]), do: [{y, b}, {y2, b}, {y3, b}, {y4, b}, {y5, b}]#PLAYER 2 FLUSH

#STRAIGHT tie compare rank of hand then check suite if same ranks
	def play([{x, a1}, {x1, a2}, {x2, a3}, {x3, a4}, {x4, a5}], [{y, b1}, {y1, b2}, {y2, b3}, {y3, b4}, {y4, b5}]) when ((x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4)) or (x==1 and x1==10 and x2==11 and x3==12 and x4==13)) and ((y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4)) or (y==1 and y1==10 and y2 == 11 and y3 == 12 and y4 == 13)) do #TIE BREAKER STRAIGHT
		hand1 = [{x, a1}, {x1, a2}, {x2, a3}, {x3, a4}, {x4, a5}]
		hand2 = [{y, b1}, {y1, b2}, {y2, b3}, {y3, b4}, {y4, b5}]
		cond do
			#Check for ace cards (highcard only)
			((x==1 || y==1) && (x != y)) && (x4==13 || y4==13) -> 
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
					a5 != b5 -> if a5>b5, do: hand1, else: hand2
				end
			#Check the last card in each hand and their suits
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			a5 != b5 -> if a5>b5, do: hand1, else: hand2
			a5 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	#Comparing for winning hands
	def play([{x, a1}, {x1, a2}, {x2, a3}, {x3, a4}, {x4, a5}], _) when ((x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4)) or (x==1 and x1==10 and x2==11 and x3==12 and x4==13)) do #PLAYER1 STRAIGHT
		[{x, a1}, {x1, a2}, {x2, a3}, {x3, a4}, {x4, a5}]
	end
	def play(_, [{y, b1}, {y1, b2}, {y2, b3}, {y3, b4}, {y4, b5}]) when ((y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4)) or (y==1 and y1==10 and y2 == 11 and y3 == 12 and y4 == 13)) do #PLAYER2 STRAIGHT
		[{y, b1}, {y1, b2}, {y2, b3}, {y3, b4}, {y4, b5}]
	end
	
#ThreeOfAKind if tie compare rank of TOK, no need to check suit because no 2 TOK, (ie no 6 cards of same rank)
#Checks each possible combination with three of a kind. 
#Each play() for Three of a kind will compare x and y but the placement of x and y in the parameters differ based on the combination of cards
	def play([{x, a1}, {x, a2}, {x, a3}, {x2, a4}, {x3, a5}], [{y, b1}, {y, b2}, {y, b3}, {y2, b4}, {y3, b5}]) do #TIE BREAKER THREE OF KIND 3/1/1 & 3/1/1
		hand1 = [{x, a1}, {x, a2}, {x, a3}, {x2, a4}, {x3, a5}]
		hand2 = [{y, b1}, {y, b2}, {y, b3}, {y2, b4}, {y3, b5}]
		cond do
			x==1 || y==1 ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x != y -> if x>y, do: hand1, else: hand2
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a1}, {x, a2}, {x, a3}, {x2, a4}, {x3, a5}], [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER THREE OF KIND 3/1/1 & 1/1/3
		hand1 = [{x, a1}, {x, a2}, {x, a3}, {x2, a4}, {x3, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y, b5}]
		cond do
			x==1 || y==1 ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x != y -> if x>y, do: hand1, else: hand2
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a1}, {x, a2}, {x, a3}, {x2, a4}, {x3, a5}], [{y2, b1}, {y, b2}, {y, b3}, {y, b4}, {y3, b5}]) do #TIE BREAKER THREE OF KIND 3/1/1 & 1/3/1
		hand1 = [{x, a1}, {x, a2}, {x, a3}, {x2, a4}, {x3, a5}]
		hand2 = [{y2, b1}, {y, b2}, {y, b3}, {y, b4}, {y3, b5}]
		cond do
			x==1 || y==1 ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x != y -> if x>y, do: hand1, else: hand2
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x, a5}], [{y, b1}, {y, b2}, {y, b3}, {y2, b4}, {y3, b5}]) do #TIE BREAKER THREE OF KIND 1/1/3 & 3/1/1
		hand1 = [{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x, a5}]
		hand2 = [{y, b1}, {y, b2}, {y, b3}, {y2, b4}, {y3, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x != y -> if x>y, do: hand1, else: hand2
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x, a5}], [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER THREE OF KIND 1/1/3 & 1/1/3
		hand1 = [{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x != y -> if x>y, do: hand1, else: hand2
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x, a5}], [{y2, b1}, {y, b2}, {y, b3}, {y, b4}, {y3, b5}]) do #TIE BREAKER THREE OF KIND 1/1/3 & 1/3/1
		hand1 = [{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x, a5}]
		hand2 = [{y2, b1}, {y, b2}, {y, b3}, {y, b4}, {y3, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x != y -> if x>y, do: hand1, else: hand2
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x, a2}, {x, a3}, {x, a4}, {x3, a5}], [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER THREE OF KIND 1/3/1 & 1/1/3
		hand1 = [{x2, a1}, {x, a2}, {x, a3}, {x, a4}, {x3, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x != y -> if x>y, do: hand1, else: hand2
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x, a2}, {x, a3}, {x, a4}, {x3, a5}], [{y, b1}, {y, b2}, {y, b3}, {y2, b4}, {y3, b5}]) do #TIE BREAKER THREE OF KIND 1/3/1 & 3/1/1
		hand1 = [{x2, a1}, {x, a2}, {x, a3}, {x, a4}, {x3, a5}]
		hand2 = [{y, b1}, {y, b2}, {y, b3}, {y2, b4}, {y3, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x != y -> if x>y, do: hand1, else: hand2
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x, a2}, {x, a3}, {x, a4}, {x3, a5}], [{y2, b1}, {y, b2}, {y, b3}, {y, b4}, {y3, b5}]) do #TIE BREAKER THREE OF KIND 1/3/1 & 1/3/1
		hand1 = [{x2, a1}, {x, a2}, {x, a3}, {x, a4}, {x3, a5}]
		hand2 = [{y2, b1}, {y, b2}, {y, b3}, {y, b4}, {y3, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x != y -> if x>y, do: hand1, else: hand2
			x==y -> [{1," Error Duplicate Cards"}]
		end
	end
	#Compare to find a winning hand for non ties
	def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x3, a5}], _), do: [{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x3, a5}]#PLAYER1 THREE OF KIND 3/1/1 winner
	def play([{x2, a}, {x3, a2}, {x, a3}, {x, a4}, {x, a5}], _), do: [{x2, a}, {x3, a2}, {x, a3}, {x, a4}, {x, a5}]#PLAYER1 THREE OF KIND 1/1/3 winner
	def play([{x2, a}, {x, a2}, {x, a3}, {x, a4}, {x3, a5}], _), do: [{x2, a}, {x, a2}, {x, a3}, {x, a4}, {x3, a5}]#PLAYER1 THREE OF KIND 1/3/1 winner
	def play(_, [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y3, b5}]), do: [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y3, b5}]#PLAYER2 THREE OF KIND 3/1/1 winner
	def play(_, [{y2, b}, {y3, b2}, {y, b3}, {y, b4}, {y, b5}]), do: [{y2, b}, {y3, b2}, {y, b3}, {y, b4}, {y, b5}]#PLAYER2 THREE OF KIND 1/1/3 winner
	def play(_, [{y2, b}, {y, b2}, {y, b3}, {y, b4}, {y3, b5}]), do: [{y2, b}, {y, b2}, {y, b3}, {y, b4}, {y3, b5}]#PLAYER2 THREE OF KIND 1/3/1 winner

#Two pair tie compare, high pair lowpair, random, suit
#Each play() for two pair tie will compare x and y values, and then suits 
#Any x==1 or y==1 is testing for an ace card in the hand, Whichever hand has the ace card will return it's hand
	def play([{x, a1}, {x, a2}, {x2, a3}, {x2,a4}, {x3, a5}], [{y, b1}, {y, b2}, {y2, b3},{y2, b4}, {y3, b5}]) do #TIE BREAKER TWO PAIR 2/2/1 & 2/2/1
		hand1 = [{x, a1}, {x, a2}, {x2, a3}, {x2,a4}, {x3, a5}]
		hand2 = [{y, b1}, {y, b2}, {y2, b3},{y2, b4}, {y3, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			#If both hands have an ace, it will compare the suits 
			x==1 && y==1 ->
				cond do
					a2 != b2 -> if a2>b2, do: hand1, else: hand2
					a2 == b2 -> [{1," Error Duplicate Cards"}]
				end
			a4 != b4 -> if a4>b4, do: hand1, else: hand2
			a4 == b4 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a1}, {x, a2}, {x2, a3}, {x2,a4}, {x3, a5}], [{y3, b1}, {y, b2}, {y, b3},{y2, b4}, {y2, b5}]) do #TIE BREAKER TWO PAIR 2/2/1 & 1/2/2
		hand1 = [{x, a1}, {x, a2}, {x2, a3}, {x2,a4}, {x3, a5}]
		hand2 = [{y3, b1}, {y, b2}, {y, b3},{y2, b4}, {y2, b5}]
		cond do
			x==1 -> hand1
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			a4 != b5 -> if a4>b5, do: hand1, else: hand2
			a4 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a1}, {x, a2}, {x2, a3}, {x2,a4}, {x3, a5}], [{y, b1}, {y, b2}, {y3, b3},{y2, b4}, {y2, b5}]) do #TIE BREAKER TWO PAIR 2/2/1 & 2/1/2
		hand1 = [{x, a1}, {x, a2}, {x2, a3}, {x2,a4}, {x3, a5}]
		hand2 = [{y, b1}, {y, b2}, {y3, b3},{y2, b4}, {y2, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			#If they both have an ace it will compare suits 
			x==1 && y==1 ->
				cond do
				a2 != b2 -> if a2>b2, do: hand1, else: hand2
				a2 == b2 -> [{1," Error Duplicate Cards"}]
				end
			a4 != b5 -> if a4>b5, do: hand1, else: hand2
			a4 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x3, a1}, {x, a2}, {x, a3}, {x2,a4}, {x2, a5}], [{y, b1}, {y, b2}, {y2, b3},{y2, b4}, {y3, b5}]) do #TIE BREAKER TWO PAIR 1/2/2 & 2/2/1
		hand1 = [{x3, a1}, {x, a2}, {x, a3}, {x2,a4}, {x2, a5}]
		hand2 = [{y, b1}, {y, b2}, {y2, b3},{y2, b4}, {y3, b5}]
		cond do
			y==1 -> hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			a5 != b4 -> if a5>b4, do: hand1, else: hand2
			a5 == b4 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x3, a1}, {x, a2}, {x, a3}, {x2,a4}, {x2, a5}], [{y3, b1}, {y, b2}, {y, b3},{y2, b4}, {y2, b5}]) do #TIE BREAKER TWO PAIR 1/2/2 & 1/2/2
		hand1 = [{x3, a1}, {x, a2}, {x, a3}, {x2,a4}, {x2, a5}]
		hand2 = [{y3, b1}, {y, b2}, {y, b3},{y2, b4}, {y2, b5}]
		cond do
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			a5 != b5 -> if a5>b5, do: hand1, else: hand2
			a5 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x3, a1}, {x, a2}, {x, a3}, {x2,a4}, {x2, a5}], [{y, b1}, {y, b2}, {y3, b3},{y2, b4}, {y2, b5}]) do #TIE BREAKER TWO PAIR 1/2/2 & 2/1/2
		hand1 = [{x3, a1}, {x, a2}, {x, a3}, {x2,a4}, {x2, a5}]
		hand2 = [{y, b1}, {y, b2}, {y3, b3},{y2, b4}, {y2, b5}]
		cond do
			y==1 -> hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			a5 != b5 -> if a5>b5, do: hand1, else: hand2
			a5 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a1}, {x, a2}, {x3, a3}, {x2,a4}, {x2, a5}], [{y, b1}, {y, b2}, {y2, b3},{y2, b4}, {y3, b5}]) do #TIE BREAKER TWO PAIR 2/1/2 & 2/2/1
		hand1 = [{x, a1}, {x, a2}, {x3, a3}, {x2,a4}, {x2, a5}]
		hand2 = [{y, b1}, {y, b2}, {y2, b3},{y2, b4}, {y3, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			#If they both have an ace it will compare suits
			x==1&&y==1 ->
				cond do
					a2 != b2 -> if a2>b2, do: hand1, else: hand2
					a2 == b2 -> [{1," Error Duplicate Cards"}]
				end
			a5 != b4 -> if a5>b4, do: hand1, else: hand2
			a5 == b4 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a1}, {x, a2}, {x3, a3}, {x2,a4}, {x2, a5}], [{y3, b1}, {y, b2}, {y, b3},{y2, b4}, {y2, b5}]) do #TIE BREAKER TWO PAIR 2/1/2 & 1/2/2
		hand1 = [{x, a1}, {x, a2}, {x3, a3}, {x2,a4}, {x2, a5}]
		hand2 = [{y3, b1}, {y, b2}, {y, b3},{y2, b4}, {y2, b5}]
		cond do
			x==1 -> hand1
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			a5 != b5 -> if a5>b5, do: hand1, else: hand2
			a5 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a1}, {x, a2}, {x3, a3}, {x2,a4}, {x2, a5}], [{y, b1}, {y, b2}, {y3, b3},{y2, b4}, {y2, b5}]) do #TIE BREAKER TWO PAIR 2/1/2 & 2/1/2
		hand1 = [{x, a1}, {x, a2}, {x3, a3}, {x2,a4}, {x2, a5}]
		hand2 = [{y, b1}, {y, b2}, {y3, b3},{y2, b4}, {y2, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			#If they both have an ace it will compare suits
			x==1&&y==1 ->
				cond do
				a2 != b2 -> if a2>b2, do: hand1, else: hand2
				a2 == b2 -> [{1," Error Duplicate Cards"}]
				end
			a5 != b5 -> if a5>b5, do: hand1, else: hand2
			a5 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a}, {x, a2}, {x2, a3}, {x2, a4}, {x3, a5}], _), do: [{x, a}, {x, a2}, {x2, a3}, {x2, a4}, {x3, a5}]#PLAYER1 TWO PAIR 2/2/1 winner
	def play([{x3, a}, {x2, a2}, {x2, a3}, {x, a4}, {x, a5}], _), do: [{x3, a}, {x2, a2}, {x2, a3}, {x, a4}, {x, a5}]#PLAYER1 TWO PAIR 1/2/2 winner
	def play([{x2, a}, {x2, a2}, {x3, a3}, {x, a4}, {x, a5}], _), do: [{x2, a}, {x2, a2}, {x3, a3}, {x, a4}, {x, a5}]#PLAYER1 TWO PAIR 2/1/2 winner
	def play(_, [{y, b}, {y, b2}, {y2, b3}, {y2, b4}, {y3, b5}]), do: [{y, b}, {y, b2}, {y2, b3}, {y2, b4}, {y3, b5}]#PLAYER2 TWO PAIR 2/2/1 winner
	def play(_, [{y3, b}, {y2, b2}, {y2, b3}, {y, b4}, {y, b5}]), do: [{y3, b}, {y2, b2}, {y2, b3}, {y, b4}, {y, b5}]#PLAYER2 TWO PAIR 1/2/2 winner
	def play(_, [{y2, b}, {y2, b2}, {y3, b3}, {y, b4}, {y, b5}]), do: [{y2, b}, {y2, b2}, {y3, b3}, {y, b4}, {y, b5}]#PLAYER2 TWO PAIR 2/1/2 winner
	
#pair tie compare
#Each play() for pair tie compare will compare x and y values which are placed differently in parameter inputs based on combination of hands
#Any x==1 or y==1 will compare for ace cards.
	def play([{x, a1}, {x, a2}, {x2, a3}, {x3, a4}, {x4, a5}], [{y, b1}, {y, b2}, {y2, b3}, {y3, b4}, {y4, b5}]) do #TIE BREAKER PAIR 2/1/1/1 & 2/1/1/1
		hand1 = [{x, a1}, {x, a2}, {x2, a3}, {x3, a4}, {x4, a5}]
		hand2 = [{y, b1}, {y, b2}, {y2, b3}, {y3, b4}, {y4, b5}]
		cond do
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a2 != b2 -> if a2>b2, do: hand1, else: hand2
			a2 == b2 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a1}, {x, a2}, {x2, a3}, {x3, a4}, {x4, a5}], [{y2, b1}, {y, b2}, {y, b3}, {y3, b4}, {y4, b5}]) do #TIE BREAKER PAIR 2/1/1/1 & 1/2/1/1
		hand1 = [{x, a1}, {x, a2}, {x2, a3}, {x3, a4}, {x4, a5}]
		hand2 = [{y2, b1}, {y, b2}, {y, b3}, {y3, b4}, {y4, b5}]
		cond do
			x==1 -> hand1
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a2 != b3 -> if a2>b3, do: hand1, else: hand2
			a2 == b3 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a1}, {x, a2}, {x2, a3}, {x3, a4}, {x4, a5}], [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y4, b5}]) do #TIE BREAKER PAIR 2/1/1/1 & 1/1/2/1
		hand1 = [{x, a1}, {x, a2}, {x2, a3}, {x3, a4}, {x4, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y4, b5}]
		cond do
			x==1 -> hand1
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a2 != b4 -> if a2>b4, do: hand1, else: hand2
			a2 == b4 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x, a1}, {x, a2}, {x2, a3}, {x3, a4}, {x4, a5}], [{y2, b1}, {y3, b2}, {y4, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER PAIR 2/1/1/1 & 1/1/1/2
		hand1 = [{x, a1}, {x, a2}, {x2, a3}, {x3, a4}, {x4, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y4, b3}, {y, b4}, {y, b5}]
		cond do
			x==1 -> hand1
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a2 != b5 -> if a2>b5, do: hand1, else: hand2
			a2 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x, a2}, {x, a3}, {x3, a4}, {x4, a5}], [{y, b1}, {y, b2}, {y2, b3}, {y3, b4}, {y4, b5}]) do #TIE BREAKER PAIR 1/2/1/1 & 2/1/1/1
		hand1 = [{x2, a1}, {x, a2}, {x, a3}, {x3, a4}, {x4, a5}]
		hand2 = [{y, b1}, {y, b2}, {y2, b3}, {y3, b4}, {y4, b5}]
		cond do
			y==1 -> hand2
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a3 != b2 -> if a3>b2, do: hand1, else: hand2
			a3 == b2 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x, a2}, {x, a3}, {x3, a4}, {x4, a5}], [{y2, b1}, {y, b2}, {y, b3}, {y3, b4}, {y4, b5}]) do #TIE BREAKER PAIR 1/2/1/1 & 1/2/1/1
		hand1 = [{x2, a1}, {x, a2}, {x, a3}, {x3, a4}, {x4, a5}]
		hand2 = [{y2, b1}, {y, b2}, {y, b3}, {y3, b4}, {y4, b5}]
		cond do
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a3 != b3 -> if a3>b3, do: hand1, else: hand2
			a3 == b3 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x, a2}, {x, a3}, {x3, a4}, {x4, a5}], [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y4, b5}]) do #TIE BREAKER PAIR 1/2/1/1 & 1/1/2/1
		hand1 = [{x2, a1}, {x, a2}, {x, a3}, {x3, a4}, {x4, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y4, b5}]
		cond do
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a3 != b4 -> if a3>b4, do: hand1, else: hand2
			a3 == b4 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x, a2}, {x, a3}, {x3, a4}, {x4, a5}], [{y2, b1}, {y3, b2}, {y4, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER PAIR 1/2/1/1 & 1/1/1/2
		hand1 = [{x2, a1}, {x, a2}, {x, a3}, {x3, a4}, {x4, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y4, b3}, {y, b4}, {y, b5}]
		cond do
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a3 != b5 -> if a3>b5, do: hand1, else: hand2
			a3 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x4, a5}], [{y, b1}, {y, b2}, {y2, b3}, {y3, b4}, {y4, b5}]) do #TIE BREAKER PAIR 1/1/2/1 & 2/1/1/1
		hand1 = [{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x4, a5}]
		hand2 = [{y, b1}, {y, b2}, {y2, b3}, {y3, b4}, {y4, b5}]
		cond do
			y==1 -> hand2
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a4 != b2 -> if a4>b2, do: hand1, else: hand2
			a4 == b2 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x4, a5}], [{y2, b1}, {y, b2}, {y, b3}, {y3, b4}, {y4, b5}]) do #TIE BREAKER PAIR 1/1/2/1 & 1/2/1/1
		hand1 = [{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x4, a5}]
		hand2 = [{y2, b1}, {y, b2}, {y, b3}, {y3, b4}, {y4, b5}]
		cond do
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a4 != b3 -> if a4>b3, do: hand1, else: hand2
			a4 == b3 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x4, a5}], [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y4, b5}]) do #TIE BREAKER PAIR 1/1/2/1 & 1/1/2/1
		hand1 = [{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x4, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y4, b5}]
		cond do
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a4 != b4 -> if a4>b4, do: hand1, else: hand2
			a4 == b4 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x4, a5}], [{y2, b1}, {y3, b2}, {y4, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER PAIR 1/1/2/1 & 1/1/1/2
		hand1 = [{x2, a1}, {x3, a2}, {x, a3}, {x, a4}, {x4, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y4, b3}, {y, b4}, {y, b5}]
		cond do
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a4 != b5 -> if a4>b5, do: hand1, else: hand2
			a4 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x4, a3}, {x, a4}, {x, a5}], [{y, b1}, {y, b2}, {y2, b3}, {y3, b4}, {y4, b5}]) do #TIE BREAKER PAIR 1/1/1/2 & 2/1/1/1
		hand1 = [{x2, a1}, {x3, a2}, {x4, a3}, {x, a4}, {x, a5}]
		hand2 = [{y, b1}, {y, b2}, {y2, b3}, {y3, b4}, {y4, b5}]
		cond do
			y==1 -> hand2
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a5 != b2 -> if a5>b2, do: hand1, else: hand2
			a5 == b2 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x4, a3}, {x, a4}, {x, a5}], [{y2, b1}, {y, b2}, {y, b3}, {y3, b4}, {y4, b5}]) do #TIE BREAKER PAIR 1/1/1/2 & 1/2/1/1
		hand1 = [{x2, a1}, {x3, a2}, {x4, a3}, {x, a4}, {x, a5}]
		hand2 = [{y2, b1}, {y, b2}, {y, b3}, {y3, b4}, {y4, b5}]
		cond do
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a5 != b3 -> if a5>b3, do: hand1, else: hand2
			a5 == b3 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x4, a3}, {x, a4}, {x, a5}], [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y4, b5}]) do #TIE BREAKER PAIR 1/1/1/2 & 1/1/2/1
		hand1 = [{x2, a1}, {x3, a2}, {x4, a3}, {x, a4}, {x, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y, b3}, {y, b4}, {y4, b5}]
		cond do
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a5 != b4 -> if a5>b4, do: hand1, else: hand2
			a5 == b4 -> [{1," Error Duplicate Cards"}]
		end
	end
	def play([{x2, a1}, {x3, a2}, {x4, a3}, {x, a4}, {x, a5}], [{y2, b1}, {y3, b2}, {y4, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER PAIR 1/1/1/2 & 1/1/1/2
		hand1 = [{x2, a1}, {x3, a2}, {x4, a3}, {x, a4}, {x, a5}]
		hand2 = [{y2, b1}, {y3, b2}, {y4, b3}, {y, b4}, {y, b5}]
		cond do
			x != y -> if x>y, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			a5 != b5 -> if a5>b5, do: hand1, else: hand2
			a5 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
	#Comparing values for non-ties to find winning hand for two pair
	def play([{x, a}, {x, a2}, {x2, a3}, {x3, a4}, {x4, a5}], _), do: [{x, a}, {x, a2}, {x2, a3}, {x3, a4}, {x4, a5}]#PLAYER1 PAIR 2/1/1/1 winner
	def play([{x2, a3}, {x, a}, {x, a2}, {x3, a4}, {x4, a5}], _), do: [{x2, a3}, {x, a}, {x, a2}, {x3, a4}, {x4, a5}]#PLAYER1 PAIR 1/2/1/1 winner
	def play([{x2, a3}, {x3, a4}, {x, a}, {x, a2}, {x4, a5}], _), do: [{x2, a3}, {x3, a4}, {x, a}, {x, a2}, {x4, a5}]#PLAYER1 PAIR 1/1/2/1 winner
	def play([{x2, a3}, {x3, a4}, {x4, a5}, {x, a}, {x, a2}], _), do: [{x2, a3}, {x3, a4}, {x4, a5}, {x, a}, {x, a2}]#PLAYER1 PAIR 1/1/1/2 winner
	def play(_, [{y, a}, {y, b2}, {y2, b3}, {y3, a4}, {y4, a5}]), do: [{y, a}, {y, b2}, {y2, b3}, {y3, a4}, {y4, a5}]#PLAYER2 PAIR 2/1/1/1 winner
	def play(_, [{y2, b3}, {y, a}, {y, b2}, {y3, a4}, {y4, a5}]), do: [{y2, b3}, {y, a}, {y, b2}, {y3, a4}, {y4, a5}]#PLAYER2 PAIR 1/2/1/1 winner
	def play(_, [{y2, b3}, {y3, a4}, {y, a}, {y, b2}, {y4, a5}]), do: [{y2, b3}, {y3, a4}, {y, a}, {y, b2}, {y4, a5}]#PLAYER2 PAIR 1/1/2/1 winner
	def play(_, [{y2, b3}, {y3, a4}, {y4, a5}, {y, a}, {y, b2}]), do: [{y2, b3}, {y3, a4}, {y4, a5}, {y, a}, {y, b2}]#PLAYER2 PAIR 1/1/1/2 winner
	
	#High card tie compare
	def play([{x, a1}, {x2, a2}, {x3, a3}, {x4, a4}, {x5, a5}], [{y, b1}, {y2, b2}, {y3, b3}, {y4, b4}, {y5, b5}]) do #HIGH CARD
		hand1 = [{x, a1}, {x2, a2}, {x3, a3}, {x4, a4}, {x5, a5}]
		hand2 = [{y, b1}, {y2, b2}, {y3, b3}, {y4, b4}, {y5, b5}]
		cond do
			#ace card compare
			(x==1 || y==1) && (x != y) ->
				cond do
					x==1 && y != 1 -> hand1
					y==1 && x != 1 -> hand2
				end
			#checks for the highest ranking card in the hands
			x5 != y5 -> if x5>y5, do: hand1, else: hand2
			x4 != y4 -> if x4>y4, do: hand1, else: hand2
			x3 != y3 -> if x3>y3, do: hand1, else: hand2
			x2 != y2 -> if x2>y2, do: hand1, else: hand2
			x != y -> if x>y, do: hand1, else: hand2
			#if they both have aces we compare suits
			x==1 && y==1 ->
				cond do	
					a1 > b1 -> hand1
					a1 < b1 -> hand2
					a1 == b1 -> [{1," Error Duplicate Cards"}]
				end
			a5 != b5 -> if a5>b5, do: hand1, else: hand2
			a5 == b5 -> [{1," Error Duplicate Cards"}]
		end
	end
end
