import express from 'express';
import { Content } from '../models/Content';
import { Request, Response } from 'express';

const router = express.Router();

router.get('/', async (req: Request, res: Response) => {
  try {
    const contents = await Content.find();
    res.json(contents);
  } catch (err) {
    res.status(500).send('Server error');
  }
});

export default router;
