import express from 'express';
import cors from 'cors';
import { Converter } from './converter';

const app = express();
const port = 8012;

app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

// Temperature conversion endpoint
app.post('/temperature', (req, res) => {
  try {
    const { value, from, to } = req.body;
    
    if (typeof value !== 'number' || typeof from !== 'string' || typeof to !== 'string') {
      return res.status(400).json({ error: 'Invalid parameters. Required: value (number), from (string), to (string)' });
    }
    
    const result = Converter.convertTemperature(value, from, to);
    console.log(`Temperature: ${value} ${from} = ${result} ${to}`);
    
    res.status(200).json({ result });
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    res.status(400).json({ error: errorMessage });
  }
});

// Length conversion endpoint
app.post('/length', (req, res) => {
  try {
    const { value, from, to } = req.body;
    
    if (typeof value !== 'number' || typeof from !== 'string' || typeof to !== 'string') {
      return res.status(400).json({ error: 'Invalid parameters. Required: value (number), from (string), to (string)' });
    }
    
    const result = Converter.convertLength(value, from, to);
    console.log(`Length: ${value} ${from} = ${result} ${to}`);
    
    res.status(200).json({ result });
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    res.status(400).json({ error: errorMessage });
  }
});

// Weight conversion endpoint
app.post('/weight', (req, res) => {
  try {
    const { value, from, to } = req.body;
    
    if (typeof value !== 'number' || typeof from !== 'string' || typeof to !== 'string') {
      return res.status(400).json({ error: 'Invalid parameters. Required: value (number), from (string), to (string)' });
    }
    
    const result = Converter.convertWeight(value, from, to);
    console.log(`Weight: ${value} ${from} = ${result} ${to}`);
    
    res.status(200).json({ result });
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    res.status(400).json({ error: errorMessage });
  }
});

app.listen(port, () => {
  console.log(`Conversion Service starting on port ${port}`);
});
