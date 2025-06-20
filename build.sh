#!/usr/bin/env bash

# 脚本出错时立即退出
set -e

# --- 用户配置 ---

# 1. 主配置文件
# 内核的基础配置，如果脚本没有接收到第一个参数，则使用此默认值
MAIN_DEFCONFIG=mt6989_defconfig

# 2. 内核版本标识
# 构建系统会自动附加 git commit hash
LOCALVERSION_BASE=-android14-Kokuban-Exusiai-AXI9-SukiSUU

# 3. LTO (Link Time Optimization)
# 设置为 "full", "thin" 或 "" (留空以禁用)
LTO="full"

# 4. 工具链路径
# 指向你的工具链的 'prebuilts' 目录
TOOLCHAIN_DIR=$(realpath "/home/kokuban/PlentyofToolchain/toolchainTS10/prebuilts")

# 5. AnyKernel3 打包配置
ANYKERNEL_REPO="https://github.com/YuzakiKokuban/AnyKernel3.git"
ANYKERNEL_BRANCH="mt6989"

# 6. 输出文件名前缀
ZIP_NAME_PREFIX="TabS10_kernel"

# --- 脚本开始 ---

# 切换到脚本所在目录 (通常是内核源码根目录)
cd "$(dirname "$0")"

# --- 环境和路径设置 ---
echo "--- 正在设置工具链环境 ---"
export PATH="$TOOLCHAIN_DIR/build-tools/linux-x86/bin:$PATH"
export PATH="$TOOLCHAIN_DIR/build-tools/path/linux-x86:$PATH"
export PATH="$TOOLCHAIN_DIR/clang/host/linux-x86/clang-r487747c/bin:$PATH"
export KBUILD_BUILD_USER="Kokuban"
export KBUILD_BUILD_HOST="Kokuban-PC"

# =============================== 核心编译参数 ===============================
# 直接使用基础版本号，构建系统会自动处理后续部分
MAKE_ARGS="
O=out
ARCH=arm64
CC=clang
LLVM=1
LLVM_IAS=1
LOCALVERSION=${LOCALVERSION_BASE}
"
# ======================================================================

# 1. 清理旧的编译产物
echo "--- 正在清理 (rm -rf out) ---"
rm -rf out

# 2. 决定并应用 defconfig
# 如果脚本运行时提供了第一个参数 (e.g., ./build.sh my_defconfig), 则使用该参数
# 否则，使用在用户配置中设置的 MAIN_DEFCONFIG
TARGET_DEFCONFIG=${1:-$MAIN_DEFCONFIG}
echo "--- 正在应用 defconfig: $TARGET_DEFCONFIG ---"
make ${MAKE_ARGS} $TARGET_DEFCONFIG
if [ $? -ne 0 ]; then
    echo "错误: 应用 defconfig '$TARGET_DEFCONFIG' 失败。"
    exit 1
fi

# 3. 后处理配置 (禁用三星/GKI等安全特性)
echo "--- 正在禁用部分内核特性 (RKP, KDP, etc.) ---"
./scripts/config --file out/.config \
  -d UH \
  -d RKP \
  -d KDP \
  -d SECURITY_DEFEX \
  -d INTEGRITY \
  -d FIVE \
  -d TRIM_UNUSED_KSYMS \
  -d PROCA \
  -d PROCA_GKI_10 \
  -d PROCA_S_OS \
  -d PROCA_CERTIFICATES_XATTR \
  -d PROCA_CERT_ENG \
  -d PROCA_CERT_USER \
  -d GAF \
  -d GAF_V6 \
  -d FIVE_CERT_USER \
  -d FIVE_DEFAULT_HASH

# 4. 配置 LTO (Link Time Optimization)
# 根据用户配置，精确地启用或禁用 LTO
if [ "$LTO" == "full" ]; then
    echo "--- 正在启用 FullLTO ---"
    ./scripts/config --file out/.config -e LTO_CLANG_FULL -d LTO_CLANG_THIN
elif [ "$LTO" == "thin" ]; then
    echo "--- 正在启用 ThinLTO ---"
    ./scripts/config --file out/.config -e LTO_CLANG_THIN -d LTO_CLANG_FULL
else
    echo "--- LTO 已禁用 ---"
    ./scripts/config --file out/.config -d LTO_CLANG_FULL -d LTO_CLANG_THIN
fi

# 5. 开始编译内核
echo "--- 开始编译内核 (-j$(nproc)) ---"
# 将编译日志同时输出到屏幕和 build.log 文件
make -j$(nproc) ${MAKE_ARGS} 2>&1 | tee build.log
BUILD_STATUS=${PIPESTATUS[0]}

if [ $BUILD_STATUS -ne 0 ]; then
    echo "--- 内核编译失败！ ---"
    echo "请检查 'build.log' 文件以获取更多错误信息。"
    exit 1
fi

echo -e "\n--- 内核编译成功！ ---\n"

# 6. 打包 AnyKernel3 Zip 和 boot.img
echo "--- 正在准备打包环境 ---"
cd out

if [ ! -d AnyKernel3 ]; then
  echo "--- 正在克隆 AnyKernel3 仓库 ---"
  git clone --depth=1 "${ANYKERNEL_REPO}" -b "${ANYKERNEL_BRANCH}" AnyKernel3
fi

# 复制原始内核镜像，准备 patch
cp arch/arm64/boot/Image AnyKernel3/Image

cd AnyKernel3

# 运行 patch_linux 脚本 (如果存在)
echo "--- 正在运行 patch_linux ---"
if [ ! -f "patch_linux" ]; then
    echo "警告: 未找到 'patch_linux' 脚本，将直接使用原始 Image 作为 zImage。"
    mv Image zImage
else
    chmod +x ./patch_linux
    ./patch_linux
    # patch_linux 脚本会生成 oImage, 我们将其重命名为 AnyKernel3 所需的 zImage
    mv oImage zImage
    # 清理中间文件
    rm -f Image oImage patch_linux
    echo "--- patch_linux 执行完毕, 已生成 zImage ---"
fi

# 检查 lz4 命令是否存在
if ! command -v lz4 &> /dev/null; then
    echo "错误: 未找到 'lz4' 命令。请先安装 lz4 工具。"
    exit 1
fi

# 检查 boot.img 打包工具的完整性
if [ ! -f "tools/libmagiskboot.so" ] || [ ! -f "tools/boot.img.lz4" ]; then
    echo "错误: boot.img 打包工具不完整！请检查你的 AnyKernel3 仓库。"
    exit 1
fi

# 准备输出文件名
kernel_release=$(cat ../include/config/kernel.release)
final_name="${ZIP_NAME_PREFIX}_${kernel_release}_$(date '+%Y%m%d')"

echo "--- 正在创建 Zip 刷机包: ${final_name}.zip ---"
zip -r9 "../${final_name}.zip" . -x "*.zip"

echo "--- 正在创建 boot.img: ${final_name}.img ---"
# 复制最终的 zImage 用于制作 boot.img
cp zImage tools/kernel
cd tools
chmod +x libmagiskboot.so
lz4 boot.img.lz4
./libmagiskboot.so repack boot.img
mv boot.img "../../${final_name}.img"
cd ../.. # 返回到 out 目录

echo "======================================================"
echo "成功！"
echo "刷机包输出到: $(realpath ${final_name}.zip)"
echo "Boot 镜像输出到: $(realpath ${final_name}.img)"
echo "======================================================"

exit 0
