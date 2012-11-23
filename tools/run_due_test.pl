use Modern::Perl '2011';
use Tapper::Model 'model';

my $job = model('TestrunDB')->resultset('TestrunScheduling')->search({status => 'schedule'}, {order_by => {-desc => 'id'}})->first;


use Tapper::MCP::Child;

# (XXX) need to find a way to include log4perl into tests to make sure no
# errors reported through this framework are missed
my $string = "
log4perl.rootLogger           = INFO, root
log4perl.appender.root        = Log::Log4perl::Appender::Screen
log4perl.appender.root.stderr = 1
log4perl.appender.root.layout = SimpleLayout";
Log::Log4perl->init(\$string);

my @errors;
# my $mock_child = Test::MockModule->new('Tapper::MCP::Child');
# $mock_child->mock('wait_for_testrun',   sub { 0 });
# $mock_child->mock('report_mcp_results', sub { 0 });
# $mock_child->mock('handle_error', sub { my ($self, $error_msg, $error_comment) = @_;
#                                         push @errors, {msg => $error_msg,
#                                                        comment => $error_comment}
#                                 });
$job->host_id(2);
$job->update();
my $child = Tapper::MCP::Child->new($job->id);
my $error = $child->runtest_handling('einstein');
$job->mark_as_finished();
say STDERR $error;
