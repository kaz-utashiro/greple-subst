# NAME

subst - Greple module for text search and substitution

# VERSION

Version 2.05

# SYNOPSIS

greple -Msubst --dict _dictionary_ \[ options \]

    --check=[ng,ok,any,outstand,all]
    --select=N
    --linefold
    --stat
    --diff
    --diffcmd command
    --replace
    --create
    --[no-]warn-overlap
    --[no-]warn-include

# DESCRIPTION

This **greple** module supports search and substitution for text based
on dictionary file.

Dictionary file is given by **--dict** option and contains pattern and
correct string pairs.

    greple -Msubst --dict DICT

If the dictionary file contains following data:

    colou?r      color
    cent(er|re)  center

Then above command find first pattern which does not match to second
string, that is "colour" and "centre" in this case.

Field "//" in dictionary file is ignored, so this file can be written
like this:

    colou?r      //  color
    cent(er|re)  //  center

You can use same file by **greple**'s **-f** option and string after
"//" is ignored as a comment in that case.

    greple -f DICT ...

## Overlapped pattern

When the matched string is same or shorter than previously matched
string by another pattern, it is simply ignored (**--no-warn-include**
by default).  So, if you have to declare conflicted patterns, put the
longer pattern in front.

If the matched string overlaps with previously matched string, it is
warned (**--warn-overlap** by default) and ignored.

# OPTIONS

- **--check**=_ng_|_ok_|_any_|_outstand_|_all_|_none_

    Option **--check** takes argument from _ng_, _ok_, _any_,
    _outstand_, _all_ and _none_.

    With default value _outstand_, command will show information about
    correct and incorrect words only when incorrect word was found.

    With value _ng_, command will show information only about incorrect
    word.  If you want to get data for correct word, use _ok_ or _any_.

    Value _all_ and _none_ makes sense only when used with **--stat**
    option.

- **--select**=_N_

    Select _N_th entry from the dictionary.  Argument is interpreted by
    [Getopt::EX::Numbers](https://metacpan.org/pod/Getopt::EX::Numbers) module.  Range can be defined like
    **--select**=_1:3,7:9_.

- **--linefold**

    If the target data is folded in the middle of text, use **--linefold**
    option.  It creates regex patterns which matches string spread across
    lines.  Substituted text does not include newline, though.  Because it
    confuses regex behavior somewhat, avoid to use if possible.

- **--stat**
- **--with-stat**

    Print statistical information.  By default, it only prints information
    about incorrect words.  Works with **--check** option.

    Opiton **--with-stat** print statistics after normal output, while
    **--stat** print only statistics.

- **--subst**

    Substitute matched pattern to correct string.  Pattern without
    replacement string is not changed.

- **--diff**
- **--diffcmd**=_command_

    Option **-diff** produce diff output of original and converted text.

    Specify diff command name used by **--diff** option.  Default is "diff
    \-u".

- **--replace**

    Replace the target file by converted result.  Original file is renamed
    to backup name with ".bak" suffix.

- **--create**

    Create new file and write the result.  Suffix ".new" is appended to
    original filename.

- **--\[no-\]warn-overlap**

    Warn overlapped pattern.
    Default on.

- **--\[no-\]warn-include**

    Warn included pattern.
    Default off.

# LICENSE

Copyright (C) Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[https://github.com/kaz-utashiro/greple](https://github.com/kaz-utashiro/greple)

[https://github.com/kaz-utashiro/greple-subst](https://github.com/kaz-utashiro/greple-subst)

# AUTHOR

Kazumasa Utashiro
