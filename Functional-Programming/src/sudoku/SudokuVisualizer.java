package sudoku;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.InputMismatchException;
import java.util.Scanner;

public class SudokuVisualizer extends JFrame {

    private static final int BOARD_SIZE = 9;
    private static final int BOX_SIZE = 3;

    private final JTextField[][] cells;
    private JButton solveButton;

    private final SudokuSolver solver;

    public SudokuVisualizer(int[][] board) {
        super("Sudoku Solver");

        // Initialize the solver
        solver = new SudokuSolver(board);

        // Set up the main window
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setResizable(false);
        setLayout(new BorderLayout());

        // Create the grid of cells
        cells = new JTextField[BOARD_SIZE][BOARD_SIZE];
        JPanel gridPanel = new JPanel();
        gridPanel.setLayout(new GridLayout(BOARD_SIZE, BOARD_SIZE));
        gridPanel.setBorder(BorderFactory.createLineBorder(Color.BLACK));
        Font font = new Font("Arial", Font.PLAIN, 24); // make the font larger
        for (int i = 0; i < BOARD_SIZE; i++) {
            for (int j = 0; j < BOARD_SIZE; j++) {
                JTextField cell = new JTextField();
                cell.setFont(font);
                cell.setHorizontalAlignment(JTextField.CENTER);
                cell.setPreferredSize(new Dimension(60, 60)); // make each cell 60x60 pixels
                cell.setText(board[i][j] == 0 ? "" : String.valueOf(board[i][j]));
                if ((i / BOX_SIZE) % 2 == (j / BOX_SIZE) % 2) { // alternate background color for each square
                    cell.setBackground(new Color(255, 255, 204));
                } else {
                    cell.setBackground(new Color(255, 255, 255));
                }
                cells[i][j] = cell;
                gridPanel.add(cell);
            }
        }
        add(gridPanel, BorderLayout.CENTER);

        // Create the "Solve" button
        solveButton = new JButton("Solve");
        solveButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                //System.out.println("Solve button clicked");
                // Solve the board
                solver.solve().ifPresent(solution -> {
                    // Update the UI with the solution
                    for (int i = 0; i < BOARD_SIZE; i++) {
                        for (int j = 0; j < BOARD_SIZE; j++) {
                            cells[i][j].setText(String.valueOf(solution[i][j]));
                        }
                    }
                });
            }
        });
        JPanel buttonPanel = new JPanel();
        buttonPanel.setLayout(new FlowLayout());
        buttonPanel.add(solveButton);
        add(buttonPanel, BorderLayout.SOUTH);

        // Pack the window and center it on the screen
        pack();
        setLocationRelativeTo(null);
    }

    public static void main(String[] args) {
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

        int[][] board3 = {
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

        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter the number of the Sudoku board to display (1, 2, or 3):");
        int boardNum;
        try {
            boardNum = scanner.nextInt();
        } catch (InputMismatchException e) {
            System.out.println("Invalid input. Please enter an integer value.");
            scanner.close();
            return; // terminate the program if input is invalid
        }
        scanner.close();


        int[][] board_play;
        switch (boardNum) {
            case 1 -> board_play = board1;
            case 2 -> board_play = board2;
            case 3 -> board_play = board3;
            default -> {
                System.out.println("Invalid input.");
                return;
            }
        }


        SudokuVisualizer visualizer = new SudokuVisualizer(board_play);
        visualizer.setVisible(true);
    }
}
