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

// Terminate process after 3 minutes.
let tid = setTimeout(() => {
    console.error("Time out.");
    process.exit(1);
}, 3 * 60 * 1000);

emulator.add_listener("serial0-output-char", async function serailOutputChar(chr) {
    data += chr;

    if(isBooted === true) process.stdout.write(chr);

    if (isBooted === false && data.endsWith("root$")) {
        isBooted = true;
        data = "";
        emulator.serial0_send('. /opt/now/boot-node.sh\n');
        emulator.serial_send_bytes(1, "node /opt/now/now-repl.js\n");
    } else if (isBooted && data.endsWith("root$")) {
        const state = await emulator.save_state();
        await fs.promises.writeFile("./linux_state.bin", Buffer.from(state));
        
        clearTimeout(tid);
        process.exit();
    }
});