# WRO — Western Romance Keyboard

This layout covers the diacritics and punctuation needed for **Catalan, French, Italian, Occitan, Portuguese, and Spanish**, layered on top of a standard US QWERTY keyboard.

## General Principles

- **Base layout**: everything that isn't mentioned below behaves exactly like US QWERTY.
- **Dead keys**: `'`, `` ` ``, `^` (Shift+6), `"` (Shift+`'`), and `~` (Shift+`` ` ``) are dead keys. Press one, then a letter, to produce a precomposed accented letter (e.g. `'` then `e` gives `é`).
- **AltGr** (Right Alt or Ctrl+Left Alt): gives access to additional letters, ligatures, and punctuation not available on the base US layout.
- **AltGr + Shift**: gives access to a second tier of additional characters, generally chosen to visually or semantically correlate with what's on the base/AltGr key (e.g. `¡` sits on Shift+AltGr+1, next to `!`).
- Where a language needs a character not covered by a dead key above, the AltGr layer also exposes the raw **combining diacritics** — see [Combining Diacritics](#combining-diacritics-altgr) below for how those differ from the dead keys.

## Accented Letters (Dead Keys)

These keys don't type anything by themselves — press the dead key first, then the letter to accent. Pressing the dead key followed by itself or Space types the bare accent mark.

| Dead Key | Type after | Result |
|---|---|---|
| `'` (acute) | `a e i o u c` / `A E I O U C` | `á é í ó ú ç` / `Á É Í Ó Ú Ç` |
| `` ` `` (grave) | `a e i o u` / `A E I O U` | `à è ì ò ù` / `À È Ì Ò Ù` |
| `^` (Shift+6, circumflex) | `a e i o u` / `A E I O U` | `â ê î ô û` / `Â Ê Î Ô Û` |
| `"` (Shift+`'`, diaeresis) | `e i u y` / `E I U Y` | `ë ï ü ÿ` / `Ë Ï Ü Ÿ` |
| `~` (Shift+`` ` ``, tilde) | `a o n` / `A O N` | `ã õ ñ` / `Ã Õ Ñ` |

Note the acute dead key also produces `ç`/`Ç` from `c`/`C` — there's no separate cedilla key, so it piggybacks on the closest available accent.

## Additional Characters (AltGr)

| Key | AltGr | AltGr + Shift |
|---|---|---|
| `1` | *(none)* | `¡` inverted exclamation mark |
| `3` | *(none)* | `№` numero sign |
| `4` | *(none)* | `€` euro sign |
| `0` | `º` masculine ordinal indicator | `ª` feminine ordinal indicator |
| `-` | `—` em dash | *(none)* |
| `[` | `«` left guillemet | `‹` single left guillemet |
| `]` | `»` right guillemet | `›` single right guillemet |
| `;` | `´` acute accent (spacing) | *(none)* |
| `.` | `·` interpunct (e.g. Catalan `l·l`) | *(none)* |
| `/` | *(none)* | `¿` inverted question mark |
| `a` | `æ` | `Æ` |
| `c` | `ç` | `Ç` |
| `o` | `œ` | `Œ` |
| `s` | `ß` | `ẞ` |

### Spaces

| Shortcut | Result |
|---|---|
| Shift + Space | No-break space (U+00A0) |
| AltGr + Space | Narrow no-break space (U+202F) |

These are especially relevant for French punctuation. Shift + Space is easier to access but it's not clear which should have preference over the other. Perhaps those with more knowledge on French typographical conventions can chime in here.

## Combining Diacritics (AltGr)

The `'`, `` ` ``, and `^` keys also expose their accent as a raw Unicode **combining** character on the AltGr layer parallel to the normal dead key. Unlike dead keys these do not wait for the following letter. Instead, they combine with **whatever character precedes them**, so type the base letter **first**, then press the shortcut to attach the accent (e.g. `w` then `AltGr+'` renders as `ẃ`).

Use these when you need to accent a letter that has no dedicated precomposed key above.

| Combining Mark | Shortcut | Unicode |
|---|---|---|
| Combining Acute Accent | AltGr + `'` | U+0301 |
| Combining Grave Accent | AltGr + `` ` `` | U+0300 |
| Combining Circumflex Accent | AltGr + Shift + `6` | U+0302 |
| Combining Diaeresis | AltGr + Shift + `'` | U+0308 |
| Combining Tilde | AltGr + Shift + `` ` `` | U+0303 |
