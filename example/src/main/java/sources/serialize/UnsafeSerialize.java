package sources.serialize;

/**
 * @author fe1w0
 * @date 2023/10/12 15:41
 * @Project example
 */

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.Arrays;

import sources.demo.Safe;
import sources.demo.SafeClass;

public class UnsafeSerialize implements Serializable {

    String name = "UnsafeSerialize";

    SafeClass chainOne = new SafeClass();
    SafeClass chainTwo = new SafeClass();

    // 添加自定义 readObject
    // 反序列化 触发 demo.Safe class

    private void writeObject(ObjectOutputStream objectOutputStream) throws IOException {
        objectOutputStream.defaultWriteObject();
        System.out.println("Serializing...");
    }


    // 我们测试的目标
    private void readObject(ObjectInputStream objectInputStream) throws Exception {
        objectInputStream.defaultReadObject();
        System.out.println("Deserializing...");
        // System.out.println(name);

        Safe safe = new Safe();
        safe.safe(chainOne, chainTwo);
    }

    public static Object getObjectFromSerialize(ObjectInputStream in) throws Exception {
        return in.readObject();
    }

    public static void main(String[] args) throws Exception {
        UnsafeSerialize e = new UnsafeSerialize();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ObjectOutputStream oos = new ObjectOutputStream(baos);
        e.name = "new sample";

        // e.chainOne = new ExpOne();
        // e.chainTwo = new ExpTwo();

        oos.writeObject(e);

        oos.flush();
        oos.close();

        System.out.println("序列化: " + Arrays.toString(baos.toByteArray()));

        ByteArrayInputStream bais = new ByteArrayInputStream(baos.toByteArray());
        ObjectInputStream in = new ObjectInputStream(bais);

        UnsafeSerialize test = (UnsafeSerialize) in.readObject();

        // UnsafeSerialize ttt = (UnsafeSerialize) getObjectFromSerizlize(in);

        // 需要查看，在此过程中，
        // test 中的 chainOne, chainTwo 是否被污点传播
        System.out.println(test.toString());
        in.close();
    }

}
