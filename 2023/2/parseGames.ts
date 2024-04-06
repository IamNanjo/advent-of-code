type GameResult = [string, number];
interface Games {
  [gameId: string]: GameResult[];
}

export default (input: string[]): Games => {
  const games: Games = {};

  for (const line of input) {
    const [gameIdString, cubesString] = line.split(":");
    const gameId = gameIdString.split(" ")[1];
    games[gameId] = [];

    for (const reveals of cubesString.split(";")) {
      const parsedReveals = reveals.trim().split(", ");

      let gameResult: GameResult[] = [];

      for (const reveal of parsedReveals) {
        const [cubeCount, cubeColor] = reveal.split(" ");
        gameResult.push([cubeColor, Number(cubeCount)]);
      }

      games[gameId].push(gameResult);
    }

    console.log(`games :>> `, games);
  }

  return games;
};
