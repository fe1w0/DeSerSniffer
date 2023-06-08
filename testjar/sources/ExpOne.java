package sources;

import sources.dynamic.Reflect;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class ExpOne extends SafeOne  {

    SafeClass chainTwo;

    @Override
    public void check(SafeClass safeTwo) throws ClassNotFoundException, InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
        System.out.println("Chain One");
        chainTwo = safeTwo;
        chainTwo.test();
    }
}

class ExpTwo extends SafeTwo {
    @Override
    public void test() throws ClassNotFoundException, NoSuchMethodException, InstantiationException, IllegalAccessException, InvocationTargetException {
        // this 应当 也是 taint source
        System.out.println("Chain Two");

        EvilObject evil = new EvilObject();
        evil.evil();

        // 添加 反射特征测试
        Class reflectClass = Class.forName("sources.dynamic.Reflect");
        Method reflectMethod = reflectClass.getMethod("handleMethod");
        // instance
        Reflect reflectInstance = (Reflect) reflectClass.newInstance();
        reflectMethod.invoke(reflectInstance);
    }
}