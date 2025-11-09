#!/usr/local/bin/zsh
# =====================================================
# myfetchFBSD - System information fetcher for FreeBSD + Zsh
# Author: Fernando de Paula
# Version: 1.0
# License: MIT
# Clean two-column output with ASCII art and lolcat
# =====================================================


# Variables globales para display_info
d_title=""
d_os=""
d_kname=""
# ... define el resto de variables globales si es necesario

display_info() {
    d_title="$USER@$HOSTNAME"
    d_system=$(printf "FreeBSD %s")
    d_kversion=$(uname -r)
    d_uptime=$(uptime | awk -F'(up |, [0-9]+ user)' '{print $2}' | sed 's/,//g')
    d_shell=$(basename $SHELL)
    d_desk=$XDG_CURRENT_DESKTOP
    # =============================
    # Info. RESOLUCIÓN (FreeBSD)
    # =============================
    d_res=$(xrandr | grep '*' | awk 'NR==1 {print $1}')
    # =============================
    # Info. FONT (FreeBSD)
    # =============================
    d_font=$(fc-match | sed 's/\..*//g')
    # =============================
    # Info. ARQUITERURA (FreeBSD)
    # =============================
    d_architecture="$(getconf LONG_BIT)-bit"
    # =============================
    # Info. CPU (FreeBSD)
    # =============================
    d_cpu=$(sysctl -n hw.model)
    # =============================
    # Info.GPU Intel (FreeBSD)
    # =============================
    d_gpu_intel=$(pciconf -lv | awk '/vgapci/{blk=1} blk&&/vendor/&&/Intel/{ok=1} blk&&/device/{if(ok){print;exit}}' | sed -E "s/.*device[[:space:]]*=[[:space:]]*'([^']+)'.*/\1/"); d_gpu_intel=${d_gpu_intel:-"N/A"}
    # =============================
    # Info. GPU NVIDIA (FreeBSD)
    # =============================
    d_gpu_nvidia=$(pciconf -lv | awk '/vgapci/ {in_block=1} in_block && /vendor/ && /NVIDIA/ {found=1} in_block && /device/ {if(found){print; exit}}' | sed -E "s/.*device[[:space:]]*=[[:space:]]*'([^']+)'.*/\1/"); d_gpu_nvidia=${d_gpu_nvidia:-"N/A"}
    # =============================
    # Info. RAM (FreeBSD)
    # =============================
    d_ram_usage=$(awk -v total=$(sysctl -n hw.physmem) -v freepages=$(sysctl -n vm.stats.vm.v_free_count) -v inactive=$(sysctl -n vm.stats.vm.v_inactive_count) -v pagesize=$(sysctl -n hw.pagesize) 'BEGIN {free=(freepages+inactive)*pagesize; used=total-free; printf "Usado: %.2fG / Libre: %.2fG / Total: %.2fG", used/1024/1024/1024, free/1024/1024/1024, total/1024/1024/1024}')
    # =============================
    # Info. BROWSER (FreeBSD)
    # =============================
    d_browser=$(xdg-settings get default-web-browser | sed 's/-.*//g')
    # =============================
    # Línea separadora (FreeBSD)
    # =============================
    qtd=$(printf '─%.0s' $(seq 1 ${#d_title}))
    # =============================
    # Info. de discos (ZFS + físicos no montados)
    # =============================
    d_storage=""
    # --- ZPOOLS ---
    if zpool list >/dev/null 2>&1; then
    while IFS=$'\t' read -r pool size alloc free; do
        [ "$pool" = "NAME" ] && continue
        d_storage+="${pool}-> En uso ${alloc} Libre ${free} Total ${size} (montado: sí)\n"
    done < <(zpool list -H -o name,size,alloc,free)
    # Guardar dispositivos físicos usados en zpools
    devices_in_pools=$(zpool status -v | grep -Eo "(ada[0-9]+|da[0-9]+|nda[0-9]+|nvme[0-9]+n[0-9]+|nvd[0-9]+)" | sort -u)
    else
    devices_in_pools=""
    fi

    # --- TODOS LOS DISCOS FÍSICOS ---
    all_disks=$(geom disk list | awk '/Geom name:/{print $3}')

    # --- PARTICIONES MONTADAS ---
    mounted_parts=$(df -k | awk '$1 ~ /^\/dev\// {print $1 ":" $2 ":" $3 ":" $6}')

    # --- PROCESAR CADA DISCO ---
    for disk in $all_disks; do
    # Saltar discos NVMe (nda, nvd, nvme) excepto ada
    case "$disk" in
        nda*|nvd*|nvme*) continue ;;
    esac

    # Verificar si el disco tiene particiones montadas
    parts=$(echo "$mounted_parts" | awk -F: -v d="$disk" '$1 ~ "^/dev/"d {print}')

    if [ -n "$parts" ]; then
        total_kb=0
        used_kb=0
        while IFS=: read -r part p_total p_used mountpt; do
        total_kb=$((total_kb + p_total))
        used_kb=$((used_kb + p_used))
        done <<< "$parts"
        free_kb=$((total_kb - used_kb))
        total_gb=$(awk "BEGIN{printf \"%.3f\", ($used_kb+$avail_kb)/1024/1024}")
        used_gb=$(awk "BEGIN{printf \"%.3f\", $used_kb/1024/1024}")
        free_gb=$(awk "BEGIN{printf \"%.2f\", $free_kb/1048576}")
        d_storage+="${disk}-> En uso ${used_gb} GB Libre ${free_gb} GB Total ${total_gb} GB (montado: sí)\n"
    else
        size_bytes=$(geom disk list "$disk" | awk -F': ' '/Mediasize:/ {print $2}' | awk '{print $1}')
        size_gb=$(awk "BEGIN{printf \"%.0f\", $size_bytes/1024/1024/1024}")
        d_storage+="${disk}--> En uso 0G Libre ${size_gb}G Total ${size_gb}G (montado: no)\n"
    fi
    done

}

# Esta función ahora SOLO imprime las líneas de datos, sin el título.
get_info_lines() {
    display_info
    cat <<EOF

$d_title
$qtd
Dist./OS /Ker.:  $d_system
Kernel Version:  $d_kversion
Uptime:         $d_uptime
Shell:           ${d_shell^}
Desk:            $d_desk
Resolution:      $d_res
Font:            $d_font
Architecture:    $d_architecture
CPU:             $d_cpu
GPU Intel:       $d_gpu_intel
GPU Nvidia:      $d_gpu_nvidia
RAM:             $d_ram_usage
Browser:         $d_browser
Device Disk:
$(echo -e "$d_storage" | sed 's/^/       /')
EOF
}

# =====================================================
# ASCII Art de FreeBSD (Ajustado para 15 líneas en total)
# =====================================================
FreeBSD_ASCII=(
""
""
""
""
""
"      _____              ____ ____  ____ "
"     |  ___| __ ___  ___| __ ) ___||  _ \ "
"     | |_ | '__/ _ \/ _ \  _ \___ \| | | |"
"     |  _|| | |  __/  __/ |_) |__) | |_| |"
"     |_|  |_|  \___|\___|____/____/|____/ "
""
""
""
""
""
)

# =====================================================
# Mostrar ASCII y la info en un array línea por línea
# =====================================================
info_lines=()
while IFS= read -r line; do
    info_lines+=("$line")
done < <(get_info_lines)

# Determinar la altura máxima entre ASCII y info_lines
max_lines=$(( ${#FreeBSD_ASCII[@]} > ${#info_lines[@]} ? ${#FreeBSD_ASCII[@]} : ${#info_lines[@]} ))

# Ancho fijo para la columna izquierda (ASCII)
left_width=50

# Imprimir alineado
for ((i=0; i<max_lines; i++)); do
    left="${FreeBSD_ASCII[i]:-}"
    right="${info_lines[i]:-}"
    printf "%-${left_width}s %s\n" "$left" "$right"
done | lolcat
