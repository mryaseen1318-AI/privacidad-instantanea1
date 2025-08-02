const pkg = require('pkg');
const path = require('path');
const fs = require('fs-extra');

async function build() {
  try {
    console.log('Creating standalone executable...');
    
    // Create a temporary directory
    const tempDir = path.join(__dirname, 'temp-build');
    await fs.ensureDir(tempDir);
    
    // Copy necessary files
    await fs.copy(path.join(__dirname, 'privacidad-instantanea'), tempDir);
    
    // Create a simple package.json for the build
    const packageJson = {
      name: 'privacidad-standalone',
      version: '1.0.0',
      main: 'main.js',
      bin: 'main.js',
      pkg: {
        assets: ['**/*'],
        targets: ['node16-win-x64'],
        outputPath: 'dist'
      }
    };
    
    await fs.writeJson(path.join(tempDir, 'package.json'), packageJson, { spaces: 2 });
    
    // Install pkg if not already installed
    try {
      require.resolve('pkg');
    } catch {
      console.log('Installing pkg...');
      const { execSync } = require('child_process');
      execSync('npm install -g pkg', { stdio: 'inherit' });
    }
    
    // Build the executable
    console.log('Building executable (this may take a few minutes)...');
    const { execSync } = require('child_process');
    execSync('npx pkg . --targets node16-win-x64 --output "PrivacidadInstantanea.exe"', { 
      cwd: tempDir,
      stdio: 'inherit'
    });
    
    // Move the executable to the root directory
    await fs.move(
      path.join(tempDir, 'PrivacidadInstantanea.exe'),
      path.join(__dirname, 'PrivacidadInstantanea.exe'),
      { overwrite: true }
    );
    
    // Clean up
    await fs.remove(tempDir);
    
    console.log('Build complete! Run PrivacidadInstantanea.exe to start the application.');
    
  } catch (error) {
    console.error('Build failed:', error);
    process.exit(1);
  }
}

build();
