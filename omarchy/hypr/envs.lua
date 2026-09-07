-- Personal environment overrides.

hl.env("SSH_AUTH_SOCK", (os.getenv("XDG_RUNTIME_DIR") or "") .. "/gcr/ssh")