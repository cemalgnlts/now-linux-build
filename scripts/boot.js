const fs = require("fs");
const V86Starter = require("./libv86.js").V86Starter;

function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function readfile(path) {
    return new Uint8Array(fs.readFileSync(path)).buffer;
}

const bios = readfile("./seabios.bin");
const linux = readfile("./linux.iso");

console.log("Now booting, please stand by ...");

const emulator = new V86Starter({
    memory_size: 512 * 1024 * 1024,
    cdrom: { buffer: linux },
    bios: { buffer: bios },
    disable_keyboard: true,
    disable_speaker: true,
    disable_mouse: true,
    is_graphical: false,
    autostart: true,
    fastboot: true,
    filesystem: {},
    uart1: true
});

let data = "";
let isBooted = false;

// Terminate process after 3 minutes.
let tid = setTimeout(() => {
    console.error("Time out.");
    process.exit(1);
}, 3 * 60 * 1000);

emulator.serial1_send = data => {
    for (let i = 0; i < data.length; i++) {
        emulator.bus.send("serial1-input", data.charCodeAt(i));
    }
};

emulator.add_listener("serial0-output-char", async function serailOutputChar(chr) {
    data += chr;

    if (isBooted === true) process.stdout.write(chr);

    if (isBooted === false && data.endsWith("root$")) {
        isBooted = true;
        data = "";
        emulator.serial1_send("node --experimental-fetch /opt/now/repl.js\n");
        emulator.serial0_send(". /opt/now/boot-node.sh\n");
    } else if (isBooted && data.endsWith("root$")) {
        emulator.serial1_send(".run /opt/now/hello.js\n");
        await wait(3000);

        const state = await emulator.save_state();
        await fs.promises.writeFile("./linux_state.bin", Buffer.from(state));

        clearTimeout(tid);
        process.exit();
    }
});