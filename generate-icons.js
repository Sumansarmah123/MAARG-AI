// Simple icon generator for PWA
// Run: node generate-icons.js

const fs = require('fs');
const { createCanvas } = require('canvas');

const sizes = [72, 96, 128, 144, 152, 192, 384, 512];

console.log('Generating PWA icons...\n');
console.log('Note: This requires "canvas" package. Install with: npm install canvas');
console.log('Alternative: Use the create-icons.html file in public folder\n');

try {
  sizes.forEach(size => {
    const canvas = createCanvas(size, size);
    const ctx = canvas.getContext('2d');

    // Background gradient (simulated with solid color)
    ctx.fillStyle = '#FF6B00';
    ctx.fillRect(0, 0, size, size);

    // Border
    ctx.strokeStyle = '#FFB800';
    ctx.lineWidth = size * 0.02;
    ctx.strokeRect(0, 0, size, size);

    // Text
    ctx.fillStyle = '#FFFFFF';
    ctx.font = `bold ${size * 0.35}px Arial`;
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('⚡', size/2, size/2 - size * 0.05);
    
    ctx.font = `bold ${size * 0.15}px Arial`;
    ctx.fillText('MAARG', size/2, size/2 + size * 0.25);

    // Save
    const buffer = canvas.toBuffer('image/png');
    fs.writeFileSync(`./public/icon-${size}x${size}.png`, buffer);
    console.log(`✓ Generated icon-${size}x${size}.png`);
  });

  console.log('\n✅ All icons generated successfully!');
} catch (error) {
  console.error('\n❌ Error generating icons:', error.message);
  console.log('\n📝 Alternative method:');
  console.log('1. Open maarg-ai-app/public/create-icons.html in your browser');
  console.log('2. Right-click each icon and save with the filename shown');
  console.log('3. Save all icons to maarg-ai-app/public/ folder');
}
