use std::fs;

struct Present {
    length: u16,
    width: u16,
    height: u16,
}

fn main() {
    let input_lines = read_file();

    let mut total_area: u32 = 0;

    for line in input_lines.iter() {
        let measurements = get_measurements(line);

        total_area +=
            calculate_needed_area(&measurements) as u32;
    }

    println!("{}", total_area);
}

fn read_file() -> Vec<String> {
    return fs::read_to_string("./input.txt")
        .expect("Read file")
        .trim()
        .split('\n')
        .map(|s| s.to_string())
        .collect();
}

fn get_measurements(input: &str) -> Present {
    let mut measurements = input.split('x').map(|s| {
        s.parse::<u16>()
            .expect("Parse measurement as unsigned integer")
    });

    return Present {
        length: measurements.next().expect("Length"),
        width: measurements.next().expect("Width"),
        height: measurements.next().expect("Height"),
    };
}

fn calculate_needed_area(present: &Present) -> u16 {
    let sides = (
        present.length * present.width,
        present.width * present.height,
        present.height * present.length,
    );

    let smallest_side =
        if sides.0 <= sides.1 && sides.0 <= sides.2 {
            sides.0
        } else if sides.1 <= sides.0 && sides.1 <= sides.2 {
            sides.1
        } else {
            sides.2
        };

    return 2 * sides.0
        + 2 * sides.1
        + 2 * sides.2
        + smallest_side;
}
