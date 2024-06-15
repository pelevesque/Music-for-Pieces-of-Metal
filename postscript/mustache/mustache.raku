use Template::Mustache;

my $stache = Template::Mustache.new: :from<./views>;
my $view = 'postscript';

my $page-w-inches = 6.5;
my $page-h-inches = 8.5;
my $ppi = 72;

my %page =
    w        => $page-w-inches * $ppi,
    h        => $page-h-inches * $ppi,
    w-inches => $page-w-inches,
    h-inches => $page-h-inches,
;

$stache.render($view, {
    showGuide => 'true',
    page => %page,
}).say;
