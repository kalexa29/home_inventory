#!/usr/bin/perl

# simple perl script to restructure my home inventory closet data
# starting point is csv with box, category, sub category, item, color
# goal is to remove the word after the last comma in the item column and place it into the sub category column

use strict;
use warnings;
use Data::Dumper;

my $local_directory = '/Users/Katelynn/Documents/';                     # replace with local location of the repository

# open the local file
open my $fh1, $local_directory . 'home_inventory/clothes_download.csv'; 

# loop through the original file
my $clothes_new = "box,category,sub_category,details,color\n";          # header row for new file
while (my $line = <$fh1>) {
    next if $. == 1;                                                    # skip first line
#    next unless $line =~ /sheer/ && $line =~ /blouse/ && $line =~ /pale/;
    $line = lc $line;                                                   # make all letters lowercase for consistency
    my @arr = split/,/,$line;                                           # split the line into parts
    my $box = uc $arr[0];                                               # first bit is the box the item is in, also the only uppercase column
    my $category = $arr[1];                                             # second bit is the top level category
    my $sub_category = '';
    my $item;
    my $color = '';
    
    # get item bit
    ($item) = $line =~ /"(.*?)"/;
    
    if (defined $item) {
        my @arr_item = split/,/,$item;                                  # split the item column into parts
        $sub_category = substr @arr_item[(scalar @arr_item - 1)], 1;    # get the last piece of the item column and save it as the sub category

        # clean up item bit
        $item = '';
        for (my $i = 0; $i < (scalar @arr_item) - 1; $i++) {
            $item .= $arr_item[$i] . ',';
        }
        chop $item;
        
        # get color bit
        my $last_double_quote = 0;
        for (my $i = scalar @arr - 1; $i > 0; $i--) { 
            if ($arr[$i] =~ /\"/ && $i != scalar @arr - 1) {            # find last array index that has a double quote and isn't the last item in the array
                if ($arr[$i-1] =~ /\"/) {                               # for when item and color both had commas in them originally
                    if ($arr[$i] =~ /$sub_category/) {
                        $last_double_quote = $i;
                    } else {
                        $last_double_quote = $i - 1;
                    }
                } else {
                    $last_double_quote = $i;
                }
                last;
            }
        }
        for (my $i = $last_double_quote + 1; $i < scalar @arr; $i++) {  # use it as the starting place for the color part
            # clean up color bit
            $arr[$i] =~ s/^\s+|\"|\s+$//g;                              # remove leading spaces | remove double quotes | remove trailing spaces
            $color .= $arr[$i] . ", "; 
        }
        $color = substr $color, 0, length($color) - 2;
    } else {                                                            # handle undefined items
        $category = $arr[2];                                            # move sub_category to category
        $item = '';
    }
    $clothes_new .= "$box,$category,$sub_category,\"$item\",\"$color\"\n";
}
close $fh1;

# create new local file and write the cleaned up data to it
open my $fh2, '>', $local_directory . 'home_inventory/clothes_new_perl.csv';
print $fh2 $clothes_new;
close $fh2;