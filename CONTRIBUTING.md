# Contributing

## 开发流程

1. 从最新主分支创建短生命周期分支。
2. 用项目 preset 配置，不在源码目录或另一个编译器的 build tree 中重配。
3. 将业务规则放在 `src/core` 或新增的领域模块中；`src/app` 只负责 Qt GUI 装配。
4. 新行为必须配套测试；缺陷修复应先添加能复现问题的测试。
5. 提交前完成构建、CTest 和格式检查。

推荐的本地检查：

```powershell
cmake --workflow --preset local-msvc-debug
cmake --workflow --preset local-mingw-debug
cmake --build --preset local-msvc-debug --target format-check
```

`format-check` 只在系统可找到 `clang-format` 时生成。

## 代码规范

- C++20；优先 RAII、值语义和清晰所有权。
- 头文件自包含，不依赖传递 include。
- Qt 对象所有权优先使用父子关系；非 QObject 资源使用标准智能指针。
- 公共接口尽量不依赖 Widgets 类型，以保持核心模块可测试。
- 不在业务模块读取全局设置、环境变量或 UI 控件；通过构造参数或接口注入依赖。
- 不提交生成文件、构建产物或 `CMakeUserPresets.json`。

## CMake 规范

- 每个模块独立 target，依赖可见性准确使用 `PRIVATE`、`PUBLIC`、`INTERFACE`。
- 不使用全局 `include_directories()`、`link_directories()` 或手写编译器 flags。
- 新增源码时更新对应 target 的 `target_sources()`。
- 引入第三方依赖前说明版本策略、许可证、离线构建与更新方式。

## 完成定义

- MSVC 主构建通过。
- MinGW 兼容构建通过，或在变更说明中给出明确的平台限制。
- 所有测试通过，无新增编译警告。
- 安装/打包仍能生成完整 Qt 运行时目录或 ZIP；MSVC 发布说明明确声明并验证 VC++ Redistributable 前置条件。
- 用户可见行为、架构决策和迁移步骤已更新文档。
