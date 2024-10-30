package tests;

import org.junit.Test;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.BiFunction;
import java.util.stream.Collectors;

import static org.junit.Assert.*;

public class functionalInterfacesDemoTest {
    @Test
    public void testSquareFunction() {
        List<Integer> numbers = new ArrayList<>();
        numbers.add(1);
        numbers.add(2);
        numbers.add(3);
        numbers.add(4);
        numbers.add(5);

        Function<Integer, Integer> square = x -> x * x;
        List<Integer> squares = numbers.stream().map(square).collect(Collectors.toList());
        List<Integer> expectedSquares = new ArrayList<>(List.of(1, 4, 9, 16, 25));
        assertEquals(expectedSquares, squares);
    }

    @Test
    public void testMultiplierBiFunction() {
        BiFunction<Integer, Integer, Integer> multiplier = (x, y) -> x * y;
        int result = multiplier.apply(4, 3);
        assertEquals(12, result);
    }

    @Test
    public void testIsEvenPredicate() {
        List<Integer> numbers = new ArrayList<>();
        numbers.add(1);
        numbers.add(2);
        numbers.add(3);
        numbers.add(4);
        numbers.add(5);

        Predicate<Integer> isEven = x -> x % 2 == 0;
        List<Integer> evenNumbers = numbers.stream().filter(isEven).collect(Collectors.toList());
        List<Integer> expectedEvenNumbers = new ArrayList<>(List.of(2, 4));
        assertEquals(expectedEvenNumbers, evenNumbers);
    }
}