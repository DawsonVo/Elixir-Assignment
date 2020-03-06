defmodule Poker do
	def deal(list) do
		playerTwo = Enum.drop_every(list, 2)
		playerOne = list -- playerTwo
		convertTuple = fn
			x when div(x-1, 13) == 0 -> {(rem((x+12), 13)+1), 'C'}
			x when div(x-1, 13) == 1 -> {(rem((x+12), 13)+1), 'D'}
			x when div(x-1, 13) == 2 -> {(rem((x+12), 13)+1), 'H'}
			x when div(x-1, 13) == 3 -> {(rem((x+12), 13)+1), 'S'}
			_ -> :error
		end
		playerOne = Enum.sort(Enum.map(playerOne, convertTuple))
		playerTwo = Enum.sort(Enum.map(playerTwo, convertTuple))
		play(playerOne, playerTwo)
	end
	#Poker.deal([1,2,10,3,11,4,12,5,13,6])

  #ROYAL FLUSH
	def play([{1, a}, {10, a}, {11, a}, {12, a}, {13, a}], [{1, b}, {10, b}, {11, b}, {12, b}, {13, b}]) do #TIE BREAKER RF
		"tie royalflush"
	end
	def play([{1, a}, {10, a}, {11, a}, {12, a}, {13, a}], _) do #PLAYER1 winner RF
		[{1, a}, {10, a}, {11, a}, {12, a}, {13, a}]
	end
	def play(_, [{1, b}, {10, b}, {11, b}, {12, b}, {13, b}]) do #PLAYER2 winner RF
		[{1, b}, {10, b}, {11, b}, {12, b}, {13, b}]
	end
	
  #STRAIGHT FLUSH
	def play([{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}], [{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]) when x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4) and y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4) do #TIE BREAKER SF
		"tie straight flush"
	end
	def play([{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}], _) when x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4) do #PLAYER1 winner SF
		[{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}]
	end
	def play(_, [{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]) when y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4) do #PLAYER2 winner SF
		[{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]
	end

#FULL HOUSE
  def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}], [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]) do #TIE BREAKER FH 3/2 & 3/2
		"tie fullhouse"
	end
  def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}], [{y2, b}, {y2, b2}, {y, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER FH 3/2 & 2/3
		"tie fullhouse"
	end
  def play([{x2, a}, {x2, a2}, {x, a3}, {x, a4}, {x, a5}], [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]) do #TIE BREAKER FH 2/3 & 3/2
		"tie fullhouse"
	end
  def play([{x2, a}, {x2, a2}, {x, a3}, {x, a4}, {x, a5}], [{y2, b}, {y2, b2}, {y, b3}, {y, b4}, {y, b5}]) do #TIE BREAKER FH 2/3 & 2/3
		"tie fullhouse"
	end
	def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}], _) do #PLAYER1 FH 3/2 winner
		[{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}]
	end
  def play([{x2, a}, {x2, a2}, {x, a3}, {x, a4}, {x, a5}], _) do #PLAYER1 FH 3/2 winner
		[{x2, a}, {x2, a2}, {x, a3}, {x, a4}, {x, a5}]
	end
  def play(_, [{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]) do #PLAYER2 FH 3/2 winner
		[{y, b}, {y, b2}, {y, b3}, {y2, b4}, {y2, b5}]
	end
	def play(_, [{y2, b}, {y2, b2}, {y, b3}, {y, b4}, {y, b5}]) do #PLAYER2 FH 2/3 winner
		[{y2, b}, {y2, b2}, {y, b3}, {y, b4}, {y, b5}]
	end


  def play([{x, a}, {x2, a}, {x3, a}, {x4, a}, {x5, a}], [{y, b}, {y2, b}, {y3, b}, {y4, b}, {y5, b}]) do #TIE BREAKER F
		"tie FLUSG"
	end
  def play([{x, a}, {x2, a}, {x3, a}, {x4, a}, {x5, a}], _) do #PLAYER 1 F
		[{x, a}, {x2, a}, {x3, a}, {x4, a}, {x5, a}]
	end
  def play(_, [{y, b}, {y2, b}, {y3, b}, {y4, b}, {y5, b}]) do #PLAYER 2 F
		[{y, b}, {y2, b}, {y3, b}, {y4, b}, {y5, b}]
	end

  def play([{x, a1}, {x1, a2}, {x2, a3}, {x3, a4}, {x4, a5}], [{y, b1}, {y1, b2}, {y2, b3}, {y3, b4}, {y4, b5}]) when x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4) and y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4) do #TIE BREAKER S
		"tie"
	end
	def play([{x, a1}, {x1, a2}, {x2, a3}, {x3, a4}, {x4, a5}], _) when x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4) do #PLAYER1 S
		[{x, a1}, {x1, a2}, {x2, a3}, {x3, a4}, {x4, a5}]
	end
	def play(_, [{y, b1}, {y1, b2}, {y2, b3}, {y3, b4}, {y4, b5}]) when y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4) do #PLAYER2 S
		[{y, b1}, {y1, b2}, {y2, b3}, {y3, b4}, {y4, b5}]
	end

end