package ua.lpnu.csad.hello;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class BasicAdditionTest {
    @Test
    void addsTwoNumbers() {
        assertEquals(4, App.add(2, 2));
    }

    @Test
    void handlesNegativeNumbers() {
        assertEquals(-5, App.add(-2, -3));
    }

    @Test
    void handlesZero() {
        assertEquals(7, App.add(7, 0));
    }
}
