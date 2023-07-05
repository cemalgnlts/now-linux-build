const { createWriteStream, readFileSync, truncateSync } = require("fs");
const { inspect } = require("util");
const repl = require("repl");

const STD_OUT_PATH = "/root/.stdout";
const STD_ERR_PATH = "/root/.stderr";

const stdOutStream = createWriteStream(STD_OUT_PATH);
const stdErrStream = createWriteStream(STD_ERR_PATH);
globalThis.console = new console.Console(stdOutStream, stdErrStream);

process.chdir("/root");

const writer = output => {
	console.log(inspect(output));
	
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
		replServer.commands.clear.action.apply(this);

		truncateSync(STD_OUT_PATH);
		truncateSync(STD_ERR_PATH);

		try {
			eval(readFileSync(file, { encoding: "utf8", flag: "r" }));
		} catch (err) {
			console.error(err);
		}

		this.displayPrompt();
	}
});