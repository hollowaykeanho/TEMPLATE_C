package fezajni.shim;

public class feza {
    static {
        System.loadLibrary("fezajni");
    }

    public static native String hello();
}