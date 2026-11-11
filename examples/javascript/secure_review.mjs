// Review a source file for security vulnerabilities with Gemini 4 Carbon.
// Usage: node examples/javascript/secure_review.mjs path/to/file.js
// Only run this on code you are authorised to analyse.
import { readFileSync } from "node:fs";
import { basename } from "node:path";
import { askCarbon } from "./carbon.mjs";

const SYSTEM =
  "You are a senior application security engineer doing a defensive code review. " +
  "For each finding give: severity, CWE id, the vulnerable lines, why it is exploitable, " +
  "and a minimal patch as a diff. If the code looks safe, say so. Do not invent issues.";

const file = process.argv[2];
if (!file) {
  console.error("usage: secure_review.mjs <file>");
  process.exit(1);
}
const code = readFileSync(file, "utf-8");
const prompt = `Review this file (${basename(file)}) for security vulnerabilities and propose patches.\n\n\`\`\`\n${code}\n\`\`\``;
console.log(await askCarbon(prompt, { systemPrompt: SYSTEM, reasoningEffort: "high" }));
