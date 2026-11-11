"""Review a source file for security vulnerabilities with Gemini 4 Carbon.

Usage: python examples/python/secure_review.py path/to/file.py
Only run this on code you are authorised to analyse.
"""
import sys
from pathlib import Path

from carbon import ask_carbon

SYSTEM = (
    "You are a senior application security engineer doing a defensive code review. "
    "For each finding give: severity, CWE id, the vulnerable lines, why it is exploitable, "
    "and a minimal patch as a diff. If the code looks safe, say so. Do not invent issues."
)


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: secure_review.py <file>")
    path = Path(sys.argv[1])
    code = path.read_text(encoding="utf-8")
    prompt = f"Review this file ({path.name}) for security vulnerabilities and propose patches.\n\n```\n{code}\n```"
    print(ask_carbon(prompt, system_prompt=SYSTEM, reasoning_effort="high"))


if __name__ == "__main__":
    main()
