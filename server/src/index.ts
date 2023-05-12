import express from 'express';
import dotenv from 'dotenv';
import mongoose from 'mongoose';
import cors from 'cors';

import eventsRouter from './routes/events';
import contentRouter from './routes/content';

// Load environment variables from .env file
dotenv.config();

// Set up Express app
const app = express();

// Use CORS middleware
app.use(cors());

// Parse JSON body
app.use(express.json());

// Set up routes
app.use('/events', eventsRouter);
app.use('/content', contentRouter);

// Connect to MongoDB database
mongoose
  .connect(process.env.MONGODB_URI!, {})
  .then(() => {
    console.log('Connected to database');
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });

// Start server
const port = process.env.PORT || 5000;
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
