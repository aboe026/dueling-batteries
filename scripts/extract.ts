import fs from 'fs/promises'
import path from 'path'
import * as zl from 'zip-lib'

//
import exists from './exists'
;(async () => {
  const projectName = 'DuelingBatteries'
  const sourceDir = path.join(__dirname, '..', 'src')
  console.log(`Source directory: "${sourceDir}"`)
  const buildDir = path.join(__dirname, '..', 'build')
  console.log(`Build directory: "${buildDir}"`)

  const wfsFilePath = path.join(buildDir, `${projectName}.wfs`)
  if (!(await exists(wfsFilePath))) {
    throw Error(`File "${wfsFilePath} does not exist. Did you run "npm run build" first?`)
  }

  const zipFilePath = path.join(buildDir, `${projectName}.zip`)
  if (await exists(zipFilePath)) {
    await fs.rm(zipFilePath, {
      force: true,
    })
  }

  await convertWfsToZip({
    input: wfsFilePath,
    output: zipFilePath,
  })

  await extract({
    input: zipFilePath,
    output: sourceDir,
  })
})().catch((err) => {
  console.error(err)
  process.exitCode = 1
})

async function convertWfsToZip({ input, output }: { input: string; output: string }): Promise<undefined> {
  console.log(`Converting WFS "${input}" to ZIP "${output}"`)
  const buffer = await fs.readFile(input)

  // WFS signature is always 16 ASCII bytes
  const SIGNATURE = 'normal_watchface'
  const signatureBytes = Buffer.from(SIGNATURE, 'ascii')

  // Validate the tail
  const tail = buffer.subarray(buffer.length - 16)
  if (!tail.equals(signatureBytes)) {
    throw new Error(`Invalid WFS signature. Expected "${SIGNATURE}" at end of file.`)
  }

  // Strip the signature → pure ZIP data
  const zipBuffer = buffer.subarray(0, buffer.length - 16)

  // Write temporary ZIP file
  await fs.writeFile(output, zipBuffer)
}

async function extract({ input, output }: { input: string; output: string }): Promise<undefined> {
  console.log(`Extracting "${input}" to "${output}"`)
  await zl.extract(input, output)

  // Clean up
  await fs.unlink(input)
}
