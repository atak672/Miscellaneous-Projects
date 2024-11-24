import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Consumer;
import java.util.function.Supplier;
import java.util.function.BiFunction;
import java.util.stream.Collectors;

public class functionalInterfacesDemo {
    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>();
        numbers.add(1);
        numbers.add(2);
        numbers.add(3);
        numbers.add(4);
        numbers.add(5);

        // Use the map method of the Stream API to implement a custom function
        Function<Integer, Integer> square = x -> x * x;
        List<Integer> squares = numbers.stream().map(square).collect(Collectors.toList());
        System.out.println("Squares of numbers using Stream API and Function: " + squares);

        // Just another example of function composition -- Square root function
        Function<Integer, Double> square_root = Math::sqrt;
        System.out.println("Square root of 64 is " + square_root.apply(64));

        // Use the biFunction interface to implement a custom multiplication function
        BiFunction<Integer, Integer, Integer> multiplier = (x, y) -> x * y;
        System.out.println("Result of adding 4 and 3 is " + multiplier.apply(4, 3));

        // Use the filter method of the Stream API to implement a custom filter
        Predicate<Integer> isEven = x -> x % 2 == 0;
        List<Integer> evenNumbers = numbers.stream().filter(isEven).collect(Collectors.toList());
        System.out.println("Even numbers using Stream API and Predicate: " + evenNumbers);

        // Use the forEach method of the Stream API to implement a custom action
        Consumer<Integer> print = x -> System.out.println(x);
        numbers.forEach(print);

        // Use the get method of the Supplier to generate a value
        Supplier<Integer> randomInt = () -> (int) (Math.random() * 100);
        System.out.println("Random integer generated using Supplier: " + randomInt.get());
    }
}