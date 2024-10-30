import java.util.*;
import java.util.function.Function;
import java.util.function.Supplier;

public class GeneralFunctionalDemo {
    public static void main(String[] args) {
        Integer[] numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        List<Integer> numbers_2 = new ArrayList<>(Arrays.asList(numbers));

        //Topic I: Conciseness, Mutability, Pure Functions, First-Class Citizen Functions

            // Imperative approach to sum all even numbers within list numbers
            int sumOfEvenNumbers = 0;
            for (Integer number : numbers) {
                if (number % 2 == 0) {
                    sumOfEvenNumbers += number;
                }
            }
            System.out.println("Sum of even numbers: " + sumOfEvenNumbers);

            // Conciseness and readability improvements as well as limited mutability
            // Functional approach -- Same result, less verbose, more declarative of intent
            int sumOfEvenNumbers_2 = Arrays.stream(numbers)
                                    .filter(n -> n % 2 == 0)
                                    .mapToInt(Integer::intValue)
                                    .sum();
            System.out.println("Sum of even numbers: " + sumOfEvenNumbers_2);


            // Example 2 -- Imperative sorting of list numbers_2 via a customized comparator
            numbers_2.sort(new Comparator<Integer>() {
                @Override
                public int compare(Integer n1, Integer n2) {
                    return n1.compareTo(n2);
                }
            });
             System.out.println("Sorted Integers List: " + numbers_2);


            //Functional programming approach -- much more concise and readable
            numbers_2.sort(Integer::compareTo);
            System.out.println("Sorted Integers List: " + numbers_2);

            //Comment on pure functions: By using pure functions like filter() and reduce(), we're able to write code
            // that is composable, modular, and easier to reason about and maintain.
            // Pure functions always produces the same output given the same input -- help build more complex functions


        //Topic II: Referential Transparency, Optional/Monads, & Currying

            // Referential transparency is a fundamental concept in functional programming that promotes the use of pure
            // functions that only depend on their inputs to produce outputs. Here is another example of a referentially
            // transparent function in Java
                @SuppressWarnings("unused")
                Function<Integer, Integer> prod = x -> x * x;
                // Could replace with an equal sign essentially due to no side effects
                // i.e. for x = 2; ret = prod.apply(2) can be essentially replaced with ret = 4

            // Not Referentially transparent bc each input is different in its result
                @SuppressWarnings("unused")
                Supplier<Integer> randomInt = () -> (int) (Math.random() * 100);


            // Optional/Monads: Abstractions that allow structuring programs generically. Can safely process null values
            // Protects against null pointer exceptions for 'absent' values -- 'wraps' value
            // .of() helps readability -- ensures value will not be null and catches it if it is (first example)
            // .ofNullable() -- value can be null, allows capturing null value and dealing with it without error
            // Use depending on program logic--use the former if you believe value != null ever
            // stream class is also known as a Monad bc it allows processing in a series of transformations
            // Monad is a way to transform data to enable a series of steps/computations
                Optional<String> optionalValue = Optional.of("Hello World");

                String value = optionalValue
                        .map(String::toUpperCase)
                        .orElse("No value found");

                System.out.println(value); // Output: HELLO WORLD

                //Example with Nullable
                value = null;
                Optional<String> optionalValue_2 = Optional.ofNullable(value);

                String value_2 = optionalValue_2
                        .map(String::toUpperCase)
                        .orElse("No value found");

                System.out.println(value_2); // Output: No value found


            // Currying:functional programming technique that allows us to create new functions from existing ones by
            // partially applying arguments. I.e. functions can return functions
                Function<Integer, Function<Integer, Integer>> curriedMultiply = x -> y -> x * y;
                int result = curriedMultiply.apply(2).apply(3);
                System.out.println(result);     // Output: 6


                //Weight calculations based on planet's gravity -- Another currying example
                Function<Double, Function<Double, Double>> weight = mass -> gravity -> mass * gravity;
                Function<Double, Double> weightOnEarth = weight.apply(9.81);
                System.out.println("My weight on Earth: " + weightOnEarth.apply(60.0));
                Function<Double, Double> weightOnMars = weight.apply(3.75);
                System.out.println("My weight on Mars: " + weightOnMars.apply(60.0));

            System.out.println("1! = " + factorial(1));
            System.out.println("3! = " + factorial(3));
            System.out.println("5! = " + factorial(5));

            System.out.println("1! = " + factorial_2(1, 1));
            System.out.println("3! = " + factorial_2(3, 1));
            System.out.println("5! = " + factorial_2(5, 5));
    }



    // Topic III: Recursion
        static Integer factorial(Integer number) {
            return (number <= 1) ? 1 : number * factorial(number - 1);
        }

        // Tail Recursion
        static Integer factorial_2(Integer number, Integer result) {
            return (number == 1) ? result : factorial_2(number - 1, result * number);
        }

}



