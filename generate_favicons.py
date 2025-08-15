#!/usr/bin/env python3
"""
Favicon Generator Script

Generates favicon files from a source SVG with transparent backgrounds.
Removes background elements from SVG to ensure true transparency.

Dependencies:
- ImageMagick (system package: sudo apt install imagemagick)

Usage:
    python generate_favicons.py

Input: assets/icons/favicon.svg
Output: Various favicon sizes in docs/assets/favicons/ and docs/favicon.ico
"""

import os
import re
import subprocess
from pathlib import Path

def remove_background_from_svg(svg_content):
    """Remove background rect elements from SVG to ensure transparency."""
    # Remove rect elements that look like backgrounds
    svg_content = re.sub(r'<rect[^>]*style="fill:#[^"]*"[^>]*/>', '', svg_content)
    svg_content = re.sub(r'<rect[^>]*fill="[^"]*"[^>]*/>', '', svg_content)
    svg_content = re.sub(r'<rect[^>]*style="fill:#[^"]*"[^>]*>[^<]*</rect>', '', svg_content)
    svg_content = re.sub(r'<rect[^>]*fill="[^"]*"[^>]*>[^<]*</rect>', '', svg_content)
    return svg_content

def generate_favicon_from_svg(svg_path, output_dir, sizes):
    """Generate favicon files from SVG with transparent backgrounds using ImageMagick."""
    
    # Read the SVG file
    with open(svg_path, 'r') as f:
        svg_content = f.read()
    
    # Remove background elements for transparency
    svg_content = remove_background_from_svg(svg_content)
    
    # Write the modified SVG to a temporary file
    temp_svg = svg_path.parent / "favicon_transparent.svg"
    with open(temp_svg, 'w') as f:
        f.write(svg_content)
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    generated_files = []
    
    for size_name, size in sizes.items():
        output_path = os.path.join(output_dir, f"favicon-{size}x{size}.png")
        
        # Use ImageMagick to convert with transparent background
        cmd = [
            "convert",
            "-background", "transparent",
            str(temp_svg),
            "-resize", f"{size}x{size}",
            output_path
        ]
        
        try:
            subprocess.run(cmd, check=True, capture_output=True)
            generated_files.append(output_path)
            print(f"Generated: {output_path}")
        except subprocess.CalledProcessError as e:
            print(f"Error generating {output_path}: {e}")
    
    # Clean up temporary file
    if temp_svg.exists():
        temp_svg.unlink()
    
    return generated_files

def create_ico_file(favicon_dir, ico_path):
    """Create favicon.ico from PNG files."""
    png_32 = os.path.join(favicon_dir, "favicon-32x32.png")
    png_16 = os.path.join(favicon_dir, "favicon-16x16.png")
    
    if os.path.exists(png_32) and os.path.exists(png_16):
        cmd = ["convert", png_32, png_16, str(ico_path)]
        try:
            subprocess.run(cmd, check=True, capture_output=True)
            print(f"Generated: {ico_path}")
        except subprocess.CalledProcessError as e:
            print(f"Error generating ICO file: {e}")

def create_apple_touch_icon(favicon_dir):
    """Create apple-touch-icon.png from 180x180 PNG."""
    src = os.path.join(favicon_dir, "favicon-180x180.png")
    dst = os.path.join(favicon_dir, "apple-touch-icon.png")
    
    if os.path.exists(src):
        cmd = ["cp", src, dst]
        try:
            subprocess.run(cmd, check=True)
            print(f"Generated: {dst}")
        except subprocess.CalledProcessError as e:
            print(f"Error creating apple-touch-icon: {e}")

def main():
    # Paths
    script_dir = Path(__file__).parent
    svg_path = script_dir / "assets" / "icons" / "favicon.svg"
    favicon_dir = script_dir / "docs" / "assets" / "favicons"
    ico_path = script_dir / "docs" / "favicon.ico"
    
    # Favicon sizes to generate
    sizes = {
        "512": 512,
        "256": 256, 
        "192": 192,
        "180": 180,  # Apple touch icon
        "32": 32,
        "16": 16
    }
    
    print("Generating favicons with transparent backgrounds...")
    print(f"Source SVG: {svg_path}")
    print(f"Output directory: {favicon_dir}")
    
    if not svg_path.exists():
        print(f"Error: SVG file not found at {svg_path}")
        return
    
    # Generate PNG files
    generated_files = generate_favicon_from_svg(svg_path, favicon_dir, sizes)
    
    # Create apple-touch-icon.png
    create_apple_touch_icon(favicon_dir)
    
    # Create favicon.ico
    create_ico_file(favicon_dir, ico_path)
    
    print("\nFavicon generation complete!")
    print("All files generated with transparent backgrounds.")
    print("\nGenerated files:")
    for file_path in generated_files:
        print(f"  - {file_path}")

if __name__ == "__main__":
    main()