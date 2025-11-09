# myfetchFBSD

**myfetchFBSD** es un script avanzado escrito en **Zsh** para mostrar información detallada del sistema **FreeBSD** con una presentación limpia, colorida y precisa, usando `lolcat`.  
Está diseñado específicamente para **sistemas basados en ZFS** y entornos de escritorio **KDE (X11 y Wayland)**, con detección precisa de **discos físicos, pools ZFS**, y estructura **padre–hijo** en unidades NVMe.

---

## 🧠 Características principales

- Información del usuario, hostname y kernel.
- Uptime, shell y entorno de escritorio.
- Resolución de pantalla y fuente activa.
- Arquitectura del sistema (32/64 bits).
- CPU y GPU (Intel / NVIDIA).
- Memoria RAM usada, libre y total.
- Detección automática de navegador por defecto.
- Reporte de discos:
  - Pools ZFS (montados).
  - Discos físicos no montados (ada, nvme, etc.).
  - Estructura **padre–hijo** de NVMe reconocida.
- Compatible con **KDE**, **X11** y **Wayland**.
- Salida en dos columnas con arte ASCII estilizado de FreeBSD.

---

## ⚙️ Instalación

Clona el repositorio y ejecuta el instalador:

```bash
git clone https://github.com/fernandodepaula/myfetchFBSD.git
cd myfetchFBSD
sudo sh install.sh



🔧 Personalización

Si el modelo de CPU o GPU no coincide exactamente con tu hardware (por ejemplo, variantes de Intel Core o Nvidia Mobile), puedes comentar o ajustar las líneas dentro del bloque:
# Info. GPU Intel / NVIDIA
d_gpu_intel=$(pciconf -lv | ...)
d_gpu_nvidia=$(pciconf -lv | ...)

Estas líneas detectan los dispositivos por vendor y device.
En algunos sistemas, puede devolver “N/A” si los módulos no están cargados o el pciconf devuelve nombres genéricos.
Si usas otro entorno gráfico diferente de KDE (por ejemplo XFCE, GNOME o i3), el script seguirá funcionando, aunque la línea:
d_desk=$XDG_CURRENT_DESKTOP


💽 Notas sobre discos ZFS y NVMe
El script identifica pools ZFS y muestra su uso y espacio libre.
Los discos no montados se muestran con su tamaño total.
Se omiten dispositivos nda, nvd y nvme hijos, salvo los de tipo ada, para evitar redundancias.
Ejemplo de salida:

Device Disk:
   zdata-> En uso 9.28G Libre 943G Total 952G (montado: sí)
   zroot-> En uso 4.12G Libre 216G Total 220G (montado: sí)
   ada0--> En uso 0G Libre 894G Total 894G (montado: no)

   
🖥️ Ejemplo de salida
      _____              ____ ____  ____           tu_usuario@FreeBSD
     |  ___| __ ___  ___| __ ) ___||  _ \          ────────────────
     | |_ | '__/ _ \/ _ \  _ \___ \| | | |         Dist./OS /Ker.:  FreeBSD
     |  _|| | |  __/  __/ |_) |__) | |_| |         Kernel Version:  14.3-RELEASE-p5
     |_|  |_|  \___|\___|____/____/|____/          Uptime:          5:22
                                                   Shell:           Zsh
                                                   Desk:            KDE
                                                   Resolution:      1920x1080
                                                   Font:            NotoSans-Regular
                                                   CPU:             Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
                                                   RAM:             Usado: 3.58G / Libre: 12.21G / Total: 15.80G
                                                   Architecture:    64-bit
                                                   GPU Intel:       CoffeeLake-H GT2 [UHD Graphics 630]
                                                   GPU Nvidia:      TU117M [GeForce GTX 1650 Mobile / Max-Q]
                                                   Browser:         kfmclient_html.desktop
                                                   Device Disk:
                                                          zdata-> En uso 9.28G Libre 943G Total 952G (montado: sí)
                                                          zroot-> En uso 4.12G Libre 216G Total 220G (montado: sí)
                                                          ada0--> En uso 0G Libre 894G Total 894G (montado: no)


🧠 Créditos y autoría 
Diseño, estructura y documentación técnica y desarrollado y mantenido por:
Fernando de Paula
FreeBSD Enthusiast & KDE User



