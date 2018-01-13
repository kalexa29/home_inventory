#!/usr/bin/perl

use strict;
use warnings;

use IO::Prompt; # for replacing user input with a character
use Data::Dumper;
use DBI;

my $un = prompt("un: ", -e => '*'); # replace entered un with asterisk;
my $pw = prompt("pw: ", -e => '*'); # replace entered pw with asterisk

my $db_home_inventory = db_connect($un, $pw, 'home_inventory'); # connect to home_inventory db

populate();

sub populate {
    my $local_directory = '/Users/Katelynn/Documents/'; # replace with local location of the repository

    # open the local file
    open my $fh1, $local_directory . 'home_inventory/clothes_new_perl.csv'; 

    # read in csv
    my $category;
    my $sub_category;
    my $detail;
    my $color;
    
    while (my $line = <$fh1>) {
        next if $. == 1; # skip first line
        # good test cases
#        next unless 
#                $line =~ /beige and white/i || # no commas
#                $line =~ /P,clothes,shirt,"sleevless, scoop neck silk","purple, gold, white, and black print/i || # detail and color have commas
#                $line =~ /P,clothes,pants,"bootcut, business, for flats","light grey"/i || # detail has commas but color doesn't
#                $line =~ /P,clothes,blouse,\"3\/4 length sleeve\",\"bright pink, leopard print/i; # color has commas but detail doesn't
        my @arr = split /,/,$line;
        
        # get unique categories
        if ($arr[1] ne '') { 
            $category->{$arr[1]} = 1;
        }

        # get unique color collections
        my $c = '';
        if ((scalar @arr) == 5) { # if no commas
            $c = $arr[4];
        } else {
            # get index of last connecting double quote and comma and save as the color part
            my $result = index($line, '","', -1);
            $c = substr($line, ($result + 2));
        }
        $c =~ s/^\s+|\"|\s+$//g; # remove leading spaces | remove double quotes | remove trailing
        if ($c ne '') { 
            $color->{$c} = 1;
        }
        
        # sub_category to detail matrix
        # foreach category list all possible details
        
        # get unique sub_categories
        if ($arr[2] ne '') { 
            $sub_category->{$arr[2]} = 1;
        }
        
        # get details bit
        my ($d) = $line =~ /"(.*?)"/;
        my @arr_item = split/,/,$d; # split the item column into parts
        for (my $i = 0; $i < (scalar @arr_item) - 1; $i++) {
            $arr_item[$i] =~ s/^\s+|\"|\s+$//g; # remove leading spaces | remove double quotes | remove trailing spaces
            if ($arr_item[$i] ne '') {
                $detail->{$arr_item[$i]} = 1;
            }
        }
    }
    
    my $insert_ca = "insert into category (category_name) values ";
    foreach my $ca (sort keys %{$category}) {
        $insert_ca .= "('$ca'),";
    }
    chop $insert_ca;
    $db_home_inventory->do($insert_ca);
    
    my $insert_sc = "insert into sub_category (sub_category_name) values ";
    foreach my $sc (sort keys %{$sub_category}) {
        $insert_sc .= "('$sc'),";
    }
    chop $insert_sc;
    $db_home_inventory->do($insert_sc);
    
    my $insert_de = "insert into detail (detail_name) values ";
    foreach my $de (sort keys %{$detail}) {
        $insert_de .= "('$de'),";
    }
    chop $insert_de;
    $db_home_inventory->do($insert_de);
    
    my $insert_co = "insert into color (color_name) values ";
    foreach my $co (sort keys %{$color}) {
        $co =~ s/'/\\'/g;
        $insert_co .= "('$co'),";
    }
    chop $insert_co;
    $db_home_inventory->do($insert_co);
}


sub clean_detail {

}

sub clean_color {

}

# sub routine for connecting to a database
sub db_connect {
    my $un = shift;
    my $pw = shift;
    my $db = shift;
    my $link = DBI->connect(
       "DBI:mysql:database=$db;mysql_socket=/Applications/MAMP/tmp/mysql/mysql.sock",
        $un,
        $pw
    ) || die "Failed to connect to database '$db'";
    return $link;
}