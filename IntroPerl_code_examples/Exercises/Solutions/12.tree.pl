#! /usr/bin/env perl

use 5.020;
use warnings;
use experimental 'signatures';

# Build the tree...

my $root = new_node('root', 'beer');

my $daughter = insert_child( $root, $root->{ID}, new_node('rootsdottir', 'daughter')            );
               insert_child( $root, $root->{ID}, new_node('rootsen',     'son')                 );
my $son      = insert_child( $root, $root->{ID}, new_node('rootloki',    'tricksy adopted son') );

my $granddaughter = insert_child( $root, $daughter, new_node('Becky', 'grand-daughter') );
my $grandson      = insert_child( $root, $son,      new_node('bucky', 'grand-son #1')   );
                    insert_child( $root, $son,      new_node('lucky', 'grand-son #2')   );


# This shouldn't insert anything (and will terminate the program if it does)...
die if insert_child( $root, 666, new_node('Lucifer', 'the naughty one') );

# Search by ID...
say 'The whole tree...';          print_tree($root);
say "\nThe Loki tree...";         print_tree(find_by_ID($root, $son));
say "\nThe Becky tree...";        print_tree(find_by_ID($root, $granddaughter));
say "\nThe evil tree...";         print_tree(find_by_ID($root, 666));

# Search by name...
say "\nThe daughter tree(s)...";  print_tree($_) for find_by_name($root, 'rootsdottir');
say "\nThe Bucky tree(s)...";     print_tree($_) for find_by_name($root, 'bucky');
say "\nThe b???cky tree(s)...";   print_tree($_) for find_by_name($root, qr/b.*cky/i);
say "\nThe monkey tree(s)...";    print_tree($_) for find_by_name($root, qr/monkey/i);


# The implementation...

# Each node is an anonymous hash...
sub new_node ($name, $data) {
    state $next_ID = 1;
    return {
        ID       => $next_ID++,
        name     => $name,
        data     => $data,
        children => [],
    };
}

sub find_by_ID ($root_node, $ID) {

    # Return this node if this node matches the ID...
    return $root_node  if $root_node->{ID} == $ID;

    # Otherwise, recursively search the children (if any)...
    for my $child (@{$root_node->{children} // []}) {
        if (my $matched_node = find_by_ID($child, $ID)) {
            return $matched_node;
        }
    }

    # If the entire tree fails to match, return a failure indicator...
    return undef;
}

sub find_by_name ($root_node, $name) {
    # Return this node (if it matches) plus any matching child nodes...
    return (
        ($root_node->{name} =~ $name ? $root_node : ()),
        map { find_by_name($_, $name) } @{$root_node->{children}}
    );
}

sub print_tree ($root_node, $level = 0) {
    return if !$root_node;

    # Print this node...
    say '    ' x $level, sprintf( "[%d] '%s': %s", @{$root_node}{qw(ID name data)} );

    # Then recursively print the children (indenting them appropriately)...
    for my $child (@{$root_node->{children}}) {
        print_tree($child, $level+1);
    }
}


sub insert_child ($root_node, $parent_ID, $child_node) {

    # Locate the desired parent node (or report failure)...
    my $parent = find_by_ID($root_node, $parent_ID)
        or return undef;

    # Add the child to the parent's children...
    push @{$parent->{children}}, $child_node;

    # Return the child's ID (which will always be true)...
    return $child_node->{ID};
}

