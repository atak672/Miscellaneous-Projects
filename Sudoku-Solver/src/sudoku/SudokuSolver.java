package sudoku;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class SudokuSolver {
    private static final int BOARD_SIZE = 9;
    private static final int BOX_SIZE = 3;
    private final Map<String, Set<Integer>> board;

    public SudokuSolver(int[][] initialBoard) {
        board = new HashMap<>();
        for (int row = 0; row < BOARD_SIZE; row++) {
            for (int col = 0; col < BOARD_SIZE; col++) {
                String cell = cellName(row, col);
                if (initialBoard[row][col] == 0) {
                    board.put(cell, IntStream.rangeClosed(1, 9).boxed().collect(Collectors.toSet()));
                } else {
                    board.put(cell, new HashSet<>(Set.of(initialBoard[row][col])));
                }
            }
        }
        propagateConstraints();
    }

    public Optional<int[][]> solve() {
        Optional<Map<String, Set<Integer>>> solution = search();
        return solution.map(this::convertBoard);
    }


    private Optional<Map<String, Set<Integer>>> search() {
        if (board.values().stream().allMatch(values -> values.size() == 1)) {
            return Optional.of(board);
        }

        String cell = board.keySet().stream()
                .filter(c -> board.get(c).size() > 1)
                .min(Comparator.comparingInt(a -> board.get(a).size()))
                .orElseThrow();

        boolean isSolvable = false; // Move the declaration here
        for (int num : new ArrayList<>(board.get(cell))) {
            SudokuSolver newSolver = new SudokuSolver(board);
            newSolver.board.get(cell).retainAll(Set.of(num));
            if (newSolver.propagateConstraints()) {
                Optional<Map<String, Set<Integer>>> solvedBoard = newSolver.search();
                if (solvedBoard.isPresent()) {
                    isSolvable = true; // Set it to true when a solution is found
                    return solvedBoard;
                }
            }
        }
        if (!isSolvable) { // Check the flag after the loop
            System.out.println("Board is unsolvable");
        }
        return Optional.empty();
    }

    private boolean propagateConstraints() {
        boolean progress;
        //System.out.println("Propagate Begin");
        do {
            progress = false;
            for (int row = 0; row < BOARD_SIZE; row++) {
                for (int col = 0; col < BOARD_SIZE; col++) {
                    String cell = cellName(row, col);
                    Set<Integer> values = board.get(cell);
                    if (values.size() == 1) {
                        int value = values.iterator().next();
                        progress |= eliminateFromNeighbors(cell, value);
                    } else {
                        //System.out.println("processing cell " + cell + ", possible values: " + values);
                        for (String neighbor : neighbors(cell)) {
                            Set<Integer> neighborValues = board.get(neighbor);
                            if (neighborValues.size() == 1) {
                                if (values.removeAll(neighborValues)) {
                                    progress = true;
                                    //System.out.println("eliminated values " + neighborValues + " from cell " + cell);
                                }
                            }
                        }
                    }
                }
            }
        } while (progress);
        return board.values().stream().allMatch(values -> values.size() == 1);
    }

    private boolean eliminateFromNeighbors(String cell, int value) {
        boolean progress = false;
        for (String neighbor : neighbors(cell)) {
            progress |= board.get(neighbor).remove(value);
        }
        return progress;
    }

    public Set<String> neighbors(String cell) {
        int row = cell.charAt(1) - '1';
        int col = cell.charAt(0) - 'A';
        int blockRow = row / BOX_SIZE;
        int blockCol = col / BOX_SIZE;

        Set<String> neighbors = IntStream.range(0, BOARD_SIZE)
                .boxed()
                .flatMap(r -> IntStream.range(0, BOARD_SIZE).mapToObj(c -> cellName(r, c)))
                .filter(c -> {
                    int r = c.charAt(1) - '1';
                    int cc = c.charAt(0) - 'A';
                    int br = r / BOX_SIZE;
                    int bc = cc / BOX_SIZE;
                    return (r == row || cc == col || (br == blockRow && bc == blockCol)) && !c.equals(cell);
                })
                .collect(Collectors.toSet());

        return neighbors;
    }




    private String cellName(int row, int col) {
        return (char) ('A' + col) + Integer.toString(row + 1);
    }

    private int[][] convertBoard(Map<String, Set<Integer>> board) {
        int[][] result = new int[BOARD_SIZE][BOARD_SIZE];
        for (int row = 0; row < BOARD_SIZE; row++) {
            for (int col = 0; col < BOARD_SIZE; col++) {
                String cell = cellName(row, col);
                result[row][col] = board.get(cell).iterator().next();
            }
        }
        return result;
    }

    // Constructor for copying the current state of the solver
    private SudokuSolver(Map<String, Set<Integer>> currentBoard) {
        board = new HashMap<>();
        for (String cell : currentBoard.keySet()) {
            board.put(cell, new HashSet<>(currentBoard.get(cell)));
        }
    }
}