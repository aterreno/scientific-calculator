import app from './app';

const port = 8012;

app.listen(port, () => {
  console.log(`Conversion Service starting on port ${port}`);
});
