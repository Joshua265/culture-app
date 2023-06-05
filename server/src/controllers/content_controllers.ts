import express, { Request, Response } from 'express';
import { Content } from '../models/Content';

const router = express.Router();

// Get all content
router.get('/', async (req: Request, res: Response) => {
  try {
    const contents = await Content.find();
    res.json(contents);
  } catch (err: any) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
});

export default router;
