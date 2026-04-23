# BuyrunCore

RV32I in-order pipelined CPU core in Verilog.

## Dependencies

This repository requires **ModelSim Intel FPGA Edition 18.1**.  
That toolchain uses older **32-bit runtime dependencies** on Linux, so these packages must be installed before running simulation.

### Required 32-bit packages

```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y libc6:i386 libstdc++6:i386 zlib1g:i386
sudo apt install -y libncurses5:i386 libtinfo5:i386
```

### If `libncurses5:i386` or `libtinfo5:i386` cannot be found

On some Ubuntu versions, these older packages may not be available directly from the default repositories.  
In that case, install them manually:

```bash
cd ~/Downloads
wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_i386.deb
wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2ubuntu0.1_i386.deb
sudo apt install ./libtinfo5_6.3-2ubuntu0.1_i386.deb ./libncurses5_6.3-2ubuntu0.1_i386.deb
```