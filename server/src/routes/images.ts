import express, { Request, Response, NextFunction } from 'express';
import multer from 'multer';
import path from 'path';
import { v4 as uu } from 'uuid';

const router = express.Router();

interface CustomRequest extends Request {
  file?: Express.Multer.File;
}

const storage = multer.diskStorage({
  destination: './uploads',
  filename: (
    req: Request,
    file: Express.Multer.File,
    cb: (arg0: null, arg1: string) => void
  ) => {
    const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
    const extension = path.extname(file.originalname);
    cb(null, `${uniqueSuffix}${extension}`);
  }
});
const upload = multer({ storage });

// POST /images/
router.post(
  '/',
  upload.single('image'),
  (req: CustomRequest, res: Response) => {
    try {
      if (!req.file) {
        return res.status(400).json({ msg: 'No image file uploaded' });
      }

      // Save the uploaded image details to your database if necessary
      const imageId = req.file.filename; // get image id from multer
      console.log(imageId);
      res.json({ imageId });
    } catch (err) {
      console.error(err);
      res.status(500).send('Server error');
    }
  }
);

// GET /images/:id
router.get('/:filename', (req: Request, res: Response) => {
  try {
    const { filename } = req.params;

    // Retrieve the image details from your database using the provided ID
    // Replace this with your logic
    const imageFilePath = `./uploads/${filename}`; // Example: path to the image file
    console.log(imageFilePath);
    console.log(path.resolve(imageFilePath));
    res.sendFile(path.resolve(imageFilePath));
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

export default router;
