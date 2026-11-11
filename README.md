> [!WARNING]
> **Deprecated: no longer maintained.** Last updated in May 2026; kept for reference.

# notehost-vault

Bash client scripts for storing and syncing Markdown notes on [notehost.net](https://notehost.net), plus a personal vault of Haskell revision notes.

**Status:** deprecated.

## Features

- Push Markdown files to notehost.net for processing and save each response next to the original as `<name>_notes.md`
- Upload files as-is, and list, download, rename, move and delete notes on the server
- Server-side folders: any note name can contain `/`, for example `ideas/foo.md`
- Batch mode (`init.sh`) that sends every new `.md` file in the current directory and saves the results into `markdownvault/`
- Optional JupyterLab set-up so that Markdown files open in preview mode
- Every script reads its settings from `.env`, so it works from any directory, and accepts `-h` or `--help`

## Tech stack

- Bash
- curl, for all HTTP requests
- Perl, used by `list.sh` and `pull.sh` to read the server's JSON responses
- Markdown

## Getting started

### Prerequisites

- Bash: Git Bash on Windows, or any POSIX shell on macOS or Linux
- curl
- Perl (needed by `list.sh` and `pull.sh`)
- A notehost.net API token, issued by the service administrator
- Optional: JupyterLab, if you want `init.sh` to set Markdown preview as the default viewer

### Installation

```bash
git clone https://github.com/JoeWat2005/notehost-vault.git
cd notehost-vault
cp .env.example .env
```

Then edit `.env` and replace `REPLACE_WITH_YOUR_TOKEN` with your token. `.env` is listed in `.gitignore`, so the token is never committed.

### Configuration

| Variable | Purpose |
|---|---|
| `NOTES_URL` | The notehost.net processing endpoint. The scripts derive the other endpoints (`/notes`, `/move`) by removing the trailing `/process`. |
| `NOTES_TOKEN` | Your personal API token, sent as a bearer token with every request. |

Each script uses these variables if they are already set in the environment. Otherwise it loads `.env` from your current directory, falling back to the folder that contains the scripts.

### Usage

| Command | What it does |
|---|---|
| `bash push.sh <file.md>...` | Sends one or more files for processing and writes each response to `<name>_notes.md` in the current directory |
| `bash upload.sh <local> [remote-name]` | Uploads a file without processing, optionally under a different name or folder |
| `bash pull.sh [name]` | Downloads all your notes, or a single note, into `NOTESPULLED/` in the current directory |
| `bash list.sh [prefix]` | Lists your notes with their sizes, optionally only those under a folder prefix |
| `bash mv.sh <from> <to>` | Renames or moves a note on the server, overwriting the destination if it exists |
| `bash rm.sh <name>` | Deletes a note from the server |
| `bash init.sh` | Sets up JupyterLab Markdown preview (if `jupyter` is installed), then batch-sends every `.md` file in the current directory that is not already in `markdownvault/` |

Working with folders:

```bash
bash upload.sh local.md ideas/foo.md       # store under a folder
bash list.sh ideas/                        # list only that folder
bash pull.sh ideas/foo.md                  # fetch one note
bash mv.sh ideas/foo.md archive/foo.md     # move between folders
bash rm.sh ideas/foo.md                    # delete
```

A typical session:

```bash
cd ~/work-papers                            # wherever you keep new .md files
bash ~/notehost-vault/init.sh               # JupyterLab set-up and batch send of new files
bash ~/notehost-vault/push.sh report.md     # one-off push
```

## How it works

Each script is a small wrapper around `curl`. It loads `NOTES_URL` and `NOTES_TOKEN`, checks that the tools it needs are installed, and calls the notehost.net HTTP API with an `Authorization: Bearer` header.

| Script | Request |
|---|---|
| `push.sh`, `init.sh` | `POST` to `NOTES_URL` with the Markdown body and an `X-Note-Name` header |
| `upload.sh` | `PUT /notes/<name>` with the file as the body |
| `list.sh` | `GET /notes`, with an optional `?prefix=` filter |
| `pull.sh` | `GET /notes` to list note names, then `GET /notes/<name>` for each one |
| `mv.sh` | `POST /move` with `X-From` and `X-To` headers |
| `rm.sh` | `DELETE /notes/<name>` |

For `push.sh`, the server stores the processed result under the original file name and returns it, and the script saves that response as `<name>_notes.md`. `init.sh` sends files the same way but saves each response into `markdownvault/`. It skips any file that already has a copy in `markdownvault/`, matched either by its file name or by `<name>_notes.md`.

Failed requests are reported on stderr with their HTTP status code. `push.sh`, `pull.sh` and `init.sh` exit with the number of files that failed, and `upload.sh`, `mv.sh` and `rm.sh` exit with status 1 on failure.

The notehost.net server is not part of this repository.

## The vault

`markdownvault/` contains 112 interlinked Markdown files of Haskell functional programming revision notes, organised around recognising a question type, finding the matching template and adapting it. Start with `markdownvault/INDEX.md`. `HOW-TO-USE.md` explains the layout, `NAVIGATION.md` is an alphabetical index, and `ONE-PAGE.md` is a single-screen summary.

## Project structure

```text
notehost-vault/
├── .env.example       Template for .env (NOTES_URL, NOTES_TOKEN)
├── init.sh            JupyterLab set-up and batch send into markdownvault/
├── push.sh            Send files for processing
├── upload.sh          Upload a file as-is
├── pull.sh            Download notes into NOTESPULLED/
├── list.sh            List notes on the server
├── mv.sh              Rename or move a note
├── rm.sh              Delete a note
└── markdownvault/     Haskell revision notes
    ├── archetypes/    Common exam question types
    ├── examples/      Worked examples and mock questions
    ├── interpreters/  Expression evaluators and interpreters
    ├── monads/        Maybe, Either, State, Reader, Writer, IO, list, free and other monads
    ├── patterns/      Recursion, folds, traversals and other patterns
    ├── templates/     Reusable code skeletons
    └── typeclasses/   Eq, Ord, Num, Functor, Applicative, Monad, Alternative and custom instances
```
