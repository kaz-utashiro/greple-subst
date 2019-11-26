# NAME

subst - Greple module for text substitution

# VERSION

Version 1.01

# SYNOPSIS

greple -Msubst \[ options \]

    --subst-file spec_file
    --subst-from string
    --subst-to   string

    --diff
    --diffcmd command
    --create
    --replace

# DESCRIPTION

This **greple** module supports word substitution in text data.

Substitution can be indicated by option **--subst-from** and
**--subst-to**, or specification file.

Next command replaces all string "FROM" to "TO".

    greple -Msubst --subst-from FROM --subst-to TO FROM

Of course, you should rather use **sed** in this case.  Option
**--subst-from** and **--subst-to** can be repeated, and substitution is
done in order.

Using **--subst-file** option, you can prepare these substitution list
in the file.  Suppose the file cotains following data:

    Monday     Mon.
    Tuesday    The.
    Wednesday  Wed.
    Thursday   Thu.
    Friday     Fri.
    Saturday   Sat.
    Sunday     Sun.

Next command converts day-of-week name to abbreviation form.

    greple -Msubst --subst-file SPEC '\b[A-Z][a-z]+' ...

Field "//" in spec file is ignored, so this file can be written like
this:

    Monday     //  Mon.
    Tuesday    //  The.
    Wednesday  //  Wed.
    Thursday   //  Thu.
    Friday     //  Fri.
    Saturday   //  Sat.
    Sunday     //  Sun.

You can use same file by **greple**'s **-f** option and string after
"//" is ignored as a comment in that case.

    greple -Msubst --subst-file SPEC -f SPEC ...

This is equivalent to search next pattern, and replace them.  This is
bad example, though.

    Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday   

Actually, it takes the second last field as a target, and the last
field as a substitution string.  All other fields are ignored.  This
behavior is useful when the pattern requires longer text than the
string to be converted.  See the next example:

    Black-\KMonday  // Monday  Friday

Pattern matches to string "Monday", but requires string "Black-" is
preceeding to it.  Substitution is done just for string "Monday",
which does not match to the original pattern.  As a matter of fact,
look-ahead and look-behind pattern is removed automatically, next
example works as expected.

    (?<=Black-)Monday  // Friday

Combining with **greple**'s other options, it is possible to convert
strings in the specific area of the target files.

- **--diff**

    Produce diff output of original and converted text.

- **--diffcmd** _command_

    Specify diff command name used by **--diff** option.  Default is "diff
    \-u".

- **--create**

    Create new file and write the result.  Suffix ".new" is appended to
    original filename.

- **--replace**

    Replace the target file by converted result.  Original file is renamed
    to backup name with ".bak" suffix.

# BUGS

This module is made for Japanese text processing, and it is difficult
to imagine the useful situation handling ascii.

# LICENSE

Copyright (C) Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[https://github.com/kaz-utashiro/greple-msdoc](https://github.com/kaz-utashiro/greple-msdoc)

# AUTHOR

Kazumasa Utashiro
