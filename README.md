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

* **版本信息**: `-android14-Kokuban-Exusiai-CYI6`

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



# Kokuban Kernel for Samsung Galaxy Tab S10 Series

<p align="center">
<img src="https://raw.githubusercontent.com/YuzakiKokuban/Kokuban_Kernel_CI_Center/main/docs/kokuban_logo.png" alt="Logo" width="150">
</p>

<p align="center">
<a href="https://github.com/YuzakiKokuban/android_kernel_samsung_mt6989_TabS10/releases"><img src="https://img.shields.io/github/v/release/YuzakiKokuban/android_kernel_samsung_sm8750?style=for-the-badge&logo=github&color=blue" alt="GitHub release"></a>
<a href="https://t.me/YuzakiKokuban"><img src="https://img.shields.io/badge/Telegram-Chat-blue.svg?style=for-the-badge&logo=telegram" alt="Telegram"></a>
</p>

This is a high-performance custom kernel for the **Samsung Galaxy Tab S10 Series**, built upon Samsung's official kernel source. It is designed to deliver exceptional stability and smoothness while integrating the latest KernelSU features for the ultimate user experience.

## 📌 Highlights

* **Official Source Base**: Built on the latest official kernel source from Samsung, ensuring optimal compatibility and stability.

* **Performance-Tuned**: Targeted performance and scheduling optimizations for a smoother daily usage and gaming experience.

* **KernelSU Integrated**: Comes with multiple KernelSU variants (Official, MKSU, SukiSU-Ultra) built-in for an out-of-the-box experience.

* **Version Info**: `-android14-Kokuban-Exusiai-CYI6`

## 🧩 Available Variants Explained

* **LKM (Loadable Kernel Module)**

  * Does not include any built-in root solution, maintaining the purity of the stock kernel.

  * **Security**: Only essential Samsung security policies that affect modding (like RKP, KDP) are removed.

  * **Usage**: Requires you to manually patch your device's `init_boot` partition using the KernelSU Manager App to achieve root.

* **KSU (KernelSU)**

  * Built-in with the official, unmodified KernelSU for the most authentic root experience.

* **MKSU (Magic KernelSU)**

  * Features KernelSU modified by `5ec1cff`, which notably supports Magic Mount for easier module management.

* **SukiSUU (SukiSU-Ultra)**

  * Integrated with the powerful SukiSU-Ultra, supporting SUSFS and KPM modules, offering advanced features for power users.

## ⚙️ Installation Guide

1. **Unlock Bootloader**: Ensure your device's bootloader is unlocked.

2. **Flash Recovery**: It is recommended to use the latest version of TWRP or OrangeFox Recovery.

3. **Flash Kernel**: Flash the kernel `zip` package downloaded from the Releases page in this project via Recovery.

4. **(LKM Version Only) Patch `init_boot`**:

   * Back up your current `init_boot.img`.

   * Use the KernelSU Manager App to select and patch this image.

   * Flash the resulting `kernelsu_boot.img` to your device's `init_boot` partition via Fastboot or Recovery.

5. **Reboot your device** and enjoy the new kernel!

## 📥 Downloads

All the latest builds can be found on the [**Releases Page**](https://github.com/YuzakiKokuban/android_kernel_samsung_mt6989_TabS10/releases).

## ⚠️ Disclaimer

Flashing custom software carries inherent risks. Please make a full backup of your personal data before proceeding. I am not responsible for any damage to your device or data loss that may occur as a result of flashing this kernel.

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


<p align="center">
<a href="https://www.paypal.me/LangQin280">☕ Support Me</a>
</p>
