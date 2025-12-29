import fs from 'fs/promises'
import path from 'path'
import { Zip } from 'zip-lib'

//
import exists from './exists'
;(async () => {
  const projectName = 'DuelingBatteries'
  const sourceDir = path.join(__dirname, '..', 'src')
  console.log(`Source directory: "${sourceDir}"`)
  const buildDir = path.join(__dirname, '..', 'build')
  console.log(`Build directory: "${buildDir}"`)

  // Ensure build directory wiped for clean starting state
  if (await exists(buildDir)) {
    console.log(`Removing build directory "${buildDir}"`)
    await fs.rm(buildDir, {
      recursive: true,
      force: true,
    })
  }

  const zipFilePath = path.join(buildDir, `${projectName}.zip`)
  await compress({
    input: sourceDir,
    output: zipFilePath,
  })

  await convertZipToWfs({
    input: zipFilePath,
    output: path.join(buildDir, `${projectName}.wfs`),
  })
})().catch((err) => {
  console.error(err)
  process.exitCode = 1
})

async function compress({ input, output }: { input: string; output: string }): Promise<undefined> {
  console.log(`Compressing "${input}" into "${output}"`)
  const zip = new Zip()

  const entries = await fs.readdir(input)

  for (const entry of entries) {
    const fullPath = path.join(input, entry)
    const stats = await fs.stat(fullPath)

    if (stats.isFile()) {
      zip.addFile(fullPath, entry)
    } else if (stats.isDirectory()) {
      zip.addFolder(fullPath, entry)
    }
  }

  await zip.archive(output)
}

async function convertZipToWfs({ input, output }: { input: string; output: string }): Promise<undefined> {
  console.log(`Converting ZIP "${input}" to WFS "${output}"`)

  // Read the zip file as raw bytes
  const zipBuffer = await fs.readFile(input)

  // Convert ASCII string to raw bytes
  const signature = Buffer.from('normal_watchface', 'ascii')

  // Concatenate zip + signature
  const wfsBuffer = Buffer.concat([zipBuffer, signature])

  // Write final .wfs file
  await fs.writeFile(output, wfsBuffer)

  // clean up temporary zip file
  await fs.unlink(input)
}
