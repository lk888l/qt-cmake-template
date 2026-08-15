# QtAppTemplate

一个面向真实桌面产品的 Qt 6 Widgets + CMake 工程模板。它刻意把“能运行的窗口”和“可持续演进的工程”分开：GUI 只是装配层，可测试逻辑位于独立静态库中，构建、测试、部署和打包均有稳定入口。

## 工程基线

- Qt 6.5 或更高版本；本机验证版本为 Qt 6.7.3。
- CMake 3.25 或更高版本，使用 Presets schema 6。
- C++20，关闭编译器私有语言扩展。
- Windows 主工具链为 MSVC 2022，MinGW 作为第二编译器验证。
- Qt Widgets、Qt SVG、Qt Test、CTest、CPack，不在配置阶段下载依赖。

## 为什么默认选择 MSVC

对以 Windows 为主要发布平台的 Qt 产品，建议使用 **MSVC 2022**：Visual Studio 调试体验、Windows SDK、崩溃转储、性能分析和多数 Windows 第三方预编译库的协作更稳定。MinGW 很适合轻量开发和 GCC 兼容性检查，因此模板保留完整的 MinGW 构建矩阵，但不把它作为默认发布 ABI。

必须遵守一个硬规则：

- MSVC 编译器只能使用 `msvc2022_64` Qt kit。
- MinGW 编译器只能使用与它匹配的 `mingw_64` Qt kit。
- 两种 ABI 不可链接，也不可复用同一个构建目录。

本机的全局 `PATH` 中还有另一套 GCC；模板的 MinGW user preset 已显式绑定 Qt 随附的 GCC 11.2 和 Ninja，避免误选工具链。

## 快速开始

仓库中的 `CMakeUserPresets.json` 已按当前电脑的 Qt 6.7.3 安装路径生成，并被 Git 忽略。

首选的 MSVC Debug 全流程：

```powershell
cmake --workflow --preset local-msvc-debug
cmake --build --preset local-msvc-debug --target run
```

MinGW Debug 全流程：

```powershell
cmake --workflow --preset local-mingw-debug
cmake --build --preset local-mingw-debug --target run
```

`run` target 会临时把当前 target 对应的 Qt `bin` 放到子进程 PATH 首位。在 Windows 上，它通过生成到构建目录的命令脚本启动 GUI，避免 `cmake -E env` 将窗口以隐藏状态创建。不要从普通终端直接双击或启动 build-tree EXE：preset 的环境不会反向修改父 PowerShell，机器上并存两套 Qt 时还可能误加载另一种 ABI 的同名 DLL。

> [!IMPORTANT]
> `run` 必须从登录到当前 Windows 桌面的交互式终端（例如单独打开的 PowerShell、Windows Terminal、Qt Creator 或 Visual Studio）执行。CI、Codex 等沙箱终端可以正常完成编译和测试，但它们启动的 GUI 进程可能位于隔离桌面；这种情况下请在普通桌面终端中重新执行第二条命令。

MSVC Release 构建、测试和 ZIP 打包：

```powershell
cmake --workflow --preset local-msvc-release
```

产物位于 `out/build/local-msvc/packages/`。也可以分步执行：

```powershell
cmake --preset local-msvc
cmake --build --preset local-msvc-release
ctest --preset local-msvc-release
cmake --install out/build/local-msvc --config Release
cpack --preset local-msvc-release
```

包名带 ABI 标签，例如 `...-msvc.zip` 与 `...-mingw.zip`，两套产物汇总到发布目录时不会互相覆盖。

Qt 6.5/6.7 的部署脚本要求自定义 `--prefix` 是绝对路径；不传时会使用 preset 已配置的绝对安装目录。例如：

```powershell
cmake --install out/build/local-msvc --config Release --prefix "$PWD/out/stage-msvc"
```

列出当前可用的所有预设：

```powershell
cmake --list-presets=all
```

### 换一台电脑

复制 `CMakeUserPresets.json.example` 为 `CMakeUserPresets.json`，修改其中的 Qt、MinGW 和 Ninja 路径。示例包含完整的 build/test/package/workflow 入口；共享的 `CMakePresets.json` 不包含机器绝对路径，可以提交到版本库。

Qt Creator 可以直接打开根目录的 `CMakeLists.txt` 并选择 preset；Visual Studio 也可以用“打开本地文件夹”加载 CMake 工程。

## 目录结构

```text
.
├── CMakeLists.txt                 # 顶层编排，不承载具体 target 细节
├── CMakePresets.json              # 可提交的共享构建入口
├── CMakeUserPresets.json.example  # 本机路径模板
├── cmake/                         # 警告、分析器、Sanitizer、部署和打包
├── src/
│   ├── core/                      # 与界面解耦、可单测的应用核心
│   └── app/                       # Qt Widgets 启动和窗口装配
├── tests/                         # Qt Test + CTest
├── docs/                          # 架构和扩展约定
└── .github/                       # MSVC/MinGW CI 与依赖更新
```

详细依赖方向和扩展约定见 [docs/architecture.md](docs/architecture.md)。

## 首次复用时要改什么

1. 修改根 `CMakeLists.txt` 中的 `project()` 名称、版本和描述。
2. 设置 `QTAPP_ORGANIZATION_NAME`、`QTAPP_ORGANIZATION_DOMAIN` 和 `QTAPP_APPLICATION_ID` 的默认值。
3. 将 C++ 命名空间 `app` 调整为产品命名空间；这不是构建所必需，但有利于大型代码库治理。
4. 替换 `MainWindow.ui`、应用图标和占位样式。
5. 选择并加入项目许可证；模板不替你预设开源或商业许可。
6. 将 CI 中的 Qt 版本升级到团队统一版本，并在 MSVC 与匹配的 MinGW kit 上验证。

## 构建开关

| 选项 | 默认值 | 用途 |
| --- | ---: | --- |
| `BUILD_TESTING` | `ON` | 构建 Qt Test 测试 |
| `QTAPP_WARNINGS_AS_ERRORS` | `OFF` | 将警告视为错误，CI 中开启 |
| `QTAPP_ENABLE_IPO` | `OFF` | 为 Release/RelWithDebInfo 开启 IPO/LTO |
| `QTAPP_ENABLE_ASAN` | `OFF` | AddressSanitizer |
| `QTAPP_ENABLE_UBSAN` | `OFF` | GCC/Clang UndefinedBehaviorSanitizer |
| `QTAPP_ENABLE_CLANG_TIDY` | `OFF` | 编译时运行 clang-tidy |
| `QTAPP_ENABLE_CPPCHECK` | `OFF` | 编译时运行 cppcheck |

如果系统能找到 `clang-format`，配置时还会生成 `format` 和 `format-check` target。CMake 的编译期 clang-tidy/cppcheck 集成要求 Ninja 或 Makefiles 生成器；在 Visual Studio generator 上开启相应选项会直接给出可操作的配置错误，而不会静默跳过分析。

## Windows 运行库策略

Qt 部署脚本会收集 Qt DLL、插件、翻译和 MinGW 运行库。模板在 MSVC 下显式禁用部署脚本复制编译器运行库，并要求正式安装器链式安装微软官方的 **Visual C++ Redistributable x64**；不要把开发机上的单个 `msvcp140*.dll` / `vcruntime140*.dll` 随意复制进 ZIP。当前 CPack ZIP 因此适合内部测试和已有 VC++ Runtime 的机器，正式发布前应接入团队选定的 MSI/NSIS/WiX 安装流程并验证干净系统。

- [Qt 官方 Windows 部署说明](https://doc.qt.io/qt-6/windows-deployment.html)
- [Microsoft：最新受支持的 Visual C++ Redistributable](https://learn.microsoft.com/cpp/windows/latest-supported-vc-redist?view=msvc-170)

## 工程约束

- 禁止源码目录内构建；所有预设输出到独立的 `out/build/<preset>`。
- 使用 target-based CMake，不修改全局 `CMAKE_CXX_FLAGS`，不使用目录级 include/link 指令。
- target 的生产源文件显式列出；`GLOB_RECURSE` 仅用于非构建关键的格式化文件列表。
- Windows 安装通过 Qt 的 CMake 部署 API 收集 Qt DLL 与平台插件；MinGW 编译器运行库会进入安装树，MSVC 运行库遵循上面的官方 Redistributable 策略；CPack 再将安装树封装为带 ABI 标签的 ZIP。
- 机器状态、IDE 用户文件和构建产物不进入 Git。

提交代码前请阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 参考

- [Qt：使用 CMake 入门](https://doc.qt.io/qt-6/cmake-get-started.html)
- [Qt：让 CMake 找到 Qt](https://doc.qt.io/qt-6/cmake-making-qt-available.html)
- [Qt：CMake 部署 API](https://doc.qt.io/qt-6/cmake-deployment.html)
- [CMake Presets 手册](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html)
