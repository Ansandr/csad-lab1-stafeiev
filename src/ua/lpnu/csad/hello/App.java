package ua.lpnu.csad.hello;

/** Minimal cross-platform Hello World application. */
public final class App {
    private App() { }

    /** Returns the sum of two integers (unit-tested by BasicAddition). */
    public static int add(int a, int b) {
        return a + b;
    }

    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
