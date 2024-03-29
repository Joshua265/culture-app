import express from 'express';
import { Event, IEvent } from '../models/Event';

const router = express.Router();

// GET /events
// router.get('/', async (req, res) => {
//   try {
//     const events = await Event.find({});
//     res.json(events);
//   } catch (err) {
//     console.error(err);
//     res.status(500).send('Server error');
//   }
// });

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

// GET /events?city=Heilbronn&timeframe_start=2022-01-01T12:00:00.000Z&timeframe_end=2022-01-03T12:00:00.000Z
router.get('/', async (req, res) => {
  const { city, timeframe_start, timeframe_end, mediaCategory, title } =
    req.query;
  let query = {};
  if (title) {
    query = { ...query, title: title };
  }
  if (city) {
    query = { ...query, city: city };
  }
  if (timeframe_start && !timeframe_end) {
    query = {
      ...query,
      startTime: {
        $gte: Date.parse(timeframe_start as string)
      }
    };
  }
  if (timeframe_start && timeframe_end) {
    query = {
      ...query,
      startTime: {
        $gte: Date.parse(timeframe_start as string),
        $lte: Date.parse(timeframe_end as string)
      }
    };
  }
  if (mediaCategory) {
    query = { ...query, mediaCategory };
  }
  console.log(query);
  try {
    const events = await Event.find(query).sort({ datetime: 1 });
    res.json(events);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

router.get('/random/:city', async (req, res) => {
  const city = String(req.params.city);
  try {
    const randomEvents = await Event.aggregate([
      {
        $match: { city: city }
      },
      {
        $group: {
          _id: '$title',
          doc: { $first: '$$ROOT' }
        }
      },
      { $sample: { size: 3 } },
      { $replaceRoot: { newRoot: '$doc' } }
    ]);
    res.json(randomEvents);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

router.get('/search/:searchTerm', async (req, res) => {
  const searchTerm = String(req.params.searchTerm);
  const city = String(req.query.city);
  try {
    const events = await Event.aggregate([
      {
        $match: {
          $or: [
            { title: { $regex: searchTerm, $options: 'i' } },
            { description: { $regex: searchTerm, $options: 'i' } }
          ],
          city: city
        }
      },
      {
        $group: {
          _id: '$title',
          doc: { $first: '$$ROOT' }
        }
      },
      {
        $replaceRoot: { newRoot: '$doc' }
      }
    ]);
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
    city,
    location,
    startTime,
    endTime,
    prices,
    mediaCategory,
    imageId,
    description,
    bookedSeats,
    genres
  } = req.body;
  try {
    const event = new Event({
      title,
      city,
      location,
      startTime,
      endTime,
      prices,
      mediaCategory,
      imageId,
      description,
      bookedSeats,
      genres
    });
    await event.save();
    res.json(event);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

export default router;
