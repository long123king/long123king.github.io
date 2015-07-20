use strict;
use warnings;
use Markdown;

my $md_file = shift @ARGV;
my $html_file = $md_file;
$html_file =~ s/(.*)\.md/$1\.html/;
my $title = $1;
#print $html_file;

my $prefix = <<EOF;
<!DOCCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>RRTITLE</title>
    <link rel="stylesheet" type="text/css" href="daniel_blog.css" />
</head>

<body>
EOF

$prefix =~ s/RRTITLE/$title/;

my $suffix = <<EOF;
</body>
</html>
EOF

open MD_HANDLE, "<".$md_file or die $!;
my @md_lines = <MD_HANDLE>;
my $md_input = join("\n", @md_lines);
close MD_HANDLE;

my $content = Markdown::Markdown($md_input);

my $html_content = $prefix.$content.$suffix;

open HTML_HANDLE, ">".$html_file or die $!;
print HTML_HANDLE $html_content;
close HTML_HANDLE;
