package sources.dynamic;

/**
* @author fe1w0
* @date 2023/10/12 15:42
* @Project example
*/

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
