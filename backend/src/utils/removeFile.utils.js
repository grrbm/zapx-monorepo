import fs from 'fs';

const removeFiles = (file) => {
  if (file) {
    fs.unlink(`${file?.url}`, (err) => {
      if (err) {
        console.error('Error deleting file:', err);
      }
    });
  }
};

export { removeFiles };
