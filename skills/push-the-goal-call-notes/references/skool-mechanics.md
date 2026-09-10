# Skool mechanics

Community: Push The Goal Soccer (skool.com/pushthegoal), logged in as Izi Murray. Confirmed working 2026-08-21.

Navigating to `skool.com/chats` redirects to the community feed — use the header icon instead.

## Opening a thread

1. Click the speech-bubble icon at the top right of the header. A "Chats" popup opens with a **Search users** box at the top.
2. Type the name, wait ~2s, click the row. A modal opens.
3. The expand icon in the modal header widens it, which makes long drafts far easier to read back.

The popup toggles closed if you click the icon while it's already open, so take a screenshot rather than assuming state.

## Sent vs. draft

In the Chats **list**, a row's preview text is the last *sent* message. An unsent draft never appears there. If the preview shows the opening line of a draft you wrote, it has been sent — do not edit or replace it.

## Typing a draft without sending it

**Plain Enter sends.** Never put a newline character inside a `type` action.

- Type each paragraph as its own `computer type` action.
- Use `computer key` with `shift+Return` for every line break; two in a row for a blank line.
- Do not press Enter at the end.
- Chain the whole thing with `browser_batch` — 30+ actions in one round trip works fine and is much faster.

To replace an existing draft: click into the composer, `ctrl+a`, `Delete`, then type the new one.

Skool **persists** unsent drafts (and attached file chips) per conversation — they survive closing the modal, switching threads, and a full page reload.

## Attaching a PDF

With the thread open, `find` "file input for attaching a document" and use `file_upload` with a path under `/mnt/user-data/outputs/`. It attaches as a pending "PDF • NNkb" chip without sending. **Do not click the paperclip** — that opens the native OS picker, which is a dead end. Attach *before* typing the draft.

## Marking a thread unread

Go to the Chats **list** (not the open thread), search the name, hover the row — a hollow circle appears on the far right. Click it and it becomes a solid blue dot, with the tooltip flipping to "Mark read".

**Gotcha that has bitten before:** the search filter resets between tool calls, so the row under your cursor can silently become a different person. This once marked Gabriel Barrales' thread unread by mistake. Do search → hover → screenshot in **one** `browser_batch`, confirm from the screenshot that the row shows the right name, then click the circle immediately. Verify the header badge count went up by one and the row now shows "(1)".

Do not reopen the thread afterward to check your work — opening marks it read again. If you do need to verify a draft, re-mark unread after closing.

## When the browser isn't cooperating

If screenshots fail with "Failed to deserialize params.clip.scale", or `read_page` reports "Viewport: 0x0", the Chrome window is minimized or off-screen. Nothing will render or click correctly. Ask Izi to bring Chrome to the front — do not try to type a draft blind.
