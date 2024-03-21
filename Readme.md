# DeSerSniffer-TaintSummary

# 项目介绍

DeSerSniffer 工具 是 FuzzChains Project 中的静态分析部分，可用Java中的反序列化漏洞检测。与以往的程序分析工具不同，DeSerSniffer (1.0 - 1.6 )直接从各类的ReadObject函数开始污点分析的流非敏感分析，并考虑到子类泛化分析，尽可能在 MaxNumberMaybeTaintedField 范围内，动态产生新的调用图和污点传播信息，当污点Value为Sink函数参数时，DeSerSniffer 认为当前参数对象中存在反序列化漏洞，且使用者可以在neo4j数据中查找可达的最短路径(可手动添加需要排除的路径)，并生成 graphviz 图。

在2.0版本中，DeSerSniffer 改为 基于污点分析和流敏感的自底向上摘要算法，实现有效时间内的组件反序列化利用链检测（ysoserial 中单一组件测试时间平均为300s），在检测精度上与(1.0 - 1.6) 基本保持一致(有一些小bug)。

> 在私有的dev版本中，DeSerSniffer可以根据调用图，生成当前调用路径的属性树图。FuzzChains 可以根据属性树图构造合适的种子结构，并根据 DeSerSniffer 提供的 调用图信息，分析 Fuzzing过程中的调用图覆盖率信息，优先选择 调用图覆盖率高的种子。
>
> 联系方式: fe1w0@qq.com

# 环境部署

## 本地部署（空缺，未完善）

依赖信息:

```bash
sudo apt install graphviz
```

## 容器部署

> 推荐使用容器部署的方式，

# 使用说明

## 运行设置

## Soundness 版本

在 Soundness 版本中，会根据soot生成的facts尽可能分析当前分析对象的所有依赖组件和JDK运行环境信息。

优点: 在MaxNumberMaybeTaintedField参数限制下，会尽可能产生所有的调用边信息。

缺点: 时间慢、内存容易爆炸。

## Unsoundness 版本

在 Unsoundness 版本中，并会根据soot生成的facts尽可能分析当前分析对象的所有依赖组件和JDK运行环境信息，分析的范围为分析对象和JDK运行环境中有用的组件(数据结构类型为主，如HashMap)。

优点: 分析快，占用资源少

缺点: 容易产生漏报。

## ⚠️ 注意事项

### MaxNumberMaybeTaintedField

MaxNumberMaybeTaintedField 直接影响了分析范围，由于Doop基于Soufflé实现的不动点计算，导致如果不设置 MaxNumberMaybeTaintedField 进行限制分析次数，会导致需要很长时间才能等待到 Soufflé 完成所有的关系计算。

### 日志信息

### InValid Input Error

# 测试样例

## CC 3.1

## clojure 1.9.0 - 1.12.0

# 🐞已披露漏洞 (待定)

## Command execution

### ZAPROXY version 2.14.0

Referencs:

- [https://hackmd.io/@fe1w0/SkKUicKR6](https://hackmd.io/@fe1w0/SkKUicKR6)

![1711022209974poc.gif](https://raw.githubusercontent.com/fe1w0/ImageHost/main/image/1711022209974poc.gif)


### org.clojure:clojure ( 1.9.0 - 1.12.0 )

Referencs:

- [https://hackmd.io/@fe1w0/HyefvRQKp](https://hackmd.io/@fe1w0/HyefvRQKp)

![command execution](https://github.com/clojure/clojure/assets/50180586/35f899ef-b7c5-44a1-b6c5-6883b690f967)

## Dos

### org.clojure:clojure ( 1.2.0 - 1.12.0 )

Referencs:

- [https://hackmd.io/@fe1w0/rymmJGida](https://hackmd.io/@fe1w0/rymmJGida)

![dos](https://hackmd.io/_uploads/S1PtMGsdT.gif)

# 引用信息

- 论文
- github 链接

# Todo ⁉

* [ ] 属性树算法设计与开发

> 1.0.0-dev 分支中有类似的算法实现，可以与 FuzzChains 联动，但对应的属性树只是个Demo，并不完善。

* [X] 优化

  * 在优化上，DeSerSniffer 的工作还有很多，但主要问题集中在算法会在更新调用图后，会重新计算新的指针分析和污点分析，内存开销很大，同时也导致大量的误报
* [X] 适用于上下文敏感的分析算法 (放弃，需要修改整体框架)

  * 当前 release 分支中的 DeSerSniffer 仅支持 Doop 中的 context-insensitive 分析方法

- [X] 2.0 中采用的是函数摘要的算法
- [ ] 适用于2.0的对象结构图生成算法(初步，本地dev中)
