#!/usr/bin/perl

# simple perl script to restructure my home inventory closet data
# starting point is csv with box, category, sub category, item, color
# goal is to remove the word after the last comma in the item column and place it into the sub category column

use strict;
use warnings;
use Data::Dumper;

# open the local file
open my $fh1, '/Users/Katelynn/Documents/home_inventory/clothes_download.csv';

# loop through the original file
my $clothes_new = "box,category,sub_category,details,color\n";
while (my $line = <$fh1>) {
    next if $. == 1;                                                    # skip first line
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
        for (my $i = 0; $i < (scalar @arr_item) - 1; $i++) {
            $item .= $arr_item[$i] . ',';
        }
        chop $item;
        
        # get color bit
        $color = $arr[(scalar @arr - 1)];                               # last column is the color

        # clean up color bit
        $color =~ s/^\s+|\"|\s+$//g;                                    # remove leading spaces | remove double quotes | remove trailing spaces
    } else {                                                            # handle undefined items
        $category = $arr[2];                                            # move sub_category to category
        $item = '';
    }
    $clothes_new .= "$box,$category,$sub_category,\"$item\",$color\n";
}
close $fh1;

# create new local file and write the cleaned up data to it
open my $fh2, '>', '/Users/Katelynn/Documents/home_inventory/clothes_new.csv';
print $fh2 $clothes_new;
close $fh2;