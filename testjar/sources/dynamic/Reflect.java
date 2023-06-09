package sources.dynamic;

import sources.demo.EvilObject;

public class Reflect {

    String reflectString;

    public void handleMethod(String code) {
        exec(code);
    }

    public void exec(String code) {
        EvilObject evilObject = new EvilObject();
        evilObject.evil(code);
    }

}
