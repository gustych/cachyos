# Windows VM Setup Session - Resume Point

**Date:** 2026-01-13
**Purpose:** Access Storage Spaces HDD via Windows VM

---

## Completed Steps

- [x] Identified HDD: `/dev/sda` (2TB Seagate ST2000DM008)
- [x] Confirmed filesystem: Microsoft Storage Spaces (cannot be read by Linux)
- [x] Installed virt-manager, QEMU, libvirt, edk2-ovmf
- [x] Enabled libvirtd: `sudo systemctl enable --now libvirtd`
- [x] Added user to groups: `sudo usermod -aG libvirt,kvm gusta`
- [x] Downloaded Windows 10 ISO to ~/Downloads/
- [x] Created VM named `win10` in virt-manager

---

## Resume Point: Add HDD to VM

The VM `win10` exists but needs the physical HDD attached. Run:

```bash
sudo virsh edit win10
```

Find `<devices>` section, add before `</devices>`:

```xml
<disk type='block' device='disk'>
  <driver name='qemu' type='raw'/>
  <source dev='/dev/sda'/>
  <target dev='sdc' bus='sata'/>
</disk>
```

Save, then:
```bash
sudo virsh destroy win10
sudo virsh start win10
```

---

## Next Steps (After HDD Attached)

### 1. Verify Group Membership
```bash
groups
# Should show: libvirt kvm
```

### 2. Download Windows ISO
Option A - Direct download:
```bash
cd ~/Downloads
# Get Windows 11 ISO from Microsoft website:
# https://www.microsoft.com/software-download/windows11
```

Option B - Use existing Windows ISO if you have one.

### 3. Launch Virt-Manager
```bash
virt-manager
```

### 4. Create Windows VM
1. Click "Create a new virtual machine"
2. Select "Local install media (ISO image)"
3. Browse to Windows ISO
4. Allocate RAM: 8GB recommended
5. Allocate CPU: 4 cores
6. Create virtual disk: 64GB (for Windows installation)
7. **IMPORTANT:** Before finishing, check "Customize configuration before install"

### 5. Add Physical HDD Passthrough
In the VM configuration window:
1. Click "Add Hardware"
2. Select "Storage"
3. Select "Select or create custom storage"
4. Enter: `/dev/sda`
5. Device type: "Disk device"
6. Bus type: "SATA"
7. Click "Finish"

### 6. Boot and Install Windows
- Complete Windows installation
- After install, Windows should detect the Storage Spaces drive
- May need to "Import" the pool in Disk Management or Storage Spaces settings

---

## Other Priorities (Also In Progress)

### Priority 1: Local AI Setup
- Need to install: ROCm, Ollama, Open WebUI
- Hardware: AMD RX 5700 XT (8GB), 62GB RAM

### Priority 3: Security Hardening
- Run commands from REMAINING-SECURITY-SETUP.md
- UFW, kernel hardening, update checks, audit logging

### Priority 4: Test Snapshot Recovery
- Practice snapshot restore process

---

## To Resume
Tell Claude: "Resume Windows VM setup from SESSION-WINDOWS-VM.md"
