import Bun from "bun";
import { unlinkSync } from "node:fs";

const input = await Bun.file("./input.txt").text();
const inputLines = input.trim().split("\n");

const outputPath = "./output.txt";
const outputFile = Bun.file(outputPath);
if (await outputFile.exists()) unlinkSync(outputPath);
const output = outputFile.writer();

let linesProcessed = 0;
let errorLines: string[] = [];
let sum = 0;

const numberConversionTable = {
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9,
  "1": 1,
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
};

// Loop over lines of text in the input and get the first and last numbers on each line.
// Converts typed out numbers: "oneight" -> 18
// Combine the first and last number to create the calibration number
// Add the calibration number to the sum of all the calibration numbers
for (let i = 0, len = inputLines.length; i < len; i++) {
  const line = inputLines[i];
  const lineNumber = i + 1;

  let foundNumbers: { index: number; number: number }[] = [];

  // Get all valid numbers from the line and add them to the foundNumbers array
  for (const numString in numberConversionTable) {
    let lineIndex = 0;

    while (lineIndex < line.length) {
      const numIndex = line.indexOf(numString, lineIndex);

      if (numIndex === -1) break;

      lineIndex = numIndex + numString.length;

      foundNumbers.push({
        index: numIndex,
        number:
          numberConversionTable[
            numString as keyof typeof numberConversionTable
          ],
      });
    }
  }

  const numbers = foundNumbers
    .toSorted((a, b) => a.index - b.index)
    .map((o) => o.number);

  output.write(`Line number:\t\t\t ${lineNumber}\n`);
  output.write(`Line:\t\t\t\t\t\t\t ${line}\n`);
  output.write(`Parsed numbers:\t\t ${numbers.join(", ")}\n`);

  // Input data has to be in the correct format
  if (!numbers.length) {
    errorLines.push(`\t${lineNumber}: ${line || "Empty line"}`);
    console.log();
    continue;
  }

  const combinedNumbers = Number(`${numbers[0]}${numbers.at(-1)}`);

  output.write(`Combined numbers:\t ${combinedNumbers}\n\n`);

  sum += combinedNumbers;
  linesProcessed++;
}

console.log(`Sum of numbers:\t\t`, sum);
console.log(`Lines processed:\t`, linesProcessed, "/", inputLines.length);
console.log(
  `Lines with errors:`,
  errorLines.length ? `\n${errorLines.join(",\n")}` : "\t none"
);

output.write("------------------------------\n\n");
output.write(`Sum of numbers:\t\t ${sum}\n`);
output.write(`Lines processed:\t ${linesProcessed} / ${inputLines.length}\n`);
output.write(
  `Lines with errors: ${
    errorLines.length ? `\n${errorLines.join(",\n")}` : "\t none"
  }`
);

output.end();
