use std::{fs, io::Write};

struct Floor {
    current: i16,
    basement_entered: u32,
    up: char,
    down: char,
}

fn main() {
    let mut floor = Floor {
        current: 0,
        basement_entered: 0,
        down: ')',
        up: '(',
    };

    let input_file = fs::read_to_string("./input.txt")
        .expect("Read input file");

    let mut output_file = fs::OpenOptions::new()
        .create(true)
        .write(true)
        .append(true)
        .open("./output.txt")
        .expect("Open output file");

    read_input(&input_file, &mut output_file, &mut floor);

    println!("Ended up on floor:\t {}", floor.current);

    let basement_entered = if floor.basement_entered == 0 {
        "never".to_string()
    } else {
        "".to_string()
            + &(floor.basement_entered + 1).to_string()
    };

    println!("Basement entered:\t {}", basement_entered);
}

fn read_input(
    input: &String,
    output_file: &mut fs::File,
    floor: &mut Floor,
) {
    for (i, character) in input.chars().enumerate() {
        let change = get_output(&character, floor);

        if change.len() == 0 {
            continue;
        }

        if floor.basement_entered == 0
            && floor.current == -1
        {
            floor.basement_entered = i as u32;
        }

        write_output(output_file, &floor, change);
    }
}

fn get_output(
    data: &char,
    floor: &mut Floor,
) -> &'static str {
    let result: &str;
    if *data == floor.up {
        floor.current += 1;
        result = "up";
    } else if *data == floor.down {
        floor.current -= 1;
        result = "down";
    } else {
        result = "";
    }

    return result;
}

fn write_output(
    output_file: &mut fs::File,
    floor: &Floor,
    change: &str,
) {
    let output = "Change direction:\t ".to_string()
        + change
        + "\nCurrent floor:\t\t "
        + &floor.current.to_string()
        + "\n\n";

    output_file
        .write(output.as_bytes())
        .expect("Write output");
}
