import db from '../../db.js';
import { removeFiles } from '../../utils/removeFile.utils.js';

const updateFile = async (req, res) => {
  try {
    const { fileId } = req?.params;
    const { file } = req.files;

    if (!fileId) {
      return res.status(400).json({ message: 'fileId is required!' });
    }

    if (file?.length === 0) {
      return res.status(400).json({ message: 'file is required!' });
    }

    const getFileById = await db.file.findFirst({
      where: {
        id: +fileId,
        deleted: false,
      },
    });

    if (getFileById) {
      removeFiles(getFileById);
      await db.file.update({
        where: {
          id: +getFileById.id,
        },
        data: {
          mimeType: file && file[0]?.mimetype,
          url: file && file[0]?.path,
        },
      });
      return res.status(200).json({
        message: 'Updated  successfully!',
      });
    } else {
      return res.status(400).json({ messaeg: 'File not found!' });
    }
  } catch (err) {
    console.log('Error', err);
    return res
      .status(500)
      .json({ message: 'Internal server error ', error: err });
  }
};

export { updateFile };
