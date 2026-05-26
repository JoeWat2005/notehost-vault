# notehost-vault

Your personal markdown vault — a folder of `.md` files plus the client scripts
to sync them with [notehost.net](https://notehost.net), a private per-user
note hosting platform. Everything in one place.

## Setup (new user)

1. Get an API token from the admin.
2. Copy `.env.example` to `.env`, paste your token:
   ```bash
   cp .env.example .env
   # edit .env, replace REPLACE_WITH_YOUR_TOKEN with your actual token
   ```
3. Run any command below in **Git Bash** on Windows (or any POSIX shell on macOS / Linux).

## Commands

All seven scripts read `NOTES_URL` and `NOTES_TOKEN` from `.env`. They look in
your current working directory first, then fall back to this folder — so you
can run them from anywhere.

| Command | Does |
|---|---|
| `bash push.sh <file.md>...` | Send file(s) to the server; writes `<name>_notes.md` in your current directory |
| `bash upload.sh <local> [remote-name]` | Raw upload — body stored as-is |
| `bash pull.sh [name]` | Sync your server notes into `NOTESPULLED/` in your current directory, or fetch one |
| `bash list.sh [prefix]` | List your server notes (size + name) |
| `bash mv.sh <from> <to>` | Rename / move a server note |
| `bash rm.sh <name>` | Delete a server note |
| `bash init.sh` | (1) Configure JupyterLab to open `.md` in preview (no-op off vLab); (2) batch-send every `.md` in the current dir not already in `markdownvault/` |

All scripts accept `-h` / `--help`.

## Folders (server-side)

Any name argument may contain `/`:

```bash
bash upload.sh local.md ideas/foo.md       # store under a folder
bash list.sh ideas/                         # list only that folder
bash pull.sh ideas/foo.md                   # fetch one
bash mv.sh ideas/foo.md archive/foo.md      # move between folders
bash rm.sh ideas/foo.md                     # delete
```

## What's in this folder

```
notehost-vault/
├── README.md
├── .env.example                                          # template -> copy to .env
├── .gitignore                                            # keeps .env out of git
├── push.sh pull.sh upload.sh list.sh mv.sh rm.sh init.sh
└── markdownvault/                                        # your accumulated notes
    ├── INDEX.md HOW-TO-USE.md NAVIGATION.md ONE-PAGE.md
    ├── archetypes/ monads/ patterns/ ... (study subfolders)
    └── ... (everything else)
```

`markdownvault/` is where `init.sh` writes new notes back from the server, and
where it checks for already-present equivalents before sending new files.

## Typical workflow

```bash
cd ~/work-papers                # wherever you keep new .md files
bash ~/notehost-vault/init.sh   # JupyterLab setup + batch send new files
```

One-off push:
```bash
bash ~/notehost-vault/push.sh report.md
```
