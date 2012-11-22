use Tapper::MCP::Master;
use Tapper::Model 'model';
use Modern::Perl '2011';

my $testrun = model('TestrunDB')->resultset('Testrun')->new({
                                                             topic_name => 'debugging',
                                                            })->insert;

                                                            
my $job = model('TestrunDB')->resultset('TestrunScheduling')->new({
                                                                   testrun_id => $testrun->id,
                                                                   status     => 'schedule',
                                                                   host_id    => 1,
                                                                  })->insert;

say $job->host->name;
