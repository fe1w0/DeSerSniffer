class Test {

    String name = "TEST";
    // class A {
    //     String name = "A";
    // }

    // class B extends A {
    //     String name = "B";
    // }

    // public boolean judeg(int number) {
    //     return number == 1;
    // }


    public void noEntry() {
        Object test = new Object();
        int testId = 1;
        if (testId == 2) {
            test = new Test("A");
        } else {
            test = new Test("B");
        }
        System.out.println(((Test)test).name);
        calledByEntry();
    }

    public Test(String name){
        this.name = name;
    }

    public Test(){
    }

    public int id(int number) {
        return number;
    }

    public void calledByEntry() {
        System.out.println("called by entry method");
    }

    public void calledByMain() {
        System.out.println("called by main method");
    }

    public static void main(String[] args) {
        Test t = new Test();
        t.calledByMain();
    }
}