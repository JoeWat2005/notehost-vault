# How to Use This Vault — The User Manual

→ [← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md) · [ONE-PAGE](ONE-PAGE.md)

A friendly, no-fluff guide to extracting maximum value from this vault before and during the Functional Programming exam at Birmingham.

> **The big idea**: you won't *remember* answers in the exam — you'll *find* them. This vault is your second brain, organised so that *recognise → look up → adapt* takes under 5 minutes per question.

---

## 1. What this vault is

**A weaponised exam reference.** 110+ interlinked markdown files covering every topic from the Birmingham FP 2025/26 module, organised so you can find what you need in **under 30 seconds** during exam pressure.

It is NOT a textbook. It is a **lookup tool**.
- Each file is dense, code-first, prose-minimal
- Cross-linked so you never get stuck
- Every Tier-1 exam topic has its own dedicated file
- Mock test questions worked end-to-end
- Common bugs flagged with ⚠

---

## 2. The "weapon" mindset

Under exam time pressure, you have ~24 minutes per 10-mark question. You cannot afford to:
- Read theory
- Re-derive patterns from scratch
- Search blindly through lecture notes

You CAN afford to:
- Recognise the question type in 30 seconds
- Look up a known template in 60 seconds
- Adapt template to specific spec in 5 minutes
- Test mentally for edge cases in 2 minutes

**This vault is optimised for that workflow.**

---

## 3. Directory structure

```
markdownvault/
├── INDEX.md                       The master navigation hub
├── NAVIGATION.md                  Flat alphabetical list of every file
├── HOW-TO-USE.md                  ← you are here
├── ONE-PAGE.md                    Single-screen panic reference
├── exam-day-plan.md               Time budget + day-of strategy
│
├── (root files — high-frequency reference)
├── if-you-see-x.md                Phrase → pattern lookup tables
├── common-templates.md            20 copy-paste skeletons in one file
├── type-signature-decoder.md      Sig shape → which template
├── common-pitfalls.md             Bugs to avoid (kills marks)
├── tree-recursion.md              #1 archetype, every variant
├── mapm.md                        mapM/sequence/forM
├── functor.md                     Every Functor instance
├── state-monad.md                 get/put/modify/run
├── interpreter-extension.md       3-layer AST+parser+eval changes
├── list-comprehensions.md         Tier-1 lecture topic
├── higher-order-functions.md      Tier-1 lecture topic
├── prelude-cheatsheet.md          Every built-in function
├── data-list-char-cheatsheet.md   Focused library reference
├── ghci-tips.md                   :t, :i, :set +s, debugging
│
├── patterns/      (12)   Reusable code shapes (cons-rec, accumulator, etc.)
├── typeclasses/   (6)    Functor, Applicative, Monad, etc.
├── monads/        (11)   Maybe, Either, State, Writer, IO, Reader, etc.
├── interpreters/  (6)    Eval patterns + storage models
├── templates/     (13)   Pure copy-paste code skeletons
├── archetypes/    (21)   20 ranked exam-question shapes + priority matrix
└── examples/      (17)   Worked Mock Q + assignment solutions
```

---

## 4. The 5 key files (memorise these names)

If you only remember 5 files, remember these:

| File | Use it when |
|------|-------------|
| [if-you-see-x.md](if-you-see-x.md) | Question is in front of you — find the pattern |
| [common-templates.md](common-templates.md) | You know the pattern — need the skeleton |
| [type-signature-decoder.md](type-signature-decoder.md) | Only the type is given — guess the pattern |
| [common-pitfalls.md](common-pitfalls.md) | Before submitting — sanity check |
| [ONE-PAGE.md](ONE-PAGE.md) | Pure panic — the absolute essentials |

---

## 5. How a single file is structured

Every file follows this anatomy:

```
# Title

[← INDEX] · [↑ Category] · [NAVIGATION]     ← breadcrumb nav

One-line summary of what this file covers.

## Section 1: Concept
Brief intro (max 2 sentences).

```haskell
-- Always-runnable code template
```

## Section 2: Variations
Bullet list or table.

## ⚠ Pitfalls
- Specific bugs to avoid
- Edge cases that QuickCheck WILL find

## See also
[Related file 1](path) · [Related file 2](path)
```

**Conventions you'll see:**
- ⭐ to ⭐⭐⭐⭐⭐ = exam-probability rating
- ⚠ = pitfall / common bug
- 🔴 🟡 🟢 = severity (in `common-pitfalls.md`)
- `## §1.` numbered sections in long files like `common-templates.md` — refer to as "§3" in cross-links
- Code blocks are always Haskell unless tagged otherwise
- Tables for type-signature lookups (Ctrl+F friendly)

---

## 6. The 5-phase exam workflow

### Phase 0 — BEFORE you read the question
- Open INDEX.md in VS Code preview (Ctrl+Shift+V)
- Pin [if-you-see-x.md](if-you-see-x.md), [common-templates.md](common-templates.md), and [common-pitfalls.md](common-pitfalls.md) as tabs

### Phase 1 — READ (1 min)
- Read question slowly
- Note: the type signature, key phrases ("preserve structure", "may fail", etc.), Mock-Q-like patterns

### Phase 2 — RECOGNISE (1 min)
- Scan [if-you-see-x.md](if-you-see-x.md) for phrases matching the question
- Or scan [type-signature-decoder.md](type-signature-decoder.md) for the sig shape
- Identify the archetype number (1-20)

### Phase 3 — PULL TEMPLATE (1 min)
- Open the matching template from [common-templates.md](common-templates.md) section number
- OR open the archetype file for the specific traps

### Phase 4 — ADAPT (15-20 min)
- Copy template into editor
- Rename to spec types
- Add specific cases
- Handle base cases

### Phase 5 — VERIFY (3 min)
- Mental edge-case check: `[]`, `Empty`, `Nothing`, `0`, single-element
- Cross-check against [common-pitfalls.md](common-pitfalls.md)
- Run `presubmit.sh` before submitting

---

## 6½. Using the vault on vLab (JupyterLab)

vLab's JupyterLab opens `.md` files in source-editor mode by default, so clicking a link in a preview opens the next file as source (not preview). **Fix this once per account:**

In the vLab Terminal, run [`vlab-setup.sh`](vlab-setup.sh):
```bash
bash markdownvault/vlab-setup.sh
```
Or paste this directly:
```bash
mkdir -p ~/.jupyter/lab/user-settings/@jupyterlab/docmanager-extension && cat > ~/.jupyter/lab/user-settings/@jupyterlab/docmanager-extension/plugin.jupyterlab-settings << 'EOF'
{
    "defaultViewers": {
        "markdown": "Markdown Preview"
    }
}
EOF
```

Then **refresh the JupyterLab browser tab** (`Ctrl+R`). Every `.md` now opens in Preview by default — including link-followed files. Persists across sessions.

**Recommended vLab setup**: open the vault in JupyterLab on one monitor for reference, edit your `.hs` assignment file in vLab Terminal/editor on the other. Best of both: VS Code on local Windows works even better (see §7) if you have access.

## 7. VS Code preview tips

| Action | Shortcut |
|--------|----------|
| Open preview (side-by-side) | `Ctrl+K V` |
| Open preview (replace tab) | `Ctrl+Shift+V` |
| Jump to file | `Ctrl+P` then type filename |
| Search across all files | `Ctrl+Shift+F` |
| Follow link | `Ctrl+Click` |
| **Go back** to prior page | `Ctrl+Alt+-` |
| Go forward | `Ctrl+Alt+=` |
| Pin tab (won't auto-close) | `Ctrl+K Shift+Enter` |

**Recommended layout for exam**:
- Left half: editor with your `.hs` file
- Right half: preview of vault
- Pin 3-4 tabs of priority files

---

## 8. Search strategies

### "I know the function name"
- Use `Ctrl+P` → type name → it's almost certainly in [prelude-cheatsheet.md](prelude-cheatsheet.md)

### "I know the type signature shape"
- [type-signature-decoder.md](type-signature-decoder.md) → look up the shape in the relevant table

### "I have an English description"
- [if-you-see-x.md](if-you-see-x.md) → scan trigger phrases

### "I know the question is similar to a Mock Q"
- Jump directly to `examples/mock-q[1-5]-*.md`

### "I need a code template for X"
- [common-templates.md](common-templates.md) §1-20

### "I'm worried about edge cases"
- [common-pitfalls.md](common-pitfalls.md)

### "I want the conceptual overview"
- Pick a category README (e.g. [patterns/README.md](patterns/README.md))

---

## 9. Navigation (back-button-like)

Every file has this header right under the title:
```
→ [← INDEX] · [↑ Category] · [NAVIGATION]
```

- **`← INDEX`** — back to the master hub
- **`↑ Category`** — up to the directory README (e.g. all `patterns/` files listed)
- **`NAVIGATION`** — flat alphabetical jump-table

PLUS:
- **`Ctrl+Alt+-`** in VS Code = browser-style back button (your actual prior page)
- Every file ends with a "See also" line linking peer concepts

---

## 10. The day-of-exam plan

See [exam-day-plan.md](exam-day-plan.md) for the full breakdown. Quick version:
1. Scan all 5 Qs (5 min)
2. Easiest Q first (15-20 min each, hardest last)
3. Skip-and-return if stuck for >5 min
4. Stub unsolved Qs with `undefined` so file compiles
5. Final 15 min: re-check, run `presubmit.sh`

---

## 11. FAQ

**Q: I'm stuck on a question. What do I do first?**
A: [if-you-see-x.md](if-you-see-x.md). If that doesn't help, [type-signature-decoder.md](type-signature-decoder.md). If still nothing, write the type sig + base case stub and move on.

**Q: How do I know which monad to use?**
A: [monads/overview.md](monads/overview.md) has a decision table.

**Q: I forgot a Prelude function's signature.**
A: [prelude-cheatsheet.md](prelude-cheatsheet.md), Ctrl+F by name.

**Q: My code won't compile.**
A: [ghci-tips.md](ghci-tips.md) has common error → cause table.

**Q: I changed my type signature and now QuickCheck fails.**
A: The auto-marker matches EXACTLY. Copy from the template verbatim. See [common-pitfalls.md](common-pitfalls.md) "HIGH severity".

**Q: I have 5 minutes left and one question untouched.**
A: Open [ONE-PAGE.md](ONE-PAGE.md). Pick the closest template. Stub it. Submit.

**Q: The vault has a typo / wrong info.**
A: Trust the lecture notes / `MockTestSolutions.hs` over the vault. Open an issue mentally.

---

## 12. Pre-exam practice (2-week plan)

**Week 1**: Read [archetypes/00-priority.md](archetypes/00-priority.md). For each Tier-1 archetype, do the worked Mock Q.

**Week 2**: Do Mock test cold. Mark with `MockTestSolutions.hs`. Identify weak spots → revisit those archetype files.

**Day before**: Skim [common-pitfalls.md](common-pitfalls.md) and [ONE-PAGE.md](ONE-PAGE.md). Sleep.

**Day of**: Run [exam-day-plan.md](exam-day-plan.md).

---

## 13. The mindset

You will not "know" answers from memory. You will **find** them. The vault is your second brain. Trust it.

If you can:
1. Recognise the archetype
2. Find the template
3. Adapt it carefully
4. Verify edge cases

...you will pass. 35+ marks = 1st class.

## See also
- [INDEX](INDEX.md) — master hub
- [NAVIGATION](NAVIGATION.md) — flat file list
- [ONE-PAGE](ONE-PAGE.md) — single-screen reference
- [exam-day-plan](exam-day-plan.md) — time budget
