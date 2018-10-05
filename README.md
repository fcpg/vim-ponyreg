Ultra-Magic Regexps
--------------------

> Friendship is magic!

Wat iz?
--------
Vim supports magic, non-magic, very-magic and very-non-magic regexps.
This plugins provides a fifth mode, "ultra-magic".
Everything becomes magic, including letters and numbers.

Ultra-magic patterns are called "ponyregs".

Setup (optional)
-----------------
`noremap  <silent>  <Leader>F  :<C-u>call ponyreg#Search()<cr>`

Usage
------
Use the mapping above, or hit `<C-x>/` after entering a ponyreg.  
This works on cmdline and `/` or `?` searches.  
Hit `<C-x>u` to undo expansion.

*What's "ultra-magic"?*
- Everything is magic -- punctuation, letters, digits
- Eg. `w+`, `d*`
- Strings must be escaped with double quotes eg. `"foobar"`, or each char must be escaped individually eg. `\f\o\o\b\a\r`
- Strings also define a group; `"ab"+` will match `ab`, `abab`, `ababab` etc.
- Digits are turned into curly-multi ie. `w3` means `\w\{3}`, and `d2,4` is `\d\{2,4}`
- Minus (`-`) is the non-greedy version of `*`, so `"begin".-"end"` will only match the block with 'foo' in `begin foo end   begin bar end`
- `zs/ze` are turned into their special meaning.
- Capture groups can be recalled (inside the pattern) with dollar instead of backslash eg. `$1`, `$2` etc.

Advanced
---------
If there are several patterns on the cmdline, eg. `:g/d3s+w/s/"."d/./`, the
`<C-x>/` will expand the first pattern (that of `:global`), and you will be
left with the second one (that of `:s`). In that case, you can move cursor on the
closing pattern `/` char (here, the `/` just after the `d`) and hit `<C-x>/`.
The expansion will search backward for the opening `/`, and expand what's between.
No slash cannot appear inside the pattern to expand.

You can define the `g:pony_delim` option to use another single-byte char as a delimiter, instead of `/`.

Quality
--------
- POC
- Alpha
- WIP
- No warranty
- Use at own risk
- Rainbow hazard

Todo
-----
- Much more checking
- Commands for ponyreg-friendly `:s` or `:g`?
- More non-greedy syntax?
- Support for `@123<=`
- Support for POSIX named character classes eg. `[[:space:]]`

Licence
--------
[Attribution-ShareAlike 4.0 Int.](https://creativecommons.org/licenses/by-sa/4.0/)

