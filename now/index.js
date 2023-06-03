const fs = require("fs");
const V86Starter = require("./libv86.js").V86Starter;

function readfile(path) {
    return new Uint8Array(fs.readFileSync(path)).buffer;
}

const bios = readfile("./seabios.bin");
const linux = readfile("./linux.iso");

console.log("Now booting, please stand by ...");

const emulator = new V86Starter({
    memory_size: 512 * 1024 * 1024,
    bios: { buffer: bios },
    cdrom: { buffer: linux },
    autostart: true,
    disable_keyboard: true,
    disable_mouse: true,
});

let data = "";
let isBooted = false;

emulator.add_listener("serial0-output-char", async function serailOutputChar(chr) {
    data += chr;

    if(isBooted === true) process.stdout.write(chr);

    if (isBooted === false && data.endsWith("root$")) {
        isBooted = true;
        data = "";
        emulator.serial0_send('. /opt/now/boot-node.sh\n');
    } else if (isBooted && data.endsWith("root$")) {
        const state = emulator.save_state();
        await fs.promises.writeFile("./linux_state.bin", state);
        
        process.exit();
    }
});