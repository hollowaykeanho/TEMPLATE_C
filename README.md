[![language](https://img.shields.io/badge/core--language-c-blue.svg?style=for-the-badge)
]()

# CWR (C Workspace Reference)
CWR is a C workspace reference designed for Linux-based operating system
development,focus on being friendly to terminal based editors. The reference
repository is meant for learning and toolkit development for an acceptable file
structure and replacing redundant tools (e.g. `make`, `Makefile`)

This repository is retained for https://monteur.zoralab.com development to
support C projects natively.

This project was previously named  `Fezā`, as in 'feather' in Japanese. Since
ZORALab has limited support, the project shall be re-licensed and owned by the
author myself.




## Usage
While the project was not meant for production development, if you have any
reason for it, feel free to execute the following:

1. Fork this project.
2. Update the README.md and LICENSE.md to match your project.

## Commands
### 1. `make all`
Build all the `.c` files in the `libs` folders and link them with the `main.o`
file. The generated binary is located inside `bin` folder.

> NOTE:
>
> Any files outside the `libs` folder is not included inside the Makefile.
> The idea is to keep the repository clean by having all `.c` and its artifacts
> files inside the `libs` directory while having only `main.c` at the root
> layer.
>
> If you disagree, please feel free to modify the Makefile accordingly.


### 2. `make clean`
Clean up the workspace from all the compiled files, such as `.d`, `.o`, `.hex`,
`.elf`, and `.bin` files.


### 3. `make test`
Run static analysis upon all the selected `.c` files using the flawfinder,
the open-source static analyzer for C written in the `test` folder using
[BaSHELL](https://gitlab.com/ZORALab/BaSHELL).




## Others
1. Android Studio NDK Integration - https://gitlab.com/ZORALab/feza/blob/master/documentations/jni/README.md




## License
This reference project is licensed under [MIT License](LICENSE).
