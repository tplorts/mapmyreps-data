const fs = require('fs')
const request = require('request-promise-native')

const congressDir = 'dist/congress'



function sourceUrl(filename) {
  return `https://theunitedstates.io/congress-legislators/${filename}`
}

const DataFiles = [
  'legislators-current',
  'committees-current',
  'committee-membership-current',
  'legislators-social-media',
].map(x => `${x}.json`)

async function get(filename) {
  return request({ url: sourceUrl(filename) })
}


async function saveCondensed(filename) {
  const sourceJson = await get(filename)
  const condensedJson = JSON.stringify(JSON.parse(sourceJson))
  const path = `${congressDir}/${filename}`
  return new Promise((resolve, reject) => {
    fs.writeFile(path, condensedJson, err => { if (err) { reject(err) } else { resolve() } })
  })
}

const writeAll = Promise.all(DataFiles.map(f => saveCondensed(f)))
writeAll.then(() => console.log('Done')).catch(err => console.error(err))
