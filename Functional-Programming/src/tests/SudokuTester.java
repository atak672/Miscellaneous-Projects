package tests;
import org.junit.jupiter.api.Test;

import java.util.*;
import java.util.Optional;
import java.util.Set;
import sudoku.SudokuSolver;


import static org.junit.jupiter.api.Assertions.*;

public class SudokuTester {
    SudokuSolver solver;

    int[][] board1 = {
            {6, 0, 0, 1, 0, 0, 0, 0, 2},
            {8, 0, 1, 0, 9, 0, 0, 0, 0},
            {0, 7, 5, 0, 8, 4, 0, 0, 0},
            {4, 3, 0, 0, 2, 0, 5, 6, 1},
            {5, 1, 8, 7, 0, 0, 4, 0, 9},
            {0, 9, 6, 4, 1, 0, 3, 0, 0},
            {0, 0, 0, 0, 7, 0, 0, 0, 0},
            {0, 6, 0, 0, 3, 1, 0, 5, 0},
            {7, 0, 2, 5, 4, 0, 6, 0, 3}
    };

    int[][] board2 = {
            {5, 0, 0, 0, 7, 0, 0, 0, 0},
            {6, 0, 0, 1, 9, 5, 0, 0, 0},
            {0, 9, 8, 0, 0, 0, 0, 6, 0},
            {8, 0, 0, 0, 6, 0, 0, 0, 3},
            {4, 0, 0, 8, 0, 3, 0, 0, 1},
            {7, 0, 0, 0, 2, 0, 0, 0, 6},
            {0, 6, 0, 0, 0, 0, 2, 8, 0},
            {0, 0, 0, 4, 1, 9, 0, 0, 5},
            {0, 0, 0, 0, 8, 0, 0, 7, 9}
    };

    int[][] invalidBoard = {
            {6, 6, 0, 1, 0, 0, 0, 0, 2},
            {8, 0, 1, 0, 9, 0, 0, 0, 0},
            {0, 7, 5, 0, 8, 4, 0, 0, 0},
            {4, 3, 0, 0, 2, 0, 5, 6, 1},
            {5, 1, 8, 7, 0, 0, 4, 0, 9},
            {0, 9, 6, 4, 1, 0, 3, 0, 0},
            {0, 0, 0, 0, 7, 0, 0, 0, 0},
            {0, 6, 0, 0, 3, 1, 0, 5, 0},
            {7, 0, 2, 5, 4, 0, 6, 0, 3}
    };




    @Test
    void testNeighbors() {
        SudokuSolver solver = new SudokuSolver(new int[9][9]);
        Set<String> neighbors = solver.neighbors("A1");
        assertEquals(20, neighbors.size());

        assertTrue(neighbors.containsAll(Arrays.asList(
                "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9",
                "B1", "C1", "D1", "E1", "F1", "G1", "H1", "I1",
                "B2", "B3", "C2", "C3"
        )));
    }


    @Test
    void testSolve() {
        SudokuSolver solver = new SudokuSolver(board1);
        assertFalse(solver.solve().isEmpty(), "Puzzle was solved correctly");
    }

    @Test
    void testSolve_2() {
        SudokuSolver solver = new SudokuSolver(board2);
        assertFalse(solver.solve().isEmpty(), "Puzzle was solved correctly");
    }


    @Test
    void testUnsolvableSudoku() {
        int[][] input = {
                {0, 0, 0, 9, 0, 0, 6, 0, 8},
                {0, 0, 0, 7, 0, 0, 0, 0, 5},
                {5, 7, 0, 0, 6, 8, 0, 0, 0},
                {6, 0, 0, 0, 0, 0, 0, 8, 0},
                {4, 0, 0, 8, 0, 7, 0, 0, 2},
                {0, 9, 0, 0, 0, 0, 0, 0, 4},
                {0, 0, 0, 2, 9, 0, 0, 1, 7},
                {1, 0, 0, 0, 0, 6, 0, 0, 0},
                {2, 0, 7, 0, 0, 1, 0, 0, 0}
        };
        SudokuSolver solver = new SudokuSolver(input);
        Optional<int[][]> isSolvable = solver.solve();
        assertTrue(isSolvable.isEmpty(), "Expected the Sudoku puzzle to be unsolvable");
    }
}
