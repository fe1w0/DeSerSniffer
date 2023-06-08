package sources;


import java.lang.reflect.InvocationTargetException;

public class Safe {
    
    SafeClass chainOne;
    SafeClass chainTwo;


    public Safe(){
        chainOne = new SafeClass();
        chainTwo = new SafeClass();
    
    public static void main(String[] args) {
        Label source = new Label();
        Safe test = source.source();
        // 触发漏洞
        try {
            test.safe(test.chainOne, test.chainTwo);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void safe(SafeClass safeObjectOne, SafeClass safeObjectTwo) throws ClassNotFoundException, InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
        // 在 chainOne 中 调用了 危险函数
        safeObjectOne.check(safeObjectTwo);
    }
}

class SafeOne extends SafeClass {

    // 该check 是安全的
    public void check(SafeClass safe) throws ClassNotFoundException, InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
        System.out.println("Safe One");
    }
}

class SafeTwo extends SafeClass {
    public void test() throws ClassNotFoundException, NoSuchMethodException, InstantiationException, IllegalAccessException, InvocationTargetException {
        System.out.println("Safe Two");
    }
}


class SafeClass  {

    public void check(SafeClass safe) throws ClassNotFoundException, InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {}

    public void test() throws ClassNotFoundException, NoSuchMethodException, InstantiationException, IllegalAccessException, InvocationTargetException {}
}

