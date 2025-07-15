#!/usr/bin/env bash

# 脚本出错时立即退出
set -e

# --- 用户配置 ---

# 1. 主配置文件
MAIN_DEFCONFIG=mt6989_defconfig

# 2. 内核版本标识
LOCALVERSION_BASE=-android14-Kokuban-Exusiai-BYE1-SukiSUU

# 3. LTO (Link Time Optimization)
LTO=""

# 4. 工具链路径
TOOLCHAIN=$(realpath "/home/kokuban/PlentyofToolchain/toolchainTS10/prebuilts")

# 5. AnyKernel3 打包配置
ANYKERNEL_REPO="https://github.com/YuzakiKokuban/AnyKernel3.git"
ANYKERNEL_BRANCH="mt6989"

# 6. 输出文件名前缀
ZIP_NAME_PREFIX="TabS10_kernel"

# 7. GitHub Release 配置
# 替换成你自己的 "用户名/仓库名"
GITHUB_REPO="YuzakiKokuban/Your-Kernel-Repo" 
# 设置为 true 以启用自动发布，设置为 false 或留空以禁用
AUTO_RELEASE=true

# --- 脚本开始 ---

# 切换到脚本所在目录 (通常是内核源码根目录)
cd "$(dirname "$0")"

# --- 环境和路径设置 ---
echo "--- 正在设置工具链环境 ---"
export PATH=$TOOLCHAIN/build-tools/linux-x86/bin:$PATH
export PATH=$TOOLCHAIN/build-tools/path/linux-x86:$PATH
export PATH=$TOOLCHAIN/clang/host/linux-x86/clang-r487747c/bin:$PATH

# =============================== 核心编译参数 ===============================
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
  -d UH -d RKP -d KDP -d SECURITY_DEFEX -d INTEGRITY -d FIVE \
  -d TRIM_UNUSED_KSYMS -d PROCA -d PROCA_GKI_10 -d PROCA_S_OS \
  -d PROCA_CERTIFICATES_XATTR -d PROCA_CERT_ENG -d PROCA_CERT_USER \
  -d GAF -d GAF_V6 -d FIVE_CERT_USER -d FIVE_DEFAULT_HASH

# 4. 配置 LTO (Link Time Optimization)
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
make -j$(nproc) ${MAKE_ARGS} 2>&1 | tee kernel_build_log.txt
BUILD_STATUS=${PIPESTATUS[0]}

if [ $BUILD_STATUS -ne 0 ]; then
    echo "--- 内核编译失败！ ---"
    echo "请检查 'kernel_build_log.txt' 文件以获取更多错误信息。"
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

cp arch/arm64/boot/Image AnyKernel3/Image
cd AnyKernel3

echo "--- 正在运行 patch_linux ---"
if [ ! -f "patch_linux" ]; then
    echo "警告: 未找到 'patch_linux' 脚本，将直接使用原始 Image 作为 zImage。"
    mv Image zImage
else
    chmod +x ./patch_linux
    ./patch_linux
    mv oImage zImage
    rm -f Image oImage patch_linux
    echo "--- patch_linux 执行完毕, 已生成 zImage ---"
fi

if ! command -v lz4 &> /dev/null; then
    echo "错误: 未找到 'lz4' 命令。请先安装 lz4 工具。"
    exit 1
fi

if [ ! -f "tools/libmagiskboot.so" ] || [ ! -f "tools/boot.img.lz4" ]; then
    echo "错误: boot.img 打包工具不完整！请检查你的 AnyKernel3 仓库。"
    exit 1
fi

kernel_release=$(cat ../include/config/kernel.release)
final_name="${ZIP_NAME_PREFIX}_${kernel_release}_$(date '+%Y%m%d')"

echo "--- 正在创建 Zip 刷机包: ${final_name}.zip ---"
zip -r9 "../${final_name}.zip" . -x "*.zip"

echo "--- 正在创建 boot.img: ${final_name}.img ---"
cp zImage tools/kernel
cd tools
chmod +x libmagiskboot.so
lz4 boot.img.lz4
./libmagiskboot.so repack boot.img
mv new-boot.img "../../${final_name}.img"
cd ../.. # 返回到 out 目录

# 获取产物的绝对路径
ZIP_FILE_PATH=$(realpath "${final_name}.zip")
IMG_FILE_PATH=$(realpath "${final_name}.img")

echo "======================================================"
echo "成功！"
echo "刷机包输出到: ${ZIP_FILE_PATH}"
echo "Boot 镜像输出到: ${IMG_FILE_PATH}"
echo "======================================================"


# ======================================================================
# --- 自动发布到 GitHub Release ---
# ======================================================================
if [ "$AUTO_RELEASE" != "true" ]; then
    echo "--- 已跳过自动发布到 GitHub Release ---"
    exit 0
fi

echo -e "\n--- 开始发布到 GitHub Release ---"

# 检查 gh 命令是否存在
if ! command -v gh &> /dev/null; then
    echo "错误: 未找到 'gh' 命令。请先安装 GitHub CLI 并确保它在你的 PATH 中。"
    exit 1
fi

# 检查 GitHub Token 是否已设置
if [ -z "$GH_TOKEN" ]; then
    echo "错误: 环境变量 'GH_TOKEN' 未设置。"
    echo "请先设置你的 GitHub Personal Access Token 以进行身份验证。"
    exit 1
fi

# 使用 gh 登录 (gh 会自动使用 GH_TOKEN)
echo "$GH_TOKEN" | gh auth login --with-token
if [ $? -ne 0 ]; then
    echo "错误: 使用 GH_TOKEN 登录 GitHub 失败。"
    exit 1
fi

# 创建一个唯一的标签名
TAG="release-$(date +%Y%m%d-%H%M%S)"
RELEASE_TITLE="新内核构建 - ${kernel_release} ($(date +'%Y-%m-%d %R'))"
RELEASE_NOTES="由构建脚本在 $(date) 自动发布。"

echo "仓库: $GITHUB_REPO"
echo "标签: $TAG"
echo "标题: $RELEASE_TITLE"
echo "上传文件: "
echo "  - ${ZIP_FILE_PATH}"
echo "  - ${IMG_FILE_PATH}"

echo "--- 准备执行发布命令 ---"

# 临时禁用 "exit on error" 以便捕获 gh 的具体错误信息
set +e

# 执行命令，并将标准错误(2)重定向到标准输出(1)，然后将所有输出捕获到变量中
RELEASE_OUTPUT=$(gh release create "$TAG" \
    "$ZIP_FILE_PATH" \
    "$IMG_FILE_PATH" \
    --repo "$GITHUB_REPO" \
    --title "$RELEASE_TITLE" \
    --notes "$RELEASE_NOTES" 2>&1)

# 获取 gh 命令的退出状态码
RELEASE_STATUS=$?

# 重新启用 "exit on error"
set -e

# 检查状态码
if [ $RELEASE_STATUS -eq 0 ]; then
    echo -e "\n--- 成功发布到 GitHub Release！ ---"
    echo "gh 命令输出:"
    echo "$RELEASE_OUTPUT"
else
    echo -e "\n--- 发布到 GitHub Release 失败！---"
    echo "gh 命令返回了错误码: $RELEASE_STATUS"
    echo "--- 错误详情 ---"
    echo "$RELEASE_OUTPUT"
    echo "--------------------"
    echo "请检查上面的错误信息。最常见的原因是："
    echo "1. GITHUB_REPO ('$GITHUB_REPO') 配置错误或仓库不存在。"
    echo "2. GitHub Token 权限不足 (需要 'contents: write' 权限)。"
    exit 1
fi

exit 0
