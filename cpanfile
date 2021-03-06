requires 'perl', '5.014';

requires 'App::Greple', '8.4004';
requires 'Getopt::EX', 'v1.19.1';
requires 'Getopt::EX::termcolor', '1.07';
requires 'File::Share';
requires 'Regexp::Assemble';

requires 'Text::VisualWidth::PP', '0.05';
requires 'Text::VisualPrintf', '3.02';

on 'develop' => sub {
    requires 'Data::Section', '0.200007';
    requires 'Data::Section::Simple', '0.07';
};

on 'test' => sub {
    requires 'Test::More', '0.98';
};

