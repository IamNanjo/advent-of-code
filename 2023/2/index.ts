import Bun from "bun";

import parseGames from "./parseGames";

const input = await Bun.file("./input.txt").text();
const inputLines = input.trim().split("\n");

const totalCubeCounts = {
  red: 12,
  green: 13,
  blue: 14,
};

const games = parseGames(inputLines);

let sum = 0;

for (const [gameId, gameResults] of Object.entries(games)) {
  let gameIsValid = true;
  for (const [cubeColor, cubeCount] of gameResults) {
    if (cubeCount > totalCubeCounts[cubeColor as keyof typeof totalCubeCounts])
      gameIsValid = false;
  }
  if (gameIsValid) sum += Number(gameId);
}

console.log("sum :>> ", sum);
