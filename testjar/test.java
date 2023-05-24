class Test {

    String name = "TEST";

    // class O {

    // }

    // class A extends O {
    //     String name = "A";

    //     @Override
    //     public int hashCode() {
    //         System.out.println("hashCode: " + this.name);
    //         return name.hashCode();
    //     }

    //     @Override
    //     public String toString() {
    //         return this.name;
    //     }
    // }

    // class B extends A {
    //     String name = "B";

    //     @Override
    //     public int hashCode() {
    //         System.out.println("hashCode: " + this.name);
    //         return name.hashCode();
    //     }

    // }


    // public void noEntry() {
    //     Object test = new Object();
    //     int testId = 1;
    //     if (testId == 2) {
    //         test = new Test("A");
    //     } else {
    //         test = new Test("B");
    //     }
    //     System.out.println(((Test)test).name);
    //     calledByEntry();

    //     // test Transform
    //     String name = test.toString();
    // }

    // public Test(String name){
    //     this.name = name;
    // }

    // public Test(){
    // }

    // public int id(int number) {
    //     return number;
    // }

    // public void calledByEntry() {
    //     O o = new A();
    //     // 测试 思路
    //     o.hashCode();
    //     System.out.println("called by entry method");
    // }

    public void calledByMain() {
        System.out.println("called by main method");
    }

    public static void main(String[] args) {
        Test t = new Test();
        t.calledByMain();
        // t.noEntry();

        // source
        int sourceId = Taint.source();

        // Transform
        String strId = t.entry(sourceId);

        // Sink
        Taint testTaint = new Taint();
        testTaint.maybeEvil(strId);
    }

    public String entry(int str) {
        String idStr = Taint.tranform(str);
        return idStr;
    }

}


class Taint {

    String name = "Taint";

    public static int source(){
        return 1;
    }

    public static String tranform(int id){
        if (id == 1){
            return "One";
        } else {
            return "Two";
        }
    }

    public void maybeEvil(String str){
        name = "Evil";
        System.out.println("Evil" + str);
    }
}
