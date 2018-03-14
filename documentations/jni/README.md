# Android Studio JNI Integration
Since Android Studio supports `c`/`c++` Native Development Kit (NDK), feza is
also positioning itself to support its feature. The purpose is to make feza as
an ideal separation between Android developers and C developers.

## Test
| Name           | Status           |
|:---------------|:-----------------|
| Android Studio | [![studio](https://img.shields.io/badge/version-3.0.1-brightgreen.svg?style=flat)]() |
| CMake          | [![cmake](https://img.shields.io/badge/version-3.4.1-brightgreen.svg?style=flat)]() |
| Supported      | [![languages](https://img.shields.io/badge/language-c%2C%20java-brightgreen.svg?style=flat)]() |
| Not Supported  | [![non-language](https://img.shields.io/badge/language-kotlin-e53935.svg?style=flat)]() |

## JNI Shim Layer
JNI shim layer is essentials for performing the separations. The one golden
rule is that all the `.c` source codes inside `libs` folder should remain as it
is. The conventional feza `make` method builds the package using the `main.c`
while JNI Shim uses its `CMakeList.txt` to perform its build inside the studio.

As a good practice, the shim layer serves as the intepreter between `c` and
`java` library. Hence, there's a java code to interface with the NDK (instead
of directly interface with the `c` codes itself.

## How it Works
On the Java side with Android Studio, you develop the `jni/fezajni/feza.java`
API for your consumption. Then, on the `c` sides, you develop the
`jni/fezajni.c` intepreter for the C folks to call in. Since the `C` folks
won't understand the JNI as the JAVA developer, it's best to indicate the
JNI return value example inside this file.

On the C side, based on the `jni/fezajni.c`, you develop the library files
inside the `libs` folder as per usual. Then, have the function called within
the `fezajni.c` file to meet the java API requirements.

Keep in mind that both `CMakeList.txt` and `Makefile` will use **ALL** `.c`
files inside the `libs` folder. Hence, do remember to clean up the unused codes.

> NOTE to `c` developer:
>
> Unlike application on the laptop (mostly `x86` processor architectures),
> keep the library development friendly to `arm` processor architectures as
> well. HINT: cross-compile.

## How to Integrate into Android Studio
It is recommended to set your `feza` repository inside the `src/main/java`
folder. You can navigate into the project folder directly and perform the
usual `git clone` step.

Then, once the folder appears in the Android Studio, right click the
`jni/CMakeLists.txt` and link into the Studio's C++ Gradle. It will prompt
for adding the `jni/CMakeLists.txt` path again, make sure you point to it
correctly. The official [guide](https://developer.android.com/studio/projects/gradle-external-native-builds.html)
has graphical guides sufficient for the integration.

> NOTE:
>
> The `CMakeLists.txt` contains pre-configured settings based on the Android
> Studio default project. If you're developing Android application per se,
> you shouldn't encounter the needs for manual configurations.
>
> Otherwise, consult the official document.

## To Use
The existing shim layer has a default String function. Make a TextView on
the Activity to display the data. An example would be:
```java
package com.example.name.helloworldndk;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import fezajni.shim.feza;

public class LoginActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView textView = new TextView(this);
        textView.setText(feza.hello());
        setContentView(textView);
    }
}
```
You should see the textView displaying the data created by the `fezajni.c`
shim layer, which is `Hello World from C`. Happy coding!

## References
1. https://developer.android.com/studio/projects/gradle-external-native-builds.html
2. https://medium.com/@jrejaud/modern-android-ndk-tutorial-630bc11829a2
3. https://code.tutsplus.com/tutorials/advanced-android-getting-started-with-the-ndk--mobile-2152
