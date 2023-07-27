package sources.demo;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;

public class SafeClass implements Serializable {

    String name;
    
    public void check(SafeClass safe) throws ClassNotFoundException, InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {}

    public void test(String name) throws ClassNotFoundException, NoSuchMethodException, InstantiationException, IllegalAccessException, InvocationTargetException {}
}


