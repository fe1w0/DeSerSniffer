package sources;

public class ExpOne extends SafeOne  {
    
    SafeClass chainTwo;

    @Override
    public void check(SafeClass safeTwo) {
        System.out.println("Chain One");
        chainTwo = safeTwo;
        chainTwo.test();
    }
}

class ExpTwo extends SafeTwo {
    @Override
    public void test() {
        // this 应当 也是 taint source
        System.out.println("Chain Two");

        EvilObject evil = new EvilObject();
        evil.evil();
    }
}