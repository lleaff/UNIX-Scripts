#!/usr/bin/env node

// Find commands names that don't compete with existing commands completion.

const { promisify } = require('util')
const exec = promisify(require('child_process').exec)

const alphabet = 'abcdefghijklmnopqrstuvxyz'.split('')

async function main() {
  const allCommands = new Set(
    (await exec('bash -c "compgen -A function -abck"')).stdout
      .split('\n')
      .filter(a => a)
      .map(command => command.slice(0, 2))
  )

  const toCheck = process.argv[2]
  if (toCheck) {

    const isAvailable = !allCommands.has(toCheck)
    console.log(isAvailable ? 'available' : 'not available')
    process.exit(isAvailable ? 0 : 1)

  } else {

    const combinations = alphabet
      .reduce((p, letter) => p
        .concat(alphabet.map(l => letter + l)), [])

    const results = combinations
      .filter(cm => !allCommands.has(cm))

    console.log(results.join(' '))
  }
}
main()
