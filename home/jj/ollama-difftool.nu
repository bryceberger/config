#!/usr/bin/env -S nix shell np#nushell np#rich-cli --command nu -n

use std/formats "from jsonl"

def main [left: path right: path] : nothing -> string {
  let url = $env.OLLAMA_HOST? | default "http://localhost:11434"
  let model = $env.OLLAMA_MODEL? | default "qwen3:0.6b"

  let diff_out = ^diff -Nur $left $right | complete
  let width = (term size).columns

  if ($diff_out.stdout | str trim) != "" {
    let prompt = $"A diff \(in unified diff format) follows. Summarize what it does.

($diff_out.stdout)
"
    http post -t application/json ($url)/api/generate {model: $model, prompt: $prompt} |
      from jsonl | get response | str join "" |
      str replace -ra "(?i)(?s)\\s*<think>.*</think>\\s*" "" |
      rich - --markdown --force-terminal --max-width $width
  } else {
    "(empty diff)"
  } | $"($in)\n"
}
