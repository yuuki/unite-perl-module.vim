# unite-perl-use.vim

unite-perl-use.vim is a plugin for [unite.vim](https://github.com/Shougo/unite.vim), which is a source for searching your installed CPAN module names.
It is inspired by [rhysd/unite-ruby-require.vim](https://github.com/rhysd/unite-ruby-require.vim).

## Usage

```vim
:Unite perl/use
```

## Notice
The performance of unite-perl-use.vim may be slow when you are in directories with many child ones like HOME directory.
This is because of the behavior of 'cpan -l', which is for listing up CPAN file.
'cpan -l' searches current directory recursively, so it may be slow.
It's no problem if you are widtin a project directory.
