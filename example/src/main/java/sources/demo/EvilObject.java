package sources.demo;

public class EvilObject {
    public void evil(String name) {
        
        // 最方便的方式是，直接 sout + MagicWord
        // System.out.println("FuzzChains@fe1w0");
        
        // 手动插桩，不太好设计
        // 不能通过直接 Throw Exception的方式
        // if (name instanceof Object) {
        //     throw new Exception();
        // }
        System.out.println("Eval");
        System.out.println(name);
    }
}
