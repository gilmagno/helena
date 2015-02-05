use strict;
use warnings;

use Helena;

my $app = Helena->apply_default_middlewares(Helena->psgi_app);
$app;

