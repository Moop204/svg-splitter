# Obtain paths 
use warnings;

my $num_args = $#ARGV;
my $fcount = 0;
$FALSE = 0;
$TRUE = 1;
#while ($num_args >= 0) {
#    print "$num_args";
#    my $arg = shift @ARGV;
#    $num_args = $#ARGV;
#    
#}

my $file = $ARGV[0];
my $name = $ARGV[1];
open F, '<', $file or die "Could not open file '$file'.";
my $relevant;
@buf = ();
$check = $FALSE;

my $start = 0;
my $end = 0;
my $count = 0;

foreach my $line(<F>){
    $end = $end + 1;
    if ( $line =~ /<g/ ) {
#    if ( $line =~ /<path/ ) {
  #      print $line;

        $check = $TRUE;
        $start = $end;
    }
    if( $check ) {
 #       print $line;
        push @buf, $line;
    }
    if ( $check and $line =~ /<\/g>/ ) {
#    if ( $check and $line =~ /\/>/ ) {
#        print $line;
        if($#buf == -1) {
          last;
        }
        $check = $FALSE;
        assign_svg($count, @buf);
        $count = $count + 1;

        #`cat $tmpfile`; 
        #`inkview $tmpfile`;
#        print "display $tmpfile";
#        `display $tmpfile`;
#        print "Path Name: ";
#        my $name = <STDIN>;
#        $name = $count;
#        chomp $name;
        @buf = ();
    }
}

sub assign_svg {
    $count = shift @_;
    $buf = @_;
    $name = find_label($buf);
    my $nfile = "$name.svg";
    print "$nfile";
    open TMP, '>', $nfile or die "Could not open file '$nfile'.";
    print TMP header_file();
    #print (@buf);
    #print "start $start\n";
    #print "end $end\n";
    #print ("\n===================================================================\n");
    foreach my $bufline(@buf) {
      print TMP $bufline;
      print "$bufline";
    }
    $fcount += 1;
    print TMP footer_file();
    close TMP;
    #`sed -e '19iname=\"$name\"' $nfile`;
}

sub find_label {
    $buf = @_;
    foreach my $bufline(@buf) {
        if ($bufline =~ /inkscape:label=/) {
            my @parts = split /\"/, $bufline;
            return $parts[1];
        }
    }
    my $tmp = $fcount;
    $fcount += 1;
    return $tmp;
}

close F;

sub header_file {
    return
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<svg
    xmlns:osb=\"http://www.openswatchbook.org/uri/2009/osb\"
    xmlns:dc=\"http://purl.org/dc/elements/1.1/\"
    xmlns:cc=\"http://creativecommons.org/ns#\"
    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"
    xmlns:svg=\"http://www.w3.org/2000/svg\"
    xmlns=\"http://www.w3.org/2000/svg\"
    xmlns:sodipodi=\"http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd\"
    xmlns:inkscape=\"http://www.inkscape.org/namespaces/inkscape\"
    version=\"1.1\"
    id=\"svg2\"
    width=\"300\"
    height=\"300\"
    viewBox=\"0 0 5525.9999 3545\"
    sodipodi:docname=\"coloured-map.svg\"
>\n";
}

#    width=\"5526\"
#    height=\"3545\"

sub footer_file {
    return "</svg>";
}
