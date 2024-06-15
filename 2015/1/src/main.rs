use std::{fs, io::Write};

struct Floor {
    current: i16,
    up: char,
    down: char,
}

fn main() {
    let mut floor = Floor {
        current: 0,
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

    for character in input_file.chars() {
        let change = get_output(&character, &mut floor);

        if change.len() == 0 {
            continue;
        }

        write_output(&mut output_file, &floor, change);
    }

    println!("Ended up on floor {}", floor.current);
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
