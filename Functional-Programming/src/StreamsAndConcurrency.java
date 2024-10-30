import java.util.List;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;


public class StreamsAndConcurrency {

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        // Infinite Streams -- Lazy Evaluation
        // Create an infinite stream of integers starting from 1
        Stream<Integer> integerStream = Stream.iterate(1, n -> n + 1);

        // Example of finite stream using Stream.iterate
        Stream<Integer> finiteStream = Stream.iterate(0, n -> n < 10, n -> n + 1);
        finiteStream.forEach(System.out::println);

        // Generate an infinite stream of hexagonal numbers
        Stream<Integer> hexagonalStream = integerStream.map(n -> n * (2 * n - 1));

        // Print the first 10 hexagonal numbers or Integer numbers
        //integerStream.limit(10).forEach(System.out::println);
        hexagonalStream.limit(10).forEach(System.out::println);

        // Concat two streams together (also works for infinite streams)
        Stream<Integer> stream_1 = Stream.of(1, 2, 3);
        Stream<Integer> stream_2 = Stream.of(4, 5, 6);
        Stream<Integer> concatenatedStream = Stream.concat(stream_1, stream_2);
        concatenatedStream.forEach(System.out::println);

        // Created my own multiplication method for multiplying two streams

        @FunctionalInterface
        interface StreamMultiplier {
            Stream<Integer> multiply(Stream<Integer> stream1, Stream<Integer> stream2);
        }

        StreamMultiplier multiplier = (stream1, stream2) -> {
            List<Integer> list1 = stream1.collect(Collectors.toList());
            List<Integer> list2 = stream2.collect(Collectors.toList());
            return IntStream.range(0, Integer.MAX_VALUE)
                    .mapToObj(i -> new int[]{i, i})
                    .flatMap(pair -> list1.stream().skip(pair[0]).limit(1).map(n1 -> list2.get(pair[1]) * n1))
                    .limit(Math.min(list1.size(), list2.size()));
        };

        Stream<Integer> stream_mul_1 = Stream.of(1, 2, 3, 4, 5);
        Stream<Integer> stream_mul_2 = Stream.of(2, 4, 6, 8, 10);
        Stream<Integer> productStream = multiplier.multiply(stream_mul_1, stream_mul_2);
        productStream.forEach(System.out::println);


        //Concurrency API with Functional Programming in Java
        CompletableFuture<Integer> future = CompletableFuture
                .supplyAsync(() -> IntStream.rangeClosed(1, 10).parallel().sum())
                .thenApply(sum -> sum * 2)
                .thenApply(sum -> sum / 3);
        int result = future.get();
        System.out.println("Total result " + result);

        // Example Two
        int numThreads = 4;
        int numTasks = 8;
        ExecutorService executor = Executors.newFixedThreadPool(numThreads);

        for (int i = 0; i < numTasks; i++) {
            int taskId = i;
            executor.submit(() -> performTask(taskId));
        }

        executor.shutdown();
    }

    private static void performTask(int taskId){
        System.out.println("Task " + taskId + " started in thread " + Thread.currentThread().getName());
        try {
            Thread.sleep(1000); // Simulate processing time
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("Task " + taskId + " completed in thread " + Thread.currentThread().getName());
    }

}
