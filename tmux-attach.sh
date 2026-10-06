#!/usr/bin/env bash
#
# Conline per-connection command, launched by Wetty for every browser session.
#
# Runs Cline inside a persistent tmux session:
#   - browser closes / connection drops -> only the tmux *client* dies;
#     the session (and Cline) keeps running in the container
#   - browser reconnects -> `new-session -A` re-attaches to the existing
#     session, restoring the running task and its full scrollback
#   - session is gone (Cline exited) -> a fresh one is created
#
# Configuration (environment variables):
#   CONLINE_TMUX_SESSION  tmux session name   (default: conline)
#   CONLINE_TMUX_COMMAND  command to run inside the session (default: cline)

set -u

SESSION="${CONLINE_TMUX_SESSION:-conline}"
COMMAND="${CONLINE_TMUX_COMMAND:-cline}"

# Small retry loop: if the session dies between "attach" and "create",
# recreate it instead of dropping the browser connection.
#
# -u forces tmux to write UTF-8 to the outer terminal even if the
# locale variables are missing/ASCII. Without it tmux may set
# client_utf8=0 and replace every non-ASCII glyph (•, ❯, …) with "_".
for _ in 1 2 3; do
    tmux -u new-session -A -s "$SESSION" bash -lc "$COMMAND" && exit 0
    sleep 0.5
done

echo "tmux-attach: failed to attach to or create session '$SESSION'" >&2
exit 1
