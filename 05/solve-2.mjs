import { readFileSync } from "node:fs";

function parseSeedRanges(seedBlock) {
  return [...seedBlock.matchAll(/(?<start>\d+) (?<length>\d+)/g)]
    .map(match => {
      const start = parseInt(match.groups.start);
      const end = start + parseInt(match.groups.length) - 1;
      return { start, end };
    });
}

function parseMappings(mappingBlocks) {
  return mappingBlocks.map(block => {
    const [_, ...mappingLines] = block.split('\n').filter(Boolean);

    const mapping = mappingLines.map(line => {
      const [ dstRangeStart, srcRangeStart, rangeLength ] = line.split(' ').map(n => parseInt(n));
      return {
        srcRange: {
          start: srcRangeStart,
          end: srcRangeStart + rangeLength - 1,
        },
        dstRangeStart,
      };
    });
    mapping.sort((a, b) => a.srcRange.start - b.srcRange.start);

    if (mapping[0].srcRange.start != 0) {
      mapping.unshift({
        srcRange: {
          start: 0,
          end: mapping[0].srcRange.start - 1,
        },
        dstRangeStart: 0,
      });
    }

    mapping.push({
      srcRange: {
        start: mapping.at(-1).srcRange.end + 1,
        end: Number.MAX_SAFE_INTEGER,
      },
      dstRangeStart: mapping.at(-1).srcRange.end + 1,
    });

    return mapping;
  });
}

function rangeIntersection(a, b) {
  if (a.start > b.end || b.start > a.end) {
    return null;
  }

  return {
    start: Math.max(a.start, b.start),
    end: Math.min(a.end, b.end),
  };
}

function applyMapping(inputRange, mapping) {
  const mapped = [];
  for (const m of mapping) {
    const intersection = rangeIntersection(inputRange, m.srcRange);
    if (intersection) {
      mapped.push({
        start: m.dstRangeStart + (intersection.start - m.srcRange.start),
        end: m.dstRangeStart + (intersection.end - m.srcRange.start),
      });
    }
  }
  return mapped;
}

function mapToLocationRanges(inputRanges, mappings) {
  const [currentMapping, ...restMappings] = mappings;
  const mapped = inputRanges.flatMap(inputRange => applyMapping(inputRange, currentMapping));

  if (restMappings.length > 0) {
    return mapToLocationRanges(mapped, restMappings);
  }

  return mapped;
}

function main() {
  const input = readFileSync(process.argv[2], "utf-8");
  const [ seedBlock, ...mappingBlocks ] = input.split("\n\n");

  const seedRanges = parseSeedRanges(seedBlock);
  const mappings = parseMappings(mappingBlocks);

  const locationRanges = mapToLocationRanges(seedRanges, mappings);
  locationRanges.sort((a, b) => a.start - b.start);

  console.log(locationRanges[0].start);
}

main();
