import express, { Request, Response } from 'express';
import { Event } from '../models/Event';

const router = express.Router();

// Get all events
router.get('/', async (req: Request, res: Response) => {
  try {
    const events = await Event.find();
    res.json(events);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
});

// Get events by media category
router.get('/category/:mediaCategory', async (req: Request, res: Response) => {
  const { mediaCategory } = req.params;
  const { limit, skip } = req.query;

  try {
    const events = await Event.find({ mediaCategory })
      .skip(parseInt(skip as string))
      .limit(parseInt(limit as string));
    res.json(events);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
});

// Get events by content id
router.get('/content/:contentId', async (req: Request, res: Response) => {
  const { contentId } = req.params;

  try {
    const events = await Event.find({ contentId });
    res.json(events);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
});

// Get events by day
router.get('/day/:day', async (req: Request, res: Response) => {
  const { day } = req.params;

  try {
    const events = await Event.find({
      startTime: {
        $gte: new Date(day),
        $lt: new Date(new Date(day).getTime() + 24 * 60 * 60 * 1000)
      }
    });
    res.json(events);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
});

export default router;
