class Board
  def initialize
    @grid = Array.new(8){[]}
    @queen_count = 0
    @safe_count = 0
  end

  def place_queen
    @grid.each_with_index do |line, row|
      line.each_with_index do |item, col|
        if safe?(row, col)
          # p "safe"
          @grid[row][col] = "Q"
          @queen_count += 1
          if @queen_count >= 8
            # p "safe"
            @safe_count += 1
          else
            place_queen
          end
          @queen_count -= 1
          @grid[row][col] = "X"
        else
          p "unsafe"
          p @safe_count
        end
      end
      @safe_count
    end
  end

  def safe?(row, col)
    return false if @grid[row].count("Q") > 1
    return false if @grid.transpose[col].count("Q") > 1
    # return false if diag.count("Q") > 1
    true
  end

  def


  def create_grid
    @grid.each do |row|
      8.times {row << "x"}
    end
  end


  def disp_grid
    @grid.each do |row|
      row.each { |el| print "#{el} " }
      puts
    end
    nil
  end
end
