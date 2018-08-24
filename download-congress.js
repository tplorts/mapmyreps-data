const fs = require('fs')
const request = require('request-promise-native')

const congressDir = 'dist/congress'

function sourceUrl (filename) {
  return `https://theunitedstates.io/congress-legislators/${filename}`
}

const DataFiles = [
  'legislators-current',
  'committees-current',
  'committee-membership-current',
  'legislators-social-media'
].map(x => `${x}.json`)

async function get (filename) {
  return request({ url: sourceUrl(filename) })
}

async function fetchAndSaveCondensed (filename) {
  const sourceJson = await get(filename)
  const condensedJson = JSON.stringify(JSON.parse(sourceJson))
  const path = `${congressDir}/${filename}`
  return new Promise((resolve, reject) => {
    fs.writeFile(path, condensedJson, err => (err ? reject(err) : resolve()))
  })
}

const writeAll = Promise.all(DataFiles.map(fetchAndSaveCondensed))
writeAll.then(() => console.log('Done')).catch(console.error)
