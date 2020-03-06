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
	def play([{1, a}, {10, a}, {11, a}, {12, a}, {13, a}], [{1, b}, {10, b}, {11, b}, {12, b}, {13, b}]) do #TIE BREAKER
		"tie"
	end
	def play([{1, a}, {10, a}, {11, a}, {12, a}, {13, a}], _) do #PLAYER1 RF
		[{1, a}, {10, a}, {11, a}, {12, a}, {13, a}]
	end
	def play(_, [{1, b}, {10, b}, {11, b}, {12, b}, {13, b}]) do #PLAYER2 RF
		[{1, b}, {10, b}, {11, b}, {12, b}, {13, b}]
	end
		
	def play([{x, a}, {(x1), a}, {(x2), a}, {(x3), a}, {(x4), a}], [{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]) when x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4) and y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4) do #TIE BREAKER
		"tie"
	end
	def play([{x, a}, {(x1), a}, {(x2), a}, {(x3), a}, {(x4), a}], _) when x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4) do #PLAYER1 SF
		[{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}]
	end
	def play(_, [{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]) when y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4) do #PLAYER2 SF
		[{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]
	end

  def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}], [{y, b}, {y, b1}, {y, b2}, {y2, b3}, {y2, b4}]) do #TIE BREAKER FH 3/2 & 3/2
		"tie"
	end
  def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}], [{y2, b}, {y2, b1}, {y, b2}, {y, b3}, {y, b4}]) do #TIE BREAKER FH 3/2 & 2/3
		"tie"
	end
  def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}], [{y, b}, {y, b1}, {y, b2}, {y2, b3}, {y2, b4}]) do #TIE BREAKER FH 2/3
		"tie"
	end
  def play([{x, a}, {x, a2}, {x, a3}, {x2, a4}, {x2, a5}], [{y, b}, {y, b1}, {y, b2}, {y2, b3}, {y2, b4}]) do #TIE BREAKER FH
		"tie"
	end
	def play([{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}], _) when x==(x1-1) and x==(x2-2) and x==(x3-3) and x==(x4-4) do #PLAYER1 SF
		[{x, a}, {x1, a}, {x2, a}, {x3, a}, {x4, a}]
	end
	def play(_, [{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]) when y==(y1-1) and y==(y2-2) and y==(y3-3) and y==(y4-4) do #PLAYER2 SF
		[{y, b}, {y1, b}, {y2, b}, {y3, b}, {y4, b}]
	end

end