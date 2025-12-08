# Interactive Image Coordinate Mapper - Setup Guide

## Overview
This tool allows you to upload fashion brand images and mark coordinates for interactive regions (watch, suit, boots, hat, etc.) that will be used in your iOS app.

## Setup Steps

### 1. Run Database Migrations
Create and apply migrations for the new models:

```bash
cd myshop2/myshop
python manage.py makemigrations image_editor
python manage.py migrate
```

### 2. Access the Tool
Navigate to the coordinate mapper in your browser:

```
http://your-domain/image-editor/interactive-mapper/
```

## How to Use

### Step 1: Upload Image
- Click or drag an image into the upload area
- Optionally enter a name for the image
- Supported formats: JPG, PNG, WEBP

### Step 2: Mark Coordinates
- Click anywhere on the image to mark a region
- Enter a label (e.g., "Watch", "Suit", "Boots", "Hat")
- Enter a region ID (e.g., "watch", "suit", "boots", "hat")
- Choose a color for the highlight
- Click on the image to place the marker

### Step 3: Save Coordinates
- Click "Save Coordinates" to store the regions in the database
- The coordinates are saved as percentages (0.0 to 1.0) for cross-device compatibility

### Step 4: Use in iOS App
- Fetch coordinates via API: `GET /image-editor/api/interactive/{image_id}/`
- The API returns regions with xPercent, yPercent, and other metadata
- Use these coordinates in your `InteractiveImageView` Swift component

## API Endpoints

### Upload Image
```
POST /image-editor/api/interactive/upload/
Content-Type: multipart/form-data

Fields:
- image: File
- name: String (optional)
```

### Save Regions
```
POST /image-editor/api/interactive/{image_id}/regions/
Content-Type: application/json

Body:
{
  "regions": [
    {
      "id": "watch",
      "label": "Watch",
      "xPercent": 0.75,
      "yPercent": 0.15,
      "color": "#3B82F6",
      "icon": "watch"
    }
  ]
}
```

### Get Image with Regions
```
GET /image-editor/api/interactive/{image_id}/
```

### List All Images
```
GET /image-editor/api/interactive/
```

### Delete Image
```
DELETE /image-editor/api/interactive/{image_id}/delete/
```

## Database Models

### InteractiveImage
- `name`: Optional name for the image
- `image`: Image file
- `created_at`: Creation timestamp
- `updated_at`: Last update timestamp

### InteractiveRegion
- `interactive_image`: Foreign key to InteractiveImage
- `region_id`: Unique identifier (e.g., "watch", "suit")
- `label`: Display name (e.g., "Watch", "Suit")
- `x_percent`: X coordinate (0.0 to 1.0)
- `y_percent`: Y coordinate (0.0 to 1.0)
- `width_percent`: Optional width
- `height_percent`: Optional height
- `color`: Hex color code
- `icon`: Icon identifier
- `order`: Display order

## Features

✅ Drag & drop image upload
✅ Click to mark coordinates
✅ Visual markers with colors
✅ Edit/delete regions
✅ Save to database
✅ Load existing images
✅ Recent images list
✅ Responsive design
✅ Beautiful modern UI

## Notes

- Coordinates are stored as percentages (0.0 to 1.0) for cross-device compatibility
- The tool automatically calculates percentages based on the displayed image size
- All coordinates work across different iPhone screen sizes
- Images are stored in `media/interactive_images/`

## Troubleshooting

If you see CSRF errors, make sure CSRF middleware is enabled in your Django settings.

If images don't load, check your `MEDIA_URL` and `MEDIA_ROOT` settings in `settings.py`.


