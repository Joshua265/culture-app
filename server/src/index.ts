import express from 'express';
import dotenv from 'dotenv';
import mongoose from 'mongoose';
import cors from 'cors';
import morgan from 'morgan';
import path from 'path';

import eventsRouter from './routes/events';
import imageRouter from './routes/images';

// Load environment variables from .env file
dotenv.config();

// Set up Express app
const app = express();

// Use CORS middleware
app.use(cors());

// Set up Morgan middleware
app.use(morgan('combined'));

// Parse JSON body
app.use(express.json());

// Set up routes
app.use('/events', eventsRouter);
app.use('/images', imageRouter);

// Connect to MongoDB database
mongoose
  .connect(process.env.MONGODB_URI!, {
    user: process.env.MONGO_USER,
    pass: process.env.MONGO_PASSWORD
  })
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

app.get('/', express.static(path.join(__dirname, './public')));
