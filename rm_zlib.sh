#!/bin/bash
# Z-Library Filename Cleanup Tool
# Author: Anson Ho
# Version: 1.0.0
# Description: 批量清理Z-Library文件名中的冗余信息
# Usage: bash rm_zlib.sh
# Dependencies: find, mv, sed, tput
# Notes: 此脚本将清理文件名中的"(Z-Library)"部分，以提高文件名的可读性和一致性。

# 颜色定义（兼容性增强）
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
NC=$(tput sgr0)

# 初始化统计变量
declare -i total=0 success=0 fail=0 current=0

# 安全获取文件列表（兼容POSIX）
echo -e "${BLUE}${BOLD}⏳ Scanning file system...${NC}"
echo "------------------------------------------------"
temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT

find . -depth -name '*(Z-Library)*' -print0 2>/dev/null > "$temp_file"

# 读取文件到数组（兼容旧版bash）
file_list=()
while IFS= read -r -d '' file; do
    file_list+=("$file")
    ((total++))
done < "$temp_file"
rm -f "$temp_file"

# 动画帧（ASCII备用方案）
spinner=('|' '/' '-' '\')

# 进度条函数（终端宽度自适应）
progress() {
    local cols=$(tput cols)
    local bar_width=$((cols - 20))
    local percent=$(( $1 * 100 / $2 ))
    local filled=$(( bar_width * percent / 100 ))
    
    printf "${BOLD}${YELLOW}%s [%03d%%]${NC} [" "${spinner[$3]}" "$percent"
    printf "%${filled}s" | tr ' ' '■'
    printf "%$((bar_width - filled))s" | tr ' ' '□'
    printf "] ${BLUE}%s/%s${NC}" "$1" "$2"
}

# 主程序（增强兼容性）
echo
echo -e "${BOLD}${GREEN}Z-Library Filename Cleanup Tool started!${NC}"
echo -e "${BLUE}📂 Found ${YELLOW}${total} ${BLUE} files to process${NC}"
echo "------------------------------------------------"
# 询问用户是否继续
read -p "🚀 Continue? [Y/n] " -n 1 -r
start_time=$(date +%s)

for file in "${file_list[@]}"; do
    ((current++))
    spin_idx=$((current % ${#spinner[@]}))
    
    # 动态显示（兼容不支持ANSI的终端）
    printf "\r\033[2K"
    progress $current $total $spin_idx
    echo -n "  "
    
    # 文件名处理（增强安全性）
    dir=$(dirname -- "$file")
    oldname=$(basename -- "$file")
    newname=$(echo "$oldname" | sed 's/(Z-Library)//g')
    
    # 执行重命名（添加错误处理）
    if [[ "$oldname" != "$newname" ]]; then
        if mv -f -- "$file" "$dir/$newname" 2>/dev/null; then
            ((success++))
            echo -en "\r\033[2K${BOLD}✅ ${GREEN}Success:${NC} ${oldname:0:40}...${NC}"
        else
            ((fail++))
            echo -en "\r\033[2K${BOLD}❌ ${RED}Failure:${NC} ${oldname:0:40}...${NC}"
        fi
    else
        ((success++))
        echo -en "\r\033[2K${BOLD}⚠️ ${YELLOW}Skip:${NC} ${oldname:0:40}...${NC}"
    fi
    sleep 0.02  # 降低CPU占用
done

# 最终报告（兼容性优化）
end_time=$(date +%s)
duration=$((end_time - start_time))

echo
echo
echo "-----------------------"
echo -e "Processing complete🎉 ${NC}"
echo "-----------------------"
echo -e " Total time:${NC} ${duration}s"
echo -e "${BLUE} Statistics:${NC}"
echo -e "  ✅ ${GREEN}Success:${NC} $success"
echo -e "  ❌ ${RED}Failure:${NC} $fail"
echo -e "  📂 ${BLUE}Total:${NC} $total"
echo "-----------------------"