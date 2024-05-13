[![Actions Status](https://github.com/kaz-utashiro/greple-subst/workflows/test/badge.svg)](https://github.com/kaz-utashiro/greple-subst/actions) [![MetaCPAN Release](https://badge.fury.io/pl/App-Greple-subst.svg)](https://metacpan.org/release/App-Greple-subst)
# NAME

subst - Greple module for text search and substitution

# VERSION

Version 2.35

# SYNOPSIS

greple -Msubst --dict _dictionary_ \[ options \]

    Dictionary:
      --dict      dictionary file
      --dictdata  dictionary data
      --dictpair  dictionary entry pair

    Check:
      --check=[ng,ok,any,outstand,all,none]
      --select=N
      --linefold
      --stat
      --with-stat
      --stat-style=[default,dict]
      --stat-item={match,expect,number,ok,ng,dict}=[0,1]
      --subst
      --[no-]warn-overlap
      --[no-]warn-include

    File Update:
      --diff
      --diffcmd command
      --create
      --replace
      --overwrite

# DESCRIPTION

This **greple** module supports check and substitution of text files
based on dictionary data.

Dictionary file is given by **--dict** option and each line contains
matching pattern and expected string pairs.

    greple -Msubst --dict DICT

If the dictionary file contains following data:

    colou?r      color
    cent(er|re)  center

above command finds the first pattern which does not match the second
string, that is "colour" and "centre" in this case.

In practice, the last two elements of a space-separated string are
treated as a pattern and a replacement string, respectively.

Dictionary data can also be written separated by `//` as follows:

    colou?r      //  color
    cent(er|re)  //  center

There must be spaces before and after the `//`.  In this format,
strings before and after it are treated as a pattern and replacement
string, rather than last two element.  Leading spaces and spaces
before and after `//` are ignored, but all other whitespace is valid.

You can use same file by **greple**'s **-f** option and string after
`//` is ignored as a comment in that case.

    greple -f DICT ...

Option **--dictdata** can be used to provide dictionary data in the
command line.

    greple -Msubst \
           --dictdata $'colou?r color\ncent(er|re) center\n'

Dictionary entry starting with a sharp sign (`#`) is a comment and
ignored.

Option **--dictpair** can be used to provide raw dictionary entries in
the command line.  In this case, no processing is done regarding
whitespace or comments.

    greple -Msubst \
           --dictpair 'colou?r' color \
           --dictpair 'cent(er|re)' center

## Overlapped pattern

When the matched string is same or shorter than previously matched
string by another pattern, it is simply ignored (**--no-warn-include**
by default).  So, if you have to declare conflicted patterns, place
the longer pattern earlier.

If the matched string overlaps with previously matched string, it is
warned (**--warn-overlap** by default) and ignored.

## Terminal color

This version uses [Getopt::EX::termcolor](https://metacpan.org/pod/Getopt%3A%3AEX%3A%3Atermcolor) module.  It sets option
**--light-screen** or **--dark-screen** depending on the terminal on
which the command run, or **TERM\_BGCOLOR** environment variable.

Some terminals (eg: "Apple\_Terminal" or "iTerm") are detected
automatically and no action is required.  Otherwise set
**TERM\_BGCOLOR** environment to #000000 (black) to #FFFFFF (white)
digit depending on terminal background color.

# OPTIONS

- **--dict**=_file_

    Specify dictionary file.

- **--dictdata**=_data_

    Specify dictionary data by text.

- **--dictpair** _pattern_ _replacement_

    Specify dictionary entry pair.  This option takes two parameters.  The
    first is a pattern and the second is a substitution string.

- **--check**=`outstand`|`ng`|`ok`|`any`|`all`|`none`

    Option **--check** takes argument from `ng`, `ok`, `any`,
    `outstand`, `all` and `none`.

    With default value `outstand`, command will show information about
    both expected and unexpected words only when unexpected word was found
    in the same file.

    With value `ng`, command will show information about unexpected
    words.  With value `ok`, you will get information about expected
    words.  Both with value `any`.

    Value `all` and `none` make sense only when used with **--stat**
    option, and display information about never matched pattern.

- **--select**=_N_

    Select _N_th entry from the dictionary.  Argument is interpreted by
    [Getopt::EX::Numbers](https://metacpan.org/pod/Getopt%3A%3AEX%3A%3ANumbers) module.  Range can be defined like
    **--select**=`1:3,7:9`.  You can get numbers by **--stat** option.

- **--linefold**

    If the target data is folded in the middle of text, use **--linefold**
    option.  It creates regex patterns which matches string spread across
    lines.  Substituted text does not include newline, though.  Because it
    confuses regex behavior somewhat, avoid to use if possible.

- **--stat**
- **--with-stat**

    Print statistical information.  Works with **--check** option.

    Option **--with-stat** print statistics after normal output, while
    **--stat** print only statistics.

- **--stat-style**=`default`|`dict`

    Using **--stat-style=dict** option with **--stat** and **--check=any**,
    you can get dictionary style output for your working document.

- **--stat-item** _item_=\[0,1\]

    Specify which item is shown up in stat information.  Default values
    are:

        match=1
        expect=1
        number=1
        ng=1
        ok=1
        dict=0

    If you don't need to see pattern field, use like this:

        --stat-item match=0

    Multiple parameters can be set at once:

        --stat-item match=number=0,ng=1,ok=1

- **--subst**

    Substitute unexpected matched pattern to expected string.  Newline
    character in the matched string is ignored.  Pattern without
    replacement string is not changed.

- **--\[no-\]warn-overlap**

    Warn overlapped pattern.
    Default on.

- **--\[no-\]warn-include**

    Warn included pattern.
    Default off.

## FILE UPDATE OPTIONS

- **--diff**
- **--diffcmd**=_command_

    Option **--diff** produce diff output of original and converted text.

    Specify diff command name used by **--diff** option.  Default is "diff
    \-u".

- **--create**

    Create new file and write the result.  Suffix ".new" is appended to
    original filename.

- **--replace**

    Replace the target file by converted result.  Original file is renamed
    to backup name with ".bak" suffix.

- **--overwrite**

    Overwrite the target file by converted result with no backup.

# DICTIONARY

This module includes example dictionaries.  They are installed share
directory and accessed by **--exdict** option.

    greple -Msubst --exdict jtca-katakana-guide-3.dict

- **--exdict** _dictionary_

    Use _dictionary_ flie in the distribution as a dictionary file.

- **--exdictdir**

    Show dictionary directory.

- **--exdict** jtca-katakana-guide-3.dict
- **--jtca-katakana-guide**

    Created from following guideline document.

        外来語（カタカナ）表記ガイドライン 第3版
        制定：2015年8月
        発行：2015年9月
        一般財団法人テクニカルコミュニケーター協会 
        Japan Technical Communicators Association
        https://www.jtca.org/standardization/katakana_guide_3_20171222.pdf

- **--jtca**

    Customized **--jtca-katakana-guide**.  Original dictionary is
    automatically generated from published data.  This dictionary is
    customized for practical use.

- **--exdict** jtf-style-guide-3.dict
- **--jtf-style-guide**

    Created from following guideline document.

        JTF日本語標準スタイルガイド（翻訳用）
        第3.0版
        2019年8月20日
        一般社団法人 日本翻訳連盟（JTF）
        翻訳品質委員会
        https://www.jtf.jp/jp/style_guide/pdf/jtf_style_guide.pdf

- **--jtf**

    Customized **--jtf-style-guide**.  Original dictionary is automatically
    generated from published data.  This dictionary is customized for
    practical use.

- **--exdict** sccc2.dict
- **--sccc2**

    Dictionary used for "C/C++ セキュアコーディング 第2版" published in
    2014.

        https://www.jpcert.or.jp/securecoding_book_2nd.html

- **--exdict** ms-style-guide.dict
- **--ms-style-guide**

    Dictionary generated from Microsoft localization style guide.

        https://www.microsoft.com/ja-jp/language/styleguides

    Data is generated from this article:

        https://www.atmarkit.co.jp/news/200807/25/microsoft.html

- **--microsoft**

    Customized **--ms-style-guide**.  Original dictionary is automatically
    generated from published data.  This dictionary is customized for
    practical use.

    Amendment dictionary can be found
    [here](https://github.com/kaz-utashiro/greple-subst/blob/master/share/ms-amend.dict).
    Please raise an issue or send a pull-request if you have request to update.

# JAPANESE

This module is originaly made for Japanese text editing support.

## KATAKANA

Japanese KATAKANA word have a lot of variants to describe same word,
so unification is important but it's quite tiresome work.  In the next
example,

    イ[エー]ハトー?([ヴブボ]ォ?)  //  イーハトーヴォ

left pattern matches all following words.

    イエハトブ
    イーハトヴ
    イーハトーヴ
    イーハトーヴォ
    イーハトーボ
    イーハトーブ

This module helps to detect and correct them.

# INSTALL

## CPANMINUS

    $ cpanm App::Greple::subst

# SEE ALSO

[https://github.com/kaz-utashiro/greple](https://github.com/kaz-utashiro/greple)

[https://github.com/kaz-utashiro/greple-subst](https://github.com/kaz-utashiro/greple-subst)

[https://github.com/kaz-utashiro/greple-update](https://github.com/kaz-utashiro/greple-update)

[https://www.jtca.org/standardization/katakana\_guide\_3\_20171222.pdf](https://www.jtca.org/standardization/katakana_guide_3_20171222.pdf)

[https://www.jtf.jp/jp/style\_guide/styleguide\_top.html](https://www.jtf.jp/jp/style_guide/styleguide_top.html),
[https://www.jtf.jp/jp/style\_guide/pdf/jtf\_style\_guide.pdf](https://www.jtf.jp/jp/style_guide/pdf/jtf_style_guide.pdf)

[https://www.microsoft.com/ja-jp/language/styleguides](https://www.microsoft.com/ja-jp/language/styleguides),
[https://www.atmarkit.co.jp/news/200807/25/microsoft.html](https://www.atmarkit.co.jp/news/200807/25/microsoft.html)

[文化庁 国語施策・日本語教育 国語施策情報 内閣告示・内閣訓令 外来語の表記](https://www.bunka.go.jp/kokugo_nihongo/sisaku/joho/joho/kijun/naikaku/gairai/index.html)

[https://qiita.com/kaz-utashiro/items/85add653a71a7e01c415](https://qiita.com/kaz-utashiro/items/85add653a71a7e01c415)

[イーハトーブ](https://ja.wikipedia.org/wiki/%E3%82%A4%E3%83%BC%E3%83%8F%E3%83%88%E3%83%BC%E3%83%96)

# AUTHOR

Kazumasa Utashiro

# LICENSE

Copyright 2017-2024 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
