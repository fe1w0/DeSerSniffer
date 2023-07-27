package sources.demo;

import sources.dynamic.Reflect;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class ExpOne extends SafeOne  {

    SafeClass chainTwo;

    @Override
    public void check(SafeClass safeTwo) throws ClassNotFoundException, InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
        System.out.println("Chain One");
        chainTwo = safeTwo;
        chainTwo.test(chainTwo.name);
    }
}

