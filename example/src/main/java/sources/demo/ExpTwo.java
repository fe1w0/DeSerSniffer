package sources.demo;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import sources.dynamic.Reflect;


public class ExpTwo extends SafeTwo {
    public int size = 100;
    @Override
    public void test(String name) throws ClassNotFoundException, NoSuchMethodException, InstantiationException, IllegalAccessException, InvocationTargetException {
        // this 应当 也是 taint source
        System.out.println("Chain Two");

        // EvilObject evil = new EvilObject();
        // evil.evil(this.name);
        
        if (size == 40) {
            // 添加 反射特征测试 
            Class reflectClass = Class.forName("sources.dynamic.Reflect");
            Method reflectMethod = reflectClass.getMethod("handleMethod", String.class);
            // instance
            Reflect reflectInstance = (Reflect) reflectClass.newInstance();
            reflectMethod.invoke(reflectInstance, name);
        }
    }
}