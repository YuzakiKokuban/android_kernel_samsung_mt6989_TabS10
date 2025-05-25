# Kokuban 内核适用于三星 Galaxy Tab S10 系列（SM-X82XX / X92XX ）

基于三星官方开源版本构建的 Galaxy Tab S10 系列自定义内核。  
支持 One UI 7.0 稳定版和 KernelSU 集成。

---

## 📌 主要特性

- **基础：** 三星官方开源内核
- **One UI 支持：** 完全兼容 One UI 7.0 稳定版
- **KernelSU 兼容性：** 支持 KernelSU LKM 模式及更多
- **更多压缩算法：** 额外支持启用 `lz4hc`, `lz4kd`, `842`, `deflate` 等多种压缩算法，兼容性更强，适用于日志、zram 等场景 
- **版本格式：**  
  `6.1.75-android14-Kokuban-Exusiai-XXXX-XXX-gXXXXXXXXXX`

---

## 🧩 可用版本

- **LKM**  
  - 未内置 KernelSU  
  - 移除部分三星安全策略  
  - 需要通过 KernelSU 管理器手动修补 `init_boot`

- **KSU**  
  - 内置 KernelSU 1.0.5

- **MKSU**  
  - 内置 KernelSU `5ec1cff`  
  - 支持 Magic Mount

- **SukiSUU**  
  - 内置 SukiSU-Ultra  
  - 支持 SUSFS 1.5.7

---

## ⚙️ 安装指南

1. 使用 TWRP 刷入提供的 AnyKernel3 包。
2. 备份您的 `init_boot` 分区，并使用 KernelSU 进行修补。
3. 将修补后的 `init_boot` 刷回设备。
4. 重启并享受！

---

## 📥 下载链接

- [发布页面](https://github.com/YuzakiKokuban/android_kernel_samsung_mt6989/releases)

---

## 🧾 源码链接

- [三星开源中心](https://opensource.samsung.com/uploadSearch)
- [GitHub 内核源码](https://github.com/YuzakiKokuban/android_kernel_samsung_mt6989)

---

## ⚠️ 免责声明

- 刷入操作需自行承担风险。
- 对于设备的任何损坏，作者概不负责。
- 在刷入自定义内核前，请务必备份数据。

---

# 🥺 小小拜托 

## 求求你了，不要拿这个内核去适配 KernelSU-Next 啦～  
😭😭😭

KernelSU-Next 不是 KernelSU 官方开发的，也不是官方认可的改进版，  
而且它的开发者有一些很让人摸不着头脑的操作……  

[岁月史书](https://web.archive.org/web/20250211155215/https://github.com/rifsxd/KernelSU-Next/issues/145)

如果你想要类似功能的话，拜托用 **SukiSU** 好不好嘛～  
它更稳定，也更值得信赖！

---

## 如果你还是坚持要适配 KernelSU-Next……  
我真的会呜呜呜哭出来的！！！  
(｡•́︿•̀｡)  
拜托啦～谢谢谢谢！

---

## ☕ 支持我

如果你觉得这个项目对你有帮助，可以通过以下方式支持我：

- PayPal：[https://www.paypal.me/LangQin280](https://www.paypal.me/LangQin280)  
- 支付宝：[点击打赏](https://qr.alipay.com/fkx13433fi3skccvxkldn48)  
- 微信：`wxp://f2f0fS_33WFG-AtCBNKiMLIvR27Z64IAQteJ3mepyvSnaQg`
- 币安: [虚拟货币](https://app.binance.com/qr/dplk879862a9139d41469d7f3f66a059c5e9)

---

感谢您的支持！  
如果您觉得这个项目有帮助，欢迎为仓库点个星！

---

# Kokuban Kernel for Samsung Galaxy Tab S10 Series (SM-X82XX / X92XX )

Custom kernel for the Samsung Galaxy S25 series, built from Samsung's official open-source release.  
Supports One UI 7.0 Stable and KernelSU integration.

---

## 📌 Highlights

- **Base:** Samsung's open-source kernel
- **One UI Support:** Fully compatible with One UI 7.0 Stable
- **KernelSU Compatibility:** Supports KernelSU LKM mode and more
- **More Compression Algorithms:** Additional support for `lz4hc`, `lz4kd`, `842`, `deflate`, and more, improving compatibility for use cases like logging and zram.
- **Version Format:**  
  `6.1.75-android14-Kokuban-Exusiai-XXXX-XXX-gXXXXXXXXXX`

---

## 🧩 Available Variants

- **LKM**  
  - No built-in KernelSU  
  - Some Samsung security policies removed  
  - Requires manual patching of `init_boot` via KernelSU Manager

- **KSU**  
  - Built-in KernelSU 1.0.5

- **MKSU**  
  - Built-in KernelSU `5ec1cff`  
  - Supports Magic Mount

- **SukiSUU**  
  - Built-in SukiSU-Ultra  
  - Supports SUSFS 1.5.7

---

## ⚙️ Installation Guide

1. Flash the provided AnyKernel3 package using TWRP.
2. Backup your `init_boot` partition and patch it with KernelSU.
3. Flash the patched `init_boot` back to your device.
4. Reboot and enjoy!

---

## 📥 Downloads

- [Releases](https://github.com/YuzakiKokuban/android_kernel_samsung_mt6989/releases)

---

## 🧾 Sources

- [Samsung Open Source Center](https://opensource.samsung.com/uploadSearch)
- [Kernel Source on GitHub](https://github.com/YuzakiKokuban/android_kernel_samsung_mt6989)

---

## ⚠️ Disclaimer

- Flash at your own risk.
- I am not responsible for any damage to your device.
- Always make backups before flashing custom kernels.

---

# 🥺 A Little Request

## Please, please don't use this kernel for adapting KernelSU-Next~  
😭😭😭

KernelSU-Next is NOT developed by the official KernelSU team, nor is it an officially endorsed improvement.  
Also, its developer has done some really confusing and questionable things...

[Some Records](https://web.archive.org/web/20250211155215/https://github.com/rifsxd/KernelSU-Next/issues/145)

If you need similar functionality, please use **SukiSU**, okay?  
It's much more stable and trustworthy!

---

## If you still insist on adapting it to KernelSU-Next...  
I might actually burst into tears!!!  
(｡•́︿•̀｡)  
Pleaseee~ Thank you so much!

---

## ☕ Support Me

If you find this project helpful and would like to support my work, you can do so via:

- PayPal: [https://www.paypal.me/LangQin280](https://www.paypal.me/LangQin280)  
- Alipay (Mainland China): [Click to donate](https://qr.alipay.com/fkx13433fi3skccvxkldn48)  
- WeChat (Weixin): `wxp://f2f0fS_33WFG-AtCBNKiMLIvR27Z64IAQteJ3mepyvSnaQg`
- Binance: [Virtual currency](https://app.binance.com/qr/dplk879862a9139d41469d7f3f66a059c5e9)
  
---

Thank you for your support!  
If you find this project helpful, feel free to star the repository!

---

# How do I submit patches to Android Common Kernels

1. BEST: Make all of your changes to upstream Linux. If appropriate, backport to the stable releases.
   These patches will be merged automatically in the corresponding common kernels. If the patch is already
   in upstream Linux, post a backport of the patch that conforms to the patch requirements below.
   - Do not send patches upstream that contain only symbol exports. To be considered for upstream Linux,
additions of `EXPORT_SYMBOL_GPL()` require an in-tree modular driver that uses the symbol -- so include
the new driver or changes to an existing driver in the same patchset as the export.
   - When sending patches upstream, the commit message must contain a clear case for why the patch
is needed and beneficial to the community. Enabling out-of-tree drivers or functionality is not
not a persuasive case.

2. LESS GOOD: Develop your patches out-of-tree (from an upstream Linux point-of-view). Unless these are
   fixing an Android-specific bug, these are very unlikely to be accepted unless they have been
   coordinated with kernel-team@android.com. If you want to proceed, post a patch that conforms to the
   patch requirements below.

# Common Kernel patch requirements

- All patches must conform to the Linux kernel coding standards and pass `scripts/checkpatch.pl`
- Patches shall not break gki_defconfig or allmodconfig builds for arm, arm64, x86, x86_64 architectures
(see  https://source.android.com/setup/build/building-kernels)
- If the patch is not merged from an upstream branch, the subject must be tagged with the type of patch:
`UPSTREAM:`, `BACKPORT:`, `FROMGIT:`, `FROMLIST:`, or `ANDROID:`.
- All patches must have a `Change-Id:` tag (see https://gerrit-review.googlesource.com/Documentation/user-changeid.html)
- If an Android bug has been assigned, there must be a `Bug:` tag.
- All patches must have a `Signed-off-by:` tag by the author and the submitter

Additional requirements are listed below based on patch type

## Requirements for backports from mainline Linux: `UPSTREAM:`, `BACKPORT:`

- If the patch is a cherry-pick from Linux mainline with no changes at all
    - tag the patch subject with `UPSTREAM:`.
    - add upstream commit information with a `(cherry picked from commit ...)` line
    - Example:
        - if the upstream commit message is
```
        important patch from upstream

        This is the detailed description of the important patch

        Signed-off-by: Fred Jones <fred.jones@foo.org>
```
>- then Joe Smith would upload the patch for the common kernel as
```
        UPSTREAM: important patch from upstream

        This is the detailed description of the important patch

        Signed-off-by: Fred Jones <fred.jones@foo.org>

        Bug: 135791357
        Change-Id: I4caaaa566ea080fa148c5e768bb1a0b6f7201c01
        (cherry picked from commit c31e73121f4c1ec41143423ac6ce3ce6dafdcec1)
        Signed-off-by: Joe Smith <joe.smith@foo.org>
```

- If the patch requires any changes from the upstream version, tag the patch with `BACKPORT:`
instead of `UPSTREAM:`.
    - use the same tags as `UPSTREAM:`
    - add comments about the changes under the `(cherry picked from commit ...)` line
    - Example:
```
        BACKPORT: important patch from upstream

        This is the detailed description of the important patch

        Signed-off-by: Fred Jones <fred.jones@foo.org>

        Bug: 135791357
        Change-Id: I4caaaa566ea080fa148c5e768bb1a0b6f7201c01
        (cherry picked from commit c31e73121f4c1ec41143423ac6ce3ce6dafdcec1)
        [joe: Resolved minor conflict in drivers/foo/bar.c ]
        Signed-off-by: Joe Smith <joe.smith@foo.org>
```

## Requirements for other backports: `FROMGIT:`, `FROMLIST:`,

- If the patch has been merged into an upstream maintainer tree, but has not yet
been merged into Linux mainline
    - tag the patch subject with `FROMGIT:`
    - add info on where the patch came from as `(cherry picked from commit <sha1> <repo> <branch>)`. This
must be a stable maintainer branch (not rebased, so don't use `linux-next` for example).
    - if changes were required, use `BACKPORT: FROMGIT:`
    - Example:
        - if the commit message in the maintainer tree is
```
        important patch from upstream

        This is the detailed description of the important patch

        Signed-off-by: Fred Jones <fred.jones@foo.org>
```
>- then Joe Smith would upload the patch for the common kernel as
```
        FROMGIT: important patch from upstream

        This is the detailed description of the important patch

        Signed-off-by: Fred Jones <fred.jones@foo.org>

        Bug: 135791357
        (cherry picked from commit 878a2fd9de10b03d11d2f622250285c7e63deace
         https://git.kernel.org/pub/scm/linux/kernel/git/foo/bar.git test-branch)
        Change-Id: I4caaaa566ea080fa148c5e768bb1a0b6f7201c01
        Signed-off-by: Joe Smith <joe.smith@foo.org>
```


- If the patch has been submitted to LKML, but not accepted into any maintainer tree
    - tag the patch subject with `FROMLIST:`
    - add a `Link:` tag with a link to the submittal on lore.kernel.org
    - add a `Bug:` tag with the Android bug (required for patches not accepted into
a maintainer tree)
    - if changes were required, use `BACKPORT: FROMLIST:`
    - Example:
```
        FROMLIST: important patch from upstream

        This is the detailed description of the important patch

        Signed-off-by: Fred Jones <fred.jones@foo.org>

        Bug: 135791357
        Link: https://lore.kernel.org/lkml/20190619171517.GA17557@someone.com/
        Change-Id: I4caaaa566ea080fa148c5e768bb1a0b6f7201c01
        Signed-off-by: Joe Smith <joe.smith@foo.org>
```

## Requirements for Android-specific patches: `ANDROID:`

- If the patch is fixing a bug to Android-specific code
    - tag the patch subject with `ANDROID:`
    - add a `Fixes:` tag that cites the patch with the bug
    - Example:
```
        ANDROID: fix android-specific bug in foobar.c

        This is the detailed description of the important fix

        Fixes: 1234abcd2468 ("foobar: add cool feature")
        Change-Id: I4caaaa566ea080fa148c5e768bb1a0b6f7201c01
        Signed-off-by: Joe Smith <joe.smith@foo.org>
```

- If the patch is a new feature
    - tag the patch subject with `ANDROID:`
    - add a `Bug:` tag with the Android bug (required for android-specific features)