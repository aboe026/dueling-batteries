import fs from 'fs/promises'

export default async function exists(filePath: string): Promise<boolean> {
  return new Promise((resolve) => {
    fs.access(filePath)
      .catch(() => resolve(false))
      .then(() => resolve(true))
  })
}
