const repl = require("repl");
const fs = require("fs");
const util = require("util");

const STD_OUT_PATH = "/root/.now/stdout";
const STD_ERR_PATH = "/root/.now/stderr";

const stdOutStream = fs.createWriteStream(STD_OUT_PATH);
const stdErrStream = fs.createWriteStream(STD_ERR_PATH);
globalThis.console = new console.Console(stdOutStream, stdErrStream);

const writer = output => {
	console.log(util.inspect(output));
	
	return undefined;
};

const replServer = repl.start({
	prompt: ">",
	writer: writer,
	useColors: false,
	useGlobals: false,
	ignoreUndefined: true,
	replMode: repl.REPL_MODE_STRICT,
	preview: false
});

Object.defineProperty(replServer.context, "console", {
  configurable: false,
  enumerable: true,
  value: console
});

replServer.defineCommand("run", {
	help: "Run code",
	action(file) {
		this.clearBufferedCommand();

		try {
			eval(fs.readFileSync(file, { encoding: "utf8", flag: "r" }));
		} catch (err) {
			console.error(err);
		}

		this.displayPrompt();
	}
});

