import java.io.ObjectOutputStream;
import java.lang.reflect.Method;

public class EntryPoints {
    public void defineEntryPoints() throws Exception{
        // 设置 first node in call graph
        Object object = new Object();
        Method method = ObjectOutputStream.class.getDeclaredMethod("readObject");
        Object rObject = method.invoke(object);
    }
}
