package sources;


public class Safe {
    
    SafeClass chainOne;
    SafeClass chainTwo;


    public Safe(){
        chainOne = new SafeClass();
        chainTwo = new SafeClass();
    }

    public static void main(String[] args) {
        Label source = new Label();
        Safe test = source.source();
        // 触发漏洞
        test.safe(test.chainOne, test.chainTwo);
    }

    public void safe(SafeClass safeObjectOne, SafeClass safeObjectTwo) {
        // 在 chainOne 中 调用了 危险函数
        safeObjectOne.check(safeObjectTwo);
    }
}

class SafeClass  {

    public void check(SafeClass safe) {}

    public void test() {}
}

class SafeOne extends SafeClass {

    // 该check 是安全的
    public void check(SafeClass safe) {
        System.out.println("Safe One");
    }
}

class SafeTwo extends SafeClass {
    public void test() {
        System.out.println("Safe Two");
    }
}

