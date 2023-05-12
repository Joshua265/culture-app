import express from 'express';
import { Event } from '../models/Event';

const router = express.Router();

// GET /events
router.get('/', async (req, res) => {
  try {
    const events = await Event.find({});
    res.json(events);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

// GET /events/:id
router.get('/:id', async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);
    if (!event) {
      return res.status(404).json({ msg: 'Event not found' });
    }
    res.json(event);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

// GET /events?start_time=2022-01-01T12:00:00.000Z
router.get('/', async (req, res) => {
  const { start_time } = req.query;
  try {
    const events = await Event.find({ startTime: start_time });
    res.json(events);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

// POST /events
router.post('/', async (req, res) => {
  const {
    title,
    location,
    startTime,
    endTime,
    prices,
    mediaCategory,
    contentId,
    imageUrl,
    description
  } = req.body;
  try {
    const event = new Event({
      title,
      location,
      startTime,
      endTime,
      prices,
      mediaCategory,
      contentId,
      imageUrl,
      description
    });
    await event.save();
    res.json(event);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

// PUT /events/:id
router.put('/:id', async (req, res) => {
  const {
    title,
    location,
    startTime,
    endTime,
    prices,
    mediaCategory,
    contentId,
    imageUrl,
    description
  } = req.body;
  try {
    let event = await Event.findById(req.params.id);
    if (!event) {
      return res.status(404).json({ msg: 'Event not found' });
    }
    event.title = title || event.title;
    event.location = location || event.location;
    event.startTime = startTime || event.startTime;
    event.endTime = endTime || event.endTime;
    event.prices = prices || event.prices;
    event.mediaCategory = mediaCategory || event.mediaCategory;
    event.contentId = contentId || event.contentId;
    event.imageUrl = imageUrl || event.imageUrl;
    event.description = description || event.description;
    await event.save();
    res.json(event);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

export default router;
