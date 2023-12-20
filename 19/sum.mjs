import { readFileSync } from "node:fs"

const sum = readFileSync("./output.txt", "utf-8")
  .split("\n")
  .map(n => BigInt(n))
  .reduce((acc, n) => acc + n, 0n)

console.log(sum)
