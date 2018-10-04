Ultra-Magic Regexps
--------------------

> Friendship is magic!

Setup
------
`noremap  <silent>  <Leader>F  :<C-u>call ponyreg#Search()<cr>`

Usage
------
- Everything is magic -- punctuation, letters, digits
- Eg. `w+`, `d*`
- Strings can be escaped with double quotes eg. `"foobar"`
- Strings define a group; `"ab"+` will match `ab`, `abab`, `ababab` etc.
- Digits are turned into curly-multi ie. `w3` means `\w\{3}`, and `d2,4` is `\d\{2,4}`
- Minus (`-`) is the non-greedy version of `*`, so `"begin".-"end"` will only match the block with 'foo' in `begin foo end   begin bar end`
- `zs/ze` are turned into their special meaning.
- Capture groups can be recalled with dollar instead of backslash eg. `$1`, `$2` etc.

Quality
--------
- POC
- Alpha
- WIP
- No warranty
- Use at own risk

Todo
-----
- Much more checking
- Substitution, `:global`
- More non-greedy syntax?
- `\%`+num eg. `\%23l`
- POSIX named character classes eg. `[[:space:]]`
