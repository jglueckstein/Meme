use Image::Magick;
use warnings;
use strict;
 
###### Configuration ######
my $fontpath = '/home/jon/Downloads/Anton-Regular.ttf';
 
 
###### Programs Go Here ######
 
my $line1 = "HAPPY BEST FRIENDS DAY";  ## Top line of meme
my $line2 = "BFF BFF BFF BFF BFF";  ## Bottom line of meme
my $template = "/home/jon/Downloads/Friends.jpg"; ## Uncaptioned meme file
my $outputfile = "/home/jon/Downloads/meme.jpg"; ## where to save the finished picture with meme overlayed
 
my $memefile = buildMeme($line1, $line2, $template, $outputfile );
print "Meme Created:\t" . $memefile . "\n";
 
 
###### Danger, Thar Be Dragons ######
 
sub buildMeme {
    my $toptext = shift;
    my $bottomtext = shift;
    my $memetemplate = shift;
    my $memesavepath = shift;   
     
    ## Read in uncaptioned meme
    my $memeimage = Image::Magick->new;
    $memeimage->Read( "$memetemplate" );
 
    ## get width of uncaptioned meme file and set caption width to 90% of width
    my $memeimagewidth  = $memeimage->Get('width');
    my $maxwidth = int($memeimagewidth*0.9);
 
    ## create new imagemagick object for the top line of text
    my $toptextimage = Image::Magick->new(size=>'3100x3100');
    $toptextimage->ReadImage('xc:transparent');
    $toptextimage->Set(background=>'transparent');
 
    ## create the outline for the top line in huge text
    $toptextimage->Annotate(
        text        => $toptext, 
        x           => 21, 
        y           => 101, 
        font        => $fontpath, 
        pointsize   => 100, 
        stroke      => '#000000', 
        strokewidth => 4, 
        antialias   => 'true', 
        fill        => '#000000');
 
    ## create the white fill for the top line in huge text
    $toptextimage->Annotate(
        text        => "$toptext", 
        x           => 20, 
        y           => 100, 
        font        => $fontpath, 
        pointsize   => 100, 
        antialias   => 'true', 
        fill        => '#FFFFFF'
    );
 
    ## remove extra empty space from around text
    $toptextimage->Trim();
 
    ## resize top line text image to 90% of meme width
    my $geom = $maxwidth . "x";
    $toptextimage->Resize(
        geometry=> $geom,
        filter=> 'catrom',
        blur=> 0.9
        );
 
    ## repeat for bottom line of text
     
    my $bottomtextimage = Image::Magick->new(size=>'3100x3100');
    $bottomtextimage->ReadImage('xc:transparent');
    $bottomtextimage->Set(background=>'transparent');
 
    $bottomtextimage->Annotate(
        text        => $bottomtext, 
        x           => 21, 
        y           => 101, 
        font        => $fontpath,
        pointsize   => 100, 
        stroke      => '#000000', 
        strokewidth => 4, 
        antialias   => 'true', 
        fill        => '#000000');
 
    $bottomtextimage->Annotate(
        text        => "$bottomtext", 
        x           => 20, 
        y           => 100, 
        font        => $fontpath,
        pointsize   => 100, 
        antialias   => 'true', 
        fill        => '#FFFFFF'
    );
 
    $bottomtextimage->Trim();
 
    $geom = $maxwidth . "x";
    $bottomtextimage->Resize(
        geometry=> $geom,
        filter=> 'catrom',
        blur=> 0.9
    );
 
    ## overlay top line of text on uncaptioned meme
    $memeimage->Composite(image=>$toptextimage, 
        compose=>'over', 
        y=>5, 
        gravity=>'North'
    );
     
    ## overlay bottom line of text on uncaptioned meme
    $memeimage->Composite(image=>$bottomtextimage, 
        compose=>'over', 
        y=>5, 
        gravity=>'South'
    );
     
    ## write out captioned meme file
    $memeimage->Write(filename=>$memesavepath, compression=>'None');
    return($memesavepath);
}
