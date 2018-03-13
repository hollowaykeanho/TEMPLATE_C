[![language](https://img.shields.io/badge/core--language-c-blue.svg?style=flat)
]()

[![banner](https://lh3.googleusercontent.com/fhdLGNIPhbSh-h6q9Ztp-XbZkB9dQVjcCV0G3Ln8gmXN0yIc-K7QqExKmNBLYfLoZkHcdyPsUondIXEyiTb8825UUi2ORX8aff5Zn0kUafmcU3ljiZNGBm_WAxmnU-A6bDMe8hsM7PJRZqSBa6if-9Aogfvo-A3BvPvOPCTGVVPqYdt5qa09SWDxgc8xkDCPaODShQsGvd8s4Troi67EQ4nBgH_ficZ02ovlMkl0gZsIwXHUV7kLo-kJad4f1yGKlLDSQ4q4ZalZij68qmDBl7qRiULem2y19qO2yZ8L5KKKSjAEMb0HfKpMnV-VcBEUAZxnKe3OcfLZE2JdsP7JROWSVwxee22odCOErsxi3QIk8uWruSP4oJ9S0Fd6qxLW9XuRCGi6E7E8V0ieTqfDsLMv3xv0npVOB-1qDgbp4nkvebqfLaAOY7Y-aDFfiHHaHAr5oVdvBPn5z9jyUIMmepuEF_OkrtoKlUUPdUbwPLOZIfNQvzMFHXt2LOzB0ttx854JJp2tEZPfu3832jt1hQkyBI_pLC6EH6dwm_tegvu9AeyAB6ecjvE9T1EyjyNrUmOADxjKjezKk6ZqJIXwjMNfsYBVdtsxSMxG5r0hfwvcXjOv9ZOUzx6l4cBmHQDsAvie35kGy1LhPFx3TV2QFfqoPqKPXxfs=w1782-h891-no)]()
# Fezā
Fezā is a C project framework designed for Linux machine,focus on being
friendly to terminal based editors. The framework is designed for
app-specific use and tracking the development of the Makefile.

Fezā, named as 'feather' in Japanese,  is also servings as the gradular module
for Project Icarus.

| Branch          | Test Condition |
|:--------------- |:---------------|
| `master`        | [![pipeline status](https://gitlab.com/ZORALab/feza/badges/master/pipeline.svg)](https://gitlab.com/ZORALab/feza/commits/master) |
| `feza/staging`  | [![pipeline status](https://gitlab.com/ZORALab/feza/badges/feza/staging/pipeline.svg)](https://gitlab.com/ZORALab/feza/commits/feza/staging) |
| `feza/next` | [![pipeline status](https://gitlab.com/ZORALab/feza/badges/feza/next/pipeline.svg)](https://gitlab.com/ZORALab/feza/commits/feza/next) |

<br/>
## Usage
1. Fork this project.
2. Rename the project and its README.md badge tags to your deployment.
3. Change the legal email in `CONTRIBUTING.md` file.
4. Modify the Makefile to suit your needs.

> NOTE:
>
> Most of the appropriate tools such as changelog generator, setup script,
> `.gitignore` and contribution are in placed.

<br/>
## Commands
### 1. `make all`
Build all the `.c` files in the `libs` folders and link them with the `main.o`
file. The generated binary is located inside `bin` folder.

> NOTE:
>
> Any files outside the `libs` folder is not included inside the Makefile.
> It was meant to have only main.c to make things clean. Keep your `.c` files
> inside the `libs` folder. Otherwise, modify the Makefile accordingly.


### 2. `make clean`
Clean up the workspace from all the compiled files, such as `.d`, `.o`, `.hex`,
`.elf`, and `.bin` files.


### 3. `make test`
Run static analysis upon all the selected `.c` files using the flawfinder,
the open-source static analyzer for C written in the `test` folder using
[BaSHELL](https://gitlab.com/ZORALab/BaSHELL).

<br/>
## License
Apache 2.0
